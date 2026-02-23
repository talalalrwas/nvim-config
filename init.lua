vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.signcolumn = "yes"
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.swapfile = false
vim.o.winborder = "rounded"
vim.g.mapleader = ' '
vim.o.termguicolors = true

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')

vim.keymap.set('n', '<leader>cs', ':noh<CR>')

vim.keymap.set('n', '<leader>t', ':vsplit | terminal<CR>i')

vim.keymap.set('n', '<leader>bn', ':bn<CR>')
vim.keymap.set('n', '<leader>bp', ':bp<CR>')
vim.keymap.set('n', '<leader>bd', ':bd<CR>')

vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })


vim.pack.add({
    { src = "https://github.com/tomasiser/vim-code-dark" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/numToStr/Comment.nvim" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/saadparwaiz1/cmp_luasnip" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-path" },
})

require('Comment').setup()

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})
vim.cmd("set completeopt+=noselect")

require "mini.pick".setup()
vim.keymap.set('n', '<leader>f', ":Pick files<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")

require "oil".setup({
    view_options = {
        show_hidden = true,
    },
})
vim.keymap.set('n', '<leader>e', ":Oil<CR>")

vim.lsp.enable({ "lua_ls", "bashls", "pyright", "ts_ls", "html", "cssls", "clangd", "roslyn_ls", "dartls", })

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            }
        }
    }
})

vim.lsp.config("clangd", {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=never",
    },
    init_options = {
        clangdFileStatus = true
    }
})

vim.lsp.config("roslyn_ls", {
    cmd = {
        'dotnet',
        '/home/tgol/.local/microsoft.codeanalysis.languageserver.linux-x64.5.0.0-1.25277.114/content/LanguageServer/linux-x64/Microsoft.CodeAnalysis.LanguageServer.dll',
        '--logLevel',              -- this property is required by the server
        'Information',
        '--extensionLogDirectory', -- this property is required by the server
        vim.fs.joinpath(vim.uv.os_tmpdir(), 'roslyn_ls/logs'),
        '--stdio',
    },
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp' },
    callback = function()
        vim.keymap.set('n', '<leader>m', ':!make -j4<CR>', { buffer = true })
        vim.keymap.set('n', '<leader>r', ':!../%<<CR>', { buffer = true })
    end
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'cs' },
    callback = function()
        vim.keymap.set('n', '<leader>r', ':!dotnet run<CR>', { buffer = true })
    end
})


local cmp = require('cmp')
local luasnip = require('luasnip')

require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = "luasnip" },
        { name = 'buffer' },
        { name = 'path' },
    },
    mapping =
        cmp.mapping.preset.insert({
            ['<CR>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    if luasnip.expandable() then
                        luasnip.expand()
                    else
                        cmp.confirm({
                            select = true,
                        })
                    end
                else
                    fallback()
                end
            end),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),

        }
        )
})

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>p', vim.lsp.buf.hover)

vim.cmd("colorscheme codedark")

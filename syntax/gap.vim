" Vim syntax file
" Language:	GAP
" Author:  Frank Lübeck,  highlighting based on file by Alexander Hulpke
" Maintainer:	Frank Lübeck
" Last change:	Updated May 2012, by William E. Skeith III
"
" Comments: If you want to use this file, you may want to adjust colors to
" your taste. There are some functions/macros for
" GAPnl                -- newline, with reindenting the old line
"                         (mapped on <CTRL>-j)
" ToggleCommentGAP     -- toggle comment, add or remove "##  "
"                         (mapped on F12)
" <F4>                 -- macro to add word under cursor to `local' list
" GAPlocal             -- add whole `local' declaration to current function
"                         (mapped on <F5>)
" Then the completion mechanism <CTRL>-p is extended to complete all

" Please, send comments and suggestions to:  Frank.Luebeck@Math.RWTH-Aachen.De

" Remove any old syntax stuff hanging around
if version < 600
		syntax clear
elseif exists("b:current_syntax")
		finish
endif

" comments
syn match gapComment "\(#.*\)*" contains=gapTodo,gapFunLine,gapNote

" strings and characters
syn region gapString  start=+"+ end=+\([^\\]\|^\)\(\\\\\)*"+
syn match  gapString  +"\(\\\\\)*"+
syn match gapChar +'\\\=.'+
syn match gapChar +'\\"'+

" must do
syn keyword gapTodo TODO contained
syn keyword gapTodo XXX contained

" Notes, Remarks, etc:
syn match gapNote '#\s*\u\w*:'hs=s+1,he=e-1 contained contains=gapTodo

" basic infos in file and folded lines
syn match gapFunLine '^#[FVOMPCAW] .*$' contained

syn keyword gapDeclare	DeclareOperation DeclareGlobalFunction
syn keyword gapDeclare  DeclareGlobalVariable
syn keyword gapDeclare	DeclareAttribute DeclareProperty
syn keyword gapDeclare	DeclareCategory DeclareFilter DeclareCategoryFamily
syn keyword gapDeclare	DeclareRepresentation DeclareInfoClass
syn keyword gapDeclare	DeclareCategoryCollections DeclareSynonym
" the CHEVIE utils
syn keyword gapDeclare  MakeProperty MakeAttribute MakeOperation
syn keyword gapDeclare  MakeGlobalVariable MakeGlobalFunction

syn keyword gapMethsel	InstallMethod InstallOtherMethod NewType Objectify
syn keyword gapMethsel	NewFamily InstallTrueMethod
syn keyword gapMethsel  InstallGlobalFunction ObjectifyWithAttributes
syn keyword gapMethsel  BindGlobal BIND_GLOBAL InstallValue
" CHEVIE util
syn keyword gapMethsel  NewMethod

syn keyword gapOperator	and div in mod not or

syn keyword gapFunction	function -> return local end Error
syn keyword gapConditional	if else elif then fi
syn keyword gapRepeat		do od for while repeat until
syn keyword gapOtherKey         Info Unbind IsBound

syn keyword gapBool         true false fail
syn match  gapNumber		"-\=\<\d\+\>"
syn match  gapListDelimiter	"[][]"
syn match  gapParentheses	"[)(]"
syn match  gapSublist	"[}{]"

"hilite
hi def link gapString String
hi def link gapFunction  Underlined
hi def link gapDeclare  Underlined
hi def link gapMethsel  PreProc
hi def link gapOtherKey  Function
hi def link gapOperator Operator
hi def link gapConditional Statement
hi def link gapRepeat Statement
hi def link gapComment Comment
hi def link gapTodo  Todo
hi def link gapNote  PreProc
" hi link gapTTodoComment  gapTodo
" hi link gapTodoComment	gapComment
hi def link gapNumber Constant
hi def link gapBool Constant
hi def link gapChar Constant
hi def link gapListDelimiter Delimiter
hi def link gapParentheses Delimiter
hi def link gapSublist PreProc
hi def link gapFunLine Type

" TODO: The below list is probably not exhaustive.  Look through the
" docs and get the complete list.
syn match	gapOper	"\(:=\|!=\|>=\|<=\|>\|<\|=\|!\.\|\.\.\)"

syn match    gCustomFunc     "\w\+\s*(" contains=gapParentheses
hi def link gCustomFunc Function
hi def link gapOper Type

" modify some of the standard attributes:
hi Statement gui=bold cterm=bold
hi def link Operator Statement
hi PreProc gui=bold cterm=bold
hi Underlined gui=bold cterm=bold

syn sync maxlines=500

" an ex function which returns a `fold level' for line n of the current
" buffer (only used with folding in vim >= 6.0)
func! GAPFoldLevel(n)
  " none at top of file
  if (a:n==0)
    return 0
  endif
  let l = getline(a:n)
  let lb = getline(a:n-1)
  " GAPDoc in comment is level 1
  if (l =~ "^##.*<#GAPDoc")
    return 1
  endif
  if (lb =~ "^##.*<#/GAPDoc")
    return 0
  endif
  " recurse inside comment
  if (l =~ "^#" && lb =~ "^#")
    return GAPFoldLevel(a:n-1)
  endif
  " in code one level per 4 blanks indent
  " from previous non-blank line
  let n = a:n
  while (n>1 && getline(n) =~ '^\s*$')
    let n = n - 1
  endwhile
  return (indent(n)+3)/4
endfunc

" enable folding and much better indenting in  vim >= 6.0
if version>=600
  syn sync fromstart
  set foldmethod=expr
  set foldminlines=3
  set foldexpr=GAPFoldLevel(v:lnum)
  " load the indent file
  " I don't think you need to source the indent file if it is already in the
  " indent directory
  "runtime indent/gap.vim
endif

let b:current_syntax = "gap"




" vim:sw=4:ff=unix:ft=vim


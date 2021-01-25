Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8878230291A
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 18:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731149AbhAYRip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 12:38:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730605AbhAYRiB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 12:38:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A50222583;
        Mon, 25 Jan 2021 17:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611596234;
        bh=6sAHpexwV3E1wMY3f2ODMH4HeE/GvpgftiTgGfYZgOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iFHm38L+28trlPkwfAFWJs0EJXo1UIstTLOJZ1R57Lbh1b4bFCQhMFWqEKq1NW9m4
         e0tYmtMPbc07uh79aMLuHGJHM+gWT4AOMGvmz1tPnesZjT68R9c8/Lppu0dSOT/Hpg
         toG/Wu0tXExkaz54gha7mgahhCJ6vqZ2CBDVKZqjLgTUEGe0wrgzNW5pd8oBDVfHgG
         xEvO4GX2Z3xuewhq8fEBKjih/OQuCXFAfcg2dlCMQZO66ezfsS8O4YJXpxBk0W5w1V
         YgQpRYBBRpG/diUUeh7b/uRLDevuPijqB5tMcGQ/oofpKyG5uOHKH1OHgh5Wu2gyZH
         IZ7Wgifj8IjFg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 983E740513; Mon, 25 Jan 2021 14:37:11 -0300 (-03)
Date:   Mon, 25 Jan 2021 14:37:11 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Subject: Re: [PATCH 2/2] bpf_encoder: Translate SHN_XINDEX in symbol's
 st_shndx values
Message-ID: <20210125173711.GE617095@kernel.org>
References: <20210122163920.59177-1-jolsa@kernel.org>
 <20210122163920.59177-3-jolsa@kernel.org>
 <CAEf4BzbC-s=27vmcJ1KYLVKgGbns2py1bHny3Q_yr4v3Oe49RQ@mail.gmail.com>
 <20210122203748.GA70760@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122203748.GA70760@krava>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Jan 22, 2021 at 09:37:48PM +0100, Jiri Olsa escreveu:
> On Fri, Jan 22, 2021 at 12:16:42PM -0800, Andrii Nakryiko wrote:
> > On Fri, Jan 22, 2021 at 8:46 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > For very large ELF objects (with many sections), we could
> > > get special value SHN_XINDEX (65535) for symbol's st_shndx.
> > >
> > > This patch is adding code to detect the optional extended
> > > section index table and use it to resolve symbol's section
> > > index.
> > >
> > > Adding elf_symtab__for_each_symbol_index macro that returns
> > > symbol's section index and usign it in collect functions.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  btf_encoder.c | 59 +++++++++++++++++++++++++++++++++++++--------------
> > >  elf_symtab.c  | 39 +++++++++++++++++++++++++++++++++-
> > >  elf_symtab.h  |  2 ++
> > >  3 files changed, 83 insertions(+), 17 deletions(-)
> > >
> > > diff --git a/btf_encoder.c b/btf_encoder.c
> > > index 5557c9efd365..56ee55965093 100644
> > > --- a/btf_encoder.c
> > > +++ b/btf_encoder.c
> > > @@ -63,13 +63,13 @@ static void delete_functions(void)
> > >  #define max(x, y) ((x) < (y) ? (y) : (x))
> > >  #endif
> > >
> > > -static int collect_function(struct btf_elf *btfe, GElf_Sym *sym)
> > > +static int collect_function(struct btf_elf *btfe, GElf_Sym *sym,
> > > +                           Elf32_Word sym_sec_idx)
> > 
> > nit: we use size_t or int for this, no need for libelf types here, imo
> 
> ok

I think it is because this patch ends up calling 

extern GElf_Sym *gelf_getsymshndx (Elf_Data *__symdata, Elf_Data *__shndxdata,
                                   int __ndx, GElf_Sym *__sym,
                                   Elf32_Word *__xshndx);

Which expects a pointer to a Elf32_Word, right Jiri?

Jiri, are you going to submit a new version of this patch? I processed
the first one, collecting Andrii's Acked-by, if you're busy I can try to
address the other concerns from Andrii, please let me know.

- Arnaldo
 
> > 
> > 
> > 
> > >  {
> > >         struct elf_function *new;
> > >         static GElf_Shdr sh;
> > > -       static int last_idx;
> > > +       static Elf32_Word last_idx;
> > >         const char *name;
> > > -       int idx;
> > >
> > >         if (elf_sym__type(sym) != STT_FUNC)
> > >                 return 0;
> > > @@ -90,12 +90,10 @@ static int collect_function(struct btf_elf *btfe, GElf_Sym *sym)
> > >                 functions = new;
> > >         }
> > >
> > > -       idx = elf_sym__section(sym);
> > > -
> > > -       if (idx != last_idx) {
> > > -               if (!elf_section_by_idx(btfe->elf, &sh, idx))
> > > +       if (sym_sec_idx != last_idx) {
> > > +               if (!elf_section_by_idx(btfe->elf, &sh, sym_sec_idx))
> > >                         return 0;
> > > -               last_idx = idx;
> > > +               last_idx = sym_sec_idx;
> > >         }
> > >
> > >         functions[functions_cnt].name = name;
> > > @@ -542,14 +540,15 @@ static bool percpu_var_exists(uint64_t addr, uint32_t *sz, const char **name)
> > >         return true;
> > >  }
> > >
> > > -static int collect_percpu_var(struct btf_elf *btfe, GElf_Sym *sym)
> > > +static int collect_percpu_var(struct btf_elf *btfe, GElf_Sym *sym,
> > > +                             Elf32_Word sym_sec_idx)
> > 
> > nit: same, size_t or just int would be fine
> > 
> > >  {
> > >         const char *sym_name;
> > >         uint64_t addr;
> > >         uint32_t size;
> > >
> > >         /* compare a symbol's shndx to determine if it's a percpu variable */
> > > -       if (elf_sym__section(sym) != btfe->percpu_shndx)
> > > +       if (sym_sec_idx != btfe->percpu_shndx)
> > >                 return 0;
> > >         if (elf_sym__type(sym) != STT_OBJECT)
> > >                 return 0;
> > > @@ -585,12 +584,13 @@ static int collect_percpu_var(struct btf_elf *btfe, GElf_Sym *sym)
> > >         return 0;
> > >  }
> > >
> > > -static void collect_symbol(GElf_Sym *sym, struct funcs_layout *fl)
> > > +static void collect_symbol(GElf_Sym *sym, struct funcs_layout *fl,
> > > +                          Elf32_Word sym_sec_idx)
> > >  {
> > >         if (!fl->mcount_start &&
> > >             !strcmp("__start_mcount_loc", elf_sym__name(sym, btfe->symtab))) {
> > >                 fl->mcount_start = sym->st_value;
> > > -               fl->mcount_sec_idx = sym->st_shndx;
> > > +               fl->mcount_sec_idx = sym_sec_idx;
> > >         }
> > >
> > >         if (!fl->mcount_stop &&
> > > @@ -598,9 +598,36 @@ static void collect_symbol(GElf_Sym *sym, struct funcs_layout *fl)
> > >                 fl->mcount_stop = sym->st_value;
> > >  }
> > >
> > > +static bool elf_sym__get(Elf_Data *syms, Elf_Data *syms_sec_idx_table,
> > > +                        int id, GElf_Sym *sym, Elf32_Word *sym_sec_idx)
> > 
> > This is a generic function, why don't you want to move it into elf_symtab.h?
> > 
> > > +{
> > > +       if (!gelf_getsym(syms, id, sym))
> > > +               return false;
> > > +
> > > +       *sym_sec_idx = sym->st_shndx;
> > > +
> > > +       if (sym->st_shndx == SHN_XINDEX) {
> > > +               if (!syms_sec_idx_table)
> > > +                       return false;
> > > +               if (!gelf_getsymshndx(syms, syms_sec_idx_table,
> > > +                                     id, sym, sym_sec_idx))
> > > +                       return false;
> > 
> > You also ignored my feedback about not fetching symbol twice. Why?
> 
> ugh, I did not read your last 2 comments.. let me check that, sry
> 
> > 
> > > +       }
> > > +
> > > +       return true;
> > > +}
> > > +
> > > +#define elf_symtab__for_each_symbol_index(symtab, id, sym, sym_sec_idx)                \
> > > +       for (id = 0;                                                            \
> > > +            id < symtab->nr_syms &&                                            \
> > > +            elf_sym__get(symtab->syms, symtab->syms_sec_idx_table,             \
> > > +                         id, &sym, &sym_sec_idx);                              \
> > > +            id++)
> > 
> > This should be in elf_symtab.h next to elf_symtab__for_each_symbol.
> > 
> > And thinking a bit more, the variant with just ignoring symbols that
> > we failed to get is probably a safer alternative. I.e., currently
> > there is no way to communicate that we terminated iteration with
> > error, so it's probably better to skip failed symbols and still get
> > the rest, no? I was hoping to discuss stuff like this on the previous
> > version of the patch...
> 
> I was thinking of that, but then I thought it's better to fail,
> than have possibly wrong data in BTF, because the ELF data is
> possibly damaged? no idea.. so I took the safer way
> 
> jirka
> 

-- 

- Arnaldo

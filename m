Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EE429DD16
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731787AbgJ1WTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:19:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731774AbgJ1WRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:45 -0400
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFAE824170;
        Wed, 28 Oct 2020 06:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603868400;
        bh=iyMPTZ3GxyHvk1KlwYCEmQBg3X4EoRIw9xSI5rtwW64=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oQS18L4xAGewXXbzKl4vYYSzrEadw2LOoltBGf+t6E7DPdQzRlFbFoSDLEtk3fzdu
         vC3O1vQZ9uleugiVTIlaYclflyNXO9oDoI1ja157Ft68sqTtzbcO5vRFaUcHTDjO69
         GCs1v7KNyAKnWkR+MCz/7d4ZZlw25T1/d9JAb1bY=
Received: by mail-oi1-f170.google.com with SMTP id j7so3949779oie.12;
        Tue, 27 Oct 2020 23:59:59 -0700 (PDT)
X-Gm-Message-State: AOAM531k5AVZ/MNM/OBRFEoojWiNRKQ0TJvljwyXtmoj2YSo1NVXcC2e
        7NLnvun+zt9y6UQWWra10w3rm6FmUVWPPwZ8o68=
X-Google-Smtp-Source: ABdhPJzkWslzr5KVOXdJabALKtzPnsyIL25Pb4KZLkMHwGbfvsfx1D8rrAo8DJg62nRjlh1TWDmt9wyz36AN4RuspQ0=
X-Received: by 2002:aca:d64f:: with SMTP id n76mr4474933oig.174.1603868399031;
 Tue, 27 Oct 2020 23:59:59 -0700 (PDT)
MIME-Version: 1.0
References: <20201027205723.12514-1-ardb@kernel.org> <72f0dd64-9f65-cbd0-873a-684540912847@iogearbox.net>
 <CAMj1kXG=B-2BAwj1HmMjQpdL5N0WUaoMXGrH_DXvkEZ6gyndaQ@mail.gmail.com>
In-Reply-To: <CAMj1kXG=B-2BAwj1HmMjQpdL5N0WUaoMXGrH_DXvkEZ6gyndaQ@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 28 Oct 2020 07:59:48 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGiot6JKtmfCkphPvMcpckq-CiUSZGnmdXdsnhWd5NW-g@mail.gmail.com>
Message-ID: <CAMj1kXGiot6JKtmfCkphPvMcpckq-CiUSZGnmdXdsnhWd5NW-g@mail.gmail.com>
Subject: Re: [PATCH] bpf: don't rely on GCC __attribute__((optimize)) to
 disable GCSE
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 at 07:51, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Wed, 28 Oct 2020 at 00:04, Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 10/27/20 9:57 PM, Ard Biesheuvel wrote:
> > > Commit 3193c0836f203 ("bpf: Disable GCC -fgcse optimization for
> > > ___bpf_prog_run()") introduced a __no_fgcse macro that expands to a
> > > function scope __attribute__((optimize("-fno-gcse"))), to disable a
> > > GCC specific optimization that was causing trouble on x86 builds, and
> > > was not expected to have any positive effect in the first place.
> > >
> > > However, as the GCC manual documents, __attribute__((optimize))
> > > is not for production use, and results in all other optimization
> > > options to be forgotten for the function in question. This can
> > > cause all kinds of trouble, but in one particular reported case,
> >
> > Looks like there are couple more as well aside from __no_fgcse, are you
> > also planning to fix them?
> >
> >    arch/powerpc/kernel/setup.h:14:#define __nostackprotector __attribute__((__optimize__("no-stack-protector")))
> >    tools/include/linux/compiler-gcc.h:37:#define __no_tail_call __attribute__((optimize("no-optimize-sibling-calls")))
> >
>
> No, but we can notify the respective maintainers.
>
> > > it causes -fno-asynchronous-unwind-tables to be disregarded,
> > > resulting in .eh_frame info to be emitted for the function
> > > inadvertently.
> >
> > Would have been useful to add a pointer to the original discussion with
> > Link tag.
> >
> > Link: https://lore.kernel.org/lkml/CAMuHMdUg0WJHEcq6to0-eODpXPOywLot6UD2=GFHpzoj_hCoBQ@mail.gmail.com/
> >
>
> Agreed.
>
> > > This reverts commit 3193c0836f203, and instead, it disables the -fgcse
> > > optimization for the entire source file, but only when building for
> > > X86.
> > >
> > > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > > Cc: Arvind Sankar <nivedita@alum.mit.edu>
> > > Cc: Randy Dunlap <rdunlap@infradead.org>
> > > Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Alexei Starovoitov <ast@kernel.org>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Fixes: 3193c0836f203 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > [...]
> > > diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> > > index bdc8cd1b6767..02b58f44c479 100644
> > > --- a/kernel/bpf/Makefile
> > > +++ b/kernel/bpf/Makefile
> > > @@ -1,6 +1,8 @@
> > >   # SPDX-License-Identifier: GPL-2.0
> > >   obj-y := core.o
> > > -CFLAGS_core.o += $(call cc-disable-warning, override-init)
> > > +# ___bpf_prog_run() needs GCSE disabled on x86; see 3193c0836f203 for details
> > > +cflags-core-$(CONFIG_X86) := -fno-gcse
> > > +CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-core-y)
> >
> > Also, this needs to be guarded behind !CONFIG_RETPOLINE and !CONFIG_BPF_JIT_ALWAYS_ON
> > in particular the latter since only in this case interpreter is compiled in ... most
> > distros have the CONFIG_BPF_JIT_ALWAYS_ON set these days for x86.
> >
>
> Is that a new requirement? Because before this patch, -fno-gcse was
> applied unconditionally.
>

Ah never mind. You are saying ___bpf_prog_run() does not even exist if
CONFIG_BPF_JIT_ALWAYS_ON=y, right?


> > Do you have an analysis for the commit log on what else this penalizes in core.c if
> > it's now for the entire translation unit?
> >
>
> No, I simply observed the regression this caused on non-x86
> architectures, and proposed a way to fix it.
>
> Do you have any concerns in particular regarding other things in
> core.c? Would you prefer ___bpf_prog_run() to be moved into a separate
> .c file?
>
>
> > >   obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
> > >   obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
> > > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > > index 9268d77898b7..55454d2278b1 100644
> > > --- a/kernel/bpf/core.c
> > > +++ b/kernel/bpf/core.c
> > > @@ -1369,7 +1369,7 @@ u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
> > >    *
> > >    * Decode and execute eBPF instructions.
> > >    */
> > > -static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> > > +static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> > >   {
> > >   #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
> > >   #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
> > >
> >

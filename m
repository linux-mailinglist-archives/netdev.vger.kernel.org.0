Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732DA29DF44
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgJ2BAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 21:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731537AbgJ1WR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:28 -0400
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2607724179;
        Wed, 28 Oct 2020 06:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603867920;
        bh=WgbuHj01IFnS0Vj48OP8wcJkPWzOiL5aoOn7vv03c4g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NNPg4GyiaHS1i8YK/6d3Ckx2fUsPyrZolq6BMElDKh7cfUVDosbIfW12QK+vL+3Kd
         90FAjPPv8CPN34Y3SeKxY2aVd6D401txJox5nWy0s9v4LQw9oZxF+IfPGDLt/Bay4+
         AyYYXe5PX3WYPdt0X23xtq825ajjbyl79Fcus1aM=
Received: by mail-oi1-f175.google.com with SMTP id w191so3973402oif.2;
        Tue, 27 Oct 2020 23:52:00 -0700 (PDT)
X-Gm-Message-State: AOAM533YKS/WyiUjXcVLHyXR1N37RwJoMua/A4hLKMkR2t7ASPACcoud
        A6HYGkJtYxyCgtPkwDREsi55ZfE7ZswPqRRPt80=
X-Google-Smtp-Source: ABdhPJx18X7t9J9cXdTUMq84QR/n+hVe8dOJJQwyEFKevqTuSiKhUkSBkkuw1zKDDRcq6nyTSf58ymou8trpmtyBC9s=
X-Received: by 2002:aca:5c82:: with SMTP id q124mr4120751oib.33.1603867919159;
 Tue, 27 Oct 2020 23:51:59 -0700 (PDT)
MIME-Version: 1.0
References: <20201027205723.12514-1-ardb@kernel.org> <72f0dd64-9f65-cbd0-873a-684540912847@iogearbox.net>
In-Reply-To: <72f0dd64-9f65-cbd0-873a-684540912847@iogearbox.net>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 28 Oct 2020 07:51:47 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG=B-2BAwj1HmMjQpdL5N0WUaoMXGrH_DXvkEZ6gyndaQ@mail.gmail.com>
Message-ID: <CAMj1kXG=B-2BAwj1HmMjQpdL5N0WUaoMXGrH_DXvkEZ6gyndaQ@mail.gmail.com>
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

On Wed, 28 Oct 2020 at 00:04, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 10/27/20 9:57 PM, Ard Biesheuvel wrote:
> > Commit 3193c0836f203 ("bpf: Disable GCC -fgcse optimization for
> > ___bpf_prog_run()") introduced a __no_fgcse macro that expands to a
> > function scope __attribute__((optimize("-fno-gcse"))), to disable a
> > GCC specific optimization that was causing trouble on x86 builds, and
> > was not expected to have any positive effect in the first place.
> >
> > However, as the GCC manual documents, __attribute__((optimize))
> > is not for production use, and results in all other optimization
> > options to be forgotten for the function in question. This can
> > cause all kinds of trouble, but in one particular reported case,
>
> Looks like there are couple more as well aside from __no_fgcse, are you
> also planning to fix them?
>
>    arch/powerpc/kernel/setup.h:14:#define __nostackprotector __attribute__((__optimize__("no-stack-protector")))
>    tools/include/linux/compiler-gcc.h:37:#define __no_tail_call __attribute__((optimize("no-optimize-sibling-calls")))
>

No, but we can notify the respective maintainers.

> > it causes -fno-asynchronous-unwind-tables to be disregarded,
> > resulting in .eh_frame info to be emitted for the function
> > inadvertently.
>
> Would have been useful to add a pointer to the original discussion with
> Link tag.
>
> Link: https://lore.kernel.org/lkml/CAMuHMdUg0WJHEcq6to0-eODpXPOywLot6UD2=GFHpzoj_hCoBQ@mail.gmail.com/
>

Agreed.

> > This reverts commit 3193c0836f203, and instead, it disables the -fgcse
> > optimization for the entire source file, but only when building for
> > X86.
> >
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: Arvind Sankar <nivedita@alum.mit.edu>
> > Cc: Randy Dunlap <rdunlap@infradead.org>
> > Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Fixes: 3193c0836f203 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> [...]
> > diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> > index bdc8cd1b6767..02b58f44c479 100644
> > --- a/kernel/bpf/Makefile
> > +++ b/kernel/bpf/Makefile
> > @@ -1,6 +1,8 @@
> >   # SPDX-License-Identifier: GPL-2.0
> >   obj-y := core.o
> > -CFLAGS_core.o += $(call cc-disable-warning, override-init)
> > +# ___bpf_prog_run() needs GCSE disabled on x86; see 3193c0836f203 for details
> > +cflags-core-$(CONFIG_X86) := -fno-gcse
> > +CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-core-y)
>
> Also, this needs to be guarded behind !CONFIG_RETPOLINE and !CONFIG_BPF_JIT_ALWAYS_ON
> in particular the latter since only in this case interpreter is compiled in ... most
> distros have the CONFIG_BPF_JIT_ALWAYS_ON set these days for x86.
>

Is that a new requirement? Because before this patch, -fno-gcse was
applied unconditionally.

> Do you have an analysis for the commit log on what else this penalizes in core.c if
> it's now for the entire translation unit?
>

No, I simply observed the regression this caused on non-x86
architectures, and proposed a way to fix it.

Do you have any concerns in particular regarding other things in
core.c? Would you prefer ___bpf_prog_run() to be moved into a separate
.c file?


> >   obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
> >   obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 9268d77898b7..55454d2278b1 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -1369,7 +1369,7 @@ u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
> >    *
> >    * Decode and execute eBPF instructions.
> >    */
> > -static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> > +static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> >   {
> >   #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
> >   #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
> >
>

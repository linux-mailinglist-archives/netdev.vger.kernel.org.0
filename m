Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDFB29CB7E
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 22:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374467AbgJ0VuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 17:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505944AbgJ0VuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 17:50:08 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C71D2223C;
        Tue, 27 Oct 2020 21:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603835407;
        bh=qyrHE/X2UJDgA/JFIaVSiVdyn53ug8ZgwnqZeFlYcjo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sCBQ+hb2yT2a/vMKInv34fxKjFlNqRuH1xbNjJTauguMgPgA8tgK5j2Rkq9l9mMEs
         xaHZSgDYlHIIM8C4IwcZ7jt5MaKI3J04aJFSnzhs4jcMBKtKMSBbemcLJaCnfph2ZF
         DlITmUQmkfUvgEieWvpMSGKGF6LjTGRYh3wMrBYA=
Received: by mail-ot1-f43.google.com with SMTP id m22so2510382ots.4;
        Tue, 27 Oct 2020 14:50:07 -0700 (PDT)
X-Gm-Message-State: AOAM531GBRNxBaYqCfH5yNKaGVyz+73CnHte7WPCoc8FZvpCROZQ7FwL
        IWfK9Gl0cF/EVY2SWsRpkU5d6q1QjS65cBMglSg=
X-Google-Smtp-Source: ABdhPJzHekgXLXtoajrpDMpUUyqQH/wvmIgYRBsoBBUPZ4ObqYcRCRWDbwRtmJZ/ohl9Cueb2yI771gfRaYP04oa18E=
X-Received: by 2002:a05:6830:4028:: with SMTP id i8mr2875566ots.90.1603835406737;
 Tue, 27 Oct 2020 14:50:06 -0700 (PDT)
MIME-Version: 1.0
References: <20201027205723.12514-1-ardb@kernel.org> <CAKwvOdmSaVcgq2eKRjRL+_StdFNG2QnNe3nGCs2PWfH=HceadA@mail.gmail.com>
In-Reply-To: <CAKwvOdmSaVcgq2eKRjRL+_StdFNG2QnNe3nGCs2PWfH=HceadA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 27 Oct 2020 22:49:55 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHb8Fe9fqpj4-90ccEMB+NJ6cbuuog-2Vuo7tr7VjZaTA@mail.gmail.com>
Message-ID: <CAMj1kXHb8Fe9fqpj4-90ccEMB+NJ6cbuuog-2Vuo7tr7VjZaTA@mail.gmail.com>
Subject: Re: [PATCH] bpf: don't rely on GCC __attribute__((optimize)) to
 disable GCSE
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 at 22:20, Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Tue, Oct 27, 2020 at 1:57 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
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
> > it causes -fno-asynchronous-unwind-tables to be disregarded,
> > resulting in .eh_frame info to be emitted for the function
> > inadvertently.
> >
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
> > ---
> >  include/linux/compiler-gcc.h   | 2 --
> >  include/linux/compiler_types.h | 4 ----
> >  kernel/bpf/Makefile            | 4 +++-
> >  kernel/bpf/core.c              | 2 +-
> >  4 files changed, 4 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> > index d1e3c6896b71..5deb37024574 100644
> > --- a/include/linux/compiler-gcc.h
> > +++ b/include/linux/compiler-gcc.h
> > @@ -175,5 +175,3 @@
> >  #else
> >  #define __diag_GCC_8(s)
> >  #endif
> > -
> > -#define __no_fgcse __attribute__((optimize("-fno-gcse")))
> > diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> > index 6e390d58a9f8..ac3fa37a84f9 100644
> > --- a/include/linux/compiler_types.h
> > +++ b/include/linux/compiler_types.h
> > @@ -247,10 +247,6 @@ struct ftrace_likely_data {
> >  #define asm_inline asm
> >  #endif
> >
> > -#ifndef __no_fgcse
> > -# define __no_fgcse
> > -#endif
> > -
> >  /* Are two types/vars the same type (ignoring qualifiers)? */
> >  #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
> >
> > diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> > index bdc8cd1b6767..02b58f44c479 100644
> > --- a/kernel/bpf/Makefile
> > +++ b/kernel/bpf/Makefile
> > @@ -1,6 +1,8 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >  obj-y := core.o
> > -CFLAGS_core.o += $(call cc-disable-warning, override-init)
> > +# ___bpf_prog_run() needs GCSE disabled on x86; see 3193c0836f203 for details
> > +cflags-core-$(CONFIG_X86) := -fno-gcse
>
> -fno-gcse is not recognized by clang and will produce
> -Wignored-optimization-argument.  It should at least be wrapped in
> cc-option, though since it's unlikely to ever not be compiler
> specific, I think it might be ok to guard with `ifdef
> CONFIG_CC_IS_GCC`.  Also, might we want to only do this for `ifndef
> CONFIG_RETPOLINE`, based on 3193c0836f203?
>
> Finally, this is going to disable GCSE for the whole translation unit,
> which may be overkill.   Previously it was isolated to one function
> definition.  You could lower the definition of the preprocessor define
> into kernel/bpf/core.c to keep its use isolated as far as possible.
>

Which preprocessor define?

> I'm fine with either approach, but we should avoid new warnings for
> clang.  Thanks for the patch!
>
> > +CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-core-y)
> >
> >  obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
> >  obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 9268d77898b7..55454d2278b1 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -1369,7 +1369,7 @@ u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
> >   *
> >   * Decode and execute eBPF instructions.
> >   */
> > -static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> > +static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> >  {
> >  #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
> >  #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
> > --
> > 2.17.1
> >
>
>
> --
> Thanks,
> ~Nick Desaulniers

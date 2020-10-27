Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1921429CB1A
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 22:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373747AbgJ0VUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 17:20:16 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36638 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504989AbgJ0VUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 17:20:14 -0400
Received: by mail-pg1-f196.google.com with SMTP id z24so1523095pgk.3
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 14:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KiW0Es6GhZG0mD0vaT0CFwu3U3DQdlwHqN8ZFRjOohU=;
        b=OnoFJ4LXia3k2waYWJDZV1WhNFTdh1HpJbZ+YQBNuJXR6UWaBQtQJs016gXMZrLUL4
         jeXFlYBEiJQsj0CoDdF3gLflYJTepQKJW7oMQsE3c7KjZbkwXmtVVwoLv5y6F4Lifw+v
         u+qHc3gWVNlre0nvgEj5IZ85/tRiTy8piIrIPVQr8ucoi0C/7qAZ2F3+wF5aZ0kV0HpS
         XwZL7/JRi3HUgjySOjVrUMob6wDz11/dTXtx4muODCn2lpg4LqVVOAYpPOP8dxXYMBDW
         mnBPDFZAyqxNDTlSlt8eVzLRkuz5+Vlzdw2FHWiOdLJawSjLhXYtAMN9j5LLfQ7/rDyy
         F2ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KiW0Es6GhZG0mD0vaT0CFwu3U3DQdlwHqN8ZFRjOohU=;
        b=UkgC144y4E7Paq89YfGqErtdcYfPMnwYWHrEcYMM3UZFUVbB2kh74VCooOJfOTp6O9
         nYr+07eIUxhWh/PpUtROJVdi2ER5JwRV7QZ/LiqHYKGsUuhazITs6sZrGY3XSKCoCfnl
         P3qcXz6Che+YTq+5HDSTzV/Aod2MKxOG/tKmS5Gh8NBpR3IRBBQdoz8qN0ndqghkP2Hm
         o9eHan5xIhhymMS/NGPj9ZDQsbdKAj3C/azcrsVX+8LG2OGM4hMhX6VzBIV45w2lXVgj
         JWsM7PioEMckGQUtKfPGA3mZQmOzQUl/2GE2TaoSCHfbHmdqvk9LFIJNSU0O3VVDjJ/I
         3zBA==
X-Gm-Message-State: AOAM531B9jf1ffgu7wMCEwm/RAJdFIUWPUMjUU/3o48Rjd7XWVFf5QEv
        q2FcZQEZO4InlEqCjvFGS1L8BA0Pv8pitKyG0ez9IKjJuw+PuA==
X-Google-Smtp-Source: ABdhPJy2bgzhrBS3UAviMtO7C3ycgCdE0U1ri7hFPUBj6N7N+rvohC6x0I9f3zi75CQozxkWmwaHN9K2xUiYtYG1NGg=
X-Received: by 2002:a63:5152:: with SMTP id r18mr3339543pgl.381.1603833611528;
 Tue, 27 Oct 2020 14:20:11 -0700 (PDT)
MIME-Version: 1.0
References: <20201027205723.12514-1-ardb@kernel.org>
In-Reply-To: <20201027205723.12514-1-ardb@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 27 Oct 2020 14:20:00 -0700
Message-ID: <CAKwvOdmSaVcgq2eKRjRL+_StdFNG2QnNe3nGCs2PWfH=HceadA@mail.gmail.com>
Subject: Re: [PATCH] bpf: don't rely on GCC __attribute__((optimize)) to
 disable GCSE
To:     Ard Biesheuvel <ardb@kernel.org>
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

On Tue, Oct 27, 2020 at 1:57 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Commit 3193c0836f203 ("bpf: Disable GCC -fgcse optimization for
> ___bpf_prog_run()") introduced a __no_fgcse macro that expands to a
> function scope __attribute__((optimize("-fno-gcse"))), to disable a
> GCC specific optimization that was causing trouble on x86 builds, and
> was not expected to have any positive effect in the first place.
>
> However, as the GCC manual documents, __attribute__((optimize))
> is not for production use, and results in all other optimization
> options to be forgotten for the function in question. This can
> cause all kinds of trouble, but in one particular reported case,
> it causes -fno-asynchronous-unwind-tables to be disregarded,
> resulting in .eh_frame info to be emitted for the function
> inadvertently.
>
> This reverts commit 3193c0836f203, and instead, it disables the -fgcse
> optimization for the entire source file, but only when building for
> X86.
>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Arvind Sankar <nivedita@alum.mit.edu>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Kees Cook <keescook@chromium.org>
> Fixes: 3193c0836f203 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  include/linux/compiler-gcc.h   | 2 --
>  include/linux/compiler_types.h | 4 ----
>  kernel/bpf/Makefile            | 4 +++-
>  kernel/bpf/core.c              | 2 +-
>  4 files changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index d1e3c6896b71..5deb37024574 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -175,5 +175,3 @@
>  #else
>  #define __diag_GCC_8(s)
>  #endif
> -
> -#define __no_fgcse __attribute__((optimize("-fno-gcse")))
> diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> index 6e390d58a9f8..ac3fa37a84f9 100644
> --- a/include/linux/compiler_types.h
> +++ b/include/linux/compiler_types.h
> @@ -247,10 +247,6 @@ struct ftrace_likely_data {
>  #define asm_inline asm
>  #endif
>
> -#ifndef __no_fgcse
> -# define __no_fgcse
> -#endif
> -
>  /* Are two types/vars the same type (ignoring qualifiers)? */
>  #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
>
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index bdc8cd1b6767..02b58f44c479 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -1,6 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-y := core.o
> -CFLAGS_core.o += $(call cc-disable-warning, override-init)
> +# ___bpf_prog_run() needs GCSE disabled on x86; see 3193c0836f203 for details
> +cflags-core-$(CONFIG_X86) := -fno-gcse

-fno-gcse is not recognized by clang and will produce
-Wignored-optimization-argument.  It should at least be wrapped in
cc-option, though since it's unlikely to ever not be compiler
specific, I think it might be ok to guard with `ifdef
CONFIG_CC_IS_GCC`.  Also, might we want to only do this for `ifndef
CONFIG_RETPOLINE`, based on 3193c0836f203?

Finally, this is going to disable GCSE for the whole translation unit,
which may be overkill.   Previously it was isolated to one function
definition.  You could lower the definition of the preprocessor define
into kernel/bpf/core.c to keep its use isolated as far as possible.

I'm fine with either approach, but we should avoid new warnings for
clang.  Thanks for the patch!

> +CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-core-y)
>
>  obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
>  obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 9268d77898b7..55454d2278b1 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1369,7 +1369,7 @@ u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
>   *
>   * Decode and execute eBPF instructions.
>   */
> -static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> +static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
>  {
>  #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
>  #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
> --
> 2.17.1
>


-- 
Thanks,
~Nick Desaulniers

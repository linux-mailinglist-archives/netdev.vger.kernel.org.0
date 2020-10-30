Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F6929F9C2
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 01:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgJ3Aed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 20:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJ3Aec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 20:34:32 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B9FC0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 17:34:32 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r186so3754300pgr.0
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 17:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5UjLSAh6sChFS0/VCLcCfHwjUGjKGUH8WNbTbx/CRfU=;
        b=c+uPjmFAVU5dIGycTD4zRmGpRN9wqyzmwYP7md0AUCeE8pR4Unx7L7zFp88+F7AO1l
         LLhdnTswYFczWfT2uIbneWs7K6fLLPsOC29KEzOZQTz3YCGNuwvCSx9s99NhK7THV17N
         G0VsGcqBYbRQpWU384hnooUfps0Y5IfyAbNTFyaCtNamFYGUq1JIJbvgT6lRPFRPd5H+
         qIGJvBk01+rEaCzg94FY2z0JMHfrL5E2LWPhIwrnmCZK0bqmXmzDTnivX16ZqoliGtLb
         +Zw1j4z4F7VFyHkQzn3e2awtzAk34wTC1pmIrZWQrstEV9hFquESbnm3YzznGszXxA/m
         3qSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5UjLSAh6sChFS0/VCLcCfHwjUGjKGUH8WNbTbx/CRfU=;
        b=m66tSUFkLdNWNiX8V6Vi5F2anbyyJZH5udxcQpO72iM1/IObSqiGbmy36xV2MajOlS
         f6zD+r81QoVoSOgOUk8UmFYY9YaZ+g2C8RGhVZqptdBSBh8khP0werX8yyIh1i3KZ02G
         sXERouQPqPics/jyyNYy7lZ53i1j0dZBS8HHt6lKnBgkYEzdcSnZKOkUszc6ek+c3XhV
         DTkHH08oqueZ7GV/J79k3pwgX5zHEsikHjNbiNQo8J4viicuBRweuYXMIc5NS1N4PZ4z
         Fgddph0XAhPpWn7b7dmg4TjQO+wI+SCFPat3+gDomZP8kJW5+skKPGaDGolu74OfZZsn
         W2Tw==
X-Gm-Message-State: AOAM53056O+B2IfGoueUn1DbEQwozKhei9M6k7FPQXdzvjWuQc2j0tb9
        E7QQF1ojMLXmdo1nsV2A6DXpeT/Kr1FpmR7n8XIOxQ==
X-Google-Smtp-Source: ABdhPJzhQlPq1XLKfjBZG4pPDCJbGaNIgb7W55xIuARUZBezd9XDmHS2bPm/vkANRENSPfgcfJFP/Wq73SAl7GZxYG8=
X-Received: by 2002:a17:90a:740a:: with SMTP id a10mr2551568pjg.32.1604018071916;
 Thu, 29 Oct 2020 17:34:31 -0700 (PDT)
MIME-Version: 1.0
References: <20201028171506.15682-1-ardb@kernel.org> <20201028171506.15682-2-ardb@kernel.org>
In-Reply-To: <20201028171506.15682-2-ardb@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 29 Oct 2020 17:34:20 -0700
Message-ID: <CAKwvOd=8TVu37rzr84jy5SDBFCqNC3=LCSGpM2bA5=Yc_dgCnA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] bpf: don't rely on GCC __attribute__((optimize))
 to disable GCSE
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

On Wed, Oct 28, 2020 at 10:15 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Commit 3193c0836 ("bpf: Disable GCC -fgcse optimization for
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
> resulting in .eh_frame info to be emitted for the function.
>
> This reverts commit 3193c0836, and instead, it disables the -fgcse
> optimization for the entire source file, but only when building for
> X86 using GCC with CONFIG_BPF_JIT_ALWAYS_ON disabled. Note that the
> original commit states that CONFIG_RETPOLINE=n triggers the issue,
> whereas CONFIG_RETPOLINE=y performs better without the optimization,
> so it is kept disabled in both cases.
>
> Fixes: 3193c0836 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> Link: https://lore.kernel.org/lkml/CAMuHMdUg0WJHEcq6to0-eODpXPOywLot6UD2=GFHpzoj_hCoBQ@mail.gmail.com/
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  include/linux/compiler-gcc.h   | 2 --
>  include/linux/compiler_types.h | 4 ----
>  kernel/bpf/Makefile            | 6 +++++-
>  kernel/bpf/core.c              | 2 +-
>  4 files changed, 6 insertions(+), 8 deletions(-)
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
> index bdc8cd1b6767..c1b9f71ee6aa 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -1,6 +1,10 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-y := core.o
> -CFLAGS_core.o += $(call cc-disable-warning, override-init)
> +ifneq ($(CONFIG_BPF_JIT_ALWAYS_ON),y)
> +# ___bpf_prog_run() needs GCSE disabled on x86; see 3193c0836f203 for details
> +cflags-nogcse-$(CONFIG_X86)$(CONFIG_CC_IS_GCC) := -fno-gcse
> +endif
> +CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)

Writing multiple conditions in a conditional block in GNU make is
painful, hence the double `y` trick.  I feel like either 3 nested
conditionals (one for CONFIG_BPF_JIT_ALWAYS_ON, CONFIG_X86, and
CONFIG_CC_IS_GCC) would have been clearer, or using three `y`, rather
than mixing and matching `if`s with multiple `y`s, but regardless of
what color I think we should paint the bikeshed:

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

This also doesn't resolve all issues here, but is a step in the right
direction, IMO.

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

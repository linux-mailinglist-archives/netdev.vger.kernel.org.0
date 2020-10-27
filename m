Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FDC29CC8B
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 00:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832666AbgJ0XEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 19:04:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:38368 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832658AbgJ0XEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 19:04:32 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kXY0w-0002mG-Dd; Wed, 28 Oct 2020 00:04:26 +0100
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kXY0w-000MGw-4i; Wed, 28 Oct 2020 00:04:26 +0100
Subject: Re: [PATCH] bpf: don't rely on GCC __attribute__((optimize)) to
 disable GCSE
To:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, arnd@arndb.de,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
References: <20201027205723.12514-1-ardb@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <72f0dd64-9f65-cbd0-873a-684540912847@iogearbox.net>
Date:   Wed, 28 Oct 2020 00:04:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201027205723.12514-1-ardb@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25970/Tue Oct 27 13:18:55 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/20 9:57 PM, Ard Biesheuvel wrote:
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

Looks like there are couple more as well aside from __no_fgcse, are you
also planning to fix them?

   arch/powerpc/kernel/setup.h:14:#define __nostackprotector __attribute__((__optimize__("no-stack-protector")))
   tools/include/linux/compiler-gcc.h:37:#define __no_tail_call	__attribute__((optimize("no-optimize-sibling-calls")))

> it causes -fno-asynchronous-unwind-tables to be disregarded,
> resulting in .eh_frame info to be emitted for the function
> inadvertently.

Would have been useful to add a pointer to the original discussion with
Link tag.

Link: https://lore.kernel.org/lkml/CAMuHMdUg0WJHEcq6to0-eODpXPOywLot6UD2=GFHpzoj_hCoBQ@mail.gmail.com/

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
[...]
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index bdc8cd1b6767..02b58f44c479 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -1,6 +1,8 @@
>   # SPDX-License-Identifier: GPL-2.0
>   obj-y := core.o
> -CFLAGS_core.o += $(call cc-disable-warning, override-init)
> +# ___bpf_prog_run() needs GCSE disabled on x86; see 3193c0836f203 for details
> +cflags-core-$(CONFIG_X86) := -fno-gcse
> +CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-core-y)

Also, this needs to be guarded behind !CONFIG_RETPOLINE and !CONFIG_BPF_JIT_ALWAYS_ON
in particular the latter since only in this case interpreter is compiled in ... most
distros have the CONFIG_BPF_JIT_ALWAYS_ON set these days for x86.

Do you have an analysis for the commit log on what else this penalizes in core.c if
it's now for the entire translation unit?

>   obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
>   obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 9268d77898b7..55454d2278b1 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1369,7 +1369,7 @@ u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
>    *
>    * Decode and execute eBPF instructions.
>    */
> -static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> +static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
>   {
>   #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
>   #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
> 


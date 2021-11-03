Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BD1444237
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 14:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhKCNSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 09:18:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:45974 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhKCNSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 09:18:34 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1miG7O-0001o4-J0; Wed, 03 Nov 2021 14:15:54 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1miG7O-000CEp-CU; Wed, 03 Nov 2021 14:15:54 +0100
Subject: Re: [PATCH bpf-next] riscv, bpf: Fix RV32 broken build, and silence
 RV64 warning
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        tongtiangen@huawei.com
Cc:     luke.r.nels@gmail.com, xi.wang@gmail.com,
        linux-riscv@lists.infradead.org
References: <20211103115453.397209-1-bjorn@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f98b15c9-bd06-267e-e404-ae4f607d8740@iogearbox.net>
Date:   Wed, 3 Nov 2021 14:15:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211103115453.397209-1-bjorn@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26342/Wed Nov  3 09:22:37 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/21 12:54 PM, Björn Töpel wrote:
> Commit 252c765bd764 ("riscv, bpf: Add BPF exception tables") only
> addressed RV64, and broke the RV32 build [1]. Fix by gating the exception
> tables code with CONFIG_ARCH_RV64I.
> 
> Further, silence a "-Wmissing-prototypes" warning [2] in the RV64 BPF
> JIT.
> 
> [1] https://lore.kernel.org/llvm/202111020610.9oy9Rr0G-lkp@intel.com/
> [2] https://lore.kernel.org/llvm/202110290334.2zdMyRq4-lkp@intel.com/
> 
> Fixes: 252c765bd764 ("riscv, bpf: Add BPF exception tables")
> Signed-off-by: Björn Töpel <bjorn@kernel.org>
> ---
> Tong/Daniel: The RV32 build has been broken since Thursday. I'll try
> to fast-track a bit, and commit a quick-fix for it. Hope that's OK
> with you, Tong!
> 
> I've verified the build on my machine using riscv32 GCC 9.3.0 and
> riscv64 GCC 11.2.0.

Thanks for the fix Bjorn!

> arch/riscv/mm/extable.c         | 4 ++--
>   arch/riscv/net/bpf_jit_comp64.c | 2 ++
>   2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
> index 18bf338303b6..ddb7d3b99e89 100644
> --- a/arch/riscv/mm/extable.c
> +++ b/arch/riscv/mm/extable.c
> @@ -11,7 +11,7 @@
>   #include <linux/module.h>
>   #include <linux/uaccess.h>
>   
> -#ifdef CONFIG_BPF_JIT
> +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_ARCH_RV64I)
>   int rv_bpf_fixup_exception(const struct exception_table_entry *ex, struct pt_regs *regs);
>   #endif
>   
> @@ -23,7 +23,7 @@ int fixup_exception(struct pt_regs *regs)
>   	if (!fixup)
>   		return 0;
>   
> -#ifdef CONFIG_BPF_JIT
> +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_ARCH_RV64I)
>   	if (regs->epc >= BPF_JIT_REGION_START && regs->epc < BPF_JIT_REGION_END)
>   		return rv_bpf_fixup_exception(fixup, regs);
>   #endif
> diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
> index 2ca345c7b0bf..f2a779c7e225 100644
> --- a/arch/riscv/net/bpf_jit_comp64.c
> +++ b/arch/riscv/net/bpf_jit_comp64.c
> @@ -459,6 +459,8 @@ static int emit_call(bool fixed, u64 addr, struct rv_jit_context *ctx)
>   #define BPF_FIXUP_OFFSET_MASK   GENMASK(26, 0)
>   #define BPF_FIXUP_REG_MASK      GENMASK(31, 27)
>   
> +int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
> +				struct pt_regs *regs);

I'm okay to take this as a quick fix, but if its not too much hassle, could we add a
arch/riscv/include/asm/extable.h in similar fashion like arm64 or x86 where we move
the ex_handler_bpf() signature there, did you have a chance to check?

>   int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
>   				struct pt_regs *regs)
>   {
> 
> base-commit: cc0356d6a02e064387c16a83cb96fe43ef33181e
> 

Thanks,
Daniel

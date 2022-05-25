Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C516533E05
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 15:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244421AbiEYNjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 09:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242683AbiEYNjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 09:39:09 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90DA269713;
        Wed, 25 May 2022 06:39:07 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD38A1FB;
        Wed, 25 May 2022 06:39:06 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.0.228])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CBBCA3F66F;
        Wed, 25 May 2022 06:38:59 -0700 (PDT)
Date:   Wed, 25 May 2022 14:38:55 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        hpa@zytor.com, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        cj.chengjian@huawei.com, huawei.libin@huawei.com,
        xiexiuqi@huawei.com, liwei391@huawei.com
Subject: Re: [PATCH bpf-next v5 1/6] arm64: ftrace: Add ftrace direct call
 support
Message-ID: <Yo4xb2w+FHhUtJNw@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518131638.3401509-2-xukuohai@huawei.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 09:16:33AM -0400, Xu Kuohai wrote:
> Add ftrace direct support for arm64.
> 
> 1. When there is custom trampoline only, replace the fentry nop to a
>    jump instruction that jumps directly to the custom trampoline.
> 
> 2. When ftrace trampoline and custom trampoline coexist, jump from
>    fentry to ftrace trampoline first, then jump to custom trampoline
>    when ftrace trampoline exits. The current unused register
>    pt_regs->orig_x0 is used as an intermediary for jumping from ftrace
>    trampoline to custom trampoline.

For those of us not all that familiar with BPF, can you explain *why* you want
this? The above explains what the patch implements, but not why that's useful.

e.g. is this just to avoid the overhead of the ops list processing in the
regular ftrace code, or is the custom trampoline there to allow you to do
something special?

There is another patch series on the list from some of your colleagues which
uses dynamic trampolines to try to avoid that ops list overhead, and it's not
clear to me whether these are trying to solve the largely same problem or
something different. That other thread is at:

  https://lore.kernel.org/linux-arm-kernel/20220316100132.244849-1-bobo.shaobowang@huawei.com/

... and I've added the relevant parties to CC here, since there doesn't seem to
be any overlap in the CC lists of the two threads.

In that other thread I've suggested a general approach we could follow at:
  
  https://lore.kernel.org/linux-arm-kernel/YmGF%2FOpIhAF8YeVq@lakrids/

As noted in that thread, I have a few concerns which equally apply here:

* Due to the limited range of BL instructions, it's not always possible to
  patch an ftrace call-site to branch to an arbitrary trampoline. The way this
  works for ftrace today relies upon knowingthe set of trampolines at
  compile-time, and allocating module PLTs for those, and that approach cannot
  work reliably for dynanically allocated trampolines.

  I'd strongly prefer to avoid custom tramplines unless they're strictly
  necessary for functional reasons, so that we can have this work reliably and
  consistently.

* If this is mostly about avoiding the ops list processing overhead, I beleive
  we can implement some custom ops support more generally in ftrace which would
  still use a common trampoline but could directly call into those custom ops.
  I would strongly prefer this over custom trampolines.

* I'm looking to minimize the set of regs ftrace saves, and never save a full
  pt_regs, since today we (incompletely) fill that with bogus values and cannot
  acquire some state reliably (e.g. PSTATE). I'd like to avoid usage of pt_regs
  unless necessary, and I don't want to add additional reliance upon that
  structure.

> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> ---
>  arch/arm64/Kconfig               |  2 ++
>  arch/arm64/include/asm/ftrace.h  | 12 ++++++++++++
>  arch/arm64/kernel/asm-offsets.c  |  1 +
>  arch/arm64/kernel/entry-ftrace.S | 18 +++++++++++++++---
>  4 files changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 57c4c995965f..81cc330daafc 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -177,6 +177,8 @@ config ARM64
>  	select HAVE_DYNAMIC_FTRACE
>  	select HAVE_DYNAMIC_FTRACE_WITH_REGS \
>  		if $(cc-option,-fpatchable-function-entry=2)
> +	select HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS \
> +		if DYNAMIC_FTRACE_WITH_REGS
>  	select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY \
>  		if DYNAMIC_FTRACE_WITH_REGS
>  	select HAVE_EFFICIENT_UNALIGNED_ACCESS
> diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
> index 1494cfa8639b..14a35a5df0a1 100644
> --- a/arch/arm64/include/asm/ftrace.h
> +++ b/arch/arm64/include/asm/ftrace.h
> @@ -78,6 +78,18 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
>  	return addr;
>  }
>  
> +#ifdef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> +static inline void arch_ftrace_set_direct_caller(struct pt_regs *regs,
> +						 unsigned long addr)
> +{
> +	/*
> +	 * Place custom trampoline address in regs->orig_x0 to let ftrace
> +	 * trampoline jump to it.
> +	 */
> +	regs->orig_x0 = addr;
> +}
> +#endif /* CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */

Please, let's not abuse pt_regs::orig_x0 for this. That's at best unnecessarily
confusing, and if we really need a field to place a value like this it implies
we should add an ftrace-specific structure to hold the ftrace-specific context
information.

Thanks,
Mark.

> +
>  #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
>  struct dyn_ftrace;
>  int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec);
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 1197e7679882..b1ed0bf01c59 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -80,6 +80,7 @@ int main(void)
>    DEFINE(S_SDEI_TTBR1,		offsetof(struct pt_regs, sdei_ttbr1));
>    DEFINE(S_PMR_SAVE,		offsetof(struct pt_regs, pmr_save));
>    DEFINE(S_STACKFRAME,		offsetof(struct pt_regs, stackframe));
> +  DEFINE(S_ORIG_X0,		offsetof(struct pt_regs, orig_x0));
>    DEFINE(PT_REGS_SIZE,		sizeof(struct pt_regs));
>    BLANK();
>  #ifdef CONFIG_COMPAT
> diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
> index e535480a4069..dfe62c55e3a2 100644
> --- a/arch/arm64/kernel/entry-ftrace.S
> +++ b/arch/arm64/kernel/entry-ftrace.S
> @@ -60,6 +60,9 @@
>  	str	x29, [sp, #S_FP]
>  	.endif
>  
> +	/* Set orig_x0 to zero  */
> +	str     xzr, [sp, #S_ORIG_X0]
> +
>  	/* Save the callsite's SP and LR */
>  	add	x10, sp, #(PT_REGS_SIZE + 16)
>  	stp	x9, x10, [sp, #S_LR]
> @@ -119,12 +122,21 @@ ftrace_common_return:
>  	/* Restore the callsite's FP, LR, PC */
>  	ldr	x29, [sp, #S_FP]
>  	ldr	x30, [sp, #S_LR]
> -	ldr	x9, [sp, #S_PC]
> -
> +	ldr	x10, [sp, #S_PC]
> +
> +	ldr	x11, [sp, #S_ORIG_X0]
> +	cbz	x11, 1f
> +	/* Set x9 to parent ip before jump to custom trampoline */
> +	mov	x9,  x30
> +	/* Set lr to self ip */
> +	ldr	x30, [sp, #S_PC]
> +	/* Set x10 (used for return address) to custom trampoline */
> +	mov	x10, x11
> +1:
>  	/* Restore the callsite's SP */
>  	add	sp, sp, #PT_REGS_SIZE + 16
>  
> -	ret	x9
> +	ret	x10
>  SYM_CODE_END(ftrace_common)
>  
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> -- 
> 2.30.2
> 

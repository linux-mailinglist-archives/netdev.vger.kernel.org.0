Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65EE9533EDB
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 16:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244713AbiEYOKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 10:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244556AbiEYOKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 10:10:41 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07D55A30A3;
        Wed, 25 May 2022 07:10:40 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FEC6106F;
        Wed, 25 May 2022 07:10:39 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.0.228])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56BF23F66F;
        Wed, 25 May 2022 07:10:33 -0700 (PDT)
Date:   Wed, 25 May 2022 15:10:28 +0100
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
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH bpf-next v5 4/6] bpf, arm64: Impelment
 bpf_arch_text_poke() for arm64
Message-ID: <Yo441FR4mXpa2yNx@FVFF77S0Q05N>
References: <20220518131638.3401509-1-xukuohai@huawei.com>
 <20220518131638.3401509-5-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518131638.3401509-5-xukuohai@huawei.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 09:16:36AM -0400, Xu Kuohai wrote:
> Impelment bpf_arch_text_poke() for arm64, so bpf trampoline code can use
> it to replace nop with jump, or replace jump with nop.
> 
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  arch/arm64/net/bpf_jit.h      |   1 +
>  arch/arm64/net/bpf_jit_comp.c | 107 +++++++++++++++++++++++++++++++---
>  2 files changed, 99 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/net/bpf_jit.h b/arch/arm64/net/bpf_jit.h
> index 194c95ccc1cf..1c4b0075a3e2 100644
> --- a/arch/arm64/net/bpf_jit.h
> +++ b/arch/arm64/net/bpf_jit.h
> @@ -270,6 +270,7 @@
>  #define A64_BTI_C  A64_HINT(AARCH64_INSN_HINT_BTIC)
>  #define A64_BTI_J  A64_HINT(AARCH64_INSN_HINT_BTIJ)
>  #define A64_BTI_JC A64_HINT(AARCH64_INSN_HINT_BTIJC)
> +#define A64_NOP    A64_HINT(AARCH64_INSN_HINT_NOP)
>  
>  /* DMB */
>  #define A64_DMB_ISH aarch64_insn_gen_dmb(AARCH64_INSN_MB_ISH)
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index 8ab4035dea27..5ce6ed5f42a1 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -9,6 +9,7 @@
>  
>  #include <linux/bitfield.h>
>  #include <linux/bpf.h>
> +#include <linux/memory.h>
>  #include <linux/filter.h>
>  #include <linux/printk.h>
>  #include <linux/slab.h>
> @@ -18,6 +19,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/debug-monitors.h>
>  #include <asm/insn.h>
> +#include <asm/patching.h>
>  #include <asm/set_memory.h>
>  
>  #include "bpf_jit.h"
> @@ -235,13 +237,13 @@ static bool is_lsi_offset(int offset, int scale)
>  	return true;
>  }
>  
> +#define BTI_INSNS (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) ? 1 : 0)
> +#define PAC_INSNS (IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL) ? 1 : 0)
> +
>  /* Tail call offset to jump into */
> -#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) || \
> -	IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL)
> -#define PROLOGUE_OFFSET 9
> -#else
> -#define PROLOGUE_OFFSET 8
> -#endif
> +#define PROLOGUE_OFFSET	(BTI_INSNS + 2 + PAC_INSNS + 8)
> +/* Offset of nop instruction in bpf prog entry to be poked */
> +#define POKE_OFFSET	(BTI_INSNS + 1)
>  
>  static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
>  {
> @@ -279,12 +281,15 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
>  	 *
>  	 */
>  
> +	if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
> +		emit(A64_BTI_C, ctx);
> +
> +	emit(A64_MOV(1, A64_R(9), A64_LR), ctx);
> +	emit(A64_NOP, ctx);

I take it the idea is to make this the same as the regular ftrace patch-site
sequence, so that this can call the same trampoline(s) ?

If so, we need some commentary to that effect, and we need some comments in the
ftrace code explaining that this needs to be kept in-sync.

> +
>  	/* Sign lr */
>  	if (IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL))
>  		emit(A64_PACIASP, ctx);
> -	/* BTI landing pad */
> -	else if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
> -		emit(A64_BTI_C, ctx);
>  
>  	/* Save FP and LR registers to stay align with ARM64 AAPCS */
>  	emit(A64_PUSH(A64_FP, A64_LR, A64_SP), ctx);
> @@ -1529,3 +1534,87 @@ void bpf_jit_free_exec(void *addr)
>  {
>  	return vfree(addr);
>  }
> +
> +static int gen_branch_or_nop(enum aarch64_insn_branch_type type, void *ip,
> +			     void *addr, u32 *insn)
> +{
> +	if (!addr)
> +		*insn = aarch64_insn_gen_nop();
> +	else
> +		*insn = aarch64_insn_gen_branch_imm((unsigned long)ip,
> +						    (unsigned long)addr,
> +						    type);
> +
> +	return *insn != AARCH64_BREAK_FAULT ? 0 : -EFAULT;
> +}
> +
> +int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
> +		       void *old_addr, void *new_addr)
> +{
> +	int ret;
> +	u32 old_insn;
> +	u32 new_insn;
> +	u32 replaced;
> +	unsigned long offset = ~0UL;
> +	enum aarch64_insn_branch_type branch_type;
> +	char namebuf[KSYM_NAME_LEN];
> +
> +	if (!__bpf_address_lookup((unsigned long)ip, NULL, &offset, namebuf))
> +		/* Only poking bpf text is supported. Since kernel function
> +		 * entry is set up by ftrace, we reply on ftrace to poke kernel
> +		 * functions.
> +		 */
> +		return -EINVAL;
> +
> +	/* bpf entry */
> +	if (offset == 0UL)
> +		/* skip to the nop instruction in bpf prog entry:
> +		 * bti c	// if BTI enabled
> +		 * mov x9, x30
> +		 * nop
> +		 */
> +		ip = ip + POKE_OFFSET * AARCH64_INSN_SIZE;

When is offset non-zero? is this ever called to patch other instructions, and
could this ever be used to try to patch the BTI specifically?

I strongly suspect we need a higher-level API to say "poke the patchable
callsite in the prologue", rather than assuming that offset 0 always means
that, or it'll be *very* easy for this to go wrong.

> +
> +	if (poke_type == BPF_MOD_CALL)
> +		branch_type = AARCH64_INSN_BRANCH_LINK;
> +	else
> +		branch_type = AARCH64_INSN_BRANCH_NOLINK;

When is poke_type *not* BPF_MOD_CALL?

I assume that means BPF also uses this for non-ftrace reasons?

> +	if (gen_branch_or_nop(branch_type, ip, old_addr, &old_insn) < 0)
> +		return -EFAULT;
> +
> +	if (gen_branch_or_nop(branch_type, ip, new_addr, &new_insn) < 0)
> +		return -EFAULT;
> +
> +	mutex_lock(&text_mutex);
> +	if (aarch64_insn_read(ip, &replaced)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (replaced != old_insn) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	/* We call aarch64_insn_patch_text_nosync() to replace instruction
> +	 * atomically, so no other CPUs will fetch a half-new and half-old
> +	 * instruction. But there is chance that another CPU fetches the old
> +	 * instruction after bpf_arch_text_poke() finishes, that is, different
> +	 * CPUs may execute different versions of instructions at the same
> +	 * time before the icache is synchronized by hardware.
> +	 *
> +	 * 1. when a new trampoline is attached, it is not an issue for
> +	 *    different CPUs to jump to different trampolines temporarily.
> +	 *
> +	 * 2. when an old trampoline is freed, we should wait for all other
> +	 *    CPUs to exit the trampoline and make sure the trampoline is no
> +	 *    longer reachable, since bpf_tramp_image_put() function already
> +	 *    uses percpu_ref and rcu task to do the sync, no need to call the
> +	 *    sync interface here.
> +	 */

How is RCU used for that? It's not clear to me how that works for PREEMPT_RCU
(which is the usual configuration for arm64), since we can easily be in a
preemptible context, outside of an RCU read side critical section, yet call
into a trampoline.

I know that for livepatching we need to use stacktracing to ensure we've
finished using code we'd like to free, and I can't immediately see how you can
avoid that here. I'm suspicious that there's still a race where threads can
enter the trampoline and it can be subsequently freed.

For ftrace today we get away with entering the existing trampolines when not
intended because those are statically allocated, and the race is caught when
acquiring the ops inside the ftrace core code. This case is different because
the CPU can fetch the instruction and execute that at any time, without any RCU
involvement.

Can you give more details on how the scheme described above works? How
*exactly*` do you ensure that threads which have entered the trampoline (and
may have been immediately preempted by an interrupt) have returned? Which RCU
mechanism are you using?

If you can point me at where this is implemented I'm happy to take a look.

Thanks,
Mark.

> +	ret = aarch64_insn_patch_text_nosync(ip, new_insn);
> +out:
> +	mutex_unlock(&text_mutex);
> +	return ret;
> +}
> -- 
> 2.30.2
> 

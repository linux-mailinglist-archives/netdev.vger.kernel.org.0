Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F0F527E6C
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 09:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240978AbiEPHTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 03:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240969AbiEPHS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 03:18:59 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64AB813CDD;
        Mon, 16 May 2022 00:18:58 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8CF31063;
        Mon, 16 May 2022 00:18:57 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.2.236])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 028A63F718;
        Mon, 16 May 2022 00:18:51 -0700 (PDT)
Date:   Mon, 16 May 2022 08:18:32 +0100
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
Subject: Re: [PATCH bpf-next v3 4/7] bpf, arm64: Impelment
 bpf_arch_text_poke() for arm64
Message-ID: <YoH6yAtmzPQtWiFM@FVFF77S0Q05N>
References: <20220424154028.1698685-1-xukuohai@huawei.com>
 <20220424154028.1698685-5-xukuohai@huawei.com>
 <Yn5yb9F4uYkio4Xe@lakrids>
 <264ecbe1-4514-d6c8-182b-3af4babb457e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <264ecbe1-4514-d6c8-182b-3af4babb457e@huawei.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 02:55:46PM +0800, Xu Kuohai wrote:
> On 5/13/2022 10:59 PM, Mark Rutland wrote:
> > On Sun, Apr 24, 2022 at 11:40:25AM -0400, Xu Kuohai wrote:
> >> Impelment bpf_arch_text_poke() for arm64, so bpf trampoline code can use
> >> it to replace nop with jump, or replace jump with nop.
> >>
> >> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> >> Acked-by: Song Liu <songliubraving@fb.com>
> >> ---
> >>  arch/arm64/net/bpf_jit_comp.c | 63 +++++++++++++++++++++++++++++++++++
> >>  1 file changed, 63 insertions(+)
> >>
> >> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> >> index 8ab4035dea27..3f9bdfec54c4 100644
> >> --- a/arch/arm64/net/bpf_jit_comp.c
> >> +++ b/arch/arm64/net/bpf_jit_comp.c
> >> @@ -9,6 +9,7 @@
> >>  
> >>  #include <linux/bitfield.h>
> >>  #include <linux/bpf.h>
> >> +#include <linux/memory.h>
> >>  #include <linux/filter.h>
> >>  #include <linux/printk.h>
> >>  #include <linux/slab.h>
> >> @@ -18,6 +19,7 @@
> >>  #include <asm/cacheflush.h>
> >>  #include <asm/debug-monitors.h>
> >>  #include <asm/insn.h>
> >> +#include <asm/patching.h>
> >>  #include <asm/set_memory.h>
> >>  
> >>  #include "bpf_jit.h"
> >> @@ -1529,3 +1531,64 @@ void bpf_jit_free_exec(void *addr)
> >>  {
> >>  	return vfree(addr);
> >>  }
> >> +
> >> +static int gen_branch_or_nop(enum aarch64_insn_branch_type type, void *ip,
> >> +			     void *addr, u32 *insn)
> >> +{
> >> +	if (!addr)
> >> +		*insn = aarch64_insn_gen_nop();
> >> +	else
> >> +		*insn = aarch64_insn_gen_branch_imm((unsigned long)ip,
> >> +						    (unsigned long)addr,
> >> +						    type);
> >> +
> >> +	return *insn != AARCH64_BREAK_FAULT ? 0 : -EFAULT;
> >> +}
> >> +
> >> +int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
> >> +		       void *old_addr, void *new_addr)
> >> +{
> >> +	int ret;
> >> +	u32 old_insn;
> >> +	u32 new_insn;
> >> +	u32 replaced;
> >> +	enum aarch64_insn_branch_type branch_type;
> >> +
> >> +	if (!is_bpf_text_address((long)ip))
> >> +		/* Only poking bpf text is supported. Since kernel function
> >> +		 * entry is set up by ftrace, we reply on ftrace to poke kernel
> >> +		 * functions. For kernel funcitons, bpf_arch_text_poke() is only
> >> +		 * called after a failed poke with ftrace. In this case, there
> >> +		 * is probably something wrong with fentry, so there is nothing
> >> +		 * we can do here. See register_fentry, unregister_fentry and
> >> +		 * modify_fentry for details.
> >> +		 */
> >> +		return -EINVAL;
> > 
> > If you rely on ftrace to poke functions, why do you need to patch text
> > at all? Why does the rest of this function exist?
> > 
> > I really don't like having another piece of code outside of ftrace
> > patching the ftrace patch-site; this needs a much better explanation.
> > 
> 
> Sorry for the incorrect explaination in the comment. I don't think it's
> reasonable to patch ftrace patch-site without ftrace code either.
> 
> The patching logic in register_fentry, unregister_fentry and
> modify_fentry is as follows:
> 
> if (tr->func.ftrace_managed)
>         ret = register_ftrace_direct((long)ip, (long)new_addr);
> else
>         ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr,
>                                  true);
> 
> ftrace patch-site is patched by ftrace code. bpf_arch_text_poke() is
> only used to patch bpf prog and bpf trampoline, which are not managed by
> ftrace.

Sorry, I had misunderstood. Thanks for the correction!

I'll have another look with that in mind.

> >> +
> >> +	if (poke_type == BPF_MOD_CALL)
> >> +		branch_type = AARCH64_INSN_BRANCH_LINK;
> >> +	else
> >> +		branch_type = AARCH64_INSN_BRANCH_NOLINK;
> >> +
> >> +	if (gen_branch_or_nop(branch_type, ip, old_addr, &old_insn) < 0)
> >> +		return -EFAULT;
> >> +
> >> +	if (gen_branch_or_nop(branch_type, ip, new_addr, &new_insn) < 0)
> >> +		return -EFAULT;
> >> +
> >> +	mutex_lock(&text_mutex);
> >> +	if (aarch64_insn_read(ip, &replaced)) {
> >> +		ret = -EFAULT;
> >> +		goto out;
> >> +	}
> >> +
> >> +	if (replaced != old_insn) {
> >> +		ret = -EFAULT;
> >> +		goto out;
> >> +	}
> >> +
> >> +	ret = aarch64_insn_patch_text_nosync((void *)ip, new_insn);
> > 
> > ... and where does the actual synchronization come from in this case?
> 
> aarch64_insn_patch_text_nosync() replaces an instruction atomically, so
> no other CPUs will fetch a half-new and half-old instruction.
> 
> The scenario here is that there is a chance that another CPU fetches the
> old instruction after bpf_arch_text_poke() finishes, that is, different
> CPUs may execute different versions of instructions at the same time.
> 
> 1. When a new trampoline is attached, it doesn't seem to be an issue for
> different CPUs to jump to different trampolines temporarily.
>
> 2. When an old trampoline is freed, we should wait for all other CPUs to
> exit the trampoline and make sure the trampoline is no longer reachable,
> IIUC, bpf_tramp_image_put() function already uses percpu_ref and rcu
> tasks to do this.

It would be good to have a comment for these points.

Thanks,
Mark.

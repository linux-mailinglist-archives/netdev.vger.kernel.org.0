Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913F6534CAB
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 11:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346879AbiEZJpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 05:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbiEZJpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 05:45:10 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8706C1EF9;
        Thu, 26 May 2022 02:45:08 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L830z5Wy3zjX98;
        Thu, 26 May 2022 17:44:03 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 26 May 2022 17:45:03 +0800
Message-ID: <0f8fe661-c450-ccd8-761f-dbfff449c533@huawei.com>
Date:   Thu, 26 May 2022 17:45:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v5 1/6] arm64: ftrace: Add ftrace direct call
 support
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>
CC:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
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
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
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
        <cj.chengjian@huawei.com>, <huawei.libin@huawei.com>,
        <xiexiuqi@huawei.com>, <liwei391@huawei.com>
References: <Yo4xb2w+FHhUtJNw@FVFF77S0Q05N>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <Yo4xb2w+FHhUtJNw@FVFF77S0Q05N>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/25/2022 9:38 PM, Mark Rutland wrote:
> On Wed, May 18, 2022 at 09:16:33AM -0400, Xu Kuohai wrote:
>> Add ftrace direct support for arm64.
>>
>> 1. When there is custom trampoline only, replace the fentry nop to a
>>    jump instruction that jumps directly to the custom trampoline.
>>
>> 2. When ftrace trampoline and custom trampoline coexist, jump from
>>    fentry to ftrace trampoline first, then jump to custom trampoline
>>    when ftrace trampoline exits. The current unused register
>>    pt_regs->orig_x0 is used as an intermediary for jumping from ftrace
>>    trampoline to custom trampoline.
> 
> For those of us not all that familiar with BPF, can you explain *why* you want
> this? The above explains what the patch implements, but not why that's useful.
> 
> e.g. is this just to avoid the overhead of the ops list processing in the
> regular ftrace code, or is the custom trampoline there to allow you to do
> something special?

IIUC, ftrace direct call was designed to *remove* the unnecessary
overhead of saving regs completely [1][2].

[1]
https://lore.kernel.org/all/20191022175052.frjzlnjjfwwfov64@ast-mbp.dhcp.thefacebook.com/
[2] https://lore.kernel.org/all/20191108212834.594904349@goodmis.org/

This patch itself is just a variant of [3].

[3] https://lore.kernel.org/all/20191108213450.891579507@goodmis.org/

> 
> There is another patch series on the list from some of your colleagues which
> uses dynamic trampolines to try to avoid that ops list overhead, and it's not
> clear to me whether these are trying to solve the largely same problem or
> something different. That other thread is at:
> 
>   https://lore.kernel.org/linux-arm-kernel/20220316100132.244849-1-bobo.shaobowang@huawei.com/
> 
> ... and I've added the relevant parties to CC here, since there doesn't seem to
> be any overlap in the CC lists of the two threads.

We're not working to solve the same problem. The trampoline introduced
in this series helps us to monitor kernel function or another bpf prog
with bpf, and also helps us to use bpf prog like a normal kernel
function pointer.

> 
> In that other thread I've suggested a general approach we could follow at:
>   
>   https://lore.kernel.org/linux-arm-kernel/YmGF%2FOpIhAF8YeVq@lakrids/
>

Is it possible for a kernel function to take a long jump to common
trampoline when we get a huge kernel image?

> As noted in that thread, I have a few concerns which equally apply here:
> 
> * Due to the limited range of BL instructions, it's not always possible to
>   patch an ftrace call-site to branch to an arbitrary trampoline. The way this
>   works for ftrace today relies upon knowingthe set of trampolines at
>   compile-time, and allocating module PLTs for those, and that approach cannot
>   work reliably for dynanically allocated trampolines.

Currently patch 5 returns -ENOTSUPP when long jump is detected, so no
bpf trampoline is constructed for out of range patch-site:

if (is_long_jump(orig_call, image))
	return -ENOTSUPP;

> 
>   I'd strongly prefer to avoid custom tramplines unless they're strictly
>   necessary for functional reasons, so that we can have this work reliably and
>   consistently.

bpf trampoline is needed by bpf itself, not to replace ftrace trampolines.

>> * If this is mostly about avoiding the ops list processing overhead, I
beleive
>   we can implement some custom ops support more generally in ftrace which would
>   still use a common trampoline but could directly call into those custom ops.
>   I would strongly prefer this over custom trampolines.
> 
> * I'm looking to minimize the set of regs ftrace saves, and never save a full
>   pt_regs, since today we (incompletely) fill that with bogus values and cannot
>   acquire some state reliably (e.g. PSTATE). I'd like to avoid usage of pt_regs
>   unless necessary, and I don't want to add additional reliance upon that
>   structure.

Even if such a common trampoline is used, bpf trampoline is still
necessary since we need to construct custom instructions to implement
bpf functions, for example, to implement kernel function pointer with a
bpf prog.

> 
>> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
>> Acked-by: Song Liu <songliubraving@fb.com>
>> ---
>>  arch/arm64/Kconfig               |  2 ++
>>  arch/arm64/include/asm/ftrace.h  | 12 ++++++++++++
>>  arch/arm64/kernel/asm-offsets.c  |  1 +
>>  arch/arm64/kernel/entry-ftrace.S | 18 +++++++++++++++---
>>  4 files changed, 30 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 57c4c995965f..81cc330daafc 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -177,6 +177,8 @@ config ARM64
>>  	select HAVE_DYNAMIC_FTRACE
>>  	select HAVE_DYNAMIC_FTRACE_WITH_REGS \
>>  		if $(cc-option,-fpatchable-function-entry=2)
>> +	select HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS \
>> +		if DYNAMIC_FTRACE_WITH_REGS
>>  	select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY \
>>  		if DYNAMIC_FTRACE_WITH_REGS
>>  	select HAVE_EFFICIENT_UNALIGNED_ACCESS
>> diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
>> index 1494cfa8639b..14a35a5df0a1 100644
>> --- a/arch/arm64/include/asm/ftrace.h
>> +++ b/arch/arm64/include/asm/ftrace.h
>> @@ -78,6 +78,18 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
>>  	return addr;
>>  }
>>  
>> +#ifdef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
>> +static inline void arch_ftrace_set_direct_caller(struct pt_regs *regs,
>> +						 unsigned long addr)
>> +{
>> +	/*
>> +	 * Place custom trampoline address in regs->orig_x0 to let ftrace
>> +	 * trampoline jump to it.
>> +	 */
>> +	regs->orig_x0 = addr;
>> +}
>> +#endif /* CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
> 
> Please, let's not abuse pt_regs::orig_x0 for this. That's at best unnecessarily
> confusing, and if we really need a field to place a value like this it implies
> we should add an ftrace-specific structure to hold the ftrace-specific context
> information.
> 

Sorry for this confusion, this was modified in the x86 way:

https://lore.kernel.org/all/20191108213450.891579507@goodmis.org/

> Thanks,
> Mark.
> 
>> +
>>  #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
>>  struct dyn_ftrace;g w
>>  int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec);
>> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
>> index 1197e7679882..b1ed0bf01c59 100644
>> --- a/arch/arm64/kernel/asm-offsets.c
>> +++ b/arch/arm64/kernel/asm-offsets.c
>> @@ -80,6 +80,7 @@ int main(void)
>>    DEFINE(S_SDEI_TTBR1,		offsetof(struct pt_regs, sdei_ttbr1));
>>    DEFINE(S_PMR_SAVE,		offsetof(struct pt_regs, pmr_save));
>>    DEFINE(S_STACKFRAME,		offsetof(struct pt_regs, stackframe));
>> +  DEFINE(S_ORIG_X0,		offsetof(struct pt_regs, orig_x0));
>>    DEFINE(PT_REGS_SIZE,		sizeof(struct pt_regs));
>>    BLANK();
>>  #ifdef CONFIG_COMPAT
>> diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
>> index e535480a4069..dfe62c55e3a2 100644
>> --- a/arch/arm64/kernel/entry-ftrace.S
>> +++ b/arch/arm64/kernel/entry-ftrace.S
>> @@ -60,6 +60,9 @@
>>  	str	x29, [sp, #S_FP]
>>  	.endif
>>  
>> +	/* Set orig_x0 to zero  */
>> +	str     xzr, [sp, #S_ORIG_X0]
>> +
>>  	/* Save the callsite's SP and LR */
>>  	add	x10, sp, #(PT_REGS_SIZE + 16)
>>  	stp	x9, x10, [sp, #S_LR]
>> @@ -119,12 +122,21 @@ ftrace_common_return:
>>  	/* Restore the callsite's FP, LR, PC */
>>  	ldr	x29, [sp, #S_FP]
>>  	ldr	x30, [sp, #S_LR]
>> -	ldr	x9, [sp, #S_PC]
>> -
>> +	ldr	x10, [sp, #S_PC]
>> +
>> +	ldr	x11, [sp, #S_ORIG_X0]
>> +	cbz	x11, 1f
>> +	/* Set x9 to parent ip before jump to custom trampoline */
>> +	mov	x9,  x30
>> +	/* Set lr to self ip */
>> +	ldr	x30, [sp, #S_PC]
>> +	/* Set x10 (used for return address) to custom trampoline */
>> +	mov	x10, x11
>> +1:
>>  	/* Restore the callsite's SP */
>>  	add	sp, sp, #PT_REGS_SIZE + 16
>>  
>> -	ret	x9
>> +	ret	x10
>>  SYM_CODE_END(ftrace_common)
>>  
>>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> -- 
>> 2.30.2
>>
> .


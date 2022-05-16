Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451A5527DF0
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 08:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240788AbiEPG4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 02:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240595AbiEPGzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 02:55:52 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751C5B1D;
        Sun, 15 May 2022 23:55:50 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L1qjw6brpzgYLZ;
        Mon, 16 May 2022 14:54:28 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 16 May 2022 14:55:46 +0800
Message-ID: <264ecbe1-4514-d6c8-182b-3af4babb457e@huawei.com>
Date:   Mon, 16 May 2022 14:55:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v3 4/7] bpf, arm64: Impelment
 bpf_arch_text_poke() for arm64
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
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
References: <20220424154028.1698685-1-xukuohai@huawei.com>
 <20220424154028.1698685-5-xukuohai@huawei.com> <Yn5yb9F4uYkio4Xe@lakrids>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <Yn5yb9F4uYkio4Xe@lakrids>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/2022 10:59 PM, Mark Rutland wrote:
> On Sun, Apr 24, 2022 at 11:40:25AM -0400, Xu Kuohai wrote:
>> Impelment bpf_arch_text_poke() for arm64, so bpf trampoline code can use
>> it to replace nop with jump, or replace jump with nop.
>>
>> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
>> Acked-by: Song Liu <songliubraving@fb.com>
>> ---
>>  arch/arm64/net/bpf_jit_comp.c | 63 +++++++++++++++++++++++++++++++++++
>>  1 file changed, 63 insertions(+)
>>
>> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
>> index 8ab4035dea27..3f9bdfec54c4 100644
>> --- a/arch/arm64/net/bpf_jit_comp.c
>> +++ b/arch/arm64/net/bpf_jit_comp.c
>> @@ -9,6 +9,7 @@
>>  
>>  #include <linux/bitfield.h>
>>  #include <linux/bpf.h>
>> +#include <linux/memory.h>
>>  #include <linux/filter.h>
>>  #include <linux/printk.h>
>>  #include <linux/slab.h>
>> @@ -18,6 +19,7 @@
>>  #include <asm/cacheflush.h>
>>  #include <asm/debug-monitors.h>
>>  #include <asm/insn.h>
>> +#include <asm/patching.h>
>>  #include <asm/set_memory.h>
>>  
>>  #include "bpf_jit.h"
>> @@ -1529,3 +1531,64 @@ void bpf_jit_free_exec(void *addr)
>>  {
>>  	return vfree(addr);
>>  }
>> +
>> +static int gen_branch_or_nop(enum aarch64_insn_branch_type type, void *ip,
>> +			     void *addr, u32 *insn)
>> +{
>> +	if (!addr)
>> +		*insn = aarch64_insn_gen_nop();
>> +	else
>> +		*insn = aarch64_insn_gen_branch_imm((unsigned long)ip,
>> +						    (unsigned long)addr,
>> +						    type);
>> +
>> +	return *insn != AARCH64_BREAK_FAULT ? 0 : -EFAULT;
>> +}
>> +
>> +int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
>> +		       void *old_addr, void *new_addr)
>> +{
>> +	int ret;
>> +	u32 old_insn;
>> +	u32 new_insn;
>> +	u32 replaced;
>> +	enum aarch64_insn_branch_type branch_type;
>> +
>> +	if (!is_bpf_text_address((long)ip))
>> +		/* Only poking bpf text is supported. Since kernel function
>> +		 * entry is set up by ftrace, we reply on ftrace to poke kernel
>> +		 * functions. For kernel funcitons, bpf_arch_text_poke() is only
>> +		 * called after a failed poke with ftrace. In this case, there
>> +		 * is probably something wrong with fentry, so there is nothing
>> +		 * we can do here. See register_fentry, unregister_fentry and
>> +		 * modify_fentry for details.
>> +		 */
>> +		return -EINVAL;
> 
> If you rely on ftrace to poke functions, why do you need to patch text
> at all? Why does the rest of this function exist?
> 
> I really don't like having another piece of code outside of ftrace
> patching the ftrace patch-site; this needs a much better explanation.
> 

Sorry for the incorrect explaination in the comment. I don't think it's
reasonable to patch ftrace patch-site without ftrace code either.

The patching logic in register_fentry, unregister_fentry and
modify_fentry is as follows:

if (tr->func.ftrace_managed)
        ret = register_ftrace_direct((long)ip, (long)new_addr);
else
        ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr,
                                 true);

ftrace patch-site is patched by ftrace code. bpf_arch_text_poke() is
only used to patch bpf prog and bpf trampoline, which are not managed by
ftrace.

>> +
>> +	if (poke_type == BPF_MOD_CALL)
>> +		branch_type = AARCH64_INSN_BRANCH_LINK;
>> +	else
>> +		branch_type = AARCH64_INSN_BRANCH_NOLINK;
>> +
>> +	if (gen_branch_or_nop(branch_type, ip, old_addr, &old_insn) < 0)
>> +		return -EFAULT;
>> +
>> +	if (gen_branch_or_nop(branch_type, ip, new_addr, &new_insn) < 0)
>> +		return -EFAULT;
>> +
>> +	mutex_lock(&text_mutex);
>> +	if (aarch64_insn_read(ip, &replaced)) {
>> +		ret = -EFAULT;
>> +		goto out;
>> +	}
>> +
>> +	if (replaced != old_insn) {
>> +		ret = -EFAULT;
>> +		goto out;
>> +	}
>> +
>> +	ret = aarch64_insn_patch_text_nosync((void *)ip, new_insn);
> 
> ... and where does the actual synchronization come from in this case?
> 

aarch64_insn_patch_text_nosync() replaces an instruction atomically, so
no other CPUs will fetch a half-new and half-old instruction.

The scenario here is that there is a chance that another CPU fetches the
old instruction after bpf_arch_text_poke() finishes, that is, different
CPUs may execute different versions of instructions at the same time.

1. When a new trampoline is attached, it doesn't seem to be an issue for
different CPUs to jump to different trampolines temporarily.

2. When an old trampoline is freed, we should wait for all other CPUs to
exit the trampoline and make sure the trampoline is no longer reachable,
IIUC, bpf_tramp_image_put() function already uses percpu_ref and rcu
tasks to do this.

> Thanks,
> Mark.
> 
>> +out:
>> +	mutex_unlock(&text_mutex);
>> +	return ret;
>> +}
>> -- 
>> 2.30.2
>>
> .


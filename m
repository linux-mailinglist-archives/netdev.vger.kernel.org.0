Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090D95350FF
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 16:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239677AbiEZOsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 10:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347739AbiEZOsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 10:48:12 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC4F5DA47;
        Thu, 26 May 2022 07:48:10 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4L89k32DZnz1JCRq;
        Thu, 26 May 2022 22:46:35 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 26 May 2022 22:48:05 +0800
Message-ID: <40fda0b0-0efc-ea1b-96d5-e51a4d1593dd@huawei.com>
Date:   Thu, 26 May 2022 22:48:05 +0800
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
 <0f8fe661-c450-ccd8-761f-dbfff449c533@huawei.com>
 <Yo9REdx3nsgbZunE@FVFF77S0Q05N>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <Yo9REdx3nsgbZunE@FVFF77S0Q05N>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

On 5/26/2022 6:06 PM, Mark Rutland wrote:
> On Thu, May 26, 2022 at 05:45:03PM +0800, Xu Kuohai wrote:
>> On 5/25/2022 9:38 PM, Mark Rutland wrote:
>>> On Wed, May 18, 2022 at 09:16:33AM -0400, Xu Kuohai wrote:
>>>> Add ftrace direct support for arm64.
>>>>
>>>> 1. When there is custom trampoline only, replace the fentry nop to a
>>>>    jump instruction that jumps directly to the custom trampoline.
>>>>
>>>> 2. When ftrace trampoline and custom trampoline coexist, jump from
>>>>    fentry to ftrace trampoline first, then jump to custom trampoline
>>>>    when ftrace trampoline exits. The current unused register
>>>>    pt_regs->orig_x0 is used as an intermediary for jumping from ftrace
>>>>    trampoline to custom trampoline.
>>>
>>> For those of us not all that familiar with BPF, can you explain *why* you want
>>> this? The above explains what the patch implements, but not why that's useful.
>>>
>>> e.g. is this just to avoid the overhead of the ops list processing in the
>>> regular ftrace code, or is the custom trampoline there to allow you to do
>>> something special?
>>
>> IIUC, ftrace direct call was designed to *remove* the unnecessary
>> overhead of saving regs completely [1][2].
> 
> Ok. My plan is to get rid of most of the register saving generally, so I think
> that aspect can be solved without direct calls.
Looking forward to your new solution.

> 
>> [1]
>> https://lore.kernel.org/all/20191022175052.frjzlnjjfwwfov64@ast-mbp.dhcp.thefacebook.com/
>> [2] https://lore.kernel.org/all/20191108212834.594904349@goodmis.org/
>>
>> This patch itself is just a variant of [3].
>>
>> [3] https://lore.kernel.org/all/20191108213450.891579507@goodmis.org/
>>
>>>
>>> There is another patch series on the list from some of your colleagues which
>>> uses dynamic trampolines to try to avoid that ops list overhead, and it's not
>>> clear to me whether these are trying to solve the largely same problem or
>>> something different. That other thread is at:
>>>
>>>   https://lore.kernel.org/linux-arm-kernel/20220316100132.244849-1-bobo.shaobowang@huawei.com/
>>>
>>> ... and I've added the relevant parties to CC here, since there doesn't seem to
>>> be any overlap in the CC lists of the two threads.
>>
>> We're not working to solve the same problem. The trampoline introduced
>> in this series helps us to monitor kernel function or another bpf prog
>> with bpf, and also helps us to use bpf prog like a normal kernel
>> function pointer.
> 
> Ok, but why is it necessary to have a special trampoline?
> 
> Is that *just* to avoid overhead, or do you need to do something special that
> the regular trampoline won't do?
> 

Sorry for not explaining the problem. The main bpf prog accepts only a
single argument 'ctx' in r1, so to allow kernel code to call bpf prog
transparently, we need a trampoline to convert native calling convention
into BPF calling convention [1].

[1] https://lore.kernel.org/bpf/20191114185720.1641606-5-ast@kernel.org/

For example,

SEC("struct_ops/dctcp_state")
void BPF_PROG(dctcp_state, struct sock *sk, __u8 new_state)
{
    // do something
}

The above bpf prog will be compiled to something like this:

dctcp_state:
    r2 = *(u64 *)(r1 + 8)  // new_state
    r1 = *(u64 *)(r1 + 0)  // sk
    ...

It accepts only one argument 'ctx' in r1, and loads the actual arugment
'sk' and 'new_state' from r1 + 0 and r1 + 8, resepectively. So before
calling this prog, we need to construct 'ctx' and store its address to r1.

>>>
>>> In that other thread I've suggested a general approach we could follow at:
>>>   
>>>   https://lore.kernel.org/linux-arm-kernel/YmGF%2FOpIhAF8YeVq@lakrids/
>>>
>>
>> Is it possible for a kernel function to take a long jump to common
>> trampoline when we get a huge kernel image?
> 
> It is possible, but only where the kernel Image itself is massive and the .text
> section exceeeds 128MiB, at which point other things break anyway. Practically
> speaking, this doesn't happen for production kernels, or reasonable test
> kernels.
> 

So even for normal kernel functions, we need some way to construct and
destruct long jumps atomically and safely.

> I've been meaning to add some logic to detect this at boot time and idsable
> ftrace (or at build time), since live patching would also be broken in that
> case.
>>>> As noted in that thread, I have a few concerns which equally apply here:
>>>
>>> * Due to the limited range of BL instructions, it's not always possible to
>>>   patch an ftrace call-site to branch to an arbitrary trampoline. The way this
>>>   works for ftrace today relies upon knowingthe set of trampolines at
>>>   compile-time, and allocating module PLTs for those, and that approach cannot
>>>   work reliably for dynanically allocated trampolines.
>>
>> Currently patch 5 returns -ENOTSUPP when long jump is detected, so no
>> bpf trampoline is constructed for out of range patch-site:
>>
>> if (is_long_jump(orig_call, image))
>> 	return -ENOTSUPP;
> 
> Sure, my point is that in practice that means that (from the user's PoV) this
> may randomly fail to work, and I'd like something that we can ensure works
> consistently.
> 

OK, should I suspend this work until you finish refactoring ftrace?

>>>   I'd strongly prefer to avoid custom tramplines unless they're strictly
>>>   necessary for functional reasons, so that we can have this work reliably and
>>>   consistently.
>>
>> bpf trampoline is needed by bpf itself, not to replace ftrace trampolines.
> 
> As above, can you please let me know *why* specifically it is needed? Why can't
> we invoke the BPF code through the usual ops mechanism?
> 
> Is that to avoid overhead, or are there other functional reasons you need a
> special trampoline?
> 
>>>> * If this is mostly about avoiding the ops list processing overhead, I
>> beleive
>>>   we can implement some custom ops support more generally in ftrace which would
>>>   still use a common trampoline but could directly call into those custom ops.
>>>   I would strongly prefer this over custom trampolines.
>>>
>>> * I'm looking to minimize the set of regs ftrace saves, and never save a full
>>>   pt_regs, since today we (incompletely) fill that with bogus values and cannot
>>>   acquire some state reliably (e.g. PSTATE). I'd like to avoid usage of pt_regs
>>>   unless necessary, and I don't want to add additional reliance upon that
>>>   structure.
>>
>> Even if such a common trampoline is used, bpf trampoline is still
>> necessary since we need to construct custom instructions to implement
>> bpf functions, for example, to implement kernel function pointer with a
>> bpf prog.
> 
> Sorry, but I'm struggling to understand this. What specifically do you need to
> do that means this can't use the same calling convention as the regular ops
> function pointers?
> > Thanks,
> Mark.
> .



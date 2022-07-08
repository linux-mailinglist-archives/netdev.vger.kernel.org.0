Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E65656B519
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 11:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237843AbiGHJIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 05:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237847AbiGHJIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 05:08:10 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E664922BC6;
        Fri,  8 Jul 2022 02:08:08 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LfS7w3r6BzhXYy;
        Fri,  8 Jul 2022 17:06:36 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 8 Jul 2022 17:08:05 +0800
Message-ID: <bbca91f2-d770-af69-8e6d-bfd18c7f1ec1@huawei.com>
Date:   Fri, 8 Jul 2022 17:08:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v6 4/4] bpf, arm64: bpf trampoline for arm64
Content-Language: en-US
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
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
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Hou Tao <houtao1@huawei.com>,
        Jason Wang <wangborong@cdjrlc.com>
References: <20220625161255.547944-1-xukuohai@huawei.com>
 <20220625161255.547944-5-xukuohai@huawei.com> <YscL4t1pYHYApIiK@larix>
 <a24109d5-b79a-99de-0fd5-66b0ec34e5ed@huawei.com> <YsfptiexC0wFABFL@myrica>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <YsfptiexC0wFABFL@myrica>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/2022 4:24 PM, Jean-Philippe Brucker wrote:
> On Fri, Jul 08, 2022 at 12:35:33PM +0800, Xu Kuohai wrote:
>>>> +
>>>> +	emit(A64_ADD_I(1, A64_R(0), A64_SP, args_off), ctx);
>>>> +	if (!p->jited)
>>>> +		emit_addr_mov_i64(A64_R(1), (const u64)p->insnsi, ctx);
>>>> +
>>>> +	emit_call((const u64)p->bpf_func, ctx);
>>>> +
>>>> +	/* store return value */
>>>> +	if (save_ret)
>>>> +		emit(A64_STR64I(r0, A64_SP, retval_off), ctx);
>>>
>>> Here too I think it should be x0. I'm guessing r0 may work for jitted
>>> functions but not interpreted ones
>>>
>>
>> Yes, r0 is only correct for jitted code, will fix it to:
>>
>> if (save_ret)
>>         emit(A64_STR64I(p->jited ? r0 : A64_R(0), A64_SP, retval_off),
>>              ctx);
> 
> I don't think we need this test because x0 should be correct in all cases.
> x7 happens to equal x0 when jitted due to the way build_epilogue() builds
> the function at the moment, but we shouldn't rely on that.
> 
> 
>>>> +	if (flags & BPF_TRAMP_F_CALL_ORIG) {
>>>> +		restore_args(ctx, args_off, nargs);
>>>> +		/* call original func */
>>>> +		emit(A64_LDR64I(A64_R(10), A64_SP, retaddr_off), ctx);
>>>> +		emit(A64_BLR(A64_R(10)), ctx);
>>>
>>> I don't think we can do this when BTI is enabled because we're not jumping
>>> to a BTI instruction. We could introduce one in a patched BPF function
>>> (there currently is one if CONFIG_ARM64_PTR_AUTH_KERNEL), but probably not
>>> in a kernel function.
>>>
>>> We could fo like FUNCTION_GRAPH_TRACER does and return to the patched
>>> function after modifying its LR. Not sure whether that works with pointer
>>> auth though.
>>>
>>
>> Yes, the blr instruction should be replaced with ret instruction, thanks!
>>
>> The layout for bpf prog and regular kernel function is as follows, with
>> bti always coming first and paciasp immediately after patchsite, so the
>> ret instruction should work in all cases.
>>
>> bpf prog or kernel function:
>>         bti c // if BTI
>>         mov x9, lr
>>         bl <trampoline>    ------> trampoline:
>>                                            ...
>>                                            mov lr, <return_entry>
>>                                            mov x10, <ORIG_CALL_entry>
>> ORIG_CALL_entry:           <-------        ret x10
>>                                    return_entry:
>>                                            ...
>>         paciasp // if PA
>>         ...
> 
> Actually I just noticed that CONFIG_ARM64_BTI_KERNEL depends on
> CONFIG_ARM64_PTR_AUTH_KERNEL, so we should be able to rely on there always
> being a PACIASP at ORIG_CALL_entry, and since it's a landing pad for BLR
> we don't need to make this a RET
> 
>  92e2294d870b ("arm64: bti: Support building kernel C code using BTI")
> 

oh, yeah, thanks

> Thanks,
> Jean
> 
> .


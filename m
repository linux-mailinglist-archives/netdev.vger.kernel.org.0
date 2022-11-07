Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9898961EE56
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 10:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbiKGJLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 04:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbiKGJLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 04:11:03 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3595F165A0;
        Mon,  7 Nov 2022 01:11:01 -0800 (PST)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N5QST36J8zmVhW;
        Mon,  7 Nov 2022 17:10:49 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:10:59 +0800
Received: from [10.67.111.205] (10.67.111.205) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:10:58 +0800
Subject: Re: [PATCH bpf RESEND 3/4] bpf: Add kernel function call support in
 32-bit ARM
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <illusionist.neo@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <mykolal@fb.com>, <shuah@kernel.org>,
        <benjamin.tissoires@redhat.com>, <memxor@gmail.com>,
        <delyank@fb.com>, <asavkov@redhat.com>, <bpf@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
References: <20221103092118.248600-1-yangjihong1@huawei.com>
 <20221103092118.248600-4-yangjihong1@huawei.com>
 <Y2OnedQdQaIQEPDQ@shell.armlinux.org.uk>
From:   Yang Jihong <yangjihong1@huawei.com>
Message-ID: <6e078f09-2f84-d3e7-2c46-7686a7ad3e17@huawei.com>
Date:   Mon, 7 Nov 2022 17:10:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <Y2OnedQdQaIQEPDQ@shell.armlinux.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.205]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 2022/11/3 19:35, Russell King (Oracle) wrote:
> On Thu, Nov 03, 2022 at 05:21:17PM +0800, Yang Jihong wrote:
>> This patch adds kernel function call support to the 32-bit ARM bpf jit.
>>
>> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
>> ---
>>   arch/arm/net/bpf_jit_32.c | 130 ++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 130 insertions(+)
>>
>> diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
>> index 6a1c9fca5260..51428c82bec6 100644
>> --- a/arch/arm/net/bpf_jit_32.c
>> +++ b/arch/arm/net/bpf_jit_32.c
>> @@ -1337,6 +1337,118 @@ static void build_epilogue(struct jit_ctx *ctx)
>>   #endif
>>   }
>>   
>> +/*
>> + * Input parameters of function in 32-bit ARM architecture:
>> + * The first four word-sized parameters passed to a function will be
>> + * transferred in registers R0-R3. Sub-word sized arguments, for example,
>> + * char, will still use a whole register.
>> + * Arguments larger than a word will be passed in multiple registers.
>> + * If more arguments are passed, the fifth and subsequent words will be passed
>> + * on the stack.
>> + *
>> + * The first for args of a function will be considered for
>> + * putting into the 32bit register R1, R2, R3 and R4.
>> + *
>> + * Two 32bit registers are used to pass a 64bit arg.
>> + *
>> + * For example,
>> + * void foo(u32 a, u32 b, u32 c, u32 d, u32 e):
>> + *      u32 a: R0
>> + *      u32 b: R1
>> + *      u32 c: R2
>> + *      u32 d: R3
>> + *      u32 e: stack
>> + *
>> + * void foo(u64 a, u32 b, u32 c, u32 d):
>> + *      u64 a: R0 (lo32) R1 (hi32)
>> + *      u32 b: R2
>> + *      u32 c: R3
>> + *      u32 d: stack
>> + *
>> + * void foo(u32 a, u64 b, u32 c, u32 d):
>> + *       u32 a: R0
>> + *       u64 b: R2 (lo32) R3 (hi32)
>> + *       u32 c: stack
>> + *       u32 d: stack
> 
> This code supports both EABI and OABI, but the above is EABI-only.
> Either we need to decide not to support OABI, or we need to add code
> for both. That can probably be done by making:
> 
Yes, the OABI situation was not considered here before,
Because I don't have OABI ARM machine, I can't actually verify it,
only EABI is supported.
In the next version, will check whether CONFIG_AEABI is enabled.
>> +	for (i = 0; i < fm->nr_args; i++) {
>> +		if (fm->arg_size[i] > sizeof(u32)) {
>> +			if (arg_regs_idx + 1 < nr_arg_regs) {
>> +				/*
>> +				 * AAPCS states:
>> +				 * A double-word sized type is passed in two
>> +				 * consecutive registers (e.g., r0 and r1, or
>> +				 * r2 and r3). The content of the registers is
>> +				 * as if the value had been loaded from memory
>> +				 * representation with a single LDM instruction.
>> +				 */
>> +				if (arg_regs_idx & 1)
>> +					arg_regs_idx++;
> 
> ... this conditional on IS_ENABLED(CONFIG_AEABI).
> 
>> +				emit(ARM_LDRD_I(arg_regs[arg_regs_idx], ARM_FP,
>> +						EBPF_SCRATCH_TO_ARM_FP(
>> +							bpf2a32[BPF_REG_1 + i][1])), ctx);
> 
> You probably want to re-use the internals of arm_bpf_get_reg64() to load
> the register.
OK, will re-use arm_bpf_get_reg64 in next version.
> 
>> +
>> +				arg_regs_idx += 2;
>> +			} else {
>> +				stack_off = ALIGN(stack_off, STACK_ALIGNMENT);
>> +
>> +				emit(ARM_LDRD_I(tmp[1], ARM_FP,
>> +						EBPF_SCRATCH_TO_ARM_FP(
>> +							bpf2a32[BPF_REG_1 + i][1])), ctx);
> 
> Same here.
OK, will re-use arm_bpf_get_reg64 in next version.
> 
>> +				emit(ARM_STRD_I(tmp[1], ARM_SP, stack_off), ctx);
> 
> and the internals of arm_bpf_put_reg64() here. Not all Arm CPUs that
> this code runs on supports ldrd and strd.
> 
Yes, the ARM CPUs that do not support LDRD and STRD have not been 
considered, will fix in next version.


Thanks,
Yang

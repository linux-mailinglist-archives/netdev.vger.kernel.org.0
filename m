Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CAE4B6214
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 05:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiBOE3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 23:29:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBOE3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 23:29:54 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BA81EC75;
        Mon, 14 Feb 2022 20:29:44 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JySkZ3Fkdz9sbb;
        Tue, 15 Feb 2022 12:28:06 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 12:29:42 +0800
From:   Hou Tao <houtao1@huawei.com>
Subject: Re: [PATCH bpf-next v3] bpf: reject kfunc calls that overflow
 insn->imm
To:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20220209091153.54116-1-houtao1@huawei.com>
 <54064f1c-5ff0-e6c1-dae5-19bec4b7641b@fb.com>
Message-ID: <2339465e-1f87-595a-2954-eb92b6bfa9cc@huawei.com>
Date:   Tue, 15 Feb 2022 12:29:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <54064f1c-5ff0-e6c1-dae5-19bec4b7641b@fb.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/9/2022 11:42 PM, Yonghong Song wrote:
>
>
> On 2/9/22 1:11 AM, Hou Tao wrote:
>> Now kfunc call uses s32 to represent the offset between the address
>> of kfunc and __bpf_call_base, but it doesn't check whether or not
>> s32 will be overflowed, so add an extra checking to reject these
>> invalid kfunc calls.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>
> The patch itself looks good. But the commit message
> itself doesn't specify whether this is a theoretical case or
> could really happen in practice. I look at the patch history,
> and find the become commit message in v1 of the patch ([1]):
>
> > Since commit b2eed9b58811 ("arm64/kernel: kaslr: reduce module
> > randomization range to 2 GB"), for arm64 whether KASLR is enabled
> > or not, the module is placed within 2GB of the kernel region, so
> > s32 in bpf_kfunc_desc is sufficient to represente the offset of
> > module function relative to __bpf_call_base. The only thing needed
> > is to override bpf_jit_supports_kfunc_call().
>
> So it does look like the overflow is possible.
>
> So I suggest you add more description on *when* the overflow
> may happen in this patch.
Will do in v5.
>
> And you can also retain your previous selftest patch to test
> this verifier change.
Is it necessary ?  IMO it is just duplication of the newly-added logic.

Regards,
Tao

>
>   [1] https://lore.kernel.org/bpf/20220119144942.305568-1-houtao1@huawei.com/
>
>> ---
>> v3:
>>   * call BPF_CALL_IMM() once (suggested by Yonghong)
>>
>> v2: https://lore.kernel.org/bpf/20220208123348.40360-1-houtao1@huawei.com
>>   * instead of checking the overflow in selftests, just reject
>>     these kfunc calls directly in verifier
>>
>> v1: https://lore.kernel.org/bpf/20220206043107.18549-1-houtao1@huawei.com
>> ---
>>   kernel/bpf/verifier.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 1ae41d0cf96c..eb72e6139e2b 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -1842,6 +1842,7 @@ static int add_kfunc_call(struct bpf_verifier_env *env,
>> u32 func_id, s16 offset)
>>       struct bpf_kfunc_desc *desc;
>>       const char *func_name;
>>       struct btf *desc_btf;
>> +    unsigned long call_imm;
>>       unsigned long addr;
>>       int err;
>>   @@ -1926,9 +1927,17 @@ static int add_kfunc_call(struct bpf_verifier_env
>> *env, u32 func_id, s16 offset)
>>           return -EINVAL;
>>       }
>>   +    call_imm = BPF_CALL_IMM(addr);
>> +    /* Check whether or not the relative offset overflows desc->imm */
>> +    if ((unsigned long)(s32)call_imm != call_imm) {
>> +        verbose(env, "address of kernel function %s is out of range\n",
>> +            func_name);
>> +        return -EINVAL;
>> +    }
>> +
>>       desc = &tab->descs[tab->nr_descs++];
>>       desc->func_id = func_id;
>> -    desc->imm = BPF_CALL_IMM(addr);
>> +    desc->imm = call_imm;
>>       desc->offset = offset;
>>       err = btf_distill_func_proto(&env->log, desc_btf,
>>                        func_proto, func_name,
> .


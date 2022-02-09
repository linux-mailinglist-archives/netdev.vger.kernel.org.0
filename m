Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEF24AEA3E
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 07:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbiBIGXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 01:23:07 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiBIGVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 01:21:24 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F19C03326C;
        Tue,  8 Feb 2022 22:21:22 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JtqQC0vzYz1FCsw;
        Wed,  9 Feb 2022 14:16:19 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Feb 2022 14:20:31 +0800
Subject: Re: [PATCH bpf-next v2] bpf: reject kfunc calls that overflow
 insn->imm
To:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20220208123348.40360-1-houtao1@huawei.com>
 <a11e8024-5a83-3016-f741-110ee74ee927@fb.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <1e3c5443-ab95-6099-55ee-edfaaaa9c898@huawei.com>
Date:   Wed, 9 Feb 2022 14:20:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <a11e8024-5a83-3016-f741-110ee74ee927@fb.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

On 2/9/2022 12:57 AM, Yonghong Song wrote:
>
>
> On 2/8/22 4:33 AM, Hou Tao wrote:
>> Now kfunc call uses s32 to represent the offset between the address
>> of kfunc and __bpf_call_base, but it doesn't check whether or not
>> s32 will be overflowed, so add an extra checking to reject these
>> invalid kfunc calls.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> ---
>> v2:
>>   * instead of checking the overflow in selftests, just reject
>>     these kfunc calls directly in verifier
>>
>> v1: https://lore.kernel.org/bpf/20220206043107.18549-1-houtao1@huawei.com
>> ---
>>   kernel/bpf/verifier.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index a39eedecc93a..fd836e64b701 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -1832,6 +1832,13 @@ static struct btf *find_kfunc_desc_btf(struct
>> bpf_verifier_env *env,
>>       return btf_vmlinux ?: ERR_PTR(-ENOENT);
>>   }
>>   +static inline bool is_kfunc_call_imm_overflowed(unsigned long addr)
>> +{
>> +    unsigned long offset = BPF_CALL_IMM(addr);
>> +
>> +    return (unsigned long)(s32)offset != offset;
>> +}
>> +
>>   static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16
>> offset)
>>   {
>>       const struct btf_type *func, *func_proto;
>> @@ -1925,6 +1932,12 @@ static int add_kfunc_call(struct bpf_verifier_env
>> *env, u32 func_id, s16 offset)
>>           return -EINVAL;
>>       }
>>   +    if (is_kfunc_call_imm_overflowed(addr)) {
>> +        verbose(env, "address of kernel function %s is out of range\n",
>> +            func_name);
>> +        return -EINVAL;
>> +    }
>> +
>>       desc = &tab->descs[tab->nr_descs++];
>>       desc->func_id = func_id;
>>       desc->imm = BPF_CALL_IMM(addr);
>
> Thanks, I would like to call BPF_CALL_IMM only once and keep checking overflow
> and setting desc->imm close to each other. How about the following
> not-compile-tested code
>
>     unsigned long call_imm;
>
>     ...
>     call_imm = BPF_CALL_IMM(addr);
>     /* some comment here */
>     if ((unsigned long)(s32)call_imm != call_imm) {
>         verbose(env, ...);
>         return -EINVAL;
>     } else {
>         desc->imm = call_imm;
>     }
call BPF_CALL_IMM once is OK for me. but I don't think the else branch is
unnecessary and it make the code
ugly. Can we just return directly when found that imm is overflowed ?

        call_imm = BPF_CALL_IMM(addr);
        /* Check whether or not the relative offset overflows desc->imm */
        if ((unsigned long)(s32)call_imm != call_imm) {
                verbose(env, "address of kernel function %s is out of range\n",
                        func_name);
                return -EINVAL;
        }

        desc = &tab->descs[tab->nr_descs++];
        desc->func_id = func_id;
        desc->imm = call_imm;




> .



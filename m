Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DE56394F7
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 10:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiKZJqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 04:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiKZJqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 04:46:02 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597921CFEF;
        Sat, 26 Nov 2022 01:46:01 -0800 (PST)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NK6Kd0krvzRpYH;
        Sat, 26 Nov 2022 17:45:25 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 26 Nov 2022 17:45:59 +0800
Received: from [10.67.111.205] (10.67.111.205) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 26 Nov 2022 17:45:58 +0800
Subject: Re: [PATCH bpf v2 1/5] bpf: Adapt 32-bit return value kfunc for
 32-bit ARM when zext extension
To:     Martin KaFai Lau <martin.lau@linux.dev>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>, <illusionist.neo@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <mykolal@fb.com>, <shuah@kernel.org>,
        <benjamin.tissoires@redhat.com>, <memxor@gmail.com>,
        <asavkov@redhat.com>, <delyank@fb.com>, <bpf@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
References: <20221107092032.178235-1-yangjihong1@huawei.com>
 <20221107092032.178235-2-yangjihong1@huawei.com>
 <62bf28ac-c1fa-fc60-ce52-6d993a8a4bbf@linux.dev>
From:   Yang Jihong <yangjihong1@huawei.com>
Message-ID: <db99b2c7-3798-b7d5-e0b9-00ce454f47c6@huawei.com>
Date:   Sat, 26 Nov 2022 17:45:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <62bf28ac-c1fa-fc60-ce52-6d993a8a4bbf@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.205]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

On 2022/11/9 7:12, Martin KaFai Lau wrote:
> On 11/7/22 1:20 AM, Yang Jihong wrote:
>> For ARM32 architecture, if data width of kfunc return value is 32 bits,
>> need to do explicit zero extension for high 32-bit, insn_def_regno should
>> return dst_reg for BPF_JMP type of BPF_PSEUDO_KFUNC_CALL. Otherwise,
>> opt_subreg_zext_lo32_rnd_hi32 returns -EFAULT, resulting in BPF failure.
>>
>> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
>> ---
>>   kernel/bpf/verifier.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 7f0a9f6cb889..bac37757ffca 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -2404,6 +2404,9 @@ static int insn_def_regno(const struct bpf_insn 
>> *insn)
>>   {
>>       switch (BPF_CLASS(insn->code)) {
>>       case BPF_JMP:
>> +        if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL)
>> +            return insn->dst_reg;
> 
> This does not look right.  A kfunc can return void.  The btf type of the 
> kfunc's return value needs to be checked against "void" first?
OK, will add the check in next version.

> Also, this will affect insn_has_def32(), does is_reg64 (called from 
> insn_has_def32) need to be adjusted also?
Yes, is_reg64 need to be adjusted, will fix in next version.
> 
> 
> For patch 2, as replied earlier in v1, I would separate out the prog 
> that does __sk_buff->sk and use the uapi's bpf.h instead of vmlinux.h 
> since it does not need CO-RE.
OK, will remove adjust sk check patches in next verion.

As mentioned in v1:
"bpf-tc program can take'struct sk_buff *skb' instead of'struct
__sk_buff *skb' but it will be a separate topic."

It is a separate topic, only the lskel test cases are affected.
The ARM32 kfunc function is not affected.

> 
> This set should target for bpf-next instead of bpf.
OK, will send to bpf-next in next version.

Thanks,
Yang

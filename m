Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F20605526
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 03:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiJTBre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 21:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiJTBrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 21:47:33 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7B91958CC;
        Wed, 19 Oct 2022 18:47:32 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mt9Mn5JfJz1P71t;
        Thu, 20 Oct 2022 09:42:45 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 09:46:55 +0800
Message-ID: <d830980c-4a38-5537-b594-bc5fb86b0acd@huawei.com>
Date:   Thu, 20 Oct 2022 09:46:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH bpf-next] bpf: fix issue that packet only contains l2 is
 dropped
To:     Stanislav Fomichev <sdf@google.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <haoluo@google.com>, <jolsa@kernel.org>, <oss@lmb.io>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20221015092448.117563-1-shaozhengchao@huawei.com>
 <CAKH8qBugSdWHP7mtNxrnLLR+56u_0OCx3xQOkJSV-+RUvDAeNg@mail.gmail.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <CAKH8qBugSdWHP7mtNxrnLLR+56u_0OCx3xQOkJSV-+RUvDAeNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/10/18 0:36, Stanislav Fomichev wrote:
> On Sat, Oct 15, 2022 at 2:16 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>>
>> As [0] see, bpf_prog_test_run_skb() should allow user space to forward
>> 14-bytes packet via BPF_PROG_RUN instead of dropping packet directly.
>> So fix it.
>>
>> 0: https://github.com/cilium/ebpf/commit/a38fb6b5a46ab3b5639ea4d421232a10013596c0
>>
>> Fixes: fd1894224407 ("bpf: Don't redirect packets with invalid pkt_len")
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   net/bpf/test_run.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
>> index 13d578ce2a09..aa1b49f19ca3 100644
>> --- a/net/bpf/test_run.c
>> +++ b/net/bpf/test_run.c
>> @@ -979,9 +979,6 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
>>   {
>>          struct qdisc_skb_cb *cb = (struct qdisc_skb_cb *)skb->cb;
>>
>> -       if (!skb->len)
>> -               return -EINVAL;
>> -
>>          if (!__skb)
>>                  return 0;
>>
>> @@ -1102,6 +1099,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>>          if (IS_ERR(data))
>>                  return PTR_ERR(data);
>>
>> +       if (size == ETH_HLEN)
>> +               is_l2 = true;
>> +
> 
> Don't think this will work? That is_l2 is there to expose proper l2/l3
> skb for specific hooks; we can't suddenly start exposing l2 headers to
> the hooks that don't expect it.
> Does it make sense to start with a small reproducer that triggers the
> issue first? We can have a couple of cases for
> len=0/ETH_HLEN-1/ETH_HLEN+1 and trigger them from the bpf program that
> redirects to different devices (to trigger dev_is_mac_header_xmit).
> 
> 
Hi Stanislav:
	Thank you for your review. Is_l2 is the flag of a specific
hook. Therefore, do you mean that if skb->len is equal to 0, just
add the length back?
> 
> 
> 
>>          ctx = bpf_ctx_init(kattr, sizeof(struct __sk_buff));
>>          if (IS_ERR(ctx)) {
>>                  kfree(data);
>> --
>> 2.17.1
>>

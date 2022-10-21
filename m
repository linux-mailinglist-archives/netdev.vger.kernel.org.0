Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994E46070FE
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 09:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiJUHZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 03:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiJUHZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 03:25:15 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E1FC50AE;
        Fri, 21 Oct 2022 00:25:08 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mtwpq5KykzmVJJ;
        Fri, 21 Oct 2022 15:20:19 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 15:25:05 +0800
Message-ID: <87f67a8c-2fb2-9478-adbb-f55c7a7c94f9@huawei.com>
Date:   Fri, 21 Oct 2022 15:25:04 +0800
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
 <d830980c-4a38-5537-b594-bc5fb86b0acd@huawei.com>
 <CAKH8qBtyfS0Otpugn7_ZiG5APA_WTKOVAe1wsFfyaxF-03X=5w@mail.gmail.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <CAKH8qBtyfS0Otpugn7_ZiG5APA_WTKOVAe1wsFfyaxF-03X=5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
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



On 2022/10/21 1:45, Stanislav Fomichev wrote:
> On Wed, Oct 19, 2022 at 6:47 PM shaozhengchao <shaozhengchao@huawei.com> wrote:
>>
>>
>>
>> On 2022/10/18 0:36, Stanislav Fomichev wrote:
>>> On Sat, Oct 15, 2022 at 2:16 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>>>>
>>>> As [0] see, bpf_prog_test_run_skb() should allow user space to forward
>>>> 14-bytes packet via BPF_PROG_RUN instead of dropping packet directly.
>>>> So fix it.
>>>>
>>>> 0: https://github.com/cilium/ebpf/commit/a38fb6b5a46ab3b5639ea4d421232a10013596c0
>>>>
>>>> Fixes: fd1894224407 ("bpf: Don't redirect packets with invalid pkt_len")
>>>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>>>> ---
>>>>    net/bpf/test_run.c | 6 +++---
>>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
>>>> index 13d578ce2a09..aa1b49f19ca3 100644
>>>> --- a/net/bpf/test_run.c
>>>> +++ b/net/bpf/test_run.c
>>>> @@ -979,9 +979,6 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
>>>>    {
>>>>           struct qdisc_skb_cb *cb = (struct qdisc_skb_cb *)skb->cb;
>>>>
>>>> -       if (!skb->len)
>>>> -               return -EINVAL;
>>>> -
>>>>           if (!__skb)
>>>>                   return 0;
>>>>
>>>> @@ -1102,6 +1099,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>>>>           if (IS_ERR(data))
>>>>                   return PTR_ERR(data);
>>>>
>>>> +       if (size == ETH_HLEN)
>>>> +               is_l2 = true;
>>>> +
>>>
>>> Don't think this will work? That is_l2 is there to expose proper l2/l3
>>> skb for specific hooks; we can't suddenly start exposing l2 headers to
>>> the hooks that don't expect it.
>>> Does it make sense to start with a small reproducer that triggers the
>>> issue first? We can have a couple of cases for
>>> len=0/ETH_HLEN-1/ETH_HLEN+1 and trigger them from the bpf program that
>>> redirects to different devices (to trigger dev_is_mac_header_xmit).
>>>
>>>
>> Hi Stanislav:
>>          Thank you for your review. Is_l2 is the flag of a specific
>> hook. Therefore, do you mean that if skb->len is equal to 0, just
>> add the length back?
> 
> Not sure I understand your question. All I'm saying is - you can't
> flip that flag arbitrarily. This flag depends on the attach point that
> you're running the prog against. Some attach points expect packets
> with l2, some expect packets without l2.
> 
> What about starting with a small reproducer? Does it make sense to
> create a small selftest that adds net namespace + fq_codel +
> bpf_prog_test run and do redirect ingress/egress with len
> 0/1...tcphdr? Because I'm not sure I 100% understand whether it's only
> len=0 that's problematic or some other combination as well?
> 
yes, only skb->len = 0 will cause null-ptr-deref issue.
The following is the process of triggering the problem:
enqueue a skb:
fq_codel_enqueue()
	...
	idx = fq_codel_classify()        --->if idx != 0
	flow = &q->flows[idx];
	flow_queue_add(flow, skb);       --->add skb to flow[idex]
	q->backlogs[idx] += qdisc_pkt_len(skb); --->backlogs = 0
	...
	fq_codel_drop()                  --->set sch->limit = 0, always
drop packets
		...
		idx = i                  --->becuase backlogs in every
flows is 0, so idx = 0
		...
		flow = &q->flows[idx];   --->get idx=0 flow
		...
		dequeue_head()
			skb = flow->head; --->flow->head = NULL
			flow->head = skb->next; --->cause null-ptr-deref
So, if skb->len !=0，fq_codel_drop() could get the correct idx, and
then skb!=NULL, it will be OK.
Maybe, I will fix it in fq_codel.

But, as I know, skb->len = 0 is just invalid packet. I prefer to add the
length back, like bellow:
	if (is_l2 || !skb->len)
		__skb_push(skb, hh_len);
is it OK?
>>>
>>>
>>>
>>>>           ctx = bpf_ctx_init(kattr, sizeof(struct __sk_buff));
>>>>           if (IS_ERR(ctx)) {
>>>>                   kfree(data);
>>>> --
>>>> 2.17.1
>>>>

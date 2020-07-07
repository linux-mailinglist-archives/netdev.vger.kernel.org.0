Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD30217A33
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 23:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgGGVYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 17:24:25 -0400
Received: from out0-157.mail.aliyun.com ([140.205.0.157]:35669 "EHLO
        out0-157.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgGGVYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 17:24:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594157061; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=Hyw+eiNcfwFGl0K5RvKjp1GetQqIv3t5qIjfXS7a00o=;
        b=IZ+KwiBnYV7RWe26aC+MZ91H0YOdsA4H7303Hp3pZPSrPaBNh6m1qR+ws9Ygsck6El4Jt/rLd3U3lj7+qOhXEkvTCWprgStEwyX1YvwdYXdzMwa+OG6gkat24pMy10rBnvQnvYtANGSrBzijZKzLEs73X1dXMSwYrJUqVsxNADg=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03305;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.HzmCU.q_1594157060;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.HzmCU.q_1594157060)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Jul 2020 05:24:21 +0800
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB)
 Qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
 <CAM_iQpVux85OXH-oYeH15sYTb=kEj0o7uu9ug9PeTesHzXk_gQ@mail.gmail.com>
 <5c963736-2a83-b658-2a9d-485d0876c03f@alibaba-inc.com>
 <CAM_iQpV5LRU-JxfLETsdNqh75wv3vWyCsxiTTgC392HvTxa9CQ@mail.gmail.com>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <ad662f0b-c4ab-01c0-57e1-45ddd7325e66@alibaba-inc.com>
Date:   Wed, 08 Jul 2020 05:24:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpV5LRU-JxfLETsdNqh75wv3vWyCsxiTTgC392HvTxa9CQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/20 1:06 PM, Cong Wang wrote:
> On Mon, Jul 6, 2020 at 1:34 PM YU, Xiangning
> <xiangning.yu@alibaba-inc.com> wrote:
>>
>>
>>
>> On 7/6/20 1:10 PM, Cong Wang wrote:
>>> On Mon, Jul 6, 2020 at 11:11 AM YU, Xiangning
>>> <xiangning.yu@alibaba-inc.com> wrote:
>>>> +static int ltb_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
>>>> +                      struct sk_buff **to_free)
>>>> +{
>>>> +       struct ltb_sched *ltb = qdisc_priv(sch);
>>>> +       struct ltb_pcpu_sched *pcpu_q;
>>>> +       struct ltb_class *cl;
>>>> +       struct ltb_pcpu_data *pcpu = this_cpu_ptr(ltb->pcpu_data);
>>>> +       int cpu;
>>>> +
>>>> +       cpu = smp_processor_id();
>>>> +       pcpu_q = qdisc_priv(pcpu->qdisc);
>>>> +       ltb_skb_cb(skb)->cpu = cpu;
>>>> +
>>>> +       cl = ltb_classify(sch, ltb, skb);
>>>> +       if (unlikely(!cl)) {
>>>> +               kfree_skb(skb);
>>>> +               return NET_XMIT_DROP;
>>>> +       }
>>>> +
>>>> +       pcpu->active = true;
>>>> +       if (unlikely(kfifo_put(&cl->aggr_queues[cpu], skb) == 0)) {
>>>> +               kfree_skb(skb);
>>>> +               atomic64_inc(&cl->stat_drops);
>>>> +               return NET_XMIT_DROP;
>>>> +       }
>>>
>>>
>>> How do you prevent out-of-order packets?
>>>
>>
>> Hi Cong,
>>
>> That's a good question. In theory there will be out of order packets during aggregation. While keep in mind this is per-class aggregation, and it runs at a high frequency, that the chance to have any left over skbs from the same TCP flow on many CPUs is low.
>>
>> Also, based on real deployment experience, we haven't observed an increased out of order events even under heavy work load.
>>
> 
> Yeah, but unless you always classify packets into proper flows, there
> is always a chance to generate out-of-order packets here, which
> means the default configuration is flawed.
>

The key is to avoid classifying packets from a same flow into different classes. So we use socket priority to classify packets. It's always going to be correctly classified.

Not sure what do you mean by default configuration. But we create a shadow class when the qdisc is created. Before any other classes are created, all packets from any flow will be classified to this same shadow class, there won't be any incorrect classified packets either. 

> 
>>>
>>>> +static int ltb_init(struct Qdisc *sch, struct nlattr *opt,
>>> ...
>>>> +       ltb->default_cls = ltb->shadow_cls; /* Default hasn't been created */
>>>> +       tasklet_init(&ltb->fanout_tasklet, ltb_fanout_tasklet,
>>>> +                    (unsigned long)ltb);
>>>> +
>>>> +       /* Bandwidth balancer, this logic can be implemented in user-land. */
>>>> +       init_waitqueue_head(&ltb->bwbalancer_wq);
>>>> +       ltb->bwbalancer_task =
>>>> +           kthread_create(ltb_bw_balancer_kthread, ltb, "ltb-balancer");
>>>> +       wake_up_process(ltb->bwbalancer_task);
>>>
>>> Creating a kthread for each qdisc doesn't look good. Why do you
>>> need a per-qdisc kthread or even a kernel thread at all?
>>>
>>
>> We moved the bandwidth sharing out of the critical data path, that's why we use a kernel thread to balance the current maximum bandwidth used by each class periodically.
>>
>> This part could be implemented at as timer. What's your suggestion?
> 
> I doubt you can use a timer, as you call rtnl_trylock() there.
> Why not use a delayed work?
> 

Thank you for the suggestion, I will replace it with a delayed work and send out the new patch.

- Xiangning

> Thanks.
> 

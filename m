Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2FF21605C
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgGFUez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:34:55 -0400
Received: from out0-129.mail.aliyun.com ([140.205.0.129]:58169 "EHLO
        out0-129.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFUey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:34:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594067693; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=Gp6cq/9DWWzfjHFgCIY652VjOsPH2nsyiqXwYR1F30U=;
        b=c4lbDT302cxIKFj6WPe3cMEG/f9j9idSvKo+3RVn/fkKy9gMjTN5XGYa53oiMrBO4vHFAob+4OfOoBpY8mbBb4d4BsGdveRqPSsiEpQggh3C/ceEYa5zWVNdFwcQ264QDjrclTMojnmolMP4ps6qTmy9C8wKgXEZak0IvsQuQug=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01a16368;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.Hz1o5RL_1594067691;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.Hz1o5RL_1594067691)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Jul 2020 04:34:52 +0800
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB)
 Qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
 <CAM_iQpVux85OXH-oYeH15sYTb=kEj0o7uu9ug9PeTesHzXk_gQ@mail.gmail.com>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <5c963736-2a83-b658-2a9d-485d0876c03f@alibaba-inc.com>
Date:   Tue, 07 Jul 2020 04:34:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVux85OXH-oYeH15sYTb=kEj0o7uu9ug9PeTesHzXk_gQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/20 1:10 PM, Cong Wang wrote:
> On Mon, Jul 6, 2020 at 11:11 AM YU, Xiangning
> <xiangning.yu@alibaba-inc.com> wrote:
>> +static int ltb_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
>> +                      struct sk_buff **to_free)
>> +{
>> +       struct ltb_sched *ltb = qdisc_priv(sch);
>> +       struct ltb_pcpu_sched *pcpu_q;
>> +       struct ltb_class *cl;
>> +       struct ltb_pcpu_data *pcpu = this_cpu_ptr(ltb->pcpu_data);
>> +       int cpu;
>> +
>> +       cpu = smp_processor_id();
>> +       pcpu_q = qdisc_priv(pcpu->qdisc);
>> +       ltb_skb_cb(skb)->cpu = cpu;
>> +
>> +       cl = ltb_classify(sch, ltb, skb);
>> +       if (unlikely(!cl)) {
>> +               kfree_skb(skb);
>> +               return NET_XMIT_DROP;
>> +       }
>> +
>> +       pcpu->active = true;
>> +       if (unlikely(kfifo_put(&cl->aggr_queues[cpu], skb) == 0)) {
>> +               kfree_skb(skb);
>> +               atomic64_inc(&cl->stat_drops);
>> +               return NET_XMIT_DROP;
>> +       }
> 
> 
> How do you prevent out-of-order packets?
> 

Hi Cong,

That's a good question. In theory there will be out of order packets during aggregation. While keep in mind this is per-class aggregation, and it runs at a high frequency, that the chance to have any left over skbs from the same TCP flow on many CPUs is low.

Also, based on real deployment experience, we haven't observed an increased out of order events even under heavy work load.

> 
>> +static int ltb_init(struct Qdisc *sch, struct nlattr *opt,
> ...
>> +       ltb->default_cls = ltb->shadow_cls; /* Default hasn't been created */
>> +       tasklet_init(&ltb->fanout_tasklet, ltb_fanout_tasklet,
>> +                    (unsigned long)ltb);
>> +
>> +       /* Bandwidth balancer, this logic can be implemented in user-land. */
>> +       init_waitqueue_head(&ltb->bwbalancer_wq);
>> +       ltb->bwbalancer_task =
>> +           kthread_create(ltb_bw_balancer_kthread, ltb, "ltb-balancer");
>> +       wake_up_process(ltb->bwbalancer_task);
> 
> Creating a kthread for each qdisc doesn't look good. Why do you
> need a per-qdisc kthread or even a kernel thread at all?
> 

We moved the bandwidth sharing out of the critical data path, that's why we use a kernel thread to balance the current maximum bandwidth used by each class periodically.

This part could be implemented at as timer. What's your suggestion?

Thanks,
- Xiangning

> Thanks.
> 

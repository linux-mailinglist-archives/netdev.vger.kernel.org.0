Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5792194C4
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 01:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgGHX7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 19:59:52 -0400
Received: from out0-151.mail.aliyun.com ([140.205.0.151]:52760 "EHLO
        out0-151.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgGHX7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 19:59:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594252789; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=gJ81qM8USMhjglEOQolqpLcjTCW9wuWxyqKH3w7vfJ8=;
        b=FZucEaP1v3rce9D62v1dGqvh5/DZmDbiI4e5hDwK9VQVXNd/I1HQwNot42GdV/Hqypyp2HNk31xFIEoj8vnCOIjyd4R4mOu9XbadWDTjQVtTSxL6lcCe8fY/cxXpMJar+EeKf3A1ynZcX1S4Aoh6/uABcbLnwtJEdazc4irN6A0=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03305;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.I-S8LPb_1594252787;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I-S8LPb_1594252787)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Jul 2020 07:59:48 +0800
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
 <554197ce-cef1-0e75-06d7-56dbef7c13cc@gmail.com>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <d1716bc1-a975-54a3-8b7e-a3d3bcac69c5@alibaba-inc.com>
Date:   Thu, 09 Jul 2020 07:59:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <554197ce-cef1-0e75-06d7-56dbef7c13cc@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 3:29 PM, Eric Dumazet wrote:
> 
> 
> On 7/8/20 9:38 AM, YU, Xiangning wrote:
>> Lockless Token Bucket (LTB) is a qdisc implementation that controls the
>> use of outbound bandwidth on a shared link. With the help of lockless
>> qdisc, and by decoupling rate limiting and bandwidth sharing, LTB is
>> designed to scale in the cloud data centers.
> 
>> +static int ltb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>> +		       spinlock_t *root_lock, struct sk_buff **to_free)
>> +{
>> +	struct ltb_sched *ltb = qdisc_priv(sch);
>> +	struct ltb_pcpu_sched *pcpu_q;
>> +	struct ltb_pcpu_data *pcpu;
>> +	struct ltb_class *cl;
>> +	int cpu;
>> +
>> +	pcpu = this_cpu_ptr(ltb->pcpu_data);
>> +	pcpu_q = qdisc_priv(pcpu->qdisc);
>> +	cpu = smp_processor_id();
>> +	ltb_skb_cb(skb)->cpu = cpu;
>> +
>> +	cl = ltb_classify(sch, ltb, skb);
>> +	if (unlikely(!cl)) {
>> +		kfree_skb(skb);
>> +		return NET_XMIT_DROP;
>> +	}
>> +
>> +	pcpu->active = true;
>> +	if (unlikely(kfifo_put(&cl->aggr_queues[cpu], skb) == 0)) {
>> +		kfree_skb(skb);
>> +		atomic64_inc(&cl->stat_drops);
> 
>             qdisc drop counter should also be incremented.
> 
>> +		return NET_XMIT_DROP;
>> +	}
>> +
> 
>> +	sch->q.qlen = 1;
> So, this is touching a shared cache line, why is it needed ? This looks some hack to me.
> 

Somehow I had the impression that if qlen is zero the qdisc won't be scheduled. We need to fix it. Thank you for catching this!

>> +	pcpu_q->qdisc->q.qlen++;
> 
>> +	tasklet_schedule(&cl->aggr_tasklet);
> 
> This is also touching a cache line.
> 
> I really have doubts about scheduling a tasklet for every sent packet.
> 
> (Particularly if majority of packets should not be rate limited)
> 

Yes, we are touching a cache line here to make sure aggregation tasklet is scheduled immediately. In most cases it is a call to test_and_set_bit(). 

We might be able to do some inline processing without tasklet here, still we need to make sure the aggregation won't run simultaneously on multiple CPUs. 

Thanks,
- Xiangning

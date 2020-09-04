Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D1425D335
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 10:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbgIDII0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 04:08:26 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10767 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbgIDIIW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 04:08:22 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EFEB2D3A099A398AECF3;
        Fri,  4 Sep 2020 16:08:16 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Fri, 4 Sep 2020 16:08:08 +0800
Subject: Re: [PATCH net-next] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
References: <1598921718-79505-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpVtb3Cks-LacZ865=C8r-_8ek1cy=n3SxELYGxvNgkPtw@mail.gmail.com>
 <511bcb5c-b089-ab4e-4424-a83c6e718bfa@huawei.com>
 <CAM_iQpW1c1TOKWLxm4uGvCUzK0mKKeDg1Y+3dGAC04pZXeCXcw@mail.gmail.com>
 <f81b534a-5845-ae7d-b103-434232c0f5ff@huawei.com>
 <CAM_iQpXmpMdxF2JDOROaf+Tjk-8dASiXz53K-Ph_q7jVMe0oVw@mail.gmail.com>
 <cd773132-c98e-18e1-67fd-bbef6babbf0f@huawei.com>
 <CAM_iQpWbZdh5-UGBi6PM19EBgV+Bq7vmifgJPdak6X=R9yztnw@mail.gmail.com>
 <c0543793-11fa-6ef1-f8ea-6a724ab2de8f@huawei.com>
 <CAM_iQpWGaTSkg+-Em6u=NSWcyswX-xN=-1p0OAdaR___U1M4rg@mail.gmail.com>
 <5f5198ae79b98_361ef20824@john-XPS-13-9370.notmuch>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <968db64f-a139-541f-e046-fba25e037d3e@huawei.com>
Date:   Fri, 4 Sep 2020 16:08:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <5f5198ae79b98_361ef20824@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/4 9:30, John Fastabend wrote:
> Cong Wang wrote:
>> On Wed, Sep 2, 2020 at 7:22 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>
>>> On 2020/9/3 9:48, Cong Wang wrote:
>>>> On Wed, Sep 2, 2020 at 6:22 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>>
>>>>> On 2020/9/3 8:35, Cong Wang wrote:
>>>>>> On Tue, Sep 1, 2020 at 11:35 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>>>>
>>>>>>> On 2020/9/2 12:41, Cong Wang wrote:
>>>>>>>> On Tue, Sep 1, 2020 at 6:42 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>>>>>>
>>>>>>>>> On 2020/9/2 2:24, Cong Wang wrote:
>>>>>>>>>> On Mon, Aug 31, 2020 at 5:59 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>>>>>>>>
>>>>>>>>>>> Currently there is concurrent reset and enqueue operation for the
>>>>>>>>>>> same lockless qdisc when there is no lock to synchronize the
>>>>>>>>>>> q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
>>>>>>>>>>> qdisc_deactivate() called by dev_deactivate_queue(), which may cause
>>>>>>>>>>> out-of-bounds access for priv->ring[] in hns3 driver if user has
>>>>>>>>>>> requested a smaller queue num when __dev_xmit_skb() still enqueue a
>>>>>>>>>>> skb with a larger queue_mapping after the corresponding qdisc is
>>>>>>>>>>> reset, and call hns3_nic_net_xmit() with that skb later.
>>>>>>>>>>
>>>>>>>>>> Can you be more specific here? Which call path requests a smaller
>>>>>>>>>> tx queue num? If you mean netif_set_real_num_tx_queues(), clearly
>>>>>>>>>> we already have a synchronize_net() there.
>>>>>>>>>
>>>>>>>>> When the netdevice is in active state, the synchronize_net() seems to
>>>>>>>>> do the correct work, as below:
>>>>>>>>>
>>>>>>>>> CPU 0:                                       CPU1:
>>>>>>>>> __dev_queue_xmit()                       netif_set_real_num_tx_queues()
>>>>>>>>> rcu_read_lock_bh();
>>>>>>>>> netdev_core_pick_tx(dev, skb, sb_dev);
>>>>>>>>>         .
>>>>>>>>>         .                               dev->real_num_tx_queues = txq;
>>>>>>>>>         .                                       .
>>>>>>>>>         .                                       .
>>>>>>>>>         .                               synchronize_net();
>>>>>>>>>         .                                       .
>>>>>>>>> q->enqueue()                                    .
>>>>>>>>>         .                                       .
>>>>>>>>> rcu_read_unlock_bh()                            .
>>>>>>>>>                                         qdisc_reset_all_tx_gt
>>>>>>>>>
>>>>>>>>>
>>>>>>>>
>>>>>>>> Right.
>>>>>>>>
>>>>>>>>
>>>>>>>>> but dev->real_num_tx_queues is not RCU-protected, maybe that is a problem
>>>>>>>>> too.
>>>>>>>>>
>>>>>>>>> The problem we hit is as below:
>>>>>>>>> In hns3_set_channels(), hns3_reset_notify(h, HNAE3_DOWN_CLIENT) is called
>>>>>>>>> to deactive the netdevice when user requested a smaller queue num, and
>>>>>>>>> txq->qdisc is already changed to noop_qdisc when calling
>>>>>>>>> netif_set_real_num_tx_queues(), so the synchronize_net() in the function
>>>>>>>>> netif_set_real_num_tx_queues() does not help here.
>>>>>>>>
>>>>>>>> How could qdisc still be running after deactivating the device?
>>>>>>>
>>>>>>> qdisc could be running during the device deactivating process.
>>>>>>>
>>>>>>> The main process of changing channel number is as below:
>>>>>>>
>>>>>>> 1. dev_deactivate()
>>>>>>> 2. hns3 handware related setup
>>>>>>> 3. netif_set_real_num_tx_queues()
>>>>>>> 4. netif_tx_wake_all_queues()
>>>>>>> 5. dev_activate()
>>>>>>>
>>>>>>> During step 1, qdisc could be running while qdisc is resetting, so
>>>>>>> there could be skb left in the old qdisc(which will be restored back to
>>>>>>> txq->qdisc during dev_activate()), as below:
>>>>>>>
>>>>>>> CPU 0:                                       CPU1:
>>>>>>> __dev_queue_xmit():                      dev_deactivate_many():
>>>>>>> rcu_read_lock_bh();                      qdisc_deactivate(qdisc);
>>>>>>> q = rcu_dereference_bh(txq->qdisc);             .
>>>>>>> netdev_core_pick_tx(dev, skb, sb_dev);          .
>>>>>>>         .
>>>>>>>         .                               rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
>>>>>>>         .                                       .
>>>>>>>         .                                       .
>>>>>>>         .                                       .
>>>>>>>         .                                       .
>>>>>>> q->enqueue()                                    .
>>>>>>
>>>>>>
>>>>>> Well, like I said, if the deactivated bit were tested before ->enqueue(),
>>>>>> there would be no packet queued after qdisc_deactivate().
> 
> Trying to unwind this through git history :/
> 
> Original code had a test_bit in dev_xmit_skb(),
> 
> 	if (q->flags & TCQ_F_NOLOCK) {
> 		if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED, &q->state))) {
> 			__qdisc_drop(skb, &to_free);
> 			rc = NET_XMIT_DROP;
> 		} else {
> 			rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> 			__qdisc_run(q);
> 		}
> 
> 		if (unlikely(to_free))
> 			kfree_skb_list(to_free);
> 		return rc;
> 	}
> 
> So we would never enqueue something on top of a deactivated qdisc. And to ensure
> we don't have any in-flight enqueues we have to swap qdiscs, wait a grace
> period, and then reset the qdisc. That _should_ be OK.

Actually, the deactivated is not really needed to be checked after swapping qdiscs
and waiting a grace period, because __dev_xmit_skb() only see the noop_qdisc now,
so qdisc_reset() in safe from q->enqueue()?

> 
> But, I'm still not entirely sure how you got here. In the drivers I did I always
> stop the queue before messing with these things with netif_tx_stop_queue(). Then
> we really should not get these packets into the driver.
> 
> In sch_direct_xmit():
> 
> 	if (likely(skb)) {
> 		HARD_TX_LOCK(dev, txq, smp_processor_id());
> 		if (!netif_xmit_frozen_or_stopped(txq))
> 			skb = dev_hard_start_xmit(skb, dev, txq, &ret);
> 
> 		HARD_TX_UNLOCK(dev, txq);
> 	} else {
> 		if (root_lock)
> 			spin_lock(root_lock);
> 		return true;
> 	}
> 
> Maybe I missed something? Does your driver use the netif_tx_stop/start APIs?

The hns3 driver uses netif_tx_stop_all_queues() in hns3_nic_net_stop() before
calling netif_carrier_off()

and call netif_tx_wake_all_queues() and netif_carrier_on() when link is detected
in hns3_link_status_change()

The main process of changing channel number is as below:
1. dev_deactivate()
2. hns3 handware related setup
3. netif_set_real_num_tx_queues()
4. netif_tx_wake_all_queues()
5. dev_activate()

During step 1, qdisc could be running while qdisc is resetting, so
there could be skb left in the old qdisc(which will be restored back to
txq->qdisc during dev_activate()), and the skb left in the old qdisc does not
get called with hns3's xmit function in step 1, but get called with hns3's xmit
function after step 5, because the old qdisc will be restored back to dev_queue->qdisc
after step 5, which still has the skb left.

Hope I did not misunderstand your question.

>  
>>>>>
>>>>> Only if the deactivated bit testing is also protected by qdisc->seqlock?
>>>>> otherwise there is still window between setting and testing the deactivated bit.
>>>>
>>>> Can you be more specific here? Why testing or setting a bit is not atomic?
>>>
>>> testing a bit or setting a bit separately is atomic.
>>> But testing a bit and setting a bit is not atomic, right?
>>>
>>>   cpu0:                   cpu1:
>>>                         testing A bit
>>> setting A bit                .
>>>        .                     .
>>>        .               qdisc enqueuing
>>> qdisc reset
>>>
>>
>> Well, this was not a problem until commit d518d2ed8640c1cbbb.
>> Prior to that commit, qdsic can still be scheduled even with this
>> race condition, that is, the packet just enqueued after resetting can
>> still be dequeued with qdisc_run().
>>
>> It is amazing to see how messy the lockless qdisc is now.
>>
>> Thanks.
> 
> 
> .
> 

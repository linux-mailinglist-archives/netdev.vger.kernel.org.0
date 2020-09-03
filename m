Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1EE825B83A
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 03:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgICBVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 21:21:13 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10757 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726586AbgICBVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 21:21:13 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 252F644608CD59A7BDEC;
        Thu,  3 Sep 2020 09:21:09 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Sep 2020 09:21:02 +0800
Subject: Re: [PATCH net-next] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
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
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <cd773132-c98e-18e1-67fd-bbef6babbf0f@huawei.com>
Date:   Thu, 3 Sep 2020 09:21:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXmpMdxF2JDOROaf+Tjk-8dASiXz53K-Ph_q7jVMe0oVw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/3 8:35, Cong Wang wrote:
> On Tue, Sep 1, 2020 at 11:35 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2020/9/2 12:41, Cong Wang wrote:
>>> On Tue, Sep 1, 2020 at 6:42 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>
>>>> On 2020/9/2 2:24, Cong Wang wrote:
>>>>> On Mon, Aug 31, 2020 at 5:59 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>>>
>>>>>> Currently there is concurrent reset and enqueue operation for the
>>>>>> same lockless qdisc when there is no lock to synchronize the
>>>>>> q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
>>>>>> qdisc_deactivate() called by dev_deactivate_queue(), which may cause
>>>>>> out-of-bounds access for priv->ring[] in hns3 driver if user has
>>>>>> requested a smaller queue num when __dev_xmit_skb() still enqueue a
>>>>>> skb with a larger queue_mapping after the corresponding qdisc is
>>>>>> reset, and call hns3_nic_net_xmit() with that skb later.
>>>>>
>>>>> Can you be more specific here? Which call path requests a smaller
>>>>> tx queue num? If you mean netif_set_real_num_tx_queues(), clearly
>>>>> we already have a synchronize_net() there.
>>>>
>>>> When the netdevice is in active state, the synchronize_net() seems to
>>>> do the correct work, as below:
>>>>
>>>> CPU 0:                                       CPU1:
>>>> __dev_queue_xmit()                       netif_set_real_num_tx_queues()
>>>> rcu_read_lock_bh();
>>>> netdev_core_pick_tx(dev, skb, sb_dev);
>>>>         .
>>>>         .                               dev->real_num_tx_queues = txq;
>>>>         .                                       .
>>>>         .                                       .
>>>>         .                               synchronize_net();
>>>>         .                                       .
>>>> q->enqueue()                                    .
>>>>         .                                       .
>>>> rcu_read_unlock_bh()                            .
>>>>                                         qdisc_reset_all_tx_gt
>>>>
>>>>
>>>
>>> Right.
>>>
>>>
>>>> but dev->real_num_tx_queues is not RCU-protected, maybe that is a problem
>>>> too.
>>>>
>>>> The problem we hit is as below:
>>>> In hns3_set_channels(), hns3_reset_notify(h, HNAE3_DOWN_CLIENT) is called
>>>> to deactive the netdevice when user requested a smaller queue num, and
>>>> txq->qdisc is already changed to noop_qdisc when calling
>>>> netif_set_real_num_tx_queues(), so the synchronize_net() in the function
>>>> netif_set_real_num_tx_queues() does not help here.
>>>
>>> How could qdisc still be running after deactivating the device?
>>
>> qdisc could be running during the device deactivating process.
>>
>> The main process of changing channel number is as below:
>>
>> 1. dev_deactivate()
>> 2. hns3 handware related setup
>> 3. netif_set_real_num_tx_queues()
>> 4. netif_tx_wake_all_queues()
>> 5. dev_activate()
>>
>> During step 1, qdisc could be running while qdisc is resetting, so
>> there could be skb left in the old qdisc(which will be restored back to
>> txq->qdisc during dev_activate()), as below:
>>
>> CPU 0:                                       CPU1:
>> __dev_queue_xmit():                      dev_deactivate_many():
>> rcu_read_lock_bh();                      qdisc_deactivate(qdisc);
>> q = rcu_dereference_bh(txq->qdisc);             .
>> netdev_core_pick_tx(dev, skb, sb_dev);          .
>>         .
>>         .                               rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
>>         .                                       .
>>         .                                       .
>>         .                                       .
>>         .                                       .
>> q->enqueue()                                    .
> 
> 
> Well, like I said, if the deactivated bit were tested before ->enqueue(),
> there would be no packet queued after qdisc_deactivate().

Only if the deactivated bit testing is also protected by qdisc->seqlock?
otherwise there is still window between setting and testing the deactivated bit.

> 
> 
>>         .                                       .
>> rcu_read_unlock_bh()                            .
>>
>> And During step 3, txq->qdisc is pointing to noop_qdisc, so the qdisc_reset()
>> only reset the noop_qdisc, but not the actual qdisc, which is stored in
>> txq->qdisc_sleeping, so the actual qdisc may still have skb.
>>
>> When hns3_link_status_change() call step 4 and 5, it will restore all queue's
>> qdisc using txq->qdisc_sleeping and schedule all queue with net_tx_action().
>> The skb enqueued in step 1 may be dequeued and run, which cause the problem.
>>
>>>
>>>
>>>>
>>>>>
>>>>>>
>>>>>> Avoid the above concurrent op by calling synchronize_rcu_tasks()
>>>>>> after assigning new qdisc to dev_queue->qdisc and before calling
>>>>>> qdisc_deactivate() to make sure skb with larger queue_mapping
>>>>>> enqueued to old qdisc will always be reset when qdisc_deactivate()
>>>>>> is called.
>>>>>
>>>>> Like Eric said, it is not nice to call such a blocking function when
>>>>> we have a large number of TX queues. Possibly we just need to
>>>>> add a synchronize_net() as in netif_set_real_num_tx_queues(),
>>>>> if it is missing.
>>>>
>>>> As above, the synchronize_net() in netif_set_real_num_tx_queues() seems
>>>> to work when netdevice is in active state, but does not work when in
>>>> deactive.
>>>
>>> Please explain why deactivated device still has qdisc running?
>>>
>>> At least before commit 379349e9bc3b4, we always test deactivate
>>> bit before enqueueing. Are you complaining about that commit?
>>> That commit is indeed suspicious, at least it does not precisely revert
>>> commit ba27b4cdaaa66561aaedb21 as it claims.
>>
>> I am not familiar with TCQ_F_CAN_BYPASS.
>> From my understanding, the problem is that there is no order between
>> qdisc enqueuing and qdisc reset.
> 
> It has almost nothing to do with BYPASS, my point here is all about
> __QDISC_STATE_DEACTIVATED bit, clearly commit 379349e9bc3b4
> removed this bit test for lockless qdisc, whether intentionally or accidentally.
> That bit test existed prior to BYPASS test, see commit ba27b4cdaaa665.

It seems there is no qdisc->seqlock or qdisc->seqlock to protect the
deactivated bit testing in commit ba27b4cdaaa665 too?

> 
> Thanks.
> .
> 

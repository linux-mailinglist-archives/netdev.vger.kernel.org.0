Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B566129E4AA
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbgJ2HmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:42:16 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7095 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbgJ2HmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:42:15 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CM93c6g2kzLpc0;
        Thu, 29 Oct 2020 10:53:00 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Thu, 29 Oct 2020 10:52:51 +0800
Subject: Re: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpX0_mz+McZdzZ7HFTjBihOKz5E6i4qJQSoFbZ=SZkVh=Q@mail.gmail.com>
 <830f85b5-ef29-c68e-c982-de20ac880bd9@huawei.com>
 <CAM_iQpU_tbRNO=Lznz_d6YjXmenYhowEfBoOiJgEmo9x8bEevw@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <1f8ebcde-f5ff-43df-960e-3661706e8d04@huawei.com>
Date:   Thu, 29 Oct 2020 10:52:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpU_tbRNO=Lznz_d6YjXmenYhowEfBoOiJgEmo9x8bEevw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/18 3:26, Cong Wang wrote:
> On Fri, Sep 11, 2020 at 1:13 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2020/9/11 4:07, Cong Wang wrote:
>>> On Tue, Sep 8, 2020 at 4:06 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>
>>>> Currently there is concurrent reset and enqueue operation for the
>>>> same lockless qdisc when there is no lock to synchronize the
>>>> q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
>>>> qdisc_deactivate() called by dev_deactivate_queue(), which may cause
>>>> out-of-bounds access for priv->ring[] in hns3 driver if user has
>>>> requested a smaller queue num when __dev_xmit_skb() still enqueue a
>>>> skb with a larger queue_mapping after the corresponding qdisc is
>>>> reset, and call hns3_nic_net_xmit() with that skb later.
>>>>
>>>> Reused the existing synchronize_net() in dev_deactivate_many() to
>>>> make sure skb with larger queue_mapping enqueued to old qdisc(which
>>>> is saved in dev_queue->qdisc_sleeping) will always be reset when
>>>> dev_reset_queue() is called.
>>>>
>>>> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
>>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>>> ---
>>>> ChangeLog V2:
>>>>         Reuse existing synchronize_net().
>>>> ---
>>>>  net/sched/sch_generic.c | 48 +++++++++++++++++++++++++++++++++---------------
>>>>  1 file changed, 33 insertions(+), 15 deletions(-)
>>>>
>>>> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
>>>> index 265a61d..54c4172 100644
>>>> --- a/net/sched/sch_generic.c
>>>> +++ b/net/sched/sch_generic.c
>>>> @@ -1131,24 +1131,10 @@ EXPORT_SYMBOL(dev_activate);
>>>>
>>>>  static void qdisc_deactivate(struct Qdisc *qdisc)
>>>>  {
>>>> -       bool nolock = qdisc->flags & TCQ_F_NOLOCK;
>>>> -
>>>>         if (qdisc->flags & TCQ_F_BUILTIN)
>>>>                 return;
>>>> -       if (test_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state))
>>>> -               return;
>>>> -
>>>> -       if (nolock)
>>>> -               spin_lock_bh(&qdisc->seqlock);
>>>> -       spin_lock_bh(qdisc_lock(qdisc));
>>>>
>>>>         set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
>>>> -
>>>> -       qdisc_reset(qdisc);
>>>> -
>>>> -       spin_unlock_bh(qdisc_lock(qdisc));
>>>> -       if (nolock)
>>>> -               spin_unlock_bh(&qdisc->seqlock);
>>>>  }
>>>>
>>>>  static void dev_deactivate_queue(struct net_device *dev,
>>>> @@ -1165,6 +1151,30 @@ static void dev_deactivate_queue(struct net_device *dev,
>>>>         }
>>>>  }
>>>>
>>>> +static void dev_reset_queue(struct net_device *dev,
>>>> +                           struct netdev_queue *dev_queue,
>>>> +                           void *_unused)
>>>> +{
>>>> +       struct Qdisc *qdisc;
>>>> +       bool nolock;
>>>> +
>>>> +       qdisc = dev_queue->qdisc_sleeping;
>>>> +       if (!qdisc)
>>>> +               return;
>>>> +
>>>> +       nolock = qdisc->flags & TCQ_F_NOLOCK;
>>>> +
>>>> +       if (nolock)
>>>> +               spin_lock_bh(&qdisc->seqlock);
>>>> +       spin_lock_bh(qdisc_lock(qdisc));
>>>
>>>
>>> I think you do not need this lock for lockless one.
>>
>> It seems so.
>> Maybe another patch to remove qdisc_lock(qdisc) for lockless
>> qdisc?
> 
> Yeah, but not sure if we still want this lockless qdisc any more,
> it brings more troubles than gains.
> 
>>
>>
>>>
>>>> +
>>>> +       qdisc_reset(qdisc);
>>>> +
>>>> +       spin_unlock_bh(qdisc_lock(qdisc));
>>>> +       if (nolock)
>>>> +               spin_unlock_bh(&qdisc->seqlock);
>>>> +}
>>>> +
>>>>  static bool some_qdisc_is_busy(struct net_device *dev)
>>>>  {
>>>>         unsigned int i;
>>>> @@ -1213,12 +1223,20 @@ void dev_deactivate_many(struct list_head *head)
>>>>                 dev_watchdog_down(dev);
>>>>         }
>>>>
>>>> -       /* Wait for outstanding qdisc-less dev_queue_xmit calls.
>>>> +       /* Wait for outstanding qdisc-less dev_queue_xmit calls or
>>>> +        * outstanding qdisc enqueuing calls.
>>>>          * This is avoided if all devices are in dismantle phase :
>>>>          * Caller will call synchronize_net() for us
>>>>          */
>>>>         synchronize_net();
>>>>
>>>> +       list_for_each_entry(dev, head, close_list) {
>>>> +               netdev_for_each_tx_queue(dev, dev_reset_queue, NULL);
>>>> +
>>>> +               if (dev_ingress_queue(dev))
>>>> +                       dev_reset_queue(dev, dev_ingress_queue(dev), NULL);
>>>> +       }
>>>> +
>>>>         /* Wait for outstanding qdisc_run calls. */
>>>>         list_for_each_entry(dev, head, close_list) {
>>>>                 while (some_qdisc_is_busy(dev)) {
>>>
>>> Do you want to reset before waiting for TX action?
>>>
>>> I think it is safer to do it after, at least prior to commit 759ae57f1b
>>> we did after.
>>
>> The reference to the txq->qdisc is always protected by RCU, so the synchronize_net()
>> should be enought to ensure there is no skb enqueued to the old qdisc that is saved
>> in the dev_queue->qdisc_sleeping, because __dev_queue_xmit can only see the new qdisc
>> after synchronize_net(), which is noop_qdisc, and noop_qdisc will make sure any skb
>> enqueued to it will be dropped and freed, right?
> 
> Hmm? In net_tx_action(), we do not hold RCU read lock, and we do not
> reference qdisc via txq->qdisc but via sd->output_queue.

Sorry for the delay reply, I seems to miss this.

I assumed synchronize_net() also wait for outstanding softirq to finish, right?

> 
> 
>>
>> If we do any additional reset that is not related to qdisc in dev_reset_queue(), we
>> can move it after some_qdisc_is_busy() checking.
> 
> I am not suggesting to do an additional reset, I am suggesting to move
> your reset after the busy waiting.

There maybe a deadlock here if we reset the qdisc after the some_qdisc_is_busy() checking,
because some_qdisc_is_busy() may require the qdisc reset to clear the skb, so that
some_qdisc_is_busy() can return false. I am not sure this is really a problem, but
sch_direct_xmit() may requeue the skb when dev_hard_start_xmit return TX_BUSY.

> 
> Thanks.
> .
> 

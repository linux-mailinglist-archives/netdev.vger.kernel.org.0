Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A952825B82A
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 03:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgICBOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 21:14:55 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10801 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726586AbgICBOy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 21:14:54 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EA716768DDFEF3071472;
        Thu,  3 Sep 2020 09:14:52 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Sep 2020 09:14:42 +0800
Subject: Re: [PATCH net-next] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Eric Dumazet <eric.dumazet@gmail.com>,
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
 <1f7208e6-8667-e542-88dd-bd80a6c59fd2@gmail.com>
 <6984825d-1ef7-bf58-75fe-cee1bafe3c1a@huawei.com>
 <df8423fb-63ed-604d-df4d-a94be5b47b31@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <041539d7-fb42-908d-5638-49ca51d758f1@huawei.com>
Date:   Thu, 3 Sep 2020 09:14:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <df8423fb-63ed-604d-df4d-a94be5b47b31@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/2 17:20, Eric Dumazet wrote:
> 
> 
> On 9/2/20 1:14 AM, Yunsheng Lin wrote:
>> On 2020/9/2 15:32, Eric Dumazet wrote:
>>>
>>>
>>> On 9/1/20 11:34 PM, Yunsheng Lin wrote:
>>>
>>>>
>>>> I am not familiar with TCQ_F_CAN_BYPASS.
>>>> From my understanding, the problem is that there is no order between
>>>> qdisc enqueuing and qdisc reset.
>>>
>>> Thw qdisc_reset() should be done after rcu grace period, when there is guarantee no enqueue is in progress.
>>>
>>> qdisc_destroy() already has a qdisc_reset() call, I am not sure why qdisc_deactivate() is also calling qdisc_reset()
>>
>> That is a good point.
>> Do we allow skb left in qdisc when the qdisc is deactivated state?
>> And qdisc_destroy() is not always called after qdisc_deactivate() is called.
>> If we allow skb left in qdisc when the qdisc is deactivated state, then it is
>> huge change of semantics for qdisc_deactivate(), and I am not sure how many
>> cases will affected by this change.
> 
> All I am saying is that the qdisc_reset() in qdisc_deactivate() seems
> at the wrong place.
> 
> This certainly can be deferred _after_ the rcu grace period we already have in dev_deactivate_many()
> 
> Something like this nicer patch.

Thanks for clarifying and the nicer patch.

Reusing the existing synchronize_net() is a good idea.

Some minor comment inline.

> 
>  net/sched/sch_generic.c |   22 ++++------------------
>  1 file changed, 4 insertions(+), 18 deletions(-)
> 
> 
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 265a61d011dfaa7ec0f8fb8aaede920784f690c9..0eaa99e4f8de643724c0942ee1a2e9516eed65c0 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -1131,24 +1131,10 @@ EXPORT_SYMBOL(dev_activate);
>  
>  static void qdisc_deactivate(struct Qdisc *qdisc)
>  {
> -       bool nolock = qdisc->flags & TCQ_F_NOLOCK;
> -
>         if (qdisc->flags & TCQ_F_BUILTIN)
>                 return;
> -       if (test_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state))
> -               return;
> -
> -       if (nolock)
> -               spin_lock_bh(&qdisc->seqlock);
> -       spin_lock_bh(qdisc_lock(qdisc));
>  
>         set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
> -
> -       qdisc_reset(qdisc);
> -
> -       spin_unlock_bh(qdisc_lock(qdisc));
> -       if (nolock)
> -               spin_unlock_bh(&qdisc->seqlock);
>  }
>  
>  static void dev_deactivate_queue(struct net_device *dev,
> @@ -1184,6 +1170,9 @@ static bool some_qdisc_is_busy(struct net_device *dev)
>                 val = (qdisc_is_running(q) ||
>                        test_bit(__QDISC_STATE_SCHED, &q->state));
>  
> +               if (!val)
> +                       qdisc_reset(q);

It seems semantics for some_qdisc_is_busy() is changed, which does not only do
the checking, but also do the reseting?

Also, qdisc_reset() could be called multi times for the same qdisc if some_qdisc_is_busy()
return true multi times?

> +
>                 spin_unlock_bh(root_lock);
>  
>                 if (val)
> @@ -1213,10 +1202,7 @@ void dev_deactivate_many(struct list_head *head)
>                 dev_watchdog_down(dev);
>         }
>  
> -       /* Wait for outstanding qdisc-less dev_queue_xmit calls.
> -        * This is avoided if all devices are in dismantle phase :
> -        * Caller will call synchronize_net() for us
> -        */
> +       /* Wait for outstanding dev_queue_xmit calls. */
>         synchronize_net();
>  
>         /* Wait for outstanding qdisc_run calls. */
> 
> 
> .
> 

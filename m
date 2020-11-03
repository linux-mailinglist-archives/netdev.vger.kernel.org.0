Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4BE2A3D9A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgKCHYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:24:46 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7447 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCHYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:24:46 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CQLrn1HbCzhd5q;
        Tue,  3 Nov 2020 15:24:41 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 3 Nov 2020 15:24:32 +0800
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
 <1f8ebcde-f5ff-43df-960e-3661706e8d04@huawei.com>
 <CAM_iQpUm91x8Q0G=CXE7S43DKryABkyMTa4mz_oEfEOTFS7BgQ@mail.gmail.com>
 <db770012-f22c-dff4-5311-bf4d17cd08e3@huawei.com>
 <CAM_iQpUBytX3qim3rXLkwjdX3DSKeF8YhyX6o=Jwr-R9Onb-HA@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <5472023c-b50b-0cb3-4cb6-7bbea42d3612@huawei.com>
Date:   Tue, 3 Nov 2020 15:24:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUBytX3qim3rXLkwjdX3DSKeF8YhyX6o=Jwr-R9Onb-HA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/11/3 0:55, Cong Wang wrote:
> On Fri, Oct 30, 2020 at 12:38 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2020/10/30 3:05, Cong Wang wrote:
>>>
>>> I do not see how and why it should. synchronize_net() is merely an optimized
>>> version of synchronize_rcu(), it should wait for RCU readers, softirqs are not
>>> necessarily RCU readers, net_tx_action() does not take RCU read lock either.
>>
>> Ok, make sense.
>>
>> Taking RCU read lock in net_tx_action() does not seems to solve the problem,
>> what about the time window between __netif_reschedule() and net_tx_action()?
>>
>> It seems we need to re-dereference the qdisc whenever RCU read lock is released
>> and qdisc is still in sd->output_queue or wait for the sd->output_queue to drain?
> 
> Not suggesting you to take RCU read lock. We already wait for TX action with
> a loop of sleep. To me, the only thing missing is just moving the
> reset after that
> wait.

__QDISC_STATE_SCHED is cleared before calling qdisc_run() in net_tx_action(),
some_qdisc_is_busy does not seem to wait fully for TX action, at least
qdisc is still being accessed even if __QDISC_STATE_DEACTIVATED is set.

> 
> 
>>>>>> If we do any additional reset that is not related to qdisc in dev_reset_queue(), we
>>>>>> can move it after some_qdisc_is_busy() checking.
>>>>>
>>>>> I am not suggesting to do an additional reset, I am suggesting to move
>>>>> your reset after the busy waiting.
>>>>
>>>> There maybe a deadlock here if we reset the qdisc after the some_qdisc_is_busy() checking,
>>>> because some_qdisc_is_busy() may require the qdisc reset to clear the skb, so that
>>>
>>> some_qdisc_is_busy() checks the status of qdisc, not the skb queue.
>>
>> Is there any reason why we do not check the skb queue in the dqisc?
>> It seems there may be skb left when netdev is deactivated, maybe at least warn
>> about that when there is still skb left when netdev is deactivated?
>> Is that why we call qdisc_reset() to clear the leftover skb in qdisc_destroy()?
>>
>>>
>>>
>>>> some_qdisc_is_busy() can return false. I am not sure this is really a problem, but
>>>> sch_direct_xmit() may requeue the skb when dev_hard_start_xmit return TX_BUSY.
>>>
>>> Sounds like another reason we should move the reset as late as possible?
>>
>> Why?
> 
> You said "sch_direct_xmit() may requeue the skb", I agree. I assume you mean
> net_tx_action() calls sch_direct_xmit() which does the requeue then races with
> reset. No?
> 

Look at current code again, I think there is no race between sch_direct_xmit()
in net_tx_action() and dev_reset_queue() in dev_deactivate_many(), because
qdisc_lock(qdisc) or qdisc->seqlock has been taken when calling sch_direct_xmit()
or dev_reset_queue().


> 
>>
>> There current netdev down order is mainly below:
>>
>> netif_tx_stop_all_queues()
>>
>> dev_deactivate_queue()
>>
>> synchronize_net()
>>
>> dev_reset_queue()
>>
>> some_qdisc_is_busy()
>>
>>
>> You suggest to change it to below order, right?
>>
>> netif_tx_stop_all_queues()
>>
>> dev_deactivate_queue()
>>
>> synchronize_net()
>>
>> some_qdisc_is_busy()
>>
>> dev_reset_queue()
> 
> Yes.
> 
>>
>>
>> What is the semantics of some_qdisc_is_busy()?
> 
> Waiting for flying TX action.

It wait for __QDISC_STATE_SCHED to clear and qdisc running to finish, but
there is still time window between __QDISC_STATE_SCHED clearing and qdisc
running, right?

> 
>> From my understanding, we can do anything about the old qdisc (including
>> destorying the old qdisc) after some_qdisc_is_busy() return false.
> 
> But the current code does the reset _before_ some_qdisc_is_busy(). ;)

If lock is taken when doing reset, it does not matter if the reset is
before some_qdisc_is_busy(), right?

> 
> Thanks.
> .
> 

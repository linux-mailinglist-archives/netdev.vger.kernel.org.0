Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E965258900
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 09:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgIAH1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 03:27:53 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:35722 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726006AbgIAH1x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 03:27:53 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6943F1D9A5E6AD60E4E8;
        Tue,  1 Sep 2020 15:27:51 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Sep 2020 15:27:43 +0800
Subject: Re: [PATCH net-next] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Eric Dumazet <eric.dumazet@gmail.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <john.fastabend@gmail.com>
References: <1598921718-79505-1-git-send-email-linyunsheng@huawei.com>
 <2d93706f-3ba6-128b-738a-b063216eba6d@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <2b60e7fd-a86a-89ab-2759-e7a83e0e28cd@huawei.com>
Date:   Tue, 1 Sep 2020 15:27:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <2d93706f-3ba6-128b-738a-b063216eba6d@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/1 14:48, Eric Dumazet wrote:
> 
> 
> On 8/31/20 5:55 PM, Yunsheng Lin wrote:
>> Currently there is concurrent reset and enqueue operation for the
>> same lockless qdisc when there is no lock to synchronize the
>> q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
>> qdisc_deactivate() called by dev_deactivate_queue(), which may cause
>> out-of-bounds access for priv->ring[] in hns3 driver if user has
>> requested a smaller queue num when __dev_xmit_skb() still enqueue a
>> skb with a larger queue_mapping after the corresponding qdisc is
>> reset, and call hns3_nic_net_xmit() with that skb later.
>>
>> Avoid the above concurrent op by calling synchronize_rcu_tasks()
>> after assigning new qdisc to dev_queue->qdisc and before calling
>> qdisc_deactivate() to make sure skb with larger queue_mapping
>> enqueued to old qdisc will always be reset when qdisc_deactivate()
>> is called.
>>
> 
> We request Fixes: tag for fixes in networking land.

ok.

Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")

> 
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>  net/sched/sch_generic.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
>> index 265a61d..6e42237 100644
>> --- a/net/sched/sch_generic.c
>> +++ b/net/sched/sch_generic.c
>> @@ -1160,8 +1160,13 @@ static void dev_deactivate_queue(struct net_device *dev,
>>  
>>  	qdisc = rtnl_dereference(dev_queue->qdisc);
>>  	if (qdisc) {
>> -		qdisc_deactivate(qdisc);
>>  		rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
>> +
>> +		/* Make sure lockless qdisc enqueuing is done with the
>> +		 * old qdisc in __dev_xmit_skb().
>> +		 */
>> +		synchronize_rcu_tasks();
> 
> This seems quite wrong, there is not a single use of synchronize_rcu_tasks() in net/,
> we probably do not want this.
> 
> I bet that synchronize_net() is appropriate, if not please explain/comment why we want this instead.

Using synchronize_net() seems more appropriate here, thanks.

> 
> Adding one synchronize_net() per TX queue is a killer for devices with 128 or 256 TX queues.
> 
> I would rather find a way of not calling qdisc_reset() from qdisc_deactivate().

Without calling qdisc_reset(), it seems there will always be skb left in the old qdisc.
Is above acceptable?

How about below steps to avoid the concurrent op:
1. assign new qdisc to all queue' qdisc(which is noop_qdisc).
2. call synchronize_net().
3. calling qdisc_reset() with all queue' qdisc_sleeping.

And the synchronize_net() in dev_deactivate_many() can be reused to
ensure old qdisc is not touched any more when calling qdisc_reset().


> 
> This lockless pfifo_fast is a mess really.
> 
> 
> .
> 

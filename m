Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70126340060
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 08:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhCRHqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 03:46:47 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5096 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhCRHqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 03:46:18 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4F1JvF5mtlzYLDW;
        Thu, 18 Mar 2021 15:44:25 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 18 Mar 2021 15:46:10 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Thu, 18 Mar
 2021 15:46:10 +0800
Subject: Re: [RFC v2] net: sched: implement TCQ_F_CAN_BYPASS for lockless
 qdisc
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>, <olteanv@gmail.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andriin@fb.com>,
        <edumazet@google.com>, <weiwan@google.com>,
        <cong.wang@bytedance.com>, <ap420073@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>
References: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
 <1615777818-13969-1-git-send-email-linyunsheng@huawei.com>
 <70d9f281-3b39-a760-1c2b-3598251f5770@pengutronix.de>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <3b4d7722-782f-7856-fd79-758796afa200@huawei.com>
Date:   Thu, 18 Mar 2021 15:46:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <70d9f281-3b39-a760-1c2b-3598251f5770@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/18 15:10, Ahmad Fatoum wrote:
> On 15.03.21 04:10, Yunsheng Lin wrote:
>> Currently pfifo_fast has both TCQ_F_CAN_BYPASS and TCQ_F_NOLOCK
>> flag set, but queue discipline by-pass does not work for lockless
>> qdisc because skb is always enqueued to qdisc even when the qdisc
>> is empty, see __dev_xmit_skb().
>>
>> This patch calls sch_direct_xmit() to transmit the skb directly
>> to the driver for empty lockless qdisc too, which aviod enqueuing
>> and dequeuing operation. qdisc->empty is set to false whenever a
>> skb is enqueued, see pfifo_fast_enqueue(), and is set to true when
>> skb dequeuing return NULL, see pfifo_fast_dequeue(), a spinlock is
>> added to avoid the race between enqueue/dequeue and qdisc->empty
>> setting.
>>
>> If there is requeued skb in q->gso_skb, and qdisc->empty is true,
>> do not allow bypassing requeued skb. enqueuing and dequeuing in
>> q->gso_skb is always protected by qdisc->seqlock, so is the access
>> of q->gso_skb by skb_queue_empty();
>>
>> Also, qdisc is scheduled at the end of qdisc_run_end() when q->empty
>> is false to avoid packet stuck problem.
>>
>> The performance for ip_forward test increases about 10% with this
>> patch.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>> RFC V2: fix requeued skb out of order and data race problem.
> 
> cansequence didn't find any frame reordering with 2 FlexCAN's communicating
> with each other on a dual core i.MX6. Feel free to add:
> 
> Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

Thanks for testing.
Actually I has a newer implemetion that canget rid of the priv->lock
added in this patch.
I am not sending it out yet:
1. There is a packet stuck problem for lockless qdisc I try to fix,
   see [1], and I prefer not to add more optimization to lockless
   qdisc before we find out real cause, it will make backporting
   packet stuck patch harder and optimization is useless if there
   is still basic bug for lockless qdisc
2. I am still not convinced that the lockless implemetion is clearer
   than the priv->lock implemetion, I still need to do some thinking
   and testing.


> 
>> ---
>>  include/net/pkt_sched.h   |  2 ++
>>  include/net/sch_generic.h |  7 +++++--
>>  net/core/dev.c            | 14 ++++++++++++++
>>  net/sched/sch_generic.c   | 31 ++++++++++++++++++++++++++++++-
>>  4 files changed, 51 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
>> index f5c1bee..c760f6a 100644
>> --- a/include/net/pkt_sched.h
>> +++ b/include/net/pkt_sched.h
>> @@ -122,6 +122,8 @@ void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc);
>>  bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
>>  		     struct net_device *dev, struct netdev_queue *txq,
>>  		     spinlock_t *root_lock, bool validate);
>> +bool sch_may_need_requeuing(struct sk_buff *skb, struct Qdisc *q,
>> +			    struct net_device *dev);
>>  
>>  void __qdisc_run(struct Qdisc *q);
>>  
>> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
>> index 2d6eb60..6591356 100644
>> --- a/include/net/sch_generic.h
>> +++ b/include/net/sch_generic.h
>> @@ -161,7 +161,6 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>>  	if (qdisc->flags & TCQ_F_NOLOCK) {
>>  		if (!spin_trylock(&qdisc->seqlock))
>>  			return false;
>> -		WRITE_ONCE(qdisc->empty, false);
>>  	} else if (qdisc_is_running(qdisc)) {
>>  		return false;
>>  	}
>> @@ -176,8 +175,12 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>>  static inline void qdisc_run_end(struct Qdisc *qdisc)
>>  {
>>  	write_seqcount_end(&qdisc->running);
>> -	if (qdisc->flags & TCQ_F_NOLOCK)
>> +	if (qdisc->flags & TCQ_F_NOLOCK) {
>>  		spin_unlock(&qdisc->seqlock);
>> +
>> +		if (unlikely(!READ_ONCE(qdisc->empty)))
>> +			__netif_schedule(qdisc);
>> +	}
>>  }
>>  
>>  static inline bool qdisc_may_bulk(const struct Qdisc *qdisc)
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 2bfdd52..8f4afb6 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -3791,6 +3791,20 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>>  	qdisc_calculate_pkt_len(skb, q);
>>  
>>  	if (q->flags & TCQ_F_NOLOCK) {
>> +		if (q->flags & TCQ_F_CAN_BYPASS && READ_ONCE(q->empty) &&
>> +		    qdisc_run_begin(q)) {
>> +			qdisc_bstats_cpu_update(q, skb);
>> +
>> +			if (sch_may_need_requeuing(skb, q, dev))
>> +				__qdisc_run(q);
>> +			else if (sch_direct_xmit(skb, q, dev, txq, NULL, true) &&
>> +				 !READ_ONCE(q->empty))
>> +				__qdisc_run(q);
>> +
>> +			qdisc_run_end(q);
>> +			return NET_XMIT_SUCCESS;
>> +		}
>> +
>>  		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
>>  		qdisc_run(q);
>>  
>> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
>> index 49eae93..0df1462 100644
>> --- a/net/sched/sch_generic.c
>> +++ b/net/sched/sch_generic.c
>> @@ -273,6 +273,23 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
>>  	return skb;
>>  }
>>  
>> +bool sch_may_need_requeuing(struct sk_buff *skb, struct Qdisc *q,
>> +			    struct net_device *dev)
>> +{
>> +	bool again = false;
>> +
>> +	if (likely(skb_queue_empty(&q->gso_skb)))
>> +		return false;
>> +
>> +	/* need validating before requeuing */
>> +	skb = validate_xmit_skb_list(skb, dev, &again);
>> +	if (unlikely(!skb))
>> +		return true;
>> +
>> +	dev_requeue_skb(skb, q);
>> +	return true;
>> +}
>> +
>>  /*
>>   * Transmit possibly several skbs, and handle the return status as
>>   * required. Owning running seqcount bit guarantees that
>> @@ -606,6 +623,11 @@ static const u8 prio2band[TC_PRIO_MAX + 1] = {
>>   */
>>  struct pfifo_fast_priv {
>>  	struct skb_array q[PFIFO_FAST_BANDS];
>> +
>> +	/* protect against data race between enqueue/dequeue and
>> +	 * qdisc->empty setting
>> +	 */
>> +	spinlock_t lock;
>>  };
>>  
>>  static inline struct skb_array *band2list(struct pfifo_fast_priv *priv,
>> @@ -623,7 +645,10 @@ static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc *qdisc,
>>  	unsigned int pkt_len = qdisc_pkt_len(skb);
>>  	int err;
>>  
>> -	err = skb_array_produce(q, skb);
>> +	spin_lock(&priv->lock);
>> +	err = __ptr_ring_produce(&q->ring, skb);
>> +	WRITE_ONCE(qdisc->empty, false);
>> +	spin_unlock(&priv->lock);
>>  
>>  	if (unlikely(err)) {
>>  		if (qdisc_is_percpu_stats(qdisc))
>> @@ -642,6 +667,7 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
>>  	struct sk_buff *skb = NULL;
>>  	int band;
>>  
>> +	spin_lock(&priv->lock);
>>  	for (band = 0; band < PFIFO_FAST_BANDS && !skb; band++) {
>>  		struct skb_array *q = band2list(priv, band);
>>  
>> @@ -655,6 +681,7 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
>>  	} else {
>>  		WRITE_ONCE(qdisc->empty, true);
>>  	}
>> +	spin_unlock(&priv->lock);
>>  
>>  	return skb;
>>  }
>> @@ -739,6 +766,8 @@ static int pfifo_fast_init(struct Qdisc *qdisc, struct nlattr *opt,
>>  
>>  	/* Can by-pass the queue discipline */
>>  	qdisc->flags |= TCQ_F_CAN_BYPASS;
>> +
>> +	spin_lock_init(&priv->lock);
>>  	return 0;
>>  }
>>  
>>
> 


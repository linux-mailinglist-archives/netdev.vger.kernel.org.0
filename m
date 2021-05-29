Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC1B3949E1
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 03:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhE2Bqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 21:46:39 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5136 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhE2Bqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 21:46:37 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FsPS94TrNzYmnV;
        Sat, 29 May 2021 09:42:17 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 09:44:58 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Sat, 29 May
 2021 09:44:58 +0800
Subject: Re: [PATCH net-next 2/3] net: sched: implement TCQ_F_CAN_BYPASS for
 lockless qdisc
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <olteanv@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andriin@fb.com>, <edumazet@google.com>,
        <weiwan@google.com>, <cong.wang@bytedance.com>,
        <ap420073@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <mkl@pengutronix.de>, <linux-can@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
References: <1622170197-27370-1-git-send-email-linyunsheng@huawei.com>
 <1622170197-27370-3-git-send-email-linyunsheng@huawei.com>
 <20210528180012.676797d6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <a6a965ee-7368-d37b-9c70-bba50c67eec9@huawei.com>
Date:   Sat, 29 May 2021 09:44:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210528180012.676797d6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme705-chm.china.huawei.com (10.1.199.101) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/29 9:00, Jakub Kicinski wrote:
> On Fri, 28 May 2021 10:49:56 +0800 Yunsheng Lin wrote:
>> Currently pfifo_fast has both TCQ_F_CAN_BYPASS and TCQ_F_NOLOCK
>> flag set, but queue discipline by-pass does not work for lockless
>> qdisc because skb is always enqueued to qdisc even when the qdisc
>> is empty, see __dev_xmit_skb().
>>
>> This patch calls sch_direct_xmit() to transmit the skb directly
>> to the driver for empty lockless qdisc, which aviod enqueuing
>> and dequeuing operation.
>>
>> As qdisc->empty is not reliable to indicate a empty qdisc because
>> there is a time window between enqueuing and setting qdisc->empty.
>> So we use the MISSED state added in commit a90c57f2cedd ("net:
>> sched: fix packet stuck problem for lockless qdisc"), which
>> indicate there is lock contention, suggesting that it is better
>> not to do the qdisc bypass in order to avoid packet out of order
>> problem.
>>
>> In order to make MISSED state reliable to indicate a empty qdisc,
>> we need to ensure that testing and clearing of MISSED state is
>> within the protection of qdisc->seqlock, only setting MISSED state
>> can be done without the protection of qdisc->seqlock. A MISSED
>> state testing is added without the protection of qdisc->seqlock to
>> aviod doing unnecessary spin_trylock() for contention case.
>>
>> There are below cases that need special handling:
>> 1. When MISSED state is cleared before another round of dequeuing
>>    in pfifo_fast_dequeue(), and __qdisc_run() might not be able to
>>    dequeue all skb in one round and call __netif_schedule(), which
>>    might result in a non-empty qdisc without MISSED set. In order
>>    to avoid this, the MISSED state is set for lockless qdisc and
>>    __netif_schedule() will be called at the end of qdisc_run_end.
>>
>> 2. The MISSED state also need to be set for lockless qdisc instead
>>    of calling __netif_schedule() directly when requeuing a skb for
>>    a similar reason.
>>
>> 3. For netdev queue stopped case, the MISSED case need clearing
>>    while the netdev queue is stopped, otherwise there may be
>>    unnecessary __netif_schedule() calling. So a new DRAINING state
>>    is added to indicate this case, which also indicate a non-empty
>>    qdisc.
>>
>> 4. As there is already netif_xmit_frozen_or_stopped() checking in
>>    dequeue_skb() and sch_direct_xmit(), which are both within the
>>    protection of qdisc->seqlock, but the same checking in
>>    __dev_xmit_skb() is without the protection, which might cause
>>    empty indication of a lockless qdisc to be not reliable. So
>>    remove the checking in __dev_xmit_skb(), and the checking in
>>    the protection of qdisc->seqlock seems enough to avoid the cpu
>>    consumption problem for netdev queue stopped case.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> 
>> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
>> index 3ed6bcc..177f240 100644
>> --- a/include/net/sch_generic.h
>> +++ b/include/net/sch_generic.h
>> @@ -37,8 +37,15 @@ enum qdisc_state_t {
>>  	__QDISC_STATE_SCHED,
>>  	__QDISC_STATE_DEACTIVATED,
>>  	__QDISC_STATE_MISSED,
>> +	__QDISC_STATE_DRAINING,
>>  };
>>  
>> +#define QDISC_STATE_MISSED	BIT(__QDISC_STATE_MISSED)
>> +#define QDISC_STATE_DRAINING	BIT(__QDISC_STATE_DRAINING)
>> +
>> +#define QDISC_STATE_NON_EMPTY	(QDISC_STATE_MISSED | \
>> +					QDISC_STATE_DRAINING)
>> +
>>  struct qdisc_size_table {
>>  	struct rcu_head		rcu;
>>  	struct list_head	list;
>> @@ -145,6 +152,11 @@ static inline bool qdisc_is_running(struct Qdisc *qdisc)
>>  	return (raw_read_seqcount(&qdisc->running) & 1) ? true : false;
>>  }
>>  
>> +static inline bool nolock_qdisc_is_empty(const struct Qdisc *qdisc)
>> +{
>> +	return !(READ_ONCE(qdisc->state) & QDISC_STATE_NON_EMPTY);
>> +}
>> +
>>  static inline bool qdisc_is_percpu_stats(const struct Qdisc *q)
>>  {
>>  	return q->flags & TCQ_F_CPUSTATS;
>> @@ -206,10 +218,8 @@ static inline void qdisc_run_end(struct Qdisc *qdisc)
>>  		spin_unlock(&qdisc->seqlock);
>>  
>>  		if (unlikely(test_bit(__QDISC_STATE_MISSED,
>> -				      &qdisc->state))) {
>> -			clear_bit(__QDISC_STATE_MISSED, &qdisc->state);
>> +				      &qdisc->state)))
> 
> Why remove the clear_bit()? Wasn't that added to avoid infinite
> re-schedules?

As we has also clear the MISSED for stopped and deactived case, so
the above clear_bit() is necessarily needed, it was added because
of the 0.02Mpps improvement for the 16 thread pktgen test case.

As we need to ensure clearing is within the protection of q->seqlock,
and above clear_bit is not within the protection, so remove the
clear_bit() above.

> 
>>  			__netif_schedule(qdisc);
>> -		}
>>  	} else {
>>  		write_seqcount_end(&qdisc->running);
>>  	}
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 50531a2..e4cc926 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -3852,10 +3852,32 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>>  	qdisc_calculate_pkt_len(skb, q);
>>  
>>  	if (q->flags & TCQ_F_NOLOCK) {
>> +		if (q->flags & TCQ_F_CAN_BYPASS && nolock_qdisc_is_empty(q) &&
>> +		    qdisc_run_begin(q)) {
>> +			/* Retest nolock_qdisc_is_empty() within the protection
>> +			 * of q->seqlock to ensure qdisc is indeed empty.
>> +			 */
>> +			if (unlikely(!nolock_qdisc_is_empty(q))) {
> 
> This is just for the DRAINING case right? 
> 
> MISSED can be set at any moment, testing MISSED seems confusing.

MISSED is only set when there is lock contention, which means it
is better not to do the qdisc bypass to avoid out of order packet
problem, another good thing is that we could also do the batch
dequeuing and transmiting of packets when there is lock contention.

> 
> Is it really worth the extra code?

Currently DRAINING is only set for the netdev queue stopped.
We could only use DRAINING to indicate the non-empty of a qdisc,
then we need to set the DRAINING evrywhere MISSED is set, that is
why I use both DRAINING and MISSED to indicate a non-empty qdisc.

> 
>> +				rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
>> +				__qdisc_run(q);
>> +				qdisc_run_end(q);
>> +
>> +				goto no_lock_out;
>> +			}
>> +
>> +			qdisc_bstats_cpu_update(q, skb);
>> +			if (sch_direct_xmit(skb, q, dev, txq, NULL, true) &&
>> +			    !nolock_qdisc_is_empty(q))
>> +				__qdisc_run(q);
>> +
>> +			qdisc_run_end(q);
>> +			return NET_XMIT_SUCCESS;
>> +		}
>> +
>>  		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
>> -		if (likely(!netif_xmit_frozen_or_stopped(txq)))
>> -			qdisc_run(q);
>> +		qdisc_run(q);
>>  
>> +no_lock_out:
>>  		if (unlikely(to_free))
>>  			kfree_skb_list(to_free);
>>  		return rc;
>> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
>> index fc8b56b..83d7f5f 100644
>> --- a/net/sched/sch_generic.c
>> +++ b/net/sched/sch_generic.c
>> @@ -52,6 +52,8 @@ static void qdisc_maybe_clear_missed(struct Qdisc *q,
>>  	 */
>>  	if (!netif_xmit_frozen_or_stopped(txq))
>>  		set_bit(__QDISC_STATE_MISSED, &q->state);
>> +	else
>> +		set_bit(__QDISC_STATE_DRAINING, &q->state);
>>  }
>>  
>>  /* Main transmission queue. */
>> @@ -164,9 +166,13 @@ static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
>>  
>>  		skb = next;
>>  	}
>> -	if (lock)
>> +
>> +	if (lock) {
>>  		spin_unlock(lock);
>> -	__netif_schedule(q);
>> +		set_bit(__QDISC_STATE_MISSED, &q->state);
>> +	} else {
>> +		__netif_schedule(q);
> 
> Could we reorder qdisc_run_begin() with clear_bit(SCHED) 
> in net_tx_action() and add SCHED to the NON_EMPTY mask?

Did you mean clearing the SCHED after the q->seqlock is
taken?

The problem is that the SCHED is also used to indicate
a qdisc is in sd->output_queue or not, and the
qdisc_run_begin() called by net_tx_action() can not
guarantee it will take the q->seqlock(we are using trylock
for lockless qdisc)

> 
>> +	}
>>  }
>>  
>>  static void try_bulk_dequeue_skb(struct Qdisc *q,
>> @@ -409,7 +415,11 @@ void __qdisc_run(struct Qdisc *q)
>>  	while (qdisc_restart(q, &packets)) {
>>  		quota -= packets;
>>  		if (quota <= 0) {
>> -			__netif_schedule(q);
>> +			if (q->flags & TCQ_F_NOLOCK)
>> +				set_bit(__QDISC_STATE_MISSED, &q->state);
>> +			else
>> +				__netif_schedule(q);
>> +
>>  			break;
>>  		}
>>  	}
>> @@ -680,13 +690,14 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
>>  	if (likely(skb)) {
>>  		qdisc_update_stats_at_dequeue(qdisc, skb);
>>  	} else if (need_retry &&
>> -		   test_bit(__QDISC_STATE_MISSED, &qdisc->state)) {
>> +		   READ_ONCE(qdisc->state) & QDISC_STATE_NON_EMPTY) {
> 
> Do we really need to retry based on DRAINING being set?
> Or is it just a convenient way of coding things up?

Yes, it is just a convenient way of coding things up.
Only MISSED need retrying.

> 
>>  		/* Delay clearing the STATE_MISSED here to reduce
>>  		 * the overhead of the second spin_trylock() in
>>  		 * qdisc_run_begin() and __netif_schedule() calling
>>  		 * in qdisc_run_end().
>>  		 */
>>  		clear_bit(__QDISC_STATE_MISSED, &qdisc->state);
>> +		clear_bit(__QDISC_STATE_DRAINING, &qdisc->state);
> 
> 
> 
> .
> 


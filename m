Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424D2363946
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 04:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbhDSCFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 22:05:02 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3339 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbhDSCFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 22:05:02 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FNqlw2NJSz149bL;
        Mon, 19 Apr 2021 10:00:44 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml406-hub.china.huawei.com (10.3.17.50) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Mon, 19 Apr 2021 10:04:28 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 19 Apr
 2021 10:04:28 +0800
Subject: Re: [PATCH net v3] net: sched: fix packet stuck problem for lockless
 qdisc
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     Juergen Gross <jgross@suse.com>, Jiri Kosina <jikos@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <olteanv@gmail.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andriin@fb.com>,
        <edumazet@google.com>, <weiwan@google.com>,
        <cong.wang@bytedance.com>, <ap420073@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>
References: <1616641991-14847-1-git-send-email-linyunsheng@huawei.com>
 <20210418225956.a6ot6xox4eq6cvv5@lion.mk-sys.cz>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <a50daff3-c716-f11c-4dfa-c5c1f85a9e12@huawei.com>
Date:   Mon, 19 Apr 2021 10:04:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210418225956.a6ot6xox4eq6cvv5@lion.mk-sys.cz>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/19 6:59, Michal Kubecek wrote:
> On Thu, Mar 25, 2021 at 11:13:11AM +0800, Yunsheng Lin wrote:
>> Lockless qdisc has below concurrent problem:
>>     cpu0                 cpu1
>>      .                     .
>> q->enqueue                 .
>>      .                     .
>> qdisc_run_begin()          .
>>      .                     .
>> dequeue_skb()              .
>>      .                     .
>> sch_direct_xmit()          .
>>      .                     .
>>      .                q->enqueue
>>      .             qdisc_run_begin()
>>      .            return and do nothing
>>      .                     .
>> qdisc_run_end()            .
>>
>> cpu1 enqueue a skb without calling __qdisc_run() because cpu0
>> has not released the lock yet and spin_trylock() return false
>> for cpu1 in qdisc_run_begin(), and cpu0 do not see the skb
>> enqueued by cpu1 when calling dequeue_skb() because cpu1 may
>> enqueue the skb after cpu0 calling dequeue_skb() and before
>> cpu0 calling qdisc_run_end().
>>
>> Lockless qdisc has below another concurrent problem when
>> tx_action is involved:
>>
>> cpu0(serving tx_action)     cpu1             cpu2
>>           .                   .                .
>>           .              q->enqueue            .
>>           .            qdisc_run_begin()       .
>>           .              dequeue_skb()         .
>>           .                   .            q->enqueue
>>           .                   .                .
>>           .             sch_direct_xmit()      .
>>           .                   .         qdisc_run_begin()
>>           .                   .       return and do nothing
>>           .                   .                .
>>  clear __QDISC_STATE_SCHED    .                .
>>  qdisc_run_begin()            .                .
>>  return and do nothing        .                .
>>           .                   .                .
>>           .            qdisc_run_end()         .
>>
>> This patch fixes the above data race by:
>> 1. Get the flag before doing spin_trylock().
>> 2. If the first spin_trylock() return false and the flag is not
>>    set before the first spin_trylock(), Set the flag and retry
>>    another spin_trylock() in case other CPU may not see the new
>>    flag after it releases the lock.
>> 3. reschedule if the flags is set after the lock is released
>>    at the end of qdisc_run_end().
>>
>> For tx_action case, the flags is also set when cpu1 is at the
>> end if qdisc_run_end(), so tx_action will be rescheduled
>> again to dequeue the skb enqueued by cpu2.
>>
>> Only clear the flag before retrying a dequeuing when dequeuing
>> returns NULL in order to reduce the overhead of the above double
>> spin_trylock() and __netif_schedule() calling.
>>
>> The performance impact of this patch, tested using pktgen and
>> dummy netdev with pfifo_fast qdisc attached:
>>
>>  threads  without+this_patch   with+this_patch      delta
>>     1        2.61Mpps            2.60Mpps           -0.3%
>>     2        3.97Mpps            3.82Mpps           -3.7%
>>     4        5.62Mpps            5.59Mpps           -0.5%
>>     8        2.78Mpps            2.77Mpps           -0.3%
>>    16        2.22Mpps            2.22Mpps           -0.0%
>>
>> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>> V3: fix a compile error and a few comment typo, remove the
>>     __QDISC_STATE_DEACTIVATED checking, and update the
>>     performance data.
>> V2: Avoid the overhead of fixing the data race as much as
>>     possible.
> 
> I tried this patch o top of 5.12-rc7 with real devices. I used two
> machines with 10Gb/s Intel ixgbe NICs, sender has 16 CPUs (2 8-core CPUs
> with HT disabled) and 16 Rx/Tx queues, receiver has 48 CPUs (2 12-core
> CPUs with HT enabled) and 48 Rx/Tx queues. With multiple TCP streams on
> a saturated ethernet, the CPU consumption grows quite a lot:
> 
>     threads     unpatched 5.12-rc7    5.12-rc7 + v3   
>       1               25.6%               30.6%
>       8               73.1%              241.4%
>     128              132.2%             1012.0%
> 
> (The values are normalized to one core, i.e. 100% corresponds to one
> fully used logical CPU.) I didn't perform a full statistical evaluation
> but the growth is way beyond any statistical fluctuation with one
> exception: 8-thread test of patched kernel showed values from 155.5% to
> 311.4%. Closer look shows that most of the CPU time was spent in softirq
> and running top in parallel with the test confirms that there are
> multiple ksofirqd threads running at 100% CPU. I had similar problem
> with earlier versions of my patch (work in progress, I still need to
> check some corner cases and write commit message explaining the logic)

Great, if there is a better idea, maybe share the core idea first so
that we both can work on the that?

> and tracing confirmed that similar problem (non-empty queue, no other
> thread going to clean it up but device queue stopped) was happening
> repeatedly most of the time.

Make sense, maybe that is why the dummy netdevice can not catch this kind
of performance degradation because it always consume the skb without stopping
the tx queue, and a real netdevice with limited queue depth may stop the
queue when there are multil skbs queuing concurrently.

I think for the above to happen, there may be a lot of tx doorbell batching
happening, it would be better to see how many packets is enqueued at a time
when trace_qdisc_dequeue() tracepoint is enabled?

> 
> The biggest problem IMHO is that the loop in __qdisc_run() may finish
> without rescheduling not only when the qdisc queue is empty but also
> when the corresponding device Tx queue is stopped which devices tend to
> do whenever they cannot send any more packets out. Thus whenever
> __QDISC_STATE_NEED_RESCHEDULE is set with device queue stopped or
> frozen, we keep rescheduling the queue cleanup without any chance to
> progress or clear __QDISC_STATE_NEED_RESCHEDULE. For this to happen, all
> we need is another thready to fail the first spin_trylock() while device
> queue is stopped and qdisc queue not empty.

Yes, We could just return false before doing the second spin_trylock() if
the netdev queue corresponding qdisc is stopped, and when the netdev queue
is restarted, __netif_schedule() is called again, see netif_tx_wake_queue().

Maybe add a sch_qdisc_stopped() function and do the testting in qdisc_run_begin:

if (dont_retry || sch_qdisc_stopped())
	return false;

bool sch_qdisc_stopped(struct Qdisc *q)
{
	const struct netdev_queue *txq = q->dev_queue;

	if (!netif_xmit_frozen_or_stopped(txq))
		return true;

	reture false;
}

At least for qdisc with TCQ_F_ONETXQUEUE flags set is doable?

> 
> Another part of the problem may be that to avoid the race, the logic is
> too pessimistic: consider e.g. (dotted lines show "barriers" where
> ordering is important):
> 
>     CPU A                            CPU B
>     spin_trylock() succeeds
>                                      pfifo_fast_enqueue()
>     ..................................................................
>     skb_array empty, exit loop
>                                      first spin_trylock() fails
>                                      set __QDISC_STATE_NEED_RESCHEDULE
>                                      second spin_trylock() fails
>     ..................................................................
>     spin_unlock()
>     call __netif_schedule()
> 
> When we switch the order of spin_lock() on CPU A and second
> spin_trylock() on CPU B (but keep setting __QDISC_STATE_NEED_RESCHEDULE
> before CPU A tests it), we end up scheduling a queue cleanup even if
> there is already one running. And either of these is quite realistic.

But I am not sure it is a good thing or bad thing when the above happen,
because it may be able to enable the tx batching?

> 
>> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
>> index f7a6e14..e3f46eb 100644
>> --- a/include/net/sch_generic.h
>> +++ b/include/net/sch_generic.h
>> @@ -36,6 +36,7 @@ struct qdisc_rate_table {
>>  enum qdisc_state_t {
>>  	__QDISC_STATE_SCHED,
>>  	__QDISC_STATE_DEACTIVATED,
>> +	__QDISC_STATE_NEED_RESCHEDULE,
>>  };
> 
> I'm not sure if putting the flag here is a good idea. If you look at the
> history of struct Qdisc reshufflings, this part (cacheline) should be
> used for members which don't change too often. However, this new flag is
> going to be touched about as often and in similar places as q->seqlock
> or q->empty so that it should probably be in the last cacheline with
> them.

I am not sure about that too, but we can always adjust it's location
if it provdes to be the case:)

> 
> [...]
>> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
>> index 44991ea..4953430 100644
>> --- a/net/sched/sch_generic.c
>> +++ b/net/sched/sch_generic.c
>> @@ -640,8 +640,10 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
>>  {
>>  	struct pfifo_fast_priv *priv = qdisc_priv(qdisc);
>>  	struct sk_buff *skb = NULL;
>> +	bool need_retry = true;
>>  	int band;
>>  
>> +retry:
>>  	for (band = 0; band < PFIFO_FAST_BANDS && !skb; band++) {
>>  		struct skb_array *q = band2list(priv, band);
>>  
>> @@ -652,6 +654,16 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
>>  	}
>>  	if (likely(skb)) {
>>  		qdisc_update_stats_at_dequeue(qdisc, skb);
>> +	} else if (need_retry &&
>> +		   test_and_clear_bit(__QDISC_STATE_NEED_RESCHEDULE,
>> +				      &qdisc->state)) {
>> +		/* do another enqueuing after clearing the flag to
>> +		 * avoid calling __netif_schedule().
>> +		 */
>> +		smp_mb__after_atomic();
>> +		need_retry = false;
>> +
>> +		goto retry;
>>  	} else {
>>  		WRITE_ONCE(qdisc->empty, true);
>>  	}i
> 
> Does the retry really provide significant improvement? IIUC it only
> helps if all of enqueue, first spin_trylock() failure and setting the
> __QDISC_STATE_NEED_RESCHEDULE flag happen between us finding the
> skb_array empty and checking the flag. If enqueue happens before we
> check the array (and flag is set before the check), the retry is
> useless. If the flag is set after we check it, we don't catch it (no
> matter if the enqueue happened before or after we found skb_array
> empty).

In odrder to avoid doing the "set_bit(__QDISC_STATE_MISSED, &qdisc->state)"
as much as possible, the __QDISC_STATE_NEED_RESCHEDULE need to be set as
as much as possible, so only clear __QDISC_STATE_NEED_RESCHEDULE when the
queue is empty.
And it has about 5% performance improvement.

> 
> Michal
> 
> .
> 


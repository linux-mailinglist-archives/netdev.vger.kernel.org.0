Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA34376F00
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 04:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhEHC4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 22:56:24 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3544 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhEHC4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 22:56:23 -0400
Received: from dggeml754-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FcWzL5GbXzWf0d;
        Sat,  8 May 2021 10:51:10 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml754-chm.china.huawei.com (10.1.199.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 8 May 2021 10:55:20 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Sat, 8 May 2021
 10:55:20 +0800
Subject: Re: [PATCH net v5 1/3] net: sched: fix packet stuck problem for
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
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>
References: <1620266264-48109-1-git-send-email-linyunsheng@huawei.com>
 <1620266264-48109-2-git-send-email-linyunsheng@huawei.com>
 <20210507165703.70771c55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <83ff1619-5ca3-1e60-3a41-0faff1566569@huawei.com>
Date:   Sat, 8 May 2021 10:55:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210507165703.70771c55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

On 2021/5/8 7:57, Jakub Kicinski wrote:
> On Thu, 6 May 2021 09:57:42 +0800 Yunsheng Lin wrote:
>> @@ -159,8 +160,37 @@ static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
>>  static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>>  {
>>  	if (qdisc->flags & TCQ_F_NOLOCK) {
>> +		bool dont_retry = test_bit(__QDISC_STATE_MISSED,
>> +					   &qdisc->state);
>> +
>> +		if (spin_trylock(&qdisc->seqlock))
>> +			goto nolock_empty;
>> +
>> +		/* If the flag is set before doing the spin_trylock() and
>> +		 * the above spin_trylock() return false, it means other cpu
>> +		 * holding the lock will do dequeuing for us, or it wil see
> 
> s/wil/will/

Thanks.

> 
>> +		 * the flag set after releasing lock and reschedule the
>> +		 * net_tx_action() to do the dequeuing.
> 
> I don't understand why MISSED is checked before the trylock.
> Could you explain why it can't be tested directly here?
The initial thinking was:
Just like the set_bit() before the second trylock, If MISSED is set
before first trylock, it means other thread has set the MISSED flag
for this thread before doing the first trylock, so that this thread
does not need to do the set_bit().

But the initial thinking seems over thinking, as thread 3' setting the
MISSED before the second trylock has ensure either thread 3' second
trylock returns ture or thread 2 holding the lock will see the MISSED
flag, so thread 1 can do the test_bit() before or after the first
trylock, as below:

    thread 1                thread 2                    thread 3
                         holding q->seqlock
first trylock failed                              first trylock failed
                         unlock q->seqlock
                                               test_bit(MISSED) return false
                   test_bit(MISSED) return false
                          and not reschedule
                                                      set_bit(MISSED)
						      trylock success
test_bit(MISSED) retun ture
and not retry second trylock

If the above is correct, it seems we could:
1. do test_bit(MISSED) before the first trylock to avoid doing the
   first trylock for contended case.
or
2. do test_bit(MISSED) after the first trylock to avoid doing the
   test_bit() for un-contended case.

Which one do you prefer?

> 
>> +		 */
>> +		if (dont_retry)
>> +			return false;
>> +
>> +		/* We could do set_bit() before the first spin_trylock(),
>> +		 * and avoid doing second spin_trylock() completely, then
>> +		 * we could have multi cpus doing the set_bit(). Here use
>> +		 * dont_retry to avoid doing the set_bit() and the second
>> +		 * spin_trylock(), which has 5% performance improvement than
>> +		 * doing the set_bit() before the first spin_trylock().
>> +		 */
>> +		set_bit(__QDISC_STATE_MISSED, &qdisc->state);
>> +
>> +		/* Retry again in case other CPU may not see the new flag
>> +		 * after it releases the lock at the end of qdisc_run_end().
>> +		 */
>>  		if (!spin_trylock(&qdisc->seqlock))
>>  			return false;
>> +
>> +nolock_empty:
>>  		WRITE_ONCE(qdisc->empty, false);
>>  	} else if (qdisc_is_running(qdisc)) {
>>  		return false;
>> @@ -176,8 +206,13 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>>  static inline void qdisc_run_end(struct Qdisc *qdisc)
>>  {
>>  	write_seqcount_end(&qdisc->running);
>> -	if (qdisc->flags & TCQ_F_NOLOCK)
>> +	if (qdisc->flags & TCQ_F_NOLOCK) {
>>  		spin_unlock(&qdisc->seqlock);
>> +
>> +		if (unlikely(test_bit(__QDISC_STATE_MISSED,
>> +				      &qdisc->state)))
>> +			__netif_schedule(qdisc);
>> +	}
>>  }
>>  
>>  static inline bool qdisc_may_bulk(const struct Qdisc *qdisc)
>> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
>> index 44991ea..9bc73ea 100644
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
>> +		   test_and_clear_bit(__QDISC_STATE_MISSED,
>> +				      &qdisc->state)) {
> 
> Why test_and_clear_bit() here? AFAICT this is the only place the bit 
> is cleared. So the test and clear do not have to be atomic.

The the bit is also cleared in other place in patch 2/3, but within the
protection of q->seqlock too, so yes, the test and clear do not have to
be atomic for performance sake.

> 
> To my limited understanding on x86 test_bit() is never a locked
> operation, while test_and_clear_bit() is always locked. So we'd save
> an atomic operation in un-contended case if we tested first and then
> cleared.
> 
>> +		/* do another dequeuing after clearing the flag to
>> +		 * avoid calling __netif_schedule().
>> +		 */
>> +		smp_mb__after_atomic();
> 
> test_and_clear_bit() which returned true implies a memory barrier,
> AFAIU, so the barrier is not needed with the code as is. It will be
> needed if we switch to test_bit() + clear_bit(), but please clarify
> what it is paring with.

Ok.
Thanks for the reviewing.

> 
>> +		need_retry = false;
>> +
>> +		goto retry;
>>  	} else {
>>  		WRITE_ONCE(qdisc->empty, true);
>>  	}
> 
> 
> .
> 


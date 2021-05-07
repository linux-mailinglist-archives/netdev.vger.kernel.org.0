Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456AB376D88
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 01:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhEGX6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 19:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhEGX6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 19:58:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63197601FA;
        Fri,  7 May 2021 23:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620431826;
        bh=75/UCOvPi5A/3+VxLXqhJqocyY02+9r1OPTzZlGM5fU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PGa9HZz2Ejb6ioHTOtFfaUy9BjfK1W122wYXztFvfEo+hqw+qBEq1Ao8LFIwD2ffN
         5NSP27QmgXe/Bd9owAOZwh0Y+yJs1WkWBNlsA1kBR3kaHFUT7IPvNsejtQdtGkMO8Z
         PLt2RIbR/lJb43KZeV6pUme3lsvqvkVIylBKv0mAHaj8/s6vDvQC/T6uqDptcs+yjR
         6wpyyllIKCZxSa0HuuIxXLCarqM0e+N/Bc8tvrCwsCARAUzkfBp3q71p+/vTZThdrh
         bRkcdfjtLG85DL5Ym0KssfzDEYsJ03D/dteGVuy9r+xki1dv3SaA8xEx/4XbOvT+VB
         IQ9eB+++myZlA==
Date:   Fri, 7 May 2021 16:57:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <olteanv@gmail.com>, <ast@kernel.org>,
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
Subject: Re: [PATCH net v5 1/3] net: sched: fix packet stuck problem for
 lockless qdisc
Message-ID: <20210507165703.70771c55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1620266264-48109-2-git-send-email-linyunsheng@huawei.com>
References: <1620266264-48109-1-git-send-email-linyunsheng@huawei.com>
        <1620266264-48109-2-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 May 2021 09:57:42 +0800 Yunsheng Lin wrote:
> @@ -159,8 +160,37 @@ static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
>  static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>  {
>  	if (qdisc->flags & TCQ_F_NOLOCK) {
> +		bool dont_retry = test_bit(__QDISC_STATE_MISSED,
> +					   &qdisc->state);
> +
> +		if (spin_trylock(&qdisc->seqlock))
> +			goto nolock_empty;
> +
> +		/* If the flag is set before doing the spin_trylock() and
> +		 * the above spin_trylock() return false, it means other cpu
> +		 * holding the lock will do dequeuing for us, or it wil see

s/wil/will/

> +		 * the flag set after releasing lock and reschedule the
> +		 * net_tx_action() to do the dequeuing.

I don't understand why MISSED is checked before the trylock.
Could you explain why it can't be tested directly here?

> +		 */
> +		if (dont_retry)
> +			return false;
> +
> +		/* We could do set_bit() before the first spin_trylock(),
> +		 * and avoid doing second spin_trylock() completely, then
> +		 * we could have multi cpus doing the set_bit(). Here use
> +		 * dont_retry to avoid doing the set_bit() and the second
> +		 * spin_trylock(), which has 5% performance improvement than
> +		 * doing the set_bit() before the first spin_trylock().
> +		 */
> +		set_bit(__QDISC_STATE_MISSED, &qdisc->state);
> +
> +		/* Retry again in case other CPU may not see the new flag
> +		 * after it releases the lock at the end of qdisc_run_end().
> +		 */
>  		if (!spin_trylock(&qdisc->seqlock))
>  			return false;
> +
> +nolock_empty:
>  		WRITE_ONCE(qdisc->empty, false);
>  	} else if (qdisc_is_running(qdisc)) {
>  		return false;
> @@ -176,8 +206,13 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>  static inline void qdisc_run_end(struct Qdisc *qdisc)
>  {
>  	write_seqcount_end(&qdisc->running);
> -	if (qdisc->flags & TCQ_F_NOLOCK)
> +	if (qdisc->flags & TCQ_F_NOLOCK) {
>  		spin_unlock(&qdisc->seqlock);
> +
> +		if (unlikely(test_bit(__QDISC_STATE_MISSED,
> +				      &qdisc->state)))
> +			__netif_schedule(qdisc);
> +	}
>  }
>  
>  static inline bool qdisc_may_bulk(const struct Qdisc *qdisc)
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 44991ea..9bc73ea 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -640,8 +640,10 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
>  {
>  	struct pfifo_fast_priv *priv = qdisc_priv(qdisc);
>  	struct sk_buff *skb = NULL;
> +	bool need_retry = true;
>  	int band;
>  
> +retry:
>  	for (band = 0; band < PFIFO_FAST_BANDS && !skb; band++) {
>  		struct skb_array *q = band2list(priv, band);
>  
> @@ -652,6 +654,16 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
>  	}
>  	if (likely(skb)) {
>  		qdisc_update_stats_at_dequeue(qdisc, skb);
> +	} else if (need_retry &&
> +		   test_and_clear_bit(__QDISC_STATE_MISSED,
> +				      &qdisc->state)) {

Why test_and_clear_bit() here? AFAICT this is the only place the bit 
is cleared. So the test and clear do not have to be atomic.

To my limited understanding on x86 test_bit() is never a locked
operation, while test_and_clear_bit() is always locked. So we'd save
an atomic operation in un-contended case if we tested first and then
cleared.

> +		/* do another dequeuing after clearing the flag to
> +		 * avoid calling __netif_schedule().
> +		 */
> +		smp_mb__after_atomic();

test_and_clear_bit() which returned true implies a memory barrier,
AFAIU, so the barrier is not needed with the code as is. It will be
needed if we switch to test_bit() + clear_bit(), but please clarify
what it is paring with.

> +		need_retry = false;
> +
> +		goto retry;
>  	} else {
>  		WRITE_ONCE(qdisc->empty, true);
>  	}


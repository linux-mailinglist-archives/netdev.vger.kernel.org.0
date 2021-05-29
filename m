Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AB9394A6A
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 06:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhE2EeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 00:34:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhE2Ed4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 May 2021 00:33:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F86261155;
        Sat, 29 May 2021 04:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622262740;
        bh=Rl96HGMazBUW08qP4/UCIV9FqdR7PrYOkc36y2z0aZ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mF3UNksXIc/rR7R+3L/Ld0hava7Z/iP+s/YbE+GiNGph2Q9mH8ZZ4DqzWMFmZdHJ2
         lHoAAsSvMKKiYc8DQreXYZyCVad/prgjFpa4mG4hIZqPR7HR0/eiNkc/SQNRzMG78S
         U6jb0cEVjMvSSfVc+3Z+3pVYc9aKwsjX46L3WKsirsgrU9hgEg2tQxYXiT3jBEDmv/
         zK/taibY3amuZW5blkMgTXkHNby756uYONiJiwuLPiKZFqhzDC3APl+Bn4C29Ck4IX
         jZHuJ5GnmsbwOHDfz2F5ZAAxHUxT8p0JI5Jy+6FVo9QyKNLPShwx81PygaI7qOoRfG
         0av6olasuHLMA==
Date:   Fri, 28 May 2021 21:32:18 -0700
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
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
Subject: Re: [PATCH net-next 2/3] net: sched: implement TCQ_F_CAN_BYPASS for
 lockless qdisc
Message-ID: <20210528213218.2b90864c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <a6a965ee-7368-d37b-9c70-bba50c67eec9@huawei.com>
References: <1622170197-27370-1-git-send-email-linyunsheng@huawei.com>
        <1622170197-27370-3-git-send-email-linyunsheng@huawei.com>
        <20210528180012.676797d6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <a6a965ee-7368-d37b-9c70-bba50c67eec9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 May 2021 09:44:57 +0800 Yunsheng Lin wrote:
> >> @@ -3852,10 +3852,32 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
> >>  	qdisc_calculate_pkt_len(skb, q);
> >>  
> >>  	if (q->flags & TCQ_F_NOLOCK) {
> >> +		if (q->flags & TCQ_F_CAN_BYPASS && nolock_qdisc_is_empty(q) &&
> >> +		    qdisc_run_begin(q)) {
> >> +			/* Retest nolock_qdisc_is_empty() within the protection
> >> +			 * of q->seqlock to ensure qdisc is indeed empty.
> >> +			 */
> >> +			if (unlikely(!nolock_qdisc_is_empty(q))) {  
> > 
> > This is just for the DRAINING case right? 
> > 
> > MISSED can be set at any moment, testing MISSED seems confusing.  
> 
> MISSED is only set when there is lock contention, which means it
> is better not to do the qdisc bypass to avoid out of order packet
> problem, 

Avoid as in make less likely? Nothing guarantees other thread is not
interrupted after ->enqueue and before qdisc_run_begin().

TBH I'm not sure what out-of-order situation you're referring to,
there is no ordering guarantee between separate threads trying to
transmit AFAIU.

IOW this check is not required for correctness, right?

> another good thing is that we could also do the batch
> dequeuing and transmiting of packets when there is lock contention.

No doubt, but did you see the flag get set significantly often here 
to warrant the double-checking?

> > Is it really worth the extra code?  
> 
> Currently DRAINING is only set for the netdev queue stopped.
> We could only use DRAINING to indicate the non-empty of a qdisc,
> then we need to set the DRAINING evrywhere MISSED is set, that is
> why I use both DRAINING and MISSED to indicate a non-empty qdisc.
> 
> >   
> >> +				rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> >> +				__qdisc_run(q);
> >> +				qdisc_run_end(q);
> >> +
> >> +				goto no_lock_out;
> >> +			}
> >> +
> >> +			qdisc_bstats_cpu_update(q, skb);
> >> +			if (sch_direct_xmit(skb, q, dev, txq, NULL, true) &&
> >> +			    !nolock_qdisc_is_empty(q))
> >> +				__qdisc_run(q);
> >> +
> >> +			qdisc_run_end(q);
> >> +			return NET_XMIT_SUCCESS;
> >> +		}
> >> +
> >>  		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> >> -		if (likely(!netif_xmit_frozen_or_stopped(txq)))
> >> -			qdisc_run(q);
> >> +		qdisc_run(q);
> >>  
> >> +no_lock_out:
> >>  		if (unlikely(to_free))
> >>  			kfree_skb_list(to_free);
> >>  		return rc;

> >> @@ -164,9 +166,13 @@ static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
> >>  
> >>  		skb = next;
> >>  	}
> >> -	if (lock)
> >> +
> >> +	if (lock) {
> >>  		spin_unlock(lock);
> >> -	__netif_schedule(q);
> >> +		set_bit(__QDISC_STATE_MISSED, &q->state);
> >> +	} else {
> >> +		__netif_schedule(q);  
> > 
> > Could we reorder qdisc_run_begin() with clear_bit(SCHED) 
> > in net_tx_action() and add SCHED to the NON_EMPTY mask?  
> 
> Did you mean clearing the SCHED after the q->seqlock is
> taken?
> 
> The problem is that the SCHED is also used to indicate
> a qdisc is in sd->output_queue or not, and the
> qdisc_run_begin() called by net_tx_action() can not
> guarantee it will take the q->seqlock(we are using trylock
> for lockless qdisc)

Ah, right. We'd need to do some more flag juggling in net_tx_action()
to get it right.

> >> +	}
> >>  }
> >>  
> >>  static void try_bulk_dequeue_skb(struct Qdisc *q,
> >> @@ -409,7 +415,11 @@ void __qdisc_run(struct Qdisc *q)
> >>  	while (qdisc_restart(q, &packets)) {
> >>  		quota -= packets;
> >>  		if (quota <= 0) {
> >> -			__netif_schedule(q);
> >> +			if (q->flags & TCQ_F_NOLOCK)
> >> +				set_bit(__QDISC_STATE_MISSED, &q->state);
> >> +			else
> >> +				__netif_schedule(q);
> >> +
> >>  			break;
> >>  		}
> >>  	}
> >> @@ -680,13 +690,14 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
> >>  	if (likely(skb)) {
> >>  		qdisc_update_stats_at_dequeue(qdisc, skb);
> >>  	} else if (need_retry &&
> >> -		   test_bit(__QDISC_STATE_MISSED, &qdisc->state)) {
> >> +		   READ_ONCE(qdisc->state) & QDISC_STATE_NON_EMPTY) {  
> > 
> > Do we really need to retry based on DRAINING being set?
> > Or is it just a convenient way of coding things up?  
> 
> Yes, it is just a convenient way of coding things up.
> Only MISSED need retrying.

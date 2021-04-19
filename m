Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB34364688
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 16:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239309AbhDSO55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 10:57:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:43910 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239210AbhDSO55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 10:57:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A90C7B302;
        Mon, 19 Apr 2021 14:57:25 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id B617F603AA; Mon, 19 Apr 2021 16:57:24 +0200 (CEST)
Date:   Mon, 19 Apr 2021 16:57:24 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Juergen Gross <jgross@suse.com>, Jiri Kosina <jikos@kernel.org>,
        davem@davemloft.net, kuba@kernel.org, olteanv@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        edumazet@google.com, weiwan@google.com, cong.wang@bytedance.com,
        ap420073@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        mkl@pengutronix.de, linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
        johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com,
        a.fatoum@pengutronix.de, atenart@kernel.org,
        alexander.duyck@gmail.com
Subject: Re: [PATCH net v3] net: sched: fix packet stuck problem for lockless
 qdisc
Message-ID: <20210419145724.wx6wriaxobo6uruu@lion.mk-sys.cz>
References: <1616641991-14847-1-git-send-email-linyunsheng@huawei.com>
 <20210418225956.a6ot6xox4eq6cvv5@lion.mk-sys.cz>
 <a50daff3-c716-f11c-4dfa-c5c1f85a9e12@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a50daff3-c716-f11c-4dfa-c5c1f85a9e12@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 10:04:27AM +0800, Yunsheng Lin wrote:
> > 
> > I tried this patch o top of 5.12-rc7 with real devices. I used two
> > machines with 10Gb/s Intel ixgbe NICs, sender has 16 CPUs (2 8-core CPUs
> > with HT disabled) and 16 Rx/Tx queues, receiver has 48 CPUs (2 12-core
> > CPUs with HT enabled) and 48 Rx/Tx queues. With multiple TCP streams on
> > a saturated ethernet, the CPU consumption grows quite a lot:
> > 
> >     threads     unpatched 5.12-rc7    5.12-rc7 + v3   
> >       1               25.6%               30.6%
> >       8               73.1%              241.4%
> >     128              132.2%             1012.0%
> > 
> > (The values are normalized to one core, i.e. 100% corresponds to one
> > fully used logical CPU.) I didn't perform a full statistical evaluation
> > but the growth is way beyond any statistical fluctuation with one
> > exception: 8-thread test of patched kernel showed values from 155.5% to
> > 311.4%. Closer look shows that most of the CPU time was spent in softirq
> > and running top in parallel with the test confirms that there are
> > multiple ksofirqd threads running at 100% CPU. I had similar problem
> > with earlier versions of my patch (work in progress, I still need to
> > check some corner cases and write commit message explaining the logic)
> 
> Great, if there is a better idea, maybe share the core idea first so
> that we both can work on the that?

I'm not sure if it's really better but to minimize the false positives
and unnecessary calls to __netif_schedule(), I replaced q->seqlock with
an atomic combination of a "running" flag (which corresponds to current
seqlock being locked) and a "drainers" count (number of other threads
going to clean up the qdisc queue). This way we could keep track of them
and get reliable information if another thread is going to run a cleanup
after we leave the qdisc_run() critical section (so that there is no
need to schedule).

> > The biggest problem IMHO is that the loop in __qdisc_run() may finish
> > without rescheduling not only when the qdisc queue is empty but also
> > when the corresponding device Tx queue is stopped which devices tend to
> > do whenever they cannot send any more packets out. Thus whenever
> > __QDISC_STATE_NEED_RESCHEDULE is set with device queue stopped or
> > frozen, we keep rescheduling the queue cleanup without any chance to
> > progress or clear __QDISC_STATE_NEED_RESCHEDULE. For this to happen, all
> > we need is another thready to fail the first spin_trylock() while device
> > queue is stopped and qdisc queue not empty.
> 
> Yes, We could just return false before doing the second spin_trylock() if
> the netdev queue corresponding qdisc is stopped, and when the netdev queue
> is restarted, __netif_schedule() is called again, see netif_tx_wake_queue().
> 
> Maybe add a sch_qdisc_stopped() function and do the testting in qdisc_run_begin:
> 
> if (dont_retry || sch_qdisc_stopped())
> 	return false;
> 
> bool sch_qdisc_stopped(struct Qdisc *q)
> {
> 	const struct netdev_queue *txq = q->dev_queue;
> 
> 	if (!netif_xmit_frozen_or_stopped(txq))
> 		return true;
> 
> 	reture false;
> }
> 
> At least for qdisc with TCQ_F_ONETXQUEUE flags set is doable?

Either this or you can do the check in qdisc_run_end() - when the device
queue is stopped or frozen, there is no need to schedule as we know it's
going to be done when the flag is cleared again (and we cannot do
anything until then anyway).

> > Another part of the problem may be that to avoid the race, the logic is
> > too pessimistic: consider e.g. (dotted lines show "barriers" where
> > ordering is important):
> > 
> >     CPU A                            CPU B
> >     spin_trylock() succeeds
> >                                      pfifo_fast_enqueue()
> >     ..................................................................
> >     skb_array empty, exit loop
> >                                      first spin_trylock() fails
> >                                      set __QDISC_STATE_NEED_RESCHEDULE
> >                                      second spin_trylock() fails
> >     ..................................................................
> >     spin_unlock()
> >     call __netif_schedule()
> > 
> > When we switch the order of spin_lock() on CPU A and second
> > spin_trylock() on CPU B (but keep setting __QDISC_STATE_NEED_RESCHEDULE
> > before CPU A tests it), we end up scheduling a queue cleanup even if
> > there is already one running. And either of these is quite realistic.
> 
> But I am not sure it is a good thing or bad thing when the above happen,
> because it may be able to enable the tx batching?

In either of the two scenarios, we call __netif_schedule() to schedule
a cleanup which does not do anything useful. In first, the qdics queue
is empty so that either the scheduled cleanup finds it empty or there
will be some new packets which would have their own cleanup. In second,
scheduling a cleanup will not prevent the other thread from doing its
own cleanup it already started.

> >> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> >> index 44991ea..4953430 100644
> >> --- a/net/sched/sch_generic.c
> >> +++ b/net/sched/sch_generic.c
> >> @@ -640,8 +640,10 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
> >>  {
> >>  	struct pfifo_fast_priv *priv = qdisc_priv(qdisc);
> >>  	struct sk_buff *skb = NULL;
> >> +	bool need_retry = true;
> >>  	int band;
> >>  
> >> +retry:
> >>  	for (band = 0; band < PFIFO_FAST_BANDS && !skb; band++) {
> >>  		struct skb_array *q = band2list(priv, band);
> >>  
> >> @@ -652,6 +654,16 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
> >>  	}
> >>  	if (likely(skb)) {
> >>  		qdisc_update_stats_at_dequeue(qdisc, skb);
> >> +	} else if (need_retry &&
> >> +		   test_and_clear_bit(__QDISC_STATE_NEED_RESCHEDULE,
> >> +				      &qdisc->state)) {
> >> +		/* do another enqueuing after clearing the flag to
> >> +		 * avoid calling __netif_schedule().
> >> +		 */
> >> +		smp_mb__after_atomic();
> >> +		need_retry = false;
> >> +
> >> +		goto retry;
> >>  	} else {
> >>  		WRITE_ONCE(qdisc->empty, true);
> >>  	}i
> > 
> > Does the retry really provide significant improvement? IIUC it only
> > helps if all of enqueue, first spin_trylock() failure and setting the
> > __QDISC_STATE_NEED_RESCHEDULE flag happen between us finding the
> > skb_array empty and checking the flag. If enqueue happens before we
> > check the array (and flag is set before the check), the retry is
> > useless. If the flag is set after we check it, we don't catch it (no
> > matter if the enqueue happened before or after we found skb_array
> > empty).
> 
> In odrder to avoid doing the "set_bit(__QDISC_STATE_MISSED, &qdisc->state)"
> as much as possible, the __QDISC_STATE_NEED_RESCHEDULE need to be set as
> as much as possible, so only clear __QDISC_STATE_NEED_RESCHEDULE when the
> queue is empty.

This is what I'm worried about. We are trying to address a race
condition which is extremely rare so we should avoid adding too much
overhead to the normal use.

> And it has about 5% performance improvement.

OK then. It thought that it would do an unnecessary dequeue retry much
more often than prevent an unnecessary __netif_schedule() but I did not
run any special benchmark to check.

Michal

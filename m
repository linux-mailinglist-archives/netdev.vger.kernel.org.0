Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0CE3648AE
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 18:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239590AbhDSQ7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 12:59:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239522AbhDSQ7H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 12:59:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D613861104;
        Mon, 19 Apr 2021 16:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618851517;
        bh=TIJaAWyTnl1Z88Pg6WRLdK2AggzEs2HITTWuwQBN630=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=cZQ2r+mA36Jt5vh5tUY4yik6L9TcbJhWXOo9FXlrn3BCmjDHFz3vhtMEpNB8ahmv1
         l+xgu2I2logHIwru8VnDu2nY1xWDaXZWpatJkmHKfIjCX4rxaS7FCzobf84eP3QCTV
         tmvpBUZqzBNS71Tu1aJRfICrWndU2KnTo2hbp8GAv19/HLg3ePyM3FWoHbtFXR3WeP
         B7FfLrz72HSDdRtP05u/UAnu+K9UmaarMzTqdHHt65o2ovJpEfYltfg+K1bht3CAfj
         HrilLQBj7puYv0nCE7pCvmTUiN1XpEuk7Y0UqgJzH+3OGuD04fjOzGL6Yi0j5HAsYY
         gU8zdiI1gJqTg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 94F865C0127; Mon, 19 Apr 2021 09:58:37 -0700 (PDT)
Date:   Mon, 19 Apr 2021 09:58:37 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Subject: Re: [PATCHv7 bpf-next 1/4] bpf: run devmap xdp_prog on flush instead
 of bulk enqueue
Message-ID: <20210419165837.GA975577@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210415023746.GR2900@Leo-laptop-t470s>
 <87o8efkilw.fsf@toke.dk>
 <20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com>
 <20210415202132.7b5e8d0d@carbon>
 <87k0p3i957.fsf@toke.dk>
 <20210416003913.azcjk4fqxs7gag3m@kafai-mbp.dhcp.thefacebook.com>
 <20210416154523.3b1fe700@carbon>
 <20210416182252.c25akwj6zjdvo7u2@kafai-mbp.dhcp.thefacebook.com>
 <20210417002301.GO4212@paulmck-ThinkPad-P17-Gen-1>
 <87h7k5hza0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h7k5hza0.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 02:27:19PM +0200, Toke Høiland-Jørgensen wrote:
> "Paul E. McKenney" <paulmck@kernel.org> writes:
> 
> > On Fri, Apr 16, 2021 at 11:22:52AM -0700, Martin KaFai Lau wrote:
> >> On Fri, Apr 16, 2021 at 03:45:23PM +0200, Jesper Dangaard Brouer wrote:
> >> > On Thu, 15 Apr 2021 17:39:13 -0700
> >> > Martin KaFai Lau <kafai@fb.com> wrote:
> >> > 
> >> > > On Thu, Apr 15, 2021 at 10:29:40PM +0200, Toke Høiland-Jørgensen wrote:
> >> > > > Jesper Dangaard Brouer <brouer@redhat.com> writes:
> >> > > >   
> >> > > > > On Thu, 15 Apr 2021 10:35:51 -0700
> >> > > > > Martin KaFai Lau <kafai@fb.com> wrote:
> >> > > > >  
> >> > > > >> On Thu, Apr 15, 2021 at 11:22:19AM +0200, Toke Høiland-Jørgensen wrote:  
> >> > > > >> > Hangbin Liu <liuhangbin@gmail.com> writes:
> >> > > > >> >     
> >> > > > >> > > On Wed, Apr 14, 2021 at 05:17:11PM -0700, Martin KaFai Lau wrote:    
> >> > > > >> > >> >  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
> >> > > > >> > >> >  {
> >> > > > >> > >> >  	struct net_device *dev = bq->dev;
> >> > > > >> > >> > -	int sent = 0, err = 0;
> >> > > > >> > >> > +	int sent = 0, drops = 0, err = 0;
> >> > > > >> > >> > +	unsigned int cnt = bq->count;
> >> > > > >> > >> > +	int to_send = cnt;
> >> > > > >> > >> >  	int i;
> >> > > > >> > >> >  
> >> > > > >> > >> > -	if (unlikely(!bq->count))
> >> > > > >> > >> > +	if (unlikely(!cnt))
> >> > > > >> > >> >  		return;
> >> > > > >> > >> >  
> >> > > > >> > >> > -	for (i = 0; i < bq->count; i++) {
> >> > > > >> > >> > +	for (i = 0; i < cnt; i++) {
> >> > > > >> > >> >  		struct xdp_frame *xdpf = bq->q[i];
> >> > > > >> > >> >  
> >> > > > >> > >> >  		prefetch(xdpf);
> >> > > > >> > >> >  	}
> >> > > > >> > >> >  
> >> > > > >> > >> > -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> >> > > > >> > >> > +	if (bq->xdp_prog) {    
> >> > > > >> > >> bq->xdp_prog is used here
> >> > > > >> > >>     
> >> > > > >> > >> > +		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> >> > > > >> > >> > +		if (!to_send)
> >> > > > >> > >> > +			goto out;
> >> > > > >> > >> > +
> >> > > > >> > >> > +		drops = cnt - to_send;
> >> > > > >> > >> > +	}
> >> > > > >> > >> > +    
> >> > > > >> > >> 
> >> > > > >> > >> [ ... ]
> >> > > > >> > >>     
> >> > > > >> > >> >  static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
> >> > > > >> > >> > -		       struct net_device *dev_rx)
> >> > > > >> > >> > +		       struct net_device *dev_rx, struct bpf_prog *xdp_prog)
> >> > > > >> > >> >  {
> >> > > > >> > >> >  	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
> >> > > > >> > >> >  	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
> >> > > > >> > >> > @@ -412,18 +466,22 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
> >> > > > >> > >> >  	/* Ingress dev_rx will be the same for all xdp_frame's in
> >> > > > >> > >> >  	 * bulk_queue, because bq stored per-CPU and must be flushed
> >> > > > >> > >> >  	 * from net_device drivers NAPI func end.
> >> > > > >> > >> > +	 *
> >> > > > >> > >> > +	 * Do the same with xdp_prog and flush_list since these fields
> >> > > > >> > >> > +	 * are only ever modified together.
> >> > > > >> > >> >  	 */
> >> > > > >> > >> > -	if (!bq->dev_rx)
> >> > > > >> > >> > +	if (!bq->dev_rx) {
> >> > > > >> > >> >  		bq->dev_rx = dev_rx;
> >> > > > >> > >> > +		bq->xdp_prog = xdp_prog;    
> >> > > > >> > >> bp->xdp_prog is assigned here and could be used later in bq_xmit_all().
> >> > > > >> > >> How is bq->xdp_prog protected? Are they all under one rcu_read_lock()?
> >> > > > >> > >> It is not very obvious after taking a quick look at xdp_do_flush[_map].
> >> > > > >> > >> 
> >> > > > >> > >> e.g. what if the devmap elem gets deleted.    
> >> > > > >> > >
> >> > > > >> > > Jesper knows better than me. From my veiw, based on the description of
> >> > > > >> > > __dev_flush():
> >> > > > >> > >
> >> > > > >> > > On devmap tear down we ensure the flush list is empty before completing to
> >> > > > >> > > ensure all flush operations have completed. When drivers update the bpf
> >> > > > >> > > program they may need to ensure any flush ops are also complete.    
> >> > > > >>
> >> > > > >> AFAICT, the bq->xdp_prog is not from the dev. It is from a devmap's elem.
> >> > 
> >> > The bq->xdp_prog comes form the devmap "dev" element, and it is stored
> >> > in temporarily in the "bq" structure that is only valid for this
> >> > softirq NAPI-cycle.  I'm slightly worried that we copied this pointer
> >> > the the xdp_prog here, more below (and Q for Paul).
> >> > 
> >> > > > >> > 
> >> > > > >> > Yeah, drivers call xdp_do_flush() before exiting their NAPI poll loop,
> >> > > > >> > which also runs under one big rcu_read_lock(). So the storage in the
> >> > > > >> > bulk queue is quite temporary, it's just used for bulking to increase
> >> > > > >> > performance :)    
> >> > > > >>
> >> > > > >> I am missing the one big rcu_read_lock() part.  For example, in i40e_txrx.c,
> >> > > > >> i40e_run_xdp() has its own rcu_read_lock/unlock().  dst->xdp_prog used to run
> >> > > > >> in i40e_run_xdp() and it is fine.
> >> > > > >> 
> >> > > > >> In this patch, dst->xdp_prog is run outside of i40e_run_xdp() where the
> >> > > > >> rcu_read_unlock() has already done.  It is now run in xdp_do_flush_map().
> >> > > > >> or I missed the big rcu_read_lock() in i40e_napi_poll()?
> >> > > > >>
> >> > > > >> I do see the big rcu_read_lock() in mlx5e_napi_poll().  
> >> > > > >
> >> > > > > I believed/assumed xdp_do_flush_map() was already protected under an
> >> > > > > rcu_read_lock.  As the devmap and cpumap, which get called via
> >> > > > > __dev_flush() and __cpu_map_flush(), have multiple RCU objects that we
> >> > > > > are operating on.  
> >> > >
> >> > > What other rcu objects it is using during flush?
> >> > 
> >> > Look at code:
> >> >  kernel/bpf/cpumap.c
> >> >  kernel/bpf/devmap.c
> >> > 
> >> > The devmap is filled with RCU code and complicated take-down steps.  
> >> > The devmap's elements are also RCU objects and the BPF xdp_prog is
> >> > embedded in this object (struct bpf_dtab_netdev).  The call_rcu
> >> > function is __dev_map_entry_free().
> >> > 
> >> > 
> >> > > > > Perhaps it is a bug in i40e?  
> >> > >
> >> > > A quick look into ixgbe falls into the same bucket.
> >> > > didn't look at other drivers though.
> >> > 
> >> > Intel driver are very much in copy-paste mode.
> >> >  
> >> > > > >
> >> > > > > We are running in softirq in NAPI context, when xdp_do_flush_map() is
> >> > > > > call, which I think means that this CPU will not go-through a RCU grace
> >> > > > > period before we exit softirq, so in-practice it should be safe.  
> >> > > > 
> >> > > > Yup, this seems to be correct: rcu_softirq_qs() is only called between
> >> > > > full invocations of the softirq handler, which for networking is
> >> > > > net_rx_action(), and so translates into full NAPI poll cycles.  
> >> > >
> >> > > I don't know enough to comment on the rcu/softirq part, may be someone
> >> > > can chime in.  There is also a recent napi_threaded_poll().
> >> > 
> >> > CC added Paul. (link to patch[1][2] for context)
> >> Updated Paul's email address.
> >> 
> >> > 
> >> > > If it is the case, then some of the existing rcu_read_lock() is unnecessary?
> >> > 
> >> > Well, in many cases, especially depending on how kernel is compiled,
> >> > that is true.  But we want to keep these, as they also document the
> >> > intend of the programmer.  And allow us to make the kernel even more
> >> > preempt-able in the future.
> >> > 
> >> > > At least, it sounds incorrect to only make an exception here while keeping
> >> > > other rcu_read_lock() as-is.
> >> > 
> >> > Let me be clear:  I think you have spotted a problem, and we need to
> >> > add rcu_read_lock() at least around the invocation of
> >> > bpf_prog_run_xdp() or before around if-statement that call
> >> > dev_map_bpf_prog_run(). (Hangbin please do this in V8).
> >> > 
> >> > Thank you Martin for reviewing the code carefully enough to find this
> >> > issue, that some drivers don't have a RCU-section around the full XDP
> >> > code path in their NAPI-loop.
> >> > 
> >> > Question to Paul.  (I will attempt to describe in generic terms what
> >> > happens, but ref real-function names).
> >> > 
> >> > We are running in softirq/NAPI context, the driver will call a
> >> > bq_enqueue() function for every packet (if calling xdp_do_redirect) ,
> >> > some driver wrap this with a rcu_read_lock/unlock() section (other have
> >> > a large RCU-read section, that include the flush operation).
> >> > 
> >> > In the bq_enqueue() function we have a per_cpu_ptr (that store the
> >> > xdp_frame packets) that will get flushed/send in the call
> >> > xdp_do_flush() (that end-up calling bq_xmit_all()).  This flush will
> >> > happen before we end our softirq/NAPI context.
> >> > 
> >> > The extension is that the per_cpu_ptr data structure (after this patch)
> >> > store a pointer to an xdp_prog (which is a RCU object).  In the flush
> >> > operation (which we will wrap with RCU-read section), we will use this
> >> > xdp_prog pointer.   I can see that it is in-principle wrong to pass
> >> > this-pointer between RCU-read sections, but I consider this safe as we
> >> > are running under softirq/NAPI and the per_cpu_ptr is only valid in
> >> > this short interval.
> >> > 
> >> > I claim a grace/quiescent RCU cannot happen between these two RCU-read
> >> > sections, but I might be wrong? (especially in the future or for RT).
> >
> > If I am reading this correctly (ha!), a very high-level summary of the
> > code in question is something like this:
> >
> > 	void foo(void)
> > 	{
> > 		local_bh_disable();
> >
> > 		rcu_read_lock();
> > 		p = rcu_dereference(gp);
> > 		do_something_with(p);
> > 		rcu_read_unlock();
> >
> > 		do_something_else();
> >
> > 		rcu_read_lock();
> > 		do_some_other_thing(p);
> > 		rcu_read_unlock();
> >
> > 		local_bh_enable();
> > 	}
> >
> > 	void bar(struct blat *new_gp)
> > 	{
> > 		struct blat *old_gp;
> >
> > 		spin_lock(my_lock);
> > 		old_gp = rcu_dereference_protected(gp, lock_held(my_lock));
> > 		rcu_assign_pointer(gp, new_gp);
> > 		spin_unlock(my_lock);
> > 		synchronize_rcu();
> > 		kfree(old_gp);
> > 	}
> 
> Yeah, something like that (the object is freed using call_rcu() - but I
> think that's equivalent, right?). And the question is whether we need to
> extend foo() so that is has one big rcu_read_lock() that covers the
> whole lifetime of p.

Yes, use of call_rcu() is an asynchronous version of synchronize_rcu().
In fact, synchronize_rcu() is implemented in terms of call_rcu().  ;-)

> > I need to check up on -rt.
> >
> > But first... In recent mainline kernels, the local_bh_disable() region
> > will look like one big RCU read-side critical section.  But don't try
> > this prior to v4.20!!!  In v4.19 and earlier, you would need to use
> > both synchronize_rcu() and synchronize_rcu_bh() to make this work, or,
> > for less latency, synchronize_rcu_mult(call_rcu, call_rcu_bh).
> 
> OK. Variants of this code has been around since before then, but I
> honestly have no idea what it looked like back then exactly...

I know that feeling...

> > Except that in that case, why not just drop the inner rcu_read_unlock()
> > and rcu_read_lock() pair?  Awkward function boundaries or some such?
> 
> Well if we can just treat such a local_bh_disable()/enable() pair as the
> equivalent of rcu_read_lock()/unlock() then I suppose we could just get
> rid of the inner ones. What about tools like lockdep; do they understand
> this, or are we likely to get complaints if we remove it?

If you just got rid of the first rcu_read_unlock() and the second
rcu_read_lock() in the code above, lockdep will understand.

However, if you instead get rid of -all- of the rcu_read_lock() and
rcu_read_unlock() invocations in the code above, you would need to let
lockdep know by adding rcu_read_lock_bh_held().  So instead of this:

	p = rcu_dereference(gp);

You would do this:

	p = rcu_dereference_check(gp, rcu_read_lock_bh_held());

This would be needed for mainline, regardless of -rt.

> > Especially given that if this works on -rt, it is probably because
> > their variant of do_softirq() holds rcu_read_lock() across each
> > softirq handler invocation. They do something similar for rwlocks.
> 
> Right. Guess we'll wait for your confirmation of that, then. Thanks! :)

Looking at v5.11.4-rt11...

And __local_bh_disable_ip() has added the required rcu_read_lock(),
so dropping all the rcu_read_lock() and rcu_read_unlock() calls would
do the right thing in -rt.  And lockdep would understand without the
rcu_read_lock_bh_held(), but that is still required for mainline.

							Thanx, Paul

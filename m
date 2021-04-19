Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01105364D91
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhDSWRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:17:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229597AbhDSWRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 18:17:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618870607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oi6gO8nIfif58fHSYNl48mYXu8hKgSlyveImjBSTpBs=;
        b=ht2rm3T3qtL4ri3Kudxdo2vMp+wMBvZg2dthn6O3bkkQkXHMpgm4qQvLl/XKHD8N0gkjgu
        hwe3WH4qUN8li0Nz7LzGIGegZ0eLeiP5FeU6L2FT6qtQ+GAe7qNHCT4Xb9qBwW2ns54Jte
        mMVvLHMwJi5+RC9n5de3U1vLeakllGE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-SCq5SY6qMBysMoI2DjLecA-1; Mon, 19 Apr 2021 18:16:45 -0400
X-MC-Unique: SCq5SY6qMBysMoI2DjLecA-1
Received: by mail-ed1-f69.google.com with SMTP id w14-20020aa7da4e0000b02903834aeed684so10176180eds.13
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 15:16:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=oi6gO8nIfif58fHSYNl48mYXu8hKgSlyveImjBSTpBs=;
        b=rqJRcwSYLJUN5NAYAOKEoE864ua2A01GNIJESlIq5uFXncNGovssUYNVldGLzcKqc0
         cZy5jA67vaacw0gCTtdG4mZyrMEtaH5LGb0kOyES0yvqI1Ac+JbGU++Xh7fjYAHJuavB
         CqN6ZJB/eQ3F9g2wIF8VNMsu9IOBPW83myb2dQjz85/Xx39LCKPpNDFKtRQ8njenIgtf
         frUQcfqVc+xkCvv8nqyqSq2ANDSGNbbRvvSnkNNK8IkI/h0M3ElD9AHKsw/vLxUdA11T
         KCVd8FBs32Ai+d++Wvj5K3YKD0uFX2wqohiu/HSueVAmD0yYHXvMQVjJGvrQZkURlqpg
         UQGQ==
X-Gm-Message-State: AOAM5303bY78eSC/00Wr6G5cJrnaE/BGCoAEEMGdglscMhs2j5sskxBe
        7zsd2n+Tow+r5B3+Km6foAxztww9ARzAYcjzGmE/X32XlD5rrUG+uSC8XPX+R0anLF4ySTz/WkM
        TCMDY4cIJc1cYpk57
X-Received: by 2002:a05:6402:31ac:: with SMTP id dj12mr10000900edb.267.1618870603503;
        Mon, 19 Apr 2021 15:16:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqw3PcBFFMPkZPr4fOQfRREBgd3l92tJExH1d/g1wrjbtwiZe0/5nDWntq+n83b+ELrN4y8g==
X-Received: by 2002:a05:6402:31ac:: with SMTP id dj12mr10000855edb.267.1618870602944;
        Mon, 19 Apr 2021 15:16:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t17sm2479309edv.3.2021.04.19.15.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 15:16:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A02C11802D9; Tue, 20 Apr 2021 00:16:40 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     paulmck@kernel.org
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
        =?utf-8?B?QmrDtnJuIFQ=?= =?utf-8?B?w7ZwZWw=?= 
        <bjorn.topel@gmail.com>
Subject: Re: [PATCHv7 bpf-next 1/4] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
In-Reply-To: <20210419214117.GE975577@paulmck-ThinkPad-P17-Gen-1>
References: <87k0p3i957.fsf@toke.dk>
 <20210416003913.azcjk4fqxs7gag3m@kafai-mbp.dhcp.thefacebook.com>
 <20210416154523.3b1fe700@carbon>
 <20210416182252.c25akwj6zjdvo7u2@kafai-mbp.dhcp.thefacebook.com>
 <20210417002301.GO4212@paulmck-ThinkPad-P17-Gen-1>
 <87h7k5hza0.fsf@toke.dk>
 <20210419165837.GA975577@paulmck-ThinkPad-P17-Gen-1>
 <87lf9egn3o.fsf@toke.dk>
 <20210419183223.GC975577@paulmck-ThinkPad-P17-Gen-1>
 <877dkygeca.fsf@toke.dk>
 <20210419214117.GE975577@paulmck-ThinkPad-P17-Gen-1>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 20 Apr 2021 00:16:40 +0200
Message-ID: <87y2ddgbsn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Paul E. McKenney" <paulmck@kernel.org> writes:

> On Mon, Apr 19, 2021 at 11:21:41PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> "Paul E. McKenney" <paulmck@kernel.org> writes:
>>=20
>> > On Mon, Apr 19, 2021 at 08:12:27PM +0200, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> >> "Paul E. McKenney" <paulmck@kernel.org> writes:
>> >>=20
>> >> > On Sat, Apr 17, 2021 at 02:27:19PM +0200, Toke H=C3=B8iland-J=C3=B8=
rgensen wrote:
>> >> >> "Paul E. McKenney" <paulmck@kernel.org> writes:
>> >> >>=20
>> >> >> > On Fri, Apr 16, 2021 at 11:22:52AM -0700, Martin KaFai Lau wrote:
>> >> >> >> On Fri, Apr 16, 2021 at 03:45:23PM +0200, Jesper Dangaard Broue=
r wrote:
>> >> >> >> > On Thu, 15 Apr 2021 17:39:13 -0700
>> >> >> >> > Martin KaFai Lau <kafai@fb.com> wrote:
>> >> >> >> >=20
>> >> >> >> > > On Thu, Apr 15, 2021 at 10:29:40PM +0200, Toke H=C3=B8iland=
-J=C3=B8rgensen wrote:
>> >> >> >> > > > Jesper Dangaard Brouer <brouer@redhat.com> writes:
>> >> >> >> > > >=20=20=20
>> >> >> >> > > > > On Thu, 15 Apr 2021 10:35:51 -0700
>> >> >> >> > > > > Martin KaFai Lau <kafai@fb.com> wrote:
>> >> >> >> > > > >=20=20
>> >> >> >> > > > >> On Thu, Apr 15, 2021 at 11:22:19AM +0200, Toke H=C3=B8=
iland-J=C3=B8rgensen wrote:=20=20
>> >> >> >> > > > >> > Hangbin Liu <liuhangbin@gmail.com> writes:
>> >> >> >> > > > >> >=20=20=20=20=20
>> >> >> >> > > > >> > > On Wed, Apr 14, 2021 at 05:17:11PM -0700, Martin K=
aFai Lau wrote:=20=20=20=20
>> >> >> >> > > > >> > >> >  static void bq_xmit_all(struct xdp_dev_bulk_qu=
eue *bq, u32 flags)
>> >> >> >> > > > >> > >> >  {
>> >> >> >> > > > >> > >> >  	struct net_device *dev =3D bq->dev;
>> >> >> >> > > > >> > >> > -	int sent =3D 0, err =3D 0;
>> >> >> >> > > > >> > >> > +	int sent =3D 0, drops =3D 0, err =3D 0;
>> >> >> >> > > > >> > >> > +	unsigned int cnt =3D bq->count;
>> >> >> >> > > > >> > >> > +	int to_send =3D cnt;
>> >> >> >> > > > >> > >> >  	int i;
>> >> >> >> > > > >> > >> >=20=20
>> >> >> >> > > > >> > >> > -	if (unlikely(!bq->count))
>> >> >> >> > > > >> > >> > +	if (unlikely(!cnt))
>> >> >> >> > > > >> > >> >  		return;
>> >> >> >> > > > >> > >> >=20=20
>> >> >> >> > > > >> > >> > -	for (i =3D 0; i < bq->count; i++) {
>> >> >> >> > > > >> > >> > +	for (i =3D 0; i < cnt; i++) {
>> >> >> >> > > > >> > >> >  		struct xdp_frame *xdpf =3D bq->q[i];
>> >> >> >> > > > >> > >> >=20=20
>> >> >> >> > > > >> > >> >  		prefetch(xdpf);
>> >> >> >> > > > >> > >> >  	}
>> >> >> >> > > > >> > >> >=20=20
>> >> >> >> > > > >> > >> > -	sent =3D dev->netdev_ops->ndo_xdp_xmit(dev, b=
q->count, bq->q, flags);
>> >> >> >> > > > >> > >> > +	if (bq->xdp_prog) {=20=20=20=20
>> >> >> >> > > > >> > >> bq->xdp_prog is used here
>> >> >> >> > > > >> > >>=20=20=20=20=20
>> >> >> >> > > > >> > >> > +		to_send =3D dev_map_bpf_prog_run(bq->xdp_pro=
g, bq->q, cnt, dev);
>> >> >> >> > > > >> > >> > +		if (!to_send)
>> >> >> >> > > > >> > >> > +			goto out;
>> >> >> >> > > > >> > >> > +
>> >> >> >> > > > >> > >> > +		drops =3D cnt - to_send;
>> >> >> >> > > > >> > >> > +	}
>> >> >> >> > > > >> > >> > +=20=20=20=20
>> >> >> >> > > > >> > >>=20
>> >> >> >> > > > >> > >> [ ... ]
>> >> >> >> > > > >> > >>=20=20=20=20=20
>> >> >> >> > > > >> > >> >  static void bq_enqueue(struct net_device *dev,=
 struct xdp_frame *xdpf,
>> >> >> >> > > > >> > >> > -		       struct net_device *dev_rx)
>> >> >> >> > > > >> > >> > +		       struct net_device *dev_rx, struct bpf=
_prog *xdp_prog)
>> >> >> >> > > > >> > >> >  {
>> >> >> >> > > > >> > >> >  	struct list_head *flush_list =3D this_cpu_ptr=
(&dev_flush_list);
>> >> >> >> > > > >> > >> >  	struct xdp_dev_bulk_queue *bq =3D this_cpu_pt=
r(dev->xdp_bulkq);
>> >> >> >> > > > >> > >> > @@ -412,18 +466,22 @@ static void bq_enqueue(st=
ruct net_device *dev, struct xdp_frame *xdpf,
>> >> >> >> > > > >> > >> >  	/* Ingress dev_rx will be the same for all xd=
p_frame's in
>> >> >> >> > > > >> > >> >  	 * bulk_queue, because bq stored per-CPU and =
must be flushed
>> >> >> >> > > > >> > >> >  	 * from net_device drivers NAPI func end.
>> >> >> >> > > > >> > >> > +	 *
>> >> >> >> > > > >> > >> > +	 * Do the same with xdp_prog and flush_list s=
ince these fields
>> >> >> >> > > > >> > >> > +	 * are only ever modified together.
>> >> >> >> > > > >> > >> >  	 */
>> >> >> >> > > > >> > >> > -	if (!bq->dev_rx)
>> >> >> >> > > > >> > >> > +	if (!bq->dev_rx) {
>> >> >> >> > > > >> > >> >  		bq->dev_rx =3D dev_rx;
>> >> >> >> > > > >> > >> > +		bq->xdp_prog =3D xdp_prog;=20=20=20=20
>> >> >> >> > > > >> > >> bp->xdp_prog is assigned here and could be used l=
ater in bq_xmit_all().
>> >> >> >> > > > >> > >> How is bq->xdp_prog protected? Are they all under=
 one rcu_read_lock()?
>> >> >> >> > > > >> > >> It is not very obvious after taking a quick look =
at xdp_do_flush[_map].
>> >> >> >> > > > >> > >>=20
>> >> >> >> > > > >> > >> e.g. what if the devmap elem gets deleted.=20=20=
=20=20
>> >> >> >> > > > >> > >
>> >> >> >> > > > >> > > Jesper knows better than me. From my veiw, based o=
n the description of
>> >> >> >> > > > >> > > __dev_flush():
>> >> >> >> > > > >> > >
>> >> >> >> > > > >> > > On devmap tear down we ensure the flush list is em=
pty before completing to
>> >> >> >> > > > >> > > ensure all flush operations have completed. When d=
rivers update the bpf
>> >> >> >> > > > >> > > program they may need to ensure any flush ops are =
also complete.=20=20=20=20
>> >> >> >> > > > >>
>> >> >> >> > > > >> AFAICT, the bq->xdp_prog is not from the dev. It is fr=
om a devmap's elem.
>> >> >> >> >=20
>> >> >> >> > The bq->xdp_prog comes form the devmap "dev" element, and it =
is stored
>> >> >> >> > in temporarily in the "bq" structure that is only valid for t=
his
>> >> >> >> > softirq NAPI-cycle.  I'm slightly worried that we copied this=
 pointer
>> >> >> >> > the the xdp_prog here, more below (and Q for Paul).
>> >> >> >> >=20
>> >> >> >> > > > >> >=20
>> >> >> >> > > > >> > Yeah, drivers call xdp_do_flush() before exiting the=
ir NAPI poll loop,
>> >> >> >> > > > >> > which also runs under one big rcu_read_lock(). So th=
e storage in the
>> >> >> >> > > > >> > bulk queue is quite temporary, it's just used for bu=
lking to increase
>> >> >> >> > > > >> > performance :)=20=20=20=20
>> >> >> >> > > > >>
>> >> >> >> > > > >> I am missing the one big rcu_read_lock() part.  For ex=
ample, in i40e_txrx.c,
>> >> >> >> > > > >> i40e_run_xdp() has its own rcu_read_lock/unlock().  ds=
t->xdp_prog used to run
>> >> >> >> > > > >> in i40e_run_xdp() and it is fine.
>> >> >> >> > > > >>=20
>> >> >> >> > > > >> In this patch, dst->xdp_prog is run outside of i40e_ru=
n_xdp() where the
>> >> >> >> > > > >> rcu_read_unlock() has already done.  It is now run in =
xdp_do_flush_map().
>> >> >> >> > > > >> or I missed the big rcu_read_lock() in i40e_napi_poll(=
)?
>> >> >> >> > > > >>
>> >> >> >> > > > >> I do see the big rcu_read_lock() in mlx5e_napi_poll().=
=20=20
>> >> >> >> > > > >
>> >> >> >> > > > > I believed/assumed xdp_do_flush_map() was already prote=
cted under an
>> >> >> >> > > > > rcu_read_lock.  As the devmap and cpumap, which get cal=
led via
>> >> >> >> > > > > __dev_flush() and __cpu_map_flush(), have multiple RCU =
objects that we
>> >> >> >> > > > > are operating on.=20=20
>> >> >> >> > >
>> >> >> >> > > What other rcu objects it is using during flush?
>> >> >> >> >=20
>> >> >> >> > Look at code:
>> >> >> >> >  kernel/bpf/cpumap.c
>> >> >> >> >  kernel/bpf/devmap.c
>> >> >> >> >=20
>> >> >> >> > The devmap is filled with RCU code and complicated take-down =
steps.=20=20
>> >> >> >> > The devmap's elements are also RCU objects and the BPF xdp_pr=
og is
>> >> >> >> > embedded in this object (struct bpf_dtab_netdev).  The call_r=
cu
>> >> >> >> > function is __dev_map_entry_free().
>> >> >> >> >=20
>> >> >> >> >=20
>> >> >> >> > > > > Perhaps it is a bug in i40e?=20=20
>> >> >> >> > >
>> >> >> >> > > A quick look into ixgbe falls into the same bucket.
>> >> >> >> > > didn't look at other drivers though.
>> >> >> >> >=20
>> >> >> >> > Intel driver are very much in copy-paste mode.
>> >> >> >> >=20=20
>> >> >> >> > > > >
>> >> >> >> > > > > We are running in softirq in NAPI context, when xdp_do_=
flush_map() is
>> >> >> >> > > > > call, which I think means that this CPU will not go-thr=
ough a RCU grace
>> >> >> >> > > > > period before we exit softirq, so in-practice it should=
 be safe.=20=20
>> >> >> >> > > >=20
>> >> >> >> > > > Yup, this seems to be correct: rcu_softirq_qs() is only c=
alled between
>> >> >> >> > > > full invocations of the softirq handler, which for networ=
king is
>> >> >> >> > > > net_rx_action(), and so translates into full NAPI poll cy=
cles.=20=20
>> >> >> >> > >
>> >> >> >> > > I don't know enough to comment on the rcu/softirq part, may=
 be someone
>> >> >> >> > > can chime in.  There is also a recent napi_threaded_poll().
>> >> >> >> >=20
>> >> >> >> > CC added Paul. (link to patch[1][2] for context)
>> >> >> >> Updated Paul's email address.
>> >> >> >>=20
>> >> >> >> >=20
>> >> >> >> > > If it is the case, then some of the existing rcu_read_lock(=
) is unnecessary?
>> >> >> >> >=20
>> >> >> >> > Well, in many cases, especially depending on how kernel is co=
mpiled,
>> >> >> >> > that is true.  But we want to keep these, as they also docume=
nt the
>> >> >> >> > intend of the programmer.  And allow us to make the kernel ev=
en more
>> >> >> >> > preempt-able in the future.
>> >> >> >> >=20
>> >> >> >> > > At least, it sounds incorrect to only make an exception her=
e while keeping
>> >> >> >> > > other rcu_read_lock() as-is.
>> >> >> >> >=20
>> >> >> >> > Let me be clear:  I think you have spotted a problem, and we =
need to
>> >> >> >> > add rcu_read_lock() at least around the invocation of
>> >> >> >> > bpf_prog_run_xdp() or before around if-statement that call
>> >> >> >> > dev_map_bpf_prog_run(). (Hangbin please do this in V8).
>> >> >> >> >=20
>> >> >> >> > Thank you Martin for reviewing the code carefully enough to f=
ind this
>> >> >> >> > issue, that some drivers don't have a RCU-section around the =
full XDP
>> >> >> >> > code path in their NAPI-loop.
>> >> >> >> >=20
>> >> >> >> > Question to Paul.  (I will attempt to describe in generic ter=
ms what
>> >> >> >> > happens, but ref real-function names).
>> >> >> >> >=20
>> >> >> >> > We are running in softirq/NAPI context, the driver will call a
>> >> >> >> > bq_enqueue() function for every packet (if calling xdp_do_red=
irect) ,
>> >> >> >> > some driver wrap this with a rcu_read_lock/unlock() section (=
other have
>> >> >> >> > a large RCU-read section, that include the flush operation).
>> >> >> >> >=20
>> >> >> >> > In the bq_enqueue() function we have a per_cpu_ptr (that stor=
e the
>> >> >> >> > xdp_frame packets) that will get flushed/send in the call
>> >> >> >> > xdp_do_flush() (that end-up calling bq_xmit_all()).  This flu=
sh will
>> >> >> >> > happen before we end our softirq/NAPI context.
>> >> >> >> >=20
>> >> >> >> > The extension is that the per_cpu_ptr data structure (after t=
his patch)
>> >> >> >> > store a pointer to an xdp_prog (which is a RCU object).  In t=
he flush
>> >> >> >> > operation (which we will wrap with RCU-read section), we will=
 use this
>> >> >> >> > xdp_prog pointer.   I can see that it is in-principle wrong t=
o pass
>> >> >> >> > this-pointer between RCU-read sections, but I consider this s=
afe as we
>> >> >> >> > are running under softirq/NAPI and the per_cpu_ptr is only va=
lid in
>> >> >> >> > this short interval.
>> >> >> >> >=20
>> >> >> >> > I claim a grace/quiescent RCU cannot happen between these two=
 RCU-read
>> >> >> >> > sections, but I might be wrong? (especially in the future or =
for RT).
>> >> >> >
>> >> >> > If I am reading this correctly (ha!), a very high-level summary =
of the
>> >> >> > code in question is something like this:
>> >> >> >
>> >> >> > 	void foo(void)
>> >> >> > 	{
>> >> >> > 		local_bh_disable();
>> >> >> >
>> >> >> > 		rcu_read_lock();
>> >> >> > 		p =3D rcu_dereference(gp);
>> >> >> > 		do_something_with(p);
>> >> >> > 		rcu_read_unlock();
>> >> >> >
>> >> >> > 		do_something_else();
>> >> >> >
>> >> >> > 		rcu_read_lock();
>> >> >> > 		do_some_other_thing(p);
>> >> >> > 		rcu_read_unlock();
>> >> >> >
>> >> >> > 		local_bh_enable();
>> >> >> > 	}
>> >> >> >
>> >> >> > 	void bar(struct blat *new_gp)
>> >> >> > 	{
>> >> >> > 		struct blat *old_gp;
>> >> >> >
>> >> >> > 		spin_lock(my_lock);
>> >> >> > 		old_gp =3D rcu_dereference_protected(gp, lock_held(my_lock));
>> >> >> > 		rcu_assign_pointer(gp, new_gp);
>> >> >> > 		spin_unlock(my_lock);
>> >> >> > 		synchronize_rcu();
>> >> >> > 		kfree(old_gp);
>> >> >> > 	}
>> >> >>=20
>> >> >> Yeah, something like that (the object is freed using call_rcu() - =
but I
>> >> >> think that's equivalent, right?). And the question is whether we n=
eed to
>> >> >> extend foo() so that is has one big rcu_read_lock() that covers the
>> >> >> whole lifetime of p.
>> >> >
>> >> > Yes, use of call_rcu() is an asynchronous version of synchronize_rc=
u().
>> >> > In fact, synchronize_rcu() is implemented in terms of call_rcu().  =
;-)
>> >>=20
>> >> Right, gotcha!
>> >>=20
>> >> >> > I need to check up on -rt.
>> >> >> >
>> >> >> > But first... In recent mainline kernels, the local_bh_disable() =
region
>> >> >> > will look like one big RCU read-side critical section.  But don'=
t try
>> >> >> > this prior to v4.20!!!  In v4.19 and earlier, you would need to =
use
>> >> >> > both synchronize_rcu() and synchronize_rcu_bh() to make this wor=
k, or,
>> >> >> > for less latency, synchronize_rcu_mult(call_rcu, call_rcu_bh).
>> >> >>=20
>> >> >> OK. Variants of this code has been around since before then, but I
>> >> >> honestly have no idea what it looked like back then exactly...
>> >> >
>> >> > I know that feeling...
>> >> >
>> >> >> > Except that in that case, why not just drop the inner rcu_read_u=
nlock()
>> >> >> > and rcu_read_lock() pair?  Awkward function boundaries or some s=
uch?
>> >> >>=20
>> >> >> Well if we can just treat such a local_bh_disable()/enable() pair =
as the
>> >> >> equivalent of rcu_read_lock()/unlock() then I suppose we could jus=
t get
>> >> >> rid of the inner ones. What about tools like lockdep; do they unde=
rstand
>> >> >> this, or are we likely to get complaints if we remove it?
>> >> >
>> >> > If you just got rid of the first rcu_read_unlock() and the second
>> >> > rcu_read_lock() in the code above, lockdep will understand.
>> >>=20
>> >> Right, but doing so entails going through all the drivers, which is w=
hat
>> >> we're trying to avoid :)
>> >
>> > I was afraid of that...  ;-)
>> >
>> >> > However, if you instead get rid of -all- of the rcu_read_lock() and
>> >> > rcu_read_unlock() invocations in the code above, you would need to =
let
>> >> > lockdep know by adding rcu_read_lock_bh_held().  So instead of this:
>> >> >
>> >> > 	p =3D rcu_dereference(gp);
>> >> >
>> >> > You would do this:
>> >> >
>> >> > 	p =3D rcu_dereference_check(gp, rcu_read_lock_bh_held());
>> >> >
>> >> > This would be needed for mainline, regardless of -rt.
>> >>=20
>> >> OK. And as far as I can tell this is harmless for code paths that call
>> >> the same function but from a regular rcu_read_lock()-protected section
>> >> instead from a bh-disabled section, right?
>> >
>> > That is correct.  That rcu_dereference_check() invocation will make
>> > lockdep be OK with rcu_read_lock() or with softirq being disabled.
>> > Or both, for that matter.
>>=20
>> OK, great, thank you for confirming my understanding!
>>=20
>> >> What happens, BTW, if we *don't* get rid of all the existing
>> >> rcu_read_lock() sections? Going back to your foo() example above, what
>> >> we're discussing is whether to add that second rcu_read_lock() around
>> >> do_some_other_thing(p). I.e., the first one around the rcu_dereferenc=
e()
>> >> is already there (in the particular driver we're discussing), and the
>> >> local_bh_disable/enable() pair is already there. AFAICT from our
>> >> discussion, there really is not much point in adding that second
>> >> rcu_read_lock/unlock(), is there?
>> >
>> > From an algorithmic point of view, the second rcu_read_lock()
>> > and rcu_read_unlock() are redundant.  Of course, there are also
>> > software-engineering considerations, including copy-pasta issues.
>> >
>> >> And because that first rcu_read_lock() around the rcu_dereference() is
>> >> already there, lockdep is not likely to complain either, so we're
>> >> basically fine? Except that the code is somewhat confusing as-is, of
>> >> course; i.e., we should probably fix it but it's not terribly urgent.=
 Or?
>> >
>> > I am concerned about copy-pasta-induced bugs.  Someone looks just at
>> > the code, fails to note the fact that softirq is disabled throughout,
>> > and decides that leaking a pointer from one RCU read-side critical
>> > section to a later one is just fine.  :-/
>>=20
>> Yup, totally agreed that we need to fix this for the sake of the humans
>> reading the code; just wanted to make sure my understanding was correct
>> that we don't strictly need to do anything as far as the machines
>> executing it are concerned :)
>>=20
>> >> Hmm, looking at it now, it seems not all the lookup code is actually
>> >> doing rcu_dereference() at all, but rather just a plain READ_ONCE() w=
ith
>> >> a comment above it saying that RCU ensures objects won't disappear[0];
>> >> so I suppose we're at least safe from lockdep in that sense :P - but =
we
>> >> should definitely clean this up.
>> >>=20
>> >> [0] Exhibit A: https://elixir.bootlin.com/linux/latest/source/kernel/=
bpf/devmap.c#L391
>> >
>> > That use of READ_ONCE() will definitely avoid lockdep complaints,
>> > including those complaints that point out bugs.  It also might get you
>> > sparse complaints if the RCU-protected pointer is marked with __rcu.
>>=20
>> It's not; it's the netdev_map member of this struct:
>>=20
>> struct bpf_dtab {
>> 	struct bpf_map map;
>> 	struct bpf_dtab_netdev **netdev_map; /* DEVMAP type only */
>> 	struct list_head list;
>>=20
>> 	/* these are only used for DEVMAP_HASH type maps */
>> 	struct hlist_head *dev_index_head;
>> 	spinlock_t index_lock;
>> 	unsigned int items;
>> 	u32 n_buckets;
>> };
>>=20
>> Will adding __rcu to such a dynamic array member do the right thing when
>> paired with rcu_dereference() on array members (i.e., in place of the
>> READ_ONCE in the code linked above)?
>
> The only thing __rcu will do is provide information to the sparse static
> analysis tool.  Which will then gripe at you for applying READ_ONCE()
> to a __rcu pointer.  But it is already griping at you for applying
> rcu_dereference() to something not marked __rcu, so...  ;-)

Right, hence the need for a cleanup ;)

My question was more if it understood arrays, though. I.e., that
'netdev_map' is an array of RCU pointers, not an RCU pointer to an
array... Or am I maybe thinking that tool is way smarter than it is, and
it just complains for any access to that field that doesn't use
rcu_dereference()?

>> Also, while you're being so nice about confirming my understanding of
>> things: I always understood the point of rcu_dereference() (and __rcu on
>> struct members) to be annotations that document the lifetime
>> expectations of the object being pointed to, rather than a functional
>> change vs READ_ONCE()? Documentation that the static checkers can turn
>> into warnings, of course, but totally transparent in terms of the
>> generated code. Right? :)
>
> Yes for __rcu.
>
> Maybe for rcu_dereference().  Yes in that it is functionally the same
> as READ_ONCE(), no in that it is not the same as a simple C-language load.

Right, was going for "functionally the same" - cool!

>> >> >> > Especially given that if this works on -rt, it is probably becau=
se
>> >> >> > their variant of do_softirq() holds rcu_read_lock() across each
>> >> >> > softirq handler invocation. They do something similar for rwlock=
s.
>> >> >>=20
>> >> >> Right. Guess we'll wait for your confirmation of that, then. Thank=
s! :)
>> >> >
>> >> > Looking at v5.11.4-rt11...
>> >> >
>> >> > And __local_bh_disable_ip() has added the required rcu_read_lock(),
>> >> > so dropping all the rcu_read_lock() and rcu_read_unlock() calls wou=
ld
>> >> > do the right thing in -rt.  And lockdep would understand without the
>> >> > rcu_read_lock_bh_held(), but that is still required for mainline.
>> >>=20
>> >> Great, thanks for checking!
>> >>=20
>> >> So this brings to mind another question: Are there any performance
>> >> implications to nesting rcu_read_locks() inside each other? One
>> >> thing that would be fairly easy to do (in terms of how much code we h=
ave
>> >> to touch) is to just add a top-level rcu_read_lock() around the
>> >> napi_poll() call in the core dev code, thus making -rt and mainline
>> >> equivalent in that respect. Also, this would make it obvious that all
>> >> the RCU usage inside of NAPI is safe, without having to know about
>> >> bh_disable() and all that. But we obviously don't want to do that if =
it
>> >> is going to slow things down; WDYT?
>> >
>> > Both rcu_read_lock() and rcu_read_unlock() are quite lightweight (zero=
 for
>> > CONFIG_PREEMPT=3Dn and about two nanoseconds per pair for CONFIG_PREEM=
PT=3Dy
>> > on 2GHz x86) and can be nested quite deeply.  So that approach should
>> > be fine from that viewpoint.
>>=20
>> OK, that may be fine, then. Guess I'll try it and benchmark (and compare
>> with the rcu_dereference_check() approach).
>
> Sounds good!

Awesome! Thanks a lot for explaining, and for bearing me and all my
stupid questions - I feel like I get closer to understanding RCU each
time I speak with you about it :)

>> > However, remaining in a single RCU read-side critical section forever
>> > will eventually OOM the system, so the code should periodically exit
>> > its top-level RCU read-side critical section, say, every few tens of
>> > milliseconds.
>>=20
>> Yup, NAPI already does this (there's a poll budget), so that should be
>> fine.
>
> Whew!!!  ;-)

I know, right? ;) Although I do seem to recall you quite recently
helping me fix a case where it didn't quite interrupt itself enough, and
was causing hangs...

-Toke


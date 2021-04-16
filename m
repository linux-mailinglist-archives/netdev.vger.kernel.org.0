Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74915362154
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 15:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243166AbhDPNq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 09:46:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51432 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229706AbhDPNq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 09:46:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618580761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oa5LDEP9CPGhnwNXSai1ubG+32x2mP3X1nVW/ALFn/k=;
        b=ba262vI72sIA/pGn4XFiUxtZfWJfcHLEtaWDIxoeMJYo7mPscccsUUg0WZn7RrDbi376Jc
        vV5XEeJh0ZOn81hYth4icZgyHPRSD8Szn0Bvi9cqXEfB7Irp8/Dk7wv8DCsVfHd8tfFftX
        ZaSc3gQWrreWp2cy9PAoqpc6XJFuQp0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-9Gy1UqSDNrSownMAvLakmQ-1; Fri, 16 Apr 2021 09:45:58 -0400
X-MC-Unique: 9Gy1UqSDNrSownMAvLakmQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BA29814337;
        Fri, 16 Apr 2021 13:45:56 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC4FA50FA2;
        Fri, 16 Apr 2021 13:45:24 +0000 (UTC)
Date:   Fri, 16 Apr 2021 15:45:23 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFQ=?= =?UTF-8?B?w7ZwZWw=?= 
        <bjorn.topel@gmail.com>, brouer@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv7 bpf-next 1/4] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
Message-ID: <20210416154523.3b1fe700@carbon>
In-Reply-To: <20210416003913.azcjk4fqxs7gag3m@kafai-mbp.dhcp.thefacebook.com>
References: <20210414122610.4037085-1-liuhangbin@gmail.com>
        <20210414122610.4037085-2-liuhangbin@gmail.com>
        <20210415001711.dpbt2lej75ry6v7a@kafai-mbp.dhcp.thefacebook.com>
        <20210415023746.GR2900@Leo-laptop-t470s>
        <87o8efkilw.fsf@toke.dk>
        <20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com>
        <20210415202132.7b5e8d0d@carbon>
        <87k0p3i957.fsf@toke.dk>
        <20210416003913.azcjk4fqxs7gag3m@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 17:39:13 -0700
Martin KaFai Lau <kafai@fb.com> wrote:

> On Thu, Apr 15, 2021 at 10:29:40PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> > Jesper Dangaard Brouer <brouer@redhat.com> writes:
> >  =20
> > > On Thu, 15 Apr 2021 10:35:51 -0700
> > > Martin KaFai Lau <kafai@fb.com> wrote:
> > > =20
> > >> On Thu, Apr 15, 2021 at 11:22:19AM +0200, Toke H=C3=B8iland-J=C3=B8r=
gensen wrote: =20
> > >> > Hangbin Liu <liuhangbin@gmail.com> writes:
> > >> >    =20
> > >> > > On Wed, Apr 14, 2021 at 05:17:11PM -0700, Martin KaFai Lau wrote=
:   =20
> > >> > >> >  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 f=
lags)
> > >> > >> >  {
> > >> > >> >  	struct net_device *dev =3D bq->dev;
> > >> > >> > -	int sent =3D 0, err =3D 0;
> > >> > >> > +	int sent =3D 0, drops =3D 0, err =3D 0;
> > >> > >> > +	unsigned int cnt =3D bq->count;
> > >> > >> > +	int to_send =3D cnt;
> > >> > >> >  	int i;
> > >> > >> > =20
> > >> > >> > -	if (unlikely(!bq->count))
> > >> > >> > +	if (unlikely(!cnt))
> > >> > >> >  		return;
> > >> > >> > =20
> > >> > >> > -	for (i =3D 0; i < bq->count; i++) {
> > >> > >> > +	for (i =3D 0; i < cnt; i++) {
> > >> > >> >  		struct xdp_frame *xdpf =3D bq->q[i];
> > >> > >> > =20
> > >> > >> >  		prefetch(xdpf);
> > >> > >> >  	}
> > >> > >> > =20
> > >> > >> > -	sent =3D dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->=
q, flags);
> > >> > >> > +	if (bq->xdp_prog) {   =20
> > >> > >> bq->xdp_prog is used here
> > >> > >>    =20
> > >> > >> > +		to_send =3D dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt,=
 dev);
> > >> > >> > +		if (!to_send)
> > >> > >> > +			goto out;
> > >> > >> > +
> > >> > >> > +		drops =3D cnt - to_send;
> > >> > >> > +	}
> > >> > >> > +   =20
> > >> > >>=20
> > >> > >> [ ... ]
> > >> > >>    =20
> > >> > >> >  static void bq_enqueue(struct net_device *dev, struct xdp_fr=
ame *xdpf,
> > >> > >> > -		       struct net_device *dev_rx)
> > >> > >> > +		       struct net_device *dev_rx, struct bpf_prog *xdp_pro=
g)
> > >> > >> >  {
> > >> > >> >  	struct list_head *flush_list =3D this_cpu_ptr(&dev_flush_li=
st);
> > >> > >> >  	struct xdp_dev_bulk_queue *bq =3D this_cpu_ptr(dev->xdp_bul=
kq);
> > >> > >> > @@ -412,18 +466,22 @@ static void bq_enqueue(struct net_devic=
e *dev, struct xdp_frame *xdpf,
> > >> > >> >  	/* Ingress dev_rx will be the same for all xdp_frame's in
> > >> > >> >  	 * bulk_queue, because bq stored per-CPU and must be flushed
> > >> > >> >  	 * from net_device drivers NAPI func end.
> > >> > >> > +	 *
> > >> > >> > +	 * Do the same with xdp_prog and flush_list since these fie=
lds
> > >> > >> > +	 * are only ever modified together.
> > >> > >> >  	 */
> > >> > >> > -	if (!bq->dev_rx)
> > >> > >> > +	if (!bq->dev_rx) {
> > >> > >> >  		bq->dev_rx =3D dev_rx;
> > >> > >> > +		bq->xdp_prog =3D xdp_prog;   =20
> > >> > >> bp->xdp_prog is assigned here and could be used later in bq_xmi=
t_all().
> > >> > >> How is bq->xdp_prog protected? Are they all under one rcu_read_=
lock()?
> > >> > >> It is not very obvious after taking a quick look at xdp_do_flus=
h[_map].
> > >> > >>=20
> > >> > >> e.g. what if the devmap elem gets deleted.   =20
> > >> > >
> > >> > > Jesper knows better than me. From my veiw, based on the descript=
ion of
> > >> > > __dev_flush():
> > >> > >
> > >> > > On devmap tear down we ensure the flush list is empty before com=
pleting to
> > >> > > ensure all flush operations have completed. When drivers update =
the bpf
> > >> > > program they may need to ensure any flush ops are also complete.=
   =20
> > >>
> > >> AFAICT, the bq->xdp_prog is not from the dev. It is from a devmap's =
elem.

The bq->xdp_prog comes form the devmap "dev" element, and it is stored
in temporarily in the "bq" structure that is only valid for this
softirq NAPI-cycle.  I'm slightly worried that we copied this pointer
the the xdp_prog here, more below (and Q for Paul).

> > >> >=20
> > >> > Yeah, drivers call xdp_do_flush() before exiting their NAPI poll l=
oop,
> > >> > which also runs under one big rcu_read_lock(). So the storage in t=
he
> > >> > bulk queue is quite temporary, it's just used for bulking to incre=
ase
> > >> > performance :)   =20
> > >>
> > >> I am missing the one big rcu_read_lock() part.  For example, in i40e=
_txrx.c,
> > >> i40e_run_xdp() has its own rcu_read_lock/unlock().  dst->xdp_prog us=
ed to run
> > >> in i40e_run_xdp() and it is fine.
> > >>=20
> > >> In this patch, dst->xdp_prog is run outside of i40e_run_xdp() where =
the
> > >> rcu_read_unlock() has already done.  It is now run in xdp_do_flush_m=
ap().
> > >> or I missed the big rcu_read_lock() in i40e_napi_poll()?
> > >>
> > >> I do see the big rcu_read_lock() in mlx5e_napi_poll(). =20
> > >
> > > I believed/assumed xdp_do_flush_map() was already protected under an
> > > rcu_read_lock.  As the devmap and cpumap, which get called via
> > > __dev_flush() and __cpu_map_flush(), have multiple RCU objects that we
> > > are operating on. =20
>
> What other rcu objects it is using during flush?

Look at code:
 kernel/bpf/cpumap.c
 kernel/bpf/devmap.c

The devmap is filled with RCU code and complicated take-down steps. =20
The devmap's elements are also RCU objects and the BPF xdp_prog is
embedded in this object (struct bpf_dtab_netdev).  The call_rcu
function is __dev_map_entry_free().


> > > Perhaps it is a bug in i40e? =20
>
> A quick look into ixgbe falls into the same bucket.
> didn't look at other drivers though.

Intel driver are very much in copy-paste mode.
=20
> > >
> > > We are running in softirq in NAPI context, when xdp_do_flush_map() is
> > > call, which I think means that this CPU will not go-through a RCU gra=
ce
> > > period before we exit softirq, so in-practice it should be safe. =20
> >=20
> > Yup, this seems to be correct: rcu_softirq_qs() is only called between
> > full invocations of the softirq handler, which for networking is
> > net_rx_action(), and so translates into full NAPI poll cycles. =20
>
> I don't know enough to comment on the rcu/softirq part, may be someone
> can chime in.  There is also a recent napi_threaded_poll().

CC added Paul. (link to patch[1][2] for context)

> If it is the case, then some of the existing rcu_read_lock() is unnecessa=
ry?

Well, in many cases, especially depending on how kernel is compiled,
that is true.  But we want to keep these, as they also document the
intend of the programmer.  And allow us to make the kernel even more
preempt-able in the future.

> At least, it sounds incorrect to only make an exception here while keeping
> other rcu_read_lock() as-is.

Let me be clear:  I think you have spotted a problem, and we need to
add rcu_read_lock() at least around the invocation of
bpf_prog_run_xdp() or before around if-statement that call
dev_map_bpf_prog_run(). (Hangbin please do this in V8).

Thank you Martin for reviewing the code carefully enough to find this
issue, that some drivers don't have a RCU-section around the full XDP
code path in their NAPI-loop.

Question to Paul.  (I will attempt to describe in generic terms what
happens, but ref real-function names).

We are running in softirq/NAPI context, the driver will call a
bq_enqueue() function for every packet (if calling xdp_do_redirect) ,
some driver wrap this with a rcu_read_lock/unlock() section (other have
a large RCU-read section, that include the flush operation).

In the bq_enqueue() function we have a per_cpu_ptr (that store the
xdp_frame packets) that will get flushed/send in the call
xdp_do_flush() (that end-up calling bq_xmit_all()).  This flush will
happen before we end our softirq/NAPI context.

The extension is that the per_cpu_ptr data structure (after this patch)
store a pointer to an xdp_prog (which is a RCU object).  In the flush
operation (which we will wrap with RCU-read section), we will use this
xdp_prog pointer.   I can see that it is in-principle wrong to pass
this-pointer between RCU-read sections, but I consider this safe as we
are running under softirq/NAPI and the per_cpu_ptr is only valid in
this short interval.

I claim a grace/quiescent RCU cannot happen between these two RCU-read
sections, but I might be wrong? (especially in the future or for RT).

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

[1] https://lore.kernel.org/netdev/20210414122610.4037085-2-liuhangbin@gmai=
l.com/
[2] https://patchwork.kernel.org/project/netdevbpf/patch/20210414122610.403=
7085-2-liuhangbin@gmail.com/


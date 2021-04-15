Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9D5361209
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 20:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbhDOSWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 14:22:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26461 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234130AbhDOSWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 14:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618510913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fhj4bfFR/cFdFHmJMiJ06RYonGSs/eplc2BPt9zd/NE=;
        b=QXUWd2eJOED2jTBLV54OJkkkSaPZKe5jxgKkjt7Td3/cnlq8RpMdQ0yMd2uAfMYZimL06i
        5rGYftwVtimKGKx5EzYPrSDNjoA8bOPGd3B/M48dNymqll1IFTCL0oQecbyi9AhCQMBJ5U
        8D3QOv1uvZiOEVwJFQa7dveGX0Cpb8M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-by2VZHkmOe6Em9cJ8RWCFg-1; Thu, 15 Apr 2021 14:21:51 -0400
X-MC-Unique: by2VZHkmOe6Em9cJ8RWCFg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08CB9801814;
        Thu, 15 Apr 2021 18:21:50 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DE4C5C3FD;
        Thu, 15 Apr 2021 18:21:33 +0000 (UTC)
Date:   Thu, 15 Apr 2021 20:21:32 +0200
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
        <bjorn.topel@gmail.com>, brouer@redhat.com
Subject: Re: [PATCHv7 bpf-next 1/4] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
Message-ID: <20210415202132.7b5e8d0d@carbon>
In-Reply-To: <20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com>
References: <20210414122610.4037085-1-liuhangbin@gmail.com>
        <20210414122610.4037085-2-liuhangbin@gmail.com>
        <20210415001711.dpbt2lej75ry6v7a@kafai-mbp.dhcp.thefacebook.com>
        <20210415023746.GR2900@Leo-laptop-t470s>
        <87o8efkilw.fsf@toke.dk>
        <20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 10:35:51 -0700
Martin KaFai Lau <kafai@fb.com> wrote:

> On Thu, Apr 15, 2021 at 11:22:19AM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> > Hangbin Liu <liuhangbin@gmail.com> writes:
> >  =20
> > > On Wed, Apr 14, 2021 at 05:17:11PM -0700, Martin KaFai Lau wrote: =20
> > >> >  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
> > >> >  {
> > >> >  	struct net_device *dev =3D bq->dev;
> > >> > -	int sent =3D 0, err =3D 0;
> > >> > +	int sent =3D 0, drops =3D 0, err =3D 0;
> > >> > +	unsigned int cnt =3D bq->count;
> > >> > +	int to_send =3D cnt;
> > >> >  	int i;
> > >> > =20
> > >> > -	if (unlikely(!bq->count))
> > >> > +	if (unlikely(!cnt))
> > >> >  		return;
> > >> > =20
> > >> > -	for (i =3D 0; i < bq->count; i++) {
> > >> > +	for (i =3D 0; i < cnt; i++) {
> > >> >  		struct xdp_frame *xdpf =3D bq->q[i];
> > >> > =20
> > >> >  		prefetch(xdpf);
> > >> >  	}
> > >> > =20
> > >> > -	sent =3D dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, fl=
ags);
> > >> > +	if (bq->xdp_prog) { =20
> > >> bq->xdp_prog is used here
> > >>  =20
> > >> > +		to_send =3D dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> > >> > +		if (!to_send)
> > >> > +			goto out;
> > >> > +
> > >> > +		drops =3D cnt - to_send;
> > >> > +	}
> > >> > + =20
> > >>=20
> > >> [ ... ]
> > >>  =20
> > >> >  static void bq_enqueue(struct net_device *dev, struct xdp_frame *=
xdpf,
> > >> > -		       struct net_device *dev_rx)
> > >> > +		       struct net_device *dev_rx, struct bpf_prog *xdp_prog)
> > >> >  {
> > >> >  	struct list_head *flush_list =3D this_cpu_ptr(&dev_flush_list);
> > >> >  	struct xdp_dev_bulk_queue *bq =3D this_cpu_ptr(dev->xdp_bulkq);
> > >> > @@ -412,18 +466,22 @@ static void bq_enqueue(struct net_device *de=
v, struct xdp_frame *xdpf,
> > >> >  	/* Ingress dev_rx will be the same for all xdp_frame's in
> > >> >  	 * bulk_queue, because bq stored per-CPU and must be flushed
> > >> >  	 * from net_device drivers NAPI func end.
> > >> > +	 *
> > >> > +	 * Do the same with xdp_prog and flush_list since these fields
> > >> > +	 * are only ever modified together.
> > >> >  	 */
> > >> > -	if (!bq->dev_rx)
> > >> > +	if (!bq->dev_rx) {
> > >> >  		bq->dev_rx =3D dev_rx;
> > >> > +		bq->xdp_prog =3D xdp_prog; =20
> > >> bp->xdp_prog is assigned here and could be used later in bq_xmit_all=
().
> > >> How is bq->xdp_prog protected? Are they all under one rcu_read_lock(=
)?
> > >> It is not very obvious after taking a quick look at xdp_do_flush[_ma=
p].
> > >>=20
> > >> e.g. what if the devmap elem gets deleted. =20
> > >
> > > Jesper knows better than me. From my veiw, based on the description of
> > > __dev_flush():
> > >
> > > On devmap tear down we ensure the flush list is empty before completi=
ng to
> > > ensure all flush operations have completed. When drivers update the b=
pf
> > > program they may need to ensure any flush ops are also complete. =20
>
> AFAICT, the bq->xdp_prog is not from the dev. It is from a devmap's elem.
>=20
> >=20
> > Yeah, drivers call xdp_do_flush() before exiting their NAPI poll loop,
> > which also runs under one big rcu_read_lock(). So the storage in the
> > bulk queue is quite temporary, it's just used for bulking to increase
> > performance :) =20
>
> I am missing the one big rcu_read_lock() part.  For example, in i40e_txrx=
.c,
> i40e_run_xdp() has its own rcu_read_lock/unlock().  dst->xdp_prog used to=
 run
> in i40e_run_xdp() and it is fine.
>=20
> In this patch, dst->xdp_prog is run outside of i40e_run_xdp() where the
> rcu_read_unlock() has already done.  It is now run in xdp_do_flush_map().
> or I missed the big rcu_read_lock() in i40e_napi_poll()?
>
> I do see the big rcu_read_lock() in mlx5e_napi_poll().

I believed/assumed xdp_do_flush_map() was already protected under an
rcu_read_lock.  As the devmap and cpumap, which get called via
__dev_flush() and __cpu_map_flush(), have multiple RCU objects that we
are operating on.

Perhaps it is a bug in i40e?

We are running in softirq in NAPI context, when xdp_do_flush_map() is
call, which I think means that this CPU will not go-through a RCU grace
period before we exit softirq, so in-practice it should be safe.  But
to be correct I do think we need a rcu_read_lock() around this call.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


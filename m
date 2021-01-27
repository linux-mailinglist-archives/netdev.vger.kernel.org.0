Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563E53060A6
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 17:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237058AbhA0QJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 11:09:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235397AbhA0PCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 10:02:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611759657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g14JYxt2Wybu59gkchFmhEGYwPfyOtbjK8Qmd2DzbKo=;
        b=JEa1J/7JMtaNLujf4E6NDeaax0YgkgtAHuGpt+J0Mz+2O/CWcLApJ7mMvVyNsG8srRW36C
        LRaklENCrYi3CRSt+QL1jOT7CIj6dqo9z2PkbUNZwJD9ytu+dVh049y/wIGu+BL63TshWv
        uX8Nm9scSSsN3fDToWDbY8R4o7MI9ns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-luM6lbHVPoCvJelwpsbAKg-1; Wed, 27 Jan 2021 10:00:48 -0500
X-MC-Unique: luM6lbHVPoCvJelwpsbAKg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A468B8117;
        Wed, 27 Jan 2021 15:00:45 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B41A60854;
        Wed, 27 Jan 2021 15:00:30 +0000 (UTC)
Date:   Wed, 27 Jan 2021 16:00:29 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        brouer@redhat.com
Subject: Re: [PATCHv17 bpf-next 1/6] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
Message-ID: <20210127160029.73f22659@carbon>
In-Reply-To: <20210127122050.GA41732@ranger.igk.intel.com>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
        <20210125124516.3098129-1-liuhangbin@gmail.com>
        <20210125124516.3098129-2-liuhangbin@gmail.com>
        <6011183d4628_86d69208ba@john-XPS-13-9370.notmuch>
        <87lfcesomf.fsf@toke.dk>
        <20210127122050.GA41732@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 13:20:50 +0100
Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:

> On Wed, Jan 27, 2021 at 10:41:44AM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> > John Fastabend <john.fastabend@gmail.com> writes:
> >  =20
> > > Hangbin Liu wrote: =20
> > >> From: Jesper Dangaard Brouer <brouer@redhat.com>
> > >>=20
> > >> This changes the devmap XDP program support to run the program when =
the
> > >> bulk queue is flushed instead of before the frame is enqueued. This =
has
> > >> a couple of benefits:
> > >>=20
> > >> - It "sorts" the packets by destination devmap entry, and then runs =
the
> > >>   same BPF program on all the packets in sequence. This ensures that=
 we
> > >>   keep the XDP program and destination device properties hot in I-ca=
che.
> > >>=20
> > >> - It makes the multicast implementation simpler because it can just
> > >>   enqueue packets using bq_enqueue() without having to deal with the
> > >>   devmap program at all.
> > >>=20
> > >> The drawback is that if the devmap program drops the packet, the enq=
ueue
> > >> step is redundant. However, arguably this is mostly visible in a
> > >> micro-benchmark, and with more mixed traffic the I-cache benefit sho=
uld
> > >> win out. The performance impact of just this patch is as follows:
> > >>=20
> > >> The bq_xmit_all's logic is also refactored and error label is remove=
d.
> > >> When bq_xmit_all() is called from bq_enqueue(), another packet will
> > >> always be enqueued immediately after, so clearing dev_rx, xdp_prog a=
nd
> > >> flush_node in bq_xmit_all() is redundant. Let's move the clear to
> > >> __dev_flush(), and only check them once in bq_enqueue() since they a=
re
> > >> all modified together.
> > >>=20
> > >> By using xdp_redirect_map in sample/bpf and send pkts via pktgen cmd:
> > >> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_ma=
c -t 10 -s 64
> > >>=20
> > >> There are about +/- 0.1M deviation for native testing, the performan=
ce
> > >> improved for the base-case, but some drop back with xdp devmap prog =
attached.
> > >>=20
> > >> Version          | Test                           | Generic | Native=
 | Native + 2nd xdp_prog
> > >> 5.10 rc6         | xdp_redirect_map   i40e->i40e  |    2.0M |   9.1M=
 |  8.0M
> > >> 5.10 rc6         | xdp_redirect_map   i40e->veth  |    1.7M |  11.0M=
 |  9.7M
> > >> 5.10 rc6 + patch | xdp_redirect_map   i40e->i40e  |    2.0M |   9.5M=
 |  7.5M
> > >> 5.10 rc6 + patch | xdp_redirect_map   i40e->veth  |    1.7M |  11.6M=
 |  9.1M
> > >>  =20
> > >
> > > [...]
> > > =20
> > >> +static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
> > >> +				struct xdp_frame **frames, int n,
> > >> +				struct net_device *dev)
> > >> +{
> > >> +	struct xdp_txq_info txq =3D { .dev =3D dev };
> > >> +	struct xdp_buff xdp;
> > >> +	int i, nframes =3D 0;
> > >> +
> > >> +	for (i =3D 0; i < n; i++) {
> > >> +		struct xdp_frame *xdpf =3D frames[i];
> > >> +		u32 act;
> > >> +		int err;
> > >> +
> > >> +		xdp_convert_frame_to_buff(xdpf, &xdp);
> > >> +		xdp.txq =3D &txq;
> > >> +
> > >> +		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > >> +		switch (act) {
> > >> +		case XDP_PASS:
> > >> +			err =3D xdp_update_frame_from_buff(&xdp, xdpf);
> > >> +			if (unlikely(err < 0))
> > >> +				xdp_return_frame_rx_napi(xdpf);
> > >> +			else
> > >> +				frames[nframes++] =3D xdpf;
> > >> +			break;
> > >> +		default:
> > >> +			bpf_warn_invalid_xdp_action(act);
> > >> +			fallthrough;
> > >> +		case XDP_ABORTED:
> > >> +			trace_xdp_exception(dev, xdp_prog, act);
> > >> +			fallthrough;
> > >> +		case XDP_DROP:
> > >> +			xdp_return_frame_rx_napi(xdpf);
> > >> +			break;
> > >> +		}
> > >> +	}
> > >> +	return nframes; /* sent frames count */
> > >> +}
> > >> +
> > >>  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
> > >>  {
> > >>  	struct net_device *dev =3D bq->dev;
> > >> -	int sent =3D 0, drops =3D 0, err =3D 0;
> > >> +	unsigned int cnt =3D bq->count;
> > >> +	int drops =3D 0, err =3D 0;
> > >> +	int to_send =3D cnt;
> > >> +	int sent =3D cnt;
> > >>  	int i;
> > >> =20
> > >> -	if (unlikely(!bq->count))
> > >> +	if (unlikely(!cnt))
> > >>  		return;
> > >> =20
> > >> -	for (i =3D 0; i < bq->count; i++) {
> > >> +	for (i =3D 0; i < cnt; i++) {
> > >>  		struct xdp_frame *xdpf =3D bq->q[i];
> > >> =20
> > >>  		prefetch(xdpf);
> > >>  	}
> > >> =20
> > >> -	sent =3D dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flag=
s);
> > >> +	if (bq->xdp_prog) {
> > >> +		to_send =3D dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> > >> +		if (!to_send) {
> > >> +			sent =3D 0;
> > >> +			goto out;
> > >> +		}
> > >> +		drops =3D cnt - to_send;
> > >> +	} =20
> > >
> > > I might be missing something about how *bq works here. What happens w=
hen
> > > dev_map_bpf_prog_run returns to_send < cnt?
> > >
> > > So I read this as it will send [0, to_send] and [to_send, cnt] will be
> > > dropped? How do we know the bpf prog would have dropped the set,
> > > [to_send+1, cnt]? =20
>=20
> You know that via recalculation of 'drops' value after you returned from
> dev_map_bpf_prog_run() which later on is provided onto trace_xdp_devmap_x=
mit.
>=20
> >=20
> > Because dev_map_bpf_prog_run() compacts the array:
> >=20
> > +		case XDP_PASS:
> > +			err =3D xdp_update_frame_from_buff(&xdp, xdpf);
> > +			if (unlikely(err < 0))
> > +				xdp_return_frame_rx_napi(xdpf);
> > +			else
> > +				frames[nframes++] =3D xdpf;
> > +			break; =20
>=20
> To expand this a little, 'frames' array is reused and 'nframes' above is
> the value that is returned and we store it onto 'to_send' variable.
>=20
> >=20
> > [...]
> >  =20
> > >>  int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *x=
dp,
> > >> @@ -489,12 +516,7 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst=
, struct xdp_buff *xdp,
> > >>  {
> > >>  	struct net_device *dev =3D dst->dev;
> > >> =20
> > >> -	if (dst->xdp_prog) {
> > >> -		xdp =3D dev_map_run_prog(dev, xdp, dst->xdp_prog);
> > >> -		if (!xdp)
> > >> -			return 0; =20
> > >
> > > So here it looks like dev_map_run_prog will not drop extra
> > > packets, but will see every single packet.
> > >
> > > Are we changing the semantics subtle here? This looks like
> > > a problem to me. We should not drop packets in the new case
> > > unless bpf program tells us to. =20
> >=20
> > It's not a change in semantics (see above), but I'll grant you that it's
> > subtle :) =20
>=20
> dev map xdp prog still sees all of the frames.
>=20
> Maybe you were referring to a fact that for XDP_PASS action you might fail
> with xdp->xdpf conversion?
>=20
> I'm wondering if we could actually do a further optimization and avoid
> xdpf/xdp juggling.
>=20
> What if xdp_dev_bulk_queue would be storing the xdp_buffs instead of
> xdp_frames ?

Not possible. Remember that struct xdp_buff is "allocated" on the call
stack.  Thus, you cannot store a pointer to the xdp_buffs in
xdp_dev_bulk_queue.

The xdp_frame also avoids allocation, via using memory placed in top of
data-frame.  Thus, you can store a pointer to the xdp_frame, as it is
actually backed by real memory.=20

See[1] slide-11 ("Fundamental structs")

> Then you hit bq_xmit_all and if prog is present it doesn't have to do that
> dance like we have right now. After that you walk through xdp_buff array
> and do the conversion so that xdp_frame array will be passed do
> ndo_xdp_xmit.

If you want to performance optimize this, I suggest that we detect if
we need to call xdp_update_frame_from_buff(&xdp, xdpf) after the 2nd
XDP-prog ran.  In many case the BPF-prog don't move head/tail/metadata,
so that call becomes unnecessary.

=20
> I had a bad sleep so maybe I'm talking nonsense over here, will take
> another look in the evening though :)

:)

[1] https://people.netfilter.org/hawk/presentations/KernelRecipes2019/xdp-n=
etstack-concert.pdf
--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


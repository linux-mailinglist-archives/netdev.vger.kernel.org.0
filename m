Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F0E307CD6
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 18:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbhA1Rm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 12:42:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232661AbhA1RmM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 12:42:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 147F464DEB;
        Thu, 28 Jan 2021 17:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611855691;
        bh=plKrGzqzr3ZDaMZm28y/Ohq7tC6n7IczSOS9OQ96dFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N/y5hmsjJEqYeIGA09C3K+2GK/pZX5COB8ydaq7KAuP8CoHbjNcxwUiZdt62JH+zc
         BksZrIu55cQ4NsdocJtLxEdy3LYaTucSRS5YWYxfDHCgcSoEODp+RJRTFiZO3+tAm6
         f3AYsBlp8AHrmAo05JLX3IU+9wdR/TA1gGjyeYts4yon1HDTiYwOmtkyWxidM1qRfR
         FzBAs8r9zPKa6MFFrLbEj7ckNK5D+Z13Zr+wj3OIh7lFPSSFMLIOaeboFHgQsO4IOd
         lwwCaL3Tpy14kWieKDQ9IsVijgmhbnqsYXSpMA1O6tAwIcFxRkqh8BVo7VH907EWnj
         PoQQI1b59H+Jw==
Date:   Thu, 28 Jan 2021 18:41:26 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com
Subject: Re: [PATCH bpf-next 1/3] net: veth: introduce bulking for XDP_PASS
Message-ID: <20210128174126.GA2965@lore-desk>
References: <cover.1611685778.git.lorenzo@kernel.org>
 <adca75284e30320e9d692d618a6349319d9340f3.1611685778.git.lorenzo@kernel.org>
 <de16aab2-58a5-dd0b-1577-4fa04a6806ce@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <de16aab2-58a5-dd0b-1577-4fa04a6806ce@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 2021/01/27 3:41, Lorenzo Bianconi wrote:
> > Introduce bulking support for XDP_PASS verdict forwarding skbs to
> > the networking stack
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   drivers/net/veth.c | 43 ++++++++++++++++++++++++++-----------------
> >   1 file changed, 26 insertions(+), 17 deletions(-)
> >=20
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index 6e03b619c93c..23137d9966da 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -35,6 +35,7 @@
> >   #define VETH_XDP_HEADROOM	(XDP_PACKET_HEADROOM + NET_IP_ALIGN)
> >   #define VETH_XDP_TX_BULK_SIZE	16
> > +#define VETH_XDP_BATCH		8
> >   struct veth_stats {
> >   	u64	rx_drops;
> > @@ -787,27 +788,35 @@ static int veth_xdp_rcv(struct veth_rq *rq, int b=
udget,
> >   	int i, done =3D 0;
> >   	for (i =3D 0; i < budget; i++) {
> > -		void *ptr =3D __ptr_ring_consume(&rq->xdp_ring);
> > -		struct sk_buff *skb;
> > +		void *frames[VETH_XDP_BATCH];
> > +		void *skbs[VETH_XDP_BATCH];
> > +		int i, n_frame, n_skb =3D 0;
>=20
> 'i' is a shadowed variable. I think this may be confusing.

ack, I will fix it in v2

>=20
> > -		if (!ptr)
> > +		n_frame =3D __ptr_ring_consume_batched(&rq->xdp_ring, frames,
> > +						     VETH_XDP_BATCH);
>=20
> This apparently exceeds the budget.
> This will process budget*VETH_XDP_BATCH packets at most.
> (You are probably aware of this because you return 'i' instead of 'done'?)

right, I will fix it in v2

>=20
> Also I'm not sure if we need to introduce __ptr_ring_consume_batched() he=
re.
> The function just does __ptr_ring_consume() n times.
>=20
> IIUC Your final code looks like this:
>=20
> for (budget) {
> 	n_frame =3D __ptr_ring_consume_batched(VETH_XDP_BATCH);
> 	for (n_frame) {
> 		if (frame is XDP)
> 			xdpf[n_xdpf++] =3D to_xdp(frame);
> 		else
> 			skbs[n_skb++] =3D frame;
> 	}
>=20
> 	if (n_xdpf)
> 		veth_xdp_rcv_batch(xdpf);
>=20
> 	for (n_skb) {
> 		skb =3D veth_xdp_rcv_skb(skbs[i]);
> 		napi_gro_receive(skb);
> 	}
> }
>=20
> Your code processes VETH_XDP_BATCH packets at a time no matter whether ea=
ch
> of them is xdp_frame or skb, but I think you actually want to process
> VETH_XDP_BATCH xdp_frames at a time?
> Then, why not doing like this?
>=20
> for (budget) {
> 	ptr =3D __ptr_ring_consume();
> 	if (ptr is XDP) {
> 		if (n_xdpf >=3D VETH_XDP_BATCH) {
> 			veth_xdp_rcv_batch(xdpf);
> 			n_xdpf =3D 0;
> 		}
> 		xdpf[n_xdpf++] =3D to_xdp(ptr);
> 	} else {
> 		skb =3D veth_xdp_rcv_skb(ptr);
> 		napi_gro_receive(skb);
> 	}
> }
> if (n_xdpf)
> 	veth_xdp_rcv_batch(xdpf);

I agree, the code is more readable. I will fix it in v2.
I guess we can drop patch 2/3 and squash patch 1/3 and 3/3.

Regards,
Lorenzo

>=20
> Toshiaki Makita

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYBL3RAAKCRA6cBh0uS2t
rJtSAQDOnXX2KFGKgwevregVHHHp5yCeaOp30L6CidkBz+a+VwD/ctnxA5h1dNvW
IPBnoZyY5cLPlJ8rj507QKD6c1uejA8=
=9Apq
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--

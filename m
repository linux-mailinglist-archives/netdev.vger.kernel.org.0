Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5A4308F8C
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbhA2VmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:42:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233058AbhA2VmA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 16:42:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A74364E0B;
        Fri, 29 Jan 2021 21:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611956479;
        bh=nxD+Ik51Ft996F6lqxR6jr9zZoSII2q6jCh8WSDdinM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KkfS+IYd4tk5SUF4UzgR5ZvPVi7jfuqyJJrm+bxJ6NRgYIViGlRTI0Q4Ab5tadizG
         ah+u8kjWq0+btArKq4qNe9blPToPQyQ+bDArjnkQCR7ojlBg2vYUu08Pa7qVHYtvxl
         SHoXFfEqt8Dkr0jl6++EEn78ARHxPX2RIG/GV9mZCAN3eQwe3nglybQLOyv73GdpO/
         0Q67lHEvV+KiLoEnlpOd07a3GT1TTcFOTO/36xpOY2u7cI/cuWMxaIggtydlkj37TK
         FLA1HtAsOrxY7sWIIVf3H1F3NR6BCVGHPNFcecSiV1KblQ2rqlx7ltfabE2mG+Walh
         NDjN1Jnzxk2Pg==
Date:   Fri, 29 Jan 2021 22:41:14 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com
Subject: Re: [PATCH v2 bpf-next] net: veth: alloc skb in bulk for ndo_xdp_xmit
Message-ID: <20210129214114.GA20729@lore-desk>
References: <415937741661ac331be09c0e59b4ff1eacfee782.1611861943.git.lorenzo@kernel.org>
 <36298336-72f9-75a5-781e-7cb01dac1702@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <36298336-72f9-75a5-781e-7cb01dac1702@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 2021/01/29 4:41, Lorenzo Bianconi wrote:
> > Split ndo_xdp_xmit and ndo_start_xmit use cases in veth_xdp_rcv routine
> > in order to alloc skbs in bulk for XDP_PASS verdict.
> > Introduce xdp_alloc_skb_bulk utility routine to alloc skb bulk list.
> > The proposed approach has been tested in the following scenario:
> >=20
> > eth (ixgbe) --> XDP_REDIRECT --> veth0 --> (remote-ns) veth1 --> XDP_PA=
SS
> >=20
> > XDP_REDIRECT: xdp_redirect_map bpf sample
> > XDP_PASS: xdp_rxq_info bpf sample
> >=20
> > traffic generator: pkt_gen sending udp traffic on a remote device
> >=20
> > bpf-next master: ~3.64Mpps
> > bpf-next + skb bulking allocation: ~3.75Mpps
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> ...
> > +/* frames array contains VETH_XDP_BATCH at most */
> > +static void veth_xdp_rcv_batch(struct veth_rq *rq, void **frames,
> > +			       int n_xdpf, struct veth_xdp_tx_bq *bq,
> > +			       struct veth_stats *stats)
> > +{
> > +	void *skbs[VETH_XDP_BATCH];
> > +	int i, n_skb =3D 0;
> > +
> > +	for (i =3D 0; i < n_xdpf; i++) {
> > +		struct xdp_frame *frame =3D frames[i];
> > +
> > +		stats->xdp_bytes +=3D frame->len;
> > +		frame =3D veth_xdp_rcv_one(rq, frame, bq, stats);
> > +		if (frame)
> > +			frames[n_skb++] =3D frame;
> > +	}
>=20
> Maybe we can move this block to veth_xdp_rcv() and make the logic even mo=
re simple?
>=20
> Something like this:
>=20
> static int veth_xdp_rcv(struct veth_rq *rq, int budget,
> 	...
> 		if (veth_is_xdp_frame(ptr)) {
> 			struct xdp_frame *frame =3D veth_ptr_to_xdp(ptr);
>=20
> 			stats->xdp_bytes +=3D frame->len;
> 			frame =3D veth_xdp_rcv_one(rq, frame, bq, stats);
> 			if (frame) {
> 				xdpf[n_xdpf++] =3D frame;
> 				if (n_xdpf =3D=3D VETH_XDP_BATCH) {
> 					veth_xdp_rcv_batch(rq, xdpf, n_xdpf, bq,
> 							   stats);
> 					n_xdpf =3D 0;
> 				}
> 			}
>=20
> Then we can fully make use of skb bulk allocation as xdpf[] does not incl=
ude
> frames which may be XDP_TX'ed or XDP_REDIRECT'ed.
>=20
> WDYT?

I gues the code is more readable, I will fix in v3. Thanks.

Regards,
Lorenzo

>=20
> Toshiaki Makita

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYBSA+AAKCRA6cBh0uS2t
rAW1AQDdCdLHZkOmFEgCLdTxAldBYjdijOxC7d+PkRPPZ8YilgD/ZZpQz4cKz2Uk
tAcAWKNoTqhvIRzOyA774IltFD3Zzwc=
=eY3D
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--

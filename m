Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CEA24B0D2
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 10:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgHTINX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 04:13:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgHTIL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 04:11:57 -0400
Received: from localhost (unknown [151.48.139.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC1632080C;
        Thu, 20 Aug 2020 08:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597911116;
        bh=c8IHdpgUofJgH17OfpXZ8mbOL/0v2aSMDySpoG9Nz7I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oKwgTUmAdkALKJDRRj4Cjyg0AlWIbAJUE2V7l9vNGmse9rVdUg8vZzma7s6YVNjeT
         yKRbli8jtCRIKTbrnp51ppin3BhdOd5ErjgvzvXYUg9CRI3szsxci+jLNLSvu26YuB
         YdajDecUojy75S73O27vu6bz8mT93ejIcrmig0HA=
Date:   Thu, 20 Aug 2020 10:11:51 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: Re: [PATCH net-next 3/6] net: mvneta: update mb bit before passing
 the xdp buffer to eBPF layer
Message-ID: <20200820081151.GD2282@lore-desk>
References: <cover.1597842004.git.lorenzo@kernel.org>
 <08f8656e906ff69bd30915a6a37a01d5f0422194.1597842004.git.lorenzo@kernel.org>
 <20200820100215.1b93464f@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bjuZg6miEcdLYP6q"
Content-Disposition: inline
In-Reply-To: <20200820100215.1b93464f@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bjuZg6miEcdLYP6q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 19 Aug 2020 15:13:48 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
> > XDP remote drivers if this is a "non-linear" XDP buffer
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index 832bbb8b05c8..36a3defa63fa 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -2170,11 +2170,14 @@ mvneta_run_xdp(struct mvneta_port *pp, struct m=
vneta_rx_queue *rxq,
> >  	       struct bpf_prog *prog, struct xdp_buff *xdp,
> >  	       u32 frame_sz, struct mvneta_stats *stats)
> >  {
> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> >  	unsigned int len, data_len, sync;
> >  	u32 ret, act;
> > =20
> >  	len =3D xdp->data_end - xdp->data_hard_start - pp->rx_offset_correcti=
on;
> >  	data_len =3D xdp->data_end - xdp->data;
> > +
> > +	xdp->mb =3D !!sinfo->nr_frags;
> >  	act =3D bpf_prog_run_xdp(prog, xdp);
>=20
> Reading the memory sinfo->nr_frags could be a performance issue for our
> baseline case of no-multi-buffer.  As you are reading a cache-line that
> you don't need to (and driver have not touch yet).

ack, I will rework it in v2 to remove this access.

Regards,
Lorenzo

>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--bjuZg6miEcdLYP6q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXz4wRQAKCRA6cBh0uS2t
rAZnAQD1n0h+sVSzJJUmmzYyNKV4sDY19aLV1SX6fSfEySCZRAD+PJnaOgAaSgCY
yd/VrWsb7Q3N6DqR1U2cVv+tkdaoPA8=
=ZqCa
-----END PGP SIGNATURE-----

--bjuZg6miEcdLYP6q--

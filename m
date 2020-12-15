Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664E02DB542
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 21:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgLOUhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 15:37:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbgLOUhc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 15:37:32 -0500
Date:   Tue, 15 Dec 2020 21:36:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608064611;
        bh=jYq2bwWzodKvXyklF/TP3A0O817lyjpRHudJwoZ5l5Q=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=ce0uQVIieWoQ5gdZ3xonIRq3ft0jddvRtk7G6B3Y6qhHJ7Wu2fF18WhG5kO7myTYc
         Zv1glUkcAuIEhUD/DMtBOabGDIpWbZcv5IGBMRbmpxRczWztiVdAP/fbpDpH/Zc3eE
         JRuqbsGiz2SQVniIoJ2Tm35StRVfaW8HWQeO5IsZVIKUptjz1YtelCh6C31ZwFxAoX
         0CXbrruszt2ZBJEXFGX9R49X+5U5QXGCrFMnDrAD2qyQGfX3CPSuiqccNPnaPBDQzD
         MxyxlnLk2FP8glmWzXK1vmwASBdc4/Lc8yiwpkVcRSXEbplRtvgBVB5b/f5ySyAsJb
         PQqXhVbzbjiCg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, brouer@redhat.com, alexander.duyck@gmail.com,
        saeed@kernel.org
Subject: Re: [PATCH v3 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
Message-ID: <20201215203646.GA910956@lore-desk>
References: <cover.1607794551.git.lorenzo@kernel.org>
 <71d5ae9f810c2c80f1cb09e304330be0b5ce5345.1607794552.git.lorenzo@kernel.org>
 <20201215123643.GA23785@ranger.igk.intel.com>
 <20201215134710.GB5477@lore-desk>
 <6886cd02-8dec-1905-b878-d45ee9a0c9b4@iogearbox.net>
 <20201215150620.GC5477@lore-desk>
 <20201215151344.GA24650@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20201215151344.GA24650@ranger.igk.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Dec 15, 2020 at 04:06:20PM +0100, Lorenzo Bianconi wrote:
> > > On 12/15/20 2:47 PM, Lorenzo Bianconi wrote:
> > > [...]
> > > > > > diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfr=
ont.c
> > > > > > index 329397c60d84..61d3f5f8b7f3 100644
> > > > > > --- a/drivers/net/xen-netfront.c
> > > > > > +++ b/drivers/net/xen-netfront.c
> > > > > > @@ -866,10 +866,8 @@ static u32 xennet_run_xdp(struct netfront_=
queue *queue, struct page *pdata,
> > > > > >   	xdp_init_buff(xdp, XEN_PAGE_SIZE - XDP_PACKET_HEADROOM,
> > > > > >   		      &queue->xdp_rxq);
> > > > > > -	xdp->data_hard_start =3D page_address(pdata);
> > > > > > -	xdp->data =3D xdp->data_hard_start + XDP_PACKET_HEADROOM;
> > > > > > +	xdp_prepare_buff(xdp, page_address(pdata), XDP_PACKET_HEADROO=
M, len);
> > > > > >   	xdp_set_data_meta_invalid(xdp);
> > > > > > -	xdp->data_end =3D xdp->data + len;
> > > > > >   	act =3D bpf_prog_run_xdp(prog, xdp);
> > > > > >   	switch (act) {
> > > > > > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > > > > > index 3fb3a9aa1b71..66d8a4b317a3 100644
> > > > > > --- a/include/net/xdp.h
> > > > > > +++ b/include/net/xdp.h
> > > > > > @@ -83,6 +83,18 @@ xdp_init_buff(struct xdp_buff *xdp, u32 fram=
e_sz, struct xdp_rxq_info *rxq)
> > > > > >   	xdp->rxq =3D rxq;
> > > > > >   }
> > > > > > +static inline void
> > >=20
> > > nit: maybe __always_inline
> >=20
> > ack, I will add in v4
> >=20
> > >=20
> > > > > > +xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_sta=
rt,
> > > > > > +		 int headroom, int data_len)
> > > > > > +{
> > > > > > +	unsigned char *data =3D hard_start + headroom;
> > > > > > +
> > > > > > +	xdp->data_hard_start =3D hard_start;
> > > > > > +	xdp->data =3D data;
> > > > > > +	xdp->data_end =3D data + data_len;
> > > > > > +	xdp->data_meta =3D data;
> > > > > > +}
> > > > > > +
> > > > > >   /* Reserve memory area at end-of data area.
> > > > > >    *
> > >=20
> > > For the drivers with xdp_set_data_meta_invalid(), we're basically set=
ting xdp->data_meta
> > > twice unless compiler is smart enough to optimize the first one away =
(did you double check?).
> > > Given this is supposed to be a cleanup, why not integrate this logic =
as well so the
> > > xdp_set_data_meta_invalid() doesn't get extra treatment?
>=20
> That's what I was trying to say previously.
>=20
> >=20
> > we discussed it before, but I am fine to add it in v4. Something like:
> >=20
> > static __always_inline void
> > xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
> > 		 int headroom, int data_len, bool meta_valid)
> > {
> > 	unsigned char *data =3D hard_start + headroom;
> > =09
> > 	xdp->data_hard_start =3D hard_start;
> > 	xdp->data =3D data;
> > 	xdp->data_end =3D data + data_len;
> > 	xdp->data_meta =3D meta_valid ? data : data + 1;
>=20
> This will introduce branch, so for intel drivers we're getting the
> overhead of one add and a branch. I'm still opting for a separate helper.
>=20
> static __always_inline void
> xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
> 		 int headroom, int data_len)
> {
> 	unsigned char *data =3D hard_start + headroom;
>=20
> 	xdp->data_hard_start =3D hard_start;
> 	xdp->data =3D data;
> 	xdp->data_end =3D data + data_len;
> 	xdp_set_data_meta_invalid(xdp);
> }
>=20
> static __always_inline void
> xdp_prepare_buff_meta(struct xdp_buff *xdp, unsigned char *hard_start,
> 		      int headroom, int data_len)
> {
> 	unsigned char *data =3D hard_start + headroom;
>=20
> 	xdp->data_hard_start =3D hard_start;
> 	xdp->data =3D data;
> 	xdp->data_end =3D data + data_len;
> 	xdp->data_meta =3D data;
> }

yes, to follow-up the possible approaches we have here are:

- have 2 different helpers (xdp_prepare_buff_meta and xdp_prepare_buff) as
  suggested by Maciej
- move the data_meta initialization out of the helper and do it in each
  driver
- use the current approach and overwrite data_meta with
  xdp_set_data_meta_invalid() when necessary
- introduce a branch in order to have just one helper

what is the best for you?

Regards,
Lorenzo

>=20
> > }
> >=20
> > Regards,
> > Lorenzo
> >=20
> > >=20
> > > Thanks,
> > > Daniel
> > >=20
>=20
>=20

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX9keXAAKCRA6cBh0uS2t
rAIMAQC+/9Cj7EvKrIx99hqsvoaiovszNh5Y3D93cPh8g6qlUgD/ViVS5d5Vftca
qxKFNS18wRbXmphraIllP1LpUnW0pwE=
=lr2h
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--

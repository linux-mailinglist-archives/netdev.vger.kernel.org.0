Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F002D871D
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 15:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439188AbgLLOfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 09:35:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgLLOfM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 09:35:12 -0500
Date:   Sat, 12 Dec 2020 15:34:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607783671;
        bh=NgIteYLGgyTLF960AVsAocSq4SuZJoun1LIWgl6OYfg=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=ahbZo+nFp3uG9qJuRdVjrvl85mWlc6qDQQolGFLwszBtayHV8DqsbO6+jGPFKsru4
         oIFZZB88aN+29U9nsrx589hBrnZid+TWLx7CtH8eHcyqYoyzcRC9qn7rz4WoLJg4Ce
         dGXgGf45a5lyIP7EBPKO+rV4W6o8Zwqq0vAK9jGX3ZYJpSPArbV1RuIyzlHqEbbRDr
         h+B2RM8ZK6CGLRNmgMUAtkPh3yTag/sEkyWfLwOWFjPVs/8OiCJcHgJ7nwS/MZM9VS
         LWOoAuIFthCxLRVDNquOQ/Ti0bkbUJ0ViJveJc3T5vnkBaun1KQeYX82jH/gWmeCKC
         Lr2LXPch0OboQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        brouer@redhat.com, lorenzo.bianconi@redhat.com,
        alexander.duyck@gmail.com, maciej.fijalkowski@intel.com
Subject: Re: [PATCH v2 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
Message-ID: <20201212143427.GA180288@lore-desk>
References: <cover.1607714335.git.lorenzo@kernel.org>
 <afc242ec96097ae8318a1ba2819aa2daa5e56a51.1607714335.git.lorenzo@kernel.org>
 <59bc3e140cfb859bb8451a1e87da5125b956d778.camel@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <59bc3e140cfb859bb8451a1e87da5125b956d778.camel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Dec 11, Saeed Mahameed wrote:
> On Fri, 2020-12-11 at 20:28 +0100, Lorenzo Bianconi wrote:
> > Introduce xdp_prepare_buff utility routine to initialize per-
> > descriptor
> > xdp_buff fields (e.g. xdp_buff pointers). Rely on xdp_prepare_buff()
> > in
> > all XDP capable drivers.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >=20
> ...
> > +static inline void
> > +xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
> > +		 int headroom, int data_len)
> > +{
> > +	xdp->data_hard_start =3D hard_start;
> > +	xdp->data =3D hard_start + headroom;
> > +	xdp->data_end =3D xdp->data + data_len;
> > +	xdp->data_meta =3D xdp->data;
>=20
> You might want to compute data =3D hard_start + headroom; on a local var,
> and hopefully gcc will put it into a register, then reuse it three
> times instead of the 2 xdp->data de-references you got at the end of
> the function.
>=20
> unsigned char *data =3D hard_start + headroom;
>=20
> xdp->data_hard_start =3D hard_start;
> xdp->data =3D data;
> xdp->data_end =3D data + data_len;
> xdp->data_meta =3D data;

ack, I will fix it in v3.

Regards,
Lorenzo

>=20
>=20

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX9TU8AAKCRA6cBh0uS2t
rB+5AP9D6pa330dvwmERH1AmF6Gn9emKfeuo7/DCwJ7yZSOxfwD+J/c5FKU1z/pG
u8D+1ALW3wnFawQSxKLxZv/7N+wz5Qk=
=FXzd
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--

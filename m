Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6932D69B7
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 22:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394043AbgLJVZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 16:25:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393988AbgLJVZR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 16:25:17 -0500
Date:   Thu, 10 Dec 2020 22:24:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607635476;
        bh=7JOIUKy6ABuwsWpGRfaD+x7h2DzmNQPzA318pYxa0bY=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=nDK1e7qUuF0xLLvLnLTxZAS5KTe5Yz8NPS+FIaFJwlXd/gEQQHxr3OW/NABnfuCzX
         DSRYwPWPB3Wwk8mR2glZ/uFe2YAyQ58NJOT1ZONtMKArXtKyAxRmDFLXM4SDiRx+8Z
         l16aykiqPcOfWWtZyquwd0skEG3pSiU/JFxqeOgcxsin/B99QYzKmGHblZuQR3A24x
         J6J/0r6Lxf4qkH9x6ij/dXrAPVsFzjt88Sc3KEst2IoHZdEC62MXXzc/1jMbunSRHp
         spm/6s0364FImPCy8KfeFMszq5z4JWbTTS4VZoSTwz5JzJ9oYRJ4FARPH3a/KI3WgV
         9YhSZFDVcrPHw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        brouer@redhat.com, alexander.duyck@gmail.com
Subject: Re: [PATCH bpf-next] net: xdp: introduce xdp_init_buff utility
 routine
Message-ID: <20201210212431.GD462213@lore-desk>
References: <e54fb61ff17c21f022392f1bb46ec951c9b909cc.1607615094.git.lorenzo@kernel.org>
 <20201210160507.GC45760@ranger.igk.intel.com>
 <20201210163241.GA462213@lore-desk>
 <20201210165556.GA46492@ranger.igk.intel.com>
 <20201210175945.GB462213@lore-desk>
 <721648a5e14dadc32629291a7d1914dd1044b7d0.camel@kernel.org>
 <20201210192804.GC462213@lore-desk>
 <44ac4e64db37f1e51a61d67c90edb7e0753b0e38.camel@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oj4kGyHlBMXGt3Le"
Content-Disposition: inline
In-Reply-To: <44ac4e64db37f1e51a61d67c90edb7e0753b0e38.camel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--oj4kGyHlBMXGt3Le
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, 2020-12-10 at 20:28 +0100, Lorenzo Bianconi wrote:
> > > On Thu, 2020-12-10 at 18:59 +0100, Lorenzo Bianconi wrote:
> > > > On Dec 10, Maciej Fijalkowski wrote:
> > > > > On Thu, Dec 10, 2020 at 05:32:41PM +0100, Lorenzo Bianconi
> > > > > wrote:
> > > > > > > On Thu, Dec 10, 2020 at 04:50:42PM +0100, Lorenzo Bianconi
> > > > > > > wrote:
> > > > > > > > Introduce xdp_init_buff utility routine to initialize
> > > > > > > > xdp_buff data
> > > > > > > > structure. Rely on xdp_init_buff in all XDP capable
> > > > > > > > drivers.
> > > > > > >=20
> > > > > > > Hm, Jesper was suggesting two helpers, one that you
> > > > > > > implemented
> > > > > > > for things
> > > > > > > that are set once per NAPI and the other that is set per
> > > > > > > each
> > > > > > > buffer.
> > > > > > >=20
> > > > > > > Not sure about the naming for a second one -
> > > > > > > xdp_prepare_buff ?
> > > > > > > xdp_init_buff that you have feels ok.
> > > > > >=20
> > > > > > ack, so we can have xdp_init_buff() for initialization done
> > > > > > once
> > > > > > per NAPI run and=20
> > > > > > xdp_prepare_buff() for per-NAPI iteration initialization,
> > > > > > e.g.
> > > > > >=20
> > > > > > static inline void
> > > > > > xdp_prepare_buff(struct xdp_buff *xdp, unsigned char
> > > > > > *hard_start,
> > > > > > 		 int headroom, int data_len)
> > > > > > {
> > > > > > 	xdp->data_hard_start =3D hard_start;
> > > > > > 	xdp->data =3D hard_start + headroom;
> > > > > > 	xdp->data_end =3D xdp->data + data_len;
> > > > > > 	xdp_set_data_meta_invalid(xdp);
> > > > > > }
> > > > >=20
> > > > > I think we should allow for setting the data_meta as well.
> > > > > x64 calling convention states that first four args are placed
> > > > > onto
> > > > > registers, so to keep it fast maybe have a third helper:
> > > > >=20
> > > > > static inline void
> > > > > xdp_prepare_buff_meta(struct xdp_buff *xdp, unsigned char
> > > > > *hard_start,
> > > > > 		      int headroom, int data_len)
> > > > > {
> > > > > 	xdp->data_hard_start =3D hard_start;
> > > > > 	xdp->data =3D hard_start + headroom;
> > > > > 	xdp->data_end =3D xdp->data + data_len;
> > > > > 	xdp->data_meta =3D xdp->data;
> > > > > }
> > > > >=20
> > > > > Thoughts?
> > > >=20
> > > > ack, I am fine with it. Let's wait for some feedback.
> > > >=20
> > > > Do you prefer to have xdp_prepare_buff/xdp_prepare_buff_meta in
> > > > the
> > > > same series
> > > > of xdp_buff_init() or is it ok to address it in a separate patch?
> > > >=20
> > >=20
> > > you only need 2
> > > why do you need xpd_prepare_buff_meta? that's exactly
> > > what xdp_set_data_meta_invalid(xdp) is all about.
> >=20
> > IIUC what Maciej means is to avoid to overwrite xdp->data_meta with
> > xdp_set_data_meta_invalid() after setting it to xdp->data in
> > xdp_prepare_buff_meta().
> > I guess setting xdp->data_meta to xdp->data is valid, it means an
> > empty meta
> > area.
> > Anyway I guess we can set xdp->data_meta to xdp->data wherever we
> > need and just
> > keep xdp_prepare_buff(). Agree?
> >=20
>=20
> hmm, i agree, but I would choose a default that is best for common use
> case performance, so maybe do xd->data_meta =3D xdp->data by default and
> drivers can override it, as they are already doing today if they don't
> support it.

ack, fine. I will fix int v2.

Regards,
Lorenzo

>=20
> > Regards,
> > Lorenzo
> >=20
> > >=20
>=20

--oj4kGyHlBMXGt3Le
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX9KSCgAKCRA6cBh0uS2t
rLvbAP95L5nkrDxkBxd0Rl3z0ACmZUFiN92H40pCJkbxivb24QEArdnNZhtpqOe1
QNbgSex8+nssP1WPGfZxVlJzjkAKgQQ=
=fvNY
-----END PGP SIGNATURE-----

--oj4kGyHlBMXGt3Le--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75B124B099
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 09:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgHTH4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 03:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgHTH4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 03:56:11 -0400
Received: from localhost (unknown [151.48.139.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4AD2208B3;
        Thu, 20 Aug 2020 07:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597910170;
        bh=uvOux36cqaVQxjtti8BDUxDmxa6cNM28nB608OciMus=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vtMLrYXHk443C3nWtBdPzxGI8G0tdjG99txXDFn09pxMwpsrNqLgkfBJmDaOSjqU0
         t4Rb1K2fP8bC3Bu8CdZ5XQ/Nzj7ewWUbH12lBrLQb1/UEbUxeDDlO1EiotUlgf+Y1G
         WsNl4OrGSXnSUTudKTSWl5Ug1Df/AaM0fflMrvFM=
Date:   Thu, 20 Aug 2020 09:56:05 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: Re: [PATCH net-next 4/6] xdp: add multi-buff support to
 xdp_return_{buff/frame}
Message-ID: <20200820075605.GC2282@lore-desk>
References: <cover.1597842004.git.lorenzo@kernel.org>
 <7ff49193140f3cb5341732612c72bcc2c5fb3372.1597842004.git.lorenzo@kernel.org>
 <20200820095222.711ccfa7@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7gGkHNMELEOhSGF6"
Content-Disposition: inline
In-Reply-To: <20200820095222.711ccfa7@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7gGkHNMELEOhSGF6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 19 Aug 2020 15:13:49 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index 884f140fc3be..006b24b5d276 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -370,19 +370,55 @@ static void __xdp_return(void *data, struct xdp_m=
em_info *mem, bool napi_direct)
> > =20
> >  void xdp_return_frame(struct xdp_frame *xdpf)
> >  {
> > +	struct skb_shared_info *sinfo;
> > +	int i;
> > +
> >  	__xdp_return(xdpf->data, &xdpf->mem, false);
>=20
> There is a use-after-free race here.  The xdpf->data contains the
> shared_info (xdp_get_shared_info_from_frame(xdpf)). Thus you cannot
> free/return the page and use this data area below.

right, thx for pointing this out. I will fix it in v2.

Regards,
Lorenzo

>=20
> > +	if (!xdpf->mb)
> > +		return;
> > +
> > +	sinfo =3D xdp_get_shared_info_from_frame(xdpf);
> > +	for (i =3D 0; i < sinfo->nr_frags; i++) {
> > +		struct page *page =3D skb_frag_page(&sinfo->frags[i]);
> > +
> > +		__xdp_return(page_address(page), &xdpf->mem, false);
> > +	}
> >  }
> >  EXPORT_SYMBOL_GPL(xdp_return_frame);
> > =20
> >  void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
> >  {
> > +	struct skb_shared_info *sinfo;
> > +	int i;
> > +
> >  	__xdp_return(xdpf->data, &xdpf->mem, true);
>=20
> Same issue.
>=20
> > +	if (!xdpf->mb)
> > +		return;
> > +
> > +	sinfo =3D xdp_get_shared_info_from_frame(xdpf);
> > +	for (i =3D 0; i < sinfo->nr_frags; i++) {
> > +		struct page *page =3D skb_frag_page(&sinfo->frags[i]);
> > +
> > +		__xdp_return(page_address(page), &xdpf->mem, true);
> > +	}
> >  }
> >  EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
> > =20
> >  void xdp_return_buff(struct xdp_buff *xdp)
> >  {
> > +	struct skb_shared_info *sinfo;
> > +	int i;
> > +
> >  	__xdp_return(xdp->data, &xdp->rxq->mem, true);
>=20
> Same issue.
>=20
> > +	if (!xdp->mb)
> > +		return;
> > +
> > +	sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	for (i =3D 0; i < sinfo->nr_frags; i++) {
> > +		struct page *page =3D skb_frag_page(&sinfo->frags[i]);
> > +
> > +		__xdp_return(page_address(page), &xdp->rxq->mem, true);
> > +	}
> >  }
>=20
>=20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--7gGkHNMELEOhSGF6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXz4skgAKCRA6cBh0uS2t
rF9wAQCLa2C8/FOuexmBRKh40iDZ7w7W3tK/WQFy3TzgQcZI/wD+K8plPDEmmzpP
CfYQTRHicawMyB5bHRXZ3FNondqQuwI=
=VQ6H
-----END PGP SIGNATURE-----

--7gGkHNMELEOhSGF6--

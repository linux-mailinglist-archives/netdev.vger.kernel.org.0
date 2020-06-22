Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC101203621
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgFVLsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbgFVLsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 07:48:20 -0400
Received: from localhost (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D48720716;
        Mon, 22 Jun 2020 11:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592826500;
        bh=WPIiRB4JSgUsHWtHb0b4M8XEW1JUPgE6hoxT2mGm6ek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FD/umBmF9ODVSj6/3qqYiCgpwaBKbVWqbtvR9vAMLTh3NH0PRbW88bVq1IwLHuqo1
         77ytEQmdpR5xTSA42WA5+UEBmy270NE5IJ6vyLAvgaIaTD+cSSo4kwTdVmGwhaccPT
         uK+la5HcUo/grBvy2iOb5zA2cR7T6ei6xWq74opM=
Date:   Mon, 22 Jun 2020 13:48:15 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH v2 bpf-next 1/8] net: Refactor xdp_convert_buff_to_frame
Message-ID: <20200622114815.GA14425@localhost.localdomain>
References: <cover.1592606391.git.lorenzo@kernel.org>
 <dfeb25e5274b0895f29fc1960e1cbd6c01157f8a.1592606391.git.lorenzo@kernel.org>
 <20200621171513.066e78ed@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <20200621171513.066e78ed@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, 20 Jun 2020 00:57:17 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > From: David Ahern <dahern@digitalocean.com>
> >=20

[...]

> >  	if (unlikely((headroom - metasize) < sizeof(*xdp_frame)))
> > -		return NULL;
> > +		return -ENOMEM;
>=20
> IMHO I think ENOMEM is reserved for memory allocations failures.
> I think ENOSPC will be more appropriate here (or EOVERFLOW).

ack, I will fix it in v3

Regards,
Lorenzo

>=20
> > =20
> >  	/* Catch if driver didn't reserve tailroom for skb_shared_info */
> >  	if (unlikely(xdp->data_end > xdp_data_hard_end(xdp))) {
> >  		XDP_WARN("Driver BUG: missing reserved tailroom");
> > -		return NULL;
> > +		return -ENOMEM;
>=20
> Same here.
>=20
> >  	}
> > =20
> > -	/* Store info in top of packet */
> > -	xdp_frame =3D xdp->data_hard_start;
> > -
> >  	xdp_frame->data =3D xdp->data;
> >  	xdp_frame->len  =3D xdp->data_end - xdp->data;
> >  	xdp_frame->headroom =3D headroom - sizeof(*xdp_frame);
> >  	xdp_frame->metasize =3D metasize;
> >  	xdp_frame->frame_sz =3D xdp->frame_sz;
> > =20
> > +	return 0;
> > +}
> > +
> > +/* Convert xdp_buff to xdp_frame */
> > +static inline
> > +struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
> > +{
> > +	struct xdp_frame *xdp_frame;
> > +
> > +	if (xdp->rxq->mem.type =3D=3D MEM_TYPE_XSK_BUFF_POOL)
> > +		return xdp_convert_zc_to_xdp_frame(xdp);
> > +
> > +	/* Store info in top of packet */
> > +	xdp_frame =3D xdp->data_hard_start;
> > +	if (unlikely(xdp_update_frame_from_buff(xdp, xdp_frame) < 0))
> > +		return NULL;
> > +
> >  	/* rxq only valid until napi_schedule ends, convert to xdp_mem_info */
> >  	xdp_frame->mem =3D xdp->rxq->mem;
> > =20
>=20
>=20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXvCafAAKCRA6cBh0uS2t
rAIxAP9c/hvo/7R8oLOusEVUOdJe0fUG7NbYdz4YhnSfAHPN/gD/dZf8jki+MJzg
etgdLe62+fTtRQeSyvdS1kmm4m/aNQ8=
=c8Lq
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--

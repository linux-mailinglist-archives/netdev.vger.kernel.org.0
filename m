Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A301E242C
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgEZOdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:33:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbgEZOdp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 10:33:45 -0400
Received: from localhost (unknown [151.48.148.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1A692065F;
        Tue, 26 May 2020 14:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590503625;
        bh=LdvSxghRs9yS+Ku+gpT21dSwC2nEsXrTcmSQxsBjTFs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hTZdY/jwNcx7J8+XxmDvOXhxNRxaT0aBoyuzHh/4ahBXpBXvbV6T8XUeYta23l5lF
         1SNvFF8HxcbypkvQ0v32CnIcsbRAE3RRFAr7wrMHJitmK+gywsrhEsVa7B3RgesfAb
         EDCWak9andw7nCm4ZCvT7JqV8pfLho+yXBGrHYpA=
Date:   Tue, 26 May 2020 16:33:40 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        toshiaki.makita1@gmail.com
Subject: Re: [PATCH bpf-next] xdp: introduce convert_to_xdp_buff utility
 routine
Message-ID: <20200526143340.GA3769@localhost.localdomain>
References: <26bcdba277dc23a57298218b7617cd8ebe03676e.1590500470.git.lorenzo@kernel.org>
 <20200526162008.7bd2d18f@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <20200526162008.7bd2d18f@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 26 May 2020 15:48:13 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20

[...]

> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 90f11760bd12..5dbdd65866a9 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -106,6 +106,16 @@ void xdp_warn(const char *msg, const char *func, c=
onst int line);
> > =20
> >  struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
> > =20
> > +static inline
> > +void convert_to_xdp_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
> > +{
> > +	xdp->data_hard_start =3D (void *)frame;
>=20
> This assumption is problematic.  You are suppose to deduct this from
> frame->data pointer.
>=20
> Currently the xdp_frame is designed and access such that is is possible
> to use another memory area for xdp_frame.  That would break after this
> change.
>=20
> This should instead be:
>=20
>  xdp->data_hard_start =3D frame->data - (frame->headroom + sizeof(struct =
xdp_frame));

ack, fine. I will fix it v2.

Regards,
Lorenzo

>=20
> > +	xdp->data =3D frame->data;
> > +	xdp->data_end =3D frame->data + frame->len;
> > +	xdp->data_meta =3D frame->data - frame->metasize;
> > +	xdp->frame_sz =3D frame->frame_sz;
> > +}
> > +
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXs0owgAKCRA6cBh0uS2t
rAAyAQCkFj/X0UTbyI5n4mzNdkWIBO289jPslneWxkfrK/x+SQEAxCqRUZrLQbhb
4Lg74IaF1IKZhnPteuRuziUuyjVv1QI=
=5SWW
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E60293932
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 12:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393157AbgJTKeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 06:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389466AbgJTKeG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 06:34:06 -0400
Received: from localhost (unknown [151.66.125.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5421522247;
        Tue, 20 Oct 2020 10:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603190045;
        bh=BS7tdLZHlco/0BxmbMLTRmEyMojZXM+vWBkCObveunU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Os+Ese8GbpXMK4ntdyW8TyeFhQJG52mL58ZOzW4neMhVYquNHKXCo5sJCmVdrFAqI
         2xmVTbYEASM8Zrsqum5VNDs4qUvf4Hk4xyAgB/AvK9TpIFCkFXitY3T2nBP6Y0Rp4f
         6NQlub1N4eWwgVSp8Em/M3Sc2oj0kXSz5kOtL0AY=
Date:   Tue, 20 Oct 2020 12:34:00 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, lorenzo.bianconi@redhat.com,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC 1/2] net: xdp: introduce bulking for xdp tx return path
Message-ID: <20201020103400.GA186228@lore-desk>
References: <cover.1603185591.git.lorenzo@kernel.org>
 <62165fcacf47521edae67ae739827aa5f751fb8b.1603185591.git.lorenzo@kernel.org>
 <20201020114613.752a979c@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20201020114613.752a979c@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 20 Oct 2020 11:33:37 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index 54b0bf574c05..af33cc62ed4c 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -663,6 +663,8 @@ struct mvneta_tx_queue {
> > =20
> >  	/* Affinity mask for CPUs*/
> >  	cpumask_t affinity_mask;
> > +
> > +	struct xdp_frame_bulk bq;
> >  };
> > =20
> >  struct mvneta_rx_queue {
> > @@ -1854,12 +1856,10 @@ static void mvneta_txq_bufs_free(struct mvneta_=
port *pp,
> >  			dev_kfree_skb_any(buf->skb);
> >  		} else if (buf->type =3D=3D MVNETA_TYPE_XDP_TX ||
> >  			   buf->type =3D=3D MVNETA_TYPE_XDP_NDO) {
> > -			if (napi && buf->type =3D=3D MVNETA_TYPE_XDP_TX)
> > -				xdp_return_frame_rx_napi(buf->xdpf);
> > -			else
> > -				xdp_return_frame(buf->xdpf);
> > +			xdp_return_frame_bulk(buf->xdpf, &txq->bq, napi);
>=20
> Hmm, I don't think you can use 'napi' directly here.
>=20
> You are circumventing check (buf->type =3D=3D MVNETA_TYPE_XDP_TX), and wi=
ll
> now also allow XDP_NDO (XDP_REDIRECT) to basically use xdp_return_frame_r=
x_napi().

ack, right. I will fix it.

Regards,
Lorenzo

>=20
>=20
> >  		}
> >  	}
> > +	xdp_flush_frame_bulk(&txq->bq, napi);
> > =20
> >  	netdev_tx_completed_queue(nq, pkts_compl, bytes_compl);
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

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX469FgAKCRA6cBh0uS2t
rMw+AQC+wTICxuV3t+HEomo4sgqeT5s/EKnTJFzEVG6ywe/2KQEA1I/zywkowV8W
dR3L8xi6iIOcfse0rFD0eCxhjAx9cAI=
=owQY
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--

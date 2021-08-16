Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E407B3ED30A
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 13:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236135AbhHPL1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 07:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236079AbhHPL1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 07:27:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF99C061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 04:27:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mFaln-0002ZJ-DT; Mon, 16 Aug 2021 13:27:07 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:3272:cc96:80a9:1a01])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6F56E668232;
        Mon, 16 Aug 2021 11:27:05 +0000 (UTC)
Date:   Mon, 16 Aug 2021 13:27:03 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/7] can: dev: add can_tdc_get_relative_tdco() helper
 function
Message-ID: <20210816112703.y6olntctn3oaavng@pengutronix.de>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-5-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gawe3w234erlrps6"
Content-Disposition: inline
In-Reply-To: <20210815033248.98111-5-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gawe3w234erlrps6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.08.2021 12:32:45, Vincent Mailhol wrote:
> struct can_tdc::tdco represents the absolute offset from TDCV. Some
> controllers use instead an offset relative to the Sample Point (SP)
> such that:
> | SSP =3D TDCV + absolute TDCO
> |     =3D TDCV + SP + relative TDCO
>=20
> Consequently:
> | relative TDCO =3D absolute TDCO - SP
>=20
> The function can_tdc_get_relative_tdco() allow to retrieve this
> relative TDCO value.
>=20
> CC: Stefan M=C3=A4tje <Stefan.Maetje@esd.eu>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>  include/linux/can/dev.h | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>=20
> diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
> index 0be982fd22fb..fa75e29182a3 100644
> --- a/include/linux/can/dev.h
> +++ b/include/linux/can/dev.h
> @@ -93,6 +93,35 @@ static inline bool can_tdc_is_enabled(const struct can=
_priv *priv)
>  	return !!(priv->ctrlmode & CAN_CTRLMODE_TDC_MASK);
>  }
> =20
> +/*
> + * can_get_relative_tdco() - TDCO relative to the sample point
> + *
> + * struct can_tdc::tdco represents the absolute offset from TDCV. Some
> + * controllers use instead an offset relative to the Sample Point (SP)
> + * such that:
> + *
> + * SSP =3D TDCV + absolute TDCO
> + *     =3D TDCV + SP + relative TDCO
> + *
> + * -+----------- one bit ----------+-- TX pin
> + *  |<--- Sample Point --->|
> + *
> + *                         --+----------- one bit ----------+-- RX pin
> + *  |<-------- TDCV -------->|
> + *                           |<------------------------>| absolute TDCO
> + *                           |<--- Sample Point --->|
> + *                           |                      |<->| relative TDCO
> + *  |<------------- Secondary Sample Point ------------>|
> + */
> +static inline s32 can_get_relative_tdco(const struct can_priv *priv)
> +{
> +	const struct can_bittiming *dbt =3D &priv->data_bittiming;
> +	s32 sample_point_in_tc =3D  (CAN_SYNC_SEG + dbt->prop_seg +
                                ^^

Only one space. I'll fix the while applying.

> +				   dbt->phase_seg1) * dbt->brp;
> +
> +	return (s32)priv->tdc.tdco - sample_point_in_tc;
> +}
> +
>  /* helper to define static CAN controller features at device creation ti=
me */
>  static inline void can_set_static_ctrlmode(struct net_device *dev,
>  					   u32 static_mode)

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--gawe3w234erlrps6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEaS4UACgkQqclaivrt
76lJJgf+JhTGf4sZoT1vegI0OZIUDYVko7WtcO2FmLg9HtQtENlwUseVVQq74w3O
aTITmDEOiAqZoCe4L8nHI6nKS5vfCNsadjtkS/As34WDWikS3/pZIYsEse5/sWxL
rg5QmXKl2iqqrWj5F6Lj8a/3mgnvxbE6LdgLsvmJHRWjOXnaZ9RAw+iXCWrV5zx1
qFV5CwOle4QeMpIuSgxL4yLvc9YIfGTdKbaHD5JBzDM2hDGeNb/q4gPPKrH4kXF8
Uts0tafEsosSpfObwlyzBWVuVDp79ph6T3WSc/k6n1eK+Eo6DSQDICuwN4dSlHMT
GEAFHBzDqJoRwr6TV1QnVCTf6lbciQ==
=cSs2
-----END PGP SIGNATURE-----

--gawe3w234erlrps6--

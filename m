Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01A64885D6
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbiAHURF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbiAHURD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:17:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DA6C06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 12:17:03 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6I8z-0005H9-Qq; Sat, 08 Jan 2022 21:16:53 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-6624-65e0-1d16-9a67.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:6624:65e0:1d16:9a67])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3C4536D39B6;
        Sat,  8 Jan 2022 20:16:51 +0000 (UTC)
Date:   Sat, 8 Jan 2022 21:16:50 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] can: flexcan: add ethtool support to get rx/tx ring
 parameters
Message-ID: <20220108201650.7gp3zlduzphgcgkq@pengutronix.de>
References: <20220108181633.420433-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lrt6ctyi5zm6ndge"
Content-Disposition: inline
In-Reply-To: <20220108181633.420433-1-dario.binacchi@amarulasolutions.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lrt6ctyi5zm6ndge
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08.01.2022 19:16:33, Dario Binacchi wrote:
> Adds ethtool support to get the number of message buffers configured for
> reception/transmission, which may also depends on runtime configurations
> such as the 'rx-rtr' flag state.
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
>=20
> ---
>=20
>  drivers/net/can/flexcan/flexcan-ethtool.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>=20
> diff --git a/drivers/net/can/flexcan/flexcan-ethtool.c b/drivers/net/can/=
flexcan/flexcan-ethtool.c
> index 5bb45653e1ac..d119bca584f6 100644
> --- a/drivers/net/can/flexcan/flexcan-ethtool.c
> +++ b/drivers/net/can/flexcan/flexcan-ethtool.c
> @@ -80,7 +80,24 @@ static int flexcan_set_priv_flags(struct net_device *n=
dev, u32 priv_flags)
>  	return 0;
>  }
> =20
> +static void flexcan_get_ringparam(struct net_device *ndev,
> +				  struct ethtool_ringparam *ring)

This doesn't compile on net-next/master, as the prototype of the
get_ringparam callback changed, fixed this while applying.

> +{
> +	struct flexcan_priv *priv =3D netdev_priv(ndev);
> +
> +	ring->rx_max_pending =3D priv->mb_count;
> +	ring->tx_max_pending =3D priv->mb_count;
> +
> +	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX)
> +		ring->rx_pending =3D __sw_hweight64(priv->rx_mask);

I've replaced the hamming weight calculation by the simpler:

| 		ring->rx_pending =3D priv->offload.mb_last -
| 			priv->offload.mb_first + 1;

> +	else
> +		ring->rx_pending =3D 6;
> +
> +	ring->tx_pending =3D __sw_hweight64(priv->tx_mask);

=2E..and here I added a hardcoded "1", as the driver currently only
support on TX buffer.

> +}
> +
>  static const struct ethtool_ops flexcan_ethtool_ops =3D {
> +	.get_ringparam =3D flexcan_get_ringparam,
>  	.get_sset_count =3D flexcan_get_sset_count,
>  	.get_strings =3D flexcan_get_strings,
>  	.get_priv_flags =3D flexcan_get_priv_flags,

BTW: If you're looking for more TX performance, this can be done by
using more than one TX buffer. It's also possible to configure the
number of RX and TX buffers via ethtool during runtime. I'm currently
preparing a patch set for the mcp251xfd to implement this.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lrt6ctyi5zm6ndge
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHZ8S8ACgkQqclaivrt
76k6Uwf+IPEx/+Pn1u4SCWbKlyCLP8f51HsSh1PizfRD6yZuIVJYHnS72AhkDeZR
ydYE3Whns+UbnP6CfS0VR+i75EwkpO/1gUlKb1oiE24HyqG1Md12E7wDttBOF/yz
xTbMF+gBeUerm9AATKrgO5gF7o0YHT6LNh7v2wbk0Laj0DHUHZqOhPPJG4os5K5y
FyeYiTZTl6U1dAR96dqeQN9lWVWcjZEfyI6bbJDzHPLHDKkT24Bx8hYtqfDf9Gpc
j0TjFTkWedacxwoNPVVIflEmAKgc4W/5bOTbZ0/HStYL8TZuH9y9XmZYojuhag9U
hJeWGMwv9vC7s82mNLDfKQSFyMbWNA==
=iBua
-----END PGP SIGNATURE-----

--lrt6ctyi5zm6ndge--

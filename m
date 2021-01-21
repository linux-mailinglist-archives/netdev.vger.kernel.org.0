Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98AC2FE641
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 10:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbhAUJWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 04:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728672AbhAUJWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 04:22:09 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D189C0613D6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 01:21:29 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l2W9V-00053L-R1; Thu, 21 Jan 2021 10:21:17 +0100
Received: from hardanger.blackshift.org (unknown [IPv6:2a03:f580:87bc:d400:37fb:eadb:47a3:78d5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 153C85C98AD;
        Thu, 21 Jan 2021 09:21:16 +0000 (UTC)
Date:   Thu, 21 Jan 2021 10:21:15 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Su Yanjun <suyanjun218@gmail.com>
Cc:     manivannan.sadhasivam@linaro.org, thomas.kopp@microchip.com,
        wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        lgirdwood@gmail.com, broonie@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] can: mcp251xfd: replace sizeof(u32) with val_bytes in
 regmap
Message-ID: <20210121092115.dasphwfzfkthcy64@hardanger.blackshift.org>
References: <20210121091005.74417-1-suyanjun218@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="efq2fpiu2im66ptm"
Content-Disposition: inline
In-Reply-To: <20210121091005.74417-1-suyanjun218@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--efq2fpiu2im66ptm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 21, 2021 at 05:10:05PM +0800, Su Yanjun wrote:

Please describe why you change this.

> No functional effect.

Not quite:

scripts/bloat-o-meter shows:

add/remove: 0/0 grow/shrink: 3/0 up/down: 104/0 (104)
Function                                     old     new   delta
mcp251xfd_handle_tefif                       980    1028     +48
mcp251xfd_irq                               3716    3756     +40
mcp251xfd_handle_rxif_ring                   964     980     +16
Total: Before=3D20832, After=3D20936, chg +0.50%

>=20
> Signed-off-by: Su Yanjun <suyanjun218@gmail.com>
> ---
>  drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net=
/can/spi/mcp251xfd/mcp251xfd-core.c
> index f07e8b737d31..b15bfd50b863 100644
> --- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> +++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> @@ -181,6 +181,12 @@ static int mcp251xfd_clks_and_vdd_disable(const stru=
ct mcp251xfd_priv *priv)
>  	return 0;
>  }
> =20
> +static inline int
> +mcp251xfd_get_val_bytes(const struct mcp251xfd_priv *priv)
> +{
> +	return regmap_get_val_bytes(priv->map_reg);

You're always using the "map_reg" here

> +}
> +
>  static inline u8
>  mcp251xfd_cmd_prepare_write_reg(const struct mcp251xfd_priv *priv,
>  				union mcp251xfd_write_reg_buf *write_reg_buf,
> @@ -1308,6 +1314,7 @@ mcp251xfd_tef_obj_read(const struct mcp251xfd_priv =
*priv,
>  		       const u8 offset, const u8 len)
>  {
>  	const struct mcp251xfd_tx_ring *tx_ring =3D priv->tx;
> +	int val_bytes =3D mcp251xfd_get_val_bytes(priv);
> =20
>  	if (IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY) &&
>  	    (offset > tx_ring->obj_num ||
> @@ -1322,7 +1329,7 @@ mcp251xfd_tef_obj_read(const struct mcp251xfd_priv =
*priv,
>  	return regmap_bulk_read(priv->map_rx,

But this works on map_rx.

>  				mcp251xfd_get_tef_obj_addr(offset),
>  				hw_tef_obj,
> -				sizeof(*hw_tef_obj) / sizeof(u32) * len);
> +				sizeof(*hw_tef_obj) / val_bytes * len);
>  }
> =20
>  static int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
> @@ -1511,11 +1518,12 @@ mcp251xfd_rx_obj_read(const struct mcp251xfd_priv=
 *priv,
>  		      const u8 offset, const u8 len)
>  {
>  	int err;
> +	int val_bytes =3D mcp251xfd_get_val_bytes(priv);
> =20
>  	err =3D regmap_bulk_read(priv->map_rx,

Same here

>  			       mcp251xfd_get_rx_obj_addr(ring, offset),
>  			       hw_rx_obj,
> -			       len * ring->obj_size / sizeof(u32));
> +			       len * ring->obj_size / val_bytes);
> =20
>  	return err;
>  }
> @@ -2139,6 +2147,7 @@ static irqreturn_t mcp251xfd_irq(int irq, void *dev=
_id)
>  	struct mcp251xfd_priv *priv =3D dev_id;
>  	irqreturn_t handled =3D IRQ_NONE;
>  	int err;
> +	int val_bytes =3D mcp251xfd_get_val_bytes(priv);
> =20
>  	if (priv->rx_int)
>  		do {
> @@ -2162,7 +2171,7 @@ static irqreturn_t mcp251xfd_irq(int irq, void *dev=
_id)
>  		err =3D regmap_bulk_read(priv->map_reg, MCP251XFD_REG_INT,

Here it's map_reg.

>  				       &priv->regs_status,
>  				       sizeof(priv->regs_status) /
> -				       sizeof(u32));
> +				       val_bytes);
>  		if (err)
>  			goto out_fail;
> =20
> --=20
> 2.25.1

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--efq2fpiu2im66ptm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmAJR4cACgkQqclaivrt
76nBmQf/Ugd8lVXzD8dAKIR9Ue89rAxybZUGcZGSiQUEToKfcq0mVC4QFuPVKtoj
lt+2YsIbLt3t7D/3Sfgrv7ZKH9YZyDaj/hVScKYAdZXDQuR1W6unHvlGLX3+VfA2
O/h9KYK4t5pkGIdBy8GKWmVChMDJ6/0eurChMzLmHCcfcYU7NqejcO5nc13LMOmX
CKZdChLBFrFdCVqAFRfA/BWd2L6gnmgDziONA4xhH6K44iKQUrO61m7RkTyFCT5I
efJsdqx1r5f6GKHhR08byCIDvbHJzFiVikd4mwVqiVYBaWaQNYoQZDmPcTsxTi+P
QGAqK/vHP9xGzzwN9JsU4BZDUnrVVg==
=SQnm
-----END PGP SIGNATURE-----

--efq2fpiu2im66ptm--

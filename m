Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C503B6EC1CF
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjDWTRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjDWTRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:17:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8033B1A2
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 12:17:11 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pqfCi-0008EO-Vx; Sun, 23 Apr 2023 21:16:57 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C74D71B5B71;
        Sun, 23 Apr 2023 19:16:54 +0000 (UTC)
Date:   Sun, 23 Apr 2023 21:16:54 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] can: bxcan: add support for single peripheral
 configuration
Message-ID: <20230423-surplus-spoon-4e8194434663-mkl@pengutronix.de>
References: <20230423172528.1398158-1-dario.binacchi@amarulasolutions.com>
 <20230423172528.1398158-5-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="felop2eqrba2j7la"
Content-Disposition: inline
In-Reply-To: <20230423172528.1398158-5-dario.binacchi@amarulasolutions.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--felop2eqrba2j7la
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23.04.2023 19:25:28, Dario Binacchi wrote:
> Add support for bxCAN controller in single peripheral configuration:
> - primary bxCAN
> - dedicated Memory Access Controller unit
> - 512-byte SRAM memory
> - 14 fiter banks
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
>=20
> ---
>=20
>  drivers/net/can/bxcan.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/can/bxcan.c b/drivers/net/can/bxcan.c
> index e26ccd41e3cb..9bcbbb85da6e 100644
> --- a/drivers/net/can/bxcan.c
> +++ b/drivers/net/can/bxcan.c
> @@ -155,6 +155,7 @@ struct bxcan_regs {
>  	u32 reserved0[88];		/* 0x20 */
>  	struct bxcan_mb tx_mb[BXCAN_TX_MB_NUM];	/* 0x180 - tx mailbox */
>  	struct bxcan_mb rx_mb[BXCAN_RX_MB_NUM];	/* 0x1b0 - rx mailbox */
> +	u32 reserved1[12];		/* 0x1d0 */
>  };
> =20
>  struct bxcan_priv {
> @@ -922,6 +923,12 @@ static int bxcan_get_berr_counter(const struct net_d=
evice *ndev,
>  	return 0;
>  }
> =20
> +static const struct regmap_config bxcan_gcan_regmap_config =3D {
> +	.reg_bits =3D 32,
> +	.val_bits =3D 32,
> +	.reg_stride =3D 4,
> +};
> +
>  static int bxcan_probe(struct platform_device *pdev)
>  {
>  	struct device_node *np =3D pdev->dev.of_node;
> @@ -942,11 +949,18 @@ static int bxcan_probe(struct platform_device *pdev)
> =20
>  	gcan =3D syscon_regmap_lookup_by_phandle(np, "st,gcan");
>  	if (IS_ERR(gcan)) {
> -		dev_err(dev, "failed to get shared memory base address\n");
> -		return PTR_ERR(gcan);
> +		primary =3D true;
> +		gcan =3D devm_regmap_init_mmio(dev,
> +					     regs + sizeof(struct bxcan_regs),
> +					     &bxcan_gcan_regmap_config);
> +		if (IS_ERR(gcan)) {
> +			dev_err(dev, "failed to get filter base address\n");
> +			return PTR_ERR(gcan);
> +		}

This probably works. Can we do better, i.e. without this additional code?

If you add a syscon node for the single instance CAN, too, you don't
need a code change here, right?

> +	} else {
> +		primary =3D of_property_read_bool(np, "st,can-primary");
>  	}
> =20
> -	primary =3D of_property_read_bool(np, "st,can-primary");
>  	clk =3D devm_clk_get(dev, NULL);
>  	if (IS_ERR(clk)) {
>  		dev_err(dev, "failed to get clock\n");

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--felop2eqrba2j7la
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRFhCMACgkQvlAcSiqK
BOhkFgf/Vxf+wVkP9/HDALlN52Aqfuf1fAXV2hCzTVntRJ5TytV5PkI9lwtifbo4
EUBfXptxrNaEoFPNMWtonKH0c8G9eDExuYZphMEtoRvXMtp8hnS8bwp9Vnp1TJG9
UBin0GXz0PKtfrPMPwr0dDwrU2foz3IJiww1iABnkhe9HM7/1X0E3iKYUiqbMCZj
LJUCknN4ZQJeTPzNQ0MzrtZWUyL4DLXlKtNeCtt8Answ7Tj+p0kumMLtE8kKefY5
iOCdW7tstpMHJOu46s0v+jgzGkHh/5zI6SW4JyJXDuUcbf/E/CGd5quFSg58JVi8
SHW/Ca8iLCaRCinqzQm6/moO52XhnA==
=xeGv
-----END PGP SIGNATURE-----

--felop2eqrba2j7la--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695963CB5CA
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 12:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237960AbhGPKNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 06:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237848AbhGPKNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 06:13:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BDAC061760
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 03:10:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m4KnG-0000gC-OV; Fri, 16 Jul 2021 12:10:06 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:df95:c0e5:d620:3bac])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A198765091A;
        Fri, 16 Jul 2021 10:10:02 +0000 (UTC)
Date:   Fri, 16 Jul 2021 12:10:01 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH 2/6] can: rcar_canfd: Add support for RZ/G2L family
Message-ID: <20210716101001.m5sgit3l354mljai@pengutronix.de>
References: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210715182123.23372-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wuc7izo7bgfbohrr"
Content-Disposition: inline
In-Reply-To: <20210715182123.23372-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wuc7izo7bgfbohrr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.07.2021 19:21:19, Lad Prabhakar wrote:
> CANFD block on RZ/G2L SoC is almost identical to one found on
> R-Car Gen3 SoC's.
>=20
> On RZ/G2L SoC interrupt sources for each channel are split into
> different sources, irq handlers for the same are added.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Thanks for the patch! Some nitpicks inline, Geert already commented to
use the same IRQ handler for all interrutps.

> ---
>  drivers/net/can/rcar/rcar_canfd.c | 275 ++++++++++++++++++++++++++----
>  1 file changed, 244 insertions(+), 31 deletions(-)
>=20
> diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rca=
r_canfd.c
> index 311e6ca3bdc4..5dfbc5fa2d81 100644
> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -37,9 +37,13 @@
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
>  #include <linux/iopoll.h>
> +#include <linux/reset.h>
> =20
>  #define RCANFD_DRV_NAME			"rcar_canfd"
> =20
> +#define RENESAS_RCAR_GEN3	0
> +#define RENESAS_RZG2L		1
> +

Please make this an enum.

>  /* Global register bits */
> =20
>  /* RSCFDnCFDGRMCFG */
> @@ -513,6 +517,9 @@ struct rcar_canfd_global {
>  	enum rcar_canfd_fcanclk fcan;	/* CANFD or Ext clock */
>  	unsigned long channels_mask;	/* Enabled channels mask */
>  	bool fdmode;			/* CAN FD or Classical CAN only mode */
> +	struct reset_control *rstc1;     /* Pointer to reset source1 */
> +	struct reset_control *rstc2;     /* Pointer to reset source2 */
> +	unsigned int chip_id;

enum here, too

>  };
> =20
>  /* CAN FD mode nominal rate constants */
> @@ -1070,6 +1077,56 @@ static void rcar_canfd_tx_done(struct net_device *=
ndev)
>  	can_led_event(ndev, CAN_LED_EVENT_TX);
>  }
> =20
[...]

> @@ -1635,8 +1784,11 @@ static int rcar_canfd_probe(struct platform_device=
 *pdev)
>  	struct rcar_canfd_global *gpriv;
>  	struct device_node *of_child;
>  	unsigned long channels_mask =3D 0;
> -	int err, ch_irq, g_irq;
> +	int err, ch_irq, g_irq, g_rx_irq;
>  	bool fdmode =3D true;			/* CAN FD only mode - default */
> +	unsigned int chip_id;
> +
> +	chip_id =3D (uintptr_t)of_device_get_match_data(&pdev->dev);

The cast looks wrong.

> =20
>  	if (of_property_read_bool(pdev->dev.of_node, "renesas,no-can-fd"))
>  		fdmode =3D false;			/* Classical CAN only mode */
> @@ -1649,27 +1801,56 @@ static int rcar_canfd_probe(struct platform_devic=
e *pdev)
>  	if (of_child && of_device_is_available(of_child))
>  		channels_mask |=3D BIT(1);	/* Channel 1 */
> =20
> -	ch_irq =3D platform_get_irq(pdev, 0);
> -	if (ch_irq < 0) {
> -		err =3D ch_irq;
> -		goto fail_dev;
> -	}
> +	if (chip_id =3D=3D RENESAS_RCAR_GEN3) {
> +		ch_irq =3D platform_get_irq(pdev, 0);
> +		if (ch_irq < 0)
> +			return ch_irq;
> =20
> -	g_irq =3D platform_get_irq(pdev, 1);
> -	if (g_irq < 0) {
> -		err =3D g_irq;
> -		goto fail_dev;
> +		g_irq =3D platform_get_irq(pdev, 1);
> +		if (g_irq < 0)
> +			return g_irq;
> +	} else {
> +		g_irq =3D platform_get_irq(pdev, 0);
> +		if (g_irq < 0)
> +			return g_irq;
> +
> +		g_rx_irq =3D platform_get_irq(pdev, 1);
> +		if (g_rx_irq < 0)
> +			return g_rx_irq;
>  	}
> =20
>  	/* Global controller context */
>  	gpriv =3D devm_kzalloc(&pdev->dev, sizeof(*gpriv), GFP_KERNEL);
> -	if (!gpriv) {
> -		err =3D -ENOMEM;
> -		goto fail_dev;
> -	}
> +	if (!gpriv)
> +		return -ENOMEM;
> +
>  	gpriv->pdev =3D pdev;
>  	gpriv->channels_mask =3D channels_mask;
>  	gpriv->fdmode =3D fdmode;
> +	gpriv->chip_id =3D chip_id;
> +
> +	if (gpriv->chip_id =3D=3D RENESAS_RZG2L) {
> +		gpriv->rstc1 =3D devm_reset_control_get_exclusive_by_index(&pdev->dev,=
 0);
> +		if (IS_ERR(gpriv->rstc1)) {
> +			dev_err(&pdev->dev, "failed to get reset index 0\n");
> +			return PTR_ERR(gpriv->rstc1);
> +		}
> +
> +		err =3D reset_control_reset(gpriv->rstc1);
> +		if (err)
> +			return err;
> +
> +		gpriv->rstc2 =3D devm_reset_control_get_exclusive_by_index(&pdev->dev,=
 1);
> +		if (IS_ERR(gpriv->rstc2)) {
> +			dev_err(&pdev->dev, "failed to get reset index 1\n");
> +			return PTR_ERR(gpriv->rstc2);
> +		}
> +		err =3D reset_control_reset(gpriv->rstc2);
> +		if (err) {
> +			reset_control_assert(gpriv->rstc1);
> +			return err;
> +		}
> +	}
> =20
>  	/* Peripheral clock */
>  	gpriv->clkp =3D devm_clk_get(&pdev->dev, "fck");
> @@ -1699,7 +1880,7 @@ static int rcar_canfd_probe(struct platform_device =
*pdev)
>  	}
>  	fcan_freq =3D clk_get_rate(gpriv->can_clk);
> =20
> -	if (gpriv->fcan =3D=3D RCANFD_CANFDCLK)
> +	if (gpriv->fcan =3D=3D RCANFD_CANFDCLK && gpriv->chip_id =3D=3D RENESAS=
_RCAR_GEN3)
>  		/* CANFD clock is further divided by (1/2) within the IP */
>  		fcan_freq /=3D 2;
> =20
> @@ -1711,21 +1892,43 @@ static int rcar_canfd_probe(struct platform_devic=
e *pdev)
>  	gpriv->base =3D addr;
> =20
>  	/* Request IRQ that's common for both channels */
> -	err =3D devm_request_irq(&pdev->dev, ch_irq,
> -			       rcar_canfd_channel_interrupt, 0,
> -			       "canfd.chn", gpriv);
> -	if (err) {
> -		dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> -			ch_irq, err);
> -		goto fail_dev;
> -	}
> -	err =3D devm_request_irq(&pdev->dev, g_irq,
> -			       rcar_canfd_global_interrupt, 0,
> -			       "canfd.gbl", gpriv);
> -	if (err) {
> -		dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> -			g_irq, err);
> -		goto fail_dev;
> +	if (gpriv->chip_id =3D=3D RENESAS_RCAR_GEN3) {
> +		err =3D devm_request_irq(&pdev->dev, ch_irq,
> +				       rcar_canfd_channel_interrupt, 0,
> +				       "canfd.chn", gpriv);
> +		if (err) {
> +			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> +				ch_irq, err);
> +			goto fail_dev;
> +		}
> +
> +		err =3D devm_request_irq(&pdev->dev, g_irq,
> +				       rcar_canfd_global_interrupt, 0,
> +				       "canfd.gbl", gpriv);
> +		if (err) {
> +			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> +				g_irq, err);
> +			goto fail_dev;
> +		}
> +	} else {
> +		err =3D devm_request_irq(&pdev->dev, g_rx_irq,
> +				       rcar_canfd_global_recieve_fifo_interrupt, 0,
> +				       "canfd.gblrx", gpriv);
> +
> +		if (err) {
> +			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> +				g_rx_irq, err);
> +			goto fail_dev;
> +		}
> +
> +		err =3D devm_request_irq(&pdev->dev, g_irq,
> +				       rcar_canfd_global_err_interrupt, 0,
> +				       "canfd.gblerr", gpriv);
> +		if (err) {
> +			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> +				g_irq, err);
> +			goto fail_dev;
> +		}
>  	}
> =20
>  	/* Enable peripheral clock for register access */
> @@ -1791,6 +1994,10 @@ static int rcar_canfd_probe(struct platform_device=
 *pdev)
>  fail_clk:
>  	clk_disable_unprepare(gpriv->clkp);
>  fail_dev:
> +	if (gpriv->chip_id =3D=3D RENESAS_RZG2L) {
> +		reset_control_assert(gpriv->rstc1);
> +		reset_control_assert(gpriv->rstc2);

reset_control_assert() can handle NULL pointers

> +	}
>  	return err;
>  }
> =20
> @@ -1810,6 +2017,11 @@ static int rcar_canfd_remove(struct platform_devic=
e *pdev)
>  	/* Enter global sleep mode */
>  	rcar_canfd_set_bit(gpriv->base, RCANFD_GCTR, RCANFD_GCTR_GSLPR);
>  	clk_disable_unprepare(gpriv->clkp);
> +	if (gpriv->chip_id =3D=3D RENESAS_RZG2L) {
> +		reset_control_assert(gpriv->rstc1);
> +		reset_control_assert(gpriv->rstc2);
> +	}

same here

> +
>  	return 0;
>  }
> =20
> @@ -1827,7 +2039,8 @@ static SIMPLE_DEV_PM_OPS(rcar_canfd_pm_ops, rcar_ca=
nfd_suspend,
>  			 rcar_canfd_resume);
> =20
>  static const struct of_device_id rcar_canfd_of_table[] =3D {
> -	{ .compatible =3D "renesas,rcar-gen3-canfd" },
> +	{ .compatible =3D "renesas,rcar-gen3-canfd", .data =3D (void *)RENESAS_=
RCAR_GEN3 },
> +	{ .compatible =3D "renesas,rzg2l-canfd", .data =3D (void *)RENESAS_RZG2=
L },
>  	{ }
>  };

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--wuc7izo7bgfbohrr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDxWvcACgkQqclaivrt
76nzsAf/VLZM8WaYPkGkszH1Cmetc3SSNU9ISL9bHW7zuKnD5sJKuYzDlQFksPmD
W4E6hTf1yDfTeVbPONWLkSYwwt/ervNH6vbb3bgMwKlcGGDjdWWgz5v+vwluFo12
6p6QQWxlsGf59mMrr/UfXCVXBjHXkm+UXAycI33hvlWcvV1NvtfWiR7uDCXwkDj4
kJhr1pSOzgwFQTT/CvJ4o3Xrtg/Fd+E4abSmwjJqL52Rs2aJlcR62aECxQfP83P0
yAP7M4hMsoNvG0++nm+4JcMIYJtKt5EmWnrvpd3R0d/jbMf3A97g6d4vSMGocRLg
ooPbMKvVMumA8xB2ye0K9MSKNW9qIw==
=OGo6
-----END PGP SIGNATURE-----

--wuc7izo7bgfbohrr--

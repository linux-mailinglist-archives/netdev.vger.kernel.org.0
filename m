Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB98D3D48FA
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 19:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhGXRQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 13:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhGXRQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 13:16:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6199C061575
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 10:56:56 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m7LtC-0006BX-5X; Sat, 24 Jul 2021 19:56:42 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:41cc:c65c:f580:3bde])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1B18D657090;
        Sat, 24 Jul 2021 17:56:39 +0000 (UTC)
Date:   Sat, 24 Jul 2021 19:56:37 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v4 2/2] can: m_can: Add support for transceiver as phy
Message-ID: <20210724175637.vcslc2iewcdqnvev@pengutronix.de>
References: <20210510052541.14168-1-a-govindraju@ti.com>
 <20210510052541.14168-3-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aozsztylvh5w2ifj"
Content-Disposition: inline
In-Reply-To: <20210510052541.14168-3-a-govindraju@ti.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--aozsztylvh5w2ifj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.05.2021 10:55:41, Aswath Govindraju wrote:
> From: Faiz Abbas <faiz_abbas@ti.com>
>=20
> Add support for implementing transceiver node as phy. The max_bitrate is
> obtained by getting a phy attribute.
>=20
> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> ---
>  drivers/net/can/m_can/m_can.c          | 11 +++++++++++
>  drivers/net/can/m_can/m_can.h          |  2 ++
>  drivers/net/can/m_can/m_can_platform.c | 13 +++++++++++++
>  3 files changed, 26 insertions(+)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 3cf6de21d19c..afbecc35d3b6 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -21,6 +21,7 @@
>  #include <linux/iopoll.h>
>  #include <linux/can/dev.h>
>  #include <linux/pinctrl/consumer.h>
> +#include <linux/phy/phy.h>
> =20
>  #include "m_can.h"
> =20
> @@ -1514,6 +1515,7 @@ static void m_can_stop(struct net_device *dev)
>  static int m_can_close(struct net_device *dev)
>  {
>  	struct m_can_classdev *cdev =3D netdev_priv(dev);
> +	int err;
> =20
>  	netif_stop_queue(dev);
> =20
> @@ -1536,6 +1538,10 @@ static int m_can_close(struct net_device *dev)
>  	close_candev(dev);
>  	can_led_event(dev, CAN_LED_EVENT_STOP);
> =20
> +	err =3D phy_power_off(cdev->transceiver);
> +	if (err)
> +		return err;

No need to propagate errors in the close().

> +
>  	return 0;
>  }
> =20
> @@ -1721,6 +1727,10 @@ static int m_can_open(struct net_device *dev)
>  	struct m_can_classdev *cdev =3D netdev_priv(dev);
>  	int err;
> =20
> +	err =3D phy_power_on(cdev->transceiver);
> +	if (err)
> +		return err;
> +
>  	err =3D m_can_clk_start(cdev);
>  	if (err)
>  		return err;

Here, don't handle the error properly.

> @@ -1781,6 +1791,7 @@ static int m_can_open(struct net_device *dev)
>  	close_candev(dev);
>  exit_disable_clks:
>  	m_can_clk_stop(cdev);
> +	phy_power_off(cdev->transceiver);
>  	return err;
>  }
> =20
> diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
> index ace071c3e58c..38cad068abad 100644
> --- a/drivers/net/can/m_can/m_can.h
> +++ b/drivers/net/can/m_can/m_can.h
> @@ -28,6 +28,7 @@
>  #include <linux/iopoll.h>
>  #include <linux/can/dev.h>
>  #include <linux/pinctrl/consumer.h>
> +#include <linux/phy/phy.h>
> =20
>  /* m_can lec values */
>  enum m_can_lec_type {
> @@ -82,6 +83,7 @@ struct m_can_classdev {
>  	struct workqueue_struct *tx_wq;
>  	struct work_struct tx_work;
>  	struct sk_buff *tx_skb;
> +	struct phy *transceiver;
> =20
>  	struct can_bittiming_const *bit_timing;
>  	struct can_bittiming_const *data_timing;
> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_c=
an/m_can_platform.c
> index 599de0e08cd7..f102d532b7f0 100644
> --- a/drivers/net/can/m_can/m_can_platform.c
> +++ b/drivers/net/can/m_can/m_can_platform.c
> @@ -6,6 +6,7 @@
>  // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.=
com/
> =20
>  #include <linux/platform_device.h>
> +#include <linux/phy/phy.h>
> =20
>  #include "m_can.h"
> =20
> @@ -67,6 +68,7 @@ static int m_can_plat_probe(struct platform_device *pde=
v)
>  	struct resource *res;
>  	void __iomem *addr;
>  	void __iomem *mram_addr;
> +	struct phy *transceiver;
>  	int irq, ret =3D 0;
> =20
>  	mcan_class =3D m_can_class_allocate_dev(&pdev->dev,
> @@ -101,6 +103,16 @@ static int m_can_plat_probe(struct platform_device *=
pdev)
>  		goto probe_fail;
>  	}
> =20
> +	transceiver =3D devm_phy_optional_get(&pdev->dev, NULL);
> +	if (IS_ERR(transceiver)) {
> +		ret =3D PTR_ERR(transceiver);
> +		dev_err_probe(&pdev->dev, ret, "failed to get phy\n");
> +		return ret;

Here you leak the memory allocated by m_can_class_allocate_dev().

> +	}
> +
> +	if (transceiver)
> +		mcan_class->can.bitrate_max =3D transceiver->attrs.max_link_rate;
> +
>  	priv->base =3D addr;
>  	priv->mram_base =3D mram_addr;
> =20
> @@ -108,6 +120,7 @@ static int m_can_plat_probe(struct platform_device *p=
dev)
>  	mcan_class->pm_clock_support =3D 1;
>  	mcan_class->can.clock.freq =3D clk_get_rate(mcan_class->cclk);
>  	mcan_class->dev =3D &pdev->dev;
> +	mcan_class->transceiver =3D transceiver;
> =20
>  	mcan_class->ops =3D &m_can_plat_ops;
> =20
> --=20
> 2.17.1
>=20
>

I've send a v5 fixing these problems.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--aozsztylvh5w2ifj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmD8VFMACgkQqclaivrt
76lU3Af6A5JrBDeFGF/y9LtAa9s/HuuJtW5am23+tonZTKV2LwpFZlxSR18/e9of
ZpdHaLJf+XBo33FxQKc32zvHg+4u+d2qgfkrAJrqaSadRx0V3nwm08Ab/QBc4LPM
gO99CqSvRUGZkmhiFMQ51u5WQHQ1VDS4UszqAcyuyZ7JIlwUE2/tzDU0/Ovmu6kO
yuRIOHZuhEO8bHP26u1/4iZOpOhRfC9xg70/HeXZvwGQmLXLLZzXQJVY1+mPEjkn
us6tglOHQO/SWugT8xwSxGydys3NN92aB+xxsmsd97det544z0wEjjS4d6gJYSaN
/psJgaQEDFCttcrHRUMT4XfxylnhxA==
=uHbx
-----END PGP SIGNATURE-----

--aozsztylvh5w2ifj--

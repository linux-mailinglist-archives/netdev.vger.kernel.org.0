Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DC735F774
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350266AbhDNPQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350221AbhDNPQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:16:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC507C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 08:16:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lWhF7-0002Ja-7c; Wed, 14 Apr 2021 17:15:49 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:69d2:43d8:822b:d361])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B74A760EA21;
        Wed, 14 Apr 2021 15:15:45 +0000 (UTC)
Date:   Wed, 14 Apr 2021 17:15:44 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v2 6/6] can: m_can: Add support for transceiver as phy
Message-ID: <20210414151544.uk756tddae3gdmvv@pengutronix.de>
References: <20210414140521.11463-1-a-govindraju@ti.com>
 <20210414140521.11463-7-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="o2cm6ur22kzzisul"
Content-Disposition: inline
In-Reply-To: <20210414140521.11463-7-a-govindraju@ti.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--o2cm6ur22kzzisul
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.04.2021 19:35:21, Aswath Govindraju wrote:
> From: Faiz Abbas <faiz_abbas@ti.com>
>=20
> Add support for implementing transceiver node as phy. The max_bitrate is
> obtained by getting a phy attribute.
>=20
> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> ---
>  drivers/net/can/m_can/m_can.c          | 18 ++++++++++++++++++
>  drivers/net/can/m_can/m_can.h          |  2 ++
>  drivers/net/can/m_can/m_can_platform.c | 15 +++++++++++++++
>  3 files changed, 35 insertions(+)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 34073cd077e4..4807a1f69cc7 100644
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
> @@ -1536,6 +1538,14 @@ static int m_can_close(struct net_device *dev)
>  	close_candev(dev);
>  	can_led_event(dev, CAN_LED_EVENT_STOP);
> =20
> +	if (cdev->transceiver) {
> +		err =3D phy_power_off(cdev->transceiver);

phy_power_off() can handle NULL pointers

> +		if (err) {
> +			netdev_err(dev, "error powering off phy, err=3D%d\n", err);
> +			return err;

As far as I can see it already print an error message in case of an
error.

> +		}
> +	}
> +
>  	return 0;
>  }
> =20
> @@ -1720,6 +1730,14 @@ static int m_can_open(struct net_device *dev)
>  	struct m_can_classdev *cdev =3D netdev_priv(dev);
>  	int err;
> =20
> +	if (cdev->transceiver) {
> +		err =3D phy_power_on(cdev->transceiver);
> +		if (err) {
> +			netdev_err(dev, "error powering on phy, err=3D%d\n", err);
> +			return err;
> +		}

same here

> +	}
> +
>  	err =3D m_can_clk_start(cdev);
>  	if (err)
>  		return err;
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
> index 599de0e08cd7..566ba25fb186 100644
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
> @@ -101,6 +103,18 @@ static int m_can_plat_probe(struct platform_device *=
pdev)
>  		goto probe_fail;
>  	}
> =20
> +	transceiver =3D devm_of_phy_optional_get_by_index(&pdev->dev, pdev->dev=
=2Eof_node, 0);
> +	if (IS_ERR(transceiver)) {
> +		ret =3D PTR_ERR(transceiver);
> +		dev_err(&pdev->dev, "error while getting phy, err=3D%d\n", ret);
> +		return ret;
> +	}
> +
> +	if (!transceiver)
> +		dev_info(&pdev->dev, "No transceiver phy found\n");

I don't think you should print anything here...
If the driver was working before w/o a phy it will still work without one.

> +	else
> +		priv->cdev.can.bitrate_max =3D transceiver->attrs.max_link_rate;
> +
>  	priv->base =3D addr;
>  	priv->mram_base =3D mram_addr;
> =20
> @@ -108,6 +122,7 @@ static int m_can_plat_probe(struct platform_device *p=
dev)
>  	mcan_class->pm_clock_support =3D 1;
>  	mcan_class->can.clock.freq =3D clk_get_rate(mcan_class->cclk);
>  	mcan_class->dev =3D &pdev->dev;
> +	mcan_class->transceiver =3D transceiver;
> =20
>  	mcan_class->ops =3D &m_can_plat_ops;

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--o2cm6ur22kzzisul
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmB3Bx4ACgkQqclaivrt
76nqJgf+LvxWJun+RUUBEPoWS+K37DWPDjH1rwLLtden4SbODJ8WChiTH/ePXBYW
Y+FCVPbDdWfe2HdSLx+QKpupk9/xkowAeBTZmgQvxmZ9av0GNvO0BkuFauxqIRWv
qw3U9KaiI9BSEQ4Z4eQqi9Ilm/vMLnqRJE45wbS6G07YI9jyFZfxFfRqA2TSoBmw
Djn2OPbzHF0Z6OgrmnU3B5qtJ8XINX96dfQlRaLxEDJpSuQL0XkyKU5nr++Rs1Ih
oU+Upvw9d7sj6wvWqadsX32r5eg3KIw+uBEVP53B/+q9EZhSP1rKPukAOvSWzjDU
8oepPcFcmhLUyuMWrfEbzqeeYj/NWQ==
=77j2
-----END PGP SIGNATURE-----

--o2cm6ur22kzzisul--

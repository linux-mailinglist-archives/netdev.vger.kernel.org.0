Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010656E29FA
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 20:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjDNSU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 14:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjDNSU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 14:20:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AC19EF7
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 11:20:25 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pnO1p-000341-LU; Fri, 14 Apr 2023 20:20:09 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E26861AF3E5;
        Fri, 14 Apr 2023 18:20:03 +0000 (UTC)
Date:   Fri, 14 Apr 2023 20:20:01 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Judith Mendez <jm@ti.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Schuyler Patton <spatton@ti.com>
Subject: Re: [RFC PATCH 5/5] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <20230414-bounding-guidance-262dffacd05c-mkl@pengutronix.de>
References: <20230413223051.24455-1-jm@ti.com>
 <20230413223051.24455-6-jm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tfenu4g5zij6oym6"
Content-Disposition: inline
In-Reply-To: <20230413223051.24455-6-jm@ti.com>
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


--tfenu4g5zij6oym6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.04.2023 17:30:51, Judith Mendez wrote:
> Add a hrtimer to MCAN struct. Each MCAN will have its own
> hrtimer instantiated if there is no hardware interrupt found.
>=20
> The hrtimer will generate a software interrupt every 1 ms. In

Are you sure about the 1ms?

> hrtimer callback, we check if there is a transaction pending by
> reading a register, then process by calling the isr if there is.
>=20
> Signed-off-by: Judith Mendez <jm@ti.com>
> ---
>  drivers/net/can/m_can/m_can.c          | 24 ++++++++++++++++++++++--
>  drivers/net/can/m_can/m_can.h          |  3 +++
>  drivers/net/can/m_can/m_can_platform.c |  9 +++++++--
>  3 files changed, 32 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 8e83d6963d85..bb9d53f4d3cc 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -23,6 +23,7 @@
>  #include <linux/pinctrl/consumer.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/hrtimer.h>
> =20
>  #include "m_can.h"
> =20
> @@ -1584,6 +1585,11 @@ static int m_can_close(struct net_device *dev)
>  	if (!cdev->is_peripheral)
>  		napi_disable(&cdev->napi);
> =20
> +	if (dev->irq < 0) {
> +		dev_info(cdev->dev, "Disabling the hrtimer\n");

Make it a dev_dbg() or remove completely.

> +		hrtimer_cancel(&cdev->hrtimer);
> +	}
> +
>  	m_can_stop(dev);
>  	m_can_clk_stop(cdev);
>  	free_irq(dev->irq, dev);
> @@ -1792,6 +1798,19 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff=
 *skb,
>  	return NETDEV_TX_OK;
>  }
> =20
> +enum hrtimer_restart hrtimer_callback(struct hrtimer *timer)
> +{
> +	irqreturn_t ret;

never read value?

> +	struct m_can_classdev *cdev =3D
> +		container_of(timer, struct m_can_classdev, hrtimer);
> +
> +	ret =3D m_can_isr(0, cdev->net);
> +
> +	hrtimer_forward_now(timer, ns_to_ktime(5 * NSEC_PER_MSEC));

There's ms_to_ktime()....and the "5" doesn't match your patch
description.

> +
> +	return HRTIMER_RESTART;
> +}
> +
>  static int m_can_open(struct net_device *dev)
>  {
>  	struct m_can_classdev *cdev =3D netdev_priv(dev);
> @@ -1836,8 +1855,9 @@ static int m_can_open(struct net_device *dev)
>  	}
> =20
>  	if (err < 0) {
> -		netdev_err(dev, "failed to request interrupt\n");
> -		goto exit_irq_fail;
> +		dev_info(cdev->dev, "Enabling the hrtimer\n");
> +		cdev->hrtimer.function =3D &hrtimer_callback;
> +		hrtimer_start(&cdev->hrtimer, ns_to_ktime(0), HRTIMER_MODE_REL_PINNED);

IMHO it makes no sense to request an IRQ if the device doesn't have one,
and then try to fix up things in the error path. What about this?

--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1831,9 +1831,11 @@ static int m_can_open(struct net_device *dev)
                 err =3D request_threaded_irq(dev->irq, NULL, m_can_isr,
                                            IRQF_ONESHOT,
                                            dev->name, dev);
-        } else {
+        } else if (dev->irq) {
                 err =3D request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev-=
>name,
                                   dev);
+        } else {
+                // polling
         }
=20
         if (err < 0) {

>  	}
> =20
>  	/* start the m_can controller */
> diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
> index a839dc71dc9b..ed046d77fdb9 100644
> --- a/drivers/net/can/m_can/m_can.h
> +++ b/drivers/net/can/m_can/m_can.h
> @@ -28,6 +28,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
> +#include <linux/hrtimer.h>
> =20
>  /* m_can lec values */
>  enum m_can_lec_type {
> @@ -93,6 +94,8 @@ struct m_can_classdev {
>  	int is_peripheral;
> =20
>  	struct mram_cfg mcfg[MRAM_CFG_NUM];
> +
> +	struct hrtimer hrtimer;
>  };
> =20
>  struct m_can_classdev *m_can_class_allocate_dev(struct device *dev, int =
sizeof_priv);
> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_c=
an/m_can_platform.c
> index 9c1dcf838006..53e1648e9dab 100644
> --- a/drivers/net/can/m_can/m_can_platform.c
> +++ b/drivers/net/can/m_can/m_can_platform.c
> @@ -7,6 +7,7 @@
> =20
>  #include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
> +#include <linux/hrtimer.h>
> =20
>  #include "m_can.h"
> =20
> @@ -98,8 +99,12 @@ static int m_can_plat_probe(struct platform_device *pd=
ev)
>  	addr =3D devm_platform_ioremap_resource_byname(pdev, "m_can");
>  	irq =3D platform_get_irq_byname(pdev, "int0");
>  	if (IS_ERR(addr) || irq < 0) {

What about the IS_ERR(addr) case?

> -		ret =3D -EINVAL;
> -		goto probe_fail;
> +		if (irq =3D=3D -EPROBE_DEFER) {
> +			ret =3D -EPROBE_DEFER;
> +			goto probe_fail;
> +		}
> +		dev_info(mcan_class->dev, "Failed to get irq, initialize hrtimer\n");
> +		hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_P=
INNED);

I don't like it when polling is unconditionally set up in case of an irq
error. I'm not sure if we need an explicit device tree property....

>  	}
> =20
>  	/* message ram could be shared */
> --=20
> 2.17.1
>=20
>

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--tfenu4g5zij6oym6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQ5mUwACgkQvlAcSiqK
BOjFcwf+LKipGSC4WttM1dgCxd5Xp2hAJFwtmQmkb/sewpvvfsMwUV1JKfMHKFeT
00wR3cJxjO+uoKC7tS0+W8TmwX8rjsmbVkkwqVqovFi9Wg7MrKiPedoJolkHhsL3
SiK1J5f7SsqvAo9yEo9PdlIWfNzxgcmtpuGCumUJPaAz0mYazPKI9ICEBjA6/WQk
TLcSRh7TPHU8QuuL7le/AHl/9vaOUBPYWSY8tgzwrgvpAzYPvApTTCcElPHKZ6I0
wlwT3KK2ED6LinsZ5HHdCEIGFG7+eN6TGgrxou4gp1jj1/TxhlBt+9tsazAEDbz+
QmHsnFEvtA5kP6UQQW5fvv/TJf1wxQ==
=r55h
-----END PGP SIGNATURE-----

--tfenu4g5zij6oym6--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489D56E8E5D
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 11:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbjDTJlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 05:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbjDTJkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 05:40:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DC85FF0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 02:38:51 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ppQjR-0008Cs-Mx; Thu, 20 Apr 2023 11:37:37 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A56391B3CD6;
        Thu, 20 Apr 2023 09:37:35 +0000 (UTC)
Date:   Thu, 20 Apr 2023 11:37:35 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Judith Mendez <jm@ti.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <20230420-unlikable-overstep-6ad655c5bbdc-mkl@pengutronix.de>
References: <20230419223323.20384-1-jm@ti.com>
 <20230419223323.20384-2-jm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ikdkjwlh4qdhgblk"
Content-Disposition: inline
In-Reply-To: <20230419223323.20384-2-jm@ti.com>
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


--ikdkjwlh4qdhgblk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19.04.2023 17:33:20, Judith Mendez wrote:
> Add an hrtimer to MCAN struct. Each MCAN will have its own
> hrtimer instantiated if there is no hardware interrupt found.
>=20
> The hrtimer will generate a software interrupt every 1 ms. In
> hrtimer callback, we check if there is a transaction pending by
> reading a register, then process by calling the isr if there is.
>=20
> Signed-off-by: Judith Mendez <jm@ti.com>
> ---
>  drivers/net/can/m_can/m_can.c          | 30 ++++++++++++++++++++++++--
>  drivers/net/can/m_can/m_can.h          |  3 +++
>  drivers/net/can/m_can/m_can_platform.c | 13 +++++++++--
>  3 files changed, 42 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index a5003435802b..8784bdea300a 100644
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
> @@ -1587,6 +1588,11 @@ static int m_can_close(struct net_device *dev)
>  	if (!cdev->is_peripheral)
>  		napi_disable(&cdev->napi);
> =20
> +	if (dev->irq < 0) {
> +		dev_dbg(cdev->dev, "Disabling the hrtimer\n");
> +		hrtimer_cancel(&cdev->hrtimer);
> +	}
> +
>  	m_can_stop(dev);
>  	m_can_clk_stop(cdev);
>  	free_irq(dev->irq, dev);
> @@ -1793,6 +1799,18 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff=
 *skb,
>  	return NETDEV_TX_OK;
>  }
> =20
> +enum hrtimer_restart hrtimer_callback(struct hrtimer *timer)
> +{
> +	struct m_can_classdev *cdev =3D
> +		container_of(timer, struct m_can_classdev, hrtimer);
> +
> +	m_can_isr(0, cdev->net);
> +
> +	hrtimer_forward_now(timer, ms_to_ktime(1));
> +
> +	return HRTIMER_RESTART;
> +}
> +
>  static int m_can_open(struct net_device *dev)
>  {
>  	struct m_can_classdev *cdev =3D netdev_priv(dev);
> @@ -1827,13 +1845,21 @@ static int m_can_open(struct net_device *dev)
>  		}
> =20
>  		INIT_WORK(&cdev->tx_work, m_can_tx_work_queue);
> -
>  		err =3D request_threaded_irq(dev->irq, NULL, m_can_isr,
>  					   IRQF_ONESHOT,
>  					   dev->name, dev);
> +

nitpick:
Please remove these 2 newline changes.

>  	} else {
> -		err =3D request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
> +		if (dev->irq > 0)	{

Please follow the kernel coding style and use a space not a tab after
the closing ")" of the "if".

> +			err =3D request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
>  				  dev);
> +		}
> +
> +		else	{

Please use kernel coding style: "} else {"

> +			dev_dbg(cdev->dev, "Enabling the hrtimer\n");
> +			cdev->hrtimer.function =3D &hrtimer_callback;
> +			hrtimer_start(&cdev->hrtimer, ns_to_ktime(0), HRTIMER_MODE_REL_PINNED=
);
> +		}

I think there's no need to have nested else branches, what about this
approach?

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
>  	if (err < 0) {
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
> index 9c1dcf838006..7540db74b7d0 100644
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
> @@ -98,8 +99,16 @@ static int m_can_plat_probe(struct platform_device *pd=
ev)
>  	addr =3D devm_platform_ioremap_resource_byname(pdev, "m_can");
>  	irq =3D platform_get_irq_byname(pdev, "int0");
>  	if (IS_ERR(addr) || irq < 0) {
> -		ret =3D -EINVAL;
> -		goto probe_fail;
> +		if (irq =3D=3D -EPROBE_DEFER) {
> +			ret =3D -EPROBE_DEFER;
> +			goto probe_fail;
> +		}
> +		if (IS_ERR(addr)) {
> +			ret =3D PTR_ERR(addr);
> +			goto probe_fail;
> +		}
> +		dev_dbg(mcan_class->dev, "Failed to get irq, initialize hrtimer\n");
> +		hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_P=
INNED);

Looks better. Please remove the outer "if (IS_ERR(addr) || irq < 0)" and
move the error checking directly after "addr =3D devm_platform_ioremap_reso=
urce_byname()".

What do you think about introducing the "poll-interval" property and
only enable polling if it is set?

>  	}
> =20
>  	/* message ram could be shared */
> --=20
> 2.17.1
>=20
>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--ikdkjwlh4qdhgblk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRBB9wACgkQvlAcSiqK
BOg0zgf8CBj+E5MKzrz5bNRXj0BWuK0IdUDA6yeaHlfkfp2NkkBFuJt+CkVPvX0y
e+kKRBxqpIlZ+fPxzMVqyP0AuGHn4+9wtfMngfEvtTi/BlhuBkQMRQYVTPcUEjwI
bNggMFPpIj0Re1c15cICUOBFLlmTUvpD5mC08LprvOtLKF78R336dOwVkrM+gNjF
ke3ickmvQjQFlS370Ge6YeABRISdipavv7e0xvoWt613yTCnXShppLIGfQm7d6rF
Cs7GTVwYLEmtepUK2GwjKrKLRF4N6CfHezmTq/Y7e0ztnEUeE4IOqicFxoLaAsRj
++iDnGMinJGDZXBdwVY5EKos9lehIQ==
=9hcv
-----END PGP SIGNATURE-----

--ikdkjwlh4qdhgblk--

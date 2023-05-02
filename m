Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890BD6F3DA4
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 08:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbjEBGjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 02:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbjEBGjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 02:39:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D6949F1
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 23:39:33 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ptjf2-0006mz-3W; Tue, 02 May 2023 08:38:52 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C0C6D1BBE79;
        Tue,  2 May 2023 06:37:22 +0000 (UTC)
Date:   Tue, 2 May 2023 08:37:22 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Judith Mendez <jm@ti.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v4 2/4] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <20230502-twiddling-threaten-d032287d4630-mkl@pengutronix.de>
References: <20230501224624.13866-1-jm@ti.com>
 <20230501224624.13866-3-jm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="notui7hxmr3gkxd5"
Content-Disposition: inline
In-Reply-To: <20230501224624.13866-3-jm@ti.com>
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


--notui7hxmr3gkxd5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.05.2023 17:46:22, Judith Mendez wrote:
> Add an hrtimer to MCAN class device. Each MCAN will have its own
> hrtimer instantiated if there is no hardware interrupt found and
> poll-interval property is defined in device tree M_CAN node.
>=20
> The hrtimer will generate a software interrupt every 1 ms. In
> hrtimer callback, we check if there is a transaction pending by
> reading a register, then process by calling the isr if there is.
>=20
> Signed-off-by: Judith Mendez <jm@ti.com>

I think this patch is as good as it gets, given the HW and SW
limitations of the coprocessor.

Some minor nitpicks inline. No need to resend from my point of view,
I'll fixup while applying the patch.

Marc

> ---
> Changelog:
> v1:
>  1. Sort list of includes
>  2. Create a define for HR_TIMER_POLL_INTERVAL
>  3. Fix indentations and style issues/warnings
>  4. Change polling variable to type bool
>  5. Change platform_get_irq to optional so not to print error msg
>  6. Move error check for addr directly after assignment
>  7. Print appropriate error msg with dev_err_probe insead of dev_dbg
>=20
> v2:
>  1. Add poll-interval to MCAN class device to check if poll-interval prop=
ery is
>     present in MCAN node, this enables timer polling method
>  2. Add 'polling' flag to MCAN class device to check if a device is using=
 timer
>     polling method
>  3. Check if both timer polling and hardware interrupt are enabled for a =
MCAN
>     device, default to hardware interrupt mode if both are enabled
>  4. Change ms_to_ktime() to ns_to_ktime()
>  5. Remove newlines, tabs, and restructure if/else section
> =20
>  drivers/net/can/m_can/m_can.c          | 29 +++++++++++++++++++++--
>  drivers/net/can/m_can/m_can.h          |  4 ++++
>  drivers/net/can/m_can/m_can_platform.c | 32 +++++++++++++++++++++++---
>  3 files changed, 60 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index a5003435802b..e1ac0c1d85a3 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -11,6 +11,7 @@
>  #include <linux/bitfield.h>
>  #include <linux/can/dev.h>
>  #include <linux/ethtool.h>
> +#include <linux/hrtimer.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/iopoll.h>
> @@ -308,6 +309,9 @@ enum m_can_reg {
>  #define TX_EVENT_MM_MASK	GENMASK(31, 24)
>  #define TX_EVENT_TXTS_MASK	GENMASK(15, 0)
> =20
> +/* Hrtimer polling interval */
> +#define HRTIMER_POLL_INTERVAL		1
> +
>  /* The ID and DLC registers are adjacent in M_CAN FIFO memory,
>   * and we can save a (potentially slow) bus round trip by combining
>   * reads and writes to them.
> @@ -1587,6 +1591,11 @@ static int m_can_close(struct net_device *dev)
>  	if (!cdev->is_peripheral)
>  		napi_disable(&cdev->napi);
> =20
> +	if (cdev->polling) {
> +		dev_dbg(cdev->dev, "Disabling the hrtimer\n");
> +		hrtimer_cancel(&cdev->hrtimer);
> +	}
> +
>  	m_can_stop(dev);
>  	m_can_clk_stop(cdev);
>  	free_irq(dev->irq, dev);
> @@ -1793,6 +1802,18 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff=
 *skb,
>  	return NETDEV_TX_OK;
>  }
> =20
> +static enum hrtimer_restart hrtimer_callback(struct hrtimer *timer)
> +{
> +	struct m_can_classdev *cdev =3D container_of(timer, struct
> +						   m_can_classdev, hrtimer);
> +
> +	m_can_isr(0, cdev->net);
> +
> +	hrtimer_forward_now(timer, ms_to_ktime(HRTIMER_POLL_INTERVAL));
> +
> +	return HRTIMER_RESTART;
> +}
> +
>  static int m_can_open(struct net_device *dev)
>  {
>  	struct m_can_classdev *cdev =3D netdev_priv(dev);
> @@ -1827,13 +1848,17 @@ static int m_can_open(struct net_device *dev)
>  		}
> =20
>  		INIT_WORK(&cdev->tx_work, m_can_tx_work_queue);
> -

unrelated change

>  		err =3D request_threaded_irq(dev->irq, NULL, m_can_isr,
>  					   IRQF_ONESHOT,
>  					   dev->name, dev);
> -	} else {
> +	} else if (!cdev->polling) {
>  		err =3D request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
>  				  dev);
> +	} else {
> +		dev_dbg(cdev->dev, "Start hrtimer\n");
> +		cdev->hrtimer.function =3D &hrtimer_callback;
> +		hrtimer_start(&cdev->hrtimer, ms_to_ktime(HRTIMER_POLL_INTERVAL),
> +			      HRTIMER_MODE_REL_PINNED);
>  	}
> =20
>  	if (err < 0) {
> diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
> index a839dc71dc9b..e9db5cce4e68 100644
> --- a/drivers/net/can/m_can/m_can.h
> +++ b/drivers/net/can/m_can/m_can.h
> @@ -15,6 +15,7 @@
>  #include <linux/device.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/freezer.h>
> +#include <linux/hrtimer.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/iopoll.h>
> @@ -93,6 +94,9 @@ struct m_can_classdev {
>  	int is_peripheral;
> =20
>  	struct mram_cfg mcfg[MRAM_CFG_NUM];
> +
> +	struct hrtimer hrtimer;
> +	bool polling;
>  };
> =20
>  struct m_can_classdev *m_can_class_allocate_dev(struct device *dev, int =
sizeof_priv);
> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_c=
an/m_can_platform.c
> index 9c1dcf838006..0fcb436298f8 100644
> --- a/drivers/net/can/m_can/m_can_platform.c
> +++ b/drivers/net/can/m_can/m_can_platform.c
> @@ -5,6 +5,7 @@
>  //
>  // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.=
com/
> =20
> +#include <linux/hrtimer.h>
>  #include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
> =20
> @@ -96,12 +97,37 @@ static int m_can_plat_probe(struct platform_device *p=
dev)
>  		goto probe_fail;
> =20
>  	addr =3D devm_platform_ioremap_resource_byname(pdev, "m_can");
> -	irq =3D platform_get_irq_byname(pdev, "int0");
> -	if (IS_ERR(addr) || irq < 0) {
> -		ret =3D -EINVAL;
> +	if (IS_ERR(addr)) {
> +		ret =3D PTR_ERR(addr);
>  		goto probe_fail;
>  	}
> =20
> +	irq =3D platform_get_irq_byname_optional(pdev, "int0");
> +	if (irq =3D=3D -EPROBE_DEFER) {
> +		ret =3D -EPROBE_DEFER;
> +		goto probe_fail;
> +	}
> +
> +	if (device_property_present(mcan_class->dev, "poll-interval"))
> +		mcan_class->polling =3D 1;

true

> +
> +	if (!mcan_class->polling && irq < 0) {
> +		ret =3D -ENXIO;
> +		dev_err_probe(mcan_class->dev, ret, "IRQ int0 not found and polling no=
t activated\n");
> +		goto probe_fail;
> +	}
> +
> +	if (mcan_class->polling) {
> +		if (irq > 0) {
> +			mcan_class->polling =3D 0;

false

> +			dev_dbg(mcan_class->dev, "Polling enabled and hardware IRQ found, use=
 hardware IRQ\n");

"...using hardware IRQ"

Use dev_info(), as there is something not 100% correct with the DT.

> +		} else {
> +			dev_dbg(mcan_class->dev, "Polling enabled, initialize hrtimer");
> +			hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC,
> +				     HRTIMER_MODE_REL_PINNED);
> +		}
> +	}
> +
>  	/* message ram could be shared */
>  	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram=
");
>  	if (!res) {
> --=20
> 2.17.1
>=20
>=20

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--notui7hxmr3gkxd5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRQr58ACgkQvlAcSiqK
BOjAZwf/bua5njZUN9XsvjnaiWJFLDyReKbLyv+49oNo8KKJgexKsDRwjgztlXWk
ulae8dFIn0Tgpix7qgVEBvAkHaPNmgfU433SDxyGzPlYY8qU7Aej7iOmz84ZNs4w
IX/LVlfwoXgHBJxKNh2AISQu4Y6W7DHDSJjewAzln2FXGDANhAU86sTJxNnj0EL2
ny9ke+jEgy35m8ZJVKKE6TkuoFnpPGQoTWIBkPbPwyWlXs+d8NhKmIWsQ8p5RRUU
1Rkb7auG3iuJx3wFaQe4zYjr6vs03XeQo6FOQwWOYd1PJ4eT+04K6GYijkQ9ARUK
qEO6soFbuJLRJLP8ewcMLVGWNmJwhw==
=Bk1F
-----END PGP SIGNATURE-----

--notui7hxmr3gkxd5--

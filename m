Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB11553F974
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 11:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238949AbiFGJUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 05:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239458AbiFGJUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 05:20:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4626FE52A5
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 02:20:07 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nyVNS-0006EU-PP; Tue, 07 Jun 2022 11:19:54 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D4C648D99B;
        Tue,  7 Jun 2022 09:19:52 +0000 (UTC)
Date:   Tue, 7 Jun 2022 11:19:52 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Srinivas Neeli <srinivas.neeli@xilinx.com>
Cc:     wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        appana.durga.rao@xilinx.com, sgoud@xilinx.com,
        michal.simek@xilinx.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com, Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: Re: [PATCH V2 2/2] can: xilinx_can: Add Transmitter delay
 compensation (TDC) feature support
Message-ID: <20220607091952.gls5bgwplytbhmoq@pengutronix.de>
References: <20220607085654.4178-1-srinivas.neeli@xilinx.com>
 <20220607085654.4178-3-srinivas.neeli@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wul5pjtdvnfd2zlk"
Content-Disposition: inline
In-Reply-To: <20220607085654.4178-3-srinivas.neeli@xilinx.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
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


--wul5pjtdvnfd2zlk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Srinivas Neeli,

thanks for your patch!

On 07.06.2022 14:26:54, Srinivas Neeli wrote:
> Added Transmitter delay compensation (TDC) feature support.
> In the case of higher measured loop delay with higher baud rates,
> observed bit stuff errors. By enabling the TDC feature in a controller,
> will compensate for the measure loop delay in the receive path.

Wich controllers support TDC?

XAXI_CANFD doesn't have do_get_auto_tdc assigned, but
CAN_CTRLMODE_TDC_AUTO is set.

> Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
> ---
>  drivers/net/can/xilinx_can.c | 46 +++++++++++++++++++++++++++++++++---
>  1 file changed, 43 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
> index e179d311aa28..d0edd1bca33c 100644
> --- a/drivers/net/can/xilinx_can.c
> +++ b/drivers/net/can/xilinx_can.c
> @@ -1,7 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-or-later
>  /* Xilinx CAN device driver
>   *
> - * Copyright (C) 2012 - 2014 Xilinx, Inc.
> + * Copyright (C) 2012 - 2022 Xilinx, Inc.
>   * Copyright (C) 2009 PetaLogix. All rights reserved.
>   * Copyright (C) 2017 - 2018 Sandvik Mining and Construction Oy
>   *
> @@ -99,6 +99,7 @@ enum xcan_reg {
>  #define XCAN_ESR_STER_MASK		0x00000004 /* Stuff error */
>  #define XCAN_ESR_FMER_MASK		0x00000002 /* Form error */
>  #define XCAN_ESR_CRCER_MASK		0x00000001 /* CRC error */
> +#define XCAN_SR_TDCV_MASK		0x007F0000 /* TDCV Value */
>  #define XCAN_SR_TXFLL_MASK		0x00000400 /* TX FIFO is full */
>  #define XCAN_SR_ESTAT_MASK		0x00000180 /* Error status */
>  #define XCAN_SR_ERRWRN_MASK		0x00000040 /* Error warning */
> @@ -132,6 +133,8 @@ enum xcan_reg {
>  #define XCAN_DLCR_BRS_MASK		0x04000000 /* BRS Mask in DLC */
> =20
>  /* CAN register bit shift - XCAN_<REG>_<BIT>_SHIFT */
> +#define XCAN_BRPR_TDCO_SHIFT		8  /* Transmitter Delay Compensation Offse=
t */
> +#define XCAN_BRPR_TDC_ENABLE		BIT(16) /* Transmitter Delay Compensation =
(TDC) Enable */
>  #define XCAN_BTR_SJW_SHIFT		7  /* Synchronous jump width */
>  #define XCAN_BTR_TS2_SHIFT		4  /* Time segment 2 */
>  #define XCAN_BTR_SJW_SHIFT_CANFD	16 /* Synchronous jump width */
> @@ -140,6 +143,7 @@ enum xcan_reg {
>  #define XCAN_IDR_ID2_SHIFT		1  /* Extended Message Identifier */
>  #define XCAN_DLCR_DLC_SHIFT		28 /* Data length code */
>  #define XCAN_ESR_REC_SHIFT		8  /* Rx Error Count */
> +#define XCAN_SR_TDCV_SHIFT		16 /* TDCV Value */
> =20
>  /* CAN frame length constants */
>  #define XCAN_FRAME_MAX_DATA_LEN		8
> @@ -276,6 +280,16 @@ static const struct can_bittiming_const xcan_data_bi=
ttiming_const_canfd2 =3D {
>  	.brp_inc =3D 1,
>  };
> =20
> +/* Transmission Delay Compensation constants for CANFD2.0 and Versal  */
> +static const struct can_tdc_const xcan_tdc_const =3D {
> +	.tdcv_min =3D 0,
> +	.tdcv_max =3D 0, /* Manual mode not supported. */
> +	.tdco_min =3D 0,
> +	.tdco_max =3D 64,
> +	.tdcf_min =3D 0, /* Filter window not supported */
> +	.tdcf_max =3D 0,
> +};
> +
>  /**
>   * xcan_write_reg_le - Write a value to the device register little endian
>   * @priv:	Driver private data structure
> @@ -424,6 +438,11 @@ static int xcan_set_bittiming(struct net_device *nde=
v)
>  	    priv->devtype.cantype =3D=3D XAXI_CANFD_2_0) {
>  		/* Setting Baud Rate prescalar value in F_BRPR Register */
>  		btr0 =3D dbt->brp - 1;
> +		if (can_tdc_is_enabled(&priv->can)) {
> +			btr0 =3D btr0 |

Make use of "|=3D" and properly indent.

> +			priv->can.tdc.tdco << XCAN_BRPR_TDCO_SHIFT |

Please include <linux/bitfield.h> and make use of "FIELD_PREP".

> +			XCAN_BRPR_TDC_ENABLE;
> +		}
> =20
>  		/* Setting Time Segment 1 in BTR Register */
>  		btr1 =3D dbt->prop_seg + dbt->phase_seg1 - 1;
> @@ -1483,6 +1502,23 @@ static int xcan_get_berr_counter(const struct net_=
device *ndev,
>  	return 0;
>  }
> =20
> +/**
> + * xcan_get_auto_tdcv - Get Transmitter Delay Compensation Value
> + * @ndev:	Pointer to net_device structure
> + * @tdcv:	Pointer to TDCV value
> + *
> + * Return: 0 on success
> + */
> +static int xcan_get_auto_tdcv(const struct net_device *ndev, u32 *tdcv)
> +{
> +	struct xcan_priv *priv =3D netdev_priv(ndev);
> +
> +	*tdcv =3D (priv->read_reg(priv, XCAN_SR_OFFSET) & XCAN_SR_TDCV_MASK) >>
> +		 XCAN_SR_TDCV_SHIFT;

Please use FIELD_GET.

> +
> +	return 0;
> +}
> +
>  static const struct net_device_ops xcan_netdev_ops =3D {
>  	.ndo_open	=3D xcan_open,
>  	.ndo_stop	=3D xcan_close,
> @@ -1734,18 +1770,22 @@ static int xcan_probe(struct platform_device *pde=
v)
>  	priv->can.do_get_berr_counter =3D xcan_get_berr_counter;
>  	priv->can.ctrlmode_supported =3D CAN_CTRLMODE_LOOPBACK |
>  					CAN_CTRLMODE_BERR_REPORTING;
> +	priv->can.do_get_auto_tdcv =3D xcan_get_auto_tdcv;

I'm not sure, if it has any side effects, if you assign do_get_auto_tdc
for all controllers, even the ones that don't support it. Vincent can
probably clarify this.

> =20
>  	if (devtype->cantype =3D=3D XAXI_CANFD)
>  		priv->can.data_bittiming_const =3D
>  			&xcan_data_bittiming_const_canfd;
> =20
> -	if (devtype->cantype =3D=3D XAXI_CANFD_2_0)
> +	if (devtype->cantype =3D=3D XAXI_CANFD_2_0) {
>  		priv->can.data_bittiming_const =3D
>  			&xcan_data_bittiming_const_canfd2;
> +		priv->can.tdc_const =3D &xcan_tdc_const;
> +	}
> =20
>  	if (devtype->cantype =3D=3D XAXI_CANFD ||
>  	    devtype->cantype =3D=3D XAXI_CANFD_2_0)
> -		priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_FD;
> +		priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_FD |
> +						CAN_CTRLMODE_TDC_AUTO;
> =20
>  	priv->reg_base =3D addr;
>  	priv->tx_max =3D tx_max;

regards
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--wul5pjtdvnfd2zlk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKfGDUACgkQrX5LkNig
011Ongf/RRwccaV+ZRKLpspCQSOABYzlA8AgPw4sbuqlOMLiEtK67YrEFniOv9Xn
T1qzkcRz7bMEFLSuOCe+pKUXL+kAcWYPYWhlsJ2nvwnf6FvqRQfNMyLKIrW5cpja
bUmulsofHGz5RmCg3HVuZrokdM87s7zcqpSClsSbGsvwNm/7YW+Z5zA9Ags1pAB9
gOPwUzcO5AdQAb5aBuA6/JBckxi1VXFPRGKI79hnNhvmvSrcqRn1nabIFlIM5eTN
daMRZnhT8iw4pUu21yXX9ZGZ5zD7XECro1cuh/js/fjaGe8BYMYOaDn5smGuqbHw
JwRY3Hfn78N4rtAcqgPzBV+YFiVY1Q==
=traN
-----END PGP SIGNATURE-----

--wul5pjtdvnfd2zlk--

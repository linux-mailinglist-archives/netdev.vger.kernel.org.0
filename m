Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7AB5445FA
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241468AbiFIIdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241912AbiFIIcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:32:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C897156B65
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 01:31:56 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nzDZu-0000bA-F5; Thu, 09 Jun 2022 10:31:42 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D43EE8FDCE;
        Thu,  9 Jun 2022 08:31:39 +0000 (UTC)
Date:   Thu, 9 Jun 2022 10:31:39 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Srinivas Neeli <srinivas.neeli@xilinx.com>
Cc:     wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        srinivas.neeli@amd.com, neelisrinivas18@gmail.com,
        appana.durga.rao@xilinx.com, sgoud@xilinx.com,
        michal.simek@xilinx.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com
Subject: Re: [PATCH V3 2/2] can: xilinx_can: Add Transmitter delay
 compensation (TDC) feature support
Message-ID: <20220609083139.sx2adt4raptu2jif@pengutronix.de>
References: <20220609082433.1191060-1-srinivas.neeli@xilinx.com>
 <20220609082433.1191060-3-srinivas.neeli@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="s7pebicfzjrbau5q"
Content-Disposition: inline
In-Reply-To: <20220609082433.1191060-3-srinivas.neeli@xilinx.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--s7pebicfzjrbau5q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.06.2022 13:54:33, Srinivas Neeli wrote:
> Added Transmitter delay compensation (TDC) feature support.
> In the case of higher measured loop delay with higher baud rates,
> observed bit stuff errors. By enabling the TDC feature in
> CANFD controllers, will compensate for the measure loop delay in
> the receive path.
>=20
> Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
> ---
> Changes in V3:
> -Implemented GENMASK,FIELD_PERP & FIELD_GET Calls.
> -Implemented TDC feature for all Xilinx CANFD controllers.
> -corrected prescalar to prescaler(typo).
> Changes in V2:
> -Created two patchs one for revert another for TDC support.
> ---
>  drivers/net/can/xilinx_can.c | 48 ++++++++++++++++++++++++++++++++----
>  1 file changed, 43 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
> index e179d311aa28..288be69c0aed 100644
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
> @@ -9,6 +9,7 @@
>   * This driver is developed for Axi CAN IP and for Zynq CANPS Controller.
>   */
> =20
> +#include <linux/bitfield.h>
>  #include <linux/clk.h>
>  #include <linux/errno.h>
>  #include <linux/init.h>
> @@ -99,6 +100,7 @@ enum xcan_reg {
>  #define XCAN_ESR_STER_MASK		0x00000004 /* Stuff error */
>  #define XCAN_ESR_FMER_MASK		0x00000002 /* Form error */
>  #define XCAN_ESR_CRCER_MASK		0x00000001 /* CRC error */
> +#define XCAN_SR_TDCV_MASK		GENMASK(22, 16) /* TDCV Value */
>  #define XCAN_SR_TXFLL_MASK		0x00000400 /* TX FIFO is full */
>  #define XCAN_SR_ESTAT_MASK		0x00000180 /* Error status */
>  #define XCAN_SR_ERRWRN_MASK		0x00000040 /* Error warning */
> @@ -132,6 +134,8 @@ enum xcan_reg {
>  #define XCAN_DLCR_BRS_MASK		0x04000000 /* BRS Mask in DLC */
> =20
>  /* CAN register bit shift - XCAN_<REG>_<BIT>_SHIFT */
> +#define XCAN_BRPR_TDCO_SHIFT		GENMASK(13, 8)  /* Transmitter Delay Compe=
nsation Offset */
                          ^^^^^
This is a MASK.

> +#define XCAN_BRPR_TDC_ENABLE		BIT(16) /* Transmitter Delay Compensation =
(TDC) Enable */
>  #define XCAN_BTR_SJW_SHIFT		7  /* Synchronous jump width */
>  #define XCAN_BTR_TS2_SHIFT		4  /* Time segment 2 */
>  #define XCAN_BTR_SJW_SHIFT_CANFD	16 /* Synchronous jump width */
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
> @@ -405,7 +419,7 @@ static int xcan_set_bittiming(struct net_device *ndev)
>  		return -EPERM;
>  	}
> =20
> -	/* Setting Baud Rate prescalar value in BRPR Register */
> +	/* Setting Baud Rate prescaler value in BRPR Register */

unrelated change, please make it a separate patch

>  	btr0 =3D (bt->brp - 1);
> =20
>  	/* Setting Time Segment 1 in BTR Register */
> @@ -422,8 +436,12 @@ static int xcan_set_bittiming(struct net_device *nde=
v)
> =20
>  	if (priv->devtype.cantype =3D=3D XAXI_CANFD ||
>  	    priv->devtype.cantype =3D=3D XAXI_CANFD_2_0) {
> -		/* Setting Baud Rate prescalar value in F_BRPR Register */
> +		/* Setting Baud Rate prescaler value in F_BRPR Register */

same

>  		btr0 =3D dbt->brp - 1;
> +		if (can_tdc_is_enabled(&priv->can))
> +			btr0 |=3D
> +			FIELD_PREP(XCAN_BRPR_TDCO_SHIFT, priv->can.tdc.tdco) |
> +			XCAN_BRPR_TDC_ENABLE;
> =20
>  		/* Setting Time Segment 1 in BTR Register */
>  		btr1 =3D dbt->prop_seg + dbt->phase_seg1 - 1;
> @@ -1483,6 +1501,22 @@ static int xcan_get_berr_counter(const struct net_=
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
> +	*tdcv =3D FIELD_GET(XCAN_SR_TDCV_MASK, priv->read_reg(priv, XCAN_SR_OFF=
SET));
> +
> +	return 0;
> +}
> +
>  static const struct net_device_ops xcan_netdev_ops =3D {
>  	.ndo_open	=3D xcan_open,
>  	.ndo_stop	=3D xcan_close,
> @@ -1744,8 +1778,12 @@ static int xcan_probe(struct platform_device *pdev)
>  			&xcan_data_bittiming_const_canfd2;
> =20
>  	if (devtype->cantype =3D=3D XAXI_CANFD ||
> -	    devtype->cantype =3D=3D XAXI_CANFD_2_0)
> -		priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_FD;
> +	    devtype->cantype =3D=3D XAXI_CANFD_2_0) {
> +		priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_FD |
> +						CAN_CTRLMODE_TDC_AUTO;
> +		priv->can.do_get_auto_tdcv =3D xcan_get_auto_tdcv;
> +		priv->can.tdc_const =3D &xcan_tdc_const;
> +	}
> =20
>  	priv->reg_base =3D addr;
>  	priv->tx_max =3D tx_max;
> --=20
> 2.25.1
>=20
>=20

Otherwise looks good.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--s7pebicfzjrbau5q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKhr+gACgkQrX5LkNig
012W6Qf9HOIrjfKerw8OWhbUfDElYj0hgq3YeQpAyhKlFTFEFuXTzB5d3g8LxkxO
5UbFmbo58yxtURpiCkv847K10at5v4Bzul6Rcwq5YmOYBQtQkkrAveKRiukyx88Y
RKmSkgEzA5TtZVGSFaAJFoo9A1Tg+0HRVh1Rnm121xGub7sgpb//Cw2ETWQF5vMv
JpSc8WpSsYIZmSW29qtmS1TfrZ6BJU03seei66FDyLCadiP+Xnm2dwBbxO6olTTr
sgA+d72CrJolZfV/xhonMYHPjl2/gX0DRolaAlVgaNcbBJiRPS9Ra9LOpeIRer29
mZY1Wjh+1AWmyuSlWOx+jvimyn2KaA==
=/OcB
-----END PGP SIGNATURE-----

--s7pebicfzjrbau5q--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A152D325FF3
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 10:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhBZJYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 04:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhBZJW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 04:22:58 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC97C06178B
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 01:22:18 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lFZJy-0005J6-4z; Fri, 26 Feb 2021 10:22:02 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:adc1:3ee1:6274:c5d0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DBBA05E99BB;
        Fri, 26 Feb 2021 09:21:59 +0000 (UTC)
Date:   Fri, 26 Feb 2021 10:21:58 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 5/6] can: c_can: prepare to up the message objects
 number
Message-ID: <20210226092158.krmrds75hy6g3vks@pengutronix.de>
References: <20210225215155.30509-1-dariobin@libero.it>
 <20210225215155.30509-6-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hovsnqewnww35o2i"
Content-Disposition: inline
In-Reply-To: <20210225215155.30509-6-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hovsnqewnww35o2i
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.02.2021 22:51:54, Dario Binacchi wrote:
> --- a/drivers/net/can/c_can/c_can.c
> +++ b/drivers/net/can/c_can/c_can.c
[...]
> -struct net_device *alloc_c_can_dev(void)
> +struct net_device *alloc_c_can_dev(int msg_obj_num)
>  {
>  	struct net_device *dev;
>  	struct c_can_priv *priv;
> +	int msg_obj_tx_num =3D msg_obj_num / 2;
> =20
> -	dev =3D alloc_candev(sizeof(struct c_can_priv), C_CAN_MSG_OBJ_TX_NUM);
> +	dev =3D alloc_candev(sizeof(*priv) + sizeof(u32) * msg_obj_tx_num,
> +			   msg_obj_tx_num);
>  	if (!dev)
>  		return NULL;
> =20
>  	priv =3D netdev_priv(dev);
> -	netif_napi_add(dev, &priv->napi, c_can_poll, C_CAN_NAPI_WEIGHT);
> +	priv->msg_obj_num =3D msg_obj_num;
> +	priv->msg_obj_rx_num =3D msg_obj_num - msg_obj_tx_num;
> +	priv->msg_obj_rx_first =3D 1;
> +	priv->msg_obj_rx_last =3D
> +		priv->msg_obj_rx_first + priv->msg_obj_rx_num - 1;
> +	priv->msg_obj_rx_mask =3D ((u64)1 << priv->msg_obj_rx_num) - 1;

Here you're casting the 1 to 64bit, but msg_obj_rx_mask is only u32. Use
"1UL", if you are sure that rx_mask would never exceed 32 bit.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--hovsnqewnww35o2i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA4vbMACgkQqclaivrt
76lH3Af/daiXgsp1o5BDGL82GyxOG6ElrbK18/+tHyFptfaofu6jQHNYpdEawnl+
T4vQrNUSmLWFGq5bCRq3Br58heLLauUCqg9FeJFEEMgZB4/3sja78lgyb00pWJra
cozJH/YweiB8pqK/Vio5c2KDX1QG1fUfVaD4Q677wdtpLt8N8vqhwCYSm8+3dD3Z
tQI37W6P9TqI+kughgahD9YZHkQbwX1S6uq7oXFEFhayhMfKtwxORnx8stu6dzdP
sZYOnGO+FHRIlB1wpQ4Q7s6rRb5NXp4AVyIBeAWkM8oxv0lM9vWrSOhvecqOCf9U
XmEswW396ahY0yMAtUe0kwrVi01mVQ==
=FzS5
-----END PGP SIGNATURE-----

--hovsnqewnww35o2i--

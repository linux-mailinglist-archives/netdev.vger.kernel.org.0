Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B539E324B2D
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 08:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbhBYHYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 02:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbhBYHYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 02:24:13 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE65C061788
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 23:23:32 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lFAzP-000525-RF; Thu, 25 Feb 2021 08:23:11 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:55fd:a17b:b4ca:d5fb])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5AF8A5E8D3D;
        Thu, 25 Feb 2021 07:23:07 +0000 (UTC)
Date:   Thu, 25 Feb 2021 08:23:06 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/6] can: c_can: prepare to up the message objects number
Message-ID: <20210225072306.wdxtzbpowuorhxlp@pengutronix.de>
References: <20210224225246.11346-1-dariobin@libero.it>
 <20210224225246.11346-6-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4ncm4fr4jlmweoy3"
Content-Disposition: inline
In-Reply-To: <20210224225246.11346-6-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4ncm4fr4jlmweoy3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hey Dario,

just a quick note...

On 24.02.2021 23:52:45, Dario Binacchi wrote:
> -struct net_device *alloc_c_can_dev(void)
> +struct net_device *alloc_c_can_dev(int msg_obj_num)
>  {
>  	struct net_device *dev;
>  	struct c_can_priv *priv;
> +	int msg_obj_tx_num =3D msg_obj_num / 2;
> =20
> -	dev =3D alloc_candev(sizeof(struct c_can_priv), C_CAN_MSG_OBJ_TX_NUM);
> +	dev =3D alloc_candev(sizeof(struct c_can_priv), msg_obj_tx_num);
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
> +
> +	priv->msg_obj_tx_num =3D msg_obj_tx_num;
> +	priv->msg_obj_tx_first =3D priv->msg_obj_rx_last + 1;
> +	priv->msg_obj_tx_last =3D
> +		priv->msg_obj_tx_first + priv->msg_obj_tx_num - 1;
> +
> +	priv->dlc =3D kcalloc(msg_obj_tx_num, sizeof(*priv->dlc), GFP_KERNEL);

You can pass a larger size to alloc_candev() so that it includes the mem
you allocate here.

> +	if (!priv->dlc) {
> +		free_candev(dev);
> +		return NULL;
> +	}
> +
> +	netif_napi_add(dev, &priv->napi, c_can_poll, priv->msg_obj_rx_num);

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--4ncm4fr4jlmweoy3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA3UFcACgkQqclaivrt
76niVAf+IuzAhvFFvjMtVPcuWVBVvHIiEbAaTPfc40isqqtmuoIsiBv1sttYFzFn
A6IiBdAZZgJL+x4TEFbXjOrC+0YHxwL2YIovO7tiZGy98lH0BV4eYRguvmKunm5H
fEH0wHc4Ouw1pSYypUFnVia9UoYB16Npubs6tdipw8bo6IAGWo7LRUlEH1fHvWYP
l9WzqzD0Ywq2tsYvdOuhuo7A7IqwR7FxXTUEwNsLs0mSFdNDOm5t0QLSAv9Q1we7
nNUvfG563VS4f3lBfLny99Ytd+HCprXDfnIBEetrJqDvzk/b7fpyUpGcmNXjVpJe
9PMUlZWuDN6jS22dO2RETQ1Gi5ip5Q==
=pUEf
-----END PGP SIGNATURE-----

--4ncm4fr4jlmweoy3--

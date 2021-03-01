Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E88328FC9
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 21:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242478AbhCAT6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 14:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242206AbhCATwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 14:52:47 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E264DC061356
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 11:49:29 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lGoXg-0000JP-4c; Mon, 01 Mar 2021 20:49:20 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:6e66:a1a4:a449:44cd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 75B5A5EB9BE;
        Mon,  1 Mar 2021 15:08:41 +0000 (UTC)
Date:   Mon, 1 Mar 2021 16:08:40 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: c_can: move runtime PM enable/disable to
 c_can_platform
Message-ID: <20210301150840.mqngl7og46o3nxjb@pengutronix.de>
References: <20210301041550.795500-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5wy4kny7riwtnmwo"
Content-Disposition: inline
In-Reply-To: <20210301041550.795500-1-ztong0001@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5wy4kny7riwtnmwo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.02.2021 23:15:48, Tong Zhang wrote:
> Currently doing modprobe c_can_pci will make kernel complain
> "Unbalanced pm_runtime_enable!", this is caused by pm_runtime_enable()
> called before pm is initialized in register_candev() and doing so will

I don't see where register_candev() is doing any pm related
initialization.

> also cause it to enable twice.

> This fix is similar to 227619c3ff7c, move those pm_enable/disable code to
> c_can_platform.

As I understand 227619c3ff7c ("can: m_can: move runtime PM
enable/disable to m_can_platform"), PCI devices automatically enable PM,
when the "PCI device is added".

Please clarify the above point, otherwise the code looks OK, small
nitpick inline:

> Signed-off-by: Tong Zhang <ztong0001@gmail.com>
> ---
>  drivers/net/can/c_can/c_can.c          | 26 ++------------------------
>  drivers/net/can/c_can/c_can_platform.c |  6 +++++-
>  2 files changed, 7 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
> index ef474bae47a1..04f783b3d9d3 100644
> --- a/drivers/net/can/c_can/c_can.c
> +++ b/drivers/net/can/c_can/c_can.c
> @@ -212,18 +212,6 @@ static const struct can_bittiming_const c_can_bittim=
ing_const =3D {
>  	.brp_inc =3D 1,
>  };
> =20
> -static inline void c_can_pm_runtime_enable(const struct c_can_priv *priv)
> -{
> -	if (priv->device)
> -		pm_runtime_enable(priv->device);
> -}
> -
> -static inline void c_can_pm_runtime_disable(const struct c_can_priv *pri=
v)
> -{
> -	if (priv->device)
> -		pm_runtime_disable(priv->device);
> -}
> -
>  static inline void c_can_pm_runtime_get_sync(const struct c_can_priv *pr=
iv)
>  {
>  	if (priv->device)
> @@ -1335,7 +1323,6 @@ static const struct net_device_ops c_can_netdev_ops=
 =3D {
> =20
>  int register_c_can_dev(struct net_device *dev)
>  {
> -	struct c_can_priv *priv =3D netdev_priv(dev);
>  	int err;
> =20
>  	/* Deactivate pins to prevent DRA7 DCAN IP from being
> @@ -1345,28 +1332,19 @@ int register_c_can_dev(struct net_device *dev)
>  	 */
>  	pinctrl_pm_select_sleep_state(dev->dev.parent);
> =20
> -	c_can_pm_runtime_enable(priv);
> -
>  	dev->flags |=3D IFF_ECHO;	/* we support local echo */
>  	dev->netdev_ops =3D &c_can_netdev_ops;
> =20
>  	err =3D register_candev(dev);
> -	if (err)
> -		c_can_pm_runtime_disable(priv);
> -	else
> -		devm_can_led_init(dev);
> -
> +	if (!err)
> +	  devm_can_led_init(dev);

Please indent with two tabs here.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--5wy4kny7riwtnmwo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA9A3YACgkQqclaivrt
76nuYgf/ZDCBnW3yY+g2dIjUY3j7qA4gy93sa/gHteqCR7eDyuE22thYiSfZ9r2G
3bTT1g75I/ikzX8VPV1aSzw1Wu5qgCIkf1yS2cK0Mtq3kFObNRYLomdf1hcFskDk
sTC1/5+DOGvNQ7sxE9QBXFRMhzCGtAAUllXdQpTPeA9pSSedBkNclVuRHZ9stx54
JkenoFPsIxrGOQrZUCXu3/NSbx6aYW6s7JtKdb5FEo8ZfXj7CZNg9aK5InI/zzGs
HiiEItzRAxodwho2bvRtdhqv5UgRj4uzuHPBVX7BJdA61GEgvtA6RL74tRj0muyG
cfiCgOIIC+ZZ0VpanLKxz1+OxGg+6w==
=zNL/
-----END PGP SIGNATURE-----

--5wy4kny7riwtnmwo--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AD063D3D2
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 11:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiK3Kyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 05:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiK3Kyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 05:54:38 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A05140E1
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 02:54:37 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p0KjM-00053C-Ib; Wed, 30 Nov 2022 11:54:20 +0100
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:38ad:958d:3def:4382])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 19C4A12DD57;
        Wed, 30 Nov 2022 10:54:18 +0000 (UTC)
Date:   Wed, 30 Nov 2022 11:54:17 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     haibo.chen@nxp.com
Cc:     wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-imx@nxp.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] can: flexcan: add auto stop mode for IMX93 to
 support wakeup
Message-ID: <20221130105417.yhljwl5dtuu5f2du@pengutronix.de>
References: <1669116752-4260-1-git-send-email-haibo.chen@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="o4vjzx26m77hgxnw"
Content-Disposition: inline
In-Reply-To: <1669116752-4260-1-git-send-email-haibo.chen@nxp.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--o4vjzx26m77hgxnw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.11.2022 19:32:30, haibo.chen@nxp.com wrote:
> From: Haibo Chen <haibo.chen@nxp.com>
>=20
> IMX93 do not contain a GPR to config the stop mode, it will set
> the flexcan into stop mode automatically once the ARM core go
> into low power mode (WFI instruct) and gate off the flexcan
> related clock automatically. But to let these logic work as
> expect, before ARM core go into low power mode, need to make
> sure the flexcan related clock keep on.
>=20
> To support stop mode and wakeup feature on imx93, this patch
> add a new fsl_imx93_devtype_data to separate from imx8mp.
>=20
> Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
> ---
>  drivers/net/can/flexcan/flexcan-core.c | 37 +++++++++++++++++++++++---
>  drivers/net/can/flexcan/flexcan.h      |  2 ++
>  2 files changed, 36 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/can/flexcan/flexcan-core.c b/drivers/net/can/fle=
xcan/flexcan-core.c
> index 9bdadd716f4e..0aeff34e5ae1 100644
> --- a/drivers/net/can/flexcan/flexcan-core.c
> +++ b/drivers/net/can/flexcan/flexcan-core.c

[...]

> @@ -2299,8 +2322,16 @@ static int __maybe_unused flexcan_noirq_suspend(st=
ruct device *device)
>  	if (netif_running(dev)) {
>  		int err;
> =20
> -		if (device_may_wakeup(device))
> +		if (device_may_wakeup(device)) {
>  			flexcan_enable_wakeup_irq(priv, true);
> +			/* For auto stop mode, need to keep the clock on before
> +			 * system go into low power mode. After system go into
> +			 * low power mode, hardware will config the flexcan into
> +			 * stop mode, and gate off the clock automatically.
> +			 */
> +			if (priv->devtype_data.quirks & FLEXCAN_QUIRK_AUTO_STOP_MODE)
> +				return 0;
> +		}

With this change the flexcan_noirq_resume() is not symmetrical any more:
pm_runtime_force_suspend() is not called for mx93, but
pm_runtime_force_resume() is called.

> =20
>  		err =3D pm_runtime_force_suspend(device);
>  		if (err)

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--o4vjzx26m77hgxnw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOHNlYACgkQrX5LkNig
010lPAf8DDn0wxSMuLblKuSMMpCeNW0GUhqzelJUsvh3LaZbSMw4bagjKVNCI9ly
fh/ZvC/C+A8PCJvT8hflMmlL4cFehDuLYkMsZYbVXWp6AsvTq1jgExwvBMbve7xX
l1DUxrHRFYnfZP/hGEofSjRoSF6KvTFNrQs6Kwzw0c1CbYJvHRJXh9zUmDnNcsV1
BWQqfqTdm5UrBPRs2WrfyCfTiz0mKGdgbXVRWn61W3zx6y3KYthBhpybpVYZXJqW
hhCaUWY7kNf2MrfpXOf998pyWB8fdNox3gNTYtcmmz4NlJp8Eivvhvh8rRtbP6tz
Qb529tdb7bMnFJ+O052M621nKnJDJw==
=9OQB
-----END PGP SIGNATURE-----

--o4vjzx26m77hgxnw--

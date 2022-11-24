Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA3E637B8D
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiKXOkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKXOkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:40:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330AFC5B60
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:40:17 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyDOR-0001xM-ET; Thu, 24 Nov 2022 15:39:59 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:5507:4aba:5e0a:4c27])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9705A12864A;
        Thu, 24 Nov 2022 14:39:58 +0000 (UTC)
Date:   Thu, 24 Nov 2022 15:39:57 +0100
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
Message-ID: <20221124143957.fr5fojvu3fa5vhnj@pengutronix.de>
References: <1669116752-4260-1-git-send-email-haibo.chen@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yhn2qnplluft6atz"
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


--yhn2qnplluft6atz
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
> @@ -345,6 +345,15 @@ static struct flexcan_devtype_data fsl_imx8mp_devtyp=
e_data =3D {
>  		FLEXCAN_QUIRK_SUPPORT_RX_MAILBOX_RTR,
>  };
> =20
> +static struct flexcan_devtype_data fsl_imx93_devtype_data =3D {
> +	.quirks =3D FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS=
 |
> +		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_RX_MAILBOX |
> +		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_AUTO_STOP_MODE |
> +		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SUPPORT_ECC |
> +		FLEXCAN_QUIRK_SUPPORT_RX_MAILBOX |
> +		FLEXCAN_QUIRK_SUPPORT_RX_MAILBOX_RTR,
> +};
> +
>  static const struct flexcan_devtype_data fsl_vf610_devtype_data =3D {
>  	.quirks =3D FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS=
 |
>  		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_RX_MAILBOX |
> @@ -532,9 +541,14 @@ static inline int flexcan_enter_stop_mode(struct fle=
xcan_priv *priv)
>  		ret =3D flexcan_stop_mode_enable_scfw(priv, true);
>  		if (ret < 0)
>  			return ret;
> -	} else {
> +	} else if (priv->devtype_data.quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_GP=
R) {
>  		regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
>  				   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
> +	} else if (priv->devtype_data.quirks & FLEXCAN_QUIRK_AUTO_STOP_MODE) {
> +		/* For the auto stop mode, software do nothing, hardware will cover
> +		 * all the operation automatically after system go into low power mode.
> +		 */
> +		return 0;
>  	}
> =20
>  	return flexcan_low_power_enter_ack(priv);
> @@ -551,7 +565,7 @@ static inline int flexcan_exit_stop_mode(struct flexc=
an_priv *priv)
>  		ret =3D flexcan_stop_mode_enable_scfw(priv, false);
>  		if (ret < 0)
>  			return ret;
> -	} else {
> +	} else if (priv->devtype_data.quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_GP=
R) {
>  		regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
>  				   1 << priv->stm.req_bit, 0);
>  	}
> @@ -560,6 +574,12 @@ static inline int flexcan_exit_stop_mode(struct flex=
can_priv *priv)
>  	reg_mcr &=3D ~FLEXCAN_MCR_SLF_WAK;
>  	priv->write(reg_mcr, &regs->mcr);
> =20
> +	/* For the auto stop mode, hardware will exist stop mode
                                                 ^^^^^
                                                 exit?

No need to resend.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--yhn2qnplluft6atz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmN/gjoACgkQrX5LkNig
011sXQf+MCoRIn0fsXC1+erxc4xdoDvO1PaSDE7V5RT0iSFDX8tNKFew3uSnzPTi
SPTuiIiEGy0SsJB108lLBxw+sS7x4+3ybV10clPL9Q4jEOgTJPthr2Iz8g8YQem6
17gmmNv0kVyVSwGw1frreiuaxQ2fOaccMrr0Cgns2K8CzFpnyxQkIHDPM75L9IGw
W6uOh1lFWYwW7W3RqZWruGb2QtBMVJFjKc0MTJO8Mqfiuo+EXAogIjbEAdKpJM9r
9zHXgJrrN8m9xPwXF3zBYd1SnY/c0Fzy5xvVllbjVGKFIPfG2F5CCCLc6B/fYgml
Cucg2bGPSmkvT9RDnHppJ7qyGfBScQ==
=31C3
-----END PGP SIGNATURE-----

--yhn2qnplluft6atz--

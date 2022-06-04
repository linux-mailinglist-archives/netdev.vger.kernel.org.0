Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261BE53D684
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 13:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbiFDLZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 07:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235270AbiFDLZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 07:25:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145492CC9D
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 04:25:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nxRuV-0000q2-N8; Sat, 04 Jun 2022 13:25:39 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C878A8C2E0;
        Sat,  4 Jun 2022 11:25:38 +0000 (UTC)
Date:   Sat, 4 Jun 2022 13:25:38 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 3/7] can: bittiming: move bittiming calculation
 functions to calc_bittiming.c
Message-ID: <20220604112538.p4hlzgqnodyvftsj@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-4-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fmzaihovq3ararpb"
Content-Disposition: inline
In-Reply-To: <20220603102848.17907-4-mailhol.vincent@wanadoo.fr>
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


--fmzaihovq3ararpb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.06.2022 19:28:44, Vincent Mailhol wrote:
> The canonical way to select or deselect an object during compilation
> is to use this pattern in the relevant Makefile:
>=20
> bar-$(CONFIG_FOO) :=3D foo.o
>=20
> bittiming.c instead uses some #ifdef CONFIG_CAN_CALC_BITTIMG.
>=20
> Create a new file named calc_bittiming.c with all the functions which
> are conditionally compiled with CONFIG_CAN_CALC_BITTIMG and modify the
> Makefile according to above pattern.
>=20
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>  drivers/net/can/Kconfig              |   4 +
>  drivers/net/can/dev/Makefile         |   2 +
>  drivers/net/can/dev/bittiming.c      | 197 --------------------------
>  drivers/net/can/dev/calc_bittiming.c | 202 +++++++++++++++++++++++++++
>  4 files changed, 208 insertions(+), 197 deletions(-)
>  create mode 100644 drivers/net/can/dev/calc_bittiming.c
>=20
> diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> index b1e47f6c5586..8f3b97aea638 100644
> --- a/drivers/net/can/Kconfig
> +++ b/drivers/net/can/Kconfig
> @@ -96,6 +96,10 @@ config CAN_CALC_BITTIMING
>  	  source clock frequencies. Disabling saves some space, but then the
>  	  bit-timing parameters must be specified directly using the Netlink
>  	  arguments "tq", "prop_seg", "phase_seg1", "phase_seg2" and "sjw".
> +
> +	  The additional features selected by this option will be added to the
> +	  can-dev module.
> +
>  	  If unsure, say Y.
> =20
>  config CAN_AT91
> diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
> index 919f87e36eed..b8a55b1d90cd 100644
> --- a/drivers/net/can/dev/Makefile
> +++ b/drivers/net/can/dev/Makefile
> @@ -9,3 +9,5 @@ can-dev-$(CONFIG_CAN_NETLINK) +=3D dev.o
>  can-dev-$(CONFIG_CAN_NETLINK) +=3D length.o
>  can-dev-$(CONFIG_CAN_NETLINK) +=3D netlink.o
>  can-dev-$(CONFIG_CAN_NETLINK) +=3D rx-offload.o
> +
> +can-dev-$(CONFIG_CAN_CALC_BITTIMING) +=3D calc_bittiming.o

Nitpick:
Can we keep this list sorted?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--fmzaihovq3ararpb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKbQS8ACgkQrX5LkNig
010fHAf9EqWC7V8zYRf8tGNLSdm/oEsh1naw8BqOxpmbMdPMxbOaSe7WN5BYJjAc
lRtXQVh0Sog3DkmHNso25zttV5HRJ/iZ139Mjko0TkQaJ2wWzbTIuQ17iBN1TkIP
vidEwAwgQlPI8PiKVegZWiekwCK/XGxDgJZVZAE+7W+Ovg88eHXZwtT5o+Idhcll
g2hH8VY5Um6sBmg08jF4FuJWReRJmTQ6fXdUeQHbs5nkrMYEL8ojIgmmPMneNbac
tBsGAU/HXIq8wY6no2qt7iPr6efZ0SEhh8T9SgdWkI32T1cGIVMIf8R0GbBFlmS8
x4goNIHA4MPFoGcZrbAj1DYZ2SFR/Q==
=fWUj
-----END PGP SIGNATURE-----

--fmzaihovq3ararpb--

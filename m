Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE15D644914
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbiLFQVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbiLFQUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:20:43 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC81E89
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:20:17 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p2afz-0002op-Fm; Tue, 06 Dec 2022 17:20:11 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:5a7d:17af:a898:e292])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B9BBB137DC1;
        Tue,  6 Dec 2022 16:20:09 +0000 (UTC)
Date:   Tue, 6 Dec 2022 17:20:01 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/11] can: tcan4x5x: Specify separate read/write
 ranges
Message-ID: <20221206162001.3cgtod46h5d5j7fx@pengutronix.de>
References: <20221206115728.1056014-1-msp@baylibre.com>
 <20221206115728.1056014-12-msp@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vhdmre27vzom3pem"
Content-Disposition: inline
In-Reply-To: <20221206115728.1056014-12-msp@baylibre.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vhdmre27vzom3pem
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06.12.2022 12:57:28, Markus Schneider-Pargmann wrote:
> Specify exactly which registers are read/writeable in the chip. This
> is supposed to help detect any violations in the future.
>=20
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> ---
>  drivers/net/can/m_can/tcan4x5x-regmap.c | 43 +++++++++++++++++++++----
>  1 file changed, 37 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_=
can/tcan4x5x-regmap.c
> index 33aed989e42a..2b218ce04e9f 100644
> --- a/drivers/net/can/m_can/tcan4x5x-regmap.c
> +++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
> @@ -90,16 +90,47 @@ static int tcan4x5x_regmap_read(void *context,
>  	return 0;
>  }
> =20
> -static const struct regmap_range tcan4x5x_reg_table_yes_range[] =3D {
> +static const struct regmap_range tcan4x5x_reg_table_wr_range[] =3D {
> +	/* Device ID and SPI Registers */
> +	regmap_reg_range(0x000c, 0x0010),

According to "Table 8-8" 0xc is RO, but in "8.6.1.4 Status (address =3D
h000C) [reset =3D h0000000U]" it clearly says it has write 1 to clear bits
:/.

> +	/* Device configuration registers and Interrupt Flags*/
> +	regmap_reg_range(0x0800, 0x080c),
> +	regmap_reg_range(0x0814, 0x0814),

0x814 is marked as reserved in "SLLSEZ5D =E2=80=93 JANUARY 2018 =E2=80=93 R=
EVISED JUNE
2022"?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vhdmre27vzom3pem
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOPa60ACgkQrX5LkNig
0112+Af7BOqOSxIaDypn/eWvKpPXDEoWBJDRw//U96c0zVlAJIAbGwHFlK07FXrJ
HERKtcMv6hvZV8qzrUyLKN7yM7APgHcCLZyhHKNLyubvODjMfDhhda5BvhEik6SK
eS2vYXnifaGtzDvgekNO17wQGxZ7WI1dm8XxjJ2+SXWXJ3lMHtp+F0zrBZW1heTr
P8Vd+RyvfMJzB1NHBFBLAaLSmCzJUCzhRhDyhiBgZ5Wc0rdVsSLJ7wGhbe6/yi4i
O8/XV+iUYWUUxryL/AzbdVlVvA5tA/fTGBw0n2LMEVNcS2u8Evead947Er4JoQD4
cuLUlD6on7FIGKdmV+c+wcEP4fSaNA==
=jsBQ
-----END PGP SIGNATURE-----

--vhdmre27vzom3pem--

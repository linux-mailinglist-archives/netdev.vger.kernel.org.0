Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D7548CB2D
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356413AbiALSoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356414AbiALSnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:43:53 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6526C061751
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:43:52 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n7iau-0002qg-OU; Wed, 12 Jan 2022 19:43:36 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3FC4116C67;
        Wed, 12 Jan 2022 18:43:31 +0000 (UTC)
Date:   Wed, 12 Jan 2022 19:43:27 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, geert@linux-m68k.org,
        kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v2 2/5] can: rcar_canfd: Add support for r8a779a0 SoC
Message-ID: <20220112184327.f7fwzgqvle23gfzv@pengutronix.de>
References: <20220111162231.10390-1-uli+renesas@fpond.eu>
 <20220111162231.10390-3-uli+renesas@fpond.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="245qoku3mnz6cen7"
Content-Disposition: inline
In-Reply-To: <20220111162231.10390-3-uli+renesas@fpond.eu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--245qoku3mnz6cen7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11.01.2022 17:22:28, Ulrich Hecht wrote:
> Adds support for the CANFD IP variant in the V3U SoC.
>=20
> Differences to controllers in other SoCs are limited to an increase in
> the number of channels from two to eight, an absence of dedicated
> registers for "classic" CAN mode, and a number of differences in magic
> numbers (register offsets and layouts).
>=20
> Inspired by BSP patch by Kazuya Mizuguchi.
>=20
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
> ---
>  drivers/net/can/rcar/rcar_canfd.c | 231 ++++++++++++++++++++----------
>  1 file changed, 153 insertions(+), 78 deletions(-)
>=20
> diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rca=
r_canfd.c
> index ff9d0f5ae0dd..b1c9870d2a82 100644
> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -44,10 +44,13 @@
>  enum rcanfd_chip_id {
>  	RENESAS_RCAR_GEN3 =3D 0,
>  	RENESAS_RZG2L,
> +	RENESAS_R8A779A0,
>  };
> =20
>  /* Global register bits */
> =20
> +#define IS_V3U (gpriv->chip_id =3D=3D RENESAS_R8A779A0)

I really don't like this macro, as it silently relies on gpriv....and
I really don't like this use of this macro in the other macros that lead
to 2 or even 3 ternary operators hiding inside them. Is there any chance
to change this?

Please add at least the gpriv argument to IS_V3U().....

[...]

> -	of_child =3D of_get_child_by_name(pdev->dev.of_node, "channel1");
> -	if (of_child && of_device_is_available(of_child))
> -		channels_mask |=3D BIT(1);	/* Channel 1 */
> +	strcpy(name, "channelX");

please use strlcpy()

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--245qoku3mnz6cen7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHfIU0ACgkQqclaivrt
76m+ZAgAhsdBWGeR/pk4xB23D97lrg6gBfBhg50YD0P6uiwmr5F6LZTA3MrfxXQ2
yRXaZ7zh7Bb0FWHlqCCjFWF1QCchtlVXkP2S4+Y1UpRF4Ppo4VduiQtEx/NvFHKN
/chjFzn6lgQjvEymMzypjDo1BcfpdZUI1buvxTcuxapLcx9wAr3ZgBLgY8DnPm5x
FhCyHBGTvpBWI2fvRwy7twrALoUhwDES3zA7aAd330F2TCi+BJGIp1uZdvEDk28v
KWlA3huprGCKCtSse2KWOMrTPp85KlDYOPiTBRZIDvM+i5wt4hQTAub8xYDP4Wjz
vo7NvdH6879oVvyJ1JnR37ZClFSahA==
=QkLU
-----END PGP SIGNATURE-----

--245qoku3mnz6cen7--

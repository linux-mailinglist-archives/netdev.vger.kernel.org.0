Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2A73D0D97
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240376AbhGUKqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbhGUJmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 05:42:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEF0C061574
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 03:22:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m69NC-0004Ky-C4; Wed, 21 Jul 2021 12:22:42 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:1b:ece1:995c:23c1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 27302653A53;
        Wed, 21 Jul 2021 10:22:40 +0000 (UTC)
Date:   Wed, 21 Jul 2021 12:22:39 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: at803x: simplify custom phy id
 matching
Message-ID: <20210721102239.saflmexhqhqtibxt@pengutronix.de>
References: <E1m5psb-0003qh-VP@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="my7ie3xpbcnma7zf"
Content-Disposition: inline
In-Reply-To: <E1m5psb-0003qh-VP@rmk-PC.armlinux.org.uk>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--my7ie3xpbcnma7zf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20.07.2021 14:33:49, Russell King wrote:
> The at803x driver contains a function, at803x_match_phy_id(), which
> tests whether the PHY ID matches the value passed, comparing phy_id
> with phydev->phy_id and testing all bits that in the driver's mask.
>=20
> This is the same test that is used to match the driver, with phy_id
> replaced with the driver specified ID, phydev->drv->phy_id.
>=20
> Hence, we already know the value of the bits being tested if we look
> at phydev->drv->phy_id directly, and we do not require a complicated
> test to check them. Test directly against phydev->drv->phy_id instead.
>=20
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>
> ---
>  drivers/net/phy/at803x.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 5d62b85a4024..0790ffcd3db6 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -532,12 +532,6 @@ static int at8031_register_regulators(struct phy_dev=
ice *phydev)
>  	return 0;
>  }
> =20
> -static bool at803x_match_phy_id(struct phy_device *phydev, u32 phy_id)
> -{
> -	return (phydev->phy_id & phydev->drv->phy_id_mask)
> -		=3D=3D (phy_id & phydev->drv->phy_id_mask);
> -}
> -

Seems you've missed a conversion:

| net/phy/at803x.c: In function =E2=80=98at803x_get_features=E2=80=99:     =
               =20
| net/phy/at803x.c:706:7: error: implicit declaration of function =E2=80=98=
at803x_match_phy_id=E2=80=99 [-Werror=3Dimplicit-function-declaration]     =
                                                                      =20
|   706 |  if (!at803x_match_phy_id(phydev, ATH8031_PHY_ID))
|       |       ^~~~~~~~~~~~~~~~~~~

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--my7ie3xpbcnma7zf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmD39WwACgkQqclaivrt
76lGRgf+JguC68Prqecj9cz7Z90HRKue7Dd+ngfwZ3JglF5W2+2HsiGtfLeMSTu8
M9jOZ4fTiHcd9YHrVHbAeF8Fsj7i5QK4NKeUUxQP55LDztRI67a10mCwEEQ3hQCg
iqPpQxJKGK1KfmUEO8kTuB0cVEoM7t4bzy2MIloLNTbOpjlQITXRIPsiIYDGGkjj
Jw1aE3NBDY+1HdI79ymMiwebxqPRU+BAngiNweqKu19Ha5QGSLfj1yoUHo3/I/N+
TwQc+D86q6A5Hj+5Tg0EaL2Xm0eSB5NNnq2rziIhHLBR9b6e8h0LgU5GHY65Ybxy
zS57wQ7Ni1Ax3wLwY9NarGcmXY//oA==
=RpiR
-----END PGP SIGNATURE-----

--my7ie3xpbcnma7zf--

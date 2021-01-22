Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255E0300B7D
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbhAVSiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728457AbhAVOUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 09:20:48 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880D3C0613D6
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 06:19:53 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l2xHw-0005nm-AN; Fri, 22 Jan 2021 15:19:48 +0100
Received: from hardanger.blackshift.org (unknown [IPv6:2a03:f580:87bc:d400:aed1:e241:8b32:9cc0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 144315CA9B9;
        Fri, 22 Jan 2021 14:19:47 +0000 (UTC)
Date:   Fri, 22 Jan 2021 15:19:46 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Woojung.Huh@microchip.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        kernel@pengutronix.de
Subject: Re: [PATCH 2/2 net] lan78xx: workaround of forced 100 Full/Half
 duplex mode error
Message-ID: <20210122141946.3bta67avfu4xmuv4@hardanger.blackshift.org>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="npbz4kmb2deypzhb"
Content-Disposition: inline
In-Reply-To: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--npbz4kmb2deypzhb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 25, 2016 at 10:22:36PM +0000, Woojung.Huh@microchip.com wrote:
> From: Woojung Huh <woojung.huh@microchip.com>
>=20
> At forced 100 Full & Half duplex mode, chip may fail to set mode correctly
> when cable is switched between long(~50+m) and short one.
> As workaround, set to 10 before setting to 100 at forced 100 F/H mode.

Sorry to picking up this old patch. We're using a LAN7801T, with an
external TI dp83tc811 PHY...

> Signed-off-by: Woojung Huh <woojung.huh@microchip.com>
> ---
>  drivers/net/usb/lan78xx.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> index 0460b81..f64778a 100644
> --- a/drivers/net/usb/lan78xx.c
> +++ b/drivers/net/usb/lan78xx.c
> @@ -1804,7 +1804,34 @@ static void lan78xx_remove_mdio(struct lan78xx_net=
 *dev)
> =20
>  static void lan78xx_link_status_change(struct net_device *net)
>  {
> -	/* nothing to do */
> +	struct phy_device *phydev =3D net->phydev;
> +	int ret, temp;
> +
> +	/* At forced 100 F/H mode, chip may fail to set mode correctly
> +	 * when cable is switched between long(~50+m) and short one.
> +	 * As workaround, set to 10 before setting to 100
> +	 * at forced 100 F/H mode.
> +	 */
> +	if (!phydev->autoneg && (phydev->speed =3D=3D 100)) {
> +		/* disable phy interrupt */
> +		temp =3D phy_read(phydev, LAN88XX_INT_MASK);
> +		temp &=3D ~LAN88XX_INT_MASK_MDINTPIN_EN_;
> +		ret =3D phy_write(phydev, LAN88XX_INT_MASK, temp);

It seems here you are assuming a microchip PHY attached, where the
INT_MASK register is at 0x19. In think 0x19 is a reserved
register. You better not write to it.

Are there some microchips components where the MAC and the PHY are in
one chip? Is that combination identifiable by the USB-ID?

> +		temp =3D phy_read(phydev, MII_BMCR);
> +		temp &=3D ~(BMCR_SPEED100 | BMCR_SPEED1000);
> +		phy_write(phydev, MII_BMCR, temp); /* set to 10 first */
> +		temp |=3D BMCR_SPEED100;
> +		phy_write(phydev, MII_BMCR, temp); /* set to 100 later */
> +
> +		/* clear pending interrupt generated while workaround */
> +		temp =3D phy_read(phydev, LAN88XX_INT_STS);
> +
> +		/* enable phy interrupt back */
> +		temp =3D phy_read(phydev, LAN88XX_INT_MASK);
> +		temp |=3D LAN88XX_INT_MASK_MDINTPIN_EN_;
> +		ret =3D phy_write(phydev, LAN88XX_INT_MASK, temp);
> +	}
>  }

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--npbz4kmb2deypzhb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmAK3v8ACgkQqclaivrt
76m8jAf+MohCdWf8Nzf7n4bW2BaXBruIzmrenw6Esx/7tWjZpAs19yczWsDk+o9g
L3bTGa4sEXY1DtAnM8UaRzeQyuqcJtw3u4kmhGY+ow7C2uEvwvkzoPTOCoroUgyD
7IuknHX65B2LxlC/GVMFXWkyddIAcvto5hHeyhA5DWGwF1IUnHTYFuG4RM+aMUC+
f35b31IbzHx7ccGnOoiJNX2kVHB5yDComye1ifq/gmDbyFwlUkzw8JC+sRNzb62m
J8tvAYGw0TE69Qy4tmBrTBrw7uWXQsViE+UC95sf2DyLqngusft73ufhoIkpE4kO
Md7T2m/CQpSVASLpb1U8tey/TO8ugQ==
=0h0k
-----END PGP SIGNATURE-----

--npbz4kmb2deypzhb--

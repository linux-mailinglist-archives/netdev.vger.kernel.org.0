Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8FE3181954
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 14:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbgCKNMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 09:12:20 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53383 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729414AbgCKNMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 09:12:20 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jC19l-0003hm-Bn; Wed, 11 Mar 2020 14:12:17 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jC19i-0003mA-Pb; Wed, 11 Mar 2020 14:12:14 +0100
Date:   Wed, 11 Mar 2020 14:12:14 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 1/2] net: phy: tja11xx: add TJA1102 support
Message-ID: <20200311131214.xfi6oikcehpalr5c@pengutronix.de>
References: <20200309074044.21399-1-o.rempel@pengutronix.de>
 <20200309074044.21399-2-o.rempel@pengutronix.de>
 <ec2361a9-1b7b-b939-a2a2-fac4d1146731@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n5skeuc4kn6dc42y"
Content-Disposition: inline
In-Reply-To: <ec2361a9-1b7b-b939-a2a2-fac4d1146731@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:10:32 up 117 days,  4:29, 143 users,  load average: 0.01, 0.06,
 0.04
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--n5skeuc4kn6dc42y
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 09, 2020 at 08:45:50PM +0100, Heiner Kallweit wrote:
> On 09.03.2020 08:40, Oleksij Rempel wrote:
> > TJA1102 is an dual T1 PHY chip. Both PHYs are separately addressable.
> > PHY 0 can be identified by PHY ID. PHY 1 has no PHY ID and can be
> > configured in device tree by setting compatible =3D "ethernet-phy-id018=
0.dc81".
> >=20
> > PHY 1 has less supported registers and functionality. For current driver
> > it will affect only the HWMON support.
> >=20
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/phy/nxp-tja11xx.c | 102 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 102 insertions(+)
> >=20
> > diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11x=
x.c
> > index b705d0bd798b..f79c9aa051ed 100644
> > --- a/drivers/net/phy/nxp-tja11xx.c
> > +++ b/drivers/net/phy/nxp-tja11xx.c
> > @@ -15,6 +15,7 @@
> >  #define PHY_ID_MASK			0xfffffff0
> >  #define PHY_ID_TJA1100			0x0180dc40
> >  #define PHY_ID_TJA1101			0x0180dd00
> > +#define PHY_ID_TJA1102			0x0180dc80
> > =20
> >  #define MII_ECTRL			17
> >  #define MII_ECTRL_LINK_CONTROL		BIT(15)
> > @@ -40,6 +41,10 @@
> >  #define MII_INTSRC_TEMP_ERR		BIT(1)
> >  #define MII_INTSRC_UV_ERR		BIT(3)
> > =20
> > +#define MII_INTEN			22
> > +#define MII_INTEN_LINK_FAIL		BIT(10)
> > +#define MII_INTEN_LINK_UP		BIT(9)
> > +
> >  #define MII_COMMSTAT			23
> >  #define MII_COMMSTAT_LINK_UP		BIT(15)
> > =20
> > @@ -190,6 +195,7 @@ static int tja11xx_config_init(struct phy_device *p=
hydev)
> >  			return ret;
> >  		break;
> >  	case PHY_ID_TJA1101:
> > +	case PHY_ID_TJA1102:
> >  		ret =3D phy_set_bits(phydev, MII_COMMCFG, MII_COMMCFG_AUTO_OP);
> >  		if (ret)
> >  			return ret;
> > @@ -354,6 +360,66 @@ static int tja11xx_probe(struct phy_device *phydev)
> >  	return PTR_ERR_OR_ZERO(priv->hwmon_dev);
> >  }
> > =20
> > +static int tja1102_match_phy_device(struct phy_device *phydev, bool po=
rt0)
> > +{
> > +	int ret;
> > +
> > +	if ((phydev->phy_id & PHY_ID_MASK) !=3D PHY_ID_TJA1102)
>=20
> For port 1 you rely on DT forcing the appropriate phy_id
> (else it would be 0 and port 1 wouldn't be matched).
> This is worth a describing comment.

There is a second patch which will do it automatically, no need to force
the PHY ID in the devicetree.

> > +		return 0;
> > +
> > +	ret =3D phy_read(phydev, MII_PHYSID2);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	/* TJA1102 Port 1 has phyid 0 and doesn't support temperature
> > +	 * and undervoltage alarms.
> > +	 */
> > +	if (port0)
> > +		return ret ? 1 : 0;
> > +
> > +	return !ret;
> > +}
> > +
> > +static int tja1102_p0_match_phy_device(struct phy_device *phydev)
> > +{
> > +	return tja1102_match_phy_device(phydev, true);
> > +}
> > +
> > +static int tja1102_p1_match_phy_device(struct phy_device *phydev)
> > +{
> > +	return tja1102_match_phy_device(phydev, false);
> > +}
> > +
> > +static int tja11xx_ack_interrupt(struct phy_device *phydev)
> > +{
> > +	int ret;
> > +
> > +	ret =3D phy_read(phydev, MII_INTSRC);
> > +
> > +	return (ret < 0) ? ret : 0;
> > +}
> > +
> > +static int tja11xx_config_intr(struct phy_device *phydev)
> > +{
> > +	int value;
> > +	int ret;
> > +
> > +	value =3D phy_read(phydev, MII_INTEN);
> > +	if (value < 0)
> > +		return value;
> > +
> > +	if (phydev->interrupts =3D=3D PHY_INTERRUPT_ENABLED) {
> > +		value |=3D MII_INTEN_LINK_FAIL;
> > +		value |=3D MII_INTEN_LINK_UP;
> > +
>=20
> This may leave unwanted interrupt sources active. Why not
> simply setting a fixed value like in the else clause?

done

> > +		ret =3D phy_write(phydev, MII_INTEN, value);
> > +	}
> > +	else
>=20
> Kernel style:
> Closing brace and else belong to one line. And the else clause
> needs braces too. checkpatch.pl should complain here.

done

> > +		ret =3D phy_write(phydev, MII_INTEN, 0);
> > +
> > +	return ret;
> > +}
> > +
> >  static struct phy_driver tja11xx_driver[] =3D {
> >  	{
> >  		PHY_ID_MATCH_MODEL(PHY_ID_TJA1100),
> > @@ -385,6 +451,41 @@ static struct phy_driver tja11xx_driver[] =3D {
> >  		.get_sset_count =3D tja11xx_get_sset_count,
> >  		.get_strings	=3D tja11xx_get_strings,
> >  		.get_stats	=3D tja11xx_get_stats,
> > +	}, {
> > +		.name		=3D "NXP TJA1102 Port 0",
> > +		.features       =3D PHY_BASIC_T1_FEATURES,
> > +		.probe		=3D tja11xx_probe,
> > +		.soft_reset	=3D tja11xx_soft_reset,
> > +		.config_init	=3D tja11xx_config_init,
> > +		.read_status	=3D tja11xx_read_status,
> > +		.match_phy_device =3D tja1102_p0_match_phy_device,
> > +		.suspend	=3D genphy_suspend,
> > +		.resume		=3D genphy_resume,
> > +		.set_loopback   =3D genphy_loopback,
> > +		/* Statistics */
> > +		.get_sset_count =3D tja11xx_get_sset_count,
> > +		.get_strings	=3D tja11xx_get_strings,
> > +		.get_stats	=3D tja11xx_get_stats,
> > +		.ack_interrupt	=3D tja11xx_ack_interrupt,
> > +		.config_intr	=3D tja11xx_config_intr,
> > +
> > +	}, {
> > +		.name		=3D "NXP TJA1102 Port 1",
> > +		.features       =3D PHY_BASIC_T1_FEATURES,
> > +		/* currently no probe for Port 1 is need */
> > +		.soft_reset	=3D tja11xx_soft_reset,
> > +		.config_init	=3D tja11xx_config_init,
> > +		.read_status	=3D tja11xx_read_status,
> > +		.match_phy_device =3D tja1102_p1_match_phy_device,
> > +		.suspend	=3D genphy_suspend,
> > +		.resume		=3D genphy_resume,
> > +		.set_loopback   =3D genphy_loopback,
> > +		/* Statistics */
> > +		.get_sset_count =3D tja11xx_get_sset_count,
> > +		.get_strings	=3D tja11xx_get_strings,
> > +		.get_stats	=3D tja11xx_get_stats,
> > +		.ack_interrupt	=3D tja11xx_ack_interrupt,
> > +		.config_intr	=3D tja11xx_config_intr,
> >  	}
> >  };
> > =20
> > @@ -393,6 +494,7 @@ module_phy_driver(tja11xx_driver);
> >  static struct mdio_device_id __maybe_unused tja11xx_tbl[] =3D {
> >  	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA1100) },
> >  	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA1101) },
> > +	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA1102) },
> >  	{ }
> >  };
> > =20
> >=20
>=20
>=20
>=20

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--n5skeuc4kn6dc42y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl5o46oACgkQ4omh9DUa
UbM4IA/6A4PdHJvqDR3QZH0g2wH2w1fSuRVWSoKlCYhD3Mw6uP3A/gAAs/GuT8Uv
Nf+7+dFt3RJ0E8tzJDOkrz5fAUjdFSh1uqi6YSQWtfWJevBOX6MzlDEF3FxF4apk
QZ7DsRi5NQa3JP1l95nNRxs0b6tb6gQHtFud8Sro4k3V7H5huGrdCw3eYMIjOzf2
dnuCCUEMHffzCvtdp22pbPKB3BuiqyqWOHSojCIbxJFmCrOSD+oqfrhJRcutZK4m
ZiEkwcJo908bf4gWfRKIGsFMc7OrJOyvYt9WdtHHoFiIatkszkiCzQp0MASz+eAh
Xj4Da897Q0uw2hmtb7v94ldtVxYUTgv3fX9OpwiBhvlh7GA9jlxnufLXpBsVUp00
xSbk/uqXW8/Q6dVvnvKB2L6kqFCwIVVqAhH4D77uxaFLwkgMnMBCFpK2rvYAPyoT
MXtwqMLlhxfu9CPhKmaZ9gf8uGpJ49GTXCA0GV3zDsxcPgJiEPGXqqXvvxQUETVq
AjBfyGjpLP5GsuymCWDd2i1139hl1veQcGZhAQkUpEqi2P9STxt/lJft8wb/TEUU
HXHGvpXBl1jq8He8pg8etkkkqPFUZWYCGbkh1RvFtBE6wyjB2qqCcYnepIma0qAS
vxPhKERIB+u1EpdENjYlMar/5gB7OhFLU7rqHRgJMDyZHQkVz8I=
=g1xf
-----END PGP SIGNATURE-----

--n5skeuc4kn6dc42y--

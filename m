Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7817C1AA280
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 14:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502626AbgDOM4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 08:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2441351AbgDOM4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 08:56:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9B9C061A0E
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 05:56:21 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jOhaN-0005JG-O7; Wed, 15 Apr 2020 14:56:11 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jOhaM-0004gK-PK; Wed, 15 Apr 2020 14:56:10 +0200
Date:   Wed, 15 Apr 2020 14:56:10 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v1] net: phy: tja11xx: add support for master-slave
 configuration
Message-ID: <20200415125610.mvvh3w6wtmeyhoxm@pengutronix.de>
References: <20200415123447.29769-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7x4bdxuiyzqo4jrq"
Content-Disposition: inline
In-Reply-To: <20200415123447.29769-1-o.rempel@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:35:06 up 152 days,  3:53, 170 users,  load average: 0.07, 0.04,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7x4bdxuiyzqo4jrq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This is the followup patch to the:
ethtool: provide UAPI for PHY master/slave configuration.

On Wed, Apr 15, 2020 at 02:34:47PM +0200, Oleksij Rempel wrote:
> The TJA11xx PHYs have a vendor specific Master/Slave configuration bit,
> which is not compatible with IEEE 803.2-2018 spec for 100Base-T1
> devices. So, provide a custom config_ange call back to solve this
> problem.
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/nxp-tja11xx.c | 39 +++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
>=20
> diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
> index 2bde9386baf1f..0042ee453cbd4 100644
> --- a/drivers/net/phy/nxp-tja11xx.c
> +++ b/drivers/net/phy/nxp-tja11xx.c
> @@ -30,6 +30,7 @@
>  #define MII_ECTRL_WAKE_REQUEST		BIT(0)
> =20
>  #define MII_CFG1			18
> +#define MII_CFG1_MASTER_SLAVE		BIT(15)
>  #define MII_CFG1_AUTO_OP		BIT(14)
>  #define MII_CFG1_SLEEP_CONFIRM		BIT(6)
>  #define MII_CFG1_LED_MODE_MASK		GENMASK(5, 4)
> @@ -177,6 +178,31 @@ static int tja11xx_soft_reset(struct phy_device *phy=
dev)
>  	return genphy_soft_reset(phydev);
>  }
> =20
> +static int tja11xx_config_aneg(struct phy_device *phydev)
> +{
> +	u16 ctl =3D 0;
> +	int ret;
> +
> +	switch (phydev->master_slave) {
> +	case PORT_MODE_MASTER:
> +		ctl |=3D MII_CFG1_MASTER_SLAVE;
> +		break;
> +	case PORT_MODE_SLAVE:
> +		break;
> +	case PORT_MODE_UNKNOWN:
> +		return 0;
> +	default:
> +		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
> +		return -ENOTSUPP;
> +	}
> +
> +	ret =3D phy_modify_changed(phydev, MII_CFG1, MII_CFG1_MASTER_SLAVE, ctl=
);
> +	if (ret < 0)
> +		return ret;
> +
> +	return __genphy_config_aneg(phydev, ret);
> +}
> +
>  static int tja11xx_config_init(struct phy_device *phydev)
>  {
>  	int ret;
> @@ -245,6 +271,15 @@ static int tja11xx_read_status(struct phy_device *ph=
ydev)
> =20
>  		if (!(ret & MII_COMMSTAT_LINK_UP))
>  			phydev->link =3D 0;
> +
> +		ret =3D phy_read(phydev, MII_CFG1);
> +		if (ret < 0)
> +			return ret;
> +
> +		if (ret & MII_CFG1_MASTER_SLAVE)
> +			phydev->master_slave =3D PORT_MODE_MASTER;
> +		else
> +			phydev->master_slave =3D PORT_MODE_SLAVE;
>  	}
> =20
>  	return 0;
> @@ -514,6 +549,7 @@ static struct phy_driver tja11xx_driver[] =3D {
>  		.features       =3D PHY_BASIC_T1_FEATURES,
>  		.probe		=3D tja11xx_probe,
>  		.soft_reset	=3D tja11xx_soft_reset,
> +		.config_aneg	=3D tja11xx_config_aneg,
>  		.config_init	=3D tja11xx_config_init,
>  		.read_status	=3D tja11xx_read_status,
>  		.suspend	=3D genphy_suspend,
> @@ -529,6 +565,7 @@ static struct phy_driver tja11xx_driver[] =3D {
>  		.features       =3D PHY_BASIC_T1_FEATURES,
>  		.probe		=3D tja11xx_probe,
>  		.soft_reset	=3D tja11xx_soft_reset,
> +		.config_aneg	=3D tja11xx_config_aneg,
>  		.config_init	=3D tja11xx_config_init,
>  		.read_status	=3D tja11xx_read_status,
>  		.suspend	=3D genphy_suspend,
> @@ -543,6 +580,7 @@ static struct phy_driver tja11xx_driver[] =3D {
>  		.features       =3D PHY_BASIC_T1_FEATURES,
>  		.probe		=3D tja1102_p0_probe,
>  		.soft_reset	=3D tja11xx_soft_reset,
> +		.config_aneg	=3D tja11xx_config_aneg,
>  		.config_init	=3D tja11xx_config_init,
>  		.read_status	=3D tja11xx_read_status,
>  		.match_phy_device =3D tja1102_p0_match_phy_device,
> @@ -561,6 +599,7 @@ static struct phy_driver tja11xx_driver[] =3D {
>  		.features       =3D PHY_BASIC_T1_FEATURES,
>  		/* currently no probe for Port 1 is need */
>  		.soft_reset	=3D tja11xx_soft_reset,
> +		.config_aneg	=3D tja11xx_config_aneg,
>  		.config_init	=3D tja11xx_config_init,
>  		.read_status	=3D tja11xx_read_status,
>  		.match_phy_device =3D tja1102_p1_match_phy_device,
> --=20
> 2.26.0.rc2
>=20
>=20

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--7x4bdxuiyzqo4jrq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6XBGYACgkQ4omh9DUa
UbNzUA//UwFEBtzEZ+9QtuKnPlYbe4AVhh8p3NmgLDK/R14V3Qz/igkgEEjrS+Dt
p5pLDegx/zBc1xeTy7XFDkRlB7tEb680VcOE/rlnfYSzZTe5GNVRabXcmrX49U60
QtHCgw7Eox5VX9jfVY0ppyFN0g1DsxWVhSVYyx0i4+D9fky/h2zT1fiqW+LDfCbc
dbDAppPRtLhB9gCRYFd+VfQTsXjt0qB8p83vWi1MesL1rQOgFjcPllPN2E26LlQJ
MXrN5SbgVxL4TDgo7qksJoD+o+qk9UA9RKH+bGr1uvbGEl/8YnACJWtvHJbpqZ6K
K1ChEx3e3hgEw3lsVUVjv0INAp2WWw7o8w5DaX41MJl3CWfxuYYegDz9Qu1L32PX
zQZfqAgQg/H19K8O3PhnCfl09kpqUfqWdwiibp7MT89y+khwkyCYUjRVTlROrWyp
OLdTTiDmlBqjA6e+NS1EVqJTfRk44Vf1JyMkAzNI03nDDiYSTa8p8o7rm2d2W4kB
YBFwxM7xNFpoTkA6QNkwN+SdxInujnQfhfkzMRcE6FenGovvoONz/DY8NAra6iMQ
xMC7KzYrNUEY065PTx6t6+QdHpBQ5h1KurS2cf8Z6ZZFbvR7wgwIVFy5VhcTzXZK
7iG3FffqOyeNKLAr/Scmu8Uw0nZ/Dgb93Sv9EXJcxZa9Av8Gkks=
=zqwc
-----END PGP SIGNATURE-----

--7x4bdxuiyzqo4jrq--

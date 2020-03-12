Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E82D6182E3B
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 11:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgCLKuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 06:50:07 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:48817 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbgCLKuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 06:50:06 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jCLPb-000635-V3; Thu, 12 Mar 2020 11:49:59 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jCLPY-0004Fe-JQ; Thu, 12 Mar 2020 11:49:56 +0100
Date:   Thu, 12 Mar 2020 11:49:56 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 3/4] net: mdio: of: export part of
 of_mdiobus_register_phy()
Message-ID: <20200312104956.no65skuzj7ivgw5t@pengutronix.de>
References: <20200312063419.23615-1-o.rempel@pengutronix.de>
 <20200312063419.23615-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dw7t46st34ahcgpo"
Content-Disposition: inline
In-Reply-To: <20200312063419.23615-4-o.rempel@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:48:22 up 118 days,  2:06, 135 users,  load average: 0.02, 0.11,
 0.19
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dw7t46st34ahcgpo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2020 at 07:34:18AM +0100, Oleksij Rempel wrote:
> This function will be needed in tja11xx driver for secondary PHY
> support.
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/of/of_mdio.c    | 74 ++++++++++++++++++++++++-----------------
>  include/linux/of_mdio.h | 11 +++++-
>  2 files changed, 53 insertions(+), 32 deletions(-)
>=20
> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
> index 8270bbf505fb..6ee7e49dcb86 100644
> --- a/drivers/of/of_mdio.c
> +++ b/drivers/of/of_mdio.c
> @@ -60,39 +60,16 @@ static struct mii_timestamper *of_find_mii_timestampe=
r(struct device_node *node)
>  	return register_mii_timestamper(arg.np, arg.args[0]);
>  }
> =20
> -static int of_mdiobus_register_phy(struct mii_bus *mdio,
> -				    struct device_node *child, u32 addr)
> +int __of_mdiobus_register_phy(struct mii_bus *mdio, struct phy_device *p=
hy,
> +			      struct device_node *child, u32 addr)
>  {
> -	struct mii_timestamper *mii_ts;
> -	struct phy_device *phy;
> -	bool is_c45;
> -	int rc;
>  	u32 phy_id;

I need to remove phy_id here.

> -	mii_ts =3D of_find_mii_timestamper(child);
> -	if (IS_ERR(mii_ts))
> -		return PTR_ERR(mii_ts);
> -
> -	is_c45 =3D of_device_is_compatible(child,
> -					 "ethernet-phy-ieee802.3-c45");
> -
> -	if (!is_c45 && !of_get_phy_id(child, &phy_id))
> -		phy =3D phy_device_create(mdio, addr, phy_id, 0, NULL);
> -	else
> -		phy =3D get_phy_device(mdio, addr, is_c45);
> -	if (IS_ERR(phy)) {
> -		if (mii_ts)
> -			unregister_mii_timestamper(mii_ts);
> -		return PTR_ERR(phy);
> -	}
> +	int rc;
> =20
>  	rc =3D of_irq_get(child, 0);
> -	if (rc =3D=3D -EPROBE_DEFER) {
> -		if (mii_ts)
> -			unregister_mii_timestamper(mii_ts);
> -		phy_device_free(phy);
> +	if (rc =3D=3D -EPROBE_DEFER)
>  		return rc;
> -	}
> +
>  	if (rc > 0) {
>  		phy->irq =3D rc;
>  		mdio->irq[addr] =3D rc;
> @@ -117,11 +94,48 @@ static int of_mdiobus_register_phy(struct mii_bus *m=
dio,
>  	/* All data is now stored in the phy struct;
>  	 * register it */
>  	rc =3D phy_device_register(phy);
> +	if (rc) {
> +		of_node_put(child);
> +		return rc;
> +	}
> +
> +	dev_dbg(&mdio->dev, "registered phy %pOFn at address %i\n",
> +		child, addr);
> +	return 0;
> +}
> +EXPORT_SYMBOL(__of_mdiobus_register_phy);
> +
> +static int of_mdiobus_register_phy(struct mii_bus *mdio,
> +				    struct device_node *child, u32 addr)
> +{
> +	struct mii_timestamper *mii_ts;
> +	struct phy_device *phy;
> +	bool is_c45;
> +	int rc;
> +	u32 phy_id;
> +
> +	mii_ts =3D of_find_mii_timestamper(child);
> +	if (IS_ERR(mii_ts))
> +		return PTR_ERR(mii_ts);
> +
> +	is_c45 =3D of_device_is_compatible(child,
> +					 "ethernet-phy-ieee802.3-c45");
> +
> +	if (!is_c45 && !of_get_phy_id(child, &phy_id))
> +		phy =3D phy_device_create(mdio, addr, phy_id, 0, NULL);
> +	else
> +		phy =3D get_phy_device(mdio, addr, is_c45);
> +	if (IS_ERR(phy)) {
> +		if (mii_ts)
> +			unregister_mii_timestamper(mii_ts);
> +		return PTR_ERR(phy);
> +	}
> +
> +	rc =3D __of_mdiobus_register_phy(mdio, phy, child, addr);
>  	if (rc) {
>  		if (mii_ts)
>  			unregister_mii_timestamper(mii_ts);
>  		phy_device_free(phy);
> -		of_node_put(child);
>  		return rc;
>  	}
> =20
> @@ -132,8 +146,6 @@ static int of_mdiobus_register_phy(struct mii_bus *md=
io,
>  	if (mii_ts)
>  		phy->mii_ts =3D mii_ts;
> =20
> -	dev_dbg(&mdio->dev, "registered phy %pOFn at address %i\n",
> -		child, addr);
>  	return 0;
>  }
> =20
> diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
> index 491a2b7e77c1..b99e9f932002 100644
> --- a/include/linux/of_mdio.h
> +++ b/include/linux/of_mdio.h
> @@ -30,7 +30,9 @@ extern struct mii_bus *of_mdio_find_bus(struct device_n=
ode *mdio_np);
>  extern int of_phy_register_fixed_link(struct device_node *np);
>  extern void of_phy_deregister_fixed_link(struct device_node *np);
>  extern bool of_phy_is_fixed_link(struct device_node *np);
> -
> +extern int __of_mdiobus_register_phy(struct mii_bus *mdio,
> +				     struct phy_device *phy,
> +				     struct device_node *child, u32 addr);
> =20
>  static inline int of_mdio_parse_addr(struct device *dev,
>  				     const struct device_node *np)
> @@ -118,6 +120,13 @@ static inline bool of_phy_is_fixed_link(struct devic=
e_node *np)
>  {
>  	return false;
>  }
> +
> +static inline int __of_mdiobus_register_phy(struct mii_bus *mdio,
> +					    struct phy_device *phy,
> +					    struct device_node *child, u32 addr)
> +{
> +	return -ENOSYS;
> +}
>  #endif
> =20
> =20
> --=20
> 2.25.1
>=20
>=20

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--dw7t46st34ahcgpo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl5qE9AACgkQ4omh9DUa
UbOK4A//bpEEpGRBqg7ufFmkaz2mSdLlu/WAVeMelo1kOAqttO/LvqzykIraTNtF
zotZhZ3Wl+oe9D1jIVxv6Fe6Xfm/bdnl8C9ST/JXLmeSJv7GoHT4JKbuqMIQoxlf
f6ky4ylis4ng4IFdfXP4T35I6DNvSgkcHbhv6b7xdjXMAYj9VWvg/0A6Y4AzPGPQ
a2gyX9W3AiJixZRnQUxzSfLSAIYU7+Brg0I29OAdh96ZAxibPVa135s5wUBUbGPG
riQElr7tIt1Ucdagu+X29S8tnRYCg5VKyf4gKASjgG5bigi9zKRwefoBi9M3lqUd
If68X7dcrSWeruL5fQO8K0OghGQKANyNP8VLNkgbKHf/Y/x4z1boUCkuySqiDTSh
zJjlijkFc1hJDSud1zvf4EqqlYHf/94NL8D54g7bKxOM/rJNpXrqbmvArlftxWjx
+26V6zoqiRuD19+BSpWLI6u717Gdrazs5ROPo4OCuF70xbIvQ189qArM9PzXjvjy
f1JwozcsbKbC3rdIVqccjUtU3fl8ThWKeo3IS4VCZT71xtafpF1vFjSfJtjVQ4/e
NdAs8nHFOz3KJ75QJ2hn/znWcOvY26EqTIHUyF6kfZhMJiIkgKI6Ra4XD/VXVol3
q1waHDYzUo+ydEKOpqfi+KY+iKRU1JWC7iQpmx8xQzmfowaBtD4=
=G/ec
-----END PGP SIGNATURE-----

--dw7t46st34ahcgpo--

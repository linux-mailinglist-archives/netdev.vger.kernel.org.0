Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F541F0FD4
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 22:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgFGUjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 16:39:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:34018 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbgFGUjo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 16:39:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 21CEDABCE;
        Sun,  7 Jun 2020 20:39:45 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A7FA8602EB; Sun,  7 Jun 2020 22:39:40 +0200 (CEST)
Date:   Sun, 7 Jun 2020 22:39:40 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH v2 2/3] netlink: add master/slave configuration support
Message-ID: <20200607203940.7ayqe4otoop7mpuw@lion.mk-sys.cz>
References: <20200528115414.11516-1-o.rempel@pengutronix.de>
 <20200528115414.11516-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l7kwu7ebk7fahgx4"
Content-Disposition: inline
In-Reply-To: <20200528115414.11516-3-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--l7kwu7ebk7fahgx4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 28, 2020 at 01:54:13PM +0200, Oleksij Rempel wrote:
> This UAPI is needed for BroadR-Reach 100BASE-T1 devices. Due to lack of
> auto-negotiation support, we needed to be able to configure the
> MASTER-SLAVE role of the port manually or from an application in user
> space.
>=20
> The same UAPI can be used for 1000BASE-T or MultiGBASE-T devices to
> force MASTER or SLAVE role. See IEEE 802.3-2018:
> 22.2.4.3.7 MASTER-SLAVE control register (Register 9)
> 22.2.4.3.8 MASTER-SLAVE status register (Register 10)
> 40.5.2 MASTER-SLAVE configuration resolution
> 45.2.1.185.1 MASTER-SLAVE config value (1.2100.14)
> 45.2.7.10 MultiGBASE-T AN control 1 register (Register 7.32)
>=20
> The MASTER-SLAVE role affects the clock configuration:
>=20
> -------------------------------------------------------------------------=
------
> When the  PHY is configured as MASTER, the PMA Transmit function shall
> source TX_TCLK from a local clock source. When configured as SLAVE, the
> PMA Transmit function shall source TX_TCLK from the clock recovered from
> data stream provided by MASTER.
>=20
> iMX6Q                     KSZ9031                XXX
> ------\                /-----------\        /------------\
>       |                |           |        |            |
>  MAC  |<----RGMII----->| PHY Slave |<------>| PHY Master |
>       |<--- 125 MHz ---+-<------/  |        | \          |
> ------/                \-----------/        \------------/
>                                                ^
>                                                 \-TX_TCLK
>=20
> -------------------------------------------------------------------------=
------
>=20
> Since some clock or link related issues are only reproducible in a
> specific MASTER-SLAVE-role, MAC and PHY configuration, it is beneficial
> to provide generic (not 100BASE-T1 specific) interface to the user space
> for configuration flexibility and trouble shooting.
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

The patch looks good from technical point of view but I don't like the
inconsistency of user interface:

1. Similar to what we discussed earlier on kernel side, you use "Port
mode" in "ethtool <dev>" output but the corresponding command line
argument for "ethtool -s <dev> ..." is "master-slave". Even if it's
documented, it's rather confusing for users.

2. The values for "master-slave" parameter are "master-preferred" and
"master-force" (and the same for "slave"). Please use the same form for
both, i.e. either "prefer / force" or "preferred / forced". Also, it
would be friendlier to users to make the values consistent with
"ethtool <dev>" output, e.g. if it says "preferred Master", setting
should use something as close as possible, i.e. "preferred-master".

Michal

--l7kwu7ebk7fahgx4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl7dUIwACgkQ538sG/LR
dpUmpQgAwWvl06RefAuj2JRXHp/zqo4YSDZo1qtI7EshQfSeZJ2v0q+aHpTXbxfd
QSDSqyDAYHWB1W5jpcnylaRBzASWzeeHLuOf7JHkud5WqnM+tj/gpOkDNWcZVn7Z
KbanU+3GqZwSbtwHue9SaYS+FAPX/W38GZ8Jdc6PJdq0kkqmGSpwse61IdcMc2oD
2ovpaRibYqvhsyAdRTNIAbksSO2jbIubnNsscqoeRti3PwNbsldmIiLIOEv3CZ36
h/WQOTNOlYfCcQ9nK6S/ZBpDhEVR1UckoyhNFQfkZl6yj34QUchADiRZD2bsAOTA
Q1Ri0Bo3iWaEfGqHDmt+uFsBxf/cEQ==
=+bKp
-----END PGP SIGNATURE-----

--l7kwu7ebk7fahgx4--

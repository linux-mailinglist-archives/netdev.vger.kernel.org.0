Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284391F4726
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 21:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389265AbgFIThx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 15:37:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:58688 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbgFIThw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 15:37:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 436A0AD5E;
        Tue,  9 Jun 2020 19:37:51 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C323A60485; Tue,  9 Jun 2020 21:37:43 +0200 (CEST)
Date:   Tue, 9 Jun 2020 21:37:43 +0200
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
Subject: Re: [PATCH v3 2/3] netlink: add master/slave configuration support
Message-ID: <20200609193743.5ns7f2yx4jnydo27@lion.mk-sys.cz>
References: <20200609084718.14110-1-o.rempel@pengutronix.de>
 <20200609084718.14110-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iu2ys77yznqfdtrr"
Content-Disposition: inline
In-Reply-To: <20200609084718.14110-3-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--iu2ys77yznqfdtrr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 09, 2020 at 10:47:17AM +0200, Oleksij Rempel wrote:
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
>  ethtool.8.in           | 19 ++++++++++++++++
>  ethtool.c              |  1 +
>  netlink/desc-ethtool.c |  2 ++
>  netlink/settings.c     | 50 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 72 insertions(+)
>=20
> diff --git a/ethtool.8.in b/ethtool.8.in
> index f8b09e0..dca7c7a 100644
> --- a/ethtool.8.in
> +++ b/ethtool.8.in
> @@ -52,6 +52,10 @@
>  .\"
>  .ds MA \fIxx\fP\fB:\fP\fIyy\fP\fB:\fP\fIzz\fP\fB:\fP\fIaa\fP\fB:\fP\fIbb=
\fP\fB:\fP\fIcc\fP
>  .\"
> +.\"	\(*MS - master-slave property
> +.\"
> +.ds MS \fBpreferred-master\fP|\fBpreferred-slave\fP|\fBforced-master\fP|=
\fBforced-slave\fP
> +.\"
>  .\"	\(*PA - IP address
>  .\"
>  .ds PA \fIip-address\fP

It would be nice if we could forbid line breaks around the dashes
somehow to prevent effects like

       ethtool -s devname [speed N] [duplex half|full] [port tp|aui|bnc|mii]
              [mdix auto|on|off] [autoneg on|off] [advertise N[/M] |
              advertise mode on|off ...]  [phyad N] [xcvr internal|external]
              [wol N[/M] | wol p|u|m|b|a|g|s|f|d...]
              [sopass xx:yy:zz:aa:bb:cc] [master-slave preferred-
              master|preferred-slave|forced-master|forced-slave] [msglvl
              N[/M] | msglvl type on|off ...]

(this is for 80 columns). But I have no idea how and it's a cosmetic
issue that can certainly be left for later.

> @@ -255,6 +259,7 @@ ethtool \- query or control network driver and hardwa=
re settings
>  .RB [ wol \ \fIN\fP[\fB/\fP\fIM\fP]
>  .RB | \ wol \ \*(WO]
>  .RB [ sopass \ \*(MA]
> +.RB [ master-slave \ \*(MS]
>  .RB [ msglvl
>  .IR N\fP[/\fIM\fP] \ |
>  .BI msglvl \ type
> @@ -646,6 +651,20 @@ Sets full or half duplex mode.
>  .A4 port tp aui bnc mii fibre da
>  Selects device port.
>  .TP
> +.BR master-slave \ \*(MS
> +Configure MASTER/SLAVE role of the PHY. When the PHY is configured as MA=
STER,
> +the PMA Transmit function shall source TX_TCLK from a local clock source=
=2E When
> +configured as SLAVE, the PMA Transmit function shall source TX_TCLK from=
 the
> +clock recovered from data stream provided by MASTER. Not all devices sup=
port this.
> +.TS
> +nokeep;
> +lB	l.
> +preferred-master Prefer MASTER role on autonegotiation
> +preferred-slave	 Prefer SLAVE role on autonegotiation
> +forced-master    Force the PHY in MASTER role. Can be used without auton=
egotiation
> +forced-slave     Force the PHY in SLAVE role. Can be used without autone=
gotiation
> +.TE
> +.TP
>  .A3 mdix auto on off
>  Selects MDI-X mode for port. May be used to override the automatic
>  detection feature of most adapters. An argument of \fBauto\fR means

This table is not formatted correctly. I played with the source a bit
and it seems the columns should be separated (on each line) by one
tabulator.

With this fixed,

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

Michal

--iu2ys77yznqfdtrr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl7f5QcACgkQ538sG/LR
dpX95ggAxK5o1Nt1TPshAFNXt5Nr/imY8hNYVQY7awOJlN2nPs1Z6FEAR7A62EA/
Ysk20LE7AkgP7v3TcsQ7bv4vnUGpZxq4jEnygyu6OinHEnrCC3lhNAPvl+yhEgZk
G04zwbqDkA2nLodd+/wLiU5Jzgbp+ufko/l6pIGo894RKR73e3yR7Ioj6fAIauB3
KdUuOD0H2KG7E5uzu4pgeknEsoQOTX0Kr3dMQrJ6sDrfe08frnTwgSq7cjZbjIQC
YWkrg/m7shwft57qOCRQNeTct0R3QmwqaYdzf9780Vmk0UFbxgKExrqpfz1bClE2
5S4GklQIkM5vj43hKkzMjEha/EfR4w==
=yNq1
-----END PGP SIGNATURE-----

--iu2ys77yznqfdtrr--

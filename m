Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0BA327C8D
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbhCAKrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:47:13 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56196 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbhCAKqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:46:53 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id AF4DC1C0B7C; Mon,  1 Mar 2021 11:46:10 +0100 (CET)
Date:   Mon, 1 Mar 2021 11:46:10 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Ben Whitten <ben.whitten@gmail.com>
Subject: Re: [PATCH RFC leds + net-next 5/7] net: phy: add simple
 incrementing phyindex member to phy_device struct
Message-ID: <20210301104610.GD31897@duo.ucw.cz>
References: <20201030114435.20169-1-kabel@kernel.org>
 <20201030114435.20169-6-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="n/aVsWSeQ4JHkrmm"
Content-Disposition: inline
In-Reply-To: <20201030114435.20169-6-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--n/aVsWSeQ4JHkrmm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2020-10-30 12:44:33, Marek Beh=FAn wrote:
> Add a new integer member phyindex to struct phy_device. This member is
> unique for every phy_device. Atomic incrementation occurs in
> phy_device_register.
>=20
> This can be used for example in LED sysfs API. The LED subsystem names
> each LED in format `device:color:function`, but currently the PHY device
> names are not suited for this, since in some situations a PHY device
> name can look like this
>   d0032004.mdio-mii:01
> or even like this
>   !soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:08
> Clearly this cannot be used as the `device` part of a LED name.
>=20
> Signed-off-by: Marek Beh=FAn <kabel@kernel.org>

Atomic should _not_ be neccessary for this. Just make sure access is
serialised by some existing lock.
								Pavel
							=09
> @@ -892,6 +893,7 @@ EXPORT_SYMBOL(get_phy_device);
>   */
>  int phy_device_register(struct phy_device *phydev)
>  {
> +	static atomic_t phyindex;
>  	int err;
> =20
>  	err =3D mdiobus_register_device(&phydev->mdio);
> @@ -908,6 +910,7 @@ int phy_device_register(struct phy_device *phydev)
>  		goto out;
>  	}
> =20
> +	phydev->phyindex =3D atomic_inc_return(&phyindex) - 1;
>  	err =3D device_add(&phydev->mdio.dev);
>  	if (err) {
>  		phydev_err(phydev, "failed to add\n");

--=20
http://www.livejournal.com/~pavelmachek

--n/aVsWSeQ4JHkrmm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYDzF8gAKCRAw5/Bqldv6
8rCMAJ9XJ9g6EdJ3uaSlddzTP7XKdOX3tACglHkmHolFAWiVSzUfgX7UsRfpVD8=
=Yn7L
-----END PGP SIGNATURE-----

--n/aVsWSeQ4JHkrmm--

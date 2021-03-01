Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69538327CCC
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 12:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbhCALGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 06:06:05 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57706 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbhCALGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 06:06:03 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id AFF1F1C0B7C; Mon,  1 Mar 2021 12:05:20 +0100 (CET)
Date:   Mon, 1 Mar 2021 12:05:20 +0100
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
Subject: Re: [PATCH RFC leds + net-next 7/7] net: phy: marvell: support LEDs
 connected on Marvell PHYs
Message-ID: <20210301110520.GF31897@duo.ucw.cz>
References: <20201030114435.20169-1-kabel@kernel.org>
 <20201030114435.20169-8-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Zi0sgQQBxRFxMTsj"
Content-Disposition: inline
In-Reply-To: <20201030114435.20169-8-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Zi0sgQQBxRFxMTsj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Add support for controlling the LEDs connected to several families of
> Marvell PHYs via Linux LED API. These families currently are: 88E1112,
> 88E1116R, 88E1118, 88E1121R, 88E1149R, 88E1240, 88E1318S, 88E1340S,
> 88E1510, 88E1545 and 88E1548P.
>=20
> This does not yet add support for compound LED modes. This could be
> achieved via the LED multicolor framework.
>=20
> netdev trigger offloading is also implemented.
>=20
> Signed-off-by: Marek Beh=FAn <kabel@kernel.org>


> +	val =3D 0;
> +	if (!active_low)
> +		val |=3D BIT(0);
> +	if (tristate)
> +		val |=3D BIT(1);

You are parsing these parameters in core... but they are not going to
be common for all phys, right? Should you parse them in the driver?
Should the parameters be same we have for gpio-leds?

> +static const struct marvell_led_mode_info marvell_led_mode_info[] =3D {
> +	{ LED_MODE(1, 0, 0), { 0x0,  -1, 0x0,  -1,  -1,  -1, }, COMMON },
> +	{ LED_MODE(1, 1, 1), { 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, }, COMMON },
> +	{ LED_MODE(0, 1, 1), { 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, }, COMMON },
> +	{ LED_MODE(1, 0, 1), {  -1, 0x2,  -1, 0x2, 0x2, 0x2, }, COMMON },
> +	{ LED_MODE(0, 1, 0), { 0x5,  -1, 0x5,  -1, 0x5, 0x5, }, COMMON },
> +	{ LED_MODE(0, 1, 0), {  -1,  -1,  -1, 0x5,  -1,  -1, }, L3V5_TX },
> +	{ LED_MODE(0, 0, 1), {  -1,  -1,  -1,  -1, 0x0, 0x0, }, COMMON },
> +	{ LED_MODE(0, 0, 1), {  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_RX },
> +};
> +
> +static int marvell_find_led_mode(struct phy_device *phydev, struct phy_l=
ed *led,
> +				 struct led_netdev_data *trig)
> +{
> +	const struct marvell_leds_info *info =3D led->priv;
> +	const struct marvell_led_mode_info *mode;
> +	u32 key;
> +	int i;
> +
> +	key =3D LED_MODE(trig->link, trig->tx, trig->rx);
> +
> +	for (i =3D 0; i < ARRAY_SIZE(marvell_led_mode_info); ++i) {
> +		mode =3D &marvell_led_mode_info[i];
> +
> +		if (key !=3D mode->key || mode->regval[led->addr] =3D=3D -1 ||
> +		    !(info->flags & mode->flags))
> +			continue;
> +
> +		return mode->regval[led->addr];
> +	}
> +
> +	dev_dbg(led->cdev.dev,
> +		"cannot offload trigger configuration (%s, link=3D%i, tx=3D%i, rx=3D%i=
)\n",
> +		netdev_name(trig->net_dev), trig->link, trig->tx, trig->rx);
> +
> +	return -1;
> +}

I'm wondering if it makes sense to offload changes on link
state. Those should be fairly infrequent and you are not saving
significant power there... and seems to complicate things.

The "shared frequency blinking" looks quite crazy.

Rest looks reasonably sane.

Best regards,
								Pavel

--=20
http://www.livejournal.com/~pavelmachek

--Zi0sgQQBxRFxMTsj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYDzKcAAKCRAw5/Bqldv6
8lzpAJ9Dsy8g7bXAqzb5kG1EdFi2awx9wQCfaiq+VSv3LJD10zG2z7ZTcwZSZpc=
=FgTW
-----END PGP SIGNATURE-----

--Zi0sgQQBxRFxMTsj--

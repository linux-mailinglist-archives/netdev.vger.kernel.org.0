Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0259F327CA0
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhCAKxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:53:05 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56704 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbhCAKwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:52:53 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B6B9F1C0B7C; Mon,  1 Mar 2021 11:52:10 +0100 (CET)
Date:   Mon, 1 Mar 2021 11:52:10 +0100
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
Subject: Re: [PATCH RFC leds + net-next 6/7] net: phy: add support for LEDs
 connected to ethernet PHYs
Message-ID: <20210301105210.GE31897@duo.ucw.cz>
References: <20201030114435.20169-1-kabel@kernel.org>
 <20201030114435.20169-7-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WK3l2KTTmXPVedZ6"
Content-Disposition: inline
In-Reply-To: <20201030114435.20169-7-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--WK3l2KTTmXPVedZ6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI!

> Many an ethernet PHY chip has pins dedicated for LEDs. On some PHYs it
> can be configured via registers whether the LED should be ON, OFF, or
> whether its state should depend on events within the chip (link, rx/tx
> activity and so on).
>=20
> Add support for probing such LEDs.
>=20
> A PHY driver wishing to utilize this API must implement methods
> led_init() and led_brightness_set(). Methods led_blink_set() and
> led_trigger_offload() are optional.
>=20
> Signed-off-by: Marek Beh=FAn <kabel@kernel.org>
> ---
>  drivers/net/phy/phy_device.c | 140 +++++++++++++++++++++++++++++++++++
>  include/linux/phy.h          |  50 +++++++++++++
>  2 files changed, 190 insertions(+)

> +	led =3D devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
> +	if (!led)
> +		return -ENOMEM;
> +
> +	led->addr =3D -1;
> +	if (!fwnode_property_read_u32(fwnode, "reg", &reg))
> +		led->addr =3D reg;
> +
> +	led->active_low =3D !fwnode_property_read_bool(fwnode,
> +						     "enable-active-high");
> +	led->tristate =3D fwnode_property_read_bool(fwnode, "tristate");

Does this need binding documentation?

>  	mutex_unlock(&phydev->lock);
> =20
> +	/* LEDs have to be registered with phydev mutex unlocked, because some
> +	 * operations can be called during registration that lock the mutex.
> +	 */
> +	if (!err)
> +		err =3D phy_probe_leds(phydev);
> +
>  	return err;
>  }

Is it safe to do the probing without the mutex?

Should error in LED probing fail the whole phy probe?

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--WK3l2KTTmXPVedZ6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYDzHWgAKCRAw5/Bqldv6
8oBWAJ9W3tst4JnTFwNevFMLmnlVC/OJTwCgl/zZEUM1jFfZ/u7dGZrXGeFa9Y8=
=FchG
-----END PGP SIGNATURE-----

--WK3l2KTTmXPVedZ6--

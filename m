Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F262637C6
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 22:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbgIIUsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 16:48:22 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39014 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730021AbgIIUsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 16:48:20 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3DD4C1C0B87; Wed,  9 Sep 2020 22:48:16 +0200 (CEST)
Date:   Wed, 9 Sep 2020 22:48:15 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 2/7] leds: add generic API for LEDs
 that can be controlled by hardware
Message-ID: <20200909204815.GB20388@amd>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-3-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <20200909162552.11032-3-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Many an ethernet PHY (and other chips) supports various HW control modes
> for LEDs connected directly to them.

I guess this should be

"Many ethernet PHYs (and other chips) support various HW control modes
for LEDs connected directly to them."

> This API registers a new private LED trigger called dev-hw-mode. When
> this trigger is enabled for a LED, the various HW control modes which
> are supported by the device for given LED can be get/set via hw_mode
> sysfs file.
>=20
> Signed-off-by: Marek Beh=FAn <marek.behun@nic.cz>
> ---
>  .../sysfs-class-led-trigger-dev-hw-mode       |   8 +
>  drivers/leds/Kconfig                          |  10 +

I guess this should live in drivers/leds/trigger/ledtrig-hw.c . I'd
call the trigger just "hw"...

> +Contact:	Marek Beh=FAn <marek.behun@nic.cz>
> +		linux-leds@vger.kernel.org
> +Description:	(W) Set the HW control mode of this LED. The various availa=
ble HW control modes
> +		    are specific per device to which the LED is connected to and per L=
ED itself.
> +		(R) Show the available HW control modes and the currently selected one.

80 columns :-) (and please fix that globally, at least at places where
it is easy, like comments).

> +	return 0;
> +err_free:
> +	devm_kfree(dev, led);
> +	return ret;
> +}

No need for explicit free with devm_ infrastructure?

> +	cur_mode =3D led->ops->led_get_hw_mode(dev->parent, led);
> +
> +	for (mode =3D led->ops->led_iter_hw_mode(dev->parent, led, &iter);
> +	     mode;
> +	     mode =3D led->ops->led_iter_hw_mode(dev->parent, led, &iter)) {
> +		bool sel;
> +
> +		sel =3D cur_mode && !strcmp(mode, cur_mode);
> +
> +		len +=3D scnprintf(buf + len, PAGE_SIZE - len, "%s%s%s ", sel ? "[" : =
"", mode,
> +				 sel ? "]" : "");
> +	}
> +
> +	if (buf[len - 1] =3D=3D ' ')
> +		buf[len - 1] =3D '\n';

Can this ever be false? Are you accessing buf[-1] in such case?

> +int of_register_hw_controlled_leds(struct device *dev, const char *devic=
ename,
> +				   const struct hw_controlled_led_ops *ops);
> +int hw_controlled_led_brightness_set(struct led_classdev *cdev, enum led=
_brightness brightness);
> +

Could we do something like hw_controlled_led -> hw_led to keep
verbosity down and line lengths reasonable? Or hwc_led?

> +extern struct led_hw_trigger_type hw_control_led_trig_type;
> +extern struct led_trigger hw_control_led_trig;
> +
> +#else /* !IS_ENABLED(CONFIG_LEDS_HW_CONTROLLED) */

CONFIG_LEDS_HWC? Or maybe CONFIG_LEDTRIG_HW?

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl9ZP48ACgkQMOfwapXb+vLwZQCfYh+LPNKqjNBysaBhnmN2tuNz
s0kAmwRZTEfv7ZWdx/OVgOPKU2VXE4z4
=ABk9
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E42327C81
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbhCAKpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:45:06 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56014 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbhCAKoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:44:46 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8B3D31C0B7F; Mon,  1 Mar 2021 11:44:04 +0100 (CET)
Date:   Mon, 1 Mar 2021 11:44:04 +0100
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
Subject: Re: [PATCH RFC leds + net-next 4/7] leds: trigger: netdev: support
 HW offloading
Message-ID: <20210301104404.GC31897@duo.ucw.cz>
References: <20201030114435.20169-1-kabel@kernel.org>
 <20201030114435.20169-5-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="H8ygTp4AXg6deix2"
Content-Disposition: inline
In-Reply-To: <20201030114435.20169-5-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Add support for HW offloading of the netdev trigger.
>=20
> We need to change spinlock to mutex, because if spinlock is used, the
> trigger_offload() method cannot sleep, which can happen for ethernet
> PHYs.

Is that bugfix or just needed for offloading? Should be separate patch
in any case.

> Move struct led_trigger_data into global include directory, into file
> linux/ledtrig.h, so that drivers wanting to offload the trigger can
> access its settings.

Separate...

> @@ -327,12 +310,14 @@ static int netdev_trig_notify(struct notifier_block=
 *nb,
>  	case NETDEV_CHANGE:
>  		if (netif_carrier_ok(dev))
>  			trigger_data->linkup =3D 1;
> +		reset =3D !trigger_data->led_cdev->offloaded;
>  		break;
>  	}
> =20
> -	set_baseline_state(trigger_data);
> +	if (reset)
> +		set_baseline_state(trigger_data);
> =20
> -	spin_unlock_bh(&trigger_data->lock);
> +	mutex_unlock(&trigger_data->lock);
> =20
>  	return NOTIFY_DONE;
>  }

Is this the only thing it saves? Because.. that would not be worth
it.

Best regards,
									Pavel

--=20
http://www.livejournal.com/~pavelmachek

--H8ygTp4AXg6deix2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYDzFdAAKCRAw5/Bqldv6
8i+uAKC8YPGzoWJ8NzCqL3SgXYyzgaY87gCffOZQjgOtU0h5ymovcBGUfu5jI0U=
=zB+D
-----END PGP SIGNATURE-----

--H8ygTp4AXg6deix2--

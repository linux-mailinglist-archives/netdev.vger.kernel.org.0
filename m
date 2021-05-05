Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9993735EB
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 09:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhEEIAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 04:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbhEEIAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 04:00:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6D1C061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 00:59:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1leCR9-0003tb-Fo; Wed, 05 May 2021 09:59:15 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:96db:da04:b018:e517])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D423361CF6D;
        Wed,  5 May 2021 07:51:28 +0000 (UTC)
Date:   Wed, 5 May 2021 09:51:27 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Timo =?utf-8?B?U2NobMO8w59sZXI=?= <schluessler@krause.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tim Harvey <tharvey@gateworks.com>, stable@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] can: mcp251x: Fix resume from sleep before interface
 was brought up
Message-ID: <20210505075127.yrx474t5dkpxxdmt@pengutronix.de>
References: <17d5d714-b468-482f-f37a-482e3d6df84e@kontron.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yznx7xbbfo6rpzze"
Content-Disposition: inline
In-Reply-To: <17d5d714-b468-482f-f37a-482e3d6df84e@kontron.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yznx7xbbfo6rpzze
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.05.2021 09:14:15, Frieder Schrempf wrote:
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>=20
> Since 8ce8c0abcba3 the driver queues work via priv->restart_work when
> resuming after suspend, even when the interface was not previously
> enabled. This causes a null dereference error as the workqueue is
> only allocated and initialized in mcp251x_open().
>=20
> To fix this we move the workqueue init to mcp251x_can_probe() as
> there is no reason to do it later and repeat it whenever
> mcp251x_open() is called.
>=20
> Fixes: 8ce8c0abcba3 ("can: mcp251x: only reset hardware as required")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> Changes in v2:
>   * Remove the out_clean label in mcp251x_open()
>   * Add Andy's R-b tag
>   * Add 'From' tag
>=20
> Hi Marc, I'm sending a v2 mainly because I noticed that v1 is missing
> the 'From' tag and as my company's mailserver always sends my name
> reversed this causes incorrect author information in git. So if possible
> you could fix this up. If this is too much work, just leave it as is.
> Thanks!

Done.

I've also squashed this fixup:

| --- a/drivers/net/can/spi/mcp251x.c
| +++ b/drivers/net/can/spi/mcp251x.c
| @@ -1224,13 +1224,13 @@ static int mcp251x_open(struct net_device *net)
| =20
|         ret =3D mcp251x_hw_wake(spi);
|         if (ret)
| -               goto out_free_wq;
| +               goto out_free_irq;
|         ret =3D mcp251x_setup(net, spi);
|         if (ret)
| -               goto out_free_wq;
| +               goto out_free_irq;
|         ret =3D mcp251x_set_normal_mode(spi);
|         if (ret)
| -               goto out_free_wq;
| +               goto out_free_irq;
| =20
|         can_led_event(net, CAN_LED_EVENT_OPEN);
| =20
| @@ -1239,8 +1239,7 @@ static int mcp251x_open(struct net_device *net)
| =20
|         return 0;
| =20
| -out_free_wq:
| -       destroy_workqueue(priv->wq);
| +out_free_irq:
|         free_irq(spi->irq, priv);
|         mcp251x_hw_sleep(spi);
|  out_close:

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--yznx7xbbfo6rpzze
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCSTnwACgkQqclaivrt
76kv9wf7BAMTVYzAMRMbokLYHE5LYSL7ixmtjQKCiMJLQBD31lk6piZ1ZIvmYW2m
FR9JeZD1IaatAbLyV3Whw8G6no+qvzVJCrgV8sR5zKuhYmYLHFeHmmAuf1LX7nzq
wd9uWnlGlkNN6b//r7euI/ccZmHsLYsl3sRVx2deVtBY2ed3/8KU4JhSGQH4U7FO
Ac66BmV6yGIwoymO5u7zRhx0m+B3eMY/02v+E2L/qXEYcJrNiFjWU7EcEm5lPP9f
e98fYjC9rwmHk3afaLFKP3XYLOsPYcbo/lSjoArNvqc0KZYV6VD2dEqd89EhCxGB
d4pDmDGLYg0n8IyI+2XPrF3rw0Xaog==
=YDVe
-----END PGP SIGNATURE-----

--yznx7xbbfo6rpzze--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F9D44B230
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 18:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241395AbhKIRxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 12:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239360AbhKIRxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 12:53:45 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B003AC061764
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 09:50:59 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mkVGs-0002Fu-03; Tue, 09 Nov 2021 18:50:58 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mkVGq-0000Xo-Lk; Tue, 09 Nov 2021 18:50:56 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mkVGp-0001gs-I3; Tue, 09 Nov 2021 18:50:56 +0100
Date:   Tue, 9 Nov 2021 18:50:55 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next] net: dsa: Some cleanups in remove code
Message-ID: <20211109175055.46rytrdejv56hkxv@pengutronix.de>
References: <20211109113921.1020311-1-u.kleine-koenig@pengutronix.de>
 <20211109115434.oejplrd7rzmvad34@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hi7hemjrusbjl3eu"
Content-Disposition: inline
In-Reply-To: <20211109115434.oejplrd7rzmvad34@skbuf>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hi7hemjrusbjl3eu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

Cc +=3D gregkh, maybe he has something to say on this matter

On Tue, Nov 09, 2021 at 01:54:34PM +0200, Vladimir Oltean wrote:
> Your commit prefix does not reflect the fact that you are touching the
> vsc73xx driver. Try "net: dsa: vsc73xx: ".

Oh, I missed that indeed.

> On Tue, Nov 09, 2021 at 12:39:21PM +0100, Uwe Kleine-K=F6nig wrote:
> > vsc73xx_remove() returns zero unconditionally and no caller checks the
> > returned value. So convert the function to return no value.
>=20
> This I agree with.
>=20
> > For both the platform and the spi variant ..._get_drvdata() will never
> > return NULL in .remove() because the remove callback is only called aft=
er
> > the probe callback returned successfully and in this case driver data w=
as
> > set to a non-NULL value.
>=20
> Have you read the commit message of 0650bf52b31f ("net: dsa: be
> compatible with masters which unregister on shutdown")?

No. But I did now. I consider it very surprising that .shutdown() calls
the .remove() callback and would recommend to not do this. The commit
log seems to prove this being difficult.

> To remove the check for dev_get_drvdata =3D=3D NULL in ->remove, you need=
 to
> prove that ->remove will never be called after ->shutdown. For platform
> devices this is pretty easy to prove, for SPI devices not so much.
> I intentionally kept the code structure the same because code gets
> copied around a lot, it is easy to copy from the wrong place.

Alternatively remove spi_set_drvdata(spi, NULL); from
vsc73xx_spi_shutdown()? Also I'm not aware how platform devices are
different to spi devices that the ordering of .remove and shutdown() is
more or less obvious than on the other bus?!

> > Also setting driver data to NULL is not necessary, this is already done
> > in the driver core in __device_release_driver(), so drop this from the
> > remove callback, too.
>=20
> And this was also intentional, for visibility more or less. I would like
> you to ack that you understand the problems surrounding ->remove/->shutdo=
wn
> ordering for devices on buses, prior to making seemingly trivial cleanups.

I see that the change is not so obviously correct as I thought. I'll
have to think about this and will respin if and when I find a sane way
forward.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--hi7hemjrusbjl3eu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmGKtPwACgkQwfwUeK3K
7AlwHQf/brAIABdCMSAp/6DHcYUD/ICoES+9/4kti0C1mV/wyWxruLLPz2BIhm00
iE2vwod3N3g1RIULX9RJlMAuCAc6L/D8H2ZDWqAw8gYQYm+g/V64pSOYs8s94YHM
g8bqeocRXmmiMD3dsDhK0SjKRoQ//vnNPR6q7Pv5s2IWo/2Q0CKD6DKl+Wz5b3fF
0N2y8cJOm75PvYWTEJGFg7cBqTU5wpcjdfaW2rDM3a4Ww6P+0q1abe76qSMAxfVU
KA0XTxqdOAmy0nUQhYQ5iRbAxu301qg21XbGmEnGtmd0O2vvCbqmYMtEM7WyrBd/
f1Sqi/xKdg6djkekPwlrWBrEQxQVAQ==
=bvYm
-----END PGP SIGNATURE-----

--hi7hemjrusbjl3eu--

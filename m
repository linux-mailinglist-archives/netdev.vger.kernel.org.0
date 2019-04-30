Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0485F1D9
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 10:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfD3IMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 04:12:39 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38179 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfD3IMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 04:12:39 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1hLNsL-000189-Bz; Tue, 30 Apr 2019 10:12:29 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1hLNsJ-0004oN-QK; Tue, 30 Apr 2019 10:12:27 +0200
Date:   Tue, 30 Apr 2019 10:12:27 +0200
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>
To:     Aurelien Jarno <aurel32@debian.org>, 927825@bugs.debian.org
Cc:     Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        netdev@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>
Subject: Re: Bug#927825: arm: mvneta driver used on Armada XP GP boards does
 not receive packets (regression from 4.9)
Message-ID: <20190430081223.GA7409@taurus.defre.kleine-koenig.org>
References: <155605060923.15313.17004641650838278623.reportbug@ohm.local>
 <155605060923.15313.17004641650838278623.reportbug@ohm.local>
 <20190425125046.GA7210@aurel32.net>
 <155605060923.15313.17004641650838278623.reportbug@ohm.local>
 <20190425191732.GA28481@aurel32.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20190425191732.GA28481@aurel32.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Adding the mvebu guys and netdev to Cc]

Hello,

On Thu, Apr 25, 2019 at 09:17:32PM +0200, Aurelien Jarno wrote:
> On 2019-04-25 14:50, Aurelien Jarno wrote:
> > On 2019-04-23 22:16, Aurelien Jarno wrote:
> > > Source: linux
> > > Version: 4.19.28-2
> > > Severity: important
> > >=20
> > > After upgrading hartmann.debian.org (an armhf buildd using an Armada =
XP
> > > GP board) from buster to stretch, the ethernet device is not working

"upgrading from buster to stretch" doesn't make sense. I think you meant
=66rom stretch to buster.

> >=20
> > More precisely the board is a "Marvell Armada XP Development Board
> > DB-MV784MP-GP"
> >=20
> > > anymore. Using tcpdump on both the buildd and a remote host, it appea=
rs
> > > that the packets correctly leave the board and that the reception side
> > > fails.

If you can send to a remote host at least ARP (or ND) must be working,
so some reception still works, right?

> > > The module used for the ethernet device is mvneta. The corresponding =
DT
> > > compatible entry is "marvell,armada-xp-neta".
> > >
> >=20
> > I have started a "bisection" with the kernels from snapshot. This is
> > what I have found so far:
> >=20
> > This one works:
> > - linux-image-4.19.0-rc6-armmp-lpae_4.19~rc6-1~exp1_armhf.deb=20
> >=20
> > The following ones don't:
> > - linux-image-4.19.0-rc7-armmp-lpae_4.19~rc7-1~exp1_armhf.deb
> > - linux-image-5.0.0-trunk-armmp_5.0.2-1~exp1_armhf.deb
> >=20
> > My guess (I don't have time to try more now) is that the issue is caused
> > by the following change:
> >=20
> > |  [ Uwe Kleine-K=F6nig ]
> > |  * [armhf] enable MVNETA_BM_ENABLE and CAN_FLEXCAN as a module
> >=20
>=20
> I confirm this is the issue. Disabling MVNETA_BM_ENABLE on kernel=20
> 4.19.28-2 fixes the issue. Note that it breaks the ABI.

A colleague happens to work with an XP based machine with a (nearly)
vanilla kernel based on 5.1.0-rc6 and there enabling MVNETA_BM_ENABLE
doesn't render networking nonfunctional.

Looking through the changes to drivers/net/ethernet/marvell/mvneta*
between 5.0 and 5.1-rc6 there isn't something that would explain a fix
though. There doesn't seem to be a good explanation in the debian
specific patches either.

So this problem is either machine specific or it works with the mvneta
driver builtin. (I didn't double check, but guess that my colleague uses
=3Dy and the Debian kernel =3Dm). Well, or I missed something.

Is it possible to test a few things on hartmann? I'd suggest:

 - try (vanilla) 5.1-rc6 with MVNETA=3Dy
 - try an older kernel (maybe 4.6 as the buffer manager stuff was
   introduced in dc35a10f68d3 ("net: mvneta: bm: add support for
   hardware buffer management") which made it into 4.6-rc1) with
   MVNETA_BM_ENABLE=3D[ym].

Best regards
Uwe

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAlzIA2QACgkQwfwUeK3K
7AkBuQf/Rj+7QkSaunh9KxGHlIlT+4yTRUXbpMWiuSeELDhgfyoAQU0HixcFU6QK
0p7aWGNMRVScHRXmN5Gi3pF6bLq8F6I+xlLraTelYVBAGRcEDHKQZPyLEUyyKnr2
6pDSZnLmqna8ppycjkvhegdqpT8+hb8w9L4F1jiJ2eKBcYvFw7e5s3oqm7cOZEPe
zyrP+USLjhn78X+9uai0uRclWi8gSpTUvwpFBz8f/xe5y4yzBzsOegDz96S10GLV
t91ElpxS6UBBYED8gaNMByia8sbylMmmALTDFylu1sN7reQGGBY0O8MDVO6TVk3A
kSc3lXcQTFJgus6ZMbCYKshPip+l+Q==
=pB6Y
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--

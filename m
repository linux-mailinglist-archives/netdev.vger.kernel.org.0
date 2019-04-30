Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 216061027E
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 00:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfD3WiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 18:38:17 -0400
Received: from hall.aurel32.net ([195.154.113.88]:48604 "EHLO hall.aurel32.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbfD3WiR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 18:38:17 -0400
X-Greylist: delayed 2027 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2019 18:38:15 EDT
Received: from [2a01:e35:2fdd:a4e1:fe91:fc89:bc43:b814] (helo=ohm.rr44.fr)
        by hall.aurel32.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <aurelien@aurel32.net>)
        id 1hLarN-0003Pa-Uh; Wed, 01 May 2019 00:04:21 +0200
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.92)
        (envelope-from <aurelien@aurel32.net>)
        id 1hLarN-0003UX-Gs; Wed, 01 May 2019 00:04:21 +0200
Date:   Wed, 1 May 2019 00:04:21 +0200
From:   Aurelien Jarno <aurel32@debian.org>
To:     Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>
Cc:     927825@bugs.debian.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        netdev@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Steve McIntyre <steve@einval.com>
Subject: Re: Bug#927825: arm: mvneta driver used on Armada XP GP boards does
 not receive packets (regression from 4.9)
Message-ID: <20190430220421.GA3750@aurel32.net>
References: <155605060923.15313.17004641650838278623.reportbug@ohm.local>
 <155605060923.15313.17004641650838278623.reportbug@ohm.local>
 <20190425125046.GA7210@aurel32.net>
 <155605060923.15313.17004641650838278623.reportbug@ohm.local>
 <20190425191732.GA28481@aurel32.net>
 <20190430081223.GA7409@taurus.defre.kleine-koenig.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <20190430081223.GA7409@taurus.defre.kleine-koenig.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-04-30 10:12, Uwe Kleine-K=F6nig wrote:
> [Adding the mvebu guys and netdev to Cc]
>=20
> Hello,
>=20
> On Thu, Apr 25, 2019 at 09:17:32PM +0200, Aurelien Jarno wrote:
> > On 2019-04-25 14:50, Aurelien Jarno wrote:
> > > On 2019-04-23 22:16, Aurelien Jarno wrote:
> > > > Source: linux
> > > > Version: 4.19.28-2
> > > > Severity: important
> > > >=20
> > > > After upgrading hartmann.debian.org (an armhf buildd using an Armad=
a XP
> > > > GP board) from buster to stretch, the ethernet device is not working
>=20
> "upgrading from buster to stretch" doesn't make sense. I think you meant
> from stretch to buster.

You're correct. To be more precise the kernel is there the issue, so
that should even be upgrading from the stretch kernel to the buster
kernel.

> > > More precisely the board is a "Marvell Armada XP Development Board
> > > DB-MV784MP-GP"
> > >=20
> > > > anymore. Using tcpdump on both the buildd and a remote host, it app=
ears
> > > > that the packets correctly leave the board and that the reception s=
ide
> > > > fails.
>=20
> If you can send to a remote host at least ARP (or ND) must be working,
> so some reception still works, right?

I have to try again, but what i have seen is the ARP requests from
hartmann arriving to the other hosts on the subnet. Steve McIntyre
(added in Cc:) confirmed me on IRC being able to reproduce the issue on
another board.

> > > > The module used for the ethernet device is mvneta. The correspondin=
g DT
> > > > compatible entry is "marvell,armada-xp-neta".
> > > >
> > >=20
> > > I have started a "bisection" with the kernels from snapshot. This is
> > > what I have found so far:
> > >=20
> > > This one works:
> > > - linux-image-4.19.0-rc6-armmp-lpae_4.19~rc6-1~exp1_armhf.deb=20
> > >=20
> > > The following ones don't:
> > > - linux-image-4.19.0-rc7-armmp-lpae_4.19~rc7-1~exp1_armhf.deb
> > > - linux-image-5.0.0-trunk-armmp_5.0.2-1~exp1_armhf.deb
> > >=20
> > > My guess (I don't have time to try more now) is that the issue is cau=
sed
> > > by the following change:
> > >=20
> > > |  [ Uwe Kleine-K=F6nig ]
> > > |  * [armhf] enable MVNETA_BM_ENABLE and CAN_FLEXCAN as a module
> > >=20
> >=20
> > I confirm this is the issue. Disabling MVNETA_BM_ENABLE on kernel=20
> > 4.19.28-2 fixes the issue. Note that it breaks the ABI.
>=20
> A colleague happens to work with an XP based machine with a (nearly)
> vanilla kernel based on 5.1.0-rc6 and there enabling MVNETA_BM_ENABLE
> doesn't render networking nonfunctional.
>=20
> Looking through the changes to drivers/net/ethernet/marvell/mvneta*
> between 5.0 and 5.1-rc6 there isn't something that would explain a fix
> though. There doesn't seem to be a good explanation in the debian
> specific patches either.
>=20
> So this problem is either machine specific or it works with the mvneta
> driver builtin. (I didn't double check, but guess that my colleague uses
> =3Dy and the Debian kernel =3Dm). Well, or I missed something.

Yes the debian kernel uses:
CONFIG_MVNETA_BM_ENABLE=3Dm
CONFIG_MVNETA=3Dm
CONFIG_MVNETA_BM=3Dm

> Is it possible to test a few things on hartmann? I'd suggest:
>=20
>  - try (vanilla) 5.1-rc6 with MVNETA=3Dy
>  - try an older kernel (maybe 4.6 as the buffer manager stuff was
>    introduced in dc35a10f68d3 ("net: mvneta: bm: add support for
>    hardware buffer management") which made it into 4.6-rc1) with
>    MVNETA_BM_ENABLE=3D[ym].

Ok, I'll try that in the next days. I just do not have remote power,
only serial console, I hope the kernels will boot enough to be able to
roll back to another kernel.

Best regards,
Aurelien

--=20
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                 http://www.aurel32.net

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUryGlb40+QrX1Ay4E4jA+JnoM2sFAlzIxmUACgkQE4jA+Jno
M2uEvQ/9GsrnoeENJ+722WTunziQhdTLAOooTKSEI0Fvgx8eaPkEEvihixD4IIhf
fdWX50dIGyGhmPZh2M/5vPrMBpauG0D+aUnKwCFKcfjfgyK3LcFN+as/CCmvkipx
mVfmojTF0NyjGLUHGzT2fIPJghwOaXx0yf7Z73v1yXXFoMVIgcnYz9sYQVxpgEaC
KIr5+S2nC9trWROgsLN1G0p0MMPtUQ7bt5L7g+a4vTenHmvID9Q0r+fdSo6FTZuM
Y9tOgyiMsDnnD82R2RagMi35ZIujVTAA7CJB2K0uVsIH+bilB87bUEgET8vLzOkZ
Lp3XqBZEDRcQWAg66ErwW1U9BqKTEXTKEDK+Kx0VBPBdFaqIZdkUhrUrwkL1os/F
p0wh982kdTpLTbU8CcG7KBkAk2TQdWwOPH32bdVTTIDqOex+7RtAHbXjxr99Ow/L
Z+fgKKlwJO4/zgN7th/1XW2MluBCh+A/KC1eZDZqeC/hfU3AU1KVu9wF9g0J5Ild
G8Lta801L5/sG8QmW6dUAhISbKknhrSoFTD5XboJqgcrji9d4B8uDMVt5iqYajNi
dNpeVl7G5NFJClcxkglFS8SCq9nY6vv/aImEiyKVMgpqKPvXjpSn+P9tisAa0KrE
p3mtU8d/y4zj4DS/sszp+GRk1Wy/hkiC+wt39ltkj18lpYY63Fw=
=nodR
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--

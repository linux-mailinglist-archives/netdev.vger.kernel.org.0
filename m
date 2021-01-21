Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3F32FE135
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbhAUE4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:56:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726848AbhAUEz7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 23:55:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90D63238E8;
        Thu, 21 Jan 2021 04:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611204911;
        bh=arP/KrUOMem4z2Wvf/y2jWGe9Nv/ZZfor37SphLwbLw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kY1gJCvmHjsvKUvZq9UlyurNQqmmyzAnv0ZnO42OUU6TKyqywqd3cRV6G7er1I2ns
         IRXoVY0JHX21I5afthVgyJkwDTbjvksIfVPxLWwKZA4c5xkOs5h35e7k1x6YPvpvPk
         m+GgTvpH67I9xZKwGdUkbeLSBCoipiEXA0bRMKJkZWceddY3Sl6HoTUnJOw3d8Ij5s
         Y5IwnNNMyfPIm/TAnH4LNPhstcgeW5TGFcPWPi7LPkBjvylE4Smz+pbM84+DQVzJZu
         hfZyv4dEPpr+nI/7RTdAcB8YzE7+xuS06eyCqjqHA8oITunVqZ7I9yR4hbQMb92gAg
         xrOBXNhFs3KIg==
Date:   Wed, 20 Jan 2021 20:55:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Paul Barker <pbarker@konsulko.com>
Cc:     netdev@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next V2] net: dsa: microchip: Adjust reset release
 timing to match reference reset circuit
Message-ID: <20210120205510.4642c92d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cdc34d4b-b384-2f2c-0b8d-070d54edf3c9@gmail.com>
References: <20210120030502.617185-1-marex@denx.de>
        <20210120173127.58445e6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9dd12956-4ddc-b641-185e-a36c7d4d81a9@denx.de>
        <cdc34d4b-b384-2f2c-0b8d-070d54edf3c9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 18:10:59 -0800 Florian Fainelli wrote:
> On 1/20/2021 5:51 PM, Marek Vasut wrote:
> > On 1/21/21 2:31 AM, Jakub Kicinski wrote: =20
> >> On Wed, 20 Jan 2021 04:05:02 +0100 Marek Vasut wrote: =20
> >>> KSZ8794CNX datasheet section 8.0 RESET CIRCUIT describes recommended
> >>> circuit for interfacing with CPU/FPGA reset consisting of 10k pullup
> >>> resistor and 10uF capacitor to ground. This circuit takes ~100 ms to
> >>> rise enough to release the reset.
> >>>
> >>> For maximum supply voltage VDDIO=3D3.3V VIH=3D2.0V R=3D10kR C=3D10uF =
that is
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VDDIO - VIH
> >>> =C2=A0=C2=A0 t =3D R * C * -ln( ------------- ) =3D 10000*0.00001*-(-=
0.93)=3D0.093 s
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VDDIO
> >>> so we need ~95 ms for the reset to really de-assert, and then the
> >>> original 100us for the switch itself to come out of reset. Simply
> >>> msleep() for 100 ms which fits the constraint with a bit of extra
> >>> space.
> >>>
> >>> Fixes: 5b797980908a ("net: dsa: microchip: Implement recommended
> >>> reset timing")
> >>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> >>> Signed-off-by: Marek Vasut <marex@denx.de> =20
> >>
> >> I'm slightly confused whether this is just future proofing or you
> >> actually have a board where this matters. The tree is tagged as
> >> net-next but there is a Fixes tag which normally indicates net+stable.=
 =20
> >=20
> > I have a board where I trigger this problem, that's how I found it. It
> > should be passed to stable too. So the correct tree / tag is "net" ? =20
>=20
> If this is a bug fix for a commit that is not only in 'net-next', then
> yes, targeting 'net' is more appropriate:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/networking/netdev-FAQ.rst#n28

Yup, in that case applied this one and the port map fix to net.

Thanks everyone!

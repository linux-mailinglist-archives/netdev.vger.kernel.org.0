Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D8E43AAF5
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 06:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhJZEGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 00:06:05 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:50047 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhJZEGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 00:06:05 -0400
Received: (Authenticated sender: cyril@debamax.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 616BF24000A;
        Tue, 26 Oct 2021 04:03:38 +0000 (UTC)
Date:   Tue, 26 Oct 2021 06:03:36 +0200
From:   Cyril Brulebois <cyril@debamax.com>
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Nicolas Saenz Julienne <nsaenz@kernel.org>
Subject: Re: GENET and UNIMAC MDIO probe issue?
Message-ID: <20211026040336.eiojc64jf7a3a3ov@debamax.com>
Organization: DEBAMAX
References: <20211022143337.jorflirdb6ctc5or@gilmour>
 <150dcf36-959c-36e3-3b35-74b7ec1db774@i2se.com>
 <20211022155839.ptgazrgyvemfa23q@gilmour>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6wlksnx2oyjltavv"
Content-Disposition: inline
In-Reply-To: <20211022155839.ptgazrgyvemfa23q@gilmour>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6wlksnx2oyjltavv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Maxime Ripard <maxime@cerno.tech> (2021-10-22):
> > looks like you are using the vendor DTB, please use the upstream DTB
> > from linux-next:
> >=20
> > bcm2711-rpi-cm4-io.dtb
>=20
> I thought upstream_kernel would be enough, but following your message
> I forced it using device_tree, and indeed it works.
>=20
> But I'm confused now, I don't have any other DTB for the CM4 on that
> boot partition, where is that other device tree coming from?

It seems to be using the DTB for the Pi 4 B instead, at least judging
by:

    # tr '\0' '\n' < /proc/device-tree/compatible
    raspberrypi,4-model-b
    brcm,bcm2711

For the avoidance of doubt, the relevant /boot/firmware has those files,
copied from the linux-image package without any name changes:

    /boot/firmware/bcm2711-rpi-4-b.dtb
    /boot/firmware/bcm2711-rpi-400.dtb
    /boot/firmware/bcm2711-rpi-cm4-io.dtb
    /boot/firmware/bcm2837-rpi-3-a-plus.dtb
    /boot/firmware/bcm2837-rpi-3-b-plus.dtb
    /boot/firmware/bcm2837-rpi-3-b.dtb
    /boot/firmware/bcm2837-rpi-cm3-io3.dtb

so maybe some fallback to the Pi 4 B happened via the more generic
brcm,bcm2711 compatible fragment?


Initially I was wondering whether there might be some things on the
EEPROM side that might need an update, but wading through some issues
in the raspberrypi/rpi-eeprom repository[1], it seems start.elf is
responsible for passing the dtb file and a quick look into it suggests
there might be a single format string for that: bcm%d-rpi-%s.dtb

 1. https://github.com/raspberrypi/rpi-eeprom

I'm also seeing filename fragments, but nothing that ressembles the io
suffix that's being used for the CM4 upstream DTB.


Since it seems that the bootloader might be expecting =E2=80=9Cvendor DTB=
=E2=80=9D and
the kernel might use different names when it comes to =E2=80=9Cupstream DTB=
=E2=80=9D,
are users/distributions expected to set the proper filename via
device_tree=3D all the time? If that's the case, I hadn't noticed until
now since we used to have things like this in Debian to put files into
place under the =E2=80=9Cexpected filenames=E2=80=9D:

    cp <packaged>/bcm2837-rpi-cm3-io3.dtb /boot/firmware/bcm2710-rpi-cm3.dtb

Nowadays, our raspi-firmware package is just copying the DTB files (as
shipped by linux-image packages, meaning =E2=80=9Cupstream DTB=E2=80=9D nam=
es without
any renaming), so we might have failed to notice a possible need for
this device_tree parameter=E2=80=A6


Cheers,
--=20
Cyril Brulebois -- Debian Consultant @ DEBAMAX -- https://debamax.com/

--6wlksnx2oyjltavv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEHoutkuoaze1Qayc7lZpsmSeGm2EFAmF3fhUACgkQlZpsmSeG
m2HQEw//dPeuOCngehTqief3T0+aKp3SsKQMR0IsUpvJl5rQHXtY9IF/XevEfIVK
zsPD2dG/dHM208r1EDRipA2+X2qH2+3I9KLXCGQAqX44uByqlMhiswn2FTFFDqSt
CP50kpm47+D+VceYBeMUx5C/VIAelywrG/yaL6UY5y3wS9fNyiy6RWTVBZVcNJta
dZD+ucGg2UaQnFyNuaRav0Egaw9RULmpXL5rUfurRXNmY9P2rYrNF6aO2+t6woKm
P1H/4zTKAlrhW/g/8ThedBiC61wmWit04gNae82VrmFXc9pfWonMpGMVReBd8JoX
5hUNLAbSoJa2LQU+0/WBtLgmYRq4P7Ik6FeJnfehLn1+tAMrZIjA0BxJkKJKUCWH
g/NA4yEpmU8eQ8CiBabF5KXjDFUwThDLzIZtxQmMWkPs4wCEFct0dxGnCR0Aevvf
XpsUdyUq2MKsvXN2X5elePP8k+Cvxs2xAcN0JP6kcCGUIscwaIA7koK7gZTkZ00+
CO830C77+y+x56NWWoH9DK1jHMqhbV7tMu5oYhGit61t81Rb+voJc5WR4mz3Vb/s
fb5Y2GU1PoLIktZCLdFRR2eNE9j7vppO3FWDm3Uf6E603b3xUlhrfF4jiVWBNTwR
rA72hK/mdef4YfYdf7AHLooR82uq+yvehKect0PcaJpOmZaMvgo=
=Su1K
-----END PGP SIGNATURE-----

--6wlksnx2oyjltavv--

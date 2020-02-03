Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED80150FB5
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 19:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbgBCSgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 13:36:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:36022 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727491AbgBCSgK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 13:36:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2B527ACB1;
        Mon,  3 Feb 2020 18:36:05 +0000 (UTC)
Message-ID: <45e138de5ddd70e8033bdef6484703eed60a9cb7.camel@suse.de>
Subject: Re: [PATCH 6/6] net: bcmgenet: reduce severity of missing clock
 warnings
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Jeremy Linton <jeremy.linton@arm.com>,
        Stefan Wahren <wahrenst@gmx.net>, netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com
Date:   Mon, 03 Feb 2020 19:36:01 +0100
In-Reply-To: <34aba1d9-5cad-0fee-038d-c5f3bfc9ed30@arm.com>
References: <20200201074625.8698-1-jeremy.linton@arm.com>
         <20200201074625.8698-7-jeremy.linton@arm.com>
         <2dfd6cd2-1dd0-c8ff-8d83-aed3b4ea7a79@gmx.net>
         <34aba1d9-5cad-0fee-038d-c5f3bfc9ed30@arm.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-2GtKugds89inu65PZmZ2"
User-Agent: Evolution 3.34.3 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-2GtKugds89inu65PZmZ2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,
BTW the patch looks good to me too:

Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

On Sat, 2020-02-01 at 13:27 -0600, Jeremy Linton wrote:
> Hi,
>=20
> First, thanks for looking at this!
>=20
> On 2/1/20 10:44 AM, Stefan Wahren wrote:
> > Hi Jeremy,
> >=20
> > [add Nicolas as BCM2835 maintainer]
> >=20
> > Am 01.02.20 um 08:46 schrieb Jeremy Linton:
> > > If one types "failed to get enet clock" or similar into google
> > > there are ~370k hits. The vast majority are people debugging
> > > problems unrelated to this adapter, or bragging about their
> > > rpi's. Given that its not a fatal situation with common DT based
> > > systems, lets reduce the severity so people aren't seeing failure
> > > messages in everyday operation.
> > >=20
> > i'm fine with your patch, since the clocks are optional according to th=
e
> > binding. But instead of hiding of those warning, it would be better to
> > fix the root cause (missing clocks). Unfortunately i don't have the
> > necessary documentation, just some answers from the RPi guys.
>=20
> The DT case just added to my ammunition here :)
>=20
> But really, I'm fixing an ACPI problem because the ACPI power management=
=20
> methods are also responsible for managing the clocks. Which means if I=
=20
> don't lower the severity (or otherwise tweak the code path) these errors=
=20
> are going to happen on every ACPI boot.
>=20
> > This is what i got so far:

Stefan, Apart from the lack of documentation (and maybe also time), is ther=
e
any specific reason you didn't sent the genet clock patch yet? It should be=
 OK
functionally isn't it?

> BTW: For DT, is part of the problem here that the videocore mailbox has=
=20
> a clock management method?

I don't think it'll be the case for these clocks. We try to only use the
mailbox interface if access to the clock is shared with videocore's firmwar=
e.
The only example for now is 'pllb' which drives the CPU. See clk-raspberryp=
i.c
for the firmware part and clk-bcm2835.c for the rest.

Note that the firmware interface has some shortcomings, it isn't fine grain=
ed
nor provides a full clock tree to work with, also some clock changes, from
videocore's point of view, might change multiple plls behind your back. See=
 for
example the ARM clock, at offset 0x3[1]: if you don't explicitly disable tu=
rbo
mode, it'll change both pllb and pllc. Affecting a whole lot of peripherals=
.

In an Ideal world I'd love to see them implement ARM's SCMI[2]. It would ma=
ke
our lives easier.

> For ACPI one of the paths of investigation is to write AML which just
> interfaces to that mailbox interface for clock control here. (there is al=
so
> SCMII to be considered).

As we're on the topic of integrating the mailbox interfaces with ACPI, have=
 you
looked at VCHIQ in the staging directory? It serves as an interface to
videocore for the camera, HDMI audio and video codec drivers. It ultimately
depends on the mailbox interface mentioned above. It might be interesting f=
or
you to look into it before writing the AML interface to the mailbox.

Regards,
Nicolas

[1] https://github.com/raspberrypi/firmware/wiki/Mailbox-property-interface
[2] https://github.com/raspberrypi/firmware/issues/1139


--=-2GtKugds89inu65PZmZ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl44aBEACgkQlfZmHno8
x/45rwf/QSRRNbEoqiSj02LaAKe+BMz+rYKuYE771m2QJ4r9C25KpfQE9Od4qm4w
PralyFBM1NpW2bq3LDuavLB/fq57dgYz7wCPPt8SqV8hLHapnwUXWCot14/6KwGN
RNnxr1Wrxr4ruvnOnY2zzJbT9gf8ofxIrrnKpxoUPF5OFN8XB9il9dU7ctkhYeFP
NjvEJg7t4+pfxUeZ6UA6o7EEZv0sV/IgFeC/T2lzNEH0JCbcLzdyVp/7loCZqOPC
3SGTrtrVgJbHTyIcUQUq76QUNmE671NDfvekz0r1JMEp9qYjPlOw4TS7YRYd73ki
XYwwIsKd2sKs9Jp+DJBmh6LNNNEiGw==
=tAsH
-----END PGP SIGNATURE-----

--=-2GtKugds89inu65PZmZ2--


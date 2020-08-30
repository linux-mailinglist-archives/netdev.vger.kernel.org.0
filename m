Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAFE2570F1
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 00:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgH3W4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 18:56:17 -0400
Received: from mail.nic.cz ([217.31.204.67]:52906 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgH3W4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 18:56:16 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id B75E713FFFB;
        Mon, 31 Aug 2020 00:56:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1598828173; bh=YTHzXCb4ZdLDojUITwXuoxdvQt+Vc8tV3tMINYete5U=;
        h=Date:From:To;
        b=InX6j2UTCOUnMtb9JVcZ9l5pcOhbEsqQeJ2i3YIu1gIyKt42g/+/fTn6s2oeHsAw2
         cuOyst+9NclOWosVIaZ21Dkv4OBHY66dLpB7E7I1UYjgW80nxl8APYORpN4Om+VSG4
         9W+8v+0fBFlZSVwsIsf7MwdsvGqBzXJH+4TOCsNY=
Date:   Mon, 31 Aug 2020 00:56:13 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25k?= =?UTF-8?B?xZllag==?= Jirman 
        <megous@megous.com>, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v4 0/2] Add support for LEDs on
 Marvell PHYs
Message-ID: <20200831005613.3c00215a@nic.cz>
In-Reply-To: <2b3604bf88082f8d8f6d21707907eff757b49362.camel@ew.tq-group.com>
References: <20200728150530.28827-1-marek.behun@nic.cz>
        <2b3604bf88082f8d8f6d21707907eff757b49362.camel@ew.tq-group.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Aug 2020 10:13:59 +0200
Matthias Schiffer <matthias.schiffer@ew.tq-group.com> wrote:

> On Tue, 2020-07-28 at 17:05 +0200, Marek Beh=C3=BAn wrote:
> > Hi,
> >=20
> > this is v4 of my RFC adding support for LEDs connected to Marvell
> > PHYs.
> >=20
> > Please note that if you want to test this, you still need to first
> > apply
> > the patch adding the LED private triggers support from Pavel's tree.
> >  =20
> https://git.kernel.org/pub/scm/linux/kernel/git/pavel/linux-leds.git/comm=
it/?h=3Dfor-next&id=3D93690cdf3060c61dfce813121d0bfc055e7fa30d
> >=20
> > What I still don't like about this is that the LEDs created by the
> > code
> > don't properly support device names. LEDs should have name in format
> > "device:color:function", for example "eth0:green:activity".
> >=20
> > The code currently looks for attached netdev for a given PHY, but
> > at the time this happens there is no netdev attached, so the LEDs
> > gets
> > names without the device part (ie ":green:activity").
> >=20
> > This can be addressed in next version by renaming the LED when a
> > netdev
> > is attached to the PHY, but first a API for LED device renaming needs
> > to
> > be proposed. I am going to try to do that. This would also solve the
> > same problem when userspace renames an interface.
> >=20
> > And no, I don't want phydev name there. =20
>=20
>=20
> Hello Marek,
>=20
> thanks for your patches - Andrew suggested me to have a look at them as
> I'm currently trying to add LED trigger support to the TI DP83867 PHY.
>=20
> Is there already a plan to add support for polarity and similiar
> settings, at least to the generic part of your changes?
>=20

Hello Matthias,

sorry for answering with delay, I somehow overlooked your email.
Yes, I plan to add some basic platform data properties (like polarity)
in the generic part.

> In the TI DP83867, there are 2 separate settings for each LED:
>=20
> - Trigger event
> - Polarity or override (active-high/active-low/force-high/force-low -
> the latter two would be used for led_brightness_set)
> - (There is also a 3rd register that defines the blink frequency, but
> as it allows only a single setting for all LEDs, I would ignore it for
> now)

I think that blink frequency should be in the generic part as well.

>=20
> At least the per-LED polarity setting would be essential to have for
> this feature to be useful for our TQ-Systems mainboards with TI PHYs.
>=20

I will try to send new version next week (starting 7th September).

Marek

>=20
> Kind regards,
> Matthias
>=20
>=20
>=20
> >=20
> > Changes since v3:
> > - addressed some of Andrew's suggestions
> > - phy_hw_led_mode.c renamed to phy_led.c
> > - the DT reading code is now also generic, moved to phy_led.c and
> > called
> >   from phy_probe
> > - the function registering the phydev-hw-mode trigger is now called
> > from
> >   phy_device.c function phy_init before registering genphy drivers
> > - PHY LED functionality now depends on CONFIG_LEDS_TRIGGERS
> >=20
> > Changes since v2:
> > - to share code with other drivers which may want to also offer PHY
> > HW
> >   control of LEDs some of the code was refactored and now resides in
> >   phy_hw_led_mode.c. This code is compiled in when config option
> >   LED_TRIGGER_PHY_HW is enabled. Drivers wanting to offer PHY HW
> > control
> >   of LEDs should depend on this option.
> > - the "hw-control" trigger is renamed to "phydev-hw-mode" and is
> >   registered by the code in phy_hw_led_mode.c
> > - the "hw_control" sysfs file is renamed to "hw_mode"
> > - struct phy_driver is extended by three methods to support PHY HW
> > LED
> >   control
> > - I renamed the various HW control modes offeret by Marvell PHYs to
> >   conform to other Linux mode names, for example the
> > "1000/100/10/else"
> >   mode was renamed to "1Gbps/100Mbps/10Mbps", or "recv/else" was
> > renamed
> >   to "rx" (this is the name of the mode in netdev trigger).
> >=20
> > Marek
> >=20
> >=20
> > Marek Beh=C3=BAn (2):
> >   net: phy: add API for LEDs controlled by PHY HW
> >   net: phy: marvell: add support for PHY LEDs via LED class
> >=20
> >  drivers/net/phy/Kconfig      |   4 +
> >  drivers/net/phy/Makefile     |   1 +
> >  drivers/net/phy/marvell.c    | 287
> > +++++++++++++++++++++++++++++++++++
> >  drivers/net/phy/phy_device.c |  25 ++-
> >  drivers/net/phy/phy_led.c    | 176 +++++++++++++++++++++
> >  include/linux/phy.h          |  51 +++++++
> >  6 files changed, 537 insertions(+), 7 deletions(-)
> >  create mode 100644 drivers/net/phy/phy_led.c
> >  =20
>=20


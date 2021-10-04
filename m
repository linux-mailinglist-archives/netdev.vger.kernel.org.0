Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F79420695
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 09:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhJDH1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 03:27:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhJDH1Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 03:27:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF4E0611C0;
        Mon,  4 Oct 2021 07:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633332328;
        bh=/eBeLCUVqoopFCgbzYbnTztcfapAtM1l3KXDL1LkYLM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=amm8iGMm6beK+gsmV6+hBDRdYNrSXGGGrUwlMtOW34K3nzBZuEZ97+5mgDQa101LS
         Dk92dNu6ZWFw1yxAwN41S+3T7M8EN4m/Zka3AuaGF9dS84z3lRwy1rfu0ZZOiOpIeU
         YD5/HotvNQ0oGhPvnPY2KhSixqOgXSMMkfmaQBCR+YUpdZv9qz40QZtwSIOujKOWnl
         0iidhlrmvsDvyqGjGLtnSiba5vvxGJHiM36dl1RhPxBr3gWB3uF6Cn1TiR58Dj7wlH
         RAyMx4U0i/Q/MDjPdbMAC81MFR5GCWyqU5/0PPqYKFbV05PwGeZhrZnW8htT/7Va2Z
         7hXAlxRgSoXSg==
Date:   Mon, 4 Oct 2021 09:25:24 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: are device names part of sysfs ABI? (was Re: devicename part of
 LEDs under ethernet MAC / PHY)
Message-ID: <20211004092524.023df950@thinkpad>
In-Reply-To: <YVqo64vS4ox9P9hk@kroah.com>
References: <20211001133057.5287f150@thinkpad>
        <YVb/HSLqcOM6drr1@lunn.ch>
        <20211001144053.3952474a@thinkpad>
        <20211003225338.76092ec3@thinkpad>
        <YVqhMeuDI0IZL/zY@kroah.com>
        <20211004090438.588a8a89@thinkpad>
        <YVqo64vS4ox9P9hk@kroah.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Oct 2021 09:10:35 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Mon, Oct 04, 2021 at 09:04:38AM +0200, Marek Beh=C3=BAn wrote:
> > Hi Greg,
> >=20
> > On Mon, 4 Oct 2021 08:37:37 +0200
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >  =20
> > > On Sun, Oct 03, 2021 at 10:53:38PM +0200, Marek Beh=C3=BAn wrote: =20
> > > > Hello Greg,
> > > >=20
> > > > could you give your opinion on this discussion?   =20
> > >=20
> > > What discussion?  Top posting ruins that :( =20
> >=20
> > Sorry, the discussion is here
> > https://lore.kernel.org/linux-leds/20211001144053.3952474a@thinkpad/T/
> > But the basic question is below, so you don't need to read the
> > discussion.
> >  =20
> > > > Are device names (as returned by dev_name() function) also part of
> > > > sysfs ABI? Should these names be stable across reboots / kernel
> > > > upgrades?   =20
> > >=20
> > > Stable in what exact way? =20
> >=20
> > Example:
> > - Board has an ethernet PHYs that is described in DT, and therefore
> >   has stable sysfs path (derived from DT path), something like
> >     /sys/devices/.../mdio_bus/f1072004.mdio-mii/f1072004.mdio-mii:01 =20
>=20
> None of the numbers there are "stable", right?
>=20
> > - The PHY has a subnode describing a LED.
> >   The LED subsystem has a different naming scheme (it uses DT node name
> >   as a last resort). When everything is okay, the dev_name() of the LED
> >   will be something like
> >     ethphy42:green:link =20
>=20
> Wonderful, but the "42" means nothing.
>=20
> > - Now suppose that the PHY driver is unloaded and loaded again. The PHY
> >   sysfs path is unchanged, but the LED will now be named
> >     ethphy43:green:link
> >=20
> > Is this OK? =20
>=20
> Yup!
>=20
> The "link" should point to the device it is associated with, right?  You
> need to have some way to refer to the device.
>=20
> > > Numbering of devices (where a dynamic value is part of a name, like t=
he
> > > "42" in "usb42"), is never guaranteed to be stable, but the non-number
> > > part of the name (like "usb" is in "usb42") is stable, as that is what
> > > you have properly documented in the Documentation/ABI/ files defining
> > > the bus and class devices, right? =20
> >=20
> > It does make sense for removable devices like USB. What I am asking
> > is whether it is also OK for devices that have stable DT nodes. =20
>=20
> Any device can be "removed" from the system and added back thanks to the
> joy of the driver model :)
>=20
> Also, what prevents your DT from renumbering things in an update to it
> in the future?  The kernel doesn't care, and userspace should be able to
> handle it.
>=20
> Again, any numbering scheme is NEVER stable, just because it feels like
> it is at the moment for your device, you should NEVER rely on that, but
> instead rely on the attributes of the device to determine what it is and
> where it is in the device hierarchy (serial number, position location,
> partition name, etc.) in order to know what it associated with.
>=20
> And again, this is 1/2 of the whole reason _why_ we created the unified
> driver model in the kernel.  Don't try to go back to the nightmare that
> we had in the 2.4 and earlier kernel days please.

OK, thanks Greg. This simplifies things. I shall send another version
of LEDs under ethernet PHYs soon :)

Marek

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D542B420663
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 09:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhJDHGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 03:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhJDHGc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 03:06:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 914AD6124B;
        Mon,  4 Oct 2021 07:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633331084;
        bh=OKUSOF07/n/y2dR8v/yi4VOQ4OUU4NE2UhFRomwTx8M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EUKNpgPPtM8094X8SmAIm2hT42fGK7yvuuLUN2I7mUlTrTytOmm/JiTQsvn8Bez/r
         kip6LBYCLpo49T4v6ldE2J6wGHQNm39BuhBJHUdXzPh3HhTa5WgRaynN83CxESTRW5
         LdkH8tgDXHe/wK3VycEIQJ+sVvM8votJGkbB0I6UgteFAqGFDgP6UsYvgbyFd+0Px1
         87ObU0NfiS6xX3Qd5nxVrqiaqCzWgjm34NbsiNaCGL/uTfOwImN/ZYtE07kV9ZAKGl
         +qRhd7AQ4FE6qhbSREdnpBbUTmpoF1b5ZMwNJNOqW/rJcy8CJXWxraKmSFvQVLr7nI
         oxFA4VXdKh3UQ==
Date:   Mon, 4 Oct 2021 09:04:38 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: are device names part of sysfs ABI? (was Re: devicename part of
 LEDs under ethernet MAC / PHY)
Message-ID: <20211004090438.588a8a89@thinkpad>
In-Reply-To: <YVqhMeuDI0IZL/zY@kroah.com>
References: <20211001133057.5287f150@thinkpad>
        <YVb/HSLqcOM6drr1@lunn.ch>
        <20211001144053.3952474a@thinkpad>
        <20211003225338.76092ec3@thinkpad>
        <YVqhMeuDI0IZL/zY@kroah.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Mon, 4 Oct 2021 08:37:37 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Sun, Oct 03, 2021 at 10:53:38PM +0200, Marek Beh=C3=BAn wrote:
> > Hello Greg,
> >=20
> > could you give your opinion on this discussion? =20
>=20
> What discussion?  Top posting ruins that :(

Sorry, the discussion is here
https://lore.kernel.org/linux-leds/20211001144053.3952474a@thinkpad/T/
But the basic question is below, so you don't need to read the
discussion.

> > Are device names (as returned by dev_name() function) also part of
> > sysfs ABI? Should these names be stable across reboots / kernel
> > upgrades? =20
>=20
> Stable in what exact way?

Example:
- Board has an ethernet PHYs that is described in DT, and therefore
  has stable sysfs path (derived from DT path), something like
    /sys/devices/.../mdio_bus/f1072004.mdio-mii/f1072004.mdio-mii:01

- The PHY has a subnode describing a LED.
  The LED subsystem has a different naming scheme (it uses DT node name
  as a last resort). When everything is okay, the dev_name() of the LED
  will be something like
    ethphy42:green:link

- Now suppose that the PHY driver is unloaded and loaded again. The PHY
  sysfs path is unchanged, but the LED will now be named
    ethphy43:green:link

Is this OK?

> Numbering of devices (where a dynamic value is part of a name, like the
> "42" in "usb42"), is never guaranteed to be stable, but the non-number
> part of the name (like "usb" is in "usb42") is stable, as that is what
> you have properly documented in the Documentation/ABI/ files defining
> the bus and class devices, right?

It does make sense for removable devices like USB. What I am asking
is whether it is also OK for devices that have stable DT nodes.

Marek

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118EB420675
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 09:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhJDHM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 03:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229484AbhJDHM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 03:12:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B6126124D;
        Mon,  4 Oct 2021 07:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633331438;
        bh=wxQMgh47EITAIUhAsP0hL+YuY3VdMgjXAZPx4dZXs/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gsfN3cobrt55Lq7+W4abDXGNrYMXTDWaW97vyAt0bwKFTpi1MbVGD8rK5tLcR5P5t
         p3MUlmtdldOGo37jvwx/46u6VqXgnHhtygxp6DEu4qWn+/VE/i0NBMp5kAuPmtTkHt
         psdFPQMjGfSvZf8WjJPFS+PEQ+3TQg8StP9BGqSg=
Date:   Mon, 4 Oct 2021 09:10:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: are device names part of sysfs ABI? (was Re: devicename part of
 LEDs under ethernet MAC / PHY)
Message-ID: <YVqo64vS4ox9P9hk@kroah.com>
References: <20211001133057.5287f150@thinkpad>
 <YVb/HSLqcOM6drr1@lunn.ch>
 <20211001144053.3952474a@thinkpad>
 <20211003225338.76092ec3@thinkpad>
 <YVqhMeuDI0IZL/zY@kroah.com>
 <20211004090438.588a8a89@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211004090438.588a8a89@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 09:04:38AM +0200, Marek Behún wrote:
> Hi Greg,
> 
> On Mon, 4 Oct 2021 08:37:37 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Sun, Oct 03, 2021 at 10:53:38PM +0200, Marek Behún wrote:
> > > Hello Greg,
> > > 
> > > could you give your opinion on this discussion?  
> > 
> > What discussion?  Top posting ruins that :(
> 
> Sorry, the discussion is here
> https://lore.kernel.org/linux-leds/20211001144053.3952474a@thinkpad/T/
> But the basic question is below, so you don't need to read the
> discussion.
> 
> > > Are device names (as returned by dev_name() function) also part of
> > > sysfs ABI? Should these names be stable across reboots / kernel
> > > upgrades?  
> > 
> > Stable in what exact way?
> 
> Example:
> - Board has an ethernet PHYs that is described in DT, and therefore
>   has stable sysfs path (derived from DT path), something like
>     /sys/devices/.../mdio_bus/f1072004.mdio-mii/f1072004.mdio-mii:01

None of the numbers there are "stable", right?

> - The PHY has a subnode describing a LED.
>   The LED subsystem has a different naming scheme (it uses DT node name
>   as a last resort). When everything is okay, the dev_name() of the LED
>   will be something like
>     ethphy42:green:link

Wonderful, but the "42" means nothing.

> - Now suppose that the PHY driver is unloaded and loaded again. The PHY
>   sysfs path is unchanged, but the LED will now be named
>     ethphy43:green:link
> 
> Is this OK?

Yup!

The "link" should point to the device it is associated with, right?  You
need to have some way to refer to the device.

> > Numbering of devices (where a dynamic value is part of a name, like the
> > "42" in "usb42"), is never guaranteed to be stable, but the non-number
> > part of the name (like "usb" is in "usb42") is stable, as that is what
> > you have properly documented in the Documentation/ABI/ files defining
> > the bus and class devices, right?
> 
> It does make sense for removable devices like USB. What I am asking
> is whether it is also OK for devices that have stable DT nodes.

Any device can be "removed" from the system and added back thanks to the
joy of the driver model :)

Also, what prevents your DT from renumbering things in an update to it
in the future?  The kernel doesn't care, and userspace should be able to
handle it.

Again, any numbering scheme is NEVER stable, just because it feels like
it is at the moment for your device, you should NEVER rely on that, but
instead rely on the attributes of the device to determine what it is and
where it is in the device hierarchy (serial number, position location,
partition name, etc.) in order to know what it associated with.

And again, this is 1/2 of the whole reason _why_ we created the unified
driver model in the kernel.  Don't try to go back to the nightmare that
we had in the 2.4 and earlier kernel days please.

thanks,

greg k-h

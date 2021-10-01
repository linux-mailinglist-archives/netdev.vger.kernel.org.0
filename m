Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DD241EDAE
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 14:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354403AbhJAMmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 08:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231352AbhJAMml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 08:42:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 535F3619EC;
        Fri,  1 Oct 2021 12:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633092057;
        bh=6uhWW7FTN4K3UNWUrnTlssSq9i2l2Xj7wJq28RUxb9c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b3+cfY6IK7cpTu1vlVcS5a286fKvSXOusXvVIPafZW3mxo+PSm51wHRgmKYiR4K+H
         ni5V0MnolPy5ncOYkWL7ie7zgg4IXzb47dhrXFpFmEz6fHF5D+jDEwCt7Gox0LYZgd
         eAr8kCxAspLH69xiKhHf6ar9oT5WYj1pCW76+PbhrvZUU3n2qocpeQ9czYutnfWA30
         ZpMDxgbN1jTQmtj4g5LH4ryCxt7NTJtHKeRwjXvYvNntEfl8pXUXyGsAyFmA46ZbA1
         DtoPD0zMIrowJfdSuMX8aIZlI5M9HIj3vBiSxrm8XDzoHMoI5Ks7vIQ5lzao78rIfb
         TLMK9VV1FaGVQ==
Date:   Fri, 1 Oct 2021 14:40:53 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>
Subject: Re: devicename part of LEDs under ethernet MAC / PHY
Message-ID: <20211001144053.3952474a@thinkpad>
In-Reply-To: <YVb/HSLqcOM6drr1@lunn.ch>
References: <20211001133057.5287f150@thinkpad>
        <YVb/HSLqcOM6drr1@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Oct 2021 14:29:17 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > - Andrew proposed that the numbering should start at non-zero number,
> >   for example at 42, to prevent people from thinking that the numbers
> >   are related to numbers in network interface names (ethN).
> >   A system with interfaces
> >     eth0
> >     eth1
> >   and LEDs
> >     ethphy0:green:link
> >     ethphy1:green:link
> >   may make user think that the ethphy0 LED does correspond to eth0
> >   interface, which is not necessarily true.
> >   Instead if LEDs are
> >     ethphy42:green:link
> >     ethphy43:green:link 
> >   the probability of confusing the user into relating them to network
> >   interfaces by these numbers is lower.
> > 
> > Anyway, the issue with these naming is that it is not stable. Upgrading
> > the kernel, enabling drivers and so on can change these names between
> > reboots.  
> 
> Sure, eth0 can become eth1, eth1 can become eth0. That is why we have
> udev rules, systemd interface names etc. Interface names have never
> been guaranteed to be stable. Also, you can have multiple interfaces
> named eth0, so long as they are in different network name spaces.
> 
> > Also for LEDs on USB ethernet adapters, removing the USB and
> > plugging it again would change the name, although the device path does
> > not change if the adapter is re-plugged into the same port.
> > 
> > To finally settle this then, I would like to ask your opinion on
> > whether this naming of LEDs should be stable.  
> 
> No. They should be unstable like everything else.

LED classdev names are something different.
For etherent interfaces, the interface name is different from name of
the underlying struct device. But LED classdev names are also
corresponding struct device names, and thus part of sysfs ABI, which,
as far as I understand, should be stable.

> > Note that this names are visible to userspace as symlinks
> > /sys/class/leds directory. If they are unstable, it is not that big an
> > issue, because mostly these LEDs should be accessed via
> > /sys/class/net/<interface>/device/leds for eth MAC LEDs and via
> > /sys/class/net/<interface>/phydev/leds for eth PHY LEDs.  
> 
> Yes, this also handles network name space nicely.
> 
> > If we wanted to make these names stable, we would need to do something
> > like
> >   ethphy-BUS-ID
> > for example
> >   ethphy-usb3,2
> >   ethmac-pci0,19,0
> >   ethphy-mdio0,1
> > or
> >   ethmac-DEVICE_PATH (with '/'s and ':'s replaced with ',' or something)
> > for example
> >   ethphy-platform,soc,soc,internal-regs,f10f0000.usb3,usb3,3-0,1:0  
> 
> I guess Systemd can be extended to do this, maybe, rename the LEDs
> when it renames the interface? This is not really a kernel problem.

Pavel is against LED classdev renaming.

Marek

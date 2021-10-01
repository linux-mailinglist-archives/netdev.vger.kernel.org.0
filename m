Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6EAC41ED71
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 14:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353100AbhJAMbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 08:31:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42990 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230162AbhJAMbK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 08:31:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YmZHWM7bd2SH/9CTsa4b9Iv+r11wfWkL+jXp2O0WySU=; b=uViTAoNSqKihuM8ET+58X2CQSl
        Y8MEqX49vcARfQfQzHgDsZpaFf+dJ1Auvn+7iSL/6V3QgH4rIidiNxURn3O/fZK5e5gO0EaJXLiCo
        f/UB3uk5HRLB3KXLBialbD7ym38upcxD3saTfKMctrqgKZC4aIm9QCJzPRxECE6ZDIRQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mWHfB-0095vl-AT; Fri, 01 Oct 2021 14:29:17 +0200
Date:   Fri, 1 Oct 2021 14:29:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>
Subject: Re: devicename part of LEDs under ethernet MAC / PHY
Message-ID: <YVb/HSLqcOM6drr1@lunn.ch>
References: <20211001133057.5287f150@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211001133057.5287f150@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> - Andrew proposed that the numbering should start at non-zero number,
>   for example at 42, to prevent people from thinking that the numbers
>   are related to numbers in network interface names (ethN).
>   A system with interfaces
>     eth0
>     eth1
>   and LEDs
>     ethphy0:green:link
>     ethphy1:green:link
>   may make user think that the ethphy0 LED does correspond to eth0
>   interface, which is not necessarily true.
>   Instead if LEDs are
>     ethphy42:green:link
>     ethphy43:green:link 
>   the probability of confusing the user into relating them to network
>   interfaces by these numbers is lower.
> 
> Anyway, the issue with these naming is that it is not stable. Upgrading
> the kernel, enabling drivers and so on can change these names between
> reboots.

Sure, eth0 can become eth1, eth1 can become eth0. That is why we have
udev rules, systemd interface names etc. Interface names have never
been guaranteed to be stable. Also, you can have multiple interfaces
named eth0, so long as they are in different network name spaces.

> Also for LEDs on USB ethernet adapters, removing the USB and
> plugging it again would change the name, although the device path does
> not change if the adapter is re-plugged into the same port.
> 
> To finally settle this then, I would like to ask your opinion on
> whether this naming of LEDs should be stable.

No. They should be unstable like everything else.

> Note that this names are visible to userspace as symlinks
> /sys/class/leds directory. If they are unstable, it is not that big an
> issue, because mostly these LEDs should be accessed via
> /sys/class/net/<interface>/device/leds for eth MAC LEDs and via
> /sys/class/net/<interface>/phydev/leds for eth PHY LEDs.

Yes, this also handles network name space nicely.

> If we wanted to make these names stable, we would need to do something
> like
>   ethphy-BUS-ID
> for example
>   ethphy-usb3,2
>   ethmac-pci0,19,0
>   ethphy-mdio0,1
> or
>   ethmac-DEVICE_PATH (with '/'s and ':'s replaced with ',' or something)
> for example
>   ethphy-platform,soc,soc,internal-regs,f10f0000.usb3,usb3,3-0,1:0

I guess Systemd can be extended to do this, maybe, rename the LEDs
when it renames the interface? This is not really a kernel problem.

     Andrew

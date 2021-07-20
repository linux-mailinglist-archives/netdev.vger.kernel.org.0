Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16CB3CFE7F
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbhGTPSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 11:18:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36634 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242457AbhGTPCf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 11:02:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8oLMUiTlHOQnZclvIoCpKJmXKyqxMy3gdTxy3e0jymg=; b=EQrP/tuUKtmzzo+zhCCBok+K5M
        E4g3EGeg0Av70ZdC3ntuZ9LmjeUScutRqLDVT/62isKpDe86KcvygZRUy1+J4Y5pDnOHIu6o6+z25
        1NbIHbhpo7IuaVyPvwPBd+krxJN+xnid05c9mMHQ9Xg6RnlMRFjtunxQHCUN3PKPT9mg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5rtL-00E4gt-A0; Tue, 20 Jul 2021 17:42:43 +0200
Date:   Tue, 20 Jul 2021 17:42:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Pavel Machek <pavel@ucw.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <YPbu8xOFDRZWMTBe@lunn.ch>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com>
 <YPTKB0HGEtsydf9/@lunn.ch>
 <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I checked the LED subsystem and didn't find a way to place the LED
> sysfs files in a place other than /sys/class/leds. Maybe Pavel can
> comment on whether I just missed something.

https://lwn.net/ml/linux-kernel/20200908000300.6982-1-marek.behun@nic.cz/

It comments the sys files appear under
/sys/class/net/<ifname>/phydev/leds/. phydev is a symbolic link to the
phy devices, provided by the phydev subsystem. So they are actually
attached to the PHY device. And this appears to be due to:

	ret = devm_led_classdev_register_ext(&phydev->mdio.dev, &led->cdev, &init_data);

The LEDs are parented to the phy device. This has the nice side affect
that PHYs are not part of the network name space. You can rename the
interface, /sys/class/net/<ifname> changes, but the symbolic link
still points to the phy device.

When not using phydev, it probably gets trickier. You probably want
the LEDs parented to the PCI device, and you need to follow a
different symbolic link out of /sys/class/net/<ifname>/ to find the
LED.

There was talk of adding an ledtool, which knows about these
links. But i pushed for it to be added to ethtool. Until we get an
implementation actually merged, that is academic.

> For r8169 I'm facing a similar challenge like Kurt. Most family
> members support three LED's:
> - Per LED a mode 0 .. 15 can be set that defines which link speed(s)
>   and/or activity is indicated.
> - Period and duty cycle for blinking can be controlled, but this
>   setting applies to all three LED's.

Cross LED settings is a problem. The Marvell PHYs have a number of
independent modes. Plus they have some shared modes which cross LEDs.
At the moment, there is no good model for these shared modes.

We have to look at the trade offs here. At the moment we have at least
3 different ways of setting PHY LEDs via DT. Because each driver does
it its own way, it probably allows full access to all features. But it
is very unfriendly. Adopting Linux LEDs allows us to have a single
uniform API for all these PHY LEDs, and probably all MAC drivers which
don't use PHY drivers. But at the expense of probably not supporting
all features of the hardware. My opinion is, we should ignore some of
the hardware features in order to get a simple to use uniform
interface for all LEDs, which probably covers the features most people
are interested in anyway.

	Andrew

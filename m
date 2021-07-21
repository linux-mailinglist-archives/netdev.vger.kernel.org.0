Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9623D1698
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 20:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239287AbhGUSFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 14:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231535AbhGUSFM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 14:05:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C5766121E;
        Wed, 21 Jul 2021 18:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626893149;
        bh=ESMnGGV4g5NlSlbPQ/VY5dMDhdeWacNJdDLjMiDrnek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tQUZmDTWThp2RXBpnHq6rDOZU1MQH7LCc5aG9HUFubBDCi6JMpHqq4FyM28/zPcR+
         HJjeCnj3oDrKW5/aIjQKL59QLEyo9/dS6VdD5bPztOXh3lDs+ZlwBc3UEe65GXgyQO
         tLpBQ0MtsztZ2aG0mzfAP3P2ASi1LyXcF0E7g3+pAi0B9jXmqKEQDJuoR3GpVDn5Nm
         qQGw/8vZeX7jy2J9gNtbsWmM1b/HMCKj61C0ucvQjcjKArGVlLpSYUgjE1Kjm0Zw03
         75yRkqljQ4zKPxyGjGITk3N4uSiVfw5BQcyyuDl9mBcNg0KaUtZbv8uMFuhS3HAWgM
         eoNzufp2Klv+A==
Date:   Wed, 21 Jul 2021 20:45:43 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Pavel Machek <pavel@ucw.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210721204543.08e79fac@thinkpad>
In-Reply-To: <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
        <20210716212427.821834-6-anthony.l.nguyen@intel.com>
        <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com>
        <YPTKB0HGEtsydf9/@lunn.ch>
        <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
        <YPbu8xOFDRZWMTBe@lunn.ch>
        <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Jul 2021 22:29:21 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 20.07.2021 17:42, Andrew Lunn wrote:
> >> I checked the LED subsystem and didn't find a way to place the LED
> >> sysfs files in a place other than /sys/class/leds. Maybe Pavel can
> >> comment on whether I just missed something.  
> > 
> > https://lwn.net/ml/linux-kernel/20200908000300.6982-1-marek.behun@nic.cz/
> > 
> > It comments the sys files appear under
> > /sys/class/net/<ifname>/phydev/leds/. phydev is a symbolic link to the
> > phy devices, provided by the phydev subsystem. So they are actually
> > attached to the PHY device. And this appears to be due to:
> > 
> > 	ret = devm_led_classdev_register_ext(&phydev->mdio.dev, &led->cdev, &init_data);
> > 
> > The LEDs are parented to the phy device. This has the nice side affect
> > that PHYs are not part of the network name space. You can rename the
> > interface, /sys/class/net/<ifname> changes, but the symbolic link
> > still points to the phy device.
> > 
> > When not using phydev, it probably gets trickier. You probably want
> > the LEDs parented to the PCI device, and you need to follow a
> > different symbolic link out of /sys/class/net/<ifname>/ to find the
> > LED.
> > 
> > There was talk of adding an ledtool, which knows about these
> > links. But i pushed for it to be added to ethtool. Until we get an
> > implementation actually merged, that is academic.
> >   
> >> For r8169 I'm facing a similar challenge like Kurt. Most family
> >> members support three LED's:
> >> - Per LED a mode 0 .. 15 can be set that defines which link speed(s)
> >>   and/or activity is indicated.
> >> - Period and duty cycle for blinking can be controlled, but this
> >>   setting applies to all three LED's.  
> > 
> > Cross LED settings is a problem. The Marvell PHYs have a number of
> > independent modes. Plus they have some shared modes which cross LEDs.
> > At the moment, there is no good model for these shared modes.
> > 
> > We have to look at the trade offs here. At the moment we have at least
> > 3 different ways of setting PHY LEDs via DT. Because each driver does
> > it its own way, it probably allows full access to all features. But it
> > is very unfriendly. Adopting Linux LEDs allows us to have a single
> > uniform API for all these PHY LEDs, and probably all MAC drivers which
> > don't use PHY drivers. But at the expense of probably not supporting
> > all features of the hardware. My opinion is, we should ignore some of
> > the hardware features in order to get a simple to use uniform
> > interface for all LEDs, which probably covers the features most people
> > are interested in anyway.
> >   
> 
> Thanks for the hint, Andrew. If I make &netdev->dev the parent,
> then I get:
> 
> ll /sys/class/leds/
> total 0
> lrwxrwxrwx 1 root root 0 Jul 20 21:37 led0 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/led0
> lrwxrwxrwx 1 root root 0 Jul 20 21:37 led1 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/led1
> lrwxrwxrwx 1 root root 0 Jul 20 21:37 led2 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/led2
> 
> Now the (linked) LED devices are under /sys/class/net/<ifname>, but still
> the primary LED devices are under /sys/class/leds and their names have
> to be unique therefore. The LED subsystem takes care of unique names,
> but in case of a second network interface the LED device name suddenly
> would be led0_1 (IIRC). So the names wouldn't be predictable, and I think
> that's not what we want.
> We could use something like led0_<pci_id>, but then userspace would have
> to do echo foo > /sys/class/net/<ifname>/led0*/bar, and that's also not
> nice.

Hi Heiner,

in sysfs, all devices registered under LED class will have symlinks in
/sys/class/leds. This is how device classes work in Linux.

There is a standardized format for LED device names, please look at
Documentation/leds/leds-class.rst.

Basically the LED name is of the format
  devicename:color:function

The list of colors and functions is defined in
  include/dt-bindings/leds/common.h

The function part of the LED is also supposed to (in the future)
specify trigger, i.e. something like:
  if the function is "activity", the LED should blink on network
  activity
(Note that there is not yet a consensus. Jacek, for example, is of the
 opinion that the "activity" function should imply the CPU activity
 trigger. I think that "activity" function together with trigger-source
 defined to be a network device should imply network activity.)

Does your driver register the LEDs based on device-tree?

If so, then LED core will compose the name for the device for you.

If not, then you need to compose the name (in the above format)
yourself.

Are your LEDs controlled by an ethernet PHY, or by the MAC itself?

Marek

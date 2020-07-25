Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA3522D9EE
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 22:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgGYU6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 16:58:44 -0400
Received: from mail.nic.cz ([217.31.204.67]:40542 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727818AbgGYU6o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 16:58:44 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 77C9C140713;
        Sat, 25 Jul 2020 22:58:41 +0200 (CEST)
Date:   Sat, 25 Jul 2020 22:58:40 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25kxZllag==?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v3 2/2] net: phy: marvell: add
 support for PHY LEDs via LED class
Message-ID: <20200725225840.4202dcac@nic.cz>
In-Reply-To: <20200725184846.GO1472201@lunn.ch>
References: <20200724164603.29148-1-marek.behun@nic.cz>
        <20200724164603.29148-3-marek.behun@nic.cz>
        <20200725172318.GK1472201@lunn.ch>
        <20200725200224.3f03c041@nic.cz>
        <20200725184846.GO1472201@lunn.ch>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jul 2020 20:48:46 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > > > +#if 0
> > > > +	/* LED_COLOR_ID_MULTI is not yet merged in Linus' tree */
> > > > +	/* TODO: Support DUAL MODE */
> > > > +	if (color == LED_COLOR_ID_MULTI) {
> > > > +		phydev_warn(phydev, "node %pOF: This driver does not yet support multicolor LEDs\n",
> > > > +			    np);
> > > > +		return -ENOTSUPP;
> > > > +	}
> > > > +#endif    
> > > 
> > > Code getting committed should not be using #if 0. Is the needed code
> > > in the LED tree? Do we want to consider a stable branch of the LED
> > > tree which DaveM can pull into net-next? Or do you want to wait until
> > > the next merge cycle?  
> > 
> > That's why this is RFC. But yes, I would like to have this merged for
> > 5.9, so maybe we should ask Dave. Is this common? Do we also need to
> > tell Pavel or how does this work?  
> 
> The Pavel needs to create a stable branch. DaveM then merges that
> branch into net-next. Your patches can then be merged. When Linus
> pulls the two branches, led and net-next, git sees the exact same
> patches twice, and simply drops them from the second pull request.
> 
> So you need to ask Pavel and DaveM if they are willing to do this.
> 
> > > > +	init_data.fwnode = &np->fwnode;
> > > > +	init_data.devname_mandatory = true;
> > > > +	init_data.devicename = phydev->attached_dev ? netdev_name(phydev->attached_dev) : "";    
> > > 
> > > This we need to think about. Are you running this on a system with
> > > systemd? Does the interface have a name like enp2s0? Does the LED get
> > > registered before or after systemd renames it from eth0 to enp2s0?  
> > 
> > Yes, well, this should be discussed also with LED guys. I don't suppose
> > that renaming the sysfs symlink on interface rename event is
> > appropriate, but who knows?
> > The interfaces are platform specific, on mvebu. They aren't connected
> > via PCI, so their names remain eth0, eth1 ...  
> 
> But the Marvell driver is used with more than just mvebu. And we need
> this generic. There are USB Ethernet dongles which used phylib. They
> will get their interfaces renamed to include the MAC address, etc.
> 
> It is possible to hook the notifier so we know when an interface is
> renamed. We can then either destroy and re-create the LED, or if the
> LED framework allows it, rename it.
> 
> Or we avoid interface names all together and stick with the phy name,
> which is stable. To make it more user friendly, you could create
> additional symlinks. We already have /sys/class/net/ethX/phydev
> linking into sys/bus/mdio_bus/devices/.. .  We could add
> /sys/class/net/ethX/ledY linking into /sys/class/led/...
> 
> It would also be possible to teach ethtool about LEDs, so that it
> follows the symbolic links, and manipulates the LED class files.

I will propose rename of the LED name on interface rename event.

> > I also want this code to be generalized somehow so that it can be
> > reused. The problem is that I want to have support for DUAL mode, which
> > is Marvell specific, and a DUAL LED needs to be defined in device tree.  
> 
> It sounds like you first need to teach the LED core about dual LEDs
> and triggers which affect two LEDs..

This is already done. DUAL LEDs will be handled by the multicolor LED
framework which also is already in Pavel's tree. The problem is that if
we make PHY LEDs OF parsing code generic in phy-core, it will also need
to be robust enough to take care of DUAL LEDs OF parsing. That is
something which is Marvell specific. It is possible that some other
vendor also manufactures PHYs with something like that, but the LEDs
on other PHYs may have different maximum value of brightness, or
additional configurations which will need to be in device tree...

But I will try to make it generic and then we will see where it goes...

Marek


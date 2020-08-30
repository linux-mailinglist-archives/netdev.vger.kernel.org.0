Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A203A256B18
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 03:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgH3BuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 21:50:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728439AbgH3BuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 21:50:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kCCTt-00CSEg-Qh; Sun, 30 Aug 2020 03:50:05 +0200
Date:   Sun, 30 Aug 2020 03:50:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v4 0/2] Add support for LEDs on
 Marvell PHYs
Message-ID: <20200830015005.GD2966560@lunn.ch>
References: <20200728150530.28827-1-marek.behun@nic.cz>
 <20200807090653.ihnt2arywqtpdzjg@duo.ucw.cz>
 <20200807132920.GB2028541@lunn.ch>
 <20200829224351.GA29564@duo.ucw.cz>
 <20200829233641.GC2966560@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200829233641.GC2966560@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > You could make a good guess at matching to two together, but it is
> > > error prone. Phys are low level things which the user is not really
> > > involved in. They interact with interface names. ethtool, ip, etc, all
> > > use interface names. In fact, i don't know of any tool which uses
> > > phydev names.
> > 
> > So... proposal:
> > 
> > Users should not be dealing with sysfs interface directly, anyway. We
> > should have a tool for that. It can live in kernel/tools somewhere, I
> > guess.
> 
> We already have one, ethtool(1). 
> 
> > 
> > Would we name leds phy0:... (with simple incrementing number), and
> > expose either interface name or phydev name as a attribute?
> > 
> > So user could do
> > 
> > cat /sys/class/leds/phy14:green:foobar/netdev
> > lan5@eth1:

I forgot about network name spaces. There can be multiple interfaces
with the name eth0, each in its own network namespace. For your
proposal to work, /sys/class/leds/phy14:green:foobar needs to be in
the network namespace, so it is only visible to other processes in the
same name space, and lan5@eth1 is then unique to that namespace.

> Which is the wrong way around. ethtool will be passed the interface
> name and an PHY descriptor of some sort, and it has to go search
> through all the LEDs to find the one with this attribute. I would be
> much more likely to add a sysfs link from
> /sys/class/net/lan5/phy:left:green to
> /sys/class/leds/phy14:left:green.

I need to test a bit, but i think this works. Everything under
/sys/class/net is network namespace aware. You only see
/sys/class/net/lan5 if there is a lan5 is in the current name space,
and you see the current namespaces version of lan5.. A sysfs symlink
out of namespace to /sys/class/led should work, assuming
/sys/class/led is namespace unaware, and phy14 is unique across all
network name spaces. But you cannot have a link in the opposite
direction from /sys/class/led/phy14 to /sys/class/net/lan5, since it
has no idea which lan5 to symlink to.

    Andrew

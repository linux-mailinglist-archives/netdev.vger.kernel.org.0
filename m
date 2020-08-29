Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACBE2256AC4
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 01:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgH2XhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 19:37:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60278 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726995AbgH2XhA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 19:37:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kCAOn-00CRu3-NN; Sun, 30 Aug 2020 01:36:41 +0200
Date:   Sun, 30 Aug 2020 01:36:41 +0200
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
Message-ID: <20200829233641.GC2966560@lunn.ch>
References: <20200728150530.28827-1-marek.behun@nic.cz>
 <20200807090653.ihnt2arywqtpdzjg@duo.ucw.cz>
 <20200807132920.GB2028541@lunn.ch>
 <20200829224351.GA29564@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200829224351.GA29564@duo.ucw.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 30, 2020 at 12:43:51AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > And no, I don't want phydev name there.
> > > 
> > > Ummm. Can we get little more explanation on that? I fear that LED
> > > device renaming will be tricky and phydev would work around that
> > > nicely.
> > 
> > Hi Pavel
> > 
> > The phydev name is not particularly nice:
> > 
> > !mdio-mux!mdio@1!switch@0!mdio:00
> > !mdio-mux!mdio@1!switch@0!mdio:01
> > !mdio-mux!mdio@1!switch@0!mdio:02
> > !mdio-mux!mdio@2!switch@0!mdio:00
> > !mdio-mux!mdio@2!switch@0!mdio:01
> > !mdio-mux!mdio@2!switch@0!mdio:02
> > !mdio-mux!mdio@4!switch@0!mdio:00
> > !mdio-mux!mdio@4!switch@0!mdio:01
> > !mdio-mux!mdio@4!switch@0!mdio:02
> > 400d0000.ethernet-1:00
> > 400d0000.ethernet-1:01
> > fixed-0:00
> 
> Not nice, I see. In particular, it contains ":"... which would be a
> problem.
> 
> > The interface name are:
> > 
> > 1: lo:
> > 2: eth0:
> > 3: eth1:
> > 4: lan0@eth1:
> > 5: lan1@eth1:
> > 6: lan2@eth1:
> > 7: lan3@eth1:
> > 8: lan4@eth1:
> > 9: lan5@eth1:
> > 10: lan6@eth1:
> > 11: lan7@eth1:
> > 12: lan8@eth1:
> > 13: optical3@eth1:
> > 14: optical4@eth1:
> 
> OTOH... renaming LEDs when interface is renamed... sounds like a
> disaster, too.

I don't think it is. The stack has all the needed support. There is a
notification before the rename, and another notification after the
rename. Things like bonding, combing two interfaces into one and load
balancing, etc. hook these notifiers. There is plenty of examples to
follow. What i don't know about is the lifetime of files under
/sys/class/led, does the destroying of an LED block while one of the
files is open?.

> > You could make a good guess at matching to two together, but it is
> > error prone. Phys are low level things which the user is not really
> > involved in. They interact with interface names. ethtool, ip, etc, all
> > use interface names. In fact, i don't know of any tool which uses
> > phydev names.
> 
> So... proposal:
> 
> Users should not be dealing with sysfs interface directly, anyway. We
> should have a tool for that. It can live in kernel/tools somewhere, I
> guess.

We already have one, ethtool(1). 

> 
> Would we name leds phy0:... (with simple incrementing number), and
> expose either interface name or phydev name as a attribute?
> 
> So user could do
> 
> cat /sys/class/leds/phy14:green:foobar/netdev
> lan5@eth1:

Which is the wrong way around. ethtool will be passed the interface
name and an PHY descriptor of some sort, and it has to go search
through all the LEDs to find the one with this attribute. I would be
much more likely to add a sysfs link from
/sys/class/net/lan5/phy:left:green to
/sys/class/leds/phy14:left:green.

	Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1F11B1051
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgDTPga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:36:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51110 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgDTPga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 11:36:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=reWbSLTLYxCFThZVNc5Xkq8Sy+cv49VQ9S3/O8E0FM0=; b=pvekA+bSWB/+gBuXVHw3N1pU64
        dbRZDOihYQ+WWtiCzPa9p7SduB6ek3GmnfMKwd0RE5/+8XhkztDOi42tcVUTF1MCzy5TOX8kUlRq7
        eZHZjO7y81LC95lYGQU1GviHimv4hHL3+2Dj1fW4rKK5gyHdmJn0AU/U6KonDaRJn4Cs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQYTB-003que-1N; Mon, 20 Apr 2020 17:36:25 +0200
Date:   Mon, 20 Apr 2020 17:36:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 3/3] net: phy: bcm54140: add hwmon support
Message-ID: <20200420153625.GA917792@lunn.ch>
References: <20200417201338.GI785713@lunn.ch>
 <84679226df03bdd8060cb95761724d3a@walle.cc>
 <20200417212829.GJ785713@lunn.ch>
 <4f3ff33f78472f547212f87f75a37b66@walle.cc>
 <20200419162928.GL836632@lunn.ch>
 <ebc026792e09d5702d031398e96d34f2@walle.cc>
 <20200419170547.GO836632@lunn.ch>
 <0f7ea4522a76f977f3aa3a80dd62201d@walle.cc>
 <20200419215549.GR836632@lunn.ch>
 <75428c5faab7fc656051ab227663e6e6@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75428c5faab7fc656051ab227663e6e6@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ok I see, but what locking do you have in mind? We could have something
> like
> 
> __phy_package_write(struct phy_device *dev, u32 regnum, u16 val)
> {
>   return __mdiobus_write(phydev->mdio.bus, phydev->shared->addr,
>                          regnum, val);
> }
> 
> and its phy_package_write() equivalent. But that would just be
> convenience functions, nothing where you actually help the user with
> locking. Am I missing something?

In general, drivers should not be using __foo functions. We want
drivers to make use of phy_package_write() which would do the bus
locking. Look at a typical PHY driver. There is no locking what so
ever. Just lots of phy_read() and phy write(). The locking is done by
the core and so should be correct.

> > > > Get the core to do reference counting on the structure?
> > > > Add helpers phy_read_shared(), phy_write_shared(), etc, which does
> > > > MDIO accesses on the base device, taking care of the locking.
> > > > 
> > > The "base" access is another thing, I guess, which has nothing to do
> > > with the shared structure.
> > > 
> > I'm making the assumption that all global addresses are at the base
> > address. If we don't want to make that assumption, we need the change
> > the API above so you pass a cookie, and all PHYs need to use the same
> > cookie to identify the package.
> 
> how would a phy driver deduce a common cookie? And how would that be a
> difference to using a PHY address.

For a cookie, i don't care how the driver decides on the cookie. The
core never uses it, other than comparing cookies to combine individual
PHYs into a package. It could be a PHY address. It could be the PHY
address where the global registers are. Or it could be anything else.

> > Maybe base is the wrong name, since MSCC can have the base as the high
> > address of the four, not the low?
> 
> I'd say it might be any of the four addresses as long as it is the same
> across the PHYs in the same package. And in that case you can also have
> the phy_package_read/write() functions.

Yes. That is the semantics which is think is most useful. But then we
don't have a cookie, the value has real significance, and we need to
document what is should mean.

     Andrew



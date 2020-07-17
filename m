Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAF3223C2B
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 15:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgGQNSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 09:18:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40944 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbgGQNSW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 09:18:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jwQFi-005bot-5W; Fri, 17 Jul 2020 15:18:14 +0200
Date:   Fri, 17 Jul 2020 15:18:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: Re: [PATCH v2] net: dsa: microchip: call phy_remove_link_mode during
 probe
Message-ID: <20200717131814.GA1336433@lunn.ch>
References: <20200715192722.GD1256692@lunn.ch>
 <20200716125723.GA19500@laureti-dev>
 <20200716141044.GA1266257@lunn.ch>
 <20200717081852.GA23732@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717081852.GA23732@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 10:18:52AM +0200, Helmut Grohne wrote:
> On Thu, Jul 16, 2020 at 04:10:44PM +0200, Andrew Lunn wrote:
> > However, i'm having trouble understanding how PHYs actually work in
> > this driver. 
> > 
> > We have:
> > 
> > struct ksz_port {
> >         u16 member;
> >         u16 vid_member;
> >         int stp_state;
> >         struct phy_device phydev;
> > 
> > with an instance of this structure per port of the switch.
> > 
> > And it is this phydev which you are manipulating.
> > 
> > > +	for (i = 0; i < dev->phy_port_cnt; ++i) {
> > > +		/* The MAC actually cannot run in 1000 half-duplex mode. */
> > > +		phy_remove_link_mode(&dev->ports[i].phydev,
> > > +				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> > > +
> > > +		/* PHY does not support gigabit. */
> > > +		if (!(dev->features & GBIT_SUPPORT))
> > > +			phy_remove_link_mode(&dev->ports[i].phydev,
> > > +					     ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
> > > +	}
> > > +
> > >  	return 0;
> > 
> > But how is this phydev associated with the netdev? I don't see how
> > phylink_connect_phy() is called using this phydev structure?
> 
> The ksz* drivers are implemented using the DSA framework. The relevant
> phylink_connect_phy call is issued by the DSA infrastructure. We can see
> this (and its ordering relative to phy_remove_link_mode after my patch)
> using ftrace by adding the following to the kernel command line:

Hi Helmut

I'm not questioning the ordering. I'm questioning which phydev
structure is being manipulated.

We have:
        return phylink_connect_phy(dp->pl, slave_dev->phydev);

and your new:

+               phy_remove_link_mode(&dev->ports[i].phydev,
+                                    ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+

Is slave_dev->phydev == &dev->ports[i].phydev ?

To me, that is not obviously correct. This driver is doing odd things
with PHYs because of how they fit into the register map. And this
oddness it making it hard for me to follow this code and see how these
is true. It could well be true, i just don't see how.

     Andrew

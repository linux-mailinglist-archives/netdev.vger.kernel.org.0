Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E87373A1D
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 14:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbhEEMHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 08:07:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54294 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232013AbhEEMHQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 08:07:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1leGI6-002fRJ-OJ; Wed, 05 May 2021 14:06:10 +0200
Date:   Wed, 5 May 2021 14:06:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 20/20] net: phy: add qca8k driver for
 qca8k switch internal PHY
Message-ID: <YJKKMqk9MtnuVj3e@lunn.ch>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-20-ansuelsmth@gmail.com>
 <YJHwyPbklFgHVP3r@lunn.ch>
 <YJHyIN7XbaluQwwL@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJHyIN7XbaluQwwL@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 03:17:20AM +0200, Ansuel Smith wrote:
> On Wed, May 05, 2021 at 03:11:36AM +0200, Andrew Lunn wrote:
> > > +/* QCA specific MII registers access function */
> > > +static void qca8k_phy_dbg_write(struct mii_bus *bus, int phy_addr, u16 dbg_addr, u16 dbg_data)
> > > +{
> > > +	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> > > +	bus->write(bus, phy_addr, MII_ATH_DBG_ADDR, dbg_addr);
> > > +	bus->write(bus, phy_addr, MII_ATH_DBG_DATA, dbg_data);
> > > +	mutex_unlock(&bus->mdio_lock);
> > > +}
> > 
> > What are you locking against here?
> > 
> >      Andrew
> 
> Added the locking if in the future it will be used outside the
> config_init function but since it's used only there, yes, I can drop the
> useless lock.

The PHY core will take the phydev->lock whenever it calls the PHY
driver functions. The only exception to this is suspend/resume. So
long as you only access the devices own addresses on the MDIO bus, you
don't need any additional locks.

     Andrew


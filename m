Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A923B18678D
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 10:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbgCPJMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 05:12:21 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48278 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730076AbgCPJMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 05:12:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0cMCib0i4x5DglbDKqSEEANoz7bkgkVr0BxGXGd1PLo=; b=XpfltrYjsibMAdkZpJcHWHgrY
        3UAvseg3hAlxC5Qqguzj6CQ/ctv1hpwQI0j4NaWs4kaiadfwop2lq29vVLti03hKrZGsMpNW8gtBs
        rtAZutYtZyBDQWIwpLBarWzEDcklNUaeUETkTZEv+pirKhE8x6dnvFM9zorN2XvI2tFqY5LENULyj
        8vFVGBtyRNg7w/JXfdNkRBoFLlq1tehpuGorDciIvAd1Dw9JqQVQK1QHu2STskuii4dp/vGM51jmN
        LRgZjDEDJ5XmjjlDxRzZN9jYQzXtYLmKxH1PBItANFc00irljt3Fv8iY5ZPl9n4iSGi+7QkyDd4uA
        gZGoRS0Lg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:33002)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jDln8-0008Vi-0b; Mon, 16 Mar 2020 09:12:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jDln5-0001hn-LP; Mon, 16 Mar 2020 09:12:07 +0000
Date:   Mon, 16 Mar 2020 09:12:07 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: mdiobus: add APIs for modifying a MDIO
 device register
Message-ID: <20200316091207.GM25745@shell.armlinux.org.uk>
References: <20200314103102.GJ25745@shell.armlinux.org.uk>
 <E1jD44i-0006Mj-9J@rmk-PC.armlinux.org.uk>
 <20200314215728.GG8622@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314215728.GG8622@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 10:57:28PM +0100, Andrew Lunn wrote:
> On Sat, Mar 14, 2020 at 10:31:24AM +0000, Russell King wrote:
> > Add APIs for modifying a MDIO device register, similar to the existing
> > phy_modify() group of functions, but at mdiobus level instead.  Adapt
> > __phy_modify_changed() to use the new mdiobus level helper.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/phy/mdio_bus.c | 55 ++++++++++++++++++++++++++++++++++++++
> >  drivers/net/phy/phy-core.c | 31 ---------------------
> >  include/linux/mdio.h       |  4 +++
> >  include/linux/phy.h        | 19 +++++++++++++
> >  4 files changed, 78 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > index 3ab9ca7614d1..b33d1e793686 100644
> > --- a/drivers/net/phy/mdio_bus.c
> > +++ b/drivers/net/phy/mdio_bus.c
> > @@ -824,6 +824,38 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
> >  }
> >  EXPORT_SYMBOL(__mdiobus_write);
> >  
> > +/**
> > + * __mdiobus_modify_changed - Unlocked version of the mdiobus_modify function
> > + * @bus: the mii_bus struct
> > + * @addr: the phy address
> > + * @regnum: register number to modify
> > + * @mask: bit mask of bits to clear
> > + * @set: bit mask of bits to set
> > + *
> > + * Read, modify, and if any change, write the register value back to the
> > + * device. Any error returns a negative number.
> > + *
> > + * NOTE: MUST NOT be called from interrupt context.
> > + */
> > +int __mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
> > +			     u16 mask, u16 set)
> > +{
> > +	int new, ret;
> > +
> > +	ret = __mdiobus_read(bus, addr, regnum);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	new = (ret & ~mask) | set;
> > +	if (new == ret)
> > +		return 0;
> > +
> > +	ret = __mdiobus_write(bus, addr, regnum, new);
> > +
> > +	return ret < 0 ? ret : 1;
> > +}
> > +EXPORT_SYMBOL_GPL(__mdiobus_modify_changed);
> > +
> >  /**
> >   * mdiobus_read_nested - Nested version of the mdiobus_read function
> >   * @bus: the mii_bus struct
> > @@ -928,6 +960,29 @@ int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
> >  }
> >  EXPORT_SYMBOL(mdiobus_write);
> >  
> > +/**
> > + * mdiobus_modify - Convenience function for modifying a given mdio device
> > + *	register
> > + * @bus: the mii_bus struct
> > + * @addr: the phy address
> > + * @regnum: register number to write
> > + * @mask: bit mask of bits to clear
> > + * @set: bit mask of bits to set
> > + */
> > +int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask, u16 set)
> > +{
> > +	int err;
> > +
> > +	BUG_ON(in_interrupt());
> 
> Hi Russell
> 
> There seems to be growing push back on using BUG_ON and its
> variants. If should only be used if the system is so badly messed up,
> going further would only cause more damage. What really happens here
> if it is called in interrupt context? The mutex lock probably won't
> work, and we might corrupt the state of the PCS. That is not the end
> of the world. So i would suggest a WARN_ON here.

Do we even need these checks? (phylib has them scattered throughout
on the bus accessors.)  Aren't the might_sleep() checks that are
already in the locking functions already sufficient?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

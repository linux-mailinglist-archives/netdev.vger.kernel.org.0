Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CF51AFBFD
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 18:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgDSQ3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 12:29:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48516 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgDSQ3d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 12:29:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X0MRD5CzLwX8JPnqO6SANjVQWQPEK4R3ADbwkBqXpro=; b=uoTly+RPsTeTrEWTyInn0FHblW
        Pd+P28zEjuOBg91hX+E/7at6FIQ/FfPJVneAProYw1zzA07P68s06MGArA1wPfUJ5sCGkJDOJjELL
        oVKGZ3VkE1xCiBiALJc1ZMGsN/me6dld/GFOQN0dGr/8mr2gJexn/gr4m0XbzrZk9yKE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQCoy-003epS-Mq; Sun, 19 Apr 2020 18:29:28 +0200
Date:   Sun, 19 Apr 2020 18:29:28 +0200
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
Message-ID: <20200419162928.GL836632@lunn.ch>
References: <20200417192858.6997-1-michael@walle.cc>
 <20200417192858.6997-3-michael@walle.cc>
 <20200417195003.GG785713@lunn.ch>
 <35d00dfe1ad24b580dc247d882aa2e39@walle.cc>
 <20200417201338.GI785713@lunn.ch>
 <84679226df03bdd8060cb95761724d3a@walle.cc>
 <20200417212829.GJ785713@lunn.ch>
 <4f3ff33f78472f547212f87f75a37b66@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f3ff33f78472f547212f87f75a37b66@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 12:29:23PM +0200, Michael Walle wrote:
> Am 2020-04-17 23:28, schrieb Andrew Lunn:
> > On Fri, Apr 17, 2020 at 11:08:56PM +0200, Michael Walle wrote:
> > > Am 2020-04-17 22:13, schrieb Andrew Lunn:
> > > > > Correct, and this function was actually stolen from there ;) This was
> > > > > actually stolen from the mscc PHY ;)
> > > >
> > > > Which in itself indicates it is time to make it a helper :-)
> > > 
> > > Sure, do you have any suggestions?
> > 
> > mdiobus_get_phy() does the bit i was complaining about, the mdiobus
> > internal knowledge.
> 
> But that doesn't address your other comment.

Yes, you are right. But i don't think you can easily generalize the
rest. It needs knowledge of the driver private structure to reference
pkg_init. You would have to move that into phy_device.

> 
> > There is also the question of locking. What happens if the PHY devices
> > is unbound while you have an instance of its phydev?
> 
> Is there any lock one could take to avoid that?

phy_attach_direct() does a get_device(). That at least means the
struct device will not go away. I don't know the code well enough to
know if that will also stop the phy_device structure from being freed.
We might need mdiobus_get_phy() to also do a get_device(), and add a
mdiobus_put_phy() which does a put_device().

> > What happens if the base PHY is unbound? Are the three others then
> > unusable?
> 
> In my case, this would mean the hwmon device is also removed. I don't
> see any other way to do it right now. I guess it would be better to
> have the hwmon device registered to some kind of parent device.

The phydev structure might go away. But the hardware is still
there. You can access it via address on the bus. What you have to be
careful of is using the phydev for a different phy.

> For the BCM54140 there are three different functions:
>  (1) PHY functions accessible by the PHYs own address (ie PHY
>      status/control)
>  (2) PHY functions but only accessible by the global registers (ie
>      interrupt enables per PHY of the shared interrupt pin)
>  (3) global functions (like sensors, global configuration)
> 
> (1) is already supported in the current PHY framework. (2) and (3)
> need the "hack" which uses mdiobus_read/write() with the base
> address.

Is the _is_pkg_init() function the only place you need to access some
other phy_device structure.

Maybe we need a phydev->shared structure, which all PHYs in one
package share? Get the core to do reference counting on the structure?
Add helpers phy_read_shared(), phy_write_shared(), etc, which does
MDIO accesses on the base device, taking care of the locking. pkg_init
is a member of this shared structure. And have a void * priv in shared
for shared driver private data?

Just "thinking out loud"

    Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4791510769D
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfKVRme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:42:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51974 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfKVRme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 12:42:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=15a4eT7E7gb/Q3u/9EixDRvlSRg7W6ucEpcl9CgoXPI=; b=tc6FMGvVUVykgCzr80T8o1HB8f
        SrFtbTr/v5ZnIv68EI2eqNXZNLzGLO6R/FTeRA2D4/fjoUjYEeDEd8WlxyL4mOUW/s1GdW4AwVzIc
        WmsFF+M0PuD0UItmq/yWqd/j4nT6AD65L1lsX2I6wLEwu74YOUo4GuxAEJFdvs7UikW4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iYCwv-0006TV-0b; Fri, 22 Nov 2019 18:42:29 +0100
Date:   Fri, 22 Nov 2019 18:42:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Marginean <alexandru.marginean@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: binding for scanning a MDIO bus
Message-ID: <20191122174229.GG6602@lunn.ch>
References: <7b6fc87b-b6d8-21e6-bd8d-74c72b3d63a7@nxp.com>
 <20191122150932.GC6602@lunn.ch>
 <a6f797cf-956e-90d9-0bb3-11e752b8a818@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6f797cf-956e-90d9-0bb3-11e752b8a818@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Alexandru
> > 
> > You often see the bus registered using mdiobus_register(). That then
> > means a scan is performed and all phys on the bus found. The MAC
> > driver then uses phy_find_first() to find the first PHY on the bus.
> > The danger here is that the hardware design changes, somebody adds a
> > second PHY, and it all stops working in interesting and confusing
> > ways.
> > 
> > Would this work for you?
> > 
> >        Andrew
> > 
> 
> How does the MAC get a reference to the mdio bus though, is there some 
> way to describe this relationship in the DT?  I did say that Eth and 
> mdio are associated and they are, but not in the way Eth would just know 
> without looking in the DT what mdio that is.

What i described is generally used for PCIe card, USB dongles,
etc. The MAC driver is the one registering the MDIO bus, so it has
what it needs. Such hardware is also pretty much guaranteed to only
have one PHY on the bus, so phy_find_first() is less dangerous.

> Mdio buses of slots/cards are defined in DT under the mdio mux.  The mux 
> itself is accessed over I2C and its parent-mdio is a stand-alone device 
> that is not associated with a specific Ethernet device.  And on top of 
> that, based on serdes configuration, some Eth interfaces may end up on a 
> different slot and for that I want to apply a DT overlay to set the 
> proper Eth/mdio association.
> 
> Current code allows me to do something like this, as seen by Linux on boot:
> / {
> ....
> 	mdio-mux {
> 		/* slot 1 */
> 		mdio@4 {
> 			slot1_phy0: phy {
> 				/* 'reg' missing on purpose */
> 			};
> 		};
> 	};
> ....
> };
> 
> &enetc_port0 {
> 	phy-handle = <&slot1_phy0>;
> 	phy-mode = "sgmii";
> };
> 
> But the binding does not allow this, 'reg' is a required property of 
> phys.  Is this kind of DT structure acceptable even if it's not 
> compliant to the binding?  Assuming it's fine, any thoughts on making 
> this official in the binding?  If it's not, are there alternative 
> options for such a set-up?

In principle, this is O.K. The code seems to support it, even if the
binding does not give it as an option. It get messy when you have
multiple PHYs on the bus though. And if you are using DT, you are
supposed to know what the hardware is. Since you don't seems to know
what your hardware is, you are going to spam your kernel logs with

                        /* be noisy to encourage people to set reg property */
                        dev_info(&mdio->dev, "scan phy %pOFn at address %i\n",
                                 child, addr);

which i agree with.

      Andrew

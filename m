Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703561ADFF9
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 16:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgDQOcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 10:32:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44296 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbgDQOcx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 10:32:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=epl+1h9DH7t7VqStdqzBeBYRhF0SK0Dzk5viy5AM9Hg=; b=0KVdno0Ls6VHpYLIy2bn0Jse5Y
        VkwfWVOQylkEAHO1oRRw7Y3DqJu4KAdf1L5Q9LckjgTIYuCkPr2+lvnZIHCGKGte6VSaBGRxjAJRy
        EHLS+t7T7V6X1xD5TbHwzxCEitzwppL47flcRiu34a5PjzNd4DdJHf9ukPLDSeCw2JmI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPS2p-003INP-Jl; Fri, 17 Apr 2020 16:32:39 +0200
Date:   Fri, 17 Apr 2020 16:32:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mkl@pengutronix.de
Subject: Re: [PATCH v1] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200417143239.GH744226@lunn.ch>
References: <20200415121209.12197-1-o.rempel@pengutronix.de>
 <20200415215739.GI657811@lunn.ch>
 <20200417101145.GP25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417101145.GP25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 11:11:45AM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Apr 15, 2020 at 11:57:39PM +0200, Andrew Lunn wrote:
> > > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > > index c8b0c34030d32..d5edf2bc40e43 100644
> > > --- a/drivers/net/phy/phy_device.c
> > > +++ b/drivers/net/phy/phy_device.c
> > > @@ -604,6 +604,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
> > >  	dev->asym_pause = 0;
> > >  	dev->link = 0;
> > >  	dev->interface = PHY_INTERFACE_MODE_GMII;
> > > +	dev->master_slave = PORT_MODE_UNKNOWN;
> > 
> > phydev->master_slave is how we want the PHY to be configured. I don't
> > think PORT_MODE_UNKNOWN makes any sense in that contest. 802.3 gives
> > some defaults. 9.12 should be 0, meaning manual master/slave
> > configuration is disabled. The majority of linux devices are end
> > systems. So we should default to a single point device. So i would
> > initialise PORT_MODE_SLAVE, or whatever we end up calling that.
> 
> I'm not sure that is a good idea given that we use phylib to drive
> the built-in PHYs in DSA switches, which ought to prefer master mode
> via the "is a multiport device" bit.

O.K. So i assume you mean we should read from the PHY at probe time
what it is doing, in order to initialise dev->master_slave?

I would be happy with that.

  Andrew

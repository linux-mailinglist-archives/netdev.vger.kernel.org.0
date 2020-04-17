Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5351ADAC0
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 12:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgDQKMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 06:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725830AbgDQKMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 06:12:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14EEC061A0C;
        Fri, 17 Apr 2020 03:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9eD/KNTKzmFdSU+cGBntMJsUHhw1OUvboBhI7LiIfIs=; b=0C+PvN75fAzrOEtsQ6MiuBzLB
        ohWDvlGZYh259QQ+36dH9o2fzzYNLQGj/t1g89c9dbzP+S4JTYJkgiCujy6kCMLYEXsrrvXS0fB3w
        X0n5sd8X214JIWdit8+t3K8nNGKgcVm/7jdQhpAgl0bL8RhvwShRYiDQX4B6cvvbgjFGCpzYrFzZG
        tJiNQr8x1VdT50+5Ls/UISRFVtHJV/qhbN6tInck3WGRB5QGoVZmCmqeE6okkWrHu8ZYeXontZX2w
        tpa+OSHIXsOOHQPfQgkx0Nxwp8hxyE73f0q1OTGrjHbXlCG64UjwpZ6JzYMbUSblCxSzijAjHfY+H
        r9uM3lYFw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:39596)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jPNyR-0001PV-1S; Fri, 17 Apr 2020 11:11:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jPNyM-0002nx-0L; Fri, 17 Apr 2020 11:11:46 +0100
Date:   Fri, 17 Apr 2020 11:11:45 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
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
Message-ID: <20200417101145.GP25745@shell.armlinux.org.uk>
References: <20200415121209.12197-1-o.rempel@pengutronix.de>
 <20200415215739.GI657811@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415215739.GI657811@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 11:57:39PM +0200, Andrew Lunn wrote:
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index c8b0c34030d32..d5edf2bc40e43 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -604,6 +604,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
> >  	dev->asym_pause = 0;
> >  	dev->link = 0;
> >  	dev->interface = PHY_INTERFACE_MODE_GMII;
> > +	dev->master_slave = PORT_MODE_UNKNOWN;
> 
> phydev->master_slave is how we want the PHY to be configured. I don't
> think PORT_MODE_UNKNOWN makes any sense in that contest. 802.3 gives
> some defaults. 9.12 should be 0, meaning manual master/slave
> configuration is disabled. The majority of linux devices are end
> systems. So we should default to a single point device. So i would
> initialise PORT_MODE_SLAVE, or whatever we end up calling that.

I'm not sure that is a good idea given that we use phylib to drive
the built-in PHYs in DSA switches, which ought to prefer master mode
via the "is a multiport device" bit.

Just to be clear, there are three bits that configure 1G PHYs, which
I've framed in briefer terminology:

- 9.12: auto/manual configuration (1= manual 0= slave)
- 9.11: manual master/slave configuration (1= master, 0 = slave)
- 9.10: auto master/slave preference (1= multiport / master)

It is recommended that multiport devices (such as DSA switches) set
9.10 so they prefer to be master.

It's likely that the reason is to reduce cross-talk interference
between neighbouring ports both inside the PHY, magnetics and the
board itself. I would suspect that this becomes critical when
operating at towards the maximum cable length.

I've checked some of my DSA switches, and 9.10 appears to default to
one, as expected given what's in the specs.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

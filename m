Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6647D2CA58
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 17:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfE1Pb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 11:31:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35678 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbfE1Pb3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 11:31:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pQmCnrgUrKdkpeL0zToWxhvhTOp0gWpr7+IEj+29RPk=; b=dmzRWfZr3zZcYCBwR+3FlXrG4M
        erWgoC2eUi46EVf2x6cBFAwvsvmGecQYQLru+ozGbEzkSg9DVxEEWk7BwdMENbpL59hbsLvi98y1w
        /oRQgW20+V5upmr4DGoOAwTgmcmL6fsJI0JMunQQ89S19Zhosuno1p4IPJ7uXjlutGwE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVe4T-0007tE-07; Tue, 28 May 2019 17:31:24 +0200
Date:   Tue, 28 May 2019 17:31:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/5] net: phy: allow Clause 45 access via mii
 ioctl
Message-ID: <20190528153124.GM18059@lunn.ch>
References: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
 <E1hVYrJ-0005ZA-0S@rmk-PC.armlinux.org.uk>
 <CA+h21hpXv7678MuKVfAGiwuQwzZHX_1hjXHpwZUFz8wP5aRabg@mail.gmail.com>
 <20190528132745.m4iuh6ggib3a5kiq@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528132745.m4iuh6ggib3a5kiq@shell.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Russell,
> > 
> > I find the SIOCGMIIREG/SIOCGMIIPHY ioctls useful for C45 just as much
> > as they are for C22, but I think the way they work is a big hack and
> > for that reason they're less than useful when you need them most.
> > These ioctls work by hijacking the MDIO bus driver of a PHY that is
> > attached to a net_device. Hence they can be used to access at most a
> > PHY that lies on the same MDIO bus as one you already have a
> > phy-handle to.
> > If you have a PHY issue that makes of_phy_connect fail and the
> > net_device to fail to probe, basically you're SOL because you lose
> > that one handle that userspace had to the MDIO bus.
> > Similarly if you're doing a bring-up and all PHY interfaces are fixed-link.
> > Maybe it would be better to rethink this and expose some sysfs nodes
> > for raw MDIO access in the bus drivers.
> 
> I don't see how putting some attributes in sysfs helps

> What would be better would be for the MDIO layer to have /dev nodes
> that userspace could use to access the bus independent of the PHY,
> much the same as we have /dev/i2c-* - but I'm not sure if we really
> want to invent a whole new interface to MDIO buses.

There is work on re-implementing ethtool using a netlink socket.  The
proposed code supports the current MII interface. However, it should
be possible to extend it to pass some other identifier for the PHY,
rather than going via the network interface it is attached to.

Once ethtool netlink gets merged, i will take a look at this.

     Andrew

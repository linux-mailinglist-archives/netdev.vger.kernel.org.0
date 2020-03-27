Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08AA41956B0
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 13:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgC0MCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 08:02:06 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33052 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgC0MCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 08:02:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0KCyy4fR6uqfv7pQ7Bns3VVcVENtN8zz9qfPJTw1u4U=; b=qrI9PjSf/erLcmWVGVGBLQ3Mq
        01EOlIAqHOrpOFWwygcxDrNjhTmbFQ9VQX92GkkqsZ+n5l2wtjzpSi+3A50x8bCduK1sO1pVfsB61
        bHohG0qrEgypXagKGIaLv0ERu47suHhJkWI+wHldYyowaoRWhi5U6MgxJ5vFQXbaWzgeUTXlywCkB
        hkoRLzdjJ8V8DZ1Nj9hXLvXwZCUIOup90jsHvuaY0ptujc453VdVh54oUfD24NtB2R+AKS4XcLKFH
        K+xpv5v5M74br+N3dEVjydMvRcwTVQ67AsDpoLwSnjRcDbmfnhY0B1I2/f/x4cJJoQ+7Xx8fuO2fA
        Q3UM/wpTg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:37884)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jHngR-0000tb-TR; Fri, 27 Mar 2020 12:01:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jHngO-0004Bh-2o; Fri, 27 Mar 2020 12:01:52 +0000
Date:   Fri, 27 Mar 2020 12:01:52 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florinel Iordache <florinel.iordache@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/9] net: phy: add kr phy connection type
Message-ID: <20200327120151.GG25745@shell.armlinux.org.uk>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-4-git-send-email-florinel.iordache@nxp.com>
 <20200327001515.GL3819@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327001515.GL3819@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 01:15:15AM +0100, Andrew Lunn wrote:
> On Thu, Mar 26, 2020 at 03:51:16PM +0200, Florinel Iordache wrote:
> > Add support for backplane kr phy connection types currently available
> > (10gbase-kr, 40gbase-kr4) and the required phylink updates (cover all
> > the cases for KR modes which are clause 45 compatible to correctly assign
> > phy_interface and phylink#supported)
> > 
> > Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
> > ---
> >  drivers/net/phy/phylink.c | 15 ++++++++++++---
> >  include/linux/phy.h       |  6 +++++-
> >  2 files changed, 17 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index fed0c59..db1bb87 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -4,6 +4,7 @@
> >   * technologies such as SFP cages where the PHY is hot-pluggable.
> >   *
> >   * Copyright (C) 2015 Russell King
> > + * Copyright 2020 NXP
> >   */
> >  #include <linux/ethtool.h>
> >  #include <linux/export.h>
> > @@ -303,7 +304,6 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
> >  			break;
> >  
> >  		case PHY_INTERFACE_MODE_USXGMII:
> > -		case PHY_INTERFACE_MODE_10GKR:
> 
> We might have a backwards compatibility issue here. If i remember
> correctly, there are some boards out in the wild using
> PHY_INTERFACE_MODE_10GKR not PHY_INTERFACE_MODE_10GBASER.
> 
> See e0f909bc3a242296da9ccff78277f26d4883a79d
> 
> Russell, what do you say about this?

Yes, and that's a point that I made when I introduced 10GBASER to
correct that mistake.  It is way too soon to change this; it will
definitely cause regressions:

$ grep 10gbase-kr arch/*/boot/dts -r
arch/arm64/boot/dts/marvell/cn9131-db.dts:      phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts:      phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts:      phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/armada-7040-db.dts:    phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dts:   phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dts:   phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts:     phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/armada-8040-db.dts: phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/armada-8040-db.dts: phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/cn9132-db.dts:      phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/cn9130-db.dts:      phy-mode = "10gbase-kr";

So any change to the existing PHY_INTERFACE_MODE_10GKR will likely
break all these platforms.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

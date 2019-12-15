Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B9B11F6CF
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 08:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfLOHna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 02:43:30 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47684 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfLOHna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 02:43:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=e/D98vB4JkGR43g0ffiAwvcnjqCBtPGwAPA6LkSz/w4=; b=Qje5YvK6tPUoxU45JijdvpN+s
        VhxrPVnSGSfTrvQiurV9DM0nreESf+u/L6ah2eLq+e8Fl4k/aHW6MzWC63PRsfamUZWa1Yrca5Uxy
        SU1SBwDz2SAH7vOBLChsZ3S12VPaQpQw+OBl+r9oyy22iaOI5S7CvuAWeFdTAvdmmsqIxZQb/13iN
        j2i4IqJl5FZs/gklx38EgHS+APsB7duEYHtLVeEYbcoQ1Iu42Zbl77XiRliozubYbm3X7bjcz0hww
        gVOd0apgrtdvT2IbsIe5zkUKdqKwetuE+xdu4MMNXOGK96TenGVcxBPUQO6W1wJ9JQhFx7rih49WV
        1QYI7mznA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:41572)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1igOYi-0007xa-C6; Sun, 15 Dec 2019 07:43:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1igOYd-0001AT-4K; Sun, 15 Dec 2019 07:43:15 +0000
Date:   Sun, 15 Dec 2019 07:43:15 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Milind Parab <mparab@cadence.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylink: propagate phy_attach_direct()
 return code
Message-ID: <20191215074314.GZ25745@shell.armlinux.org.uk>
References: <E1ifS4S-000706-ON@rmk-PC.armlinux.org.uk>
 <20191214202745.649bbed2@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191214202745.649bbed2@cakuba.netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 14, 2019 at 08:27:45PM -0800, Jakub Kicinski wrote:
> On Thu, 12 Dec 2019 17:16:12 +0000, Russell King wrote:
> > of_phy_attach() hides the return value of phy_attach_direct(), forcing
> > us to return a "generic" ENODEV error code that is indistinguishable
> > from the lack-of-phy-property case.
> > 
> > Switch to using of_phy_find_device() to find the PHY device, and then
> > propagating any phy_attach_direct() error back to the caller.
> > 
> > Link: https://lore.kernel.org/lkml/20191210113829.GT25745@shell.armlinux.org.uk
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Applied thanks, the ref counting is not entirely obvious to a layman.
> In your reply to Milind you said he can immediately of_node_put()
> because the phy_dev is never deferenced in his code, but here it looks
> like it is actually - the reference used to be given up after attach is
> done, now its given up before attach_direct is called.

The refcount is on the device_node - once we've got the phy device
itself (or failed to) we're not using the device_node anymore, so
we can put it directly after the of_phy_find_device() call.

> 
> But I don't know how the refcounting here works, so applied, and on the
> off chance the code is wrong follow up will be fine.
> 
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index f7c660bf99d1..8d20cf3ba0b7 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -859,14 +859,17 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
> >  		return 0;
> >  	}
> >  
> > -	phy_dev = of_phy_attach(pl->netdev, phy_node, flags,
> > -				pl->link_interface);
> > +	phy_dev = of_phy_find_device(phy_node);
> >  	/* We're done with the phy_node handle */
> >  	of_node_put(phy_node);
> > -
> >  	if (!phy_dev)
> >  		return -ENODEV;
> >  
> > +	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
> > +				pl->link_interface);
> > +	if (ret)
> > +		return ret;
> > +
> >  	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
> >  	if (ret)
> >  		phy_detach(phy_dev);
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2479A207035
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389074AbgFXJjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388031AbgFXJjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 05:39:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3281C061573;
        Wed, 24 Jun 2020 02:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mu39W01/t9ACc+drZK56GEmPLcRgj8Ms7poz8whzmow=; b=vuaVAcTH7W1+HEM32sXXCH+PV
        qLbCEfLDNkxMy9Qm63+cJQwVrVVLMfhkLUGfHBw8Nf2BjF/Iy2HQ4cggnd5joJPhh7L2767co4iv5
        C71N+Po+YjfaSzbWe4iBRJrc7TeZwf2QYiB9BsekdSrGjWLh+TJCussKTG2UJ//73av1mdmZkYEf3
        2fZCrxaxztth359yTjF1jk5CL092a6U1LZlDDB3RAYC4n6V/GCMZLYNUZKOHUKkeXPOvbItDdyWfj
        2ud2QmXexeJAdFVw7RnB1m3NPmEElOwPszX+S84WJeh9ncCXhwmiE6jKYGePwhwbup7vk7zL7UfXJ
        0XmMe6HHA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59050)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jo1sL-0002oX-Rr; Wed, 24 Jun 2020 10:39:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jo1sJ-0001qH-RN; Wed, 24 Jun 2020 10:39:23 +0100
Date:   Wed, 24 Jun 2020 10:39:23 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] net: phy: call phy_disable_interrupts() in
 phy_init_hw()
Message-ID: <20200624093923.GX1551@shell.armlinux.org.uk>
References: <20200624112516.7fcd6677@xhacker.debian>
 <20200624112624.200306ac@xhacker.debian>
 <996affa7-9f78-73c4-8f86-9bcd337191c4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <996affa7-9f78-73c4-8f86-9bcd337191c4@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 08:36:46PM -0700, Florian Fainelli wrote:
> Le 2020-06-23 à 20:26, Jisheng Zhang a écrit :
> > Call phy_disable_interrupts() in phy_init_hw() to "have a defined init
> > state as we don't know in which state the PHY is if the PHY driver is
> > loaded. We shouldn't assume that it's the chip power-on defaults, BIOS
> > or boot loader could have changed this. Or in case of dual-boot
> > systems the other OS could leave the PHY in whatever state." as pointed
> > out by Heiner.
> > 
> > Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
> > Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> > ---
> >  drivers/net/phy/phy_device.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 04946de74fa0..f17d397ba689 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -1090,10 +1090,13 @@ int phy_init_hw(struct phy_device *phydev)
> >  	if (ret < 0)
> >  		return ret;
> >  
> > -	if (phydev->drv->config_init)
> > +	if (phydev->drv->config_init) {
> >  		ret = phydev->drv->config_init(phydev);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> >  
> > -	return ret;
> > +	return phy_disable_interrupts(phydev);
> 
> Not sure if the order makes sense here, it may seem more natural for a
> driver writer to have interrupts disabled first and then config_init
> called (which could enable interrupts not related to link management
> like thermal events etc.)

If this is a shared interrupt, and the PHY interrupt has been left
enabled, wouldn't we want to ensure that the PHY interrupt is disabled
as early as possible - in other words, when the device is probed,
rather than when the PHY is eventually bound to the network device.

However, I must point out that even disabling the PHY interrupt at
probe time is only reducing the window for problems - if that shared
interrupt has already been claimed by other users, and if the PHY
interrupt is unmasked in the PHY, then the PHY can do whatever it
likes with the shared interrupt before we even get to probe the PHY.
So the only real solution to this is to fix the environment that is
passing control to the kernel.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

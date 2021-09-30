Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6987D41D7ED
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 12:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350019AbhI3Kma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 06:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349873AbhI3Km2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 06:42:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2573DC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 03:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gZDCQGOEO7ghlR4K6N8RDKcc5ZR8Uy4dI8CySD3f97E=; b=EFLUUkZWJr10XNi+7p9wuDNYZw
        YVtzoQ0DUUau1DOcY9ad9lUrYYf+khMK6/4bkh3S4EAhroYjefUmq+SWmYD6Z+dHHg7hjU5iXQohc
        4VQ+TUV+QP0ppeYzKGvh25Y4ls0vxHRbaamt91e/srlzfq6HvYAnFfTDzgV94qD01WGFIHANb4ymZ
        M7NPNLHABQEezZrwaibJbFJFpE0QMhHl1bPR/FpMQCjQKrv2aicg770GIM3MMWshkxQIio0mE3Hz1
        445syveFFCCRUFGk3RnpCV7FSGwyNrhxLtCR/ISV+/J43zbgzWXO1DgXNVgHe75xRXyXLmYgZGDlr
        xTQ1yeYA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54856)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mVtUa-0003HG-9A; Thu, 30 Sep 2021 11:40:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mVtUZ-0003ZX-JJ; Thu, 30 Sep 2021 11:40:43 +0100
Date:   Thu, 30 Sep 2021 11:40:43 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Vivek Unune <npcomplete13@gmail.com>
Subject: Re: Lockup in phy_probe() for MDIO device (Broadcom's switch)
Message-ID: <YVWUKwEXrd39t8iw@shell.armlinux.org.uk>
References: <2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com>
 <YVWOp/2Nj/E1dpe3@shell.armlinux.org.uk>
 <5715f818-a279-d514-dcac-73a94c1d30ef@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5715f818-a279-d514-dcac-73a94c1d30ef@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 12:30:52PM +0200, Rafał Miłecki wrote:
> On 30.09.2021 12:17, Russell King (Oracle) wrote:
> > On Thu, Sep 30, 2021 at 11:58:21AM +0200, Rafał Miłecki wrote:
> > > This isn't necessarily a PHY / MDIO regression. It could be some core
> > > change that exposed a PHY / MDIO bug.
> > 
> > I think what's going on is that the switch device is somehow being
> > probed by phylib. It looks to me like we don't check that the mdio
> > device being matched in phy_bus_match() is actually a PHY (by
> > checking whether mdiodev->flags & MDIO_DEVICE_FLAG_PHY is true
> > before proceeding with any matching.)
> > 
> > We do, however, check the driver side. This looks to me like a problem
> > especially when the mdio bus can contain a mixture of PHY devices and
> > non-PHY devices. However, I would expect this to also be blowing up in
> > the mainline kernel as well - but it doesn't seem to.
> > 
> > Maybe Andrew can provide a reason why this doesn't happen - maybe we've
> > just been lucky with out-of-bounds read accesses (to the non-existent
> > phy_device wrapped around the mdio_device?)
> 
> I'll see if I can use buildroot to test unmodified kernel.
> 
> 
> > If my theory is correct, this patch should solve your issue:
> > 
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index ba5ad86ec826..dac017174ab1 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -462,7 +462,8 @@ static int phy_bus_match(struct device *dev, struct device_driver *drv)
> >   	const int num_ids = ARRAY_SIZE(phydev->c45_ids.device_ids);
> >   	int i;
> > -	if (!(phydrv->mdiodrv.flags & MDIO_DEVICE_IS_PHY))
> > +	if (!(phydrv->mdiodrv.flags & MDIO_DEVICE_IS_PHY) ||
> > +	    !(phydev->mdio.flags & MDIO_DEVICE_FLAG_PHY))
> >   		return 0;
> >   	if (phydrv->match_phy_device)
> > 
> 
> Unfortunately this doesn't seem to help

Hmm.

In phy_probe, can you add:

	WARN_ON(!(phydev->mdio.flags & MDIO_DEVICE_FLAG_PHY));

just to make sure we have a real PHY device there please? Maybe also
print the value of the flags argument.

MDIO_DEVICE_FLAG_PHY is set by phy_create_device() before the mutex is
initialised, so if it is set, the lock should be initialised.

Maybe also print mdiodev->flags in mdio_device_register() as well, so
we can see what is being registered and the flags being used for that
device.

Could it be that openwrt is carrying a patch that is causing this
issue?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

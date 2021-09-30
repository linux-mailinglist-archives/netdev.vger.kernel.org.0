Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7379A41D904
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350535AbhI3LqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350490AbhI3LqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:46:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823FCC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8NzCLP7fTToPVBSP+2lxMzrdY8ctQScwWyfBj1ehlpA=; b=wgLn2b9NgPcwUo+xBhy2GwUIXK
        sfdPjnj0qbbesxBVMWtNeBJcIZr7Rlevo2GA6IPAvBUL/ea6FPjLKsr2m9WENYU3gInFE+wgXvVjF
        By0AZejf+jPm2b0YXPODp86MoJYAGKTgySjX2dIGlHIndbhJCtXqXYsN+oMrHuXOE/p2bSbbmRH0L
        MR+NgIy/+gxF+DCyDdeWwFprcnxoYN7u+MDUdgij2ppvDOIlZTy1gfO78BY59NOd0vsooAYMUwoD+
        ncYFAi8abyjqqs3+1jP600r2ID4uGpD1AAE4MBbmkzFOF/6ADhGL6WhurQ8QarBV52UdCjNOgG8ua
        rAlJ1vYQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54860)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mVuU6-0003N8-2S; Thu, 30 Sep 2021 12:44:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mVuU5-0003cE-35; Thu, 30 Sep 2021 12:44:17 +0100
Date:   Thu, 30 Sep 2021 12:44:17 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Vivek Unune <npcomplete13@gmail.com>
Subject: Re: Lockup in phy_probe() for MDIO device (Broadcom's switch)
Message-ID: <YVWjEQzJisT0HgHB@shell.armlinux.org.uk>
References: <2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com>
 <YVWOp/2Nj/E1dpe3@shell.armlinux.org.uk>
 <5715f818-a279-d514-dcac-73a94c1d30ef@gmail.com>
 <YVWUKwEXrd39t8iw@shell.armlinux.org.uk>
 <1e4e40ba-23b8-65b4-0b53-1c8393d9a834@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1e4e40ba-23b8-65b4-0b53-1c8393d9a834@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 01:29:33PM +0200, Rafał Miłecki wrote:
> On 30.09.2021 12:40, Russell King (Oracle) wrote:
> > In phy_probe, can you add:
> > 
> > 	WARN_ON(!(phydev->mdio.flags & MDIO_DEVICE_FLAG_PHY));
> > 
> > just to make sure we have a real PHY device there please? Maybe also
> > print the value of the flags argument.
> > 
> > MDIO_DEVICE_FLAG_PHY is set by phy_create_device() before the mutex is
> > initialised, so if it is set, the lock should be initialised.
> > 
> > Maybe also print mdiodev->flags in mdio_device_register() as well, so
> > we can see what is being registered and the flags being used for that
> > device.
> > 
> > Could it be that openwrt is carrying a patch that is causing this
> > issue?
> 
> I don't think there is any OpenWrt patch affecting that.
> 
> MDIO_DEVICE_FLAG_PHY seems to be missing.

Right, so the mdio device being registered is a non-PHY MDIO device.
It doesn't have a struct phy_device around it - and so any access
outside of the mdio_device is an out-of-bounds access.

Consequently, phylib should not be matching this device. The only
remaining way I can see that this could happen is if a PHY driver has
an OF compatible, which phylib drivers should never have.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

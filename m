Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A65B47565E
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 11:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241669AbhLOK3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 05:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241668AbhLOK3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 05:29:12 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B5AC061574;
        Wed, 15 Dec 2021 02:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TVQg7rmLG9/kEQLBFPzjR2EeSy+xiEzrH+q1P3DvhXg=; b=lFfJegrnC0xJgESF0BGSNXdjs3
        Jl+aaLDljTZGLkE38I3rA2Y10F41p3fkamSkYZnM4BynI0hm/dM+rAn6GVoRC/PzozH9mY8XpW2RN
        PyJ+x2QEy7b6Sl/yF/fHGqnW0+5LrdRWMehfegPTuEmOlPRaGymvoVVuqebP0ahOKOsWUBzQt8/TL
        zR8Sp19tiDiHS/QS8YLa+WybqwpHWiARqsgwMfCRIneq1k84NpOOrtUfear/yaGBXx3ckLeEJ/0gz
        9EBX9FV7kL6UWI9+IBAu7TaaOcpjJVhj65ePCQv4Qg3bdvRLiTeIZDiln6B8GBib1B+IYbVTI4j5Z
        ACeNLh9A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56300)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mxRX2-0006C9-Rj; Wed, 15 Dec 2021 10:29:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mxRX1-0004P3-4h; Wed, 15 Dec 2021 10:29:07 +0000
Date:   Wed, 15 Dec 2021 10:29:07 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Message-ID: <YbnDc/snmb1WYVCt@shell.armlinux.org.uk>
References: <20211214121638.138784-1-philippe.schenker@toradex.com>
 <20211214121638.138784-4-philippe.schenker@toradex.com>
 <YbjofqEBIjonjIgg@lunn.ch>
 <20211214223548.GA47132@francesco-nb.int.toradex.com>
 <Ybm3NDeq96TSjh+k@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybm3NDeq96TSjh+k@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 10:36:52AM +0100, Andrew Lunn wrote:
> On Tue, Dec 14, 2021 at 11:35:48PM +0100, Francesco Dolcini wrote:
> > Hello Andrew,
> > 
> > On Tue, Dec 14, 2021 at 07:54:54PM +0100, Andrew Lunn wrote:
> > > What i don't particularly like about this is that the MAC driver is
> > > doing it. Meaning if this PHY is used with any other MAC, the same
> > > code needs adding there.
> > This is exactly the same case as phy_reset_after_clk_enable() [1][2], to
> > me it does not look that bad.
> > 
> > > So maybe in the phy driver, add a suspend handler, which asserts the
> > > reset. This call here will take it out of reset, so applying the reset
> > > you need?
> > Asserting the reset in the phylib in suspend path is a bad idea, in the
> > general case in which the PHY is powered in suspend the
> > power-consumption is likely to be higher if the device is in reset
> > compared to software power-down using the BMCR register (at least for
> > the PHY datasheet I checked).
> 
> Maybe i don't understand your hardware.
> 
> You have a regulator providing power of the PHY.
> 
> You have a reset, i guess a GPIO, connected to the reset pin of the
> PHY.
> 
> What you could do is:
> 
> PHY driver suspend handler does a phy_device_reset(ndev->phydev, 1)
> to put the PHY into reset.
> 
> MAC driver disables the regulator.
> 
> Power consumption should now be 0, since it does not have any power.
> 
> On resume, the MAC enables the regulator. At this point, the PHY gets
> power, but is still held in reset. It is now consuming power, but not
> doing anything. The MAC calls phy_hw_init(), which calls
> phy_device_reset(ndev->phydev, 0), taking the PHY out of reset.
> 
> Hopefully, this release from reset is enough to make the PHY work.
> 
> Doing it like this also addresses Russell point. phy_hw_init() is not
> putting the device into reset, it is only taking it out of reset, if
> it happens to be already in reset. So we are not slowing down link up
> for everybody.

Here's another question which no one seems to have considered. If the
PHY power source can be controlled, why doesn't the firmware describe
the power supply for the PHY, and why doesn't the PHY driver control
the PHY power source? Why is that in the SoC network driver?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

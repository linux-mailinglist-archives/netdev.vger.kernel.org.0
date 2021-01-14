Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AD92F6E55
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 23:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbhANWip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 17:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbhANWio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 17:38:44 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6223BC061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 14:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4Zly++atkssZpB3uw6V3G4wMYBSSQ+uaWn+F+rW5PUg=; b=XULCShztpvNT4y6S1rY9DqPPI
        pnKLKkfHHLCbaJe2f8K0HD5DW0hGVl+imWse/1cc2MwGocyS3gmg7ZnsTNqSTSnSZ4zW9hyTIkl3g
        P5enZRTOTU7bPsjeihX/vY8NT+4/3o8cjOh026F2Oi9Agqb1N1BBHpX8ppqa9Da761yye+EVZ8mR9
        9/mhp1DfjTcQLbB2DJzteguMHTwLJw7BL5F1l08jeukpLyvenen/cBeaJCnBG92NO/OEiF5/Jgxu4
        ZicKMb8fJozuwJhclXz72Z04bniODDG8qTLuH8jNOcIHjdqPcaXWErUVYcPhTmagW26wwcbDQ3YFH
        gbf+v1szQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48056)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l0BFh-000315-Tj; Thu, 14 Jan 2021 22:38:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l0BFg-0000Hq-Sg; Thu, 14 Jan 2021 22:38:00 +0000
Date:   Thu, 14 Jan 2021 22:38:00 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <20210114223800.GR1605@shell.armlinux.org.uk>
References: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
 <20210114125506.GC3154@hoboy.vegasvil.org>
 <20210114132217.GR1551@shell.armlinux.org.uk>
 <20210114133235.GP1605@shell.armlinux.org.uk>
 <20210114172712.GA13644@hoboy.vegasvil.org>
 <20210114173111.GX1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114173111.GX1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 05:31:11PM +0000, Russell King - ARM Linux admin wrote:
> On Thu, Jan 14, 2021 at 09:27:12AM -0800, Richard Cochran wrote:
> > Thanks for the reminder.  We ended up with having to review the MAC
> > drivers that support phydev.
> > 
> >    https://lore.kernel.org/netdev/20200730194427.GE1551@shell.armlinux.org.uk/
> > 
> > There is at least the FEC that supports phydev.  I have a board that
> > combines the FEC with the dp83640 PHYTER, and your patch would break
> > this setup.  (In the case of this HW combination, the PHYTER is
> > superior in every way.)
> > 
> > Another combination that I have seen twice is the TI am335x with its
> > cpsw MAC and the PHYTER.  Unfortunately I don't have one of these
> > boards, but people made them because the cpsw MAC supports time
> > stamping in a way that is inadequate.
> > 
> > I *think* the cpsw/phyter combination would work with your patch, but
> > only if the users disable CONFIG_TI_CPTS at compile time.
> 
> I think then the only solution is to move the decision how to handle
> get_ts_info into each MAC driver and get rid of:
> 
> 	if (phy_has_tsinfo(phydev))
> 	        return phy_ts_info(phydev, info);
> 
> in __ethtool_get_ts_info().

Thinking about this more, that is an impossible task - there's no
obvious information around to suggest which ethernet drivers could
possibly be attached to a phylib PHY that supports PTP.

So, I think the only way to prevent a regression with the code as
it is today is that we _never_ support PTP on Marvell PHYs - because
doing so _will_ break the existing MVPP2 driver's implementation and
cause a regression.

Right now, there is no option: if a PHY supports PTP, then the only
option is to use the PHYs PTP. Which is utterly rediculous.

Unless you can see a way around it. Because I can't.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8292831B07C
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 14:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhBNNUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 08:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhBNNUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 08:20:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDC0C061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 05:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RNsJj/JyuhXkjwNa7QkOgQwOioTf/v6xRBsDpH922b8=; b=Yf+73hecXNoTLflrOyrrRf2K1
        i9YX2wJA92GSJQ98qaZL9Lat4jGeOUxSt5PHbwHQQjvwZSy5S/MiI3Qjj7GmtQcHM05NkdurAR29S
        FW0W/3S66Wid360i0N7EBLIDuUMKknNrAut9W1F0+tMBX6S+74pAEbRJBB9vuuryxLdeY7VAcrQY4
        Fpxr8KGMJVr/ls2pGTSolOFAb9/T5q8V8YjRuWC2lPmo0WL4UdRfR8JtCY4Ol+Aw/YBqCoLYkgx18
        +nE/Auq+/vFYH7aIz2n1BtmndcnKKK+gOK/kY3hVGEShqyTgg1u7U4aD63/W7dtX8bwu9kIY8aR/T
        7gZvPdB+w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43300)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lBHJA-0000NZ-UY; Sun, 14 Feb 2021 13:19:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lBHI0-0000iM-6F; Sun, 14 Feb 2021 13:18:16 +0000
Date:   Sun, 14 Feb 2021 13:18:16 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phylink: explicitly configure in-band
 autoneg for PHYs that support it
Message-ID: <20210214131816.GU1463@shell.armlinux.org.uk>
References: <20210212172341.3489046-1-olteanv@gmail.com>
 <20210212172341.3489046-2-olteanv@gmail.com>
 <20210214103529.GT1463@shell.armlinux.org.uk>
 <20210214111014.edr7uqezqdzrrr7w@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210214111014.edr7uqezqdzrrr7w@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 01:10:14PM +0200, Vladimir Oltean wrote:
> On Sun, Feb 14, 2021 at 10:35:29AM +0000, Russell King - ARM Linux admin wrote:
> > As mentioned in this thread, we have at least one PHY which is unable
> > to provide the inband signalling in any mode (BCM84881). Currently,
> > phylink detects this PHY on a SFP (in phylink_phy_no_inband()) and
> > adjusts not to use inband mode. This would need to be addressed if we
> > are creating an alterative way to discover whether the PHY supports
> > inband mode or not.
> 
> So I haven't studied the SFP code path too deeply, but I think part of
> the issue is the order in which things are done. It's almost as if there
> should be a validation phase for PHY inband abilities too.
> 
> phylink_sfp_connect_phy
> -> phylink_sfp_config:
>    -> first this checks if phylink_phy_no_inband
>    -> then this changes pl->link_config.interface and pl->cur_link_an_mode
> -> phylink_bringup_phy:
>    -> this is where I'm adding the new phy_config_inband_aneg function
> 
> If we were to use only my phy_config_inband_aneg function, it would need
> to be moved upwards in the code path, to be precise where phylink_phy_no_inband
> currently is. Then we'd have to try MLO_AN_INBAND first, with a fallback
> to MLO_AN_PHY if that fails. I think this would unnecessarily complicate
> the code.

There's another possibility - we could postpone the actual configuration
on the MAC side to always be in phylink_sfp_module_start(), essentially
moving the phylink_mac_initial_config() call to that point while
preserving the current locations where we compute the initial interface
mode. We can then defer the AN mode selection.

> Alternatively, I could create a second PHY driver method, simply for
> validation of supported inband modes. The validation can be done in
> place of the current phylink_phy_noinband(), and I can still have the
> phy_config_inband_aneg() where I put it now, since we shouldn't have any
> surprises w.r.t. supported operating mode, and there should be no reason
> to repeat the attempt as there would be with a single PHY driver method.
> Thoughts?

That also sounds like it should work, and would probably be more
flexible.

> > Also, there needs to be consideration of PHYs that dynamically change
> > their interface type, and whether they support inband signalling.
> > For example, a PHY may support a mode where it dynamically selects
> > between 10GBASE-R, 5GBASE-R, 2500BASE-X and SGMII, where the SGMII
> > mode may have inband signalling enabled or disabled. This is not a
> > theoretical case; we have a PHY like that supported in the kernel and
> > boards use it. What would the semantics of your new call be for a PHY
> > that performs this?
> > 
> > Should we also have a phydev->inband tristate, taking values "unknown,
> > enabled, disabled" which the PHY driver is required to update in their
> > read_status callback if they dynamically change their interface type?
> > (Although then phylink will need to figure out how to deal with that.)
> 
> I don't have such PHY to test with, but I think the easiest way would be
> to just call the validation method again, after we change the
> phydev->interface value.

I'm not sure I follow. It is the PHY driver that is in charge of
changing phydev->interface dynamically, since that is precisely what
the hardware is doing.

88x3310 hardware, when connected using a single lane serdes without
rate adaption will switch the MAC side interface between 10GBASE-R,
5GBASE-R, 2500BASE-X and SGMII depending on the media side speed (10G,
5G, 2.5G, 1G, 100M, 10M.)

BCM84881 does the same, switching dynamically between 10GBASE-R,
2500BASE-X and SGMII (never with inband signalling - it's not
supported in hardware) for 10G, 2.5G, 1G and 100M speeds. 10M is not
supported.

With both these PHYs, you don't get to say "I want you to operate in
_this_ single interface mode", with the exception of 88x3310 with rate
adaption, they aren't designed for that. As soon as there is link on
the media side, the PHYs automatically reconfigure their MAC side with
no intervention from MDIO.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

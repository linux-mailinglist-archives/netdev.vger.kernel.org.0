Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98619638B78
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 14:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiKYNnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 08:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiKYNny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 08:43:54 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B45113DD9
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 05:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nw9i7z8WP44gT2RtjzGghuuYoUooIgyXfr9jN16ABCg=; b=AVxRZJQFZSGHszluxCWQ8piIOA
        QTeKMkdFuTzmcyhb2Ml19vW1gRc6/H0AXP/JQ4dPcnF3sDUe1gClU+Z8O+E1druybOFCwEKZANSSL
        t2cmAVQPpP8+Ms2KFfnkNs4ZekGlZslX+SHhcYLKjnJwbpAQGp8KK647JxI3qKvqA2mRbnYEzJEat
        8fUxMappmHyAw2yPEurEMw517ojrtx5gr/WO2T5+eIu7T941eyAelL5zcIP3BegxlxweeGPSFUfan
        vYXYXn35LSGNfLXcWg2GQ4chvHuNsoH///LQP8/Aern7t5gUK+ezsP1sCno4SqRIe3xyeAMKKJ4ae
        TiEb9oHQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35426)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oyYzW-00058X-7K; Fri, 25 Nov 2022 13:43:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oyYzO-0006Do-Mx; Fri, 25 Nov 2022 13:43:34 +0000
Date:   Fri, 25 Nov 2022 13:43:34 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 3/8] net: phy: bcm84881: move the in-band
 capability check where it belongs
Message-ID: <Y4DGhv/6BHNaMEYQ@shell.armlinux.org.uk>
References: <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
 <Y3yvd0uyG2tNeED3@shell.armlinux.org.uk>
 <20221122121122.klqkw4onjxabyi22@skbuf>
 <Y3z/xcbYMQFM5SN4@shell.armlinux.org.uk>
 <20221122175603.soux2q2cxs2wfsun@skbuf>
 <Y30U1tHqLw0SWwo1@shell.armlinux.org.uk>
 <20221122193618.p57qrvhymeegu7cs@skbuf>
 <Y34NK9h86cgYmcoM@shell.armlinux.org.uk>
 <Y34b+7IOaCX401vR@shell.armlinux.org.uk>
 <20221125123022.cnqobhnuzyqb5ukw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125123022.cnqobhnuzyqb5ukw@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Fri, Nov 25, 2022 at 02:30:42PM +0200, Vladimir Oltean wrote:
> Hi Russell,
> 
> Sorry for the delay. Had to do something else yesterday and the day before.

I think there was some kind of celebration going on in the US for at
least one of those days...

> I tested the patch and it does detect the operating mode of my PHY.

Thanks for testing.

> My modules are these:
> 
> [    6.465788] sfp sfp-0: module UBNT  UF-RJ45-1G  rev 1.0  sn X20072804742  dc 200617
> ethtool -m dpmac7
>         Identifier              : 0x03 (SFP)
>         Extended identifier     : 0x04 (GBIC/SFP defined by 2-wire interface ID)
>         Connector               : 0x00 (unknown or unspecified)
>         Transceiver codes       : 0x00 0x00 0x00 0x08 0x00 0x00 0x00 0x00 0x00
>         Transceiver type        : Ethernet: 1000BASE-T
>         Encoding                : 0x01 (8B/10B)
>         BR, Nominal             : 1300MBd
>         Rate identifier         : 0x00 (unspecified)
>         Length (SMF,km)         : 0km
>         Length (SMF)            : 0m
>         Length (50um)           : 0m
>         Length (62.5um)         : 0m
>         Length (Copper)         : 100m
>         Length (OM3)            : 0m
>         Laser wavelength        : 0nm
>         Vendor name             : UBNT
>         Vendor OUI              : 00:00:00
>         Vendor PN               : UF-RJ45-1G
>         Vendor rev              : 1.0
>         Option values           : 0x00 0x1a
>         Option                  : RX_LOS implemented
>         Option                  : TX_FAULT implemented
>         Option                  : TX_DISABLE implemented
>         BR margin, max          : 0%
>         BR margin, min          : 0%
>         Vendor SN               : X20072804742
>         Date code               : 200617
> 
> Here is how the PHY driver does a few things:
> 
> [ 3079.596985] fsl_dpaa2_eth dpni.1 dpmac7: configuring for inband/sgmii link mode
> [ 3079.689892] fsl_dpaa2_eth dpni.1 dpmac7: PHY driver reported AN inband 0x4 // PHY_AN_INBAND_ON_TIMEOUT
> [ 3079.696826] fsl_dpaa2_eth dpni.1 dpmac7: switched to phy/sgmii link mode
> [ 3079.779656] Marvell 88E1111 i2c:sfp-0:16: m88e1111_config_init_sgmii: EXT_SR before 0x9088 after 0x9084, fiber page BMCR 0x1140
> [ 3079.865386] fsl_dpaa2_eth dpni.1 dpmac7: PHY [i2c:sfp-0:16] driver [Marvell 88E1111] (irq=POLL)
> 
> So the default EXT_SR is being changed by the PHY driver from 0x9088 to
> 0x9084 (MII_M1111_HWCFG_MODE_COPPER_1000X_AN -> MII_M1111_HWCFG_MODE_SGMII_NO_CLK).
> 
> I don't know if it's possible to force these modules to operate in
> 1000BASE-X mode. If you're interested in the results there, please give
> me some guidance.

The value of "EXT_SR before" is 1000base-X, so if you change sfp-bus.c::
sfp_select_interface() to use 1000BASEX instead of SGMII then you'll be
using 1000BASEX instead (and it should work, although at fixed 1G
speeds). The only reason the module is working in SGMII mode is because,
as you've noticed above, we switch it to SGMII mode in
m88e1111_config_init_sgmii().

> I was curious if the fiber page BMCR has an effect for in-band autoneg,
> and at least for SGMII it surely does. If I add this to
> m88e1111_config_init_sgmii():
> 
> 	phy_modify_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR,
> 			 BMCR_ANENABLE, 0);
> 
> (and force an intentional mismatch) then I am able to break the link
> with my Lynx PCS.

Yes, the fiber page is re-used for the host side of the link when
operating in SGMII and 1000baseX modes, so changes there have the
expected effect.

> If my hunch is correct that this also holds true for 1000BASE-X, then
> you are also correct that m88e1111_config_init_1000basex() only allows
> AN bypass but does not seem to enable in-band AN in itself, if it wasn't
> enabled.
> 
> The implication here is that maybe we should test for the fiber page
> BMCR in both SGMII and 1000BASE-X modes?

I think a more comprehensive test would be to write the fiber page
BMCR with 0x140 before changing the mode from 1000baseX to SGMII and
see whether the BMCR changes value. My suspicion is it won't, and
the hwcfg_mode only has an effect on the settings in the fiber page
under hardware reset conditions, and mode changes have no effect on
the fiber page.

If that is correct, then I think we have two options:
1. make m88e1111_config_init_1000basex() actually do what the comment
   says, and enable AN in the fiber page (risky). That would make it
   conform with how I implemented the validate_an_inband() function.
2. update the comment in m88e1111_config_init_1000basex() to reflect
   what's actually happening with the hardware, and make
   validate_an_inband() read the fiber page BMCR for 1000base-X too.

> Should we call m88e1111_validate_an_inband() also for the Finisar
> variant of the 88E1111? What about 88E1112?

Entirely probable - this patch is minimalist in order for your tests,
I didn't bother with the 151x devices. I'll prepare a more
comprehensive patch next week.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

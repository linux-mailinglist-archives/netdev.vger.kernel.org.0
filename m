Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57716635C69
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 13:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbiKWMIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 07:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236810AbiKWMIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 07:08:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2377B21834
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=edm44DsVHWgSO0FaiVAtBxqjswB4c/JUGDheelzEyAM=; b=T8jfEveY9eHyNBeg/e+j6rTSkx
        sI5Zicf15ZMvfquBYjTmkiQzlwYMdF/29gKv0mwHI66uzTqFzQ75A9DrHFhvbnOnbpfa+NyMuPcDL
        tilTL6YJvwugKHqhzkQhPBDKOWITWuosQRCbLlIc0B63fGMfd6mPPuNT34EZkJZZYbjOHoRpNlch5
        0H36nObW3J3LgLUPl4sI95DLtyRhVZxjSYVfaz2YW5tRcF6INK+no91fi3m0Af8itTRw8w1oQbE29
        dXFIiqnTdE6xisUb0OQIJDL2hZlyki2H+VDI9xSB4cpUdKwvea2J4ULIAzSEJWZu8X8rpm0co4evi
        lmzmQwzw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35402)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oxoY8-0002pw-BY; Wed, 23 Nov 2022 12:08:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oxoXz-0004Fp-DH; Wed, 23 Nov 2022 12:08:11 +0000
Date:   Wed, 23 Nov 2022 12:08:11 +0000
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
Message-ID: <Y34NK9h86cgYmcoM@shell.armlinux.org.uk>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-4-vladimir.oltean@nxp.com>
 <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
 <Y3yvd0uyG2tNeED3@shell.armlinux.org.uk>
 <20221122121122.klqkw4onjxabyi22@skbuf>
 <Y3z/xcbYMQFM5SN4@shell.armlinux.org.uk>
 <20221122175603.soux2q2cxs2wfsun@skbuf>
 <Y30U1tHqLw0SWwo1@shell.armlinux.org.uk>
 <20221122193618.p57qrvhymeegu7cs@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122193618.p57qrvhymeegu7cs@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 09:36:59PM +0200, Vladimir Oltean wrote:
> I think we're in agreement, but please let's wait until tomorrow, I need
> to take a break for today.

I think we do have a sort of agreement... but lets give this a go. The
following should be sufficient for copper SFP modules using the 88E1111
PHY. However, I haven't build-tested this patch yet.

Reading through the documentation has brought up some worms in this
area. :(

It may be worth printing the fiber page BMCR and extsr at various
strategic points in this driver and reporting back if things don't
seem to be working right for your modules. In the mean time, I'll try
to see how the modules in the Honeycomb appear to be setup at power-up
and after the driver has configured the PHY... assuming I left both
MicroUSBs connected and the board has a network connection via the
main ethernet jack.

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 3c54d7d0f17f..9d537a2bccda 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -669,6 +669,54 @@ static int marvell_config_aneg_fiber(struct phy_device *phydev)
 	return genphy_check_and_restart_aneg(phydev, changed);
 }
 
+static int m88e1111_validate_an_inband(struct phy_device *phydev,
+				       phy_interface_t interface)
+{
+	int hwcfg_mode, extsr, bmcr;
+
+	if (interface != PHY_INTERFACE_MODE_1000BASEX &&
+	    interface != PHY_INTERFACE_MODE_SGMII)
+		return PHY_AN_INBAND_UNKNOWN;
+
+	extsr = phy_read(phydev, MII_M1111_PHY_EXT_SR);
+	if (extsr < 0)
+		return PHY_AN_INBAND_UNKNOWN;
+
+	hwcfg_mode = extsr & MII_M1111_HWCFG_MODE_MASK;
+
+	/* If we are in 1000base-X no-AN hwcfg_mode,
+	 * m88e1111_config_init_1000basex() will allegedly enable AN and
+	 * allow AN bypass - but there is a question over whether that is
+	 * actually the case. Let's follow what the comment says, and assume
+	 * that it was actually tested.
+	 */
+	if (interface == PHY_INTERFACE_MODE_1000BASEX &&
+	    hwcfg_mode == MII_M1111_HWCFG_MODE_COPPER_1000X_NOAN)
+		return PHY_AN_INBAND_ON_TIMEOUT;
+
+	/* Otherwise, we leave the AN enable bit and the AN bypass bit
+	 * alone, so we need to read the registers to determine how the
+	 * MAC facing side of the PHY has been setup by firmware and/or
+	 * hardware reset.
+	 *
+	 * If the AN enable bit is clear, then all in-band signalling
+	 * on the SGMII/1000base-X side is disabled. Otherwise, AN is
+	 * enabled. If the bypass bit is set, AN can complete without
+	 * a response from the partner (MAC).
+	 */
+	bmcr = phy_read_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR);
+	if (bmcr < 0)
+		return PHY_AN_INBAND_UNKNOWN;
+
+	if (!(bmcr & BMCR_ANENABLE))
+		return PHY_AN_INBAND_OFF;
+
+	if (extsr & MII_M1111_HWCFG_SERIAL_AN_BYPASS)
+		return PHY_AN_INBAND_ON_TIMEOUT;
+
+	return PHY_AN_INBAND_ON;
+}
+
 static int m88e1111_config_aneg(struct phy_device *phydev)
 {
 	int extsr = phy_read(phydev, MII_M1111_PHY_EXT_SR);
@@ -915,7 +963,10 @@ static int m88e1111_config_init_1000basex(struct phy_device *phydev)
 	if (extsr < 0)
 		return extsr;
 
-	/* If using copper mode, ensure 1000BaseX auto-negotiation is enabled */
+	/* If using copper mode, ensure 1000BaseX auto-negotiation is enabled.
+	 * FIXME: does this actually enable 1000BaseX auto-negotiation if it
+	 * was previously disabled in the Fiber BMCR? 2.3.1.6 suggests not!
+	 */
 	mode = extsr & MII_M1111_HWCFG_MODE_MASK;
 	if (mode == MII_M1111_HWCFG_MODE_COPPER_1000X_NOAN) {
 		err = phy_modify(phydev, MII_M1111_PHY_EXT_SR,
@@ -2997,6 +3048,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1111_get_tunable,
 		.set_tunable = m88e1111_set_tunable,
+		.validate_an_inband = m88e1111_validate_an_inband,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1111_FINISAR,

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

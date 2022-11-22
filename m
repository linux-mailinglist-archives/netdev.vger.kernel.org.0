Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CDE633B33
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbiKVLVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiKVLUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:20:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9725B5B7
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RYtpynv/kogTOkI7TLHvo2p/ncitXmtCLLJ+tXI0lNU=; b=FxmC0QuRwhmbDzGQTJ2xEnft63
        WsvydlPeI6q5SfJtVeex9MDVxyNoij5iY5yyZzt7SAx3Hi5+OBOBjZPvkUovubVkwjhOAYlqxLOav
        aYOWI2fALk0yiycskgB2O5iwytArwq8LmWZnCglL62fYSWGW/iq5XKf9BOV4LjoyropsZYrmjclyJ
        Jqf/E1brPgXy6Nf3WPLbS3rfkktNQsHIJAsBx92c8nRjoWZwWKT0Yx8UHm96JCSDDHEmpXqa2W3Wz
        WCCYbsCu+L6hL3Ml7d+BaWP2Zi960HC4rQkdLngi+acsgJkjMy9rMn20DI9hChAlSVTSCqNN6VziB
        dQEPyZOg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35378)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oxRGD-0001PG-NQ; Tue, 22 Nov 2022 11:16:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oxRG3-0003HC-TZ; Tue, 22 Nov 2022 11:16:07 +0000
Date:   Tue, 22 Nov 2022 11:16:07 +0000
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
Message-ID: <Y3yvd0uyG2tNeED3@shell.armlinux.org.uk>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-4-vladimir.oltean@nxp.com>
 <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 09:38:43AM +0000, Russell King (Oracle) wrote:
> Also, if we get the Marvell driver implementing validate_an_inband()
> then I believe we can get rid of other parts of this patch - 88E1111 is
> the commonly used accessible PHY on gigabit SFPs, as this PHY implements
> I2C access natively. As I mentioned, Marvell PHYs can be set to no
> inband, requiring inband, or inband with bypass mode enabled. So we
> need to decide how we deal with that - especially if we're going to be
> changing the mode from 1000base-X to SGMII (which we do on some SFP
> modules so they work at 10/100/1000.)

For the Marvell 88E1111:

- If switching into 1000base-X mode, then bypass mode is enabled by
m88e1111_config_init_1000basex(). However, if AN is disabled in the
fibre page BMCR (e.g. by firmware), then AN won't be used.

- If switching into SGMII mode, then bypass mode is left however it was
originally set by m88e1111_config_init_sgmii() - so it may be allowed
or it may be disallowed, which means it's whatever the hardware
defaulted to or firmware set it as.

For the 88e151x (x=0,2,8) it looks like bypass mode defaults to being
allowed on hardware reset, but firmware may change that.

I don't think we make much of an effort to configure other Marvell
PHYs, relying on their hardware reset defaults or firmware to set
them appropriately.

So, I think for 88e151x, we should implement something like:

	int mode, bmcr, fscr2;

	/* RGMII too? I believe RGMII can signal inband as well, so we
	 * may need to handle that as well.
	 */
	if (interface != PHY_INTERFACE_MODE_SGMII &&
	    interface != PHY_INTERFACE_MODE_1000BASE_X)
		return PHY_AN_INBAND_UNKNOWN;

	bmcr = phy_read_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR);
	if (bmcr < 0)
		return SOME_ERROR?

	mode = PHY_AN_INBAND_OFF;

	if (bmcr & BMCR_ANENABLE) {
		mode = PHY_AN_INBAND_ON;

		fscr2 = phy_read_paged(phydev, MII_MARVELL_FIBER_PAGE,
				       0x1a);
		if (fscr2 & BIT(6))
			mode |= PHY_AN_INBAND_TIMEOUT;
	}

	return mode;

Obviously adding register definitions for BIT(6) and 01a.

For the 88E1111:

	int mode, hwcfg;

	/* If operating in 1000base-X mode, we always turn on inband
	 * and allow bypass.
	 */
	if (interface == PHY_INTERFACE_MODE_1000BASEX)
		return PHY_AN_INBAND_ON | PHY_AN_INBAND_TIMEOUT;

	if (interface == PHY_INTERFACE_MODE_SGMII) {
		hwcfg = phy_read(phydev, MII_M1111_PHY_EXT_SR);
		if (hwcfg < 0)
			return SOME_ERROR?

		mode = PHY_AN_INBAND_ON;
		if (hwcfg & MII_M1111_HWCFG_SERIAL_AN_BYPASS)
			mode |= PHY_AN_INBAND_TIMEOUT;

		return mode;
	}

	return PHY_AN_INBAND_UNKNOWN;

Maybe?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

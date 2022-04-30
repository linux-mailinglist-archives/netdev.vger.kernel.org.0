Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B30E515F96
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 19:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243664AbiD3Rea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 13:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbiD3Rea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 13:34:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CA937022
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 10:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ol/uOEuFX2PVGfYZEYVS48n+1LQNiWko42V6PB5HjTc=; b=rNRH345lEMw++zKNUvVXTQ7Ngq
        BvqwQN70+A7SbVIkbJnVqt1NjOf85W0nqD8ThRxTJcB1Tk8x9NE4Hk+KN/CMt/0vBoJlO05wQ7nsW
        XKbMNcuwsawXWk3hxZlpaLEPkzlnz+Fl3TYTWUBfvUyEkUUgJKTZb++t6C4lq8ukUk70=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkqvl-000eoN-9q; Sat, 30 Apr 2022 19:30:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v1 3/5] net: phy: bcm87xx: Use mmd helpers
Date:   Sat, 30 Apr 2022 19:30:35 +0200
Message-Id: <20220430173037.156823-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220430173037.156823-1-andrew@lunn.ch>
References: <20220430173037.156823-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than construct special phy device addresses to access C45
registers, use the mmd helpers. These will directly call the C45 API
of the MDIO bus driver.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/bcm87xx.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/bcm87xx.c b/drivers/net/phy/bcm87xx.c
index 313563482690..cc2858107668 100644
--- a/drivers/net/phy/bcm87xx.c
+++ b/drivers/net/phy/bcm87xx.c
@@ -10,12 +10,12 @@
 #define PHY_ID_BCM8706	0x0143bdc1
 #define PHY_ID_BCM8727	0x0143bff0
 
-#define BCM87XX_PMD_RX_SIGNAL_DETECT	(MII_ADDR_C45 | 0x1000a)
-#define BCM87XX_10GBASER_PCS_STATUS	(MII_ADDR_C45 | 0x30020)
-#define BCM87XX_XGXS_LANE_STATUS	(MII_ADDR_C45 | 0x40018)
+#define BCM87XX_PMD_RX_SIGNAL_DETECT	0x000a
+#define BCM87XX_10GBASER_PCS_STATUS	0x0020
+#define BCM87XX_XGXS_LANE_STATUS	0x0018
 
-#define BCM87XX_LASI_CONTROL (MII_ADDR_C45 | 0x39002)
-#define BCM87XX_LASI_STATUS (MII_ADDR_C45 | 0x39005)
+#define BCM87XX_LASI_CONTROL		0x9002
+#define BCM87XX_LASI_STATUS		0x9005
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
 /* Set and/or override some configuration registers based on the
@@ -54,11 +54,10 @@ static int bcm87xx_of_reg_init(struct phy_device *phydev)
 		u16 reg		= be32_to_cpup(paddr++);
 		u16 mask	= be32_to_cpup(paddr++);
 		u16 val_bits	= be32_to_cpup(paddr++);
-		u32 regnum = mdiobus_c45_addr(devid, reg);
 		int val = 0;
 
 		if (mask) {
-			val = phy_read(phydev, regnum);
+			val = phy_read_mmd(phydev, devid, reg);
 			if (val < 0) {
 				ret = val;
 				goto err;
@@ -67,7 +66,7 @@ static int bcm87xx_of_reg_init(struct phy_device *phydev)
 		}
 		val |= val_bits;
 
-		ret = phy_write(phydev, regnum, val);
+		ret = phy_write_mmd(phydev, devid, reg, val);
 		if (ret < 0)
 			goto err;
 	}
@@ -104,21 +103,24 @@ static int bcm87xx_read_status(struct phy_device *phydev)
 	int pcs_status;
 	int xgxs_lane_status;
 
-	rx_signal_detect = phy_read(phydev, BCM87XX_PMD_RX_SIGNAL_DETECT);
+	rx_signal_detect = phy_read_mmd(phydev, MDIO_MMD_PMAPMD,
+					BCM87XX_PMD_RX_SIGNAL_DETECT);
 	if (rx_signal_detect < 0)
 		return rx_signal_detect;
 
 	if ((rx_signal_detect & 1) == 0)
 		goto no_link;
 
-	pcs_status = phy_read(phydev, BCM87XX_10GBASER_PCS_STATUS);
+	pcs_status = phy_read_mmd(phydev, MDIO_MMD_PCS,
+				  BCM87XX_10GBASER_PCS_STATUS);
 	if (pcs_status < 0)
 		return pcs_status;
 
 	if ((pcs_status & 1) == 0)
 		goto no_link;
 
-	xgxs_lane_status = phy_read(phydev, BCM87XX_XGXS_LANE_STATUS);
+	xgxs_lane_status = phy_read_mmd(phydev, MDIO_MMD_PHYXS,
+					BCM87XX_XGXS_LANE_STATUS);
 	if (xgxs_lane_status < 0)
 		return xgxs_lane_status;
 
@@ -139,25 +141,27 @@ static int bcm87xx_config_intr(struct phy_device *phydev)
 {
 	int reg, err;
 
-	reg = phy_read(phydev, BCM87XX_LASI_CONTROL);
+	reg = phy_read_mmd(phydev, MDIO_MMD_PCS, BCM87XX_LASI_CONTROL);
 
 	if (reg < 0)
 		return reg;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
-		err = phy_read(phydev, BCM87XX_LASI_STATUS);
+		err = phy_read_mmd(phydev, MDIO_MMD_PCS, BCM87XX_LASI_STATUS);
 		if (err)
 			return err;
 
 		reg |= 1;
-		err = phy_write(phydev, BCM87XX_LASI_CONTROL, reg);
+		err = phy_write_mmd(phydev, MDIO_MMD_PCS,
+				    BCM87XX_LASI_CONTROL, reg);
 	} else {
 		reg &= ~1;
-		err = phy_write(phydev, BCM87XX_LASI_CONTROL, reg);
+		err = phy_write_mmd(phydev, MDIO_MMD_PCS,
+				    BCM87XX_LASI_CONTROL, reg);
 		if (err)
 			return err;
 
-		err = phy_read(phydev, BCM87XX_LASI_STATUS);
+		err = phy_read_mmd(phydev, MDIO_MMD_PCS, BCM87XX_LASI_STATUS);
 	}
 
 	return err;
-- 
2.35.2


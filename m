Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5F61D4767
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 09:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgEOHxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 03:53:12 -0400
Received: from 220-134-220-36.HINET-IP.hinet.net ([220.134.220.36]:24898 "EHLO
        ns.kevlo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbgEOHxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 03:53:11 -0400
Received: from ns.kevlo.org (localhost [127.0.0.1])
        by ns.kevlo.org (8.15.2/8.15.2) with ESMTPS id 04F5MMWA015463
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 15 May 2020 13:22:24 +0800 (CST)
        (envelope-from kevlo@ns.kevlo.org)
Received: (from kevlo@localhost)
        by ns.kevlo.org (8.15.2/8.15.2/Submit) id 04F5MKcS015462;
        Fri, 15 May 2020 13:22:20 +0800 (CST)
        (envelope-from kevlo)
Date:   Fri, 15 May 2020 13:22:19 +0800
From:   Kevin Lo <kevlo@kevlo.org>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net] net: phy: broadcom: add support for BCM54811 PHY
Message-ID: <20200515052219.GA15435@ns.kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.8.0 (2017-02-23)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BCM54811 PHY shares many similarities with the already supported BCM54810
PHY but additionally requires some semi-unique configuration.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index d14d91b759b7..0360a5cfdb9e 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -195,7 +195,8 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
 	if (BRCM_PHY_MODEL(phydev) != PHY_ID_BCM57780 &&
 	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610 &&
 	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610M &&
-	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54810)
+	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54810 &&
+	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54811)
 		return;
 
 	val = bcm_phy_read_shadow(phydev, BCM54XX_SHD_SCR3);
@@ -214,8 +215,10 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
 		clk125en = false;
 	} else {
 		if (phydev->dev_flags & PHY_BRCM_RX_REFCLK_UNUSED) {
-			/* Here, bit 0 _enables_ CLK125 when set */
-			val &= ~BCM54XX_SHD_SCR3_DEF_CLK125;
+			if (BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54811) {
+				/* Here, bit 0 _enables_ CLK125 when set */
+				val &= ~BCM54XX_SHD_SCR3_DEF_CLK125;
+			}
 			clk125en = false;
 		}
 	}
@@ -226,7 +229,8 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
 		val |= BCM54XX_SHD_SCR3_DLLAPD_DIS;
 
 	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) {
-		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810)
+		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810 ||
+		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54811)
 			val |= BCM54810_SHD_SCR3_TRDDAPD;
 		else
 			val |= BCM54XX_SHD_SCR3_TRDDAPD;
@@ -331,6 +335,32 @@ static int bcm54xx_resume(struct phy_device *phydev)
 	return bcm54xx_config_init(phydev);
 }
 
+static int bcm54811_config_init(struct phy_device *phydev)
+{
+	int err, reg;
+
+	/* Disable BroadR-Reach function. */
+	reg = bcm_phy_read_exp(phydev, BCM54810_EXP_BROADREACH_LRE_MISC_CTL);
+	reg &= ~BCM54810_EXP_BROADREACH_LRE_MISC_CTL_EN;
+	err = bcm_phy_write_exp(phydev, BCM54810_EXP_BROADREACH_LRE_MISC_CTL,
+				reg);
+	if (err < 0)
+		return err;
+
+	err = bcm54xx_config_init(phydev);
+
+	/* Enable CLK125 MUX on LED4 if ref clock is enabled. */
+	if (!(phydev->dev_flags & PHY_BRCM_RX_REFCLK_UNUSED)) {
+		reg = bcm_phy_read_exp(phydev, BCM54612E_EXP_SPARE0);
+		err = bcm_phy_write_exp(phydev, BCM54612E_EXP_SPARE0,
+					BCM54612E_LED4_CLK125OUT_EN | reg);
+		if (err < 0)
+			return err; 
+        }
+
+	return err;
+}
+
 static int bcm5482_config_init(struct phy_device *phydev)
 {
 	int err, reg;
@@ -726,6 +756,17 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_intr    = bcm_phy_config_intr,
 	.suspend	= genphy_suspend,
 	.resume		= bcm54xx_resume,
+}, {
+	.phy_id         = PHY_ID_BCM54811,
+	.phy_id_mask    = 0xfffffff0,
+	.name           = "Broadcom BCM54811",
+	/* PHY_GBIT_FEATURES */
+	.config_init    = bcm54811_config_init,
+	.config_aneg    = bcm5481_config_aneg,
+	.ack_interrupt  = bcm_phy_ack_intr,
+	.config_intr    = bcm_phy_config_intr,
+	.suspend	= genphy_suspend,
+	.resume		= bcm54xx_resume,
 }, {
 	.phy_id		= PHY_ID_BCM5482,
 	.phy_id_mask	= 0xfffffff0,
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index f4b77018c625..8f1a06bb3ac2 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -16,6 +16,7 @@
 #define PHY_ID_BCM5481			0x0143bca0
 #define PHY_ID_BCM5395			0x0143bcf0
 #define PHY_ID_BCM54810			0x03625d00
+#define PHY_ID_BCM54811			0x03625cc0
 #define PHY_ID_BCM5482			0x0143bcb0
 #define PHY_ID_BCM5411			0x00206070
 #define PHY_ID_BCM5421			0x002060e0

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C64318F9CB
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 17:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgCWQfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 12:35:21 -0400
Received: from mars.blocktrron.ovh ([51.254.112.43]:41252 "EHLO
        mail.blocktrron.ovh" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727277AbgCWQfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 12:35:21 -0400
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Mar 2020 12:35:20 EDT
Received: from dbauer-t470.home.david-bauer.net (p200300E53F051400556931CCC843E1C6.dip0.t-ipconnect.de [IPv6:2003:e5:3f05:1400:5569:31cc:c843:e1c6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.blocktrron.ovh (Postfix) with ESMTPSA id 235A91E1CF
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 17:27:38 +0100 (CET)
From:   David Bauer <mail@david-bauer.net>
To:     netdev@vger.kernel.org
Subject: [PATCH] net: phy: at803x: select correct page on initialization
Date:   Mon, 23 Mar 2020 17:27:30 +0100
Message-Id: <20200323162730.88236-1-mail@david-bauer.net>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Atheros AR8031 and AR8033 expose different registers for SGMII/Fiber
as well as the copper side of the PHY depending on the BT_BX_REG_SEL bit
in the chip configure register.

The driver assumes the copper side is selected on probe, but this might
not be the case depending which page was last selected by the
bootloader.

Select the copper page when initializing the configuration to circumvent
this.

Signed-off-by: David Bauer <mail@david-bauer.net>
---
 drivers/net/phy/at803x.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 481cf48c9b9e..c027ae820a6a 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -103,6 +103,9 @@
 #define AT803X_CLK_OUT_STRENGTH_HALF		1
 #define AT803X_CLK_OUT_STRENGTH_QUARTER		2
 
+#define AT803X_PAGE_COPPER		0
+#define AT803X_PAGE_FIBER		1
+
 #define ATH9331_PHY_ID 0x004dd041
 #define ATH8030_PHY_ID 0x004dd076
 #define ATH8031_PHY_ID 0x004dd074
@@ -160,6 +163,21 @@ static int at803x_debug_reg_mask(struct phy_device *phydev, u16 reg,
 	return phy_write(phydev, AT803X_DEBUG_DATA, val);
 }
 
+static int at803x_switch_page(struct phy_device *phydev, u8 page)
+{
+	int ccr = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
+
+	if (ccr < 0)
+		return ccr;
+
+	if (page == AT803X_PAGE_COPPER)
+		ccr = ccr | AT803X_BT_BX_REG_SEL;
+	else
+		ccr = ccr & ~AT803X_BT_BX_REG_SEL;
+
+	return phy_write(phydev, AT803X_REG_CHIP_CONFIG, ccr);
+}
+
 static int at803x_enable_rx_delay(struct phy_device *phydev)
 {
 	return at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0, 0,
@@ -534,6 +552,12 @@ static int at803x_config_init(struct phy_device *phydev)
 {
 	int ret;
 
+	if (at803x_match_phy_id(phydev, ATH8031_PHY_ID)) {
+		ret = at803x_switch_page(phydev, AT803X_PAGE_COPPER);
+		if (ret < 0)
+			return ret;
+	}
+
 	/* The RX and TX delay default is:
 	 *   after HW reset: RX delay enabled and TX delay disabled
 	 *   after SW reset: RX delay enabled, while TX delay retains the
@@ -641,7 +665,7 @@ static int at803x_aneg_done(struct phy_device *phydev)
 		return aneg_done;
 
 	/* switch to SGMII/fiber page */
-	phy_write(phydev, AT803X_REG_CHIP_CONFIG, ccr & ~AT803X_BT_BX_REG_SEL);
+	at803x_switch_page(phydev, AT803X_PAGE_FIBER);
 
 	/* check if the SGMII link is OK. */
 	if (!(phy_read(phydev, AT803X_PSSR) & AT803X_PSSR_MR_AN_COMPLETE)) {
@@ -649,7 +673,7 @@ static int at803x_aneg_done(struct phy_device *phydev)
 		aneg_done = 0;
 	}
 	/* switch back to copper page */
-	phy_write(phydev, AT803X_REG_CHIP_CONFIG, ccr | AT803X_BT_BX_REG_SEL);
+	at803x_switch_page(phydev, AT803X_PAGE_COPPER);
 
 	return aneg_done;
 }
-- 
2.25.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7DB35FDE3
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 00:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbhDNWf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 18:35:58 -0400
Received: from perseus.uberspace.de ([95.143.172.134]:40368 "EHLO
        perseus.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbhDNWf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 18:35:57 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2021 18:35:57 EDT
Received: (qmail 19010 invoked from network); 14 Apr 2021 22:28:52 -0000
Received: from localhost (HELO localhost) (127.0.0.1)
  by perseus.uberspace.de with SMTP; 14 Apr 2021 22:28:52 -0000
From:   David Bauer <mail@david-bauer.net>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch
Subject: [PATCH net-next 1/2] net: phy: at803x: use paged reads
Date:   Thu, 15 Apr 2021 00:28:40 +0200
Message-Id: <20210414222841.82548-1-mail@david-bauer.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the page-switching in at803x_aneg_done to use
paged reads as suggested by Andrew Lunn.

This way, potential race conditions are avoided, as the
MDIO lock was previously not taken.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David Bauer <mail@david-bauer.net>
---
 drivers/net/phy/at803x.c | 42 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index c2aa4c92edde..b3243ad570c7 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -144,6 +144,9 @@
 #define ATH8035_PHY_ID 0x004dd072
 #define AT8030_PHY_ID_MASK			0xffffffef
 
+#define AT803X_PAGE_FIBER		0
+#define AT803X_PAGE_COPPER		1
+
 MODULE_DESCRIPTION("Qualcomm Atheros AR803x PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
 MODULE_LICENSE("GPL");
@@ -198,6 +201,35 @@ static int at803x_debug_reg_mask(struct phy_device *phydev, u16 reg,
 	return phy_write(phydev, AT803X_DEBUG_DATA, val);
 }
 
+static int at803x_write_page(struct phy_device *phydev, int page)
+{
+	int mask;
+	int set;
+
+	if (page == AT803X_PAGE_COPPER) {
+		set = AT803X_BT_BX_REG_SEL;
+		mask = 0;
+	} else {
+		set = 0;
+		mask = AT803X_BT_BX_REG_SEL;
+	}
+
+	return __phy_modify(phydev, AT803X_REG_CHIP_CONFIG, mask, set);
+}
+
+static int at803x_read_page(struct phy_device *phydev)
+{
+	int ccr = __phy_read(phydev, AT803X_REG_CHIP_CONFIG);
+
+	if (ccr < 0)
+		return ccr;
+
+	if (ccr & AT803X_BT_BX_REG_SEL)
+		return AT803X_PAGE_COPPER;
+
+	return AT803X_PAGE_FIBER;
+}
+
 static int at803x_enable_rx_delay(struct phy_device *phydev)
 {
 	return at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0, 0,
@@ -753,6 +785,7 @@ static void at803x_link_change_notify(struct phy_device *phydev)
 
 static int at803x_aneg_done(struct phy_device *phydev)
 {
+	int pssr;
 	int ccr;
 
 	int aneg_done = genphy_aneg_done(phydev);
@@ -767,16 +800,13 @@ static int at803x_aneg_done(struct phy_device *phydev)
 	if ((ccr & AT803X_MODE_CFG_MASK) != AT803X_MODE_CFG_SGMII)
 		return aneg_done;
 
-	/* switch to SGMII/fiber page */
-	phy_write(phydev, AT803X_REG_CHIP_CONFIG, ccr & ~AT803X_BT_BX_REG_SEL);
+	pssr = phy_read_paged(phydev, AT803X_PAGE_FIBER, AT803X_PSSR);
 
 	/* check if the SGMII link is OK. */
-	if (!(phy_read(phydev, AT803X_PSSR) & AT803X_PSSR_MR_AN_COMPLETE)) {
+	if (!(pssr & AT803X_PSSR_MR_AN_COMPLETE)) {
 		phydev_warn(phydev, "803x_aneg_done: SGMII link is not ok\n");
 		aneg_done = 0;
 	}
-	/* switch back to copper page */
-	phy_write(phydev, AT803X_REG_CHIP_CONFIG, ccr | AT803X_BT_BX_REG_SEL);
 
 	return aneg_done;
 }
@@ -1196,6 +1226,8 @@ static struct phy_driver at803x_driver[] = {
 	.get_wol		= at803x_get_wol,
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
+	.read_page		= at803x_read_page,
+	.write_page		= at803x_write_page,
 	/* PHY_GBIT_FEATURES */
 	.read_status		= at803x_read_status,
 	.aneg_done		= at803x_aneg_done,
-- 
2.31.1


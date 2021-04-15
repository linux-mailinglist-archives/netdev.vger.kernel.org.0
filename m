Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7257F35FF88
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 03:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhDOB1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 21:27:32 -0400
Received: from perseus.uberspace.de ([95.143.172.134]:49056 "EHLO
        perseus.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhDOB1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 21:27:31 -0400
Received: (qmail 12997 invoked from network); 15 Apr 2021 01:27:08 -0000
Received: from localhost (HELO localhost) (127.0.0.1)
  by perseus.uberspace.de with SMTP; 15 Apr 2021 01:27:08 -0000
From:   David Bauer <mail@david-bauer.net>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch
Subject: [PATCH net-next v2] net: phy: at803x: select correct page on config init
Date:   Thu, 15 Apr 2021 03:26:50 +0200
Message-Id: <20210415012650.9825-1-mail@david-bauer.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Atheros AR8031 and AR8033 expose different registers for SGMII/Fiber
as well as the copper side of the PHY depending on the BT_BX_REG_SEL bit
in the chip configure register.

The driver assumes the copper side is selected on probe, but this might
not be the case depending which page was last selected by the
bootloader. Notably, Ubiquiti UniFi bootloaders show this behavior.

Select the copper page when probing to circumvent this.

Signed-off-by: David Bauer <mail@david-bauer.net>
---
Changes in v2:
 - rebase to latest net-next
 - squash both patches

 drivers/net/phy/at803x.c | 50 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index d7799beb811c..e0f56850edc5 100644
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
@@ -535,6 +567,7 @@ static int at803x_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
 	struct at803x_priv *priv;
+	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -542,7 +575,20 @@ static int at803x_probe(struct phy_device *phydev)
 
 	phydev->priv = priv;
 
-	return at803x_parse_dt(phydev);
+	ret = at803x_parse_dt(phydev);
+	if (ret)
+		return ret;
+
+	/* Some bootloaders leave the fiber page selected.
+	 * Switch to the copper page, as otherwise we read
+	 * the PHY capabilities from the fiber side.
+	 */
+	if (at803x_match_phy_id(phydev, ATH8031_PHY_ID)) {
+		ret = phy_select_page(phydev, AT803X_PAGE_COPPER);
+		ret = phy_restore_page(phydev, AT803X_PAGE_COPPER, ret);
+	}
+
+	return ret;
 }
 
 static void at803x_remove(struct phy_device *phydev)
@@ -1166,6 +1212,8 @@ static struct phy_driver at803x_driver[] = {
 	.get_wol		= at803x_get_wol,
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
+	.read_page		= at803x_read_page,
+	.write_page		= at803x_write_page,
 	/* PHY_GBIT_FEATURES */
 	.read_status		= at803x_read_status,
 	.config_intr		= &at803x_config_intr,
-- 
2.31.1


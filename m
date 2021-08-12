Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09823EA684
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 16:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238003AbhHLOXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 10:23:54 -0400
Received: from mail.pr-group.ru ([178.18.215.3]:62421 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233282AbhHLOXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 10:23:54 -0400
X-Greylist: delayed 1833 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Aug 2021 10:23:53 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding;
        bh=AlzlNWi2lS+3T947tdB8PTt/EsRAtcFczsyd1uMBrNY=;
        b=NzASVu70JSXHVH0rKlcU2bEBPVYRyYE5nYw7b7VAM3iYhuyEsWnSI59nyLMykgy3SUtHbHNgjTNhO
         gHi95anc1Ldl6M0CZXM8En9oX7U2P13yNHTZEkjB+SY8QAEEfBAjLIpbbIYp7mv8oNNt5H2PQkUWqf
         MElEyByKBN+nRB8UubKTkNgnraS4xff4p84ZdjC7aHeYp1fSCppzFyJLTqjij2F2TDV54QP7arKLR8
         uYaNhAjj8DiL6j7OboKQ4o3mBVTG0qCQhDpgslhzDArdG083h+QFP0zuUdHysKUOsU8DnRss6kfYX6
         Kd1mI44096G10EsVnqn4bLXn9XCym7Q==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW, TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([78.37.165.146])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Thu, 12 Aug 2021 16:52:14 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, system@metrotek.ru,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: phy: marvell: add SFP support for 88E1510
Date:   Thu, 12 Aug 2021 16:42:56 +0300
Message-Id: <20210812134256.2436-1-i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for SFP cages connected to the Marvell 88E1512 transceiver.
88E1512 supports for SGMII/1000Base-X/100Base-FX media type with RGMII
on system interface. Configure PHY to appropriate mode depending on the
type of SFP inserted. On SFP removal configure PHY to the RGMII-copper
mode so RJ-45 port can still work.

Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
---
 drivers/net/phy/marvell.c | 105 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 104 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 3de93c9f2744..ce0a7de1e08f 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -32,6 +32,7 @@
 #include <linux/marvell_phy.h>
 #include <linux/bitfield.h>
 #include <linux/of.h>
+#include <linux/sfp.h>
 
 #include <linux/io.h>
 #include <asm/irq.h>
@@ -46,6 +47,7 @@
 #define MII_MARVELL_MISC_TEST_PAGE	0x06
 #define MII_MARVELL_VCT7_PAGE		0x07
 #define MII_MARVELL_WOL_PAGE		0x11
+#define MII_MARVELL_MODE_PAGE		0x12
 
 #define MII_M1011_IEVENT		0x13
 #define MII_M1011_IEVENT_CLEAR		0x0000
@@ -176,7 +178,14 @@
 
 #define MII_88E1510_GEN_CTRL_REG_1		0x14
 #define MII_88E1510_GEN_CTRL_REG_1_MODE_MASK	0x7
+#define MII_88E1510_GEN_CTRL_REG_1_MODE_RGMII	0x0	/* RGMII to copper */
 #define MII_88E1510_GEN_CTRL_REG_1_MODE_SGMII	0x1	/* SGMII to copper */
+/* RGMII to 1000BASE-X */
+#define MII_88E1510_GEN_CTRL_REG_1_MODE_RGMII_1000X	0x2
+/* RGMII to 100BASE-FX */
+#define MII_88E1510_GEN_CTRL_REG_1_MODE_RGMII_100FX	0x3
+/* RGMII to SGMII */
+#define MII_88E1510_GEN_CTRL_REG_1_MODE_RGMII_SGMII	0x4
 #define MII_88E1510_GEN_CTRL_REG_1_RESET	0x8000	/* Soft reset */
 
 #define MII_VCT5_TX_RX_MDI0_COUPLING	0x10
@@ -2701,6 +2710,100 @@ static int marvell_probe(struct phy_device *phydev)
 	return marvell_hwmon_probe(phydev);
 }
 
+static int m88e1510_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
+{
+	struct phy_device *phydev = upstream;
+	phy_interface_t interface;
+	struct device *dev;
+	int oldpage;
+	int ret = 0;
+	u16 mode;
+
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported) = { 0, };
+
+	dev = &phydev->mdio.dev;
+
+	sfp_parse_support(phydev->sfp_bus, id, supported);
+	interface = sfp_select_interface(phydev->sfp_bus, supported);
+
+	dev_info(dev, "%s SFP module inserted\n", phy_modes(interface));
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_1000BASEX:
+		mode = MII_88E1510_GEN_CTRL_REG_1_MODE_RGMII_1000X;
+
+		break;
+	case PHY_INTERFACE_MODE_100BASEX:
+		mode = MII_88E1510_GEN_CTRL_REG_1_MODE_RGMII_100FX;
+
+		break;
+	case PHY_INTERFACE_MODE_SGMII:
+		mode = MII_88E1510_GEN_CTRL_REG_1_MODE_RGMII_SGMII;
+
+		break;
+	default:
+		dev_err(dev, "Incompatible SFP module inserted\n");
+
+		return -EINVAL;
+	}
+
+	oldpage = phy_select_page(phydev, MII_MARVELL_MODE_PAGE);
+	if (oldpage < 0)
+		goto error;
+
+	ret = __phy_modify(phydev, MII_88E1510_GEN_CTRL_REG_1,
+			   MII_88E1510_GEN_CTRL_REG_1_MODE_MASK, mode);
+	if (ret < 0)
+		goto error;
+
+	ret = __phy_set_bits(phydev, MII_88E1510_GEN_CTRL_REG_1,
+			     MII_88E1510_GEN_CTRL_REG_1_RESET);
+
+error:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
+static void m88e1510_sfp_remove(void *upstream)
+{
+	struct phy_device *phydev = upstream;
+	int oldpage;
+	int ret = 0;
+
+	oldpage = phy_select_page(phydev, MII_MARVELL_MODE_PAGE);
+	if (oldpage < 0)
+		goto error;
+
+	ret = __phy_modify(phydev, MII_88E1510_GEN_CTRL_REG_1,
+			   MII_88E1510_GEN_CTRL_REG_1_MODE_MASK,
+			   MII_88E1510_GEN_CTRL_REG_1_MODE_RGMII);
+	if (ret < 0)
+		goto error;
+
+	ret = __phy_set_bits(phydev, MII_88E1510_GEN_CTRL_REG_1,
+			     MII_88E1510_GEN_CTRL_REG_1_RESET);
+
+error:
+	phy_restore_page(phydev, oldpage, ret);
+}
+
+static const struct sfp_upstream_ops m88e1510_sfp_ops = {
+	.module_insert = m88e1510_sfp_insert,
+	.module_remove = m88e1510_sfp_remove,
+	.attach = phy_sfp_attach,
+	.detach = phy_sfp_detach,
+};
+
+static int m88e1510_probe(struct phy_device *phydev)
+{
+	int err;
+
+	err = marvell_probe(phydev);
+	if (err)
+		return err;
+
+	return phy_sfp_probe(phydev, &m88e1510_sfp_ops);
+}
+
 static struct phy_driver marvell_drivers[] = {
 	{
 		.phy_id = MARVELL_PHY_ID_88E1101,
@@ -2927,7 +3030,7 @@ static struct phy_driver marvell_drivers[] = {
 		.driver_data = DEF_MARVELL_HWMON_OPS(m88e1510_hwmon_ops),
 		.features = PHY_GBIT_FIBRE_FEATURES,
 		.flags = PHY_POLL_CABLE_TEST,
-		.probe = marvell_probe,
+		.probe = m88e1510_probe,
 		.config_init = m88e1510_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
-- 
2.31.1



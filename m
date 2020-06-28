Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6F620C69D
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 09:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgF1HFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 03:05:00 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:56669 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgF1HFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jun 2020 03:05:00 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 4C4FF440777;
        Sun, 28 Jun 2020 10:04:55 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Shmuel Hazan <sh@tkos.co.il>, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v2] net: phy: marvell10g: support XFI rate matching mode
Date:   Sun, 28 Jun 2020 10:04:51 +0300
Message-Id: <76ee08645fd35182911fd2bac2546e455c4b662c.1593327891.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the hardware MACTYPE hardware configuration pins are set to "XFI
with Rate Matching" the PHY interface operate at fixed 10Gbps speed. The
MAC buffer packets in both directions to match various wire speeds.

Read the MAC Type field in the Port Control register, and set the MAC
interface speed accordingly.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
v2: Move rate matching state read to config_init (RMK)
---
 drivers/net/phy/marvell10g.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index d4c2e62b2439..a7610eb55f30 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -80,6 +80,8 @@ enum {
 	MV_V2_PORT_CTRL		= 0xf001,
 	MV_V2_PORT_CTRL_SWRST	= BIT(15),
 	MV_V2_PORT_CTRL_PWRDOWN = BIT(11),
+	MV_V2_PORT_MAC_TYPE_MASK = 0x7,
+	MV_V2_PORT_MAC_TYPE_RATE_MATCH = 0x6,
 	/* Temperature control/read registers (88X3310 only) */
 	MV_V2_TEMP_CTRL		= 0xf08a,
 	MV_V2_TEMP_CTRL_MASK	= 0xc000,
@@ -91,6 +93,7 @@ enum {
 
 struct mv3310_priv {
 	u32 firmware_ver;
+	bool rate_match;
 
 	struct device *hwmon_dev;
 	char *hwmon_name;
@@ -458,7 +461,9 @@ static bool mv3310_has_pma_ngbaset_quirk(struct phy_device *phydev)
 
 static int mv3310_config_init(struct phy_device *phydev)
 {
+	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
 	int err;
+	int val;
 
 	/* Check that the PHY interface type is compatible */
 	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
@@ -475,6 +480,12 @@ static int mv3310_config_init(struct phy_device *phydev)
 	if (err)
 		return err;
 
+	val = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
+	if (val < 0)
+		return val;
+	priv->rate_match = ((val & MV_V2_PORT_MAC_TYPE_MASK) ==
+			MV_V2_PORT_MAC_TYPE_RATE_MATCH);
+
 	/* Enable EDPD mode - saving 600mW */
 	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
 }
@@ -581,6 +592,17 @@ static int mv3310_aneg_done(struct phy_device *phydev)
 
 static void mv3310_update_interface(struct phy_device *phydev)
 {
+	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
+
+	/* In "XFI with Rate Matching" mode the PHY interface is fixed at
+	 * 10Gb. The PHY adapts the rate to actual wire speed with help of
+	 * internal 16KB buffer.
+	 */
+	if (priv->rate_match) {
+		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
+		return;
+	}
+
 	if ((phydev->interface == PHY_INTERFACE_MODE_SGMII ||
 	     phydev->interface == PHY_INTERFACE_MODE_2500BASEX ||
 	     phydev->interface == PHY_INTERFACE_MODE_10GBASER) &&
-- 
2.27.0


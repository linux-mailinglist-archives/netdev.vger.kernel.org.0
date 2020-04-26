Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40ACE1B8CE5
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 08:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgDZGWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 02:22:15 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:51926 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgDZGWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 02:22:14 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id E106A440535;
        Sun, 26 Apr 2020 09:22:10 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: [PATCH net v4] net: phy: marvell10g: fix temperature sensor on 2110
Date:   Sun, 26 Apr 2020 09:22:06 +0300
Message-Id: <7f1ffa0c51d4f7be6867878e601037ae3326ac01.1587882126.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Read the temperature sensor register from the correct location for the
88E2110 PHY. There is no enable/disable bit on 2110, so make
mv3310_hwmon_config() run on 88X3310 only.

Fixes: 62d01535474b61 ("net: phy: marvell10g: add support for the 88x2110 PHY")
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
v4:
  * Combine two patches into one (RMK)

  * Add comments to mark PHY specific temperature registers (RMK)

  * Drop PHY check on mv3310_hwmon_probe() (RMK)

v3: Split temperature register read routine per variant (Andrew Lunn)

v2: Fix indentation (Andrew Lunn)
---
 drivers/net/phy/marvell10g.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 95e3f4644aeb..419301bfe8c6 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -66,6 +66,9 @@ enum {
 	MV_PCS_CSSR1_SPD2_2500	= 0x0004,
 	MV_PCS_CSSR1_SPD2_10000	= 0x0000,
 
+	/* Temperature read register (88E2110 only) */
+	MV_PCS_TEMP		= 0x8042,
+
 	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
 	 * registers appear to set themselves to the 0x800X when AN is
 	 * restarted, but status registers appear readable from either.
@@ -77,6 +80,7 @@ enum {
 	MV_V2_PORT_CTRL		= 0xf001,
 	MV_V2_PORT_CTRL_SWRST	= BIT(15),
 	MV_V2_PORT_CTRL_PWRDOWN = BIT(11),
+	/* Temperature control/read registers (88X3310 only) */
 	MV_V2_TEMP_CTRL		= 0xf08a,
 	MV_V2_TEMP_CTRL_MASK	= 0xc000,
 	MV_V2_TEMP_CTRL_SAMPLE	= 0x0000,
@@ -104,6 +108,24 @@ static umode_t mv3310_hwmon_is_visible(const void *data,
 	return 0;
 }
 
+static int mv3310_hwmon_read_temp_reg(struct phy_device *phydev)
+{
+	return phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP);
+}
+
+static int mv2110_hwmon_read_temp_reg(struct phy_device *phydev)
+{
+	return phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_TEMP);
+}
+
+static int mv10g_hwmon_read_temp_reg(struct phy_device *phydev)
+{
+	if (phydev->drv->phy_id == MARVELL_PHY_ID_88X3310)
+		return mv3310_hwmon_read_temp_reg(phydev);
+	else /* MARVELL_PHY_ID_88E2110 */
+		return mv2110_hwmon_read_temp_reg(phydev);
+}
+
 static int mv3310_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 			     u32 attr, int channel, long *value)
 {
@@ -116,7 +138,7 @@ static int mv3310_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 	}
 
 	if (type == hwmon_temp && attr == hwmon_temp_input) {
-		temp = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP);
+		temp = mv10g_hwmon_read_temp_reg(phydev);
 		if (temp < 0)
 			return temp;
 
@@ -169,6 +191,9 @@ static int mv3310_hwmon_config(struct phy_device *phydev, bool enable)
 	u16 val;
 	int ret;
 
+	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310)
+		return 0;
+
 	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP,
 			    MV_V2_TEMP_UNKNOWN);
 	if (ret < 0)
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D811AD5ED
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 08:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgDQGLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 02:11:02 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:51417 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgDQGLC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 02:11:02 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 6FC064400E1;
        Fri, 17 Apr 2020 09:10:58 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] net: phy: marvell10g: hwmon support for 2110
Date:   Fri, 17 Apr 2020 09:10:52 +0300
Message-Id: <18fe946c32093f50462e026090a9e32eb568c8c5.1587103852.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Read the temperature sensor register from the correct location for the
88E2110 PHY. There is no enable/disable bit, so leave
mv3310_hwmon_config() for 88X3310 only.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---

This applies on top of "net: phy: marvell10g: disable temperature sensor
on 2110".
---
 drivers/net/phy/marvell10g.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 7c4bc7347d0f..52d697563142 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -64,6 +64,8 @@ enum {
 	MV_PCS_CSSR1_SPD2_2500	= 0x0004,
 	MV_PCS_CSSR1_SPD2_10000	= 0x0000,
 
+	MV_PCS_TEMP		= 0x8042,
+
 	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
 	 * registers appear to set themselves to the 0x800X when AN is
 	 * restarted, but status registers appear readable from either.
@@ -99,6 +101,14 @@ static umode_t mv3310_hwmon_is_visible(const void *data,
 	return 0;
 }
 
+static int mv3310_hwmon_read_temp_reg(struct phy_device *phydev)
+{
+	if (phydev->drv->phy_id == MARVELL_PHY_ID_88X3310)
+		return phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP);
+	else /* MARVELL_PHY_ID_88E2110 */
+		return phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_TEMP);
+}
+
 static int mv3310_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 			     u32 attr, int channel, long *value)
 {
@@ -111,7 +121,7 @@ static int mv3310_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 	}
 
 	if (type == hwmon_temp && attr == hwmon_temp_input) {
-		temp = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP);
+		temp = mv3310_hwmon_read_temp_reg(phydev);
 		if (temp < 0)
 			return temp;
 
@@ -191,7 +201,8 @@ static int mv3310_hwmon_probe(struct phy_device *phydev)
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
 	int i, j, ret;
 
-	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310)
+	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310 &&
+			phydev->drv->phy_id != MARVELL_PHY_ID_88E2110)
 		return 0;
 
 	priv->hwmon_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
-- 
2.25.1


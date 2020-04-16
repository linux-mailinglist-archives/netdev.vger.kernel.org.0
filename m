Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855D11AC622
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 16:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394285AbgDPOeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 10:34:07 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:51351 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394388AbgDPOdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 10:33:13 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 79599440045;
        Thu, 16 Apr 2020 17:33:07 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: [PATCH] net: phy: marvell10g: disable temperature sensor on 2110
Date:   Thu, 16 Apr 2020 17:32:36 +0300
Message-Id: <1eca8c654679764a64252072509ddc1bf59938a0.1587047556.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 88E2110 temperature sensor is in a different location than 88X3310,
and it has no enable/disable option.

Fixes: 62d01535474b61 ("net: phy: marvell10g: add support for the 88x2110 PHY")
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/net/phy/marvell10g.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 7621badae64d..7c4bc7347d0f 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -164,6 +164,9 @@ static int mv3310_hwmon_config(struct phy_device *phydev, bool enable)
 	u16 val;
 	int ret;
 
+	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310)
+		return 0;
+
 	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP,
 			    MV_V2_TEMP_UNKNOWN);
 	if (ret < 0)
@@ -188,6 +191,9 @@ static int mv3310_hwmon_probe(struct phy_device *phydev)
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
 	int i, j, ret;
 
+	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310)
+		return 0;
+
 	priv->hwmon_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
 	if (!priv->hwmon_name)
 		return -ENODEV;
-- 
2.25.1


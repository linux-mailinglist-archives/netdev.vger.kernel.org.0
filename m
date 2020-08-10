Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB36B240815
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 17:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgHJPCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 11:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgHJPCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 11:02:07 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74E0C061756
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 08:02:06 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 799641409B6;
        Mon, 10 Aug 2020 17:01:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597071719; bh=UvyNCqV9Y2ibm+qLZUvbX4vk0xGb5Dx7XpWtFreRmWs=;
        h=From:To:Date;
        b=c+Qt0vrxC3cliSC3xZetlHxxcRfh8WisgqHk/331/PJ5nTP7nrwjAKcbc33GgMMD+
         2JeIqUaiXDFeu5MPQ0SctQ8aX3rXsXsN/x96hO8hopfvI0dLRSMny93/Ii98Hvas2w
         yDyGHfEEgcceiu2dIgD0qXzktv1JaMTx9M3coc9o=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Baruch Siach <baruch@tkos.co.il>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net] net: phy: marvell10g: fix null pointer dereference
Date:   Mon, 10 Aug 2020 17:01:58 +0200
Message-Id: <20200810150158.25081-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit c3e302edca24 ("net: phy: marvell10g: fix temperature sensor on 2110")
added a check for PHY ID via phydev->drv->phy_id in a function which is
called by devres at a time when phydev->drv is already set to null by
phy_remove function.

This null pointer dereference can be triggered via SFP subsystem with a
SFP module containing this Marvell PHY. When the SFP interface is put
down, the SFP subsystem removes the PHY.

Fixes: c3e302edca24 ("net: phy: marvell10g: fix temperature sensor on 2110")
Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell10g.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index a7610eb55f30f..1901ba277413d 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -208,13 +208,6 @@ static int mv3310_hwmon_config(struct phy_device *phydev, bool enable)
 			      MV_V2_TEMP_CTRL_MASK, val);
 }
 
-static void mv3310_hwmon_disable(void *data)
-{
-	struct phy_device *phydev = data;
-
-	mv3310_hwmon_config(phydev, false);
-}
-
 static int mv3310_hwmon_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -238,10 +231,6 @@ static int mv3310_hwmon_probe(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
-	ret = devm_add_action_or_reset(dev, mv3310_hwmon_disable, phydev);
-	if (ret)
-		return ret;
-
 	priv->hwmon_dev = devm_hwmon_device_register_with_info(dev,
 				priv->hwmon_name, phydev,
 				&mv3310_hwmon_chip_info, NULL);
@@ -426,6 +415,11 @@ static int mv3310_probe(struct phy_device *phydev)
 	return phy_sfp_probe(phydev, &mv3310_sfp_ops);
 }
 
+static void mv3310_remove(struct phy_device *phydev)
+{
+	mv3310_hwmon_config(phydev, false);
+}
+
 static int mv3310_suspend(struct phy_device *phydev)
 {
 	return mv3310_power_down(phydev);
@@ -784,6 +778,7 @@ static struct phy_driver mv3310_drivers[] = {
 		.read_status	= mv3310_read_status,
 		.get_tunable	= mv3310_get_tunable,
 		.set_tunable	= mv3310_set_tunable,
+		.remove		= mv3310_remove,
 	},
 	{
 		.phy_id		= MARVELL_PHY_ID_88E2110,
@@ -798,6 +793,7 @@ static struct phy_driver mv3310_drivers[] = {
 		.read_status	= mv3310_read_status,
 		.get_tunable	= mv3310_get_tunable,
 		.set_tunable	= mv3310_set_tunable,
+		.remove		= mv3310_remove,
 	},
 };
 
-- 
2.26.2


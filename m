Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982C9123335
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 18:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfLQRKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 12:10:04 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:40415 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLQRKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 12:10:04 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id BEDD81C0011;
        Tue, 17 Dec 2019 17:10:01 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        alexandre.belloni@bootlin.com, nicolas.ferre@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: [PATCH net 1/2] of: mdio: export of_mdiobus_child_is_phy
Date:   Tue, 17 Dec 2019 18:07:41 +0100
Message-Id: <20191217170742.1166139-2-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191217170742.1166139-1-antoine.tenart@bootlin.com>
References: <20191217170742.1166139-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch exports of_mdiobus_child_is_phy, allowing to check if a child
node is a network PHY.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/of/of_mdio.c    | 3 ++-
 include/linux/of_mdio.h | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index c6b87ce2b0cc..fc757ef6eadc 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -162,7 +162,7 @@ static const struct of_device_id whitelist_phys[] = {
  * A device which is not a phy is expected to have a compatible string
  * indicating what sort of device it is.
  */
-static bool of_mdiobus_child_is_phy(struct device_node *child)
+bool of_mdiobus_child_is_phy(struct device_node *child)
 {
 	u32 phy_id;
 
@@ -187,6 +187,7 @@ static bool of_mdiobus_child_is_phy(struct device_node *child)
 
 	return false;
 }
+EXPORT_SYMBOL(of_mdiobus_child_is_phy);
 
 /**
  * of_mdiobus_register - Register mii_bus and create PHYs from the device tree
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index 99cefe6f5edb..79bc82e30c02 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -12,6 +12,7 @@
 #include <linux/of.h>
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
+extern bool of_mdiobus_child_is_phy(struct device_node *child);
 extern int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np);
 extern struct phy_device *of_phy_find_device(struct device_node *phy_np);
 extern struct phy_device *of_phy_connect(struct net_device *dev,
@@ -54,6 +55,11 @@ static inline int of_mdio_parse_addr(struct device *dev,
 }
 
 #else /* CONFIG_OF_MDIO */
+static bool of_mdiobus_child_is_phy(struct device_node *child)
+{
+	return false;
+}
+
 static inline int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 {
 	/*
-- 
2.23.0


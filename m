Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E40123336
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 18:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfLQRKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 12:10:06 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:50243 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbfLQRKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 12:10:05 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 0709C1BF206;
        Tue, 17 Dec 2019 17:10:02 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        alexandre.belloni@bootlin.com, nicolas.ferre@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: [PATCH net 2/2] net: macb: fix probing of PHY not described in the dt
Date:   Tue, 17 Dec 2019 18:07:42 +0100
Message-Id: <20191217170742.1166139-3-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191217170742.1166139-1-antoine.tenart@bootlin.com>
References: <20191217170742.1166139-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the case where the PHY isn't described in the device
tree. This is due to the way the MDIO bus is registered in the driver:
whether the PHY is described in the device tree or not, the bus is
registered through of_mdiobus_register. The function masks all the PHYs
and only allow probing the ones described in the device tree. Prior to
the Phylink conversion this was also done but later on in the driver
the MDIO bus was manually scanned to circumvent the fact that the PHY
wasn't described.

This patch fixes it in a proper way, by registering the MDIO bus based
on if the PHY attached to a given interface is described in the device
tree or not.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 27 ++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 9c767ee252ac..c5ee363ca5dc 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -664,9 +664,30 @@ static int macb_mii_probe(struct net_device *dev)
 	return 0;
 }
 
+static int macb_mdiobus_register(struct macb *bp)
+{
+	struct device_node *child, *np = bp->pdev->dev.of_node;
+
+	/* Only create the PHY from the device tree if at least one PHY is
+	 * described. Otherwise scan the entire MDIO bus. We do this to support
+	 * old device tree that did not follow the best practices and did not
+	 * describe their network PHYs.
+	 */
+	for_each_available_child_of_node(np, child)
+		if (of_mdiobus_child_is_phy(child)) {
+			/* The loop increments the child refcount,
+			 * decrement it before returning.
+			 */
+			of_node_put(child);
+
+			return of_mdiobus_register(bp->mii_bus, np);
+		}
+
+	return mdiobus_register(bp->mii_bus);
+}
+
 static int macb_mii_init(struct macb *bp)
 {
-	struct device_node *np;
 	int err = -ENXIO;
 
 	/* Enable management port */
@@ -688,9 +709,7 @@ static int macb_mii_init(struct macb *bp)
 
 	dev_set_drvdata(&bp->dev->dev, bp->mii_bus);
 
-	np = bp->pdev->dev.of_node;
-
-	err = of_mdiobus_register(bp->mii_bus, np);
+	err = macb_mdiobus_register(bp);
 	if (err)
 		goto err_out_free_mdiobus;
 
-- 
2.23.0


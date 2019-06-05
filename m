Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74AB0365C9
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfFEUnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:43:16 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:32327 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfFEUnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 16:43:01 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x55KgqxV032218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 5 Jun 2019 14:42:57 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x55Kghj9021149
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 5 Jun 2019 14:42:52 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v4 17/20] net: axienet: Fix MDIO bus parent node detection
Date:   Wed,  5 Jun 2019 14:42:30 -0600
Message-Id: <1559767353-17301-18-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559767353-17301-1-git-send-email-hancock@sedsystems.ca>
References: <1559767353-17301-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was previously using the parent node of the specified PHY
node as the device node to register the MDIO bus on. Andrew Lunn
pointed out this is wrong as the PHY node is potentially not even
underneath the MDIO bus for the current device instance. Find the MDIO
node explicitly by looking it up by name under the controller's device
node instead.

This could potentially break existing device trees if they don't use
"mdio" as the name for the MDIO bus, but I did not find any with various
searches and Xilinx's examples all use mdio as the name so it seems like
this should be relatively safe.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 093b85d..5b899e5 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -228,7 +228,6 @@ int axienet_mdio_setup(struct axienet_local *lp)
 	if (!bus)
 		return -ENOMEM;
 
-	mdio_node = of_get_parent(lp->phy_node);
 	snprintf(bus->id, MII_BUS_ID_SIZE, "axienet-%.8llx",
 		 (unsigned long long)lp->regs_start);
 
@@ -239,7 +238,9 @@ int axienet_mdio_setup(struct axienet_local *lp)
 	bus->parent = lp->dev;
 	lp->mii_bus = bus;
 
+	mdio_node = of_get_child_by_name(lp->dev->of_node, "mdio");
 	ret = of_mdiobus_register(bus, mdio_node);
+	of_node_put(mdio_node);
 	if (ret) {
 		mdiobus_free(bus);
 		lp->mii_bus = NULL;
-- 
1.8.3.1


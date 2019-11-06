Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA4CBF1C18
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 18:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732211AbfKFRHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 12:07:05 -0500
Received: from inva021.nxp.com ([92.121.34.21]:57854 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbfKFRHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 12:07:04 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A9BD4200A13;
        Wed,  6 Nov 2019 18:07:02 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9A43B20096F;
        Wed,  6 Nov 2019 18:07:02 +0100 (CET)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 52F4B205EB;
        Wed,  6 Nov 2019 18:07:02 +0100 (CET)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, dan.carpenter@oracle.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH] dpaa2-eth: fix an always true condition in dpaa2_mac_get_if_mode
Date:   Wed,  6 Nov 2019 19:06:50 +0200
Message-Id: <1573060010-24260-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the phy_mode() function to return the if_mode through an
argument, similar to the new form of of_get_phy_mode().
This will help with handling errors in a common manner and also will fix
an always true condition.

Fixes: 0c65b2b90d13 ("net: of_get_phy_mode: Change API to solve int/unit warnings")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index b713739f4804..d322123ed373 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -7,14 +7,19 @@
 #define phylink_to_dpaa2_mac(config) \
 	container_of((config), struct dpaa2_mac, phylink_config)
 
-static phy_interface_t phy_mode(enum dpmac_eth_if eth_if)
+static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 {
+	*if_mode = PHY_INTERFACE_MODE_NA;
+
 	switch (eth_if) {
 	case DPMAC_ETH_IF_RGMII:
-		return PHY_INTERFACE_MODE_RGMII;
+		*if_mode = PHY_INTERFACE_MODE_RGMII;
+		break;
 	default:
 		return -EINVAL;
 	}
+
+	return 0;
 }
 
 /* Caller must call of_node_put on the returned value */
@@ -51,11 +56,11 @@ static int dpaa2_mac_get_if_mode(struct device_node *node,
 	if (!err)
 		return if_mode;
 
-	if_mode = phy_mode(attr.eth_if);
-	if (if_mode >= 0)
+	err = phy_mode(attr.eth_if, &if_mode);
+	if (!err)
 		return if_mode;
 
-	return -ENODEV;
+	return err;
 }
 
 static bool dpaa2_mac_phy_mode_mismatch(struct dpaa2_mac *mac,
-- 
1.9.1


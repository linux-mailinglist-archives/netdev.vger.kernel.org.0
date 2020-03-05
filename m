Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1228217A556
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgCEMea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:34:30 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36903 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgCEMea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:34:30 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1j9pht-0004EO-31; Thu, 05 Mar 2020 13:34:29 +0100
Received: from sha by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1j9phs-0001hq-LE; Thu, 05 Mar 2020 13:34:28 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v2] fsl/fman: Use random MAC address when none is given
Date:   Thu,  5 Mar 2020 13:34:14 +0100
Message-Id: <20200305123414.5010-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no need to fail probing when no MAC address is given in the
device tree, just use a random MAC address.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---

Changes since v1:
- Remove printing of permanent MAC address

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c   | 11 +++++++++--
 drivers/net/ethernet/freescale/fman/fman_memac.c |  4 ----
 drivers/net/ethernet/freescale/fman/mac.c        | 10 ++--------
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index fd93d542f497..fc117eab788d 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -233,8 +233,15 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	net_dev->features |= net_dev->hw_features;
 	net_dev->vlan_features = net_dev->features;
 
-	memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
-	memcpy(net_dev->dev_addr, mac_addr, net_dev->addr_len);
+	if (is_valid_ether_addr(mac_addr)) {
+		dev_info(dev, "FMan MAC address: %pM\n", mac_addr);
+		memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
+		memcpy(net_dev->dev_addr, mac_addr, net_dev->addr_len);
+	} else {
+		eth_hw_addr_random(net_dev);
+		dev_info(dev, "Using random MAC address: %pM\n",
+			 net_dev->dev_addr);
+	}
 
 	net_dev->ethtool_ops = &dpaa_ethtool_ops;
 
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index e1901874c19f..9e2372688405 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -596,10 +596,6 @@ static void setup_sgmii_internal_phy_base_x(struct fman_mac *memac)
 
 static int check_init_parameters(struct fman_mac *memac)
 {
-	if (memac->addr == 0) {
-		pr_err("Ethernet MAC must have a valid MAC address\n");
-		return -EINVAL;
-	}
 	if (!memac->exception_cb) {
 		pr_err("Uninitialized exception handler\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 55f2122c3217..9de76bc4ebde 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -724,12 +724,8 @@ static int mac_probe(struct platform_device *_of_dev)
 
 	/* Get the MAC address */
 	mac_addr = of_get_mac_address(mac_node);
-	if (IS_ERR(mac_addr)) {
-		dev_err(dev, "of_get_mac_address(%pOF) failed\n", mac_node);
-		err = -EINVAL;
-		goto _return_of_get_parent;
-	}
-	ether_addr_copy(mac_dev->addr, mac_addr);
+	if (!IS_ERR(mac_addr))
+		ether_addr_copy(mac_dev->addr, mac_addr);
 
 	/* Get the port handles */
 	nph = of_count_phandle_with_args(mac_node, "fsl,fman-ports", NULL);
@@ -855,8 +851,6 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err < 0)
 		dev_err(dev, "fman_set_mac_active_pause() = %d\n", err);
 
-	dev_info(dev, "FMan MAC address: %pM\n", mac_dev->addr);
-
 	priv->eth_dev = dpaa_eth_add_device(fman_id, mac_dev);
 	if (IS_ERR(priv->eth_dev)) {
 		dev_err(dev, "failed to add Ethernet platform device for MAC %d\n",
-- 
2.25.1


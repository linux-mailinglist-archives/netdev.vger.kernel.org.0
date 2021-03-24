Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE77234793D
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 14:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbhCXNGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 09:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbhCXNFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 09:05:51 -0400
Received: from mail.bugwerft.de (mail.bugwerft.de [IPv6:2a03:6000:1011::59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92395C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:05:51 -0700 (PDT)
Received: from hq-00021.holoplot.net (p57bc9f24.dip0.t-ipconnect.de [87.188.159.36])
        by mail.bugwerft.de (Postfix) with ESMTPSA id 07CF74C40BB;
        Wed, 24 Mar 2021 13:05:50 +0000 (UTC)
From:   Daniel Mack <daniel@zonque.org>
To:     radhey.shyam.pandey@xilinx.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH v2] net: axienet: allow setups without MDIO
Date:   Wed, 24 Mar 2021 14:05:36 +0100
Message-Id: <20210324130536.1663062-1-daniel@zonque.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In setups with fixed-link settings there is no mdio node in DTS.
axienet_probe() already handles that gracefully but lp->mii_bus is
then NULL.

Fix code that tries to blindly grab the MDIO lock by introducing two helper
functions that make the locking conditional.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
v2:
  * Also fix axienet_dma_err_handler, as pointed out by Andrew Lunn

 drivers/net/ethernet/xilinx/xilinx_axienet.h      | 12 ++++++++++++
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 12 ++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 1e966a39967e5..aca7f82f6791b 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -504,6 +504,18 @@ static inline u32 axinet_ior_read_mcr(struct axienet_local *lp)
 	return axienet_ior(lp, XAE_MDIO_MCR_OFFSET);
 }
 
+static inline void axienet_lock_mii(struct axienet_local *lp)
+{
+	if (lp->mii_bus)
+		mutex_lock(&lp->mii_bus->mdio_lock);
+}
+
+static inline void axienet_unlock_mii(struct axienet_local *lp)
+{
+	if (lp->mii_bus)
+		mutex_unlock(&lp->mii_bus->mdio_lock);
+}
+
 /**
  * axienet_iow - Memory mapped Axi Ethernet register write
  * @lp:         Pointer to axienet local structure
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3a8775e0ca552..61380c6b65b86 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1053,9 +1053,9 @@ static int axienet_open(struct net_device *ndev)
 	 * including the MDIO. MDIO must be disabled before resetting.
 	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
 	 */
-	mutex_lock(&lp->mii_bus->mdio_lock);
+	axienet_lock_mii(lp);
 	ret = axienet_device_reset(ndev);
-	mutex_unlock(&lp->mii_bus->mdio_lock);
+	axienet_unlock_mii(lp);
 
 	ret = phylink_of_phy_connect(lp->phylink, lp->dev->of_node, 0);
 	if (ret) {
@@ -1148,9 +1148,9 @@ static int axienet_stop(struct net_device *ndev)
 	}
 
 	/* Do a reset to ensure DMA is really stopped */
-	mutex_lock(&lp->mii_bus->mdio_lock);
+	axienet_lock_mii(lp);
 	__axienet_device_reset(lp);
-	mutex_unlock(&lp->mii_bus->mdio_lock);
+	axienet_unlock_mii(lp);
 
 	cancel_work_sync(&lp->dma_err_task);
 
@@ -1709,9 +1709,9 @@ static void axienet_dma_err_handler(struct work_struct *work)
 	 * including the MDIO. MDIO must be disabled before resetting.
 	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
 	 */
-	mutex_lock(&lp->mii_bus->mdio_lock);
+	axienet_lock_mii(lp);
 	__axienet_device_reset(lp);
-	mutex_unlock(&lp->mii_bus->mdio_lock);
+	axienet_unlock_mii(lp);
 
 	for (i = 0; i < lp->tx_bd_num; i++) {
 		cur_p = &lp->tx_bd_v[i];
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4839735CB26
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243443AbhDLQXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243381AbhDLQXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE7A861369;
        Mon, 12 Apr 2021 16:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244595;
        bh=jEukYEUhaFyVfZevnjU1DgH7B2qU4S3Hom0+Adu5m4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F75bdx7vTn030UDtk28IeI213k0Wi1VUfrVMBtOcvBvDEco4ZMlO4dlUqIMBrrgfC
         plHSjkTPK2kJa7PClNxjsLCeB7TmCHQ/AlpN0PjjCLHjv2d/xUGbMQtWBV8Ic55MWK
         i2aXyiq6s0IG8jM3xCiv8VTDg8s166cfZHgWh6z1RuD/d1eGY9YvSzZhlWcMhp4D4o
         x3lfZfdIBNpZoEi/S17sLoAejDcyjRY+ejNsrX5AuJ8KpMm6oAJYHNiEUj2ImXX3OB
         OfR8bW/rEBZRgFqkwMUnmkbWu/Yn0mRirdDtMGvcPUZtqKy8siTVlCuB0pgMCfG+aT
         SO9bJ7gFUnpiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Mack <daniel@zonque.org>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 15/51] net: axienet: allow setups without MDIO
Date:   Mon, 12 Apr 2021 12:22:20 -0400
Message-Id: <20210412162256.313524-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>

[ Upstream commit de9c7854e6e1589f639c6352112956d08243b659 ]

In setups with fixed-link settings there is no mdio node in DTS.
axienet_probe() already handles that gracefully but lp->mii_bus is
then NULL.

Fix code that tries to blindly grab the MDIO lock by introducing two helper
functions that make the locking conditional.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      | 12 ++++++++++++
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 12 ++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index a03c3ca1b28d..9e2cddba3b5b 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -497,6 +497,18 @@ static inline u32 axinet_ior_read_mcr(struct axienet_local *lp)
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
index 4cd701a9277d..82176dd2cdf3 100644
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
 
@@ -1664,9 +1664,9 @@ static void axienet_dma_err_handler(struct work_struct *work)
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


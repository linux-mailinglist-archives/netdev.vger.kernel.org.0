Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06E832C457
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392291AbhCDANL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:13:11 -0500
Received: from mga14.intel.com ([192.55.52.115]:39547 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242284AbhCCPab (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 10:30:31 -0500
IronPort-SDR: qL0mWu6cVl2clkEHQXOIdVZlOpGRKRH/3MJDwnzWsvjh13/HvroTzdI8lo16iHDPKeHlMT5qTv
 cBe44NUo9QjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="186564129"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="186564129"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 07:28:06 -0800
IronPort-SDR: CJX19H7i3B/YiVnKRlNNnRZnI/Pu/SC0fShZcyn3s88efDYCEcpeOE5JWDx4mXP0PAfobADWbp
 Ro+s5L28mRPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="399758579"
Received: from climb.png.intel.com ([10.221.118.165])
  by fmsmga008.fm.intel.com with ESMTP; 03 Mar 2021 07:28:04 -0800
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH v1 net-next 2/5] net: stmmac: make stmmac_interrupt() function more friendly to MSI
Date:   Wed,  3 Mar 2021 23:27:54 +0800
Message-Id: <20210303152757.18959-3-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210303152757.18959-1-weifeng.voon@intel.com>
References: <20210303152757.18959-1-weifeng.voon@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

Refactor stmmac_interrupt() by introducing stmmac_common_interrupt()
so that we prepare the ISR operation to be friendly to MSI later.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 59 +++++++++++--------
 1 file changed, 36 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 70c2eb7fc3eb..eb1fcf20aacd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4106,21 +4106,8 @@ static int stmmac_set_features(struct net_device *netdev,
 	return 0;
 }
 
-/**
- *  stmmac_interrupt - main ISR
- *  @irq: interrupt number.
- *  @dev_id: to pass the net device pointer (must be valid).
- *  Description: this is the main driver interrupt service routine.
- *  It can call:
- *  o DMA service routine (to manage incoming frame reception and transmission
- *    status)
- *  o Core interrupts to manage: remote wake-up, management counter, LPI
- *    interrupts.
- */
-static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
+static void stmmac_common_interrupt(struct stmmac_priv *priv)
 {
-	struct net_device *dev = (struct net_device *)dev_id;
-	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
 	u32 tx_cnt = priv->plat->tx_queues_to_use;
 	u32 queues_count;
@@ -4133,13 +4120,6 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 	if (priv->irq_wake)
 		pm_wakeup_event(priv->device, 0);
 
-	/* Check if adapter is up */
-	if (test_bit(STMMAC_DOWN, &priv->state))
-		return IRQ_HANDLED;
-	/* Check if a fatal error happened */
-	if (stmmac_safety_feat_interrupt(priv))
-		return IRQ_HANDLED;
-
 	/* To handle GMAC own interrupts */
 	if ((priv->plat->has_gmac) || xmac) {
 		int status = stmmac_host_irq_status(priv, priv->hw, &priv->xstats);
@@ -4170,11 +4150,44 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 		/* PCS link status */
 		if (priv->hw->pcs) {
 			if (priv->xstats.pcs_link)
-				netif_carrier_on(dev);
+				netif_carrier_on(priv->dev);
 			else
-				netif_carrier_off(dev);
+				netif_carrier_off(priv->dev);
 		}
 	}
+}
+
+/**
+ *  stmmac_interrupt - main ISR
+ *  @irq: interrupt number.
+ *  @dev_id: to pass the net device pointer.
+ *  Description: this is the main driver interrupt service routine.
+ *  It can call:
+ *  o DMA service routine (to manage incoming frame reception and transmission
+ *    status)
+ *  o Core interrupts to manage: remote wake-up, management counter, LPI
+ *    interrupts.
+ */
+static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
+{
+	struct net_device *dev = (struct net_device *)dev_id;
+	struct stmmac_priv *priv = netdev_priv(dev);
+
+	if (unlikely(!dev)) {
+		netdev_err(priv->dev, "%s: invalid dev pointer\n", __func__);
+		return IRQ_NONE;
+	}
+
+	/* Check if adapter is up */
+	if (test_bit(STMMAC_DOWN, &priv->state))
+		return IRQ_HANDLED;
+
+	/* Check if a fatal error happened */
+	if (stmmac_safety_feat_interrupt(priv))
+		return IRQ_HANDLED;
+
+	/* To handle Common interrupts */
+	stmmac_common_interrupt(priv);
 
 	/* To handle DMA interrupts */
 	stmmac_dma_interrupt(priv);
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C37C349868
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhCYRjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:39:48 -0400
Received: from mga03.intel.com ([134.134.136.65]:27389 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229995AbhCYRj2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 13:39:28 -0400
IronPort-SDR: zf0eU1hiZPsfTDSvJaI0+bm9+LoYjeDd7V6tmyWAIbiPjYCzDr7ypIrXg2ycC5uLrFV/znM91E
 Q/SjN7XF8L8w==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="191016792"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="191016792"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 10:39:27 -0700
IronPort-SDR: tH3hR0c0An/vBFVND+UGv8IE5bGJ6nZ/uNkYF5gVJM7OALgI5CTVVZIkDW+7gG/0wwXgvqGj3d
 n+nVIG3tl51w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="416112281"
Received: from climb.png.intel.com ([10.221.118.165])
  by orsmga008.jf.intel.com with ESMTP; 25 Mar 2021 10:39:24 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH v2 net-next 2/5] net: stmmac: make stmmac_interrupt() function more friendly to MSI
Date:   Fri, 26 Mar 2021 01:39:13 +0800
Message-Id: <20210325173916.13203-3-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210325173916.13203-1-weifeng.voon@intel.com>
References: <20210325173916.13203-1-weifeng.voon@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

Refactor stmmac_interrupt() by introducing stmmac_common_interrupt()
so that we prepare the ISR operation to be friendly to MSI later.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
Changes:
v1 -> v2
 -Remove defensive check for invalid dev pointer
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 54 +++++++++++--------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7c352d017eb2..abe990b9b07b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4382,21 +4382,8 @@ static void stmmac_fpe_event_status(struct stmmac_priv *priv, int status)
 	}
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
@@ -4409,13 +4396,6 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 	if (priv->irq_wake)
 		pm_wakeup_event(priv->device, 0);
 
-	/* Check if adapter is up */
-	if (test_bit(STMMAC_DOWN, &priv->state))
-		return IRQ_HANDLED;
-	/* Check if a fatal error happened */
-	if (stmmac_safety_feat_interrupt(priv))
-		return IRQ_HANDLED;
-
 	if (priv->dma_cap.estsel)
 		stmmac_est_irq_status(priv, priv->ioaddr, priv->dev,
 				      &priv->xstats, tx_cnt);
@@ -4457,11 +4437,39 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20654C2B11
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiBXLjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbiBXLjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:39:11 -0500
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD151A58EA;
        Thu, 24 Feb 2022 03:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1645702721;
  x=1677238721;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JrRPEFKeXWcc6jAXtUVnif+wj03hnZPozhAYD5BNe3k=;
  b=YohyELoDu7SBrBBUmLGrTpRy5yutwrYpT2WQZJ60NTszOPcZxWVp2bCQ
   Z9DxuP9U23fXk2ZsDp00nLHz9VAXEfX05T6FpTWDBCPhhCXDlTyNGjvBm
   5Pwg9l7asUlVynsno3aRM9g/d8g+S2ETY0nejJlfN28274mquFKom2+yY
   J9RNC5+RTv8p8F/LkegdCBh0Y4MYjDiIVbDudHhpdHZxSPw+OfeLSXTv9
   RUiZdpYMM0sD/9dWa6IYaSY7HHVwyjOCKX01CV/RQAgcqwfoNVTKAYHaY
   8aPF0s9LVfx9cD7fVKLKPZWFxit6xHQ7KN+94rTreUnul7hYJZ1aPdi3A
   A==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     <kernel@axis.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Lars Persson <larper@axis.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] net: stmmac: only enable DMA interrupts when ready
Date:   Thu, 24 Feb 2022 12:38:29 +0100
Message-ID: <20220224113829.1092859-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this driver's ->ndo_open() callback, it enables DMA interrupts,
starts the DMA channels, then requests interrupts with request_irq(),
and then finally enables napi.

If RX DMA interrupts are received before napi is enabled, no processing
is done because napi_schedule_prep() will return false.  If the network
has a lot of broadcast/multicast traffic, then the RX ring could fill up
completely before napi is enabled.  When this happens, no further RX
interrupts will be delivered, and the driver will fail to receive any
packets.

Fix this by only enabling DMA interrupts after all other initialization
is complete.

Fixes: 523f11b5d4fd72efb ("net: stmmac: move hardware setup for stmmac_open to new function")
Reported-by: Lars Persson <larper@axis.com>
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 28 +++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6708ca2aa4f7..43978558d6c0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2260,6 +2260,23 @@ static void stmmac_stop_tx_dma(struct stmmac_priv *priv, u32 chan)
 	stmmac_stop_tx(priv, priv->ioaddr, chan);
 }
 
+static void stmmac_enable_all_dma_irq(struct stmmac_priv *priv)
+{
+	u32 rx_channels_count = priv->plat->rx_queues_to_use;
+	u32 tx_channels_count = priv->plat->tx_queues_to_use;
+	u32 dma_csr_ch = max(rx_channels_count, tx_channels_count);
+	u32 chan;
+
+	for (chan = 0; chan < dma_csr_ch; chan++) {
+		struct stmmac_channel *ch = &priv->channel[chan];
+		unsigned long flags;
+
+		spin_lock_irqsave(&ch->lock, flags);
+		stmmac_enable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
+		spin_unlock_irqrestore(&ch->lock, flags);
+	}
+}
+
 /**
  * stmmac_start_all_dma - start all RX and TX DMA channels
  * @priv: driver private structure
@@ -2902,8 +2919,10 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 		stmmac_axi(priv, priv->ioaddr, priv->plat->axi);
 
 	/* DMA CSR Channel configuration */
-	for (chan = 0; chan < dma_csr_ch; chan++)
+	for (chan = 0; chan < dma_csr_ch; chan++) {
 		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
+		stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
+	}
 
 	/* DMA RX Channel Configuration */
 	for (chan = 0; chan < rx_channels_count; chan++) {
@@ -3759,6 +3778,7 @@ static int stmmac_open(struct net_device *dev)
 
 	stmmac_enable_all_queues(priv);
 	netif_tx_start_all_queues(priv->dev);
+	stmmac_enable_all_dma_irq(priv);
 
 	return 0;
 
@@ -6508,8 +6528,10 @@ int stmmac_xdp_open(struct net_device *dev)
 	}
 
 	/* DMA CSR Channel configuration */
-	for (chan = 0; chan < dma_csr_ch; chan++)
+	for (chan = 0; chan < dma_csr_ch; chan++) {
 		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
+		stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
+	}
 
 	/* Adjust Split header */
 	sph_en = (priv->hw->rx_csum > 0) && priv->sph;
@@ -6570,6 +6592,7 @@ int stmmac_xdp_open(struct net_device *dev)
 	stmmac_enable_all_queues(priv);
 	netif_carrier_on(dev);
 	netif_tx_start_all_queues(dev);
+	stmmac_enable_all_dma_irq(priv);
 
 	return 0;
 
@@ -7447,6 +7470,7 @@ int stmmac_resume(struct device *dev)
 	stmmac_restore_hw_vlan_rx_fltr(priv, ndev, priv->hw);
 
 	stmmac_enable_all_queues(priv);
+	stmmac_enable_all_dma_irq(priv);
 
 	mutex_unlock(&priv->lock);
 	rtnl_unlock();
-- 
2.34.1


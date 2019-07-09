Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6426328E
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 10:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfGIIDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 04:03:17 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:48322 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725905AbfGIIDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 04:03:16 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 81EDDC0208;
        Tue,  9 Jul 2019 08:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1562659395; bh=USMhb3PmD7Fnb1zWk1acddlt1/elsAz9LHTPWf6voaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=OBOh7LIz6ulSeSpOFRssKRrwIcrdAqYZpkkszL39W2pVCxRjv8XAk7W+NtPbQwaKy
         C7zk3xm4jKDgHKICrX16Suwlu0Mb5yiPKhud6dRfndAxF6XHEAsWErmSD5ONkE67lX
         OvgtfSEZu9OJGB5sOj8dOO8cQ/k92wXgKdOcRO3XMpEQaXlQFCWSj1LjiY3QJp6Ned
         rRZdLUIpVwdqn8H5GdiV/JY/A2DP+PW516uJdeh+CdwpicW/qkcQkyjN6wSFYdHNgM
         OecLi6EbIVTb1Qn4/bfe1sSvGqBd+L4vFoVh4hD0spq9efKO/mXflIsyi5lWROTwM9
         GkHnnaE02fXhA==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id BE7EEA0065;
        Tue,  9 Jul 2019 08:03:13 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 589083F82F;
        Tue,  9 Jul 2019 10:03:13 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next v4 1/3] net: stmmac: Implement RX Coalesce Frames setting
Date:   Tue,  9 Jul 2019 10:02:58 +0200
Message-Id: <106c23ead8aee293f76cb98291195a0949e2f989.1562659012.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1562659012.git.joabreu@synopsys.com>
References: <cover.1562659012.git.joabreu@synopsys.com>
In-Reply-To: <cover.1562659012.git.joabreu@synopsys.com>
References: <cover.1562659012.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for coalescing RX path by specifying number of frames which
don't need to have interrupt on completion bit set.

This is only available when RX Watchdog is enabled.

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h         |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h         |  2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c |  7 +++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    | 18 ++++++++++++------
 4 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 2403a65167b2..dfd47fdfa447 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -252,6 +252,7 @@ struct stmmac_safety_stats {
 #define STMMAC_MAX_COAL_TX_TICK	100000
 #define STMMAC_TX_MAX_FRAMES	256
 #define STMMAC_TX_FRAMES	1
+#define STMMAC_RX_FRAMES	25
 
 /* Packets types */
 enum packets_types {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 123898235cb0..513f4e2df5f6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -55,6 +55,7 @@ struct stmmac_tx_queue {
 };
 
 struct stmmac_rx_queue {
+	u32 rx_count_frames;
 	u32 queue_index;
 	struct stmmac_priv *priv_data;
 	struct dma_extended_desc *dma_erx;
@@ -110,6 +111,7 @@ struct stmmac_priv {
 	/* Frequently used values are kept adjacent for cache effect */
 	u32 tx_coal_frames;
 	u32 tx_coal_timer;
+	u32 rx_coal_frames;
 
 	int tx_coalesce;
 	int hwts_tx_en;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index cfd93eefb50e..6efb66820d4c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -701,8 +701,10 @@ static int stmmac_get_coalesce(struct net_device *dev,
 	ec->tx_coalesce_usecs = priv->tx_coal_timer;
 	ec->tx_max_coalesced_frames = priv->tx_coal_frames;
 
-	if (priv->use_riwt)
+	if (priv->use_riwt) {
+		ec->rx_max_coalesced_frames = priv->rx_coal_frames;
 		ec->rx_coalesce_usecs = stmmac_riwt2usec(priv->rx_riwt, priv);
+	}
 
 	return 0;
 }
@@ -715,7 +717,7 @@ static int stmmac_set_coalesce(struct net_device *dev,
 	unsigned int rx_riwt;
 
 	/* Check not supported parameters  */
-	if ((ec->rx_max_coalesced_frames) || (ec->rx_coalesce_usecs_irq) ||
+	if ((ec->rx_coalesce_usecs_irq) ||
 	    (ec->rx_max_coalesced_frames_irq) || (ec->tx_coalesce_usecs_irq) ||
 	    (ec->use_adaptive_rx_coalesce) || (ec->use_adaptive_tx_coalesce) ||
 	    (ec->pkt_rate_low) || (ec->rx_coalesce_usecs_low) ||
@@ -749,6 +751,7 @@ static int stmmac_set_coalesce(struct net_device *dev,
 	/* Only copy relevant parameters, ignore all others. */
 	priv->tx_coal_frames = ec->tx_max_coalesced_frames;
 	priv->tx_coal_timer = ec->tx_coalesce_usecs;
+	priv->rx_coal_frames = ec->rx_max_coalesced_frames;
 	priv->rx_riwt = rx_riwt;
 	stmmac_rx_watchdog(priv, priv->ioaddr, priv->rx_riwt, rx_cnt);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index bdedde99148a..c142e9367a68 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2268,20 +2268,21 @@ static void stmmac_tx_timer(struct timer_list *t)
 }
 
 /**
- * stmmac_init_tx_coalesce - init tx mitigation options.
+ * stmmac_init_coalesce - init mitigation options.
  * @priv: driver private structure
  * Description:
- * This inits the transmit coalesce parameters: i.e. timer rate,
+ * This inits the coalesce parameters: i.e. timer rate,
  * timer handler and default threshold used for enabling the
  * interrupt on completion bit.
  */
-static void stmmac_init_tx_coalesce(struct stmmac_priv *priv)
+static void stmmac_init_coalesce(struct stmmac_priv *priv)
 {
 	u32 tx_channel_count = priv->plat->tx_queues_to_use;
 	u32 chan;
 
 	priv->tx_coal_frames = STMMAC_TX_FRAMES;
 	priv->tx_coal_timer = STMMAC_COAL_TX_TIMER;
+	priv->rx_coal_frames = STMMAC_RX_FRAMES;
 
 	for (chan = 0; chan < tx_channel_count; chan++) {
 		struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
@@ -2651,7 +2652,7 @@ static int stmmac_open(struct net_device *dev)
 		goto init_error;
 	}
 
-	stmmac_init_tx_coalesce(priv);
+	stmmac_init_coalesce(priv);
 
 	phylink_start(priv->phylink);
 
@@ -3289,6 +3290,7 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 
 	while (dirty-- > 0) {
 		struct dma_desc *p;
+		bool use_rx_wd;
 
 		if (priv->extend_desc)
 			p = (struct dma_desc *)(rx_q->dma_erx + entry);
@@ -3331,7 +3333,11 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 		}
 		dma_wmb();
 
-		stmmac_set_rx_owner(priv, p, priv->use_riwt);
+		rx_q->rx_count_frames++;
+		rx_q->rx_count_frames %= priv->rx_coal_frames;
+		use_rx_wd = priv->use_riwt && rx_q->rx_count_frames;
+
+		stmmac_set_rx_owner(priv, p, use_rx_wd);
 
 		dma_wmb();
 
@@ -4631,7 +4637,7 @@ int stmmac_resume(struct device *dev)
 	stmmac_clear_descriptors(priv);
 
 	stmmac_hw_setup(ndev, false);
-	stmmac_init_tx_coalesce(priv);
+	stmmac_init_coalesce(priv);
 	stmmac_set_rx_mode(ndev);
 
 	stmmac_enable_all_queues(priv);
-- 
2.7.4


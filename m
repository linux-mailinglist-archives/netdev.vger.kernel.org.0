Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70AFA16225A
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 09:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgBRI1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 03:27:45 -0500
Received: from first.geanix.com ([116.203.34.67]:59662 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgBRI1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 03:27:44 -0500
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id C9794C003F;
        Tue, 18 Feb 2020 08:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582014413; bh=FjjXvDzFnkljG7dLY4SaZbmbX0tHBNHM2LB3sA1jlV4=;
        h=From:To:Cc:Subject:Date;
        b=kX65JjUAmN4R6IuXkZUWoQi7FEjZuRS1rGNFUc3lqptn2DHfQMGY/8hotnkWwa+/E
         5Mw0uOZOigwn9VTT94gmTos9A5q1RcV3rXneB2FIo6A9Mb60tg3Ib/G/JZ+gl33uOx
         vWHgEcU/KTqB/QjaTQZAyTEVlEWUN6vjcAktpDdaSiuNfCcie5vhZRatb2adFKtEUU
         XZ3VKe7QB9Q7wnPdzAjT9guayEFrxBirCO94TAYFR292uh5s5q0STcP6xyrlhsUrKA
         zLjusdtFg3t+fN3i1mgRyTYdod2fhUz9NI1fjYPwwM0iLaOAgc5yEhCn1f3uOyEH3H
         YaijeYKb4Yw9w==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH 8/8] net: ll_temac: Add ethtool support for coalesce parameters
Date:   Tue, 18 Feb 2020 09:27:41 +0100
Message-Id: <20200218082741.7710-1-esben@geanix.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=4.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=disabled
        version=3.4.3
X-Spam-Checker-Version: SpamAssassin 3.4.3 (2019-12-06) on eb9da72b0f73
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please note that the delays are calculated based on typical
parameters.  But as TEMAC is an HDL IP, designs may vary, and future
work might be needed to make this calculation configurable.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac.h      |   5 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c | 102 ++++++++++++++++----
 2 files changed, 85 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index 8777ec6e21c8..4a73127e10a6 100644
--- a/drivers/net/ethernet/xilinx/ll_temac.h
+++ b/drivers/net/ethernet/xilinx/ll_temac.h
@@ -379,9 +379,10 @@ struct temac_local {
 	int rx_bd_tail;
 
 	/* DMA channel control setup */
-	u32 tx_chnl_ctrl;
-	u32 rx_chnl_ctrl;
+	u8 coalesce_count_tx;
+	u8 coalesce_delay_tx;
 	u8 coalesce_count_rx;
+	u8 coalesce_delay_rx;
 
 	struct delayed_work restart_work;
 };
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index e3d4857334f3..3168dd77ecbc 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -379,11 +379,13 @@ static int temac_dma_bd_init(struct net_device *ndev)
 	}
 
 	/* Configure DMA channel (irq setup) */
-	lp->dma_out(lp, TX_CHNL_CTRL, lp->tx_chnl_ctrl |
+	lp->dma_out(lp, TX_CHNL_CTRL,
+		    lp->coalesce_delay_tx << 24 | lp->coalesce_count_tx << 16 |
 		    0x00000400 | // Use 1 Bit Wide Counters. Currently Not Used!
 		    CHNL_CTRL_IRQ_EN | CHNL_CTRL_IRQ_ERR_EN |
 		    CHNL_CTRL_IRQ_DLY_EN | CHNL_CTRL_IRQ_COAL_EN);
-	lp->dma_out(lp, RX_CHNL_CTRL, lp->rx_chnl_ctrl |
+	lp->dma_out(lp, RX_CHNL_CTRL,
+		    lp->coalesce_delay_rx << 24 | lp->coalesce_count_rx << 16 |
 		    CHNL_CTRL_IRQ_IOE |
 		    CHNL_CTRL_IRQ_EN | CHNL_CTRL_IRQ_ERR_EN |
 		    CHNL_CTRL_IRQ_DLY_EN | CHNL_CTRL_IRQ_COAL_EN);
@@ -1284,6 +1286,69 @@ static int ll_temac_ethtools_set_ringparam(struct net_device *ndev,
 	return 0;
 }
 
+static int ll_temac_ethtools_get_coalesce(struct net_device *ndev,
+					  struct ethtool_coalesce *ec)
+{
+	struct temac_local *lp = netdev_priv(ndev);
+
+	ec->rx_max_coalesced_frames = lp->coalesce_count_rx;
+	ec->tx_max_coalesced_frames = lp->coalesce_count_tx;
+	ec->rx_coalesce_usecs = (lp->coalesce_delay_rx * 512) / 100;
+	ec->tx_coalesce_usecs = (lp->coalesce_delay_tx * 512) / 100;
+	return 0;
+}
+
+static int ll_temac_ethtools_set_coalesce(struct net_device *ndev,
+					  struct ethtool_coalesce *ec)
+{
+	struct temac_local *lp = netdev_priv(ndev);
+
+	if (netif_running(ndev)) {
+		netdev_err(ndev,
+			   "Please stop netif before applying configuration\n");
+		return -EFAULT;
+	}
+
+	if (ec->rx_coalesce_usecs_irq ||
+	    ec->rx_max_coalesced_frames_irq ||
+	    ec->tx_coalesce_usecs_irq ||
+	    ec->tx_max_coalesced_frames_irq ||
+	    ec->stats_block_coalesce_usecs ||
+	    ec->use_adaptive_rx_coalesce ||
+	    ec->use_adaptive_tx_coalesce ||
+	    ec->pkt_rate_low ||
+	    ec->rx_coalesce_usecs_low ||
+	    ec->rx_max_coalesced_frames_low ||
+	    ec->tx_coalesce_usecs_low ||
+	    ec->tx_max_coalesced_frames_low ||
+	    ec->pkt_rate_high ||
+	    ec->rx_coalesce_usecs_high ||
+	    ec->rx_max_coalesced_frames_high ||
+	    ec->tx_coalesce_usecs_high ||
+	    ec->tx_max_coalesced_frames_high ||
+	    ec->rate_sample_interval)
+		return -EOPNOTSUPP;
+	if (ec->rx_max_coalesced_frames)
+		lp->coalesce_count_rx = ec->rx_max_coalesced_frames;
+	if (ec->tx_max_coalesced_frames)
+		lp->coalesce_count_tx = ec->tx_max_coalesced_frames;
+	/* With typical LocalLink clock speed of 200 MHz and
+	 * C_PRESCALAR=1023, each delay count corresponds to 5.12 us.
+	 */
+	if (ec->rx_coalesce_usecs)
+		lp->coalesce_delay_rx =
+			min(255U, (ec->rx_coalesce_usecs * 100) / 512);
+	if (ec->tx_coalesce_usecs)
+		lp->coalesce_delay_tx =
+			min(255U, (ec->tx_coalesce_usecs * 100) / 512);
+
+	pr_info("%d -> %d  %d -> %d\n",
+		ec->rx_coalesce_usecs, lp->coalesce_delay_rx,
+		ec->tx_coalesce_usecs, lp->coalesce_delay_tx);
+
+	return 0;
+}
+
 static const struct ethtool_ops temac_ethtool_ops = {
 	.nway_reset = phy_ethtool_nway_reset,
 	.get_link = ethtool_op_get_link,
@@ -1292,6 +1357,8 @@ static const struct ethtool_ops temac_ethtool_ops = {
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
 	.get_ringparam	= ll_temac_ethtools_get_ringparam,
 	.set_ringparam	= ll_temac_ethtools_set_ringparam,
+	.get_coalesce	= ll_temac_ethtools_get_coalesce,
+	.set_coalesce	= ll_temac_ethtools_set_coalesce,
 };
 
 static int temac_probe(struct platform_device *pdev)
@@ -1401,6 +1468,14 @@ static int temac_probe(struct platform_device *pdev)
 		/* Can checksum TCP/UDP over IPv4. */
 		ndev->features |= NETIF_F_IP_CSUM;
 
+	/* Defaults for IRQ delay/coalescing setup.  These are
+	 * configuration values, so does not belong in device-tree.
+	 */
+	lp->coalesce_delay_tx = 0x10;
+	lp->coalesce_count_tx = 0x22;
+	lp->coalesce_delay_rx = 0xff;
+	lp->coalesce_count_rx = 0x07;
+
 	/* Setup LocalLink DMA */
 	if (temac_np) {
 		/* Find the DMA node, map the DMA registers, and
@@ -1439,14 +1514,6 @@ static int temac_probe(struct platform_device *pdev)
 		lp->rx_irq = irq_of_parse_and_map(dma_np, 0);
 		lp->tx_irq = irq_of_parse_and_map(dma_np, 1);
 
-		/* Use defaults for IRQ delay/coalescing setup.  These
-		 * are configuration values, so does not belong in
-		 * device-tree.
-		 */
-		lp->tx_chnl_ctrl = 0x10220000;
-		lp->rx_chnl_ctrl = 0xff070000;
-		lp->coalesce_count_rx = 0x07;
-
 		/* Finished with the DMA node; drop the reference */
 		of_node_put(dma_np);
 	} else if (pdata) {
@@ -1472,18 +1539,13 @@ static int temac_probe(struct platform_device *pdev)
 		lp->tx_irq = platform_get_irq(pdev, 1);
 
 		/* IRQ delay/coalescing setup */
-		if (pdata->tx_irq_timeout || pdata->tx_irq_count)
-			lp->tx_chnl_ctrl = (pdata->tx_irq_timeout << 24) |
-				(pdata->tx_irq_count << 16);
-		else
-			lp->tx_chnl_ctrl = 0x10220000;
+		if (pdata->tx_irq_timeout || pdata->tx_irq_count) {
+			lp->coalesce_delay_tx = pdata->tx_irq_timeout;
+			lp->coalesce_count_tx = pdata->tx_irq_count;
+		}
 		if (pdata->rx_irq_timeout || pdata->rx_irq_count) {
-			lp->rx_chnl_ctrl = (pdata->rx_irq_timeout << 24) |
-				(pdata->rx_irq_count << 16);
+			lp->coalesce_delay_rx = pdata->rx_irq_timeout;
 			lp->coalesce_count_rx = pdata->rx_irq_count;
-		} else {
-			lp->rx_chnl_ctrl = 0xff070000;
-			lp->coalesce_count_rx = 0x07;
 		}
 	}
 
-- 
2.25.0


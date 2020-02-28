Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D97017323B
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 08:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgB1H5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 02:57:48 -0500
Received: from first.geanix.com ([116.203.34.67]:36238 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbgB1H5s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 02:57:48 -0500
Received: from localhost (87-49-45-242-mobile.dk.customer.tdc.net [87.49.45.242])
        by first.geanix.com (Postfix) with ESMTPSA id 0B510C109A;
        Fri, 28 Feb 2020 07:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582876665; bh=zBgtqCrGUsET1svdVFhciBVSpIAwTr7L1NWazRTC+fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=bZM52pRdtbL11k8JPjIyM/hWy3BMFsu1tEyH9vjA3os/ZbTtFpLZM6LyH+YZEwVym
         gLU4Ik/KD4BroZcsFMnGUwWOaaKrtlyBfi6oGyjHKy0KiJHKrl4YLxvTHDFnxSj9Qv
         sGZfPBO6I9uNhDwz5uyGDuQbr0mg1KyrV44u5fvYL9TWNfIk+BxndZ1Rlz4wIDkamt
         x5qoSg1UmWNoBSQtyhjP5leabp2A4I7rT7mZNi1ud9EpRxRS2c8Y8yeLY8plkSzcth
         D010b6It8twFXdLAwAXlafTMsSL7vELm4dwiDBUrNSqmifxrlZzNgcEye3OdmFIjkw
         2UHku16fLZ+9w==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH net-next 4/4] net: ll_temac: Add ethtool support for coalesce parameters
Date:   Fri, 28 Feb 2020 08:57:41 +0100
Message-Id: <6cead06223920dc5751125c33ce1421e98973593.1582875715.git.esben@geanix.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1582875715.git.esben@geanix.com>
References: <cover.1582875715.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=4.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 05ff821c8cf1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please note that the delays are calculated based on typical
parameters.  But as TEMAC is an HDL IP, designs may vary, and future
work might be needed to make this calculation configurable.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac.h      |  5 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c | 98 ++++++++++++++++-----
 2 files changed, 81 insertions(+), 22 deletions(-)

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
index 5735acb44b57..dc022cd5bc42 100644
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
@@ -1289,6 +1291,65 @@ static int ll_temac_ethtools_set_ringparam(struct net_device *ndev,
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
+	return 0;
+}
+
 static const struct ethtool_ops temac_ethtool_ops = {
 	.nway_reset = phy_ethtool_nway_reset,
 	.get_link = ethtool_op_get_link,
@@ -1297,6 +1358,8 @@ static const struct ethtool_ops temac_ethtool_ops = {
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
 	.get_ringparam	= ll_temac_ethtools_get_ringparam,
 	.set_ringparam	= ll_temac_ethtools_set_ringparam,
+	.get_coalesce	= ll_temac_ethtools_get_coalesce,
+	.set_coalesce	= ll_temac_ethtools_set_coalesce,
 };
 
 static int temac_probe(struct platform_device *pdev)
@@ -1406,6 +1469,14 @@ static int temac_probe(struct platform_device *pdev)
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
@@ -1444,14 +1515,6 @@ static int temac_probe(struct platform_device *pdev)
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
@@ -1477,18 +1540,13 @@ static int temac_probe(struct platform_device *pdev)
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
2.25.1


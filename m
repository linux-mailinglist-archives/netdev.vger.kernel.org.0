Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736E0DDE1
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfD2IfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:35:19 -0400
Received: from first.geanix.com ([116.203.34.67]:50030 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727871AbfD2IfN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:13 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 1C351308E92;
        Mon, 29 Apr 2019 08:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556526828; bh=sZP5Q24Ik4BSDHAkm/3DP/6FSjKHw+wZqugbp80qS/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=VA5rdffKFwkIrLLxxvbXyAT/DEVP9F4trct0zN5Opu3ycIVmZciMEkjeG0X9UaQqw
         Qip3ZFfFnCpIJdjnfqexm3PzBIB2bqMcX8MozhyNXYuVUzHihk+4tA5vlugEv8MeF9
         w95o1bX2AlXBRpeZE4Z29E9PVegnqjKFfUSdTuaOIi1ncNm3ivu3GWuyOkW7RHMP3b
         bZqiyifIje3S7hyTKR3cJKGVlLiWCoe6+DDlVySSizt0ZNQhOnZKBVOMpIk6RsBqiC
         xxrvbvJQ9aJi+1OCOta8Q5W5fz5Gmz86474HGokwdrKoGfHI+z9/236o2csLl7s0R8
         TDAyk/iUVWQCQ==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Yang Wei <yang.wei9@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] net: ll_temac: Allow configuration of IRQ coalescing
Date:   Mon, 29 Apr 2019 10:34:21 +0200
Message-Id: <20190429083422.4356-12-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190429083422.4356-1-esben@geanix.com>
References: <20190426073231.4008-1-esben@geanix.com>
 <20190429083422.4356-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 3e0c63300934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows custom setup of IRQ coalescing for platforms using legacy
platform_device. The irq timeout and count parameters can be used for
tuning cpu load vs. latency.

I have maintained the 0x00000400 bit in TX_CHNL_CTRL.  It is specified as
unused in the documentation I have available.  It does not make any
difference in the hardware I have available, so it is left in to not risk
breaking other platforms where it might be used.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac.h        |  4 +++
 drivers/net/ethernet/xilinx/ll_temac_main.c   | 40 +++++++++++++++++++--------
 include/linux/platform_data/xilinx-ll-temac.h |  5 ++++
 3 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index 990f9ed..1aeda08 100644
--- a/drivers/net/ethernet/xilinx/ll_temac.h
+++ b/drivers/net/ethernet/xilinx/ll_temac.h
@@ -375,6 +375,10 @@ struct temac_local {
 	int tx_bd_next;
 	int tx_bd_tail;
 	int rx_bd_ci;
+
+	/* DMA channel control setup */
+	u32 tx_chnl_ctrl;
+	u32 rx_chnl_ctrl;
 };
 
 /* Wrappers for temac_ior()/temac_iow() function pointers above */
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 5e7b8f0..5833f02 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -306,18 +306,15 @@ static int temac_dma_bd_init(struct net_device *ndev)
 		lp->rx_bd_v[i].app0 = cpu_to_be32(STS_CTRL_APP0_IRQONEND);
 	}
 
-	lp->dma_out(lp, TX_CHNL_CTRL, 0x10220400 |
-					  CHNL_CTRL_IRQ_EN |
-					  CHNL_CTRL_IRQ_DLY_EN |
-					  CHNL_CTRL_IRQ_COAL_EN);
-	/* 0x10220483 */
-	/* 0x00100483 */
-	lp->dma_out(lp, RX_CHNL_CTRL, 0xff070000 |
-					  CHNL_CTRL_IRQ_EN |
-					  CHNL_CTRL_IRQ_DLY_EN |
-					  CHNL_CTRL_IRQ_COAL_EN |
-					  CHNL_CTRL_IRQ_IOE);
-	/* 0xff010283 */
+	/* Configure DMA channel (irq setup) */
+	lp->dma_out(lp, TX_CHNL_CTRL, lp->tx_chnl_ctrl |
+		    0x00000400 | // Use 1 Bit Wide Counters. Currently Not Used!
+		    CHNL_CTRL_IRQ_EN | CHNL_CTRL_IRQ_ERR_EN |
+		    CHNL_CTRL_IRQ_DLY_EN | CHNL_CTRL_IRQ_COAL_EN);
+	lp->dma_out(lp, RX_CHNL_CTRL, lp->rx_chnl_ctrl |
+		    CHNL_CTRL_IRQ_IOE |
+		    CHNL_CTRL_IRQ_EN | CHNL_CTRL_IRQ_ERR_EN |
+		    CHNL_CTRL_IRQ_DLY_EN | CHNL_CTRL_IRQ_COAL_EN);
 
 	lp->dma_out(lp, RX_CURDESC_PTR,  lp->rx_bd_p);
 	lp->dma_out(lp, RX_TAILDESC_PTR,
@@ -1187,6 +1184,13 @@ static int temac_probe(struct platform_device *pdev)
 		lp->rx_irq = irq_of_parse_and_map(dma_np, 0);
 		lp->tx_irq = irq_of_parse_and_map(dma_np, 1);
 
+		/* Use defaults for IRQ delay/coalescing setup.  These
+		 * are configuration values, so does not belong in
+		 * device-tree.
+		 */
+		lp->tx_chnl_ctrl = 0x10220000;
+		lp->rx_chnl_ctrl = 0xff070000;
+
 		/* Finished with the DMA node; drop the reference */
 		of_node_put(dma_np);
 	} else if (pdata) {
@@ -1210,6 +1214,18 @@ static int temac_probe(struct platform_device *pdev)
 		/* Get DMA RX and TX interrupts */
 		lp->rx_irq = platform_get_irq(pdev, 0);
 		lp->tx_irq = platform_get_irq(pdev, 1);
+
+		/* IRQ delay/coalescing setup */
+		if (pdata->tx_irq_timeout || pdata->tx_irq_count)
+			lp->tx_chnl_ctrl = (pdata->tx_irq_timeout << 24) |
+				(pdata->tx_irq_count << 16);
+		else
+			lp->tx_chnl_ctrl = 0x10220000;
+		if (pdata->rx_irq_timeout || pdata->rx_irq_count)
+			lp->rx_chnl_ctrl = (pdata->rx_irq_timeout << 24) |
+				(pdata->rx_irq_count << 16);
+		else
+			lp->rx_chnl_ctrl = 0xff070000;
 	}
 
 	/* Error handle returned DMA RX and TX interrupts */
diff --git a/include/linux/platform_data/xilinx-ll-temac.h b/include/linux/platform_data/xilinx-ll-temac.h
index b0b8238..368530f 100644
--- a/include/linux/platform_data/xilinx-ll-temac.h
+++ b/include/linux/platform_data/xilinx-ll-temac.h
@@ -22,6 +22,11 @@ struct ll_temac_platform_data {
 	 * they share the same DCR bus bridge.
 	 */
 	struct mutex *indirect_mutex;
+	/* DMA channel control setup */
+	u8 tx_irq_timeout;	/* TX Interrupt Delay Time-out */
+	u8 tx_irq_count;	/* TX Interrupt Coalescing Threshold Count */
+	u8 rx_irq_timeout;	/* RX Interrupt Delay Time-out */
+	u8 rx_irq_count;	/* RX Interrupt Coalescing Threshold Count */
 };
 
 #endif /* __LINUX_XILINX_LL_TEMAC_H */
-- 
2.4.11


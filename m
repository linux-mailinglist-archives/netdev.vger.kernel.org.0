Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A66217AC4C
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgCERTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:19:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:41624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727926AbgCERPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:15:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7E212166E;
        Thu,  5 Mar 2020 17:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428503;
        bh=wKyo751Qb290M1eueCeLhse11w1D722qA+2YbQAX6yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+0xQFYoHCf9HXfbvZb2SvO33vo1ldKIFUPCsT9SKcKXLbIRIHAGF874ugyr2GOIA
         jfyNqCbPAvBSxoUa6De22nowiPQV/VkFELwKdBynT27mtgNXv8IJEnsU4yzS2o50KL
         HfG6gGznuois0CDJfXFj/Dn01cK+J4kEZaqFwmxc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Esben Haabendal <esben@geanix.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 34/58] net: ll_temac: Handle DMA halt condition caused by buffer underrun
Date:   Thu,  5 Mar 2020 12:13:55 -0500
Message-Id: <20200305171420.29595-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171420.29595-1-sashal@kernel.org>
References: <20200305171420.29595-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 1d63b8d66d146deaaedbe16c80de105f685ea012 ]

The SDMA engine used by TEMAC halts operation when it has finished
processing of the last buffer descriptor in the buffer ring.
Unfortunately, no interrupt event is generated when this happens,
so we need to setup another mechanism to make sure DMA operation is
restarted when enough buffers have been added to the ring.

Fixes: 92744989533c ("net: add Xilinx ll_temac device driver")
Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac.h      |  3 ++
 drivers/net/ethernet/xilinx/ll_temac_main.c | 58 +++++++++++++++++++--
 2 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index 99fe059e5c7f3..53fb8141f1a67 100644
--- a/drivers/net/ethernet/xilinx/ll_temac.h
+++ b/drivers/net/ethernet/xilinx/ll_temac.h
@@ -380,6 +380,9 @@ struct temac_local {
 	/* DMA channel control setup */
 	u32 tx_chnl_ctrl;
 	u32 rx_chnl_ctrl;
+	u8 coalesce_count_rx;
+
+	struct delayed_work restart_work;
 };
 
 /* Wrappers for temac_ior()/temac_iow() function pointers above */
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 2e3f59dae586e..eb480204cdbeb 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -51,6 +51,7 @@
 #include <linux/ip.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
+#include <linux/workqueue.h>
 #include <linux/dma-mapping.h>
 #include <linux/processor.h>
 #include <linux/platform_data/xilinx-ll-temac.h>
@@ -866,8 +867,11 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	skb_dma_addr = dma_map_single(ndev->dev.parent, skb->data,
 				      skb_headlen(skb), DMA_TO_DEVICE);
 	cur_p->len = cpu_to_be32(skb_headlen(skb));
-	if (WARN_ON_ONCE(dma_mapping_error(ndev->dev.parent, skb_dma_addr)))
-		return NETDEV_TX_BUSY;
+	if (WARN_ON_ONCE(dma_mapping_error(ndev->dev.parent, skb_dma_addr))) {
+		dev_kfree_skb_any(skb);
+		ndev->stats.tx_dropped++;
+		return NETDEV_TX_OK;
+	}
 	cur_p->phys = cpu_to_be32(skb_dma_addr);
 	ptr_to_txbd((void *)skb, cur_p);
 
@@ -897,7 +901,9 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			dma_unmap_single(ndev->dev.parent,
 					 be32_to_cpu(cur_p->phys),
 					 skb_headlen(skb), DMA_TO_DEVICE);
-			return NETDEV_TX_BUSY;
+			dev_kfree_skb_any(skb);
+			ndev->stats.tx_dropped++;
+			return NETDEV_TX_OK;
 		}
 		cur_p->phys = cpu_to_be32(skb_dma_addr);
 		cur_p->len = cpu_to_be32(skb_frag_size(frag));
@@ -920,6 +926,17 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	return NETDEV_TX_OK;
 }
 
+static int ll_temac_recv_buffers_available(struct temac_local *lp)
+{
+	int available;
+
+	if (!lp->rx_skb[lp->rx_bd_ci])
+		return 0;
+	available = 1 + lp->rx_bd_tail - lp->rx_bd_ci;
+	if (available <= 0)
+		available += RX_BD_NUM;
+	return available;
+}
 
 static void ll_temac_recv(struct net_device *ndev)
 {
@@ -990,6 +1007,18 @@ static void ll_temac_recv(struct net_device *ndev)
 			lp->rx_bd_ci = 0;
 	} while (rx_bd != lp->rx_bd_tail);
 
+	/* DMA operations will halt when the last buffer descriptor is
+	 * processed (ie. the one pointed to by RX_TAILDESC_PTR).
+	 * When that happens, no more interrupt events will be
+	 * generated.  No IRQ_COAL or IRQ_DLY, and not even an
+	 * IRQ_ERR.  To avoid stalling, we schedule a delayed work
+	 * when there is a potential risk of that happening.  The work
+	 * will call this function, and thus re-schedule itself until
+	 * enough buffers are available again.
+	 */
+	if (ll_temac_recv_buffers_available(lp) < lp->coalesce_count_rx)
+		schedule_delayed_work(&lp->restart_work, HZ / 1000);
+
 	/* Allocate new buffers for those buffer descriptors that were
 	 * passed to network stack.  Note that GFP_ATOMIC allocations
 	 * can fail (e.g. when a larger burst of GFP_ATOMIC
@@ -1045,6 +1074,18 @@ static void ll_temac_recv(struct net_device *ndev)
 	spin_unlock_irqrestore(&lp->rx_lock, flags);
 }
 
+/* Function scheduled to ensure a restart in case of DMA halt
+ * condition caused by running out of buffer descriptors.
+ */
+static void ll_temac_restart_work_func(struct work_struct *work)
+{
+	struct temac_local *lp = container_of(work, struct temac_local,
+					      restart_work.work);
+	struct net_device *ndev = lp->ndev;
+
+	ll_temac_recv(ndev);
+}
+
 static irqreturn_t ll_temac_tx_irq(int irq, void *_ndev)
 {
 	struct net_device *ndev = _ndev;
@@ -1137,6 +1178,8 @@ static int temac_stop(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "temac_close()\n");
 
+	cancel_delayed_work_sync(&lp->restart_work);
+
 	free_irq(lp->tx_irq, ndev);
 	free_irq(lp->rx_irq, ndev);
 
@@ -1269,6 +1312,7 @@ static int temac_probe(struct platform_device *pdev)
 	lp->dev = &pdev->dev;
 	lp->options = XTE_OPTION_DEFAULTS;
 	spin_lock_init(&lp->rx_lock);
+	INIT_DELAYED_WORK(&lp->restart_work, ll_temac_restart_work_func);
 
 	/* Setup mutex for synchronization of indirect register access */
 	if (pdata) {
@@ -1375,6 +1419,7 @@ static int temac_probe(struct platform_device *pdev)
 		 */
 		lp->tx_chnl_ctrl = 0x10220000;
 		lp->rx_chnl_ctrl = 0xff070000;
+		lp->coalesce_count_rx = 0x07;
 
 		/* Finished with the DMA node; drop the reference */
 		of_node_put(dma_np);
@@ -1406,11 +1451,14 @@ static int temac_probe(struct platform_device *pdev)
 				(pdata->tx_irq_count << 16);
 		else
 			lp->tx_chnl_ctrl = 0x10220000;
-		if (pdata->rx_irq_timeout || pdata->rx_irq_count)
+		if (pdata->rx_irq_timeout || pdata->rx_irq_count) {
 			lp->rx_chnl_ctrl = (pdata->rx_irq_timeout << 24) |
 				(pdata->rx_irq_count << 16);
-		else
+			lp->coalesce_count_rx = pdata->rx_irq_count;
+		} else {
 			lp->rx_chnl_ctrl = 0xff070000;
+			lp->coalesce_count_rx = 0x07;
+		}
 	}
 
 	/* Error handle returned DMA RX and TX interrupts */
-- 
2.20.1


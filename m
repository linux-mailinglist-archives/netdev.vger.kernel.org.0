Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADE68162240
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 09:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgBRI06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 03:26:58 -0500
Received: from first.geanix.com ([116.203.34.67]:59582 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbgBRI06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 03:26:58 -0500
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id C537AC002E;
        Tue, 18 Feb 2020 08:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582014366; bh=wekhhvMCNY7EMRwrvMirFyA6iv84n/skDxu1z8OYPs8=;
        h=From:To:Cc:Subject:Date;
        b=Bbhxb28u2n1YCOHmxWCf+u1DochKYTMsVQJVXflOybdnXAbiJt0lxO09RO2fueYGY
         0nmwgr7eOlr1zp7Zr+ynnex4viXRe3V3xY5IJoQlMFVGAjuPy6+klQB1OWu/c/oSId
         fXfVWnZquiSQ0o2wTN6dhy9206FT7JQoMY4sTOfoWtIGt0dhrQIrSMb45gs+AzmMwy
         /9s/DsEyqJXQOGD7+93aiyaTb1WYVvic/h+aB8ago4FKYB3fOyIkX/glxPNnElksFz
         8nrLVAZ4icnFyKMZ0h8/Qu0boxQd1KbVEzdFZ1unuGaLNTG5HXlQ/k2ys7YnmZ8kYc
         w2Mc8vJgnQjkA==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        stable@vger.kernel.org
Subject: [PATCH 4/8] net: ll_temac: Handle DMA halt condition caused by buffer underrun
Date:   Tue, 18 Feb 2020 09:26:54 +0100
Message-Id: <20200218082654.7372-1-esben@geanix.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.2 required=4.0 tests=BAYES_40,DKIM_INVALID,
        DKIM_SIGNED,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=disabled
        version=3.4.3
X-Spam-Checker-Version: SpamAssassin 3.4.3 (2019-12-06) on eb9da72b0f73
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SDMA engine used by TEMAC halts operation when it has finished
processing of the last buffer descriptor in the buffer ring.
Unfortunately, no interrupt event is generated when this happens,
so we need to setup another mechanism to make sure DMA operation is
restarted when enough buffers have been added to the ring.

Signed-off-by: Esben Haabendal <esben@geanix.com>
Cc: stable@vger.kernel.org
---
 drivers/net/ethernet/xilinx/ll_temac.h      |  3 ++
 drivers/net/ethernet/xilinx/ll_temac_main.c | 47 ++++++++++++++++++++-
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index 99fe059e5c7f..53fb8141f1a6 100644
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
index 255207f2fd27..90b486becb5b 100644
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
@@ -920,6 +921,17 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
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
@@ -990,6 +1002,18 @@ static void ll_temac_recv(struct net_device *ndev)
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
@@ -1045,6 +1069,18 @@ static void ll_temac_recv(struct net_device *ndev)
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
@@ -1137,6 +1173,8 @@ static int temac_stop(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "temac_close()\n");
 
+	cancel_delayed_work_sync(&lp->restart_work);
+
 	free_irq(lp->tx_irq, ndev);
 	free_irq(lp->rx_irq, ndev);
 
@@ -1258,6 +1296,7 @@ static int temac_probe(struct platform_device *pdev)
 	lp->dev = &pdev->dev;
 	lp->options = XTE_OPTION_DEFAULTS;
 	spin_lock_init(&lp->rx_lock);
+	INIT_DELAYED_WORK(&lp->restart_work, ll_temac_restart_work_func);
 
 	/* Setup mutex for synchronization of indirect register access */
 	if (pdata) {
@@ -1364,6 +1403,7 @@ static int temac_probe(struct platform_device *pdev)
 		 */
 		lp->tx_chnl_ctrl = 0x10220000;
 		lp->rx_chnl_ctrl = 0xff070000;
+		lp->coalesce_count_rx = 0x07;
 
 		/* Finished with the DMA node; drop the reference */
 		of_node_put(dma_np);
@@ -1395,11 +1435,14 @@ static int temac_probe(struct platform_device *pdev)
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
2.25.0


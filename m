Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132DA68E904
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 08:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjBHHfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 02:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjBHHe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 02:34:57 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D37C31E1C;
        Tue,  7 Feb 2023 23:34:55 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,280,1669042800"; 
   d="scan'208";a="148858884"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 08 Feb 2023 16:34:54 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id A0C4641C8A7D;
        Wed,  8 Feb 2023 16:34:54 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next 4/4] net: renesas: rswitch: Improve TX timestamp accuracy
Date:   Wed,  8 Feb 2023 16:34:45 +0900
Message-Id: <20230208073445.2317192-5-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230208073445.2317192-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230208073445.2317192-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the previous code, TX timestamp accuracy was bad because the irq
handler got the timestamp from the timestamp register at that time.

This hardware has "Timestamp capture" feature which can store
each TX timestamp into the timestamp descriptors. To improve
TX timestamp accuracy, implement timestamp descriptors' handling.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 166 ++++++++++++++++++++++---
 drivers/net/ethernet/renesas/rswitch.h |  35 +++++-
 2 files changed, 179 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index e408d10184e8..4fba647835f2 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -123,13 +123,6 @@ static void rswitch_fwd_init(struct rswitch_private *priv)
 	iowrite32(GENMASK(RSWITCH_NUM_PORTS - 1, 0), priv->addr + FWPBFC(priv->gwca.index));
 }
 
-/* gPTP timer (gPTP) */
-static void rswitch_get_timestamp(struct rswitch_private *priv,
-				  struct timespec64 *ts)
-{
-	priv->ptp_priv->info.gettime64(&priv->ptp_priv->info, ts);
-}
-
 /* Gateway CPU agent block (GWCA) */
 static int rswitch_gwca_change_mode(struct rswitch_private *priv,
 				    enum rswitch_gwca_mode mode)
@@ -299,6 +292,16 @@ static void rswitch_gwca_queue_free(struct net_device *ndev,
 	gq->skbs = NULL;
 }
 
+static void rswitch_gwca_ts_queue_free(struct rswitch_private *priv)
+{
+	struct rswitch_gwca_queue *gq = &priv->gwca.ts_queue;
+
+	dma_free_coherent(&priv->pdev->dev,
+			  sizeof(struct rswitch_ts_desc) * (gq->ring_size + 1),
+			  gq->ts_ring, gq->ring_dma);
+	gq->ts_ring = NULL;
+}
+
 static int rswitch_gwca_queue_alloc(struct net_device *ndev,
 				    struct rswitch_private *priv,
 				    struct rswitch_gwca_queue *gq,
@@ -344,6 +347,17 @@ static int rswitch_gwca_queue_alloc(struct net_device *ndev,
 	return -ENOMEM;
 }
 
+static int rswitch_gwca_ts_queue_alloc(struct rswitch_private *priv)
+{
+	struct rswitch_gwca_queue *gq = &priv->gwca.ts_queue;
+
+	gq->ring_size = TS_RING_SIZE;
+	gq->ts_ring = dma_alloc_coherent(&priv->pdev->dev,
+					 sizeof(struct rswitch_ts_desc) *
+					 (gq->ring_size + 1), &gq->ring_dma, GFP_KERNEL);
+	return !gq->ts_ring ? -ENOMEM : 0;
+}
+
 static void rswitch_desc_set_dptr(struct rswitch_desc *desc, dma_addr_t addr)
 {
 	desc->dptrl = cpu_to_le32(lower_32_bits(addr));
@@ -405,6 +419,20 @@ static int rswitch_gwca_queue_format(struct net_device *ndev,
 	return -ENOMEM;
 }
 
+static void rswitch_gwca_ts_queue_fill(struct rswitch_private *priv,
+				       int start_index, int num)
+{
+	struct rswitch_gwca_queue *gq = &priv->gwca.ts_queue;
+	struct rswitch_ts_desc *desc;
+	int i, index;
+
+	for (i = 0; i < num; i++) {
+		index = (i + start_index) % gq->ring_size;
+		desc = &gq->ts_ring[index];
+		desc->desc.die_dt = DT_FEMPTY_ND | DIE;
+	}
+}
+
 static int rswitch_gwca_queue_ext_ts_fill(struct net_device *ndev,
 					  struct rswitch_gwca_queue *gq,
 					  int start_index, int num)
@@ -618,6 +646,9 @@ static int rswitch_gwca_hw_init(struct rswitch_private *priv)
 	iowrite32(0, priv->addr + GWTTFC);
 	iowrite32(lower_32_bits(priv->gwca.linkfix_table_dma), priv->addr + GWDCBAC1);
 	iowrite32(upper_32_bits(priv->gwca.linkfix_table_dma), priv->addr + GWDCBAC0);
+	iowrite32(lower_32_bits(priv->gwca.ts_queue.ring_dma), priv->addr + GWTDCAC10);
+	iowrite32(upper_32_bits(priv->gwca.ts_queue.ring_dma), priv->addr + GWTDCAC00);
+	iowrite32(GWCA_TS_IRQ_BIT, priv->addr + GWTSDCC0);
 	rswitch_gwca_set_rate_limit(priv, priv->gwca.speed);
 
 	for (i = 0; i < RSWITCH_NUM_PORTS; i++) {
@@ -744,15 +775,6 @@ static int rswitch_tx_free(struct net_device *ndev, bool free_txed_only)
 		size = le16_to_cpu(desc->desc.info_ds) & TX_DS;
 		skb = gq->skbs[gq->dirty];
 		if (skb) {
-			if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
-				struct skb_shared_hwtstamps shhwtstamps;
-				struct timespec64 ts;
-
-				rswitch_get_timestamp(rdev->priv, &ts);
-				memset(&shhwtstamps, 0, sizeof(shhwtstamps));
-				shhwtstamps.hwtstamp = timespec64_to_ktime(ts);
-				skb_tstamp_tx(skb, &shhwtstamps);
-			}
 			dma_addr = rswitch_desc_get_dptr(&desc->desc);
 			dma_unmap_single(ndev->dev.parent, dma_addr,
 					 size, DMA_TO_DEVICE);
@@ -878,6 +900,73 @@ static int rswitch_gwca_request_irqs(struct rswitch_private *priv)
 	return 0;
 }
 
+static void rswitch_ts(struct rswitch_private *priv)
+{
+	struct rswitch_gwca_queue *gq = &priv->gwca.ts_queue;
+	struct rswitch_gwca_ts_info *ts_info, *ts_info2;
+	struct skb_shared_hwtstamps shhwtstamps;
+	struct rswitch_ts_desc *desc;
+	struct timespec64 ts;
+	u32 tag, port;
+	int num;
+
+	desc = &gq->ts_ring[gq->cur];
+	while ((desc->desc.die_dt & DT_MASK) != DT_FEMPTY_ND) {
+		dma_rmb();
+
+		port = TS_DESC_DPN(desc->desc.dptrl);
+		tag = TS_DESC_TSUN(desc->desc.dptrl);
+
+		list_for_each_entry_safe(ts_info, ts_info2, &priv->gwca.ts_info_list, list) {
+			if (!(ts_info->port == port && ts_info->tag == tag))
+				continue;
+
+			memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+			ts.tv_sec = __le32_to_cpu(desc->ts_sec);
+			ts.tv_nsec = __le32_to_cpu(desc->ts_nsec & cpu_to_le32(0x3fffffff));
+			shhwtstamps.hwtstamp = timespec64_to_ktime(ts);
+			skb_tstamp_tx(ts_info->skb, &shhwtstamps);
+			dev_consume_skb_irq(ts_info->skb);
+			list_del(&ts_info->list);
+			kfree(ts_info);
+			break;
+		}
+
+		gq->cur = rswitch_next_queue_index(gq, true, 1);
+		desc = &gq->ts_ring[gq->cur];
+	}
+
+	num = rswitch_get_num_cur_queues(gq);
+	rswitch_gwca_ts_queue_fill(priv, gq->dirty, num);
+	gq->dirty = rswitch_next_queue_index(gq, false, num);
+}
+
+static irqreturn_t rswitch_gwca_ts_irq(int irq, void *dev_id)
+{
+	struct rswitch_private *priv = dev_id;
+
+	if (ioread32(priv->addr + GWTSDIS) & GWCA_TS_IRQ_BIT) {
+		iowrite32(GWCA_TS_IRQ_BIT, priv->addr + GWTSDIS);
+		rswitch_ts(priv);
+
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static int rswitch_gwca_ts_request_irqs(struct rswitch_private *priv)
+{
+	int irq;
+
+	irq = platform_get_irq_byname(priv->pdev, GWCA_TS_IRQ_RESOURCE_NAME);
+	if (irq < 0)
+		return irq;
+
+	return devm_request_irq(&priv->pdev->dev, irq, rswitch_gwca_ts_irq,
+				0, GWCA_TS_IRQ_NAME, priv);
+}
+
 /* Ethernet TSN Agent block (ETHA) and Ethernet MAC IP block (RMAC) */
 static int rswitch_etha_change_mode(struct rswitch_etha *etha,
 				    enum rswitch_etha_mode mode)
@@ -1348,15 +1437,28 @@ static int rswitch_open(struct net_device *ndev)
 	rswitch_enadis_data_irq(rdev->priv, rdev->tx_queue->index, true);
 	rswitch_enadis_data_irq(rdev->priv, rdev->rx_queue->index, true);
 
+	iowrite32(GWCA_TS_IRQ_BIT, rdev->priv->addr + GWTSDIE);
+
 	return 0;
 };
 
 static int rswitch_stop(struct net_device *ndev)
 {
 	struct rswitch_device *rdev = netdev_priv(ndev);
+	struct rswitch_gwca_ts_info *ts_info, *ts_info2;
 
 	netif_tx_stop_all_queues(ndev);
 
+	iowrite32(GWCA_TS_IRQ_BIT, rdev->priv->addr + GWTSDID);
+
+	list_for_each_entry_safe(ts_info, ts_info2, &rdev->priv->gwca.ts_info_list, list) {
+		if (ts_info->port != rdev->port)
+			continue;
+		dev_kfree_skb_irq(ts_info->skb);
+		list_del(&ts_info->list);
+		kfree(ts_info);
+	}
+
 	rswitch_enadis_data_irq(rdev->priv, rdev->tx_queue->index, false);
 	rswitch_enadis_data_irq(rdev->priv, rdev->rx_queue->index, false);
 
@@ -1395,11 +1497,25 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
 
 	desc->info1 = cpu_to_le64(INFO1_DV(BIT(rdev->etha->index)) | INFO1_FMT);
 	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+		struct rswitch_gwca_ts_info *ts_info;
+
+		ts_info = kzalloc(sizeof(*ts_info), GFP_ATOMIC);
+		if (!ts_info) {
+			dma_unmap_single(ndev->dev.parent, dma_addr, skb->len, DMA_TO_DEVICE);
+			return -ENOMEM;
+		}
+
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 		rdev->ts_tag++;
 		desc->info1 |= cpu_to_le64(INFO1_TSUN(rdev->ts_tag) | INFO1_TXC);
+
+		ts_info->skb = skb_get(skb);
+		ts_info->port = rdev->port;
+		ts_info->tag = rdev->ts_tag;
+		list_add_tail(&ts_info->list, &rdev->priv->gwca.ts_info_list);
+
+		skb_tx_timestamp(skb);
 	}
-	skb_tx_timestamp(skb);
 
 	dma_wmb();
 
@@ -1653,6 +1769,13 @@ static int rswitch_init(struct rswitch_private *priv)
 	if (err < 0)
 		return -ENOMEM;
 
+	err = rswitch_gwca_ts_queue_alloc(priv);
+	if (err < 0)
+		goto err_ts_queue_alloc;
+
+	rswitch_gwca_ts_queue_fill(priv, 0, TS_RING_SIZE);
+	INIT_LIST_HEAD(&priv->gwca.ts_info_list);
+
 	for (i = 0; i < RSWITCH_NUM_PORTS; i++) {
 		err = rswitch_device_alloc(priv, i);
 		if (err < 0) {
@@ -1673,6 +1796,10 @@ static int rswitch_init(struct rswitch_private *priv)
 	if (err < 0)
 		goto err_gwca_request_irq;
 
+	err = rswitch_gwca_ts_request_irqs(priv);
+	if (err < 0)
+		goto err_gwca_ts_request_irq;
+
 	err = rswitch_gwca_hw_init(priv);
 	if (err < 0)
 		goto err_gwca_hw_init;
@@ -1703,6 +1830,7 @@ static int rswitch_init(struct rswitch_private *priv)
 	rswitch_gwca_hw_deinit(priv);
 
 err_gwca_hw_init:
+err_gwca_ts_request_irq:
 err_gwca_request_irq:
 	rcar_gen4_ptp_unregister(priv->ptp_priv);
 
@@ -1711,6 +1839,9 @@ static int rswitch_init(struct rswitch_private *priv)
 		rswitch_device_free(priv, i);
 
 err_device_alloc:
+	rswitch_gwca_ts_queue_free(priv);
+
+err_ts_queue_alloc:
 	rswitch_gwca_linkfix_free(priv);
 
 	return err;
@@ -1790,6 +1921,7 @@ static void rswitch_deinit(struct rswitch_private *priv)
 		rswitch_device_free(priv, i);
 	}
 
+	rswitch_gwca_ts_queue_free(priv);
 	rswitch_gwca_linkfix_free(priv);
 
 	rswitch_clock_disable(priv);
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index ee36e8e896d2..27d3d38c055f 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -27,6 +27,7 @@
 
 #define TX_RING_SIZE		1024
 #define RX_RING_SIZE		1024
+#define TS_RING_SIZE		(TX_RING_SIZE * RSWITCH_NUM_PORTS)
 
 #define PKT_BUF_SZ		1584
 #define RSWITCH_ALIGN		128
@@ -49,6 +50,10 @@
 #define AGENT_INDEX_GWCA	3
 #define GWRO			RSWITCH_GWCA0_OFFSET
 
+#define GWCA_TS_IRQ_RESOURCE_NAME	"gwca0_rxts0"
+#define GWCA_TS_IRQ_NAME		"rswitch: gwca0_rxts0"
+#define GWCA_TS_IRQ_BIT			BIT(0)
+
 #define FWRO	0
 #define TPRO	RSWITCH_TOP_OFFSET
 #define CARO	RSWITCH_COMA_OFFSET
@@ -831,7 +836,7 @@ enum DIE_DT {
 	DT_FSINGLE	= 0x80,
 	DT_FSTART	= 0x90,
 	DT_FMID		= 0xa0,
-	DT_FEND		= 0xb8,
+	DT_FEND		= 0xb0,
 
 	/* Chain control */
 	DT_LEMPTY	= 0xc0,
@@ -843,7 +848,7 @@ enum DIE_DT {
 	DT_FEMPTY	= 0x40,
 	DT_FEMPTY_IS	= 0x10,
 	DT_FEMPTY_IC	= 0x20,
-	DT_FEMPTY_ND	= 0x38,
+	DT_FEMPTY_ND	= 0x30,
 	DT_FEMPTY_START	= 0x50,
 	DT_FEMPTY_MID	= 0x60,
 	DT_FEMPTY_END	= 0x70,
@@ -865,6 +870,12 @@ enum DIE_DT {
 /* For reception */
 #define INFO1_SPN(port)		((u64)(port) << 36ULL)
 
+/* For timestamp descriptor in dptrl (Byte 4 to 7) */
+#define TS_DESC_TSUN(dptrl)	((dptrl) & GENMASK(7, 0))
+#define TS_DESC_SPN(dptrl)	(((dptrl) & GENMASK(10, 8)) >> 8)
+#define TS_DESC_DPN(dptrl)	(((dptrl) & GENMASK(17, 16)) >> 16)
+#define TS_DESC_TN(dptrl)	((dptrl) & BIT(24))
+
 struct rswitch_desc {
 	__le16 info_ds;	/* Descriptor size */
 	u8 die_dt;	/* Descriptor interrupt enable and type */
@@ -911,21 +922,33 @@ struct rswitch_etha {
  * name, this driver calls "queue".
  */
 struct rswitch_gwca_queue {
-	int index;
-	bool dir_tx;
 	union {
 		struct rswitch_ext_desc *tx_ring;
 		struct rswitch_ext_ts_desc *rx_ring;
+		struct rswitch_ts_desc *ts_ring;
 	};
+
+	/* Common */
 	dma_addr_t ring_dma;
 	int ring_size;
 	int cur;
 	int dirty;
-	struct sk_buff **skbs;
 
+	/* For [rt]_ring */
+	int index;
+	bool dir_tx;
+	struct sk_buff **skbs;
 	struct net_device *ndev;	/* queue to ndev for irq */
 };
 
+struct rswitch_gwca_ts_info {
+	struct sk_buff *skb;
+	struct list_head list;
+
+	int port;
+	u8 tag;
+};
+
 #define RSWITCH_NUM_IRQ_REGS	(RSWITCH_MAX_NUM_QUEUES / BITS_PER_TYPE(u32))
 struct rswitch_gwca {
 	int index;
@@ -934,6 +957,8 @@ struct rswitch_gwca {
 	u32 linkfix_table_size;
 	struct rswitch_gwca_queue *queues;
 	int num_queues;
+	struct rswitch_gwca_queue ts_queue;
+	struct list_head ts_info_list;
 	DECLARE_BITMAP(used, RSWITCH_MAX_NUM_QUEUES);
 	u32 tx_irq_bits[RSWITCH_NUM_IRQ_REGS];
 	u32 rx_irq_bits[RSWITCH_NUM_IRQ_REGS];
-- 
2.25.1


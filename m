Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0101668FBBA
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 00:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjBHX5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 18:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjBHX5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 18:57:31 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA9201E2AB;
        Wed,  8 Feb 2023 15:57:29 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,281,1669042800"; 
   d="scan'208";a="152153737"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 09 Feb 2023 08:57:28 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id D13F440029BF;
        Thu,  9 Feb 2023 08:57:28 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v2 1/4] net: renesas: rswitch: Rename rings in struct rswitch_gwca_queue
Date:   Thu,  9 Feb 2023 08:57:18 +0900
Message-Id: <20230208235721.2336249-2-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230208235721.2336249-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230208235721.2336249-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To add a new ring which is really related to timestamp (ts_ring)
in the future, rename the following members to improve readability:

    ring --> tx_ring
    ts_ring --> rx_ring

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 64 +++++++++++++-------------
 drivers/net/ethernet/renesas/rswitch.h |  4 +-
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 50b61a0a7f53..6207692f9c56 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -240,7 +240,7 @@ static int rswitch_get_num_cur_queues(struct rswitch_gwca_queue *gq)
 
 static bool rswitch_is_queue_rxed(struct rswitch_gwca_queue *gq)
 {
-	struct rswitch_ext_ts_desc *desc = &gq->ts_ring[gq->dirty];
+	struct rswitch_ext_ts_desc *desc = &gq->rx_ring[gq->dirty];
 
 	if ((desc->desc.die_dt & DT_MASK) != DT_FEMPTY)
 		return true;
@@ -283,13 +283,13 @@ static void rswitch_gwca_queue_free(struct net_device *ndev,
 	if (gq->gptp) {
 		dma_free_coherent(ndev->dev.parent,
 				  sizeof(struct rswitch_ext_ts_desc) *
-				  (gq->ring_size + 1), gq->ts_ring, gq->ring_dma);
-		gq->ts_ring = NULL;
+				  (gq->ring_size + 1), gq->rx_ring, gq->ring_dma);
+		gq->rx_ring = NULL;
 	} else {
 		dma_free_coherent(ndev->dev.parent,
 				  sizeof(struct rswitch_ext_desc) *
-				  (gq->ring_size + 1), gq->ring, gq->ring_dma);
-		gq->ring = NULL;
+				  (gq->ring_size + 1), gq->tx_ring, gq->ring_dma);
+		gq->tx_ring = NULL;
 	}
 
 	if (!gq->dir_tx) {
@@ -321,14 +321,14 @@ static int rswitch_gwca_queue_alloc(struct net_device *ndev,
 		rswitch_gwca_queue_alloc_skb(gq, 0, gq->ring_size);
 
 	if (gptp)
-		gq->ts_ring = dma_alloc_coherent(ndev->dev.parent,
+		gq->rx_ring = dma_alloc_coherent(ndev->dev.parent,
 						 sizeof(struct rswitch_ext_ts_desc) *
 						 (gq->ring_size + 1), &gq->ring_dma, GFP_KERNEL);
 	else
-		gq->ring = dma_alloc_coherent(ndev->dev.parent,
-					      sizeof(struct rswitch_ext_desc) *
-					      (gq->ring_size + 1), &gq->ring_dma, GFP_KERNEL);
-	if (!gq->ts_ring && !gq->ring)
+		gq->tx_ring = dma_alloc_coherent(ndev->dev.parent,
+						 sizeof(struct rswitch_ext_desc) *
+						 (gq->ring_size + 1), &gq->ring_dma, GFP_KERNEL);
+	if (!gq->rx_ring && !gq->tx_ring)
 		goto out;
 
 	i = gq->index / 32;
@@ -361,14 +361,14 @@ static int rswitch_gwca_queue_format(struct net_device *ndev,
 				     struct rswitch_private *priv,
 				     struct rswitch_gwca_queue *gq)
 {
-	int tx_ring_size = sizeof(struct rswitch_ext_desc) * gq->ring_size;
+	int ring_size = sizeof(struct rswitch_ext_desc) * gq->ring_size;
 	struct rswitch_ext_desc *desc;
 	struct rswitch_desc *linkfix;
 	dma_addr_t dma_addr;
 	int i;
 
-	memset(gq->ring, 0, tx_ring_size);
-	for (i = 0, desc = gq->ring; i < gq->ring_size; i++, desc++) {
+	memset(gq->tx_ring, 0, ring_size);
+	for (i = 0, desc = gq->tx_ring; i < gq->ring_size; i++, desc++) {
 		if (!gq->dir_tx) {
 			dma_addr = dma_map_single(ndev->dev.parent,
 						  gq->skbs[i]->data, PKT_BUF_SZ,
@@ -397,7 +397,7 @@ static int rswitch_gwca_queue_format(struct net_device *ndev,
 
 err:
 	if (!gq->dir_tx) {
-		for (i--, desc = gq->ring; i >= 0; i--, desc++) {
+		for (i--, desc = gq->tx_ring; i >= 0; i--, desc++) {
 			dma_addr = rswitch_desc_get_dptr(&desc->desc);
 			dma_unmap_single(ndev->dev.parent, dma_addr, PKT_BUF_SZ,
 					 DMA_FROM_DEVICE);
@@ -407,9 +407,9 @@ static int rswitch_gwca_queue_format(struct net_device *ndev,
 	return -ENOMEM;
 }
 
-static int rswitch_gwca_queue_ts_fill(struct net_device *ndev,
-				      struct rswitch_gwca_queue *gq,
-				      int start_index, int num)
+static int rswitch_gwca_queue_ext_ts_fill(struct net_device *ndev,
+					  struct rswitch_gwca_queue *gq,
+					  int start_index, int num)
 {
 	struct rswitch_device *rdev = netdev_priv(ndev);
 	struct rswitch_ext_ts_desc *desc;
@@ -418,7 +418,7 @@ static int rswitch_gwca_queue_ts_fill(struct net_device *ndev,
 
 	for (i = 0; i < num; i++) {
 		index = (i + start_index) % gq->ring_size;
-		desc = &gq->ts_ring[index];
+		desc = &gq->rx_ring[index];
 		if (!gq->dir_tx) {
 			dma_addr = dma_map_single(ndev->dev.parent,
 						  gq->skbs[index]->data, PKT_BUF_SZ,
@@ -442,7 +442,7 @@ static int rswitch_gwca_queue_ts_fill(struct net_device *ndev,
 	if (!gq->dir_tx) {
 		for (i--; i >= 0; i--) {
 			index = (i + start_index) % gq->ring_size;
-			desc = &gq->ts_ring[index];
+			desc = &gq->rx_ring[index];
 			dma_addr = rswitch_desc_get_dptr(&desc->desc);
 			dma_unmap_single(ndev->dev.parent, dma_addr, PKT_BUF_SZ,
 					 DMA_FROM_DEVICE);
@@ -452,21 +452,21 @@ static int rswitch_gwca_queue_ts_fill(struct net_device *ndev,
 	return -ENOMEM;
 }
 
-static int rswitch_gwca_queue_ts_format(struct net_device *ndev,
-					struct rswitch_private *priv,
-					struct rswitch_gwca_queue *gq)
+static int rswitch_gwca_queue_ext_ts_format(struct net_device *ndev,
+					    struct rswitch_private *priv,
+					    struct rswitch_gwca_queue *gq)
 {
-	int tx_ts_ring_size = sizeof(struct rswitch_ext_ts_desc) * gq->ring_size;
+	int ring_size = sizeof(struct rswitch_ext_ts_desc) * gq->ring_size;
 	struct rswitch_ext_ts_desc *desc;
 	struct rswitch_desc *linkfix;
 	int err;
 
-	memset(gq->ts_ring, 0, tx_ts_ring_size);
-	err = rswitch_gwca_queue_ts_fill(ndev, gq, 0, gq->ring_size);
+	memset(gq->rx_ring, 0, ring_size);
+	err = rswitch_gwca_queue_ext_ts_fill(ndev, gq, 0, gq->ring_size);
 	if (err < 0)
 		return err;
 
-	desc = &gq->ts_ring[gq->ring_size];	/* Last */
+	desc = &gq->rx_ring[gq->ring_size];	/* Last */
 	rswitch_desc_set_dptr(&desc->desc, gq->ring_dma);
 	desc->desc.die_dt = DT_LINKFIX;
 
@@ -594,7 +594,7 @@ static int rswitch_rxdmac_init(struct rswitch_private *priv, int index)
 	struct rswitch_device *rdev = priv->rdev[index];
 	struct net_device *ndev = rdev->ndev;
 
-	return rswitch_gwca_queue_ts_format(ndev, priv, rdev->rx_queue);
+	return rswitch_gwca_queue_ext_ts_format(ndev, priv, rdev->rx_queue);
 }
 
 static int rswitch_gwca_hw_init(struct rswitch_private *priv)
@@ -675,7 +675,7 @@ static bool rswitch_rx(struct net_device *ndev, int *quota)
 	boguscnt = min_t(int, gq->ring_size, *quota);
 	limit = boguscnt;
 
-	desc = &gq->ts_ring[gq->cur];
+	desc = &gq->rx_ring[gq->cur];
 	while ((desc->desc.die_dt & DT_MASK) != DT_FEMPTY) {
 		if (--boguscnt < 0)
 			break;
@@ -703,14 +703,14 @@ static bool rswitch_rx(struct net_device *ndev, int *quota)
 		rdev->ndev->stats.rx_bytes += pkt_len;
 
 		gq->cur = rswitch_next_queue_index(gq, true, 1);
-		desc = &gq->ts_ring[gq->cur];
+		desc = &gq->rx_ring[gq->cur];
 	}
 
 	num = rswitch_get_num_cur_queues(gq);
 	ret = rswitch_gwca_queue_alloc_skb(gq, gq->dirty, num);
 	if (ret < 0)
 		goto err;
-	ret = rswitch_gwca_queue_ts_fill(ndev, gq, gq->dirty, num);
+	ret = rswitch_gwca_queue_ext_ts_fill(ndev, gq, gq->dirty, num);
 	if (ret < 0)
 		goto err;
 	gq->dirty = rswitch_next_queue_index(gq, false, num);
@@ -737,7 +737,7 @@ static int rswitch_tx_free(struct net_device *ndev, bool free_txed_only)
 
 	for (; rswitch_get_num_cur_queues(gq) > 0;
 	     gq->dirty = rswitch_next_queue_index(gq, false, 1)) {
-		desc = &gq->ring[gq->dirty];
+		desc = &gq->tx_ring[gq->dirty];
 		if (free_txed_only && (desc->desc.die_dt & DT_MASK) != DT_FEMPTY)
 			break;
 
@@ -1390,7 +1390,7 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
 	}
 
 	gq->skbs[gq->cur] = skb;
-	desc = &gq->ring[gq->cur];
+	desc = &gq->tx_ring[gq->cur];
 	rswitch_desc_set_dptr(&desc->desc, dma_addr);
 	desc->desc.info_ds = cpu_to_le16(skb->len);
 
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index 59830ab91a69..390ec242ed69 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -915,8 +915,8 @@ struct rswitch_gwca_queue {
 	bool dir_tx;
 	bool gptp;
 	union {
-		struct rswitch_ext_desc *ring;
-		struct rswitch_ext_ts_desc *ts_ring;
+		struct rswitch_ext_desc *tx_ring;
+		struct rswitch_ext_ts_desc *rx_ring;
 	};
 	dma_addr_t ring_dma;
 	int ring_size;
-- 
2.25.1


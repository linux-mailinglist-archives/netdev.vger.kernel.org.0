Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBEF68E90B
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 08:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjBHHfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 02:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjBHHe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 02:34:58 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49C903253C;
        Tue,  7 Feb 2023 23:34:57 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,280,1669042800"; 
   d="scan'208";a="152068350"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 08 Feb 2023 16:34:54 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 8C05B41C8690;
        Wed,  8 Feb 2023 16:34:54 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next 3/4] net: renesas: rswitch: Remove gptp flag from rswitch_gwca_queue
Date:   Wed,  8 Feb 2023 16:34:44 +0900
Message-Id: <20230208073445.2317192-4-yoshihiro.shimoda.uh@renesas.com>
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

The gptp flag is completely related to the !dir_tx in struct
rswitch_gwca_queue. In the future, a new queue handling for
timestamp will be implemented and this gptp flag is confusable.
So, remove the gptp flag.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 26 +++++++++++---------------
 drivers/net/ethernet/renesas/rswitch.h |  1 -
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index b256dadada1d..e408d10184e8 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -280,11 +280,14 @@ static void rswitch_gwca_queue_free(struct net_device *ndev,
 {
 	int i;
 
-	if (gq->gptp) {
+	if (!gq->dir_tx) {
 		dma_free_coherent(ndev->dev.parent,
 				  sizeof(struct rswitch_ext_ts_desc) *
 				  (gq->ring_size + 1), gq->rx_ring, gq->ring_dma);
 		gq->rx_ring = NULL;
+
+		for (i = 0; i < gq->ring_size; i++)
+			dev_kfree_skb(gq->skbs[i]);
 	} else {
 		dma_free_coherent(ndev->dev.parent,
 				  sizeof(struct rswitch_ext_desc) *
@@ -292,11 +295,6 @@ static void rswitch_gwca_queue_free(struct net_device *ndev,
 		gq->tx_ring = NULL;
 	}
 
-	if (!gq->dir_tx) {
-		for (i = 0; i < gq->ring_size; i++)
-			dev_kfree_skb(gq->skbs[i]);
-	}
-
 	kfree(gq->skbs);
 	gq->skbs = NULL;
 }
@@ -304,12 +302,11 @@ static void rswitch_gwca_queue_free(struct net_device *ndev,
 static int rswitch_gwca_queue_alloc(struct net_device *ndev,
 				    struct rswitch_private *priv,
 				    struct rswitch_gwca_queue *gq,
-				    bool dir_tx, bool gptp, int ring_size)
+				    bool dir_tx, int ring_size)
 {
 	int i, bit;
 
 	gq->dir_tx = dir_tx;
-	gq->gptp = gptp;
 	gq->ring_size = ring_size;
 	gq->ndev = ndev;
 
@@ -317,17 +314,18 @@ static int rswitch_gwca_queue_alloc(struct net_device *ndev,
 	if (!gq->skbs)
 		return -ENOMEM;
 
-	if (!dir_tx)
+	if (!dir_tx) {
 		rswitch_gwca_queue_alloc_skb(gq, 0, gq->ring_size);
 
-	if (gptp)
 		gq->rx_ring = dma_alloc_coherent(ndev->dev.parent,
 						 sizeof(struct rswitch_ext_ts_desc) *
 						 (gq->ring_size + 1), &gq->ring_dma, GFP_KERNEL);
-	else
+	} else {
 		gq->tx_ring = dma_alloc_coherent(ndev->dev.parent,
 						 sizeof(struct rswitch_ext_desc) *
 						 (gq->ring_size + 1), &gq->ring_dma, GFP_KERNEL);
+	}
+
 	if (!gq->rx_ring && !gq->tx_ring)
 		goto out;
 
@@ -539,8 +537,7 @@ static int rswitch_txdmac_alloc(struct net_device *ndev)
 	if (!rdev->tx_queue)
 		return -EBUSY;
 
-	err = rswitch_gwca_queue_alloc(ndev, priv, rdev->tx_queue, true, false,
-				       TX_RING_SIZE);
+	err = rswitch_gwca_queue_alloc(ndev, priv, rdev->tx_queue, true, TX_RING_SIZE);
 	if (err < 0) {
 		rswitch_gwca_put(priv, rdev->tx_queue);
 		return err;
@@ -574,8 +571,7 @@ static int rswitch_rxdmac_alloc(struct net_device *ndev)
 	if (!rdev->rx_queue)
 		return -EBUSY;
 
-	err = rswitch_gwca_queue_alloc(ndev, priv, rdev->rx_queue, false, true,
-				       RX_RING_SIZE);
+	err = rswitch_gwca_queue_alloc(ndev, priv, rdev->rx_queue, false, RX_RING_SIZE);
 	if (err < 0) {
 		rswitch_gwca_put(priv, rdev->rx_queue);
 		return err;
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index 79c8ff01021c..ee36e8e896d2 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -913,7 +913,6 @@ struct rswitch_etha {
 struct rswitch_gwca_queue {
 	int index;
 	bool dir_tx;
-	bool gptp;
 	union {
 		struct rswitch_ext_desc *tx_ring;
 		struct rswitch_ext_ts_desc *rx_ring;
-- 
2.25.1


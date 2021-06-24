Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D1B3B354B
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhFXSKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbhFXSKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:10:30 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913BDC061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:08:01 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 44-20020aed30af0000b029024e8ccfcd07so7117423qtf.11
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VKCf8h/xZ9MVf2Csydsh3XQpFeXlCwvkWbdwrg3KyMU=;
        b=H4WBqDUTUlnb4munKOe3vtRerfYxMH0MpEsov5UK7AGbc/mP4WLGi4hAveZoXL2VGF
         36fzcUsEqQnn/uMpiAXkWrzaaBmTmHOU6mHXxr/yXVRBH04a2VWeM2MOvyqd3lWxdq+E
         fSldIGFwh4tgHvDKr2IGWo75BSG2/NOA9E6oeDvcj37Gv6cZdEI9T9HecDQm+xIj3def
         7qoYfwxWJSx8yfaDwX3Q1I0mNlkVZKpR6Swb1wGn1pqgIL6iB2yif8d5Xanqo83fai+6
         LBPTbvCi1FXmM63e/lXbqgZYtz3MAQeJ7k7PdaxDSkNeEn7/G8761xafvQOeMKbox5cf
         3feA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VKCf8h/xZ9MVf2Csydsh3XQpFeXlCwvkWbdwrg3KyMU=;
        b=WqynBgS52TnxsGCY4YMNZYBRnDQs6mRhbuXBals8fGTWW7h56CeCphic2KU7+7Te86
         okwpGDd0Aw1Nr1lROy+bZo4bF7wmrYCAn8vzNdxSBbd60Xr3OV0BA8cH4R18CRgeaf72
         rd9EYXGloMrbTbTLaNe0Fd745zmv6N4uj/eyTpICSLHkef6WLJhOOwN9hYk6PvoC+iYR
         FQoEJUBOJf9QGCq9LzGAUs07Xsx6EXRjkYo9nFBFRNtEn3cHgeK1BVejgY6JJ7DP7XQh
         Dbxb6tq7e/SVt5+PYFhi53kSJZ62XpNONOTNWLZOAV9DcGs7CfplvgqTm/7do1K99zI4
         Rewg==
X-Gm-Message-State: AOAM530o2SHNRldQtQKMFg76qKHKwjqBeKU0M55pdl19kAHkata6kLtf
        BJB7KAyf/9dGyrpCU8UI0GrXJbo=
X-Google-Smtp-Source: ABdhPJxn0qy75M4MjwNU7Oe33tN3kfV0H9n5G3xmPOM0eyGy7wllr/qbkNhQdzUxyIV1iHlMaft8FUc=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:ad4:4c43:: with SMTP id cs3mr6802921qvb.27.1624558080774;
 Thu, 24 Jun 2021 11:08:00 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:29 -0700
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
Message-Id: <20210624180632.3659809-14-bcf@google.com>
Mime-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 13/16] gve: DQO: Add ring allocation and initialization
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allocate the buffer and completion ring structures. Do not populate the
rings yet. That will happen in the respective rx and tx datapath
follow-on patches

Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        |   8 +-
 drivers/net/ethernet/google/gve/gve_dqo.h    |  18 ++
 drivers/net/ethernet/google/gve/gve_main.c   |  53 ++++-
 drivers/net/ethernet/google/gve/gve_rx.c     |   2 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 157 +++++++++++++++
 drivers/net/ethernet/google/gve/gve_tx.c     |   2 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 193 +++++++++++++++++++
 7 files changed, 420 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index d6bf0466ae8b..30978a15e37d 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -204,6 +204,10 @@ struct gve_rx_ring {
 	struct gve_queue_resources *q_resources; /* head and tail pointer idx */
 	dma_addr_t q_resources_bus; /* dma address for the queue resources */
 	struct u64_stats_sync statss; /* sync stats for 32bit archs */
+
+	/* head and tail of skb chain for the current packet or NULL if none */
+	struct sk_buff *skb_head;
+	struct sk_buff *skb_tail;
 };
 
 /* A TX desc ring entry */
@@ -816,14 +820,14 @@ void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
 netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev);
 bool gve_tx_poll(struct gve_notify_block *block, int budget);
 int gve_tx_alloc_rings(struct gve_priv *priv);
-void gve_tx_free_rings(struct gve_priv *priv);
+void gve_tx_free_rings_gqi(struct gve_priv *priv);
 __be32 gve_tx_load_event_counter(struct gve_priv *priv,
 				 struct gve_tx_ring *tx);
 /* rx handling */
 void gve_rx_write_doorbell(struct gve_priv *priv, struct gve_rx_ring *rx);
 bool gve_rx_poll(struct gve_notify_block *block, int budget);
 int gve_rx_alloc_rings(struct gve_priv *priv);
-void gve_rx_free_rings(struct gve_priv *priv);
+void gve_rx_free_rings_gqi(struct gve_priv *priv);
 bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 		       netdev_features_t feat);
 /* Reset */
diff --git a/drivers/net/ethernet/google/gve/gve_dqo.h b/drivers/net/ethernet/google/gve/gve_dqo.h
index cff4e6ef7bb6..9877a33ec068 100644
--- a/drivers/net/ethernet/google/gve/gve_dqo.h
+++ b/drivers/net/ethernet/google/gve/gve_dqo.h
@@ -19,6 +19,24 @@
 netdev_tx_t gve_tx_dqo(struct sk_buff *skb, struct net_device *dev);
 bool gve_tx_poll_dqo(struct gve_notify_block *block, bool do_clean);
 int gve_rx_poll_dqo(struct gve_notify_block *block, int budget);
+int gve_tx_alloc_rings_dqo(struct gve_priv *priv);
+void gve_tx_free_rings_dqo(struct gve_priv *priv);
+int gve_rx_alloc_rings_dqo(struct gve_priv *priv);
+void gve_rx_free_rings_dqo(struct gve_priv *priv);
+int gve_clean_tx_done_dqo(struct gve_priv *priv, struct gve_tx_ring *tx,
+			  struct napi_struct *napi);
+void gve_rx_post_buffers_dqo(struct gve_rx_ring *rx);
+void gve_rx_write_doorbell_dqo(const struct gve_priv *priv, int queue_idx);
+
+static inline void
+gve_tx_put_doorbell_dqo(const struct gve_priv *priv,
+			const struct gve_queue_resources *q_resources, u32 val)
+{
+	u64 index;
+
+	index = be32_to_cpu(q_resources->db_index);
+	iowrite32(val, &priv->db_bar2[index]);
+}
 
 static inline void
 gve_write_irq_doorbell_dqo(const struct gve_priv *priv,
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 579f867cf148..cddf19c8cf0b 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -571,13 +571,21 @@ static int gve_create_rings(struct gve_priv *priv)
 	netif_dbg(priv, drv, priv->dev, "created %d rx queues\n",
 		  priv->rx_cfg.num_queues);
 
-	/* Rx data ring has been prefilled with packet buffers at queue
-	 * allocation time.
-	 * Write the doorbell to provide descriptor slots and packet buffers
-	 * to the NIC.
-	 */
-	for (i = 0; i < priv->rx_cfg.num_queues; i++)
-		gve_rx_write_doorbell(priv, &priv->rx[i]);
+	if (gve_is_gqi(priv)) {
+		/* Rx data ring has been prefilled with packet buffers at queue
+		 * allocation time.
+		 *
+		 * Write the doorbell to provide descriptor slots and packet
+		 * buffers to the NIC.
+		 */
+		for (i = 0; i < priv->rx_cfg.num_queues; i++)
+			gve_rx_write_doorbell(priv, &priv->rx[i]);
+	} else {
+		for (i = 0; i < priv->rx_cfg.num_queues; i++) {
+			/* Post buffers and ring doorbell. */
+			gve_rx_post_buffers_dqo(&priv->rx[i]);
+		}
+	}
 
 	return 0;
 }
@@ -606,6 +614,15 @@ static void add_napi_init_sync_stats(struct gve_priv *priv,
 	}
 }
 
+static void gve_tx_free_rings(struct gve_priv *priv)
+{
+	if (gve_is_gqi(priv)) {
+		gve_tx_free_rings_gqi(priv);
+	} else {
+		gve_tx_free_rings_dqo(priv);
+	}
+}
+
 static int gve_alloc_rings(struct gve_priv *priv)
 {
 	int err;
@@ -615,9 +632,14 @@ static int gve_alloc_rings(struct gve_priv *priv)
 			    GFP_KERNEL);
 	if (!priv->tx)
 		return -ENOMEM;
-	err = gve_tx_alloc_rings(priv);
+
+	if (gve_is_gqi(priv))
+		err = gve_tx_alloc_rings(priv);
+	else
+		err = gve_tx_alloc_rings_dqo(priv);
 	if (err)
 		goto free_tx;
+
 	/* Setup rx rings */
 	priv->rx = kvzalloc(priv->rx_cfg.num_queues * sizeof(*priv->rx),
 			    GFP_KERNEL);
@@ -625,7 +647,11 @@ static int gve_alloc_rings(struct gve_priv *priv)
 		err = -ENOMEM;
 		goto free_tx_queue;
 	}
-	err = gve_rx_alloc_rings(priv);
+
+	if (gve_is_gqi(priv))
+		err = gve_rx_alloc_rings(priv);
+	else
+		err = gve_rx_alloc_rings_dqo(priv);
 	if (err)
 		goto free_rx;
 
@@ -670,6 +696,14 @@ static int gve_destroy_rings(struct gve_priv *priv)
 	return 0;
 }
 
+static inline void gve_rx_free_rings(struct gve_priv *priv)
+{
+	if (gve_is_gqi(priv))
+		gve_rx_free_rings_gqi(priv);
+	else
+		gve_rx_free_rings_dqo(priv);
+}
+
 static void gve_free_rings(struct gve_priv *priv)
 {
 	int ntfy_idx;
@@ -869,6 +903,7 @@ static int gve_open(struct net_device *dev)
 	err = gve_alloc_qpls(priv);
 	if (err)
 		return err;
+
 	err = gve_alloc_rings(priv);
 	if (err)
 		goto free_qpls;
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 15a64e40004d..bb8261368250 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -238,7 +238,7 @@ int gve_rx_alloc_rings(struct gve_priv *priv)
 	return err;
 }
 
-void gve_rx_free_rings(struct gve_priv *priv)
+void gve_rx_free_rings_gqi(struct gve_priv *priv)
 {
 	int i;
 
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 808e09741ecc..1073a820767d 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -16,6 +16,163 @@
 #include <net/ipv6.h>
 #include <net/tcp.h>
 
+static void gve_free_page_dqo(struct gve_priv *priv,
+			      struct gve_rx_buf_state_dqo *bs)
+{
+}
+
+static void gve_rx_free_ring_dqo(struct gve_priv *priv, int idx)
+{
+	struct gve_rx_ring *rx = &priv->rx[idx];
+	struct device *hdev = &priv->pdev->dev;
+	size_t completion_queue_slots;
+	size_t buffer_queue_slots;
+	size_t size;
+	int i;
+
+	completion_queue_slots = rx->dqo.complq.mask + 1;
+	buffer_queue_slots = rx->dqo.bufq.mask + 1;
+
+	gve_rx_remove_from_block(priv, idx);
+
+	if (rx->q_resources) {
+		dma_free_coherent(hdev, sizeof(*rx->q_resources),
+				  rx->q_resources, rx->q_resources_bus);
+		rx->q_resources = NULL;
+	}
+
+	for (i = 0; i < rx->dqo.num_buf_states; i++) {
+		struct gve_rx_buf_state_dqo *bs = &rx->dqo.buf_states[i];
+
+		if (bs->page_info.page)
+			gve_free_page_dqo(priv, bs);
+	}
+
+	if (rx->dqo.bufq.desc_ring) {
+		size = sizeof(rx->dqo.bufq.desc_ring[0]) * buffer_queue_slots;
+		dma_free_coherent(hdev, size, rx->dqo.bufq.desc_ring,
+				  rx->dqo.bufq.bus);
+		rx->dqo.bufq.desc_ring = NULL;
+	}
+
+	if (rx->dqo.complq.desc_ring) {
+		size = sizeof(rx->dqo.complq.desc_ring[0]) *
+			completion_queue_slots;
+		dma_free_coherent(hdev, size, rx->dqo.complq.desc_ring,
+				  rx->dqo.complq.bus);
+		rx->dqo.complq.desc_ring = NULL;
+	}
+
+	kvfree(rx->dqo.buf_states);
+	rx->dqo.buf_states = NULL;
+
+	netif_dbg(priv, drv, priv->dev, "freed rx ring %d\n", idx);
+}
+
+static int gve_rx_alloc_ring_dqo(struct gve_priv *priv, int idx)
+{
+	struct gve_rx_ring *rx = &priv->rx[idx];
+	struct device *hdev = &priv->pdev->dev;
+	size_t size;
+	int i;
+
+	const u32 buffer_queue_slots =
+		priv->options_dqo_rda.rx_buff_ring_entries;
+	const u32 completion_queue_slots = priv->rx_desc_cnt;
+
+	netif_dbg(priv, drv, priv->dev, "allocating rx ring DQO\n");
+
+	memset(rx, 0, sizeof(*rx));
+	rx->gve = priv;
+	rx->q_num = idx;
+	rx->dqo.bufq.mask = buffer_queue_slots - 1;
+	rx->dqo.complq.num_free_slots = completion_queue_slots;
+	rx->dqo.complq.mask = completion_queue_slots - 1;
+	rx->skb_head = NULL;
+	rx->skb_tail = NULL;
+
+	rx->dqo.num_buf_states = min_t(s16, S16_MAX, buffer_queue_slots * 4);
+	rx->dqo.buf_states = kvcalloc(rx->dqo.num_buf_states,
+				      sizeof(rx->dqo.buf_states[0]),
+				      GFP_KERNEL);
+	if (!rx->dqo.buf_states)
+		return -ENOMEM;
+
+	/* Set up linked list of buffer IDs */
+	for (i = 0; i < rx->dqo.num_buf_states - 1; i++)
+		rx->dqo.buf_states[i].next = i + 1;
+
+	rx->dqo.buf_states[rx->dqo.num_buf_states - 1].next = -1;
+	rx->dqo.recycled_buf_states.head = -1;
+	rx->dqo.recycled_buf_states.tail = -1;
+	rx->dqo.used_buf_states.head = -1;
+	rx->dqo.used_buf_states.tail = -1;
+
+	/* Allocate RX completion queue */
+	size = sizeof(rx->dqo.complq.desc_ring[0]) *
+		completion_queue_slots;
+	rx->dqo.complq.desc_ring =
+		dma_alloc_coherent(hdev, size, &rx->dqo.complq.bus, GFP_KERNEL);
+	if (!rx->dqo.complq.desc_ring)
+		goto err;
+
+	/* Allocate RX buffer queue */
+	size = sizeof(rx->dqo.bufq.desc_ring[0]) * buffer_queue_slots;
+	rx->dqo.bufq.desc_ring =
+		dma_alloc_coherent(hdev, size, &rx->dqo.bufq.bus, GFP_KERNEL);
+	if (!rx->dqo.bufq.desc_ring)
+		goto err;
+
+	rx->q_resources = dma_alloc_coherent(hdev, sizeof(*rx->q_resources),
+					     &rx->q_resources_bus, GFP_KERNEL);
+	if (!rx->q_resources)
+		goto err;
+
+	gve_rx_add_to_block(priv, idx);
+
+	return 0;
+
+err:
+	gve_rx_free_ring_dqo(priv, idx);
+	return -ENOMEM;
+}
+
+int gve_rx_alloc_rings_dqo(struct gve_priv *priv)
+{
+	int err = 0;
+	int i;
+
+	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
+		err = gve_rx_alloc_ring_dqo(priv, i);
+		if (err) {
+			netif_err(priv, drv, priv->dev,
+				  "Failed to alloc rx ring=%d: err=%d\n",
+				  i, err);
+			goto err;
+		}
+	}
+
+	return 0;
+
+err:
+	for (i--; i >= 0; i--)
+		gve_rx_free_ring_dqo(priv, i);
+
+	return err;
+}
+
+void gve_rx_free_rings_dqo(struct gve_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->rx_cfg.num_queues; i++)
+		gve_rx_free_ring_dqo(priv, i);
+}
+
+void gve_rx_post_buffers_dqo(struct gve_rx_ring *rx)
+{
+}
+
 int gve_rx_poll_dqo(struct gve_notify_block *block, int budget)
 {
 	u32 work_done = 0;
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 75930bb64eb9..665ac795a1ad 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -256,7 +256,7 @@ int gve_tx_alloc_rings(struct gve_priv *priv)
 	return err;
 }
 
-void gve_tx_free_rings(struct gve_priv *priv)
+void gve_tx_free_rings_gqi(struct gve_priv *priv)
 {
 	int i;
 
diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index 4b3319a1b299..bde8f90ac8bd 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -12,11 +12,204 @@
 #include <linux/slab.h>
 #include <linux/skbuff.h>
 
+/* gve_tx_free_desc - Cleans up all pending tx requests and buffers.
+ */
+static void gve_tx_clean_pending_packets(struct gve_tx_ring *tx)
+{
+	int i;
+
+	for (i = 0; i < tx->dqo.num_pending_packets; i++) {
+		struct gve_tx_pending_packet_dqo *cur_state =
+			&tx->dqo.pending_packets[i];
+		int j;
+
+		for (j = 0; j < cur_state->num_bufs; j++) {
+			struct gve_tx_dma_buf *buf = &cur_state->bufs[j];
+
+			if (j == 0) {
+				dma_unmap_single(tx->dev,
+						 dma_unmap_addr(buf, dma),
+						 dma_unmap_len(buf, len),
+						 DMA_TO_DEVICE);
+			} else {
+				dma_unmap_page(tx->dev,
+					       dma_unmap_addr(buf, dma),
+					       dma_unmap_len(buf, len),
+					       DMA_TO_DEVICE);
+			}
+		}
+		if (cur_state->skb) {
+			dev_consume_skb_any(cur_state->skb);
+			cur_state->skb = NULL;
+		}
+	}
+}
+
+static void gve_tx_free_ring_dqo(struct gve_priv *priv, int idx)
+{
+	struct gve_tx_ring *tx = &priv->tx[idx];
+	struct device *hdev = &priv->pdev->dev;
+	size_t bytes;
+
+	gve_tx_remove_from_block(priv, idx);
+
+	if (tx->q_resources) {
+		dma_free_coherent(hdev, sizeof(*tx->q_resources),
+				  tx->q_resources, tx->q_resources_bus);
+		tx->q_resources = NULL;
+	}
+
+	if (tx->dqo.compl_ring) {
+		bytes = sizeof(tx->dqo.compl_ring[0]) *
+			(tx->dqo.complq_mask + 1);
+		dma_free_coherent(hdev, bytes, tx->dqo.compl_ring,
+				  tx->complq_bus_dqo);
+		tx->dqo.compl_ring = NULL;
+	}
+
+	if (tx->dqo.tx_ring) {
+		bytes = sizeof(tx->dqo.tx_ring[0]) * (tx->mask + 1);
+		dma_free_coherent(hdev, bytes, tx->dqo.tx_ring, tx->bus);
+		tx->dqo.tx_ring = NULL;
+	}
+
+	kvfree(tx->dqo.pending_packets);
+	tx->dqo.pending_packets = NULL;
+
+	netif_dbg(priv, drv, priv->dev, "freed tx queue %d\n", idx);
+}
+
+static int gve_tx_alloc_ring_dqo(struct gve_priv *priv, int idx)
+{
+	struct gve_tx_ring *tx = &priv->tx[idx];
+	struct device *hdev = &priv->pdev->dev;
+	int num_pending_packets;
+	size_t bytes;
+	int i;
+
+	memset(tx, 0, sizeof(*tx));
+	tx->q_num = idx;
+	tx->dev = &priv->pdev->dev;
+	tx->netdev_txq = netdev_get_tx_queue(priv->dev, idx);
+	atomic_set_release(&tx->dqo_compl.hw_tx_head, 0);
+
+	/* Queue sizes must be a power of 2 */
+	tx->mask = priv->tx_desc_cnt - 1;
+	tx->dqo.complq_mask = priv->options_dqo_rda.tx_comp_ring_entries - 1;
+
+	/* The max number of pending packets determines the maximum number of
+	 * descriptors which maybe written to the completion queue.
+	 *
+	 * We must set the number small enough to make sure we never overrun the
+	 * completion queue.
+	 */
+	num_pending_packets = tx->dqo.complq_mask + 1;
+
+	/* Reserve space for descriptor completions, which will be reported at
+	 * most every GVE_TX_MIN_RE_INTERVAL packets.
+	 */
+	num_pending_packets -=
+		(tx->dqo.complq_mask + 1) / GVE_TX_MIN_RE_INTERVAL;
+
+	/* Each packet may have at most 2 buffer completions if it receives both
+	 * a miss and reinjection completion.
+	 */
+	num_pending_packets /= 2;
+
+	tx->dqo.num_pending_packets = min_t(int, num_pending_packets, S16_MAX);
+	tx->dqo.pending_packets = kvcalloc(tx->dqo.num_pending_packets,
+					   sizeof(tx->dqo.pending_packets[0]),
+					   GFP_KERNEL);
+	if (!tx->dqo.pending_packets)
+		goto err;
+
+	/* Set up linked list of pending packets */
+	for (i = 0; i < tx->dqo.num_pending_packets - 1; i++)
+		tx->dqo.pending_packets[i].next = i + 1;
+
+	tx->dqo.pending_packets[tx->dqo.num_pending_packets - 1].next = -1;
+	atomic_set_release(&tx->dqo_compl.free_pending_packets, -1);
+	tx->dqo_compl.miss_completions.head = -1;
+	tx->dqo_compl.miss_completions.tail = -1;
+	tx->dqo_compl.timed_out_completions.head = -1;
+	tx->dqo_compl.timed_out_completions.tail = -1;
+
+	bytes = sizeof(tx->dqo.tx_ring[0]) * (tx->mask + 1);
+	tx->dqo.tx_ring = dma_alloc_coherent(hdev, bytes, &tx->bus, GFP_KERNEL);
+	if (!tx->dqo.tx_ring)
+		goto err;
+
+	bytes = sizeof(tx->dqo.compl_ring[0]) * (tx->dqo.complq_mask + 1);
+	tx->dqo.compl_ring = dma_alloc_coherent(hdev, bytes,
+						&tx->complq_bus_dqo,
+						GFP_KERNEL);
+	if (!tx->dqo.compl_ring)
+		goto err;
+
+	tx->q_resources = dma_alloc_coherent(hdev, sizeof(*tx->q_resources),
+					     &tx->q_resources_bus, GFP_KERNEL);
+	if (!tx->q_resources)
+		goto err;
+
+	gve_tx_add_to_block(priv, idx);
+
+	return 0;
+
+err:
+	gve_tx_free_ring_dqo(priv, idx);
+	return -ENOMEM;
+}
+
+int gve_tx_alloc_rings_dqo(struct gve_priv *priv)
+{
+	int err = 0;
+	int i;
+
+	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
+		err = gve_tx_alloc_ring_dqo(priv, i);
+		if (err) {
+			netif_err(priv, drv, priv->dev,
+				  "Failed to alloc tx ring=%d: err=%d\n",
+				  i, err);
+			goto err;
+		}
+	}
+
+	return 0;
+
+err:
+	for (i--; i >= 0; i--)
+		gve_tx_free_ring_dqo(priv, i);
+
+	return err;
+}
+
+void gve_tx_free_rings_dqo(struct gve_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
+		struct gve_tx_ring *tx = &priv->tx[i];
+
+		gve_clean_tx_done_dqo(priv, tx, /*napi=*/NULL);
+		netdev_tx_reset_queue(tx->netdev_txq);
+		gve_tx_clean_pending_packets(tx);
+
+		gve_tx_free_ring_dqo(priv, i);
+	}
+}
+
 netdev_tx_t gve_tx_dqo(struct sk_buff *skb, struct net_device *dev)
 {
 	return NETDEV_TX_OK;
 }
 
+int gve_clean_tx_done_dqo(struct gve_priv *priv, struct gve_tx_ring *tx,
+			  struct napi_struct *napi)
+{
+	return 0;
+}
+
 bool gve_tx_poll_dqo(struct gve_notify_block *block, bool do_clean)
 {
 	return false;
-- 
2.32.0.288.g62a8d224e6-goog


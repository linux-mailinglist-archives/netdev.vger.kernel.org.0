Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35ABE2703B9
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgIRSH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIRSH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 14:07:28 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2285DC0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 11:07:28 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 7so5723462qtp.18
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 11:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=TRf6yXWMUrW2wU9jZPjfANZHoMcBLdj4ZkjmBYeugEg=;
        b=DQspYj2BMuLDCekvwgikVGswDVdYF0ig0sfRFBhbEVeR/7WUw7a8GBUWUM79D9ofiJ
         zK8Zkf2VsxaZKTnOrhRRIZTEFeXCqmr+YZMlt8zRC5lAQrsr7uOHtCq26x/Tgyat8J75
         /nGrIny+MUKhMV0MS0pFrcqvUklgo0c6K0sEqDJNEZ0c/y9LXLYeOFI9dQ4hcUa6X3BS
         ORcGlaRQ7twSOBWH+ulC3RERSvFxXi/44+LK1W4PKQWaHV7HWBkGy5cSrF2IQIgmoXqm
         B5azfBuD9WbHBBe0E5heCagBSG17x5PTnJ1+sHvZB3Oj9XnFbo3qoD9BoOL6p8/VIOJg
         EaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TRf6yXWMUrW2wU9jZPjfANZHoMcBLdj4ZkjmBYeugEg=;
        b=E5kQn1kXjRVQMZuNjvcGLSf5yOV3c98RT8FKpxHO17WCtapTRn5pDXuw4WmZE+OrIm
         25nOWxD24FNZ8NUGEw3Cphg4tc0H+dctUUkVuPzzIUBqyqHPwC8ClkC7Fh4NvFpIdMcA
         ToIFGH1DNo8A3DPKSbxZEZl/z0XIfYMgont8dMEZ0/e9Zpsr0b5b82vghSmTxf5VgrHO
         9Yo5o92bpo2+Qh9Y1C2zzU8nQ1jY2FpV6YYehtDJIxat3gwRuZfP6C9wmeoViZG5nXvv
         t5Q/guXjJ7UEM+sTsPMrjJh/11VtV95YIq8UhcTgPvXSFKMcBcpnulYZzmlGmT9jPIZj
         E4PQ==
X-Gm-Message-State: AOAM533EgQnQ0NgRPBBdF2pXdAeM9Op/YOHen+vDcK/6iICqhDQIDZFA
        EHBI0J1GgnsvIgMKUo+SSgIPpKkBuGK/sioxr9S8uvpOatfw6ddqmG1H5icfSo8idVwRteFlGNe
        Hd+lPXy0IKiEdCrBF3KU+vOZYZj2eIiQhxTH1TB1NZc7jJ/RUIqYwmrOB6s5vaKjDaaT51HkO
X-Google-Smtp-Source: ABdhPJzhMTAt2SAlqfMz8MaU9KeRp/pYy+ZL7aM46REqixuUWFijwXbm7/YJgLG5pj7qdAJ1y61JvkZ09IvKsLSj
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:ad4:47cc:: with SMTP id
 p12mr34642281qvw.26.1600452447121; Fri, 18 Sep 2020 11:07:27 -0700 (PDT)
Date:   Fri, 18 Sep 2020 11:07:19 -0700
In-Reply-To: <20200918180720.2080407-1-awogbemila@google.com>
Message-Id: <20200918180720.2080407-3-awogbemila@google.com>
Mime-Version: 1.0
References: <20200918180720.2080407-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 2/3] gve: Add support for raw addressing to the rx path
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Add support to use raw dma addresses in the rx path. Due to this new
support we can alloc a new buffer instead of making a copy.

RX buffers are handed to the networking stack and are then recycled or
re-allocated as needed, avoiding the need to use
skb_copy_to_linear_data() as in "qpl" mode.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        |  21 +-
 drivers/net/ethernet/google/gve/gve_adminq.c |  14 +-
 drivers/net/ethernet/google/gve/gve_desc.h   |  10 +-
 drivers/net/ethernet/google/gve/gve_main.c   |   3 +-
 drivers/net/ethernet/google/gve/gve_rx.c     | 342 ++++++++++++++-----
 5 files changed, 290 insertions(+), 100 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 80cdae06ee39..94e37193c389 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -50,6 +50,7 @@ struct gve_rx_slot_page_info {
 	struct page *page;
 	void *page_address;
 	u32 page_offset; /* offset to write to in page */
+	bool can_flip; /* page can be flipped and reused */
 };
 
 /* A list of pages registered with the device during setup and used by a queue
@@ -68,6 +69,7 @@ struct gve_rx_data_queue {
 	dma_addr_t data_bus; /* dma mapping of the slots */
 	struct gve_rx_slot_page_info *page_info; /* page info of the buffers */
 	struct gve_queue_page_list *qpl; /* qpl assigned to this queue */
+	bool raw_addressing; /* use raw_addressing? */
 };
 
 struct gve_priv;
@@ -82,11 +84,14 @@ struct gve_rx_ring {
 	u32 cnt; /* free-running total number of completed packets */
 	u32 fill_cnt; /* free-running total number of descs and buffs posted */
 	u32 mask; /* masks the cnt and fill_cnt to the size of the ring */
+	u32 db_threshold; /* threshold for posting new buffs and descs */
 	u64 rx_copybreak_pkt; /* free-running count of copybreak packets */
 	u64 rx_copied_pkt; /* free-running total number of copied packets */
 	u64 rx_skb_alloc_fail; /* free-running count of skb alloc fails */
 	u64 rx_buf_alloc_fail; /* free-running count of buffer alloc fails */
 	u64 rx_desc_err_dropped_pkt; /* free-running count of packets dropped by descriptor error */
+	/* free-running count of packets dropped because of lack of buffer refill */
+	u64 rx_no_refill_dropped_pkt;
 	u32 q_num; /* queue index */
 	u32 ntfy_id; /* notification block index */
 	struct gve_queue_resources *q_resources; /* head and tail pointer idx */
@@ -194,7 +199,7 @@ struct gve_priv {
 	u16 tx_desc_cnt; /* num desc per ring */
 	u16 rx_desc_cnt; /* num desc per ring */
 	u16 tx_pages_per_qpl; /* tx buffer length */
-	u16 rx_pages_per_qpl; /* rx buffer length */
+	u16 rx_data_slot_cnt; /* rx buffer length */
 	u64 max_registered_pages;
 	u64 num_registered_pages; /* num pages registered with NIC */
 	u32 rx_copybreak; /* copy packets smaller than this */
@@ -444,7 +449,10 @@ static inline u32 gve_num_tx_qpls(struct gve_priv *priv)
  */
 static inline u32 gve_num_rx_qpls(struct gve_priv *priv)
 {
-	return priv->rx_cfg.num_queues;
+	if (priv->raw_addressing)
+		return 0;
+	else
+		return priv->rx_cfg.num_queues;
 }
 
 /* Returns a pointer to the next available tx qpl in the list of qpls
@@ -498,15 +506,6 @@ static inline enum dma_data_direction gve_qpl_dma_dir(struct gve_priv *priv,
 		return DMA_FROM_DEVICE;
 }
 
-/* Returns true if the max mtu allows page recycling */
-static inline bool gve_can_recycle_pages(struct net_device *dev)
-{
-	/* We can't recycle the pages if we can't fit a packet into half a
-	 * page.
-	 */
-	return dev->max_mtu <= PAGE_SIZE / 2;
-}
-
 /* buffers */
 int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 		   struct page **page, dma_addr_t *dma,
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index b79958e37a30..858ed2ffe60d 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -357,8 +357,10 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 {
 	struct gve_rx_ring *rx = &priv->rx[queue_index];
 	union gve_adminq_command cmd;
+	u32 qpl_id;
 	int err;
 
+	qpl_id = priv->raw_addressing ? GVE_RAW_ADDRESSING_QPL_ID : rx->data.qpl->id;
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_RX_QUEUE);
 	cmd.create_rx_queue = (struct gve_adminq_create_rx_queue) {
@@ -369,7 +371,7 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 		.queue_resources_addr = cpu_to_be64(rx->q_resources_bus),
 		.rx_desc_ring_addr = cpu_to_be64(rx->desc.bus),
 		.rx_data_ring_addr = cpu_to_be64(rx->data.data_bus),
-		.queue_page_list_id = cpu_to_be32(rx->data.qpl->id),
+		.queue_page_list_id = cpu_to_be32(qpl_id),
 	};
 
 	err = gve_adminq_issue_cmd(priv, &cmd);
@@ -514,11 +516,11 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	mac = descriptor->mac;
 	dev_info(&priv->pdev->dev, "MAC addr: %pM\n", mac);
 	priv->tx_pages_per_qpl = be16_to_cpu(descriptor->tx_pages_per_qpl);
-	priv->rx_pages_per_qpl = be16_to_cpu(descriptor->rx_pages_per_qpl);
-	if (priv->rx_pages_per_qpl < priv->rx_desc_cnt) {
-		dev_err(&priv->pdev->dev, "rx_pages_per_qpl cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
-			  priv->rx_pages_per_qpl);
-		priv->rx_desc_cnt = priv->rx_pages_per_qpl;
+	priv->rx_data_slot_cnt = be16_to_cpu(descriptor->rx_pages_per_qpl);
+	if (priv->rx_data_slot_cnt < priv->rx_desc_cnt) {
+		dev_err(&priv->pdev->dev, "rx_data_slot_cnt cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
+			priv->rx_data_slot_cnt);
+		priv->rx_desc_cnt = priv->rx_data_slot_cnt;
 	}
 	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
 	dev_opt = (struct gve_device_option *)((void *)descriptor +
diff --git a/drivers/net/ethernet/google/gve/gve_desc.h b/drivers/net/ethernet/google/gve/gve_desc.h
index 54779871d52e..0aad314aefaf 100644
--- a/drivers/net/ethernet/google/gve/gve_desc.h
+++ b/drivers/net/ethernet/google/gve/gve_desc.h
@@ -72,12 +72,14 @@ struct gve_rx_desc {
 } __packed;
 static_assert(sizeof(struct gve_rx_desc) == 64);
 
-/* As with the Tx ring format, the qpl_offset entries below are offsets into an
- * ordered list of registered pages.
+/* If the device supports raw dma addressing then the addr in data slot is
+ * the dma address of the buffer.
+ * If the device only supports registered segments than the addr is a byte
+ * offset into the registered segment (an ordered list of pages) where the
+ * buffer is.
  */
 struct gve_rx_data_slot {
-	/* byte offset into the rx registered segment of this slot */
-	__be64 qpl_offset;
+	__be64 addr;
 };
 
 /* GVE Recive Packet Descriptor Seq No */
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 70685c10db0e..225e17dd1ae5 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -596,6 +596,7 @@ int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 	if (dma_mapping_error(dev, *dma)) {
 		priv->dma_mapping_error++;
 		put_page(*page);
+		*page = NULL;
 		return -ENOMEM;
 	}
 	return 0;
@@ -694,7 +695,7 @@ static int gve_alloc_qpls(struct gve_priv *priv)
 	}
 	for (; i < num_qpls; i++) {
 		err = gve_alloc_queue_page_list(priv, i,
-						priv->rx_pages_per_qpl);
+						priv->rx_data_slot_cnt);
 		if (err)
 			goto free_qpls;
 	}
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 008fa897a3e6..60eba64f29d8 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -16,12 +16,22 @@ static void gve_rx_remove_from_block(struct gve_priv *priv, int queue_idx)
 	block->rx = NULL;
 }
 
+static void gve_rx_free_buffer(struct device *dev,
+			       struct gve_rx_slot_page_info *page_info,
+			       struct gve_rx_data_slot *data_slot)
+{
+	dma_addr_t dma = (dma_addr_t)(be64_to_cpu(data_slot->addr) -
+				      page_info->page_offset);
+
+	gve_free_page(dev, page_info->page, dma, DMA_FROM_DEVICE);
+}
+
 static void gve_rx_free_ring(struct gve_priv *priv, int idx)
 {
 	struct gve_rx_ring *rx = &priv->rx[idx];
 	struct device *dev = &priv->pdev->dev;
+	u32 slots = rx->mask + 1;
 	size_t bytes;
-	u32 slots;
 
 	gve_rx_remove_from_block(priv, idx);
 
@@ -33,11 +43,18 @@ static void gve_rx_free_ring(struct gve_priv *priv, int idx)
 			  rx->q_resources, rx->q_resources_bus);
 	rx->q_resources = NULL;
 
-	gve_unassign_qpl(priv, rx->data.qpl->id);
-	rx->data.qpl = NULL;
+	if (rx->data.raw_addressing) {
+		int i;
+
+		for (i = 0; i < slots; i++)
+			gve_rx_free_buffer(dev, &rx->data.page_info[i],
+					   &rx->data.data_ring[i]);
+	} else {
+		gve_unassign_qpl(priv, rx->data.qpl->id);
+		rx->data.qpl = NULL;
+	}
 	kvfree(rx->data.page_info);
 
-	slots = rx->mask + 1;
 	bytes = sizeof(*rx->data.data_ring) * slots;
 	dma_free_coherent(dev, bytes, rx->data.data_ring,
 			  rx->data.data_bus);
@@ -52,13 +69,14 @@ static void gve_setup_rx_buffer(struct gve_rx_slot_page_info *page_info,
 	page_info->page = page;
 	page_info->page_offset = 0;
 	page_info->page_address = page_address(page);
-	slot->qpl_offset = cpu_to_be64(addr);
+	slot->addr = cpu_to_be64(addr);
 }
 
 static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
 {
 	struct gve_priv *priv = rx->gve;
 	u32 slots;
+	int err;
 	int i;
 
 	/* Allocate one page per Rx queue slot. Each page is split into two
@@ -71,12 +89,30 @@ static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
 	if (!rx->data.page_info)
 		return -ENOMEM;
 
-	rx->data.qpl = gve_assign_rx_qpl(priv);
-
+	if (!rx->data.raw_addressing)
+		rx->data.qpl = gve_assign_rx_qpl(priv);
 	for (i = 0; i < slots; i++) {
-		struct page *page = rx->data.qpl->pages[i];
-		dma_addr_t addr = i * PAGE_SIZE;
+		struct page *page;
+		dma_addr_t addr;
+
+		if (rx->data.raw_addressing) {
+			err = gve_alloc_page(priv, &priv->pdev->dev, &page,
+					     &addr, DMA_FROM_DEVICE);
+			if (err) {
+				int j;
 
+				u64_stats_update_begin(&rx->statss);
+				rx->rx_buf_alloc_fail++;
+				u64_stats_update_end(&rx->statss);
+				for (j = 0; j < i; j++)
+					gve_free_page(&priv->pdev->dev, page,
+						      addr, DMA_FROM_DEVICE);
+				return err;
+			}
+		} else {
+			page = rx->data.qpl->pages[i];
+			addr = i * PAGE_SIZE;
+		}
 		gve_setup_rx_buffer(&rx->data.page_info[i],
 				    &rx->data.data_ring[i], addr, page);
 	}
@@ -110,8 +146,9 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 	rx->gve = priv;
 	rx->q_num = idx;
 
-	slots = priv->rx_pages_per_qpl;
+	slots = priv->rx_data_slot_cnt;
 	rx->mask = slots - 1;
+	rx->data.raw_addressing = priv->raw_addressing;
 
 	/* alloc rx data ring */
 	bytes = sizeof(*rx->data.data_ring) * slots;
@@ -156,8 +193,8 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 		err = -ENOMEM;
 		goto abort_with_q_resources;
 	}
-	rx->mask = slots - 1;
 	rx->cnt = 0;
+	rx->db_threshold = priv->rx_desc_cnt / 2;
 	rx->desc.seqno = 1;
 	gve_rx_add_to_block(priv, idx);
 
@@ -225,8 +262,7 @@ static enum pkt_hash_types gve_rss_type(__be16 pkt_flags)
 	return PKT_HASH_TYPE_L2;
 }
 
-static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
-				   struct net_device *dev,
+static struct sk_buff *gve_rx_copy(struct net_device *dev,
 				   struct napi_struct *napi,
 				   struct gve_rx_slot_page_info *page_info,
 				   u16 len)
@@ -244,15 +280,10 @@ static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
 
 	skb->protocol = eth_type_trans(skb, dev);
 
-	u64_stats_update_begin(&rx->statss);
-	rx->rx_copied_pkt++;
-	u64_stats_update_end(&rx->statss);
-
 	return skb;
 }
 
-static struct sk_buff *gve_rx_add_frags(struct net_device *dev,
-					struct napi_struct *napi,
+static struct sk_buff *gve_rx_add_frags(struct napi_struct *napi,
 					struct gve_rx_slot_page_info *page_info,
 					u16 len)
 {
@@ -268,14 +299,118 @@ static struct sk_buff *gve_rx_add_frags(struct net_device *dev,
 	return skb;
 }
 
-static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info,
-			     struct gve_rx_data_slot *data_ring)
+static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
+			       struct gve_rx_slot_page_info *page_info,
+			       struct gve_rx_data_slot *data_slot,
+			       struct gve_rx_ring *rx)
+{
+	struct page *page;
+	dma_addr_t dma;
+	int err;
+
+	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE);
+	if (err) {
+		u64_stats_update_begin(&rx->statss);
+		rx->rx_buf_alloc_fail++;
+		u64_stats_update_end(&rx->statss);
+		return err;
+	}
+
+	gve_setup_rx_buffer(page_info, data_slot, dma, page);
+	return 0;
+}
+
+static void gve_rx_flip_buffer(struct gve_rx_slot_page_info *page_info,
+			       struct gve_rx_data_slot *data_slot)
 {
-	u64 addr = be64_to_cpu(data_ring->qpl_offset);
+	u64 addr = be64_to_cpu(data_slot->addr);
 
+	/* "flip" to other packet buffer on this page */
 	page_info->page_offset ^= PAGE_SIZE / 2;
 	addr ^= PAGE_SIZE / 2;
-	data_ring->qpl_offset = cpu_to_be64(addr);
+	data_slot->addr = cpu_to_be64(addr);
+}
+
+static bool gve_rx_can_flip_buffers(struct net_device *netdev)
+{
+#if PAGE_SIZE == 4096
+	/* We can't flip a buffer if we can't fit a packet
+	 * into half a page.
+	 */
+	if (netdev->max_mtu + GVE_RX_PAD + ETH_HLEN  > PAGE_SIZE / 2)
+		return false;
+	return true;
+#else
+	/* PAGE_SIZE != 4096 - don't try to reuse */
+	return false;
+#endif
+}
+
+static int gve_rx_can_recycle_buffer(struct page *page)
+{
+	int pagecount = page_count(page);
+
+	/* This page is not being used by any SKBs - reuse */
+	if (pagecount == 1) {
+		return 1;
+	/* This page is still being used by an SKB - we can't reuse */
+	} else if (pagecount >= 2) {
+		return 0;
+	}
+	WARN(pagecount < 1, "Pagecount should never be < 1");
+	return -1;
+}
+
+static struct sk_buff *
+gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
+		      struct gve_rx_slot_page_info *page_info, u16 len,
+		      struct napi_struct *napi,
+		      struct gve_rx_data_slot *data_slot, bool can_flip)
+{
+	struct sk_buff *skb = gve_rx_add_frags(napi, page_info, len);
+
+	if (!skb)
+		return NULL;
+
+	/* Optimistically stop the kernel from freeing the page by increasing
+	 * the page bias. We will check the refcount in refill to determine if
+	 * we need to alloc a new page.
+	 */
+	get_page(page_info->page);
+	page_info->can_flip = can_flip;
+
+	return skb;
+}
+
+static struct sk_buff *
+gve_rx_qpl(struct device *dev, struct net_device *netdev,
+	   struct gve_rx_ring *rx, struct gve_rx_slot_page_info *page_info,
+	   u16 len, struct napi_struct *napi,
+	   struct gve_rx_data_slot *data_slot, bool recycle)
+{
+	struct sk_buff *skb;
+	/* if raw_addressing mode is not enabled gvnic can only receive into
+	 * registered segments. If the buffer can't be recycled, our only
+	 * choice is to copy the data out of it so that we can return it to the
+	 * device.
+	 */
+	if (recycle) {
+		skb = gve_rx_add_frags(napi, page_info, len);
+		/* No point in recycling if we didn't get the skb */
+		if (skb) {
+			/* Make sure the networking stack can't free the page */
+			get_page(page_info->page);
+			gve_rx_flip_buffer(page_info, data_slot);
+		}
+	} else {
+		skb = gve_rx_copy(netdev, napi, page_info, len);
+		if (skb) {
+			u64_stats_update_begin(&rx->statss);
+			rx->rx_copied_pkt++;
+			u64_stats_update_end(&rx->statss);
+		}
+	}
+	return skb;
 }
 
 static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
@@ -284,9 +419,10 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	struct gve_rx_slot_page_info *page_info;
 	struct gve_priv *priv = rx->gve;
 	struct napi_struct *napi = &priv->ntfy_blocks[rx->ntfy_id].napi;
-	struct net_device *dev = priv->dev;
-	struct sk_buff *skb;
-	int pagecount;
+	struct net_device *netdev = priv->dev;
+	struct gve_rx_data_slot *data_slot;
+	struct sk_buff *skb = NULL;
+	dma_addr_t page_bus;
 	u16 len;
 
 	/* drop this packet */
@@ -294,71 +430,56 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 		u64_stats_update_begin(&rx->statss);
 		rx->rx_desc_err_dropped_pkt++;
 		u64_stats_update_end(&rx->statss);
-		return true;
+		return false;
 	}
 
 	len = be16_to_cpu(rx_desc->len) - GVE_RX_PAD;
 	page_info = &rx->data.page_info[idx];
-	dma_sync_single_for_cpu(&priv->pdev->dev, rx->data.qpl->page_buses[idx],
-				PAGE_SIZE, DMA_FROM_DEVICE);
 
-	/* gvnic can only receive into registered segments. If the buffer
-	 * can't be recycled, our only choice is to copy the data out of
-	 * it so that we can return it to the device.
-	 */
+	data_slot = &rx->data.data_ring[idx];
+	page_bus = (rx->data.raw_addressing) ?
+					be64_to_cpu(data_slot->addr) - page_info->page_offset :
+					rx->data.qpl->page_buses[idx];
+	dma_sync_single_for_cpu(&priv->pdev->dev, page_bus,
+				PAGE_SIZE, DMA_FROM_DEVICE);
 
-	if (PAGE_SIZE == 4096) {
-		if (len <= priv->rx_copybreak) {
-			/* Just copy small packets */
-			skb = gve_rx_copy(rx, dev, napi, page_info, len);
+	if (len <= priv->rx_copybreak) {
+		/* Just copy small packets */
+		skb = gve_rx_copy(netdev, napi, page_info, len);
+		if (skb) {
 			u64_stats_update_begin(&rx->statss);
+			rx->rx_copied_pkt++;
 			rx->rx_copybreak_pkt++;
 			u64_stats_update_end(&rx->statss);
-			goto have_skb;
 		}
-		if (unlikely(!gve_can_recycle_pages(dev))) {
-			skb = gve_rx_copy(rx, dev, napi, page_info, len);
-			goto have_skb;
-		}
-		pagecount = page_count(page_info->page);
-		if (pagecount == 1) {
-			/* No part of this page is used by any SKBs; we attach
-			 * the page fragment to a new SKB and pass it up the
-			 * stack.
-			 */
-			skb = gve_rx_add_frags(dev, napi, page_info, len);
-			if (!skb) {
-				u64_stats_update_begin(&rx->statss);
-				rx->rx_skb_alloc_fail++;
-				u64_stats_update_end(&rx->statss);
-				return true;
+	} else {
+		bool can_flip = gve_rx_can_flip_buffers(netdev);
+		int recycle = 0;
+
+		if (can_flip) {
+			recycle = gve_rx_can_recycle_buffer(page_info->page);
+			if (recycle < 0) {
+				gve_schedule_reset(priv);
+				return false;
 			}
-			/* Make sure the kernel stack can't release the page */
-			get_page(page_info->page);
-			/* "flip" to other packet buffer on this page */
-			gve_rx_flip_buff(page_info, &rx->data.data_ring[idx]);
-		} else if (pagecount >= 2) {
-			/* We have previously passed the other half of this
-			 * page up the stack, but it has not yet been freed.
-			 */
-			skb = gve_rx_copy(rx, dev, napi, page_info, len);
+		}
+		if (rx->data.raw_addressing) {
+			skb = gve_rx_raw_addressing(&priv->pdev->dev, netdev,
+						    page_info, len, napi,
+						    data_slot,
+						    can_flip && recycle);
 		} else {
-			WARN(pagecount < 1, "Pagecount should never be < 1");
-			return false;
+			skb = gve_rx_qpl(&priv->pdev->dev, netdev, rx,
+					 page_info, len, napi, data_slot,
+					 can_flip && recycle);
 		}
-	} else {
-		skb = gve_rx_copy(rx, dev, napi, page_info, len);
 	}
 
-have_skb:
-	/* We didn't manage to allocate an skb but we haven't had any
-	 * reset worthy failures.
-	 */
 	if (!skb) {
 		u64_stats_update_begin(&rx->statss);
 		rx->rx_skb_alloc_fail++;
 		u64_stats_update_end(&rx->statss);
-		return true;
+		return false;
 	}
 
 	if (likely(feat & NETIF_F_RXCSUM)) {
@@ -399,19 +520,72 @@ static bool gve_rx_work_pending(struct gve_rx_ring *rx)
 	return (GVE_SEQNO(flags_seq) == rx->desc.seqno);
 }
 
+static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
+{
+	u32 fill_cnt = rx->fill_cnt;
+
+	while ((fill_cnt & rx->mask) != (rx->cnt & rx->mask)) {
+		u32 idx = fill_cnt & rx->mask;
+		struct gve_rx_slot_page_info *page_info =
+						&rx->data.page_info[idx];
+
+		if (page_info->can_flip) {
+			/* The other half of the page is free because it was
+			 * free when we processed the descriptor. Flip to it.
+			 */
+			struct gve_rx_data_slot *data_slot =
+						&rx->data.data_ring[idx];
+
+			gve_rx_flip_buffer(page_info, data_slot);
+			page_info->can_flip = false;
+		} else {
+			/* It is possible that the networking stack has already
+			 * finished processing all outstanding packets in the buffer
+			 * and it can be reused.
+			 * Flipping is unnecessary here - if the networking stack still
+			 * owns half the page it is impossible to tell which half. Either
+			 * the whole page is free or it needs to be replaced.
+			 */
+			int recycle = gve_rx_can_recycle_buffer(page_info->page);
+
+			if (recycle < 0) {
+				gve_schedule_reset(priv);
+				return false;
+			}
+			if (!recycle) {
+				/* We can't reuse the buffer - alloc a new one*/
+				struct gve_rx_data_slot *data_slot =
+						&rx->data.data_ring[idx];
+				struct device *dev = &priv->pdev->dev;
+
+				gve_rx_free_buffer(dev, page_info, data_slot);
+				page_info->page = NULL;
+				if (gve_rx_alloc_buffer(priv, dev, page_info,
+							data_slot, rx)) {
+					break;
+				}
+			}
+		}
+		fill_cnt++;
+	}
+	rx->fill_cnt = fill_cnt;
+	return true;
+}
+
 bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 		       netdev_features_t feat)
 {
 	struct gve_priv *priv = rx->gve;
+	u32 work_done = 0, packets = 0;
 	struct gve_rx_desc *desc;
 	u32 cnt = rx->cnt;
 	u32 idx = cnt & rx->mask;
-	u32 work_done = 0;
 	u64 bytes = 0;
 
 	desc = rx->desc.desc_ring + idx;
 	while ((GVE_SEQNO(desc->flags_seq) == rx->desc.seqno) &&
 	       work_done < budget) {
+		bool dropped;
 		netif_info(priv, rx_status, priv->dev,
 			   "[%d] idx=%d desc=%p desc->flags_seq=0x%x\n",
 			   rx->q_num, idx, desc, desc->flags_seq);
@@ -419,9 +593,11 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 			   "[%d] seqno=%d rx->desc.seqno=%d\n",
 			   rx->q_num, GVE_SEQNO(desc->flags_seq),
 			   rx->desc.seqno);
-		bytes += be16_to_cpu(desc->len) - GVE_RX_PAD;
-		if (!gve_rx(rx, desc, feat, idx))
-			gve_schedule_reset(priv);
+		dropped = !gve_rx(rx, desc, feat, idx);
+		if (!dropped) {
+			bytes += be16_to_cpu(desc->len) - GVE_RX_PAD;
+			packets++;
+		}
 		cnt++;
 		idx = cnt & rx->mask;
 		desc = rx->desc.desc_ring + idx;
@@ -433,11 +609,21 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 		return false;
 
 	u64_stats_update_begin(&rx->statss);
-	rx->rpackets += work_done;
+	rx->rpackets += packets;
 	rx->rbytes += bytes;
 	u64_stats_update_end(&rx->statss);
 	rx->cnt = cnt;
-	rx->fill_cnt += work_done;
+	/* restock ring slots */
+	if (!rx->data.raw_addressing) {
+		/* In QPL mode buffs are refilled as the desc are processed */
+		rx->fill_cnt += work_done;
+	} else if (rx->fill_cnt - cnt <= rx->db_threshold) {
+		/* In raw addressing mode buffs are only refilled if the avail
+		 * falls below a threshold.
+		 */
+		if (!gve_rx_refill_buffers(priv, rx))
+			return false;
+	}
 
 	gve_rx_write_doorbell(priv, rx);
 	return gve_rx_work_pending(rx);
-- 
2.28.0.681.g6f77f65b4e-goog


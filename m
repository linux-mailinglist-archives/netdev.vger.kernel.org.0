Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC672CC500
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 19:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbgLBSZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 13:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgLBSZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 13:25:02 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259FFC0617A7
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 10:24:22 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id v13so2798324ybe.18
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 10:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Gagdy//8MpXqBPFPZZ1spkx8hEQN+maKH6DvvnH+zXA=;
        b=NtWi7c7m1ms8FGu+620dxHWtvg+apL8z2FAOD9Q2BCLgtrL61Uh6tY4NiYrXmPpASB
         C7uja6L1/V4kBKk1Q1RTxkBc7Y00jqp3LIVJ0/AbnXSYuKQhm80sSPa8dXpJqC7b3r3Z
         J1FliphtjpCGCfN3xXU2i+EOpR4y/RwcUJdaXg36/mH9JOn9n3uRPam7KUtlR/uyeL5R
         ehCGEe0jYHjrCsoFY8kF34Ovo978l0H3PPhSE6MHDATHlVAdyR0R361hnlj8oFqwcIJE
         a47sQWWwSqm8kw7Ifi7Qk7xZ8LSwcd9pO8QrR4ggTv/Mc746hrzNQ/U0I0bVLD2IIgT0
         6gcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Gagdy//8MpXqBPFPZZ1spkx8hEQN+maKH6DvvnH+zXA=;
        b=VzNcRlTsXc3+WxL+VOiXc//cBihJL2l7ff2IgtnzdtimTKXK5C+JTcpE1xelmYU00V
         O5A+/Ma568t8E+Ww5X7OAUeaujIeGX7YFjHeEHNMBNVlg7d2IPhXugjf3XWjDF+zYtnz
         I6oRRFd2o1RBsuCZuFWoEMTHvv6HwVC/XevPB+/PUxGFoWlqgYYt7JkmTE4nXjTUnUl9
         rMQcBAN1DA1pgRMonuCahjxP8ZV3rcYOcYUnAWZuJ32yK61BkSwpiBultMI4ibiUBK6G
         ZPi8a4iBiQc+oTM53tjFwC1//HNlkkUG5s6Bm2H6vAyOntC0+6GzdsQ8YPQu6KJh16bJ
         1z+w==
X-Gm-Message-State: AOAM5305HY9HM3TLicBMXT64wp+ZYAZmuAmRaLQDjDRRNi3Hain5rRvv
        oB9iPr/tw1DsADmJ1ZnAQH1sFUy6fPN6hOs+9DVmrnq7eKpAEQSa4cL4G0xKCh6gqLFap3iEZN/
        uJsnCws3jAygLe8SOxw3+tSF3qhSgEgB7emC/hvvPZ1SheC1vwVwLawZ9Sn9JzWeBI8CR9+Wd
X-Google-Smtp-Source: ABdhPJxJ6vPorcOZWPTt9WE+NsldAJmxGtD55QpZ1SkuioLd7QEyINVZ6n3HZmxqJ6ZbfNTKqrA5sH8kgSzqYuUc
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a25:aa06:: with SMTP id
 s6mr4165403ybi.147.1606933461306; Wed, 02 Dec 2020 10:24:21 -0800 (PST)
Date:   Wed,  2 Dec 2020 10:24:11 -0800
In-Reply-To: <20201202182413.232510-1-awogbemila@google.com>
Message-Id: <20201202182413.232510-3-awogbemila@google.com>
Mime-Version: 1.0
References: <20201202182413.232510-1-awogbemila@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net-next v9 2/4] gve: Add support for raw addressing to the rx path
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     alexander.duyck@gmail.com, saeed@kernel.org,
        eric.dumazet@gmail.com, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Add support to use raw dma addresses in the rx path. Due to this new
support we can alloc a new buffer instead of making a copy.

RX buffers are handed to the networking stack and are
re-allocated as needed, avoiding the need to use
skb_copy_to_linear_data() as in "qpl" mode.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        |  12 +-
 drivers/net/ethernet/google/gve/gve_adminq.c |  14 +-
 drivers/net/ethernet/google/gve/gve_desc.h   |  11 +-
 drivers/net/ethernet/google/gve/gve_main.c   |   2 +-
 drivers/net/ethernet/google/gve/gve_rx.c     | 205 ++++++++++++++-----
 5 files changed, 182 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 782e2791ee11..d8bba0ba34e3 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -38,6 +38,8 @@
 #define NIC_TX_STATS_REPORT_NUM	0
 #define NIC_RX_STATS_REPORT_NUM	4
 
+#define GVE_DATA_SLOT_ADDR_PAGE_MASK (~(PAGE_SIZE - 1))
+
 /* Each slot in the desc ring has a 1:1 mapping to a slot in the data ring */
 struct gve_rx_desc_queue {
 	struct gve_rx_desc *desc_ring; /* the descriptor ring */
@@ -49,7 +51,7 @@ struct gve_rx_desc_queue {
 struct gve_rx_slot_page_info {
 	struct page *page;
 	void *page_address;
-	u32 page_offset; /* offset to write to in page */
+	u8 page_offset; /* flipped to second half? */
 };
 
 /* A list of pages registered with the device during setup and used by a queue
@@ -64,10 +66,11 @@ struct gve_queue_page_list {
 
 /* Each slot in the data ring has a 1:1 mapping to a slot in the desc ring */
 struct gve_rx_data_queue {
-	struct gve_rx_data_slot *data_ring; /* read by NIC */
+	union gve_rx_data_slot *data_ring; /* read by NIC */
 	dma_addr_t data_bus; /* dma mapping of the slots */
 	struct gve_rx_slot_page_info *page_info; /* page info of the buffers */
 	struct gve_queue_page_list *qpl; /* qpl assigned to this queue */
+	u8 raw_addressing; /* use raw_addressing? */
 };
 
 struct gve_priv;
@@ -82,6 +85,7 @@ struct gve_rx_ring {
 	u32 cnt; /* free-running total number of completed packets */
 	u32 fill_cnt; /* free-running total number of descs and buffs posted */
 	u32 mask; /* masks the cnt and fill_cnt to the size of the ring */
+	u32 db_threshold; /* threshold for posting new buffs and descs */
 	u64 rx_copybreak_pkt; /* free-running count of copybreak packets */
 	u64 rx_copied_pkt; /* free-running total number of copied packets */
 	u64 rx_skb_alloc_fail; /* free-running count of skb alloc fails */
@@ -194,7 +198,7 @@ struct gve_priv {
 	u16 tx_desc_cnt; /* num desc per ring */
 	u16 rx_desc_cnt; /* num desc per ring */
 	u16 tx_pages_per_qpl; /* tx buffer length */
-	u16 rx_pages_per_qpl; /* rx buffer length */
+	u16 rx_data_slot_cnt; /* rx buffer length */
 	u64 max_registered_pages;
 	u64 num_registered_pages; /* num pages registered with NIC */
 	u32 rx_copybreak; /* copy packets smaller than this */
@@ -444,7 +448,7 @@ static inline u32 gve_num_tx_qpls(struct gve_priv *priv)
  */
 static inline u32 gve_num_rx_qpls(struct gve_priv *priv)
 {
-	return priv->rx_cfg.num_queues;
+	return priv->raw_addressing ? 0 : priv->rx_cfg.num_queues;
 }
 
 /* Returns a pointer to the next available tx qpl in the list of qpls
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 608a8806f8c8..a1b9370db1e4 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -408,8 +408,10 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 {
 	struct gve_rx_ring *rx = &priv->rx[queue_index];
 	union gve_adminq_command cmd;
+	u32 qpl_id;
 	int err;
 
+	qpl_id = priv->raw_addressing ? GVE_RAW_ADDRESSING_QPL_ID : rx->data.qpl->id;
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_RX_QUEUE);
 	cmd.create_rx_queue = (struct gve_adminq_create_rx_queue) {
@@ -420,7 +422,7 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 		.queue_resources_addr = cpu_to_be64(rx->q_resources_bus),
 		.rx_desc_ring_addr = cpu_to_be64(rx->desc.bus),
 		.rx_data_ring_addr = cpu_to_be64(rx->data.data_bus),
-		.queue_page_list_id = cpu_to_be32(rx->data.qpl->id),
+		.queue_page_list_id = cpu_to_be32(qpl_id),
 	};
 
 	err = gve_adminq_issue_cmd(priv, &cmd);
@@ -565,11 +567,11 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	mac = descriptor->mac;
 	dev_info(&priv->pdev->dev, "MAC addr: %pM\n", mac);
 	priv->tx_pages_per_qpl = be16_to_cpu(descriptor->tx_pages_per_qpl);
-	priv->rx_pages_per_qpl = be16_to_cpu(descriptor->rx_pages_per_qpl);
-	if (priv->rx_pages_per_qpl < priv->rx_desc_cnt) {
-		dev_err(&priv->pdev->dev, "rx_pages_per_qpl cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
-			priv->rx_pages_per_qpl);
-		priv->rx_desc_cnt = priv->rx_pages_per_qpl;
+	priv->rx_data_slot_cnt = be16_to_cpu(descriptor->rx_pages_per_qpl);
+	if (priv->rx_data_slot_cnt < priv->rx_desc_cnt) {
+		dev_err(&priv->pdev->dev, "rx_data_slot_cnt cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
+			priv->rx_data_slot_cnt);
+		priv->rx_desc_cnt = priv->rx_data_slot_cnt;
 	}
 	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
 	dev_opt = (void *)(descriptor + 1);
diff --git a/drivers/net/ethernet/google/gve/gve_desc.h b/drivers/net/ethernet/google/gve/gve_desc.h
index 54779871d52e..a1c0aaa60139 100644
--- a/drivers/net/ethernet/google/gve/gve_desc.h
+++ b/drivers/net/ethernet/google/gve/gve_desc.h
@@ -72,12 +72,15 @@ struct gve_rx_desc {
 } __packed;
 static_assert(sizeof(struct gve_rx_desc) == 64);
 
-/* As with the Tx ring format, the qpl_offset entries below are offsets into an
- * ordered list of registered pages.
+/* If the device supports raw dma addressing then the addr in data slot is
+ * the dma address of the buffer.
+ * If the device only supports registered segments then the addr is a byte
+ * offset into the registered segment (an ordered list of pages) where the
+ * buffer is.
  */
-struct gve_rx_data_slot {
-	/* byte offset into the rx registered segment of this slot */
+union gve_rx_data_slot {
 	__be64 qpl_offset;
+	__be64 addr;
 };
 
 /* GVE Recive Packet Descriptor Seq No */
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 70685c10db0e..b7dae4f7b2fd 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -694,7 +694,7 @@ static int gve_alloc_qpls(struct gve_priv *priv)
 	}
 	for (; i < num_qpls; i++) {
 		err = gve_alloc_queue_page_list(priv, i,
-						priv->rx_pages_per_qpl);
+						priv->rx_data_slot_cnt);
 		if (err)
 			goto free_qpls;
 	}
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 008fa897a3e6..596772f5e29a 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -16,12 +16,39 @@ static void gve_rx_remove_from_block(struct gve_priv *priv, int queue_idx)
 	block->rx = NULL;
 }
 
+static void gve_rx_free_buffer(struct device *dev,
+			       struct gve_rx_slot_page_info *page_info,
+			       union gve_rx_data_slot *data_slot)
+{
+	dma_addr_t dma = (dma_addr_t)(be64_to_cpu(data_slot->addr) &
+				      GVE_DATA_SLOT_ADDR_PAGE_MASK);
+
+	gve_free_page(dev, page_info->page, dma, DMA_FROM_DEVICE);
+}
+
+static void gve_rx_unfill_pages(struct gve_priv *priv, struct gve_rx_ring *rx)
+{
+	if (rx->data.raw_addressing) {
+		u32 slots = rx->mask + 1;
+		int i;
+
+		for (i = 0; i < slots; i++)
+			gve_rx_free_buffer(&priv->pdev->dev, &rx->data.page_info[i],
+					   &rx->data.data_ring[i]);
+	} else {
+		gve_unassign_qpl(priv, rx->data.qpl->id);
+		rx->data.qpl = NULL;
+	}
+	kvfree(rx->data.page_info);
+	rx->data.page_info = NULL;
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
 
@@ -33,11 +60,8 @@ static void gve_rx_free_ring(struct gve_priv *priv, int idx)
 			  rx->q_resources, rx->q_resources_bus);
 	rx->q_resources = NULL;
 
-	gve_unassign_qpl(priv, rx->data.qpl->id);
-	rx->data.qpl = NULL;
-	kvfree(rx->data.page_info);
+	gve_rx_unfill_pages(priv, rx);
 
-	slots = rx->mask + 1;
 	bytes = sizeof(*rx->data.data_ring) * slots;
 	dma_free_coherent(dev, bytes, rx->data.data_ring,
 			  rx->data.data_bus);
@@ -46,19 +70,35 @@ static void gve_rx_free_ring(struct gve_priv *priv, int idx)
 }
 
 static void gve_setup_rx_buffer(struct gve_rx_slot_page_info *page_info,
-				struct gve_rx_data_slot *slot,
-				dma_addr_t addr, struct page *page)
+			     dma_addr_t addr, struct page *page, __be64 *slot_addr)
 {
 	page_info->page = page;
 	page_info->page_offset = 0;
 	page_info->page_address = page_address(page);
-	slot->qpl_offset = cpu_to_be64(addr);
+	*slot_addr = cpu_to_be64(addr);
+}
+
+static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
+			       struct gve_rx_slot_page_info *page_info,
+			       union gve_rx_data_slot *data_slot)
+{
+	struct page *page;
+	dma_addr_t dma;
+	int err;
+
+	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE);
+	if (err)
+		return err;
+
+	gve_setup_rx_buffer(page_info, dma, page, &data_slot->addr);
+	return 0;
 }
 
 static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
 {
 	struct gve_priv *priv = rx->gve;
 	u32 slots;
+	int err;
 	int i;
 
 	/* Allocate one page per Rx queue slot. Each page is split into two
@@ -71,17 +111,30 @@ static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
 	if (!rx->data.page_info)
 		return -ENOMEM;
 
-	rx->data.qpl = gve_assign_rx_qpl(priv);
-
+	if (!rx->data.raw_addressing)
+		rx->data.qpl = gve_assign_rx_qpl(priv);
 	for (i = 0; i < slots; i++) {
-		struct page *page = rx->data.qpl->pages[i];
-		dma_addr_t addr = i * PAGE_SIZE;
+		if (!rx->data.raw_addressing) {
+			struct page *page = rx->data.qpl->pages[i];
+			dma_addr_t addr = i * PAGE_SIZE;
 
-		gve_setup_rx_buffer(&rx->data.page_info[i],
-				    &rx->data.data_ring[i], addr, page);
+			gve_setup_rx_buffer(&rx->data.page_info[i], addr, page,
+					    &rx->data.data_ring[i].qpl_offset);
+			continue;
+		}
+		err = gve_rx_alloc_buffer(priv, &priv->pdev->dev, &rx->data.page_info[i],
+					  &rx->data.data_ring[i]);
+		if (err)
+			goto alloc_err;
 	}
 
 	return slots;
+alloc_err:
+	while (i--)
+		gve_rx_free_buffer(&priv->pdev->dev,
+				   &rx->data.page_info[i],
+				   &rx->data.data_ring[i]);
+	return err;
 }
 
 static void gve_rx_add_to_block(struct gve_priv *priv, int queue_idx)
@@ -110,8 +163,9 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 	rx->gve = priv;
 	rx->q_num = idx;
 
-	slots = priv->rx_pages_per_qpl;
+	slots = priv->rx_data_slot_cnt;
 	rx->mask = slots - 1;
+	rx->data.raw_addressing = priv->raw_addressing;
 
 	/* alloc rx data ring */
 	bytes = sizeof(*rx->data.data_ring) * slots;
@@ -156,8 +210,8 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 		err = -ENOMEM;
 		goto abort_with_q_resources;
 	}
-	rx->mask = slots - 1;
 	rx->cnt = 0;
+	rx->db_threshold = priv->rx_desc_cnt / 2;
 	rx->desc.seqno = 1;
 	gve_rx_add_to_block(priv, idx);
 
@@ -168,7 +222,7 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 			  rx->q_resources, rx->q_resources_bus);
 	rx->q_resources = NULL;
 abort_filled:
-	kvfree(rx->data.page_info);
+	gve_rx_unfill_pages(priv, rx);
 abort_with_slots:
 	bytes = sizeof(*rx->data.data_ring) * slots;
 	dma_free_coherent(hdev, bytes, rx->data.data_ring, rx->data.data_bus);
@@ -233,7 +287,7 @@ static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
 {
 	struct sk_buff *skb = napi_alloc_skb(napi, len);
 	void *va = page_info->page_address + GVE_RX_PAD +
-		   page_info->page_offset;
+		   (page_info->page_offset ? PAGE_SIZE / 2 : 0);
 
 	if (unlikely(!skb))
 		return NULL;
@@ -251,8 +305,7 @@ static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
 	return skb;
 }
 
-static struct sk_buff *gve_rx_add_frags(struct net_device *dev,
-					struct napi_struct *napi,
+static struct sk_buff *gve_rx_add_frags(struct napi_struct *napi,
 					struct gve_rx_slot_page_info *page_info,
 					u16 len)
 {
@@ -262,20 +315,19 @@ static struct sk_buff *gve_rx_add_frags(struct net_device *dev,
 		return NULL;
 
 	skb_add_rx_frag(skb, 0, page_info->page,
-			page_info->page_offset +
+			(page_info->page_offset ? PAGE_SIZE / 2 : 0) +
 			GVE_RX_PAD, len, PAGE_SIZE / 2);
 
 	return skb;
 }
 
-static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info,
-			     struct gve_rx_data_slot *data_ring)
+static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info, __be64 *slot_addr)
 {
-	u64 addr = be64_to_cpu(data_ring->qpl_offset);
+	const __be64 offset = cpu_to_be64(PAGE_SIZE / 2);
 
-	page_info->page_offset ^= PAGE_SIZE / 2;
-	addr ^= PAGE_SIZE / 2;
-	data_ring->qpl_offset = cpu_to_be64(addr);
+	/* "flip" to other packet buffer on this page */
+	page_info->page_offset ^= 0x1;
+	*(slot_addr) ^= offset;
 }
 
 static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
@@ -285,7 +337,9 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	struct gve_priv *priv = rx->gve;
 	struct napi_struct *napi = &priv->ntfy_blocks[rx->ntfy_id].napi;
 	struct net_device *dev = priv->dev;
-	struct sk_buff *skb;
+	union gve_rx_data_slot *data_slot;
+	struct sk_buff *skb = NULL;
+	dma_addr_t page_bus;
 	int pagecount;
 	u16 len;
 
@@ -294,18 +348,18 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
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
+			be64_to_cpu(data_slot->addr) & GVE_DATA_SLOT_ADDR_PAGE_MASK :
+			rx->data.qpl->page_buses[idx];
+	dma_sync_single_for_cpu(&priv->pdev->dev, page_bus,
+				PAGE_SIZE, DMA_FROM_DEVICE);
 
 	if (PAGE_SIZE == 4096) {
 		if (len <= priv->rx_copybreak) {
@@ -316,6 +370,10 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 			u64_stats_update_end(&rx->statss);
 			goto have_skb;
 		}
+		if (rx->data.raw_addressing) {
+			skb = gve_rx_add_frags(napi, page_info, len);
+			goto have_skb;
+		}
 		if (unlikely(!gve_can_recycle_pages(dev))) {
 			skb = gve_rx_copy(rx, dev, napi, page_info, len);
 			goto have_skb;
@@ -326,17 +384,17 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 			 * the page fragment to a new SKB and pass it up the
 			 * stack.
 			 */
-			skb = gve_rx_add_frags(dev, napi, page_info, len);
+			skb = gve_rx_add_frags(napi, page_info, len);
 			if (!skb) {
 				u64_stats_update_begin(&rx->statss);
 				rx->rx_skb_alloc_fail++;
 				u64_stats_update_end(&rx->statss);
-				return true;
+				return false;
 			}
 			/* Make sure the kernel stack can't release the page */
 			get_page(page_info->page);
 			/* "flip" to other packet buffer on this page */
-			gve_rx_flip_buff(page_info, &rx->data.data_ring[idx]);
+			gve_rx_flip_buff(page_info, &rx->data.data_ring[idx].qpl_offset);
 		} else if (pagecount >= 2) {
 			/* We have previously passed the other half of this
 			 * page up the stack, but it has not yet been freed.
@@ -347,7 +405,10 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 			return false;
 		}
 	} else {
-		skb = gve_rx_copy(rx, dev, napi, page_info, len);
+		if (rx->data.raw_addressing)
+			skb = gve_rx_add_frags(napi, page_info, len);
+		else
+			skb = gve_rx_copy(rx, dev, napi, page_info, len);
 	}
 
 have_skb:
@@ -358,7 +419,7 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 		u64_stats_update_begin(&rx->statss);
 		rx->rx_skb_alloc_fail++;
 		u64_stats_update_end(&rx->statss);
-		return true;
+		return false;
 	}
 
 	if (likely(feat & NETIF_F_RXCSUM)) {
@@ -399,19 +460,48 @@ static bool gve_rx_work_pending(struct gve_rx_ring *rx)
 	return (GVE_SEQNO(flags_seq) == rx->desc.seqno);
 }
 
+static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
+{
+	int refill_target = rx->mask + 1;
+	u32 fill_cnt = rx->fill_cnt;
+
+	while (fill_cnt - rx->cnt < refill_target) {
+		struct gve_rx_slot_page_info *page_info;
+		struct device *dev = &priv->pdev->dev;
+		union gve_rx_data_slot *data_slot;
+		u32 idx = fill_cnt & rx->mask;
+
+		page_info = &rx->data.page_info[idx];
+		data_slot = &rx->data.data_ring[idx];
+		gve_rx_free_buffer(dev, page_info, data_slot);
+		page_info->page = NULL;
+		if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot)) {
+			u64_stats_update_begin(&rx->statss);
+			rx->rx_buf_alloc_fail++;
+			u64_stats_update_end(&rx->statss);
+			break;
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
+
 		netif_info(priv, rx_status, priv->dev,
 			   "[%d] idx=%d desc=%p desc->flags_seq=0x%x\n",
 			   rx->q_num, idx, desc, desc->flags_seq);
@@ -419,9 +509,11 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
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
@@ -429,15 +521,34 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 		work_done++;
 	}
 
-	if (!work_done)
+	if (!work_done && rx->fill_cnt - cnt > rx->db_threshold)
 		return false;
 
 	u64_stats_update_begin(&rx->statss);
-	rx->rpackets += work_done;
+	rx->rpackets += packets;
 	rx->rbytes += bytes;
 	u64_stats_update_end(&rx->statss);
 	rx->cnt = cnt;
-	rx->fill_cnt += work_done;
+
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
+
+		/* If we were not able to completely refill buffers, we'll want
+		 * to schedule this queue for work again to refill buffers.
+		 */
+		if (rx->fill_cnt - cnt <= rx->db_threshold) {
+			gve_rx_write_doorbell(priv, rx);
+			return true;
+		}
+	}
 
 	gve_rx_write_doorbell(priv, rx);
 	return gve_rx_work_pending(rx);
-- 
2.29.2.576.ga3fc446d84-goog


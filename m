Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1FB3B354E
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhFXSK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbhFXSKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:10:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922BEC061756
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:08:08 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p23-20020a25d8170000b0290550a9ad877dso493832ybg.12
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=InFKVL4xkdLtvkArol7Ll0FzvsiLZlsbBwBK7mb8lY4=;
        b=EQ5YD3mf/sgxc9jOpVEpQozTVjuij0IHkzmGv8YKGadzUA/nvBO4RPXAj1DdNtq5ZS
         1ZgFErGFTl4iSx9fgQidiOxeGd944MTlG8iaUg4txa3K87Dc6g56T0wRIV9oBAz6C3jK
         rTMyPON01+YR/ZCeRoWqFoCAmE8XdRvTrzCZQCFDFUD/IPP+9taArxajExcDItF/XBsJ
         W/WRwkVphYwA/fviouiLUyZsynjPLGeTJ+LhN2neGSvb6nYXA7+bMmyKycUAO7rufgmH
         3WzCXuVph028eXXN2r5juAcv6UDP+DSbQ16vjAg0kGTnFHXyjEl1Ir+xXEW7HFcLqR5y
         YQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=InFKVL4xkdLtvkArol7Ll0FzvsiLZlsbBwBK7mb8lY4=;
        b=WSoJnqh/dXQd/q3C5G20MesGfNb+Ng9ORAUyZShodMRlBHCOMg3bv9unXtFPwU+EHa
         ulHtzQrazaCJz/r0CMgUgG/AWDleLcii0Sm3mFAAK4HZd7o7eoGZU/PYFxSui84V0w51
         gKijXq+ztBo2aJc+F0DiqF8tYILQ0ovwEwEto5nhw1huEKcBP1hyOsMY+Nml1SpDnHLd
         l2hST6j5D7BfswC8dosrMQl+tSTxzSiqRJJzoViNVaWJvIDEX0gf3+Ti7MqVPiDR6Maq
         p+6/4j+MSqnwUeJXtOIXt/WuTV/UhfWgEbvDcLHrItbKzXQ2dYx2x46TdPi/Y2XPt2O/
         6nNg==
X-Gm-Message-State: AOAM531OV5r0tFnOLqVoybe8ftdhaP4mky73xBjhjnDl6sUnDJpKuOVx
        fUJTqgN0sps7ma/+9Rnzcd9KA1U=
X-Google-Smtp-Source: ABdhPJy9YBozm0/MeDEgdjVhZaMOczj0FTNvoLEEIdM/32HYxdwV/9XyiwaxMANt7fCttwZgMCHNqvQ=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:a25:bd84:: with SMTP id f4mr7365313ybh.143.1624558087742;
 Thu, 24 Jun 2021 11:08:07 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:32 -0700
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
Message-Id: <20210624180632.3659809-17-bcf@google.com>
Mime-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 16/16] gve: DQO: Add RX path
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RX queue has an array of `gve_rx_buf_state_dqo` objects. All
allocated pages have an associated buf_state object. When a buffer is
posted on the RX buffer queue, the buffer ID will be the buf_state's
index into the RX queue's array.

On packet reception, the RX queue will have one descriptor for each
buffer associated with a received packet. Each RX descriptor will have
a buffer_id that was posted on the buffer queue.

Notable mentions:

- We use a default buffer size of 2048 bytes. Based on page size, we
  may post separate sections of a single page as separate buffers.

- The driver holds an extra reference on pages passed up the receive
  path with an skb and keeps these pages on a list. When posting new
  buffers to the NIC, we check if any of these pages has only our
  reference, or another buffer sized segment of the page has no
  references. If so, it is free to reuse. This page recycling approach
  is a common netdev optimization that reduces page alloc/free calls.

- Pages in the free list have a page_count bias in order to avoid an
  atomic increment of pagecount every time we attempt to reuse a page.
  # references = page_count() - bias

- In order to track when a page is safe to reuse, we keep track of the
  last offset which had a single SKB reference. When this occurs, it
  implies that every single other offset is reusable. Otherwise, we
  don't know if offsets can be safely reused.

- We maintain two free lists of pages. List #1 (recycled_buf_states)
  contains pages we know can be reused right away. List #2
  (used_buf_states) contains pages which cannot be used right away. We
  only attempt to get pages from list #2 when list #1 is empty. We only
  attempt to use a small fixed number pages from list #2 before giving
  up and allocating a new page. Both lists are FIFOs in hope that by the
  time we attempt to reuse a page, the references were dropped.

Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        |   1 +
 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 582 +++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_utils.c  |  15 +
 drivers/net/ethernet/google/gve/gve_utils.h  |   3 +
 4 files changed, 601 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 30978a15e37d..1d3188e8e3b3 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -59,6 +59,7 @@ struct gve_rx_slot_page_info {
 	struct page *page;
 	void *page_address;
 	u32 page_offset; /* offset to write to in page */
+	int pagecnt_bias; /* expected pagecnt if only the driver has a ref */
 	u8 can_flip;
 };
 
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 1073a820767d..8738db020061 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -16,9 +16,161 @@
 #include <net/ipv6.h>
 #include <net/tcp.h>
 
+static int gve_buf_ref_cnt(struct gve_rx_buf_state_dqo *bs)
+{
+	return page_count(bs->page_info.page) - bs->page_info.pagecnt_bias;
+}
+
 static void gve_free_page_dqo(struct gve_priv *priv,
 			      struct gve_rx_buf_state_dqo *bs)
 {
+	page_ref_sub(bs->page_info.page, bs->page_info.pagecnt_bias - 1);
+	gve_free_page(&priv->pdev->dev, bs->page_info.page, bs->addr,
+		      DMA_FROM_DEVICE);
+	bs->page_info.page = NULL;
+}
+
+static struct gve_rx_buf_state_dqo *gve_alloc_buf_state(struct gve_rx_ring *rx)
+{
+	struct gve_rx_buf_state_dqo *buf_state;
+	s16 buffer_id;
+
+	buffer_id = rx->dqo.free_buf_states;
+	if (unlikely(buffer_id == -1))
+		return NULL;
+
+	buf_state = &rx->dqo.buf_states[buffer_id];
+
+	/* Remove buf_state from free list */
+	rx->dqo.free_buf_states = buf_state->next;
+
+	/* Point buf_state to itself to mark it as allocated */
+	buf_state->next = buffer_id;
+
+	return buf_state;
+}
+
+static bool gve_buf_state_is_allocated(struct gve_rx_ring *rx,
+				       struct gve_rx_buf_state_dqo *buf_state)
+{
+	s16 buffer_id = buf_state - rx->dqo.buf_states;
+
+	return buf_state->next == buffer_id;
+}
+
+static void gve_free_buf_state(struct gve_rx_ring *rx,
+			       struct gve_rx_buf_state_dqo *buf_state)
+{
+	s16 buffer_id = buf_state - rx->dqo.buf_states;
+
+	buf_state->next = rx->dqo.free_buf_states;
+	rx->dqo.free_buf_states = buffer_id;
+}
+
+static struct gve_rx_buf_state_dqo *
+gve_dequeue_buf_state(struct gve_rx_ring *rx, struct gve_index_list *list)
+{
+	struct gve_rx_buf_state_dqo *buf_state;
+	s16 buffer_id;
+
+	buffer_id = list->head;
+	if (unlikely(buffer_id == -1))
+		return NULL;
+
+	buf_state = &rx->dqo.buf_states[buffer_id];
+
+	/* Remove buf_state from list */
+	list->head = buf_state->next;
+	if (buf_state->next == -1)
+		list->tail = -1;
+
+	/* Point buf_state to itself to mark it as allocated */
+	buf_state->next = buffer_id;
+
+	return buf_state;
+}
+
+static void gve_enqueue_buf_state(struct gve_rx_ring *rx,
+				  struct gve_index_list *list,
+				  struct gve_rx_buf_state_dqo *buf_state)
+{
+	s16 buffer_id = buf_state - rx->dqo.buf_states;
+
+	buf_state->next = -1;
+
+	if (list->head == -1) {
+		list->head = buffer_id;
+		list->tail = buffer_id;
+	} else {
+		int tail = list->tail;
+
+		rx->dqo.buf_states[tail].next = buffer_id;
+		list->tail = buffer_id;
+	}
+}
+
+static struct gve_rx_buf_state_dqo *
+gve_get_recycled_buf_state(struct gve_rx_ring *rx)
+{
+	struct gve_rx_buf_state_dqo *buf_state;
+	int i;
+
+	/* Recycled buf states are immediately usable. */
+	buf_state = gve_dequeue_buf_state(rx, &rx->dqo.recycled_buf_states);
+	if (likely(buf_state))
+		return buf_state;
+
+	if (unlikely(rx->dqo.used_buf_states.head == -1))
+		return NULL;
+
+	/* Used buf states are only usable when ref count reaches 0, which means
+	 * no SKBs refer to them.
+	 *
+	 * Search a limited number before giving up.
+	 */
+	for (i = 0; i < 5; i++) {
+		buf_state = gve_dequeue_buf_state(rx, &rx->dqo.used_buf_states);
+		if (gve_buf_ref_cnt(buf_state) == 0)
+			return buf_state;
+
+		gve_enqueue_buf_state(rx, &rx->dqo.used_buf_states, buf_state);
+	}
+
+	/* If there are no free buf states discard an entry from
+	 * `used_buf_states` so it can be used.
+	 */
+	if (unlikely(rx->dqo.free_buf_states == -1)) {
+		buf_state = gve_dequeue_buf_state(rx, &rx->dqo.used_buf_states);
+		if (gve_buf_ref_cnt(buf_state) == 0)
+			return buf_state;
+
+		gve_free_page_dqo(rx->gve, buf_state);
+		gve_free_buf_state(rx, buf_state);
+	}
+
+	return NULL;
+}
+
+static int gve_alloc_page_dqo(struct gve_priv *priv,
+			      struct gve_rx_buf_state_dqo *buf_state)
+{
+	int err;
+
+	err = gve_alloc_page(priv, &priv->pdev->dev, &buf_state->page_info.page,
+			     &buf_state->addr, DMA_FROM_DEVICE);
+	if (err)
+		return err;
+
+	buf_state->page_info.page_offset = 0;
+	buf_state->page_info.page_address =
+		page_address(buf_state->page_info.page);
+	buf_state->last_single_ref_offset = 0;
+
+	/* The page already has 1 ref. */
+	page_ref_add(buf_state->page_info.page, INT_MAX - 1);
+	buf_state->page_info.pagecnt_bias = INT_MAX;
+
+	return 0;
 }
 
 static void gve_rx_free_ring_dqo(struct gve_priv *priv, int idx)
@@ -137,6 +289,14 @@ static int gve_rx_alloc_ring_dqo(struct gve_priv *priv, int idx)
 	return -ENOMEM;
 }
 
+void gve_rx_write_doorbell_dqo(const struct gve_priv *priv, int queue_idx)
+{
+	const struct gve_rx_ring *rx = &priv->rx[queue_idx];
+	u64 index = be32_to_cpu(rx->q_resources->db_index);
+
+	iowrite32(rx->dqo.bufq.tail, &priv->db_bar2[index]);
+}
+
 int gve_rx_alloc_rings_dqo(struct gve_priv *priv)
 {
 	int err = 0;
@@ -171,11 +331,433 @@ void gve_rx_free_rings_dqo(struct gve_priv *priv)
 
 void gve_rx_post_buffers_dqo(struct gve_rx_ring *rx)
 {
+	struct gve_rx_compl_queue_dqo *complq = &rx->dqo.complq;
+	struct gve_rx_buf_queue_dqo *bufq = &rx->dqo.bufq;
+	struct gve_priv *priv = rx->gve;
+	u32 num_avail_slots;
+	u32 num_full_slots;
+	u32 num_posted = 0;
+
+	num_full_slots = (bufq->tail - bufq->head) & bufq->mask;
+	num_avail_slots = bufq->mask - num_full_slots;
+
+	num_avail_slots = min_t(u32, num_avail_slots, complq->num_free_slots);
+	while (num_posted < num_avail_slots) {
+		struct gve_rx_desc_dqo *desc = &bufq->desc_ring[bufq->tail];
+		struct gve_rx_buf_state_dqo *buf_state;
+
+		buf_state = gve_get_recycled_buf_state(rx);
+		if (unlikely(!buf_state)) {
+			buf_state = gve_alloc_buf_state(rx);
+			if (unlikely(!buf_state))
+				break;
+
+			if (unlikely(gve_alloc_page_dqo(priv, buf_state))) {
+				u64_stats_update_begin(&rx->statss);
+				rx->rx_buf_alloc_fail++;
+				u64_stats_update_end(&rx->statss);
+				gve_free_buf_state(rx, buf_state);
+				break;
+			}
+		}
+
+		desc->buf_id = cpu_to_le16(buf_state - rx->dqo.buf_states);
+		desc->buf_addr = cpu_to_le64(buf_state->addr +
+					     buf_state->page_info.page_offset);
+
+		bufq->tail = (bufq->tail + 1) & bufq->mask;
+		complq->num_free_slots--;
+		num_posted++;
+
+		if ((bufq->tail & (GVE_RX_BUF_THRESH_DQO - 1)) == 0)
+			gve_rx_write_doorbell_dqo(priv, rx->q_num);
+	}
+
+	rx->fill_cnt += num_posted;
+}
+
+static void gve_try_recycle_buf(struct gve_priv *priv, struct gve_rx_ring *rx,
+				struct gve_rx_buf_state_dqo *buf_state)
+{
+	const int data_buffer_size = priv->data_buffer_size_dqo;
+	int pagecount;
+
+	/* Can't reuse if we only fit one buffer per page */
+	if (data_buffer_size * 2 > PAGE_SIZE)
+		goto mark_used;
+
+	pagecount = gve_buf_ref_cnt(buf_state);
+
+	/* Record the offset when we have a single remaining reference.
+	 *
+	 * When this happens, we know all of the other offsets of the page are
+	 * usable.
+	 */
+	if (pagecount == 1) {
+		buf_state->last_single_ref_offset =
+			buf_state->page_info.page_offset;
+	}
+
+	/* Use the next buffer sized chunk in the page. */
+	buf_state->page_info.page_offset += data_buffer_size;
+	buf_state->page_info.page_offset &= (PAGE_SIZE - 1);
+
+	/* If we wrap around to the same offset without ever dropping to 1
+	 * reference, then we don't know if this offset was ever freed.
+	 */
+	if (buf_state->page_info.page_offset ==
+	    buf_state->last_single_ref_offset) {
+		goto mark_used;
+	}
+
+	gve_enqueue_buf_state(rx, &rx->dqo.recycled_buf_states, buf_state);
+	return;
+
+mark_used:
+	gve_enqueue_buf_state(rx, &rx->dqo.used_buf_states, buf_state);
+}
+
+static void gve_rx_skb_csum(struct sk_buff *skb,
+			    const struct gve_rx_compl_desc_dqo *desc,
+			    struct gve_ptype ptype)
+{
+	skb->ip_summed = CHECKSUM_NONE;
+
+	/* HW did not identify and process L3 and L4 headers. */
+	if (unlikely(!desc->l3_l4_processed))
+		return;
+
+	if (ptype.l3_type == GVE_L3_TYPE_IPV4) {
+		if (unlikely(desc->csum_ip_err || desc->csum_external_ip_err))
+			return;
+	} else if (ptype.l3_type == GVE_L3_TYPE_IPV6) {
+		/* Checksum should be skipped if this flag is set. */
+		if (unlikely(desc->ipv6_ex_add))
+			return;
+	}
+
+	if (unlikely(desc->csum_l4_err))
+		return;
+
+	switch (ptype.l4_type) {
+	case GVE_L4_TYPE_TCP:
+	case GVE_L4_TYPE_UDP:
+	case GVE_L4_TYPE_ICMP:
+	case GVE_L4_TYPE_SCTP:
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		break;
+	default:
+		break;
+	}
+}
+
+static void gve_rx_skb_hash(struct sk_buff *skb,
+			    const struct gve_rx_compl_desc_dqo *compl_desc,
+			    struct gve_ptype ptype)
+{
+	enum pkt_hash_types hash_type = PKT_HASH_TYPE_L2;
+
+	if (ptype.l4_type != GVE_L4_TYPE_UNKNOWN)
+		hash_type = PKT_HASH_TYPE_L4;
+	else if (ptype.l3_type != GVE_L3_TYPE_UNKNOWN)
+		hash_type = PKT_HASH_TYPE_L3;
+
+	skb_set_hash(skb, le32_to_cpu(compl_desc->hash), hash_type);
+}
+
+static void gve_rx_free_skb(struct gve_rx_ring *rx)
+{
+	if (!rx->skb_head)
+		return;
+
+	dev_kfree_skb_any(rx->skb_head);
+	rx->skb_head = NULL;
+	rx->skb_tail = NULL;
+}
+
+/* Chains multi skbs for single rx packet.
+ * Returns 0 if buffer is appended, -1 otherwise.
+ */
+static int gve_rx_append_frags(struct napi_struct *napi,
+			       struct gve_rx_buf_state_dqo *buf_state,
+			       u16 buf_len, struct gve_rx_ring *rx,
+			       struct gve_priv *priv)
+{
+	int num_frags = skb_shinfo(rx->skb_tail)->nr_frags;
+
+	if (unlikely(num_frags == MAX_SKB_FRAGS)) {
+		struct sk_buff *skb;
+
+		skb = napi_alloc_skb(napi, 0);
+		if (!skb)
+			return -1;
+
+		skb_shinfo(rx->skb_tail)->frag_list = skb;
+		rx->skb_tail = skb;
+		num_frags = 0;
+	}
+	if (rx->skb_tail != rx->skb_head) {
+		rx->skb_head->len += buf_len;
+		rx->skb_head->data_len += buf_len;
+		rx->skb_head->truesize += priv->data_buffer_size_dqo;
+	}
+
+	skb_add_rx_frag(rx->skb_tail, num_frags,
+			buf_state->page_info.page,
+			buf_state->page_info.page_offset,
+			buf_len, priv->data_buffer_size_dqo);
+	gve_dec_pagecnt_bias(&buf_state->page_info);
+
+	return 0;
+}
+
+/* Returns 0 if descriptor is completed successfully.
+ * Returns -EINVAL if descriptor is invalid.
+ * Returns -ENOMEM if data cannot be copied to skb.
+ */
+static int gve_rx_dqo(struct napi_struct *napi, struct gve_rx_ring *rx,
+		      const struct gve_rx_compl_desc_dqo *compl_desc,
+		      int queue_idx)
+{
+	const u16 buffer_id = le16_to_cpu(compl_desc->buf_id);
+	const bool eop = compl_desc->end_of_packet != 0;
+	struct gve_rx_buf_state_dqo *buf_state;
+	struct gve_priv *priv = rx->gve;
+	u16 buf_len;
+
+	if (unlikely(buffer_id > rx->dqo.num_buf_states)) {
+		net_err_ratelimited("%s: Invalid RX buffer_id=%u\n",
+				    priv->dev->name, buffer_id);
+		return -EINVAL;
+	}
+	buf_state = &rx->dqo.buf_states[buffer_id];
+	if (unlikely(!gve_buf_state_is_allocated(rx, buf_state))) {
+		net_err_ratelimited("%s: RX buffer_id is not allocated: %u\n",
+				    priv->dev->name, buffer_id);
+		return -EINVAL;
+	}
+
+	if (unlikely(compl_desc->rx_error)) {
+		gve_enqueue_buf_state(rx, &rx->dqo.recycled_buf_states,
+				      buf_state);
+		return -EINVAL;
+	}
+
+	buf_len = compl_desc->packet_len;
+
+	/* Page might have not been used for awhile and was likely last written
+	 * by a different thread.
+	 */
+	prefetch(buf_state->page_info.page);
+
+	/* Sync the portion of dma buffer for CPU to read. */
+	dma_sync_single_range_for_cpu(&priv->pdev->dev, buf_state->addr,
+				      buf_state->page_info.page_offset,
+				      buf_len, DMA_FROM_DEVICE);
+
+	/* Append to current skb if one exists. */
+	if (rx->skb_head) {
+		if (unlikely(gve_rx_append_frags(napi, buf_state, buf_len, rx,
+						 priv)) != 0) {
+			goto error;
+		}
+
+		gve_try_recycle_buf(priv, rx, buf_state);
+		return 0;
+	}
+
+	/* Prefetch the payload header. */
+	prefetch((char *)buf_state->addr + buf_state->page_info.page_offset);
+#if L1_CACHE_BYTES < 128
+	prefetch((char *)buf_state->addr + buf_state->page_info.page_offset +
+		 L1_CACHE_BYTES);
+#endif
+
+	if (eop && buf_len <= priv->rx_copybreak) {
+		rx->skb_head = gve_rx_copy(priv->dev, napi,
+					   &buf_state->page_info, buf_len, 0);
+		if (unlikely(!rx->skb_head))
+			goto error;
+		rx->skb_tail = rx->skb_head;
+
+		u64_stats_update_begin(&rx->statss);
+		rx->rx_copied_pkt++;
+		rx->rx_copybreak_pkt++;
+		u64_stats_update_end(&rx->statss);
+
+		gve_enqueue_buf_state(rx, &rx->dqo.recycled_buf_states,
+				      buf_state);
+		return 0;
+	}
+
+	rx->skb_head = napi_get_frags(napi);
+	if (unlikely(!rx->skb_head))
+		goto error;
+	rx->skb_tail = rx->skb_head;
+
+	skb_add_rx_frag(rx->skb_head, 0, buf_state->page_info.page,
+			buf_state->page_info.page_offset, buf_len,
+			priv->data_buffer_size_dqo);
+	gve_dec_pagecnt_bias(&buf_state->page_info);
+
+	gve_try_recycle_buf(priv, rx, buf_state);
+	return 0;
+
+error:
+	gve_enqueue_buf_state(rx, &rx->dqo.recycled_buf_states, buf_state);
+	return -ENOMEM;
+}
+
+static int gve_rx_complete_rsc(struct sk_buff *skb,
+			       const struct gve_rx_compl_desc_dqo *desc,
+			       struct gve_ptype ptype)
+{
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+
+	/* Only TCP is supported right now. */
+	if (ptype.l4_type != GVE_L4_TYPE_TCP)
+		return -EINVAL;
+
+	switch (ptype.l3_type) {
+	case GVE_L3_TYPE_IPV4:
+		shinfo->gso_type = SKB_GSO_TCPV4;
+		break;
+	case GVE_L3_TYPE_IPV6:
+		shinfo->gso_type = SKB_GSO_TCPV6;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	shinfo->gso_size = le16_to_cpu(desc->rsc_seg_len);
+	return 0;
+}
+
+/* Returns 0 if skb is completed successfully, -1 otherwise. */
+static int gve_rx_complete_skb(struct gve_rx_ring *rx, struct napi_struct *napi,
+			       const struct gve_rx_compl_desc_dqo *desc,
+			       netdev_features_t feat)
+{
+	struct gve_ptype ptype =
+		rx->gve->ptype_lut_dqo->ptypes[desc->packet_type];
+	int err;
+
+	skb_record_rx_queue(rx->skb_head, rx->q_num);
+
+	if (feat & NETIF_F_RXHASH)
+		gve_rx_skb_hash(rx->skb_head, desc, ptype);
+
+	if (feat & NETIF_F_RXCSUM)
+		gve_rx_skb_csum(rx->skb_head, desc, ptype);
+
+	/* RSC packets must set gso_size otherwise the TCP stack will complain
+	 * that packets are larger than MTU.
+	 */
+	if (desc->rsc) {
+		err = gve_rx_complete_rsc(rx->skb_head, desc, ptype);
+		if (err < 0)
+			return err;
+	}
+
+	if (skb_headlen(rx->skb_head) == 0)
+		napi_gro_frags(napi);
+	else
+		napi_gro_receive(napi, rx->skb_head);
+
+	return 0;
 }
 
 int gve_rx_poll_dqo(struct gve_notify_block *block, int budget)
 {
+	struct napi_struct *napi = &block->napi;
+	netdev_features_t feat = napi->dev->features;
+
+	struct gve_rx_ring *rx = block->rx;
+	struct gve_rx_compl_queue_dqo *complq = &rx->dqo.complq;
+
 	u32 work_done = 0;
+	u64 bytes = 0;
+	int err;
+
+	while (work_done < budget) {
+		struct gve_rx_compl_desc_dqo *compl_desc =
+			&complq->desc_ring[complq->head];
+		u32 pkt_bytes;
+
+		/* No more new packets */
+		if (compl_desc->generation == complq->cur_gen_bit)
+			break;
+
+		/* Prefetch the next two descriptors. */
+		prefetch(&complq->desc_ring[(complq->head + 1) & complq->mask]);
+		prefetch(&complq->desc_ring[(complq->head + 2) & complq->mask]);
+
+		/* Do not read data until we own the descriptor */
+		dma_rmb();
+
+		err = gve_rx_dqo(napi, rx, compl_desc, rx->q_num);
+		if (err < 0) {
+			gve_rx_free_skb(rx);
+			u64_stats_update_begin(&rx->statss);
+			if (err == -ENOMEM)
+				rx->rx_skb_alloc_fail++;
+			else if (err == -EINVAL)
+				rx->rx_desc_err_dropped_pkt++;
+			u64_stats_update_end(&rx->statss);
+		}
+
+		complq->head = (complq->head + 1) & complq->mask;
+		complq->num_free_slots++;
+
+		/* When the ring wraps, the generation bit is flipped. */
+		complq->cur_gen_bit ^= (complq->head == 0);
+
+		/* Receiving a completion means we have space to post another
+		 * buffer on the buffer queue.
+		 */
+		{
+			struct gve_rx_buf_queue_dqo *bufq = &rx->dqo.bufq;
+
+			bufq->head = (bufq->head + 1) & bufq->mask;
+		}
+
+		/* Free running counter of completed descriptors */
+		rx->cnt++;
+
+		if (!rx->skb_head)
+			continue;
+
+		if (!compl_desc->end_of_packet)
+			continue;
+
+		work_done++;
+		pkt_bytes = rx->skb_head->len;
+		/* The ethernet header (first ETH_HLEN bytes) is snipped off
+		 * by eth_type_trans.
+		 */
+		if (skb_headlen(rx->skb_head))
+			pkt_bytes += ETH_HLEN;
+
+		/* gve_rx_complete_skb() will consume skb if successful */
+		if (gve_rx_complete_skb(rx, napi, compl_desc, feat) != 0) {
+			gve_rx_free_skb(rx);
+			u64_stats_update_begin(&rx->statss);
+			rx->rx_desc_err_dropped_pkt++;
+			u64_stats_update_end(&rx->statss);
+			continue;
+		}
+
+		bytes += pkt_bytes;
+		rx->skb_head = NULL;
+		rx->skb_tail = NULL;
+	}
+
+	gve_rx_post_buffers_dqo(rx);
+
+	u64_stats_update_begin(&rx->statss);
+	rx->rpackets += work_done;
+	rx->rbytes += bytes;
+	u64_stats_update_end(&rx->statss);
 
 	return work_done;
 }
diff --git a/drivers/net/ethernet/google/gve/gve_utils.c b/drivers/net/ethernet/google/gve/gve_utils.c
index a0607a824ab9..93f3dcbeeea9 100644
--- a/drivers/net/ethernet/google/gve/gve_utils.c
+++ b/drivers/net/ethernet/google/gve/gve_utils.c
@@ -64,3 +64,18 @@ struct sk_buff *gve_rx_copy(struct net_device *dev, struct napi_struct *napi,
 	return skb;
 }
 
+void gve_dec_pagecnt_bias(struct gve_rx_slot_page_info *page_info)
+{
+	page_info->pagecnt_bias--;
+	if (page_info->pagecnt_bias == 0) {
+		int pagecount = page_count(page_info->page);
+
+		/* If we have run out of bias - set it back up to INT_MAX
+		 * minus the existing refs.
+		 */
+		page_info->pagecnt_bias = INT_MAX - pagecount;
+
+		/* Set pagecount back up to max. */
+		page_ref_add(page_info->page, INT_MAX - pagecount);
+	}
+}
diff --git a/drivers/net/ethernet/google/gve/gve_utils.h b/drivers/net/ethernet/google/gve/gve_utils.h
index 8fb39b990bbc..79595940b351 100644
--- a/drivers/net/ethernet/google/gve/gve_utils.h
+++ b/drivers/net/ethernet/google/gve/gve_utils.h
@@ -21,5 +21,8 @@ struct sk_buff *gve_rx_copy(struct net_device *dev, struct napi_struct *napi,
 			    struct gve_rx_slot_page_info *page_info, u16 len,
 			    u16 pad);
 
+/* Decrement pagecnt_bias. Set it back to INT_MAX if it reached zero. */
+void gve_dec_pagecnt_bias(struct gve_rx_slot_page_info *page_info);
+
 #endif /* _GVE_UTILS_H */
 
-- 
2.32.0.288.g62a8d224e6-goog


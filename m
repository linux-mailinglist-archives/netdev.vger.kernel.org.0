Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEE02C46F0
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 18:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732926AbgKYRjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 12:39:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731443AbgKYRjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 12:39:15 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3794C061A4F
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 09:38:56 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id b19so2210847pgm.2
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 09:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=pKvTFqLwylzdRSsxkjoCXQnvD80Q0XD+tHuPLu2w0ME=;
        b=uYqYDUuK//gWY0PyIMJDIuBAe3kND5X/6AuCPF/WN5lu369gnsvC7LBuO8JAewp1h0
         zGAHGmSDQYc/yuYMLGN4fQMIlzdNNxatns7xgJXcdLmSc9dTmWVbaqrtNia0DqNazmul
         TeSkglCWtGT2+ur+AKXDRzOdhEgXRWOLKkiQlm0nJ/nipCsN+R5J+Nyrl9HXpM9NqVtP
         ZgOHhxGoXQauF7hb98jjejLAiBdVx/W0ux/Tk6qeO1u3A/tS6zzVz1jBXAT9fQbWsr/3
         4RgxTzP3kbsETFLseTWcX2r5ftRvhi8UqGcL9tCBLpJ+6vfgpWTHvy7EtvyHdCfze4p9
         iKsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pKvTFqLwylzdRSsxkjoCXQnvD80Q0XD+tHuPLu2w0ME=;
        b=uGv0j159UnOyqeWhpihl5D3F5niOQu+X0LguaIvHnoMuV+HjQarkCwYqC2Z1Zsmb04
         9mIyD5IFvw0wI0Ejva/8PaSGjvJ8P+xkIhoYX9AktNPfb+Gscv3otqI3qcSSFM373Ggn
         sPNdINKR38Z6TtjIkBs3LAi9tGfPdO9X0JBIKoOUK9MIDh6dDuqAZ9dFQFfTzqhyYlI9
         2ur17XhUmvMi7AYoUgOdF/thapM0EQgssNIdI1om5aLMsEUHQ96eBbQ57/GB+L8mlXs2
         +BLk638BrSsYKxEAYriO84gkx8eXzIuCIdwgLB4ViCJF5rwZep/Dqtt3XQ6IFfhQyQn/
         Y32A==
X-Gm-Message-State: AOAM531eeVDnOFs60BJsb9j+fYeM8xwHihVhUWhoiRPlcG6abfuajnDZ
        mf7kElwYpMpLZtntm4Vm4boF4Yi5aHQoDnl1IdaeZfNpxOf7q9xwNbiPDH/eqscNazU7xpWmDe1
        Mo/zY9xoG1Wzln0pfAHQzqbJR0/ZDvSP2lGzBAz18vzvCcdHDFtae70aEA31vJO7INHmpINPS
X-Google-Smtp-Source: ABdhPJyannfzZ2gc/epcpVZP1nCsbBvz0CAkn6XaVIkzNdZroRj58e4xbDCuRlbRAR8kkv9B3xn+H+SEmuDRnjeo
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a65:6a13:: with SMTP id
 m19mr4052943pgu.260.1606325936126; Wed, 25 Nov 2020 09:38:56 -0800 (PST)
Date:   Wed, 25 Nov 2020 09:38:45 -0800
In-Reply-To: <20201125173846.3033449-1-awogbemila@google.com>
Message-Id: <20201125173846.3033449-4-awogbemila@google.com>
Mime-Version: 1.0
References: <20201125173846.3033449-1-awogbemila@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH net-next v8 3/4] gve: Rx Buffer Recycling
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     alexander.duyck@gmail.com, saeed@kernel.org,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch lets the driver reuse buffers that have been freed by the
networking stack.

In the raw addressing case, this allows the driver avoid allocating new
buffers.
In the qpl case, the driver can avoid copies.

Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h    |  10 +-
 drivers/net/ethernet/google/gve/gve_rx.c | 199 +++++++++++++++--------
 2 files changed, 135 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index d8bba0ba34e3..8aad4af2aa2b 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -52,6 +52,7 @@ struct gve_rx_slot_page_info {
 	struct page *page;
 	void *page_address;
 	u8 page_offset; /* flipped to second half? */
+	u8 can_flip;
 };
 
 /* A list of pages registered with the device during setup and used by a queue
@@ -502,15 +503,6 @@ static inline enum dma_data_direction gve_qpl_dma_dir(struct gve_priv *priv,
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
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 596772f5e29a..bf123fe524c4 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -279,8 +279,7 @@ static enum pkt_hash_types gve_rss_type(__be16 pkt_flags)
 	return PKT_HASH_TYPE_L2;
 }
 
-static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
-				   struct net_device *dev,
+static struct sk_buff *gve_rx_copy(struct net_device *dev,
 				   struct napi_struct *napi,
 				   struct gve_rx_slot_page_info *page_info,
 				   u16 len)
@@ -298,10 +297,6 @@ static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
 
 	skb->protocol = eth_type_trans(skb, dev);
 
-	u64_stats_update_begin(&rx->statss);
-	rx->rx_copied_pkt++;
-	u64_stats_update_end(&rx->statss);
-
 	return skb;
 }
 
@@ -330,6 +325,79 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info, __be64 *sl
 	*(slot_addr) ^= offset;
 }
 
+static bool gve_rx_can_flip_buffers(struct net_device *netdev)
+{
+	return PAGE_SIZE == 4096
+		? netdev->mtu + GVE_RX_PAD + ETH_HLEN <= PAGE_SIZE / 2 : false;
+}
+
+static int gve_rx_can_recycle_buffer(struct page *page)
+{
+	int pagecount = page_count(page);
+
+	/* This page is not being used by any SKBs - reuse */
+	if (pagecount == 1)
+		return 1;
+	/* This page is still being used by an SKB - we can't reuse */
+	else if (pagecount >= 2)
+		return 0;
+	WARN(pagecount < 1, "Pagecount should never be < 1");
+	return -1;
+}
+
+static struct sk_buff *
+gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
+		      struct gve_rx_slot_page_info *page_info, u16 len,
+		      struct napi_struct *napi,
+		      union gve_rx_data_slot *data_slot)
+{
+	struct sk_buff *skb;
+
+	skb = gve_rx_add_frags(napi, page_info, len);
+	if (!skb)
+		return NULL;
+
+	/* Optimistically stop the kernel from freeing the page by increasing
+	 * the page bias. We will check the refcount in refill to determine if
+	 * we need to alloc a new page.
+	 */
+	get_page(page_info->page);
+
+	return skb;
+}
+
+static struct sk_buff *
+gve_rx_qpl(struct device *dev, struct net_device *netdev,
+	   struct gve_rx_ring *rx, struct gve_rx_slot_page_info *page_info,
+	   u16 len, struct napi_struct *napi,
+	   union gve_rx_data_slot *data_slot)
+{
+	struct sk_buff *skb;
+
+	/* if raw_addressing mode is not enabled gvnic can only receive into
+	 * registered segments. If the buffer can't be recycled, our only
+	 * choice is to copy the data out of it so that we can return it to the
+	 * device.
+	 */
+	if (page_info->can_flip) {
+		skb = gve_rx_add_frags(napi, page_info, len);
+		/* No point in recycling if we didn't get the skb */
+		if (skb) {
+			/* Make sure that the page isn't freed. */
+			get_page(page_info->page);
+			gve_rx_flip_buff(page_info, &data_slot->qpl_offset);
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
+}
+
 static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 		   netdev_features_t feat, u32 idx)
 {
@@ -340,7 +408,6 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	union gve_rx_data_slot *data_slot;
 	struct sk_buff *skb = NULL;
 	dma_addr_t page_bus;
-	int pagecount;
 	u16 len;
 
 	/* drop this packet */
@@ -361,60 +428,37 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	dma_sync_single_for_cpu(&priv->pdev->dev, page_bus,
 				PAGE_SIZE, DMA_FROM_DEVICE);
 
-	if (PAGE_SIZE == 4096) {
-		if (len <= priv->rx_copybreak) {
-			/* Just copy small packets */
-			skb = gve_rx_copy(rx, dev, napi, page_info, len);
-			u64_stats_update_begin(&rx->statss);
-			rx->rx_copybreak_pkt++;
-			u64_stats_update_end(&rx->statss);
-			goto have_skb;
-		}
-		if (rx->data.raw_addressing) {
-			skb = gve_rx_add_frags(napi, page_info, len);
-			goto have_skb;
-		}
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
-			skb = gve_rx_add_frags(napi, page_info, len);
-			if (!skb) {
-				u64_stats_update_begin(&rx->statss);
-				rx->rx_skb_alloc_fail++;
-				u64_stats_update_end(&rx->statss);
+	if (len <= priv->rx_copybreak) {
+		/* Just copy small packets */
+		skb = gve_rx_copy(dev, napi, page_info, len);
+		u64_stats_update_begin(&rx->statss);
+		rx->rx_copied_pkt++;
+		rx->rx_copybreak_pkt++;
+		u64_stats_update_end(&rx->statss);
+	} else {
+		u8 can_flip = gve_rx_can_flip_buffers(dev);
+		int recycle = 0;
+
+		if (can_flip) {
+			recycle = gve_rx_can_recycle_buffer(page_info->page);
+			if (recycle < 0) {
+				if (!rx->data.raw_addressing)
+					gve_schedule_reset(priv);
 				return false;
 			}
-			/* Make sure the kernel stack can't release the page */
-			get_page(page_info->page);
-			/* "flip" to other packet buffer on this page */
-			gve_rx_flip_buff(page_info, &rx->data.data_ring[idx].qpl_offset);
-		} else if (pagecount >= 2) {
-			/* We have previously passed the other half of this
-			 * page up the stack, but it has not yet been freed.
-			 */
-			skb = gve_rx_copy(rx, dev, napi, page_info, len);
+		}
+
+		page_info->can_flip = can_flip && recycle;
+		if (rx->data.raw_addressing) {
+			skb = gve_rx_raw_addressing(&priv->pdev->dev, dev,
+						    page_info, len, napi,
+						    data_slot);
 		} else {
-			WARN(pagecount < 1, "Pagecount should never be < 1");
-			return false;
+			skb = gve_rx_qpl(&priv->pdev->dev, dev, rx,
+					 page_info, len, napi, data_slot);
 		}
-	} else {
-		if (rx->data.raw_addressing)
-			skb = gve_rx_add_frags(napi, page_info, len);
-		else
-			skb = gve_rx_copy(rx, dev, napi, page_info, len);
 	}
 
-have_skb:
-	/* We didn't manage to allocate an skb but we haven't had any
-	 * reset worthy failures.
-	 */
 	if (!skb) {
 		u64_stats_update_begin(&rx->statss);
 		rx->rx_skb_alloc_fail++;
@@ -467,19 +511,44 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 
 	while (fill_cnt - rx->cnt < refill_target) {
 		struct gve_rx_slot_page_info *page_info;
-		struct device *dev = &priv->pdev->dev;
-		union gve_rx_data_slot *data_slot;
 		u32 idx = fill_cnt & rx->mask;
 
 		page_info = &rx->data.page_info[idx];
-		data_slot = &rx->data.data_ring[idx];
-		gve_rx_free_buffer(dev, page_info, data_slot);
-		page_info->page = NULL;
-		if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot)) {
-			u64_stats_update_begin(&rx->statss);
-			rx->rx_buf_alloc_fail++;
-			u64_stats_update_end(&rx->statss);
-			break;
+		if (page_info->can_flip) {
+			/* The other half of the page is free because it was
+			 * free when we processed the descriptor. Flip to it.
+			 */
+			union gve_rx_data_slot *data_slot =
+						&rx->data.data_ring[idx];
+
+			gve_rx_flip_buff(page_info, &data_slot->addr);
+			page_info->can_flip = 0;
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
+				if (!rx->data.raw_addressing)
+					gve_schedule_reset(priv);
+				return false;
+			}
+			if (!recycle) {
+				/* We can't reuse the buffer - alloc a new one*/
+				union gve_rx_data_slot *data_slot =
+						&rx->data.data_ring[idx];
+				struct device *dev = &priv->pdev->dev;
+
+				gve_rx_free_buffer(dev, page_info, data_slot);
+				page_info->page = NULL;
+				if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot))
+					break;
+			}
 		}
 		fill_cnt++;
 	}
-- 
2.29.2.454.gaff20da3a2-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03AA2CC503
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 19:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbgLBSZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 13:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbgLBSZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 13:25:10 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E132CC061A04
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 10:24:23 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id h189so1920381qke.19
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 10:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=kPwdIkE2MSoeOxSqAEK0otIeCG0typk/AUPP2A3s88c=;
        b=ol7DVPd+pG6xkq0aW/5Bb2GkLSuVToLzKauryplTwrz4JuHCjBh48Gb5vpD5Ul3zrA
         W8LW4FlsXh+y46NqwECKqrNx/gnhH1CoUpSPbjBOGoLYdTw5tVhoFnbXVf0WfznWT3yW
         iMMTYFz4PHmM04Bi0e0vlFyPAMb4CnzqCsEea+pqc1iqoYmx20ptS45kmVni+BmNmRJp
         32X4eyW7fp7cQpuU9941O0HKh3Q2UpkD6TIH2am9FmsahLLrY+dru8ySiHInEmJQQBID
         72tVnc7UuaCWrQTy1InfQT+dHF4HTSKJzrFxwqcT59mVuFypgEz3l5VpLohqLmoZdcOF
         6ZJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kPwdIkE2MSoeOxSqAEK0otIeCG0typk/AUPP2A3s88c=;
        b=thE2WYCRxa28PYlVaROduWeI7CRmos8yWVkzdN7GZ+xzICFYYFz+VE779QfLDgWV6N
         AfAxAGSPu7Kwobq3s/ogIQNd5gVmgcQeusy/9csADusSlbPC3I+onvLus+Enpy9OQUv/
         iPO5LCfu06RRJhHzSUPaTjJMYRpAdZ5jPtoelGhUKtrzMqcOTZ/tVBULdweGb/Azjs1g
         ZS/FgCekIiloBQ3qY+rtnOIfHwQUd4Wq9JP/sv1YU10qENHDyiY7bdRLfBk8BARMeCzR
         FPwVVEr36VVZRza4+OV/h+t3UXNKSkCZ0Y0Ni5l4l+abZBDwIzK3nJjPBJ4HdHtQa4LN
         kxpQ==
X-Gm-Message-State: AOAM5324WMw2b8L3SiYWH42PD4GtgonJs3afmhK1DgelcDimUSHuQV75
        fnjacCZcHaYjPbKRQhsp5b7xsVVEw5fWXUYfbqf+pf0IJgF1nfLcWEsh3GJYRPHODLw8cPqcV18
        gacwY6EzZn42L+4PgYhT9BCnqonu3qxKi1S4cNSXwTxGS8NtgwbL/OoQLBv+r156teP+1qbMR
X-Google-Smtp-Source: ABdhPJyg2l/bhZjR0SW2xHDC6OEQLKSEeLO0YkCppZf7k/thh52NErll+K/Zvc3i3yggR+rmmrU0AcyMQ+bLtPL7
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:ad4:5587:: with SMTP id
 e7mr3692064qvx.33.1606933462989; Wed, 02 Dec 2020 10:24:22 -0800 (PST)
Date:   Wed,  2 Dec 2020 10:24:12 -0800
In-Reply-To: <20201202182413.232510-1-awogbemila@google.com>
Message-Id: <20201202182413.232510-4-awogbemila@google.com>
Mime-Version: 1.0
References: <20201202182413.232510-1-awogbemila@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net-next v9 3/4] gve: Rx Buffer Recycling
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     alexander.duyck@gmail.com, saeed@kernel.org,
        eric.dumazet@gmail.com, David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch lets the driver reuse buffers that have been freed by the
networking stack.

In the raw addressing case, this allows the driver avoid allocating new
buffers.
In the qpl case, the driver can avoid copies.

This patch separates the page refcount tracking mechanism
into a function gve_rx_can_recycle_buffer which uses get_page - this will
be changed in a future patch to entirely eliminate the use of get_page in
tracking page refcounts.

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
2.29.2.576.ga3fc446d84-goog


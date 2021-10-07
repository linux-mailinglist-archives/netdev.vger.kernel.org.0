Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D134257E9
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242684AbhJGQ1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242668AbhJGQ1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 12:27:35 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33185C061764
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 09:25:41 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z130-20020a256588000000b005b6b4594129so8575373ybb.15
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 09:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=q+muMcXnIK0tIvESCIwPxCzd8ymTbee320pnZSs9Jk0=;
        b=tUHNaj7uWkRfTDpD8pgyW5eYadm8yLfQ4v1/s+xFfeMX74pgw4svWRdB+XKJfFMmzj
         DJJcg6O8RNEwCsxniSDn4cPUsCfsl3l6qIsUkiYbCL4dTSq9B1clEw4eO7jhk7tQ/oG9
         bBDe07BnLWPDefa6Pfl6gxvSE8B6KXhmE8L+zuVuLWyzm7wZcCqLcY7MFBeK0eBtMoT4
         Mwk6wVrYsfGUV6lVRf7ua59ujfmE+GCM5eHCvmLU14CmJLVCreJyVp5ce71+S3EVE0Au
         6pCDRFsDoFR6Dfpotf4Dlj7fUOfok2lZUK7XJSQGFRo/UwtsA5aWBRaPYBapVsyNzRfX
         EcRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=q+muMcXnIK0tIvESCIwPxCzd8ymTbee320pnZSs9Jk0=;
        b=oKx9kpDuwuIua+VacTG5DvAmukVTEbdbv4ZCx+LTflZqBqq+t++VrbDylUvIfLDs2U
         lKGljbmtx10E+r9tep4RgIGuIHXHzclGl8DfhH7LRXhke6uLonscrv3Y994X9zJVH+qy
         SQgbq4stRZ5xMkq0UM3JDgT+/MrV7uulFKNjFsJJAuA/kZMM/DEs2XPjBJOxseIt2y/4
         UwrmiyTb/C6ftIjqWZ/xRE2owN3wF8Nuexmd4N2f4IojcQa6ydCT6kCbb4tHbdLXklX4
         WwwgxThQgpEu5JpOTbVSZHh79aRl668IhVV1xA8AmRhJcZAtJdcU09D9sb0++omhoEwN
         I67g==
X-Gm-Message-State: AOAM533habaX3wrRh/xnpuYHd8F77G/jkDUBBr1rT0NpQvQ9TkdjxZd+
        nhY2eFa2y0FKzxVcD4DZyp7AKTdwnkZ4i3BlCs9j6Ynsg3REUyrllFs0x0GLX/qNHhoovjK6LqQ
        9bguRWXeHcARXCCM4/OD9/lE1u2R98MNI/jrW/aOgzyj/HhgtgtY2M7R014lzesdl6Bo=
X-Google-Smtp-Source: ABdhPJx5ye4wjm0Ts2CGnP7N9Bt4ooLI5Ie1J0JF7znE3UJjTIwRmuOXLkqtV+GbCviYVIHMiJVDS3Ki3V++XA==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:fe55:7411:11ac:c2a7])
 (user=jeroendb job=sendgmr) by 2002:a25:6106:: with SMTP id
 v6mr5931072ybb.531.1633623940312; Thu, 07 Oct 2021 09:25:40 -0700 (PDT)
Date:   Thu,  7 Oct 2021 09:25:29 -0700
In-Reply-To: <20211007162534.1502578-1-jeroendb@google.com>
Message-Id: <20211007162534.1502578-2-jeroendb@google.com>
Mime-Version: 1.0
References: <20211007162534.1502578-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH net-next 2/7] gve: Add rx buffer pagecnt bias
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Catherine Sullivan <csully@google.com>,
        Yanchun Fu <yangchun@google.com>,
        Nathan Lewis <npl@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Add a pagecnt bias field to rx buffer info struct to eliminate
needing to increment the atomic page ref count on every pass in the
rx hotpath.

Also prefetch two packet pages ahead.

Fixes: ede3fcf5ec67f ("gve: Add support for raw addressing to the rx path")
Signed-off-by: Yanchun Fu <yangchun@google.com>
Signed-off-by: Nathan Lewis <npl@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 52 +++++++++++++++++-------
 1 file changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index bb9fc456416b..ecf5a396290b 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -16,19 +16,23 @@ static void gve_rx_free_buffer(struct device *dev,
 	dma_addr_t dma = (dma_addr_t)(be64_to_cpu(data_slot->addr) &
 				      GVE_DATA_SLOT_ADDR_PAGE_MASK);
 
+	page_ref_sub(page_info->page, page_info->pagecnt_bias - 1);
 	gve_free_page(dev, page_info->page, dma, DMA_FROM_DEVICE);
 }
 
 static void gve_rx_unfill_pages(struct gve_priv *priv, struct gve_rx_ring *rx)
 {
-	if (rx->data.raw_addressing) {
-		u32 slots = rx->mask + 1;
-		int i;
+	u32 slots = rx->mask + 1;
+	int i;
 
+	if (rx->data.raw_addressing) {
 		for (i = 0; i < slots; i++)
 			gve_rx_free_buffer(&priv->pdev->dev, &rx->data.page_info[i],
 					   &rx->data.data_ring[i]);
 	} else {
+		for (i = 0; i < slots; i++)
+			page_ref_sub(rx->data.page_info[i].page,
+				     rx->data.page_info[i].pagecnt_bias - 1);
 		gve_unassign_qpl(priv, rx->data.qpl->id);
 		rx->data.qpl = NULL;
 	}
@@ -69,6 +73,9 @@ static void gve_setup_rx_buffer(struct gve_rx_slot_page_info *page_info,
 	page_info->page_offset = 0;
 	page_info->page_address = page_address(page);
 	*slot_addr = cpu_to_be64(addr);
+	/* The page already has 1 ref */
+	page_ref_add(page, INT_MAX - 1);
+	page_info->pagecnt_bias = INT_MAX;
 }
 
 static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
@@ -293,17 +300,18 @@ static bool gve_rx_can_flip_buffers(struct net_device *netdev)
 		? netdev->mtu + GVE_RX_PAD + ETH_HLEN <= PAGE_SIZE / 2 : false;
 }
 
-static int gve_rx_can_recycle_buffer(struct page *page)
+static int gve_rx_can_recycle_buffer(struct gve_rx_slot_page_info *page_info)
 {
-	int pagecount = page_count(page);
+	int pagecount = page_count(page_info->page);
 
 	/* This page is not being used by any SKBs - reuse */
-	if (pagecount == 1)
+	if (pagecount == page_info->pagecnt_bias)
 		return 1;
 	/* This page is still being used by an SKB - we can't reuse */
-	else if (pagecount >= 2)
+	else if (pagecount > page_info->pagecnt_bias)
 		return 0;
-	WARN(pagecount < 1, "Pagecount should never be < 1");
+	WARN(pagecount < page_info->pagecnt_bias,
+	     "Pagecount should never be less than the bias.");
 	return -1;
 }
 
@@ -319,11 +327,11 @@ gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
 	if (!skb)
 		return NULL;
 
-	/* Optimistically stop the kernel from freeing the page by increasing
-	 * the page bias. We will check the refcount in refill to determine if
-	 * we need to alloc a new page.
+	/* Optimistically stop the kernel from freeing the page.
+	 * We will check again in refill to determine if we need to alloc a
+	 * new page.
 	 */
-	get_page(page_info->page);
+	gve_dec_pagecnt_bias(page_info);
 
 	return skb;
 }
@@ -346,7 +354,7 @@ gve_rx_qpl(struct device *dev, struct net_device *netdev,
 		/* No point in recycling if we didn't get the skb */
 		if (skb) {
 			/* Make sure that the page isn't freed. */
-			get_page(page_info->page);
+			gve_dec_pagecnt_bias(page_info);
 			gve_rx_flip_buff(page_info, &data_slot->qpl_offset);
 		}
 	} else {
@@ -370,8 +378,18 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	union gve_rx_data_slot *data_slot;
 	struct sk_buff *skb = NULL;
 	dma_addr_t page_bus;
+	void *va;
 	u16 len;
 
+	/* Prefetch two packet pages ahead, we will need it soon. */
+	page_info = &rx->data.page_info[(idx + 2) & rx->mask];
+	va = page_info->page_address + GVE_RX_PAD +
+		page_info->page_offset;
+
+	prefetch(page_info->page); /* Kernel page struct. */
+	prefetch(va);              /* Packet header. */
+	prefetch(va + 64);         /* Next cacheline too. */
+
 	/* drop this packet */
 	if (unlikely(rx_desc->flags_seq & GVE_RXF_ERR)) {
 		u64_stats_update_begin(&rx->statss);
@@ -402,7 +420,7 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 		int recycle = 0;
 
 		if (can_flip) {
-			recycle = gve_rx_can_recycle_buffer(page_info->page);
+			recycle = gve_rx_can_recycle_buffer(page_info);
 			if (recycle < 0) {
 				if (!rx->data.raw_addressing)
 					gve_schedule_reset(priv);
@@ -493,7 +511,7 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 			 * owns half the page it is impossible to tell which half. Either
 			 * the whole page is free or it needs to be replaced.
 			 */
-			int recycle = gve_rx_can_recycle_buffer(page_info->page);
+			int recycle = gve_rx_can_recycle_buffer(page_info);
 
 			if (recycle < 0) {
 				if (!rx->data.raw_addressing)
@@ -540,6 +558,10 @@ int gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 			   "[%d] seqno=%d rx->desc.seqno=%d\n",
 			   rx->q_num, GVE_SEQNO(desc->flags_seq),
 			   rx->desc.seqno);
+
+		/* prefetch two descriptors ahead */
+		prefetch(rx->desc.desc_ring + ((cnt + 2) & rx->mask));
+
 		dropped = !gve_rx(rx, desc, feat, idx);
 		if (!dropped) {
 			bytes += be16_to_cpu(desc->len) - GVE_RX_PAD;
-- 
2.33.0.800.g4c38ced690-goog


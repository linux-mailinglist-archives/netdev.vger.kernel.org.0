Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2351D429388
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 17:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242723AbhJKPjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 11:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239178AbhJKPi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 11:38:58 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D7EC061570
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:36:58 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x25-20020aa79199000000b0044caf0d1ba8so6463551pfa.1
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Vq5uG/mknd3C6XywCguFKo+XID2+aYDrcaX9qyydnC8=;
        b=ojMyvEJZhJcN61llFCADVI62cnjXJexdezpbbIH9rC+8Er3Yfpbw/dz7761gsHuKo8
         qAqdK3bWi1Dzxl0sDmBxZy6yeS19mZ0KMp5LBxBjmRE3hvnVIGqc3iJdKGfqBng8/E6J
         Nh6Qoq5TTnNMGSIlbtHoJNJbS06AgpW41gBrOuGYisnM6dSFVQ4jyCcskuENSfAIwsXM
         R9BNgURbaMQ3fIYuee6FKiIN9AKOc4jSLaRT7fzRBeOtrfgaRyW6DwfyX49OMeXZ12EW
         p8RlQ3PONUV4vgapgPhBkjMt8VnZw+3ZTDz+qqrmLTDUbgtOITvDik+hKwPwAh0g7LVB
         aUlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Vq5uG/mknd3C6XywCguFKo+XID2+aYDrcaX9qyydnC8=;
        b=qXXeAtfwgeXnkguGab2T8oZ89/AVhMD5569kMtQ6FMEVGJsKctTLXb0Zv2ZAw2N5PT
         IT2GFt+BENkFZBtylpmGwekOJbS50EsU4KGjK/Lm386uLtxJ/Xkk2M2wB4Vvp1DI8LCx
         k4qdkq76sJGLApNGqEoc9cXr9e5TlQhBaZVSecb5V3ZB/FJTKairDgGbgQcZsMyvnL6L
         GMC90vJC7H3gqADeD6kfmoUrgGmcaPLZIU+fl/CCLYKkc1XV++PSGtJEXtw/PSP3SV2k
         glBt6d3MNMyr+jZqumqnkZOcYDlRvGRdSGjmd+tltUpnX+oQvt/fxziJz5Wts8jUlDg4
         p8SA==
X-Gm-Message-State: AOAM531ybq2CLDITFTStuP++AudgFJqaiJteDLJWMyjZOSQ9wLfYMp/t
        9/G2XK1h14RDbG8T6eLdNM+77+FtWgSTjXl7cyHhccnjT0TcNouH6wxud7pbGEkZWxDcu2XfZR9
        bliW6r1Q5bkfhQoCNNzkuYKen7wVPXqTBp3Eb1DLdO88p/qcgm0x62eDzXAUdWI/sffY=
X-Google-Smtp-Source: ABdhPJxI4qNjY+TgPQrLIBSs9u/gTaLm5aJ0U4mHy0tW613qDeUH4CH1wVS0Ol2NtydZZOPCn05chBwNB1aUog==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:94b6:8af3:6cef:e277])
 (user=jeroendb job=sendgmr) by 2002:a62:403:0:b0:433:9582:d449 with SMTP id
 3-20020a620403000000b004339582d449mr26508220pfe.15.1633966617669; Mon, 11 Oct
 2021 08:36:57 -0700 (PDT)
Date:   Mon, 11 Oct 2021 08:36:45 -0700
In-Reply-To: <20211011153650.1982904-1-jeroendb@google.com>
Message-Id: <20211011153650.1982904-3-jeroendb@google.com>
Mime-Version: 1.0
References: <20211011153650.1982904-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH net-next v2 2/7] gve: Add rx buffer pagecnt bias
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
index 3347879a4a5d..41b21b527470 100644
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
@@ -299,17 +306,18 @@ static bool gve_rx_can_flip_buffers(struct net_device *netdev)
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
 
@@ -325,11 +333,11 @@ gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
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
@@ -352,7 +360,7 @@ gve_rx_qpl(struct device *dev, struct net_device *netdev,
 		/* No point in recycling if we didn't get the skb */
 		if (skb) {
 			/* Make sure that the page isn't freed. */
-			get_page(page_info->page);
+			gve_dec_pagecnt_bias(page_info);
 			gve_rx_flip_buff(page_info, &data_slot->qpl_offset);
 		}
 	} else {
@@ -376,8 +384,18 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
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
@@ -408,7 +426,7 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 		int recycle = 0;
 
 		if (can_flip) {
-			recycle = gve_rx_can_recycle_buffer(page_info->page);
+			recycle = gve_rx_can_recycle_buffer(page_info);
 			if (recycle < 0) {
 				if (!rx->data.raw_addressing)
 					gve_schedule_reset(priv);
@@ -499,7 +517,7 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 			 * owns half the page it is impossible to tell which half. Either
 			 * the whole page is free or it needs to be replaced.
 			 */
-			int recycle = gve_rx_can_recycle_buffer(page_info->page);
+			int recycle = gve_rx_can_recycle_buffer(page_info);
 
 			if (recycle < 0) {
 				if (!rx->data.raw_addressing)
@@ -546,6 +564,10 @@ static int gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
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
2.33.0.882.g93a45727a2-goog

v2: Unchanged

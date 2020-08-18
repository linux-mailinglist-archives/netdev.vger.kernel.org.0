Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38317248EEF
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgHRTp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgHRTpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:45:08 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE40C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:45:08 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c2so12754208plo.11
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=bazRyaRpd4lWfsnoRkwrFUpyZkBuL3CvZya3DQ/BzgQ=;
        b=lmDHXC0heFriXuxprlGxsC7r4Hr++kBsEsJI06sFg4I4QnhIUIhWgZOmpv8T5eHs5i
         YlgmGHGYZiKY0eYTKrCpRWitqgf+djv9iEKH+xodIPgZRpheFpT+1W9sfRIWmEuZk93M
         Q5zfN0PnEryEgF8iv5mZEg/Cq2J4ABpxrZ9SeHPqd4iGbVrCjIrZgbsZUfUGL93T0yQG
         a3VeEsIb6ES2K7PNfykHpHoQoyqn9FT8QiS33bSYRswca8eaxD/rudhVSMSoQ6o+nLfs
         HWhZJCCvPxl8VtIaAnAyOvC+WCyg+yyvOitE/LTf8re6fzR1QU9S/0c37apcHG6RA4cO
         8/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bazRyaRpd4lWfsnoRkwrFUpyZkBuL3CvZya3DQ/BzgQ=;
        b=rkSCTTwPxmBMauFGK9gQZ8m6dQy6amy1mctIZDbDR6Rf2Yhux1Yg5uODRH6TewIuO2
         Q9+Y3EQPX8Hyjt6Muwz73HYUwT3hAMKpj4OD4xsYxEkTr67rAE/fOZHZHGrtIPvwAzqM
         vqh6zSXOhrR7R8x5DpF/7d1mtKuzuhSbWyVOjuRoOJSaqn1O8UWEG/GurwhbYnC9UA/s
         7x3IWXwl/oJBXaaKRRDP/SThejoslic/2yP3X4yTs6i4swe0Af2IT8Zx4eg9pS1Tbpii
         dC41dF5praYwVprcshXSp8AzbX7IrgeWwEkvFVP3h0FifakXVTcPole9K9OX/zExjAsB
         0+dw==
X-Gm-Message-State: AOAM531f4lnrrxEpzaLHwD+veR6GmQgx5PAIQ6Irl+3JRwwCFKBWl2Om
        agSaTZE85wu6YtPqAXBywmXUPqflpXN4bymSuAafNsmnzonE+xUHSNR3FZviTz6Uq2wWpxfRfLe
        T89pcJ4dBTUjithL64ujd+vR8tGG6xOLbN3AhNgRMS2F39K03Wwv88/lDS5db8xIzdze07slO
X-Google-Smtp-Source: ABdhPJwI4lelUW+6oq2KVUEMf5qI2XMymUVEJqnwnZr/Ic3MHT77dmerFSpkMKz6seQpQcndBtgnWTbZQsWaljZl
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:90a:c591:: with SMTP id
 l17mr1173159pjt.17.1597779907758; Tue, 18 Aug 2020 12:45:07 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:44:12 -0700
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
Message-Id: <20200818194417.2003932-14-awogbemila@google.com>
Mime-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 13/18] gve: Add rx buffer pagecnt bias.
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Add a pagecnt bias field to rx buffer info struct to eliminate
needing to increment the atomic page ref count on every pass in the
rx hotpath.

We now keep track of whether the nic has the only reference to a page
by decrementing the bias instead of incrementing the atomic page ref
count, which could be expensive.
If the bias is equal to the pagecount, then the nic has the only
reference to that page. But, if the bias is less than the page count,
the networking stack is still using the page.
The pagecount should never be less than the bias.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h    |  1 +
 drivers/net/ethernet/google/gve/gve_rx.c | 47 ++++++++++++++++++------
 2 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index c0f0b22c1ec0..8b1773c45cb6 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -50,6 +50,7 @@ struct gve_rx_slot_page_info {
 	struct page *page;
 	void *page_address;
 	u32 page_offset; /* offset to write to in page */
+	int pagecnt_bias; /* expected pagecnt if only the driver has a ref */
 	bool can_flip; /* page can be flipped and reused */
 };
 
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index ca12f267d08a..c65615b9e602 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -23,6 +23,7 @@ static void gve_rx_free_buffer(struct device *dev,
 	dma_addr_t dma = (dma_addr_t)(be64_to_cpu(data_slot->addr) -
 				      page_info->page_offset);
 
+	page_ref_sub(page_info->page, page_info->pagecnt_bias - 1);
 	gve_free_page(dev, page_info->page, dma, DMA_FROM_DEVICE);
 }
 
@@ -70,6 +71,9 @@ static void gve_setup_rx_buffer(struct gve_rx_slot_page_info *page_info,
 	page_info->page_offset = 0;
 	page_info->page_address = page_address(page);
 	slot->addr = cpu_to_be64(addr);
+
+	set_page_count(page, INT_MAX);
+	page_info->pagecnt_bias = INT_MAX;
 }
 
 static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
@@ -347,21 +351,40 @@ static bool gve_rx_can_flip_buffers(struct net_device *netdev)
 #endif
 }
 
-static int gve_rx_can_recycle_buffer(struct page *page)
+static int gve_rx_can_recycle_buffer(struct gve_rx_slot_page_info *page_info)
 {
-	int pagecount = page_count(page);
+	int pagecount = page_count(page_info->page);
 
 	/* This page is not being used by any SKBs - reuse */
-	if (pagecount == 1) {
+	if (pagecount == page_info->pagecnt_bias) {
 		return 1;
 	/* This page is still being used by an SKB - we can't reuse */
-	} else if (pagecount >= 2) {
+	} else if (pagecount > page_info->pagecnt_bias) {
 		return 0;
 	}
-	WARN(pagecount < 1, "Pagecount should never be < 1");
+	WARN(pagecount < page_info->pagecnt_bias, "Pagecount should never be less than the bias.");
 	return -1;
 }
 
+/* Update page reference not by incrementing the page count, but by
+ * decrementing the "bias" offset from page_count that determines
+ * whether the nic has the only reference.
+ */
+static void gve_rx_update_pagecnt_bias(struct gve_rx_slot_page_info *page_info)
+{
+	page_info->pagecnt_bias--;
+	if (page_info->pagecnt_bias == 0) {
+		int pagecount = page_count(page_info->page);
+
+		/* If we have run out of bias - set it back up to INT_MAX
+		 * minus the existing refs.
+		 */
+		page_info->pagecnt_bias = INT_MAX - (pagecount);
+		/* Set pagecount back up to max */
+		set_page_count(page_info->page, INT_MAX);
+	}
+}
+
 static struct sk_buff *
 gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
 		      struct gve_rx_slot_page_info *page_info, u16 len,
@@ -373,11 +396,11 @@ gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
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
+	gve_rx_update_pagecnt_bias(page_info);
 	page_info->can_flip = can_flip;
 
 	return skb;
@@ -400,7 +423,7 @@ gve_rx_qpl(struct device *dev, struct net_device *netdev,
 		/* No point in recycling if we didn't get the skb */
 		if (skb) {
 			/* Make sure the networking stack can't free the page */
-			get_page(page_info->page);
+			gve_rx_update_pagecnt_bias(page_info);
 			gve_rx_flip_buffer(page_info, data_slot);
 		}
 	} else {
@@ -458,7 +481,7 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 		int recycle = 0;
 
 		if (can_flip) {
-			recycle = gve_rx_can_recycle_buffer(page_info->page);
+			recycle = gve_rx_can_recycle_buffer(page_info);
 			if (recycle < 0) {
 				gve_schedule_reset(priv);
 				return false;
@@ -548,7 +571,7 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 			 * owns half the page it is impossible to tell which half. Either
 			 * the whole page is free or it needs to be replaced.
 			 */
-			int recycle = gve_rx_can_recycle_buffer(page_info->page);
+			int recycle = gve_rx_can_recycle_buffer(page_info);
 
 			if (recycle < 0) {
 				gve_schedule_reset(priv);
-- 
2.28.0.220.ged08abb693-goog


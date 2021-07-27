Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899B53D7C6C
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhG0Rnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhG0Rnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:43:49 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E7CC061765
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:49 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so5402471pjb.3
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=y7buWIGbj5gLeiQ4crzTWmYKGUE3U+OhNl6z+D6MrLk=;
        b=blu0dh0IwwEkwrI8ygnOvU1UarDDdba2tnbbos/COedHdxkh+/lyuNp51IgPKEK3K4
         HCR9LkpglTjeyMP8tTTPxIyOmv5CofzOlU3unrYzb9r5q/c3n0txmYu9do9iCUW/XnJm
         NqNNARPRxyyrs2d7gPaWdx5FT/P3txsiJxYG+BBvhYc2n/CivgSH+Zc3JD49z6Sw+ntc
         Rdcu9VzioDOP8PukaqCRSyH8J8+Nf6mwKuxSD08JBc+HyjyDa7Y7xLJ7Zvrhrs/zO0Jc
         Byt/PWDTDvjbpCnhyaO3xwNw0nWyPxiJndIb0Szek889YMmd0P/0KIelDAs0N7uS6p9+
         DP2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y7buWIGbj5gLeiQ4crzTWmYKGUE3U+OhNl6z+D6MrLk=;
        b=TsuT9foF5BoTMwOFtAxiNLIG8dzHfm8Nz0ygUL1xgj+8oMo7EFNK+lQKOrw/92vSUe
         xCii106cEhG8+1z6/b+sBUpFXbt2HXxckA53P/wB6C+F8Sx3CzB+8DhQ5/xDXi6bDb9n
         NAnfjn71+3oMJMe2r8Psv9UdbpxSY1yHQjpC8RhKZyai8U6fpt5+C9Clr/RlpN359Bc2
         dnB6J/v3/BL/f16Xk4OuMqtyGdqgiq1uz8lkVtIoMQHNSYuWNkLrO3Z2awa3zUeizqgy
         CgoFHgjJjOF6rSD32J4PKAmvUuE8ZkdCNJ+LhJht1P2R6PNJq6IWa9EHWSOKuaz+LXE9
         e3sg==
X-Gm-Message-State: AOAM531c4R1oeryAHD/plJ7tBDHFpveSm+q2OG81O8G4Nvq3uZDrVXNa
        QN/FN9LB/0IBRHsTF50G8yTEiQ==
X-Google-Smtp-Source: ABdhPJwuU+1iTxZ1PPhGJKDHe0fZehhHslBmbQss7Yr3v+qauBJtHcoGT83/dIX922rORqLnrbsW/g==
X-Received: by 2002:a17:902:ec8b:b029:12c:41b1:5821 with SMTP id x11-20020a170902ec8bb029012c41b15821mr4565822plg.49.1627407828721;
        Tue, 27 Jul 2021 10:43:48 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t9sm4671944pgc.81.2021.07.27.10.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:43:48 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 05/10] ionic: use fewer inits on the buf_info struct
Date:   Tue, 27 Jul 2021 10:43:29 -0700
Message-Id: <20210727174334.67931-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727174334.67931-1-snelson@pensando.io>
References: <20210727174334.67931-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on Alex's review notes on [1], we don't need to write
to the buf_info elements as often, and can tighten up how they
are used.  Also, use prefetchw() to warm up the page struct
for a later get_page().

[1] https://lore.kernel.org/netdev/CAKgT0UfyjoAN7LTnq0NMZfXRv4v7iTCPyAb9pVr3qWMhop_BVw@mail.gmail.com/

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 27 ++++++++-----------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 08934888575c..2ba19246d763 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -32,19 +32,13 @@ static inline struct netdev_queue *q_to_ndq(struct ionic_queue *q)
 	return netdev_get_tx_queue(q->lif->netdev, q->index);
 }
 
-static void ionic_rx_buf_reset(struct ionic_buf_info *buf_info)
-{
-	buf_info->page = NULL;
-	buf_info->page_offset = 0;
-	buf_info->dma_addr = 0;
-}
-
 static int ionic_rx_page_alloc(struct ionic_queue *q,
 			       struct ionic_buf_info *buf_info)
 {
 	struct net_device *netdev = q->lif->netdev;
 	struct ionic_rx_stats *stats;
 	struct device *dev;
+	struct page *page;
 
 	dev = q->dev;
 	stats = q_to_rx_stats(q);
@@ -55,26 +49,27 @@ static int ionic_rx_page_alloc(struct ionic_queue *q,
 		return -EINVAL;
 	}
 
-	buf_info->page = alloc_pages(IONIC_PAGE_GFP_MASK, 0);
-	if (unlikely(!buf_info->page)) {
+	page = alloc_pages(IONIC_PAGE_GFP_MASK, 0);
+	if (unlikely(!page)) {
 		net_err_ratelimited("%s: %s page alloc failed\n",
 				    netdev->name, q->name);
 		stats->alloc_err++;
 		return -ENOMEM;
 	}
-	buf_info->page_offset = 0;
 
-	buf_info->dma_addr = dma_map_page(dev, buf_info->page, buf_info->page_offset,
+	buf_info->dma_addr = dma_map_page(dev, page, 0,
 					  IONIC_PAGE_SIZE, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(dev, buf_info->dma_addr))) {
-		__free_pages(buf_info->page, 0);
-		ionic_rx_buf_reset(buf_info);
+		__free_pages(page, 0);
 		net_err_ratelimited("%s: %s dma map failed\n",
 				    netdev->name, q->name);
 		stats->dma_map_err++;
 		return -EIO;
 	}
 
+	buf_info->page = page;
+	buf_info->page_offset = 0;
+
 	return 0;
 }
 
@@ -95,7 +90,7 @@ static void ionic_rx_page_free(struct ionic_queue *q,
 
 	dma_unmap_page(dev, buf_info->dma_addr, IONIC_PAGE_SIZE, DMA_FROM_DEVICE);
 	__free_pages(buf_info->page, 0);
-	ionic_rx_buf_reset(buf_info);
+	buf_info->page = NULL;
 }
 
 static bool ionic_rx_buf_recycle(struct ionic_queue *q,
@@ -139,7 +134,7 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
 	buf_info = &desc_info->bufs[0];
 	len = le16_to_cpu(comp->len);
 
-	prefetch(buf_info->page);
+	prefetchw(buf_info->page);
 
 	skb = napi_get_frags(&q_to_qcq(q)->napi);
 	if (unlikely(!skb)) {
@@ -170,7 +165,7 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
 		if (!ionic_rx_buf_recycle(q, buf_info, frag_len)) {
 			dma_unmap_page(dev, buf_info->dma_addr,
 				       IONIC_PAGE_SIZE, DMA_FROM_DEVICE);
-			ionic_rx_buf_reset(buf_info);
+			buf_info->page = NULL;
 		}
 
 		buf_info++;
-- 
2.17.1


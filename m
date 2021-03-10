Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E243347E4
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbhCJT12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbhCJT1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 14:27:01 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD56CC061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:27:01 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 16so11279785pfn.5
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oIYrqPmVh2Qtcudq6hO8iojq6BjddUm3Q+sDfmXLBbM=;
        b=ZLlmU8hAFH8DycurwdxZUIBfgJl7vmAJ42eHK0fCrtS1RQfXdIMOY0xGAPJabXZbuo
         SrHeIP2L8529YdOtYQeQ/fldCxxYv9tGOd5PdpTfx/W2IAgoQOn5jVBEJOwIejS/GYGk
         Ll3r5lmUxKbAyGSBs2gye69INC689Y+f5tQW3gqFHvkGZhpHcI1NwdAQfnbx94FMreHW
         /sPbJx+RkSD/yx6hrENjjluQbB3rUSKuw1oxBoZlFGgr1jWHtKV10igrPw/cp4vwLxBs
         yb0+DU9gfwWS1rg3xO+bQXlkyhbFrVYCJW8G8PO8CypqVf66ujxYjQynlUgV4up0Ymd+
         wQcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oIYrqPmVh2Qtcudq6hO8iojq6BjddUm3Q+sDfmXLBbM=;
        b=dA74rxoPpyGHBbYeS+aOWL1Ecl3NDYMOXrPi4H6l4J1plM4Q7ooJ0BrvciUoaI+uc7
         /HodBLYZLlmsRZ8qbnivoAibGP8eCOw9xLoSGCF/fK049LcAuDwlJ63bVZPmIRJ+OXDx
         O2AEme0qfemynoLoRmFPcA/PeEy5RRX2WKAAbpEPCqzctA/OkKt83QXLtqBi3ax+FCze
         JE+J+jU5/qZI1BG2EoVuY+cM+HZcEfdVK2bxrM3pZyJSSW4ehQi2kSe63jMNZuIV0NIf
         lTo2Cv0XnDwUZMUuIizso4L4vvx6aRGogy4/0Axw8FJ+Zl6Fq5QfKYscePr3ghWxE2pe
         bepw==
X-Gm-Message-State: AOAM532auT8Yxsyf037OpRS+1o1RQJAiQgHv78tvJztDjYSxM59emNMY
        y5JIfqYNf+0B+VB1+sngCZwXzJc3Iq7trQ==
X-Google-Smtp-Source: ABdhPJwXVFnAjIFVqSMenMcWLeZgSpEBoEZPhadVw+PgaFjRfDzbfI/aacX8nGh87gKeyHZa0kN/lw==
X-Received: by 2002:a63:fc07:: with SMTP id j7mr4071791pgi.401.1615404421123;
        Wed, 10 Mar 2021 11:27:01 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 12sm306393pgw.18.2021.03.10.11.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 11:27:00 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/6] ionic: move rx_page_alloc and free
Date:   Wed, 10 Mar 2021 11:26:26 -0800
Message-Id: <20210310192631.20022-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210310192631.20022-1-snelson@pensando.io>
References: <20210310192631.20022-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move ionic_rx_page_alloc() and ionic_rx_page_free() to earlier
in the file to make the next patch easier to review.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 140 +++++++++---------
 1 file changed, 70 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 162a1ff1e9d2..70b997f302ac 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -66,6 +66,76 @@ static struct sk_buff *ionic_rx_skb_alloc(struct ionic_queue *q,
 	return skb;
 }
 
+static int ionic_rx_page_alloc(struct ionic_queue *q,
+			       struct ionic_page_info *page_info)
+{
+	struct ionic_lif *lif = q->lif;
+	struct ionic_rx_stats *stats;
+	struct net_device *netdev;
+	struct device *dev;
+
+	netdev = lif->netdev;
+	dev = lif->ionic->dev;
+	stats = q_to_rx_stats(q);
+
+	if (unlikely(!page_info)) {
+		net_err_ratelimited("%s: %s invalid page_info in alloc\n",
+				    netdev->name, q->name);
+		return -EINVAL;
+	}
+
+	page_info->page = dev_alloc_page();
+	if (unlikely(!page_info->page)) {
+		net_err_ratelimited("%s: %s page alloc failed\n",
+				    netdev->name, q->name);
+		stats->alloc_err++;
+		return -ENOMEM;
+	}
+
+	page_info->dma_addr = dma_map_page(dev, page_info->page, 0, PAGE_SIZE,
+					   DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(dev, page_info->dma_addr))) {
+		put_page(page_info->page);
+		page_info->dma_addr = 0;
+		page_info->page = NULL;
+		net_err_ratelimited("%s: %s dma map failed\n",
+				    netdev->name, q->name);
+		stats->dma_map_err++;
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void ionic_rx_page_free(struct ionic_queue *q,
+			       struct ionic_page_info *page_info)
+{
+	struct ionic_lif *lif = q->lif;
+	struct net_device *netdev;
+	struct device *dev;
+
+	netdev = lif->netdev;
+	dev = lif->ionic->dev;
+
+	if (unlikely(!page_info)) {
+		net_err_ratelimited("%s: %s invalid page_info in free\n",
+				    netdev->name, q->name);
+		return;
+	}
+
+	if (unlikely(!page_info->page)) {
+		net_err_ratelimited("%s: %s invalid page in free\n",
+				    netdev->name, q->name);
+		return;
+	}
+
+	dma_unmap_page(dev, page_info->dma_addr, PAGE_SIZE, DMA_FROM_DEVICE);
+
+	put_page(page_info->page);
+	page_info->dma_addr = 0;
+	page_info->page = NULL;
+}
+
 static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
 				      struct ionic_desc_info *desc_info,
 				      struct ionic_cq_info *cq_info)
@@ -253,76 +323,6 @@ static bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 	return true;
 }
 
-static int ionic_rx_page_alloc(struct ionic_queue *q,
-			       struct ionic_page_info *page_info)
-{
-	struct ionic_lif *lif = q->lif;
-	struct ionic_rx_stats *stats;
-	struct net_device *netdev;
-	struct device *dev;
-
-	netdev = lif->netdev;
-	dev = lif->ionic->dev;
-	stats = q_to_rx_stats(q);
-
-	if (unlikely(!page_info)) {
-		net_err_ratelimited("%s: %s invalid page_info in alloc\n",
-				    netdev->name, q->name);
-		return -EINVAL;
-	}
-
-	page_info->page = dev_alloc_page();
-	if (unlikely(!page_info->page)) {
-		net_err_ratelimited("%s: %s page alloc failed\n",
-				    netdev->name, q->name);
-		stats->alloc_err++;
-		return -ENOMEM;
-	}
-
-	page_info->dma_addr = dma_map_page(dev, page_info->page, 0, PAGE_SIZE,
-					   DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(dev, page_info->dma_addr))) {
-		put_page(page_info->page);
-		page_info->dma_addr = 0;
-		page_info->page = NULL;
-		net_err_ratelimited("%s: %s dma map failed\n",
-				    netdev->name, q->name);
-		stats->dma_map_err++;
-		return -EIO;
-	}
-
-	return 0;
-}
-
-static void ionic_rx_page_free(struct ionic_queue *q,
-			       struct ionic_page_info *page_info)
-{
-	struct ionic_lif *lif = q->lif;
-	struct net_device *netdev;
-	struct device *dev;
-
-	netdev = lif->netdev;
-	dev = lif->ionic->dev;
-
-	if (unlikely(!page_info)) {
-		net_err_ratelimited("%s: %s invalid page_info in free\n",
-				    netdev->name, q->name);
-		return;
-	}
-
-	if (unlikely(!page_info->page)) {
-		net_err_ratelimited("%s: %s invalid page in free\n",
-				    netdev->name, q->name);
-		return;
-	}
-
-	dma_unmap_page(dev, page_info->dma_addr, PAGE_SIZE, DMA_FROM_DEVICE);
-
-	put_page(page_info->page);
-	page_info->dma_addr = 0;
-	page_info->page = NULL;
-}
-
 void ionic_rx_fill(struct ionic_queue *q)
 {
 	struct net_device *netdev = q->lif->netdev;
-- 
2.17.1


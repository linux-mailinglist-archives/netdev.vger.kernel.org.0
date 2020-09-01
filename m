Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3492259E05
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730485AbgIASVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730152AbgIASUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:20:34 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCB4C061245
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 11:20:32 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id nv17so1037786pjb.3
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 11:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/YhURs6thIRKQENuEmMUz6hEKmtfEBpZ2ukYj2UWP5c=;
        b=GbGrKgDtG4dfFfsPFw11x5/iiMA2l/sj2RjNniXXfjhFSDLz6WQ8kamnOGMbZ5ol5L
         V96oA1KII23vYWGH0ODsCx7Ja1rm9i4rIxS9jloYzTNeJxwZIJByITjIJE899nWRyHhV
         srjd5ocP/m25w1MFq09vrCwgP5s6Qh+EA1LG6ScQUdFOLVyTgh8cqxExMeHy26AiYonh
         cWbUBDZbHV5CLHMX07r7Ji/arhIYUtR+m45FW+fJ1EMmiaWChIKm4xhmBfSOdJfNeSWX
         WFEhL3m1vnCI/F3Ve59Y6YTkQkF4/Hu2OPUAmY+2iuttmC66tSe90F45bZMPSwG1Dxiw
         a21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/YhURs6thIRKQENuEmMUz6hEKmtfEBpZ2ukYj2UWP5c=;
        b=U2M57VFObKkZ2vU+KVqCd46eeaSsFpjOdv9lmHiw8NiZukGlawC01DnVbgPZpF3MHS
         h0/SD0zGYN/Lb/wt5ned1+oTNDloFOOJzV2qqUsIqqbuRXTMn0JxSRlWEtM3r+Z2gwKe
         CLcYssKRhOt85Tp5D0qvlcUkuexZI/k+3SPF0d4UKjjxis8nSLFaPMVtG78vRdC+ReUy
         0oWDVDzN8Mx03t+Xpl0Q/TJXcpCpp7c/Ii+41jgZFx0w1oy9x3ELx/O1+hdIYVoSqV/h
         isqWbW90mZd8jdVxgTzn6jhP7U61JTtxCUi2r3zkXSPD+xqyJ/ZbUEiWSdBf50rYOEVK
         SQkw==
X-Gm-Message-State: AOAM531gtfNFe4prLEkksSaNC1m8NfguIjcv/mNlxspo/DDLnnwqT2lx
        RNPlFy4W24YErlMGud1nIbjPxzflGDQnUQ==
X-Google-Smtp-Source: ABdhPJwY2qm2/RgjQ03NcAzzhw/33KzVBhoz/16xrU5GHOTCsA9jytuic9pXUXiKscR/MoHHLnfKxQ==
X-Received: by 2002:a17:902:8690:: with SMTP id g16mr2549832plo.257.1598984431929;
        Tue, 01 Sep 2020 11:20:31 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id j81sm2747086pfd.213.2020.09.01.11.20.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 11:20:31 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 1/6] ionic: clean up page handling code
Date:   Tue,  1 Sep 2020 11:20:19 -0700
Message-Id: <20200901182024.64101-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200901182024.64101-1-snelson@pensando.io>
References: <20200901182024.64101-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The internal page handling can be cleaned up by passing our
local page struct rather than dma addresses, and by putting
more of the mgmt code into the alloc and free routines.

Co-developed-by: Neel Patel <neel@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 71 +++++++++++--------
 1 file changed, 40 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index c3291decd4c3..bbc926bc3852 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -266,40 +266,49 @@ void ionic_rx_flush(struct ionic_cq *cq)
 				   work_done, IONIC_INTR_CRED_RESET_COALESCE);
 }
 
-static struct page *ionic_rx_page_alloc(struct ionic_queue *q,
-					dma_addr_t *dma_addr)
+static int ionic_rx_page_alloc(struct ionic_queue *q,
+			       struct ionic_page_info *page_info)
 {
 	struct ionic_lif *lif = q->lif;
 	struct ionic_rx_stats *stats;
 	struct net_device *netdev;
 	struct device *dev;
-	struct page *page;
 
 	netdev = lif->netdev;
 	dev = lif->ionic->dev;
 	stats = q_to_rx_stats(q);
-	page = alloc_page(GFP_ATOMIC);
-	if (unlikely(!page)) {
-		net_err_ratelimited("%s: Page alloc failed on %s!\n",
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
 				    netdev->name, q->name);
 		stats->alloc_err++;
-		return NULL;
+		return -ENOMEM;
 	}
 
-	*dma_addr = dma_map_page(dev, page, 0, PAGE_SIZE, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(dev, *dma_addr))) {
-		__free_page(page);
-		net_err_ratelimited("%s: DMA single map failed on %s!\n",
+	page_info->dma_addr = dma_map_page(dev, page_info->page, 0, PAGE_SIZE,
+					   DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(dev, page_info->dma_addr))) {
+		put_page(page_info->page);
+		page_info->dma_addr = 0;
+		page_info->page = NULL;
+		net_err_ratelimited("%s: %s dma map failed\n",
 				    netdev->name, q->name);
 		stats->dma_map_err++;
-		return NULL;
+		return -EIO;
 	}
 
-	return page;
+	return 0;
 }
 
-static void ionic_rx_page_free(struct ionic_queue *q, struct page *page,
-			       dma_addr_t dma_addr)
+static void ionic_rx_page_free(struct ionic_queue *q,
+			       struct ionic_page_info *page_info)
 {
 	struct ionic_lif *lif = q->lif;
 	struct net_device *netdev;
@@ -308,15 +317,23 @@ static void ionic_rx_page_free(struct ionic_queue *q, struct page *page,
 	netdev = lif->netdev;
 	dev = lif->ionic->dev;
 
-	if (unlikely(!page)) {
-		net_err_ratelimited("%s: Trying to free unallocated buffer on %s!\n",
+	if (unlikely(!page_info)) {
+		net_err_ratelimited("%s: %s invalid page_info in free\n",
 				    netdev->name, q->name);
 		return;
 	}
 
-	dma_unmap_page(dev, dma_addr, PAGE_SIZE, DMA_FROM_DEVICE);
+	if (unlikely(!page_info->page)) {
+		net_err_ratelimited("%s: %s invalid page in free\n",
+				    netdev->name, q->name);
+		return;
+	}
 
-	__free_page(page);
+	dma_unmap_page(dev, page_info->dma_addr, PAGE_SIZE, DMA_FROM_DEVICE);
+
+	put_page(page_info->page);
+	page_info->dma_addr = 0;
+	page_info->page = NULL;
 }
 
 void ionic_rx_fill(struct ionic_queue *q)
@@ -352,8 +369,7 @@ void ionic_rx_fill(struct ionic_queue *q)
 		desc->opcode = (nfrags > 1) ? IONIC_RXQ_DESC_OPCODE_SG :
 					      IONIC_RXQ_DESC_OPCODE_SIMPLE;
 		desc_info->npages = nfrags;
-		page_info->page = ionic_rx_page_alloc(q, &page_info->dma_addr);
-		if (unlikely(!page_info->page)) {
+		if (unlikely(ionic_rx_page_alloc(q, page_info))) {
 			desc->addr = 0;
 			desc->len = 0;
 			return;
@@ -370,8 +386,7 @@ void ionic_rx_fill(struct ionic_queue *q)
 				continue;
 
 			sg_elem = &sg_desc->elems[j];
-			page_info->page = ionic_rx_page_alloc(q, &page_info->dma_addr);
-			if (unlikely(!page_info->page)) {
+			if (unlikely(ionic_rx_page_alloc(q, page_info))) {
 				sg_elem->addr = 0;
 				sg_elem->len = 0;
 				return;
@@ -409,14 +424,8 @@ void ionic_rx_empty(struct ionic_queue *q)
 		desc->addr = 0;
 		desc->len = 0;
 
-		for (i = 0; i < desc_info->npages; i++) {
-			if (likely(desc_info->pages[i].page)) {
-				ionic_rx_page_free(q, desc_info->pages[i].page,
-						   desc_info->pages[i].dma_addr);
-				desc_info->pages[i].page = NULL;
-				desc_info->pages[i].dma_addr = 0;
-			}
-		}
+		for (i = 0; i < desc_info->npages; i++)
+			ionic_rx_page_free(q, &desc_info->pages[i]);
 
 		desc_info->cb_arg = NULL;
 		idx = (idx + 1) & (q->num_descs - 1);
-- 
2.17.1


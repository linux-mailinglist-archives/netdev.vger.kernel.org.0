Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6099F258472
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 01:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgHaXgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 19:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgHaXgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 19:36:08 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD540C061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:36:07 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id z15so4005681plo.7
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0GsUkwyyePTcF4PM1YP9+SkZY0LA0X782tp1AILmXhQ=;
        b=1o0LAynkMylle0iW3W5y+KgNFUF1LTHikHIp9gpg5GqtQtmXaE297QqKnFHcZ8Ot+i
         YJUk0816ckvQCb0a1DspN9+A/HK+fzNgf4XY3BA/cwNdYTWyMh6wlJYNU1kMs7ujwp/Z
         hCpwFEl3Gj0Lzawpaj+SjrxUlabaCjRizd7n0uePfnA1VUEQY5/hODleFVl5nAfQZljL
         mRFgSIQJzpp4E+GFLwBS6/qTwO+sFuuvStBCMzMmSmsZUn0cTukXtDo3zVKickqyXUbz
         8Q5VrUxRkmZOS6xLMrYaJlyM2H+NiUmdGeVCmivkI0069n1JHTEW4uQ6WqhH7zpVhlIW
         7XKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0GsUkwyyePTcF4PM1YP9+SkZY0LA0X782tp1AILmXhQ=;
        b=ZwBT8wzavamDmWUB1kCYAb/3/QDRjCz4m4xF5t3/gPEPfijCAujMC6GppdHnaC67lw
         bmc4wEr9OZ59xuKWPBVt0O13wYnoNsb7a4bXrV0o14HD+zPi2n+y3K0vQZ+23rJcbMrp
         tncAWVjX6QUEHD4PzTbsqn4dwUO2YvP7O5Vn2DAyprLcgB+ppKmZqYaC630U7o7wdmL+
         8nkwWZO++hR6mM/KbfzluEzMuE7aiZhzb6HgRtB9xNcNFG4PhpfejWvQuYBpZkf/Rxdj
         kGia0lmq2pFfEz5zeBDeNw3Xrl/1fuMQyVGOPI+w5OnIL2wfwiOahHvtF4UxNqx9AxWi
         BwAA==
X-Gm-Message-State: AOAM532e1eHxyWozR7BbJ6ySdAEGofCvF5+G+5yAP5ie2l0YKDfyiPK4
        tQcBoeS21zrB2lJ1dKieXosFpaf9QzVvnw==
X-Google-Smtp-Source: ABdhPJxsuZU+07/2FJcqyS+96AbxZOhlhuEvss63ZxxM6Jr2Rb7ez6Hy2i8MyXrTf5ooKAByHXRAiQ==
X-Received: by 2002:a17:90a:8d05:: with SMTP id c5mr1505754pjo.222.1598916967144;
        Mon, 31 Aug 2020 16:36:07 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 65sm9082651pfx.104.2020.08.31.16.36.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 Aug 2020 16:36:06 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>, Neel Patel <neel@pensando.io>
Subject: [PATCH net-next 1/5] ionic: clean up page handling code
Date:   Mon, 31 Aug 2020 16:35:54 -0700
Message-Id: <20200831233558.71417-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200831233558.71417-1-snelson@pensando.io>
References: <20200831233558.71417-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The internal page handling can be cleaned up by passing our
local page struct rather than dma addresses, and by putting
more of the mgmt code into the alloc and free routines.

Signed-off-by: Neel Patel <neel@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 73 +++++++++++--------
 1 file changed, 42 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index c3291decd4c3..efc02b366e73 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -100,6 +100,8 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
 		frag_len = min(len, (u16)PAGE_SIZE);
 		len -= frag_len;
 
+		dma_sync_single_for_cpu(dev, dma_unmap_addr(page_info, dma_addr),
+					len, DMA_FROM_DEVICE);
 		dma_unmap_page(dev, dma_unmap_addr(page_info, dma_addr),
 			       PAGE_SIZE, DMA_FROM_DEVICE);
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
@@ -266,40 +268,49 @@ void ionic_rx_flush(struct ionic_cq *cq)
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
@@ -308,15 +319,23 @@ static void ionic_rx_page_free(struct ionic_queue *q, struct page *page,
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
@@ -352,8 +371,7 @@ void ionic_rx_fill(struct ionic_queue *q)
 		desc->opcode = (nfrags > 1) ? IONIC_RXQ_DESC_OPCODE_SG :
 					      IONIC_RXQ_DESC_OPCODE_SIMPLE;
 		desc_info->npages = nfrags;
-		page_info->page = ionic_rx_page_alloc(q, &page_info->dma_addr);
-		if (unlikely(!page_info->page)) {
+		if (unlikely(ionic_rx_page_alloc(q, page_info))) {
 			desc->addr = 0;
 			desc->len = 0;
 			return;
@@ -370,8 +388,7 @@ void ionic_rx_fill(struct ionic_queue *q)
 				continue;
 
 			sg_elem = &sg_desc->elems[j];
-			page_info->page = ionic_rx_page_alloc(q, &page_info->dma_addr);
-			if (unlikely(!page_info->page)) {
+			if (unlikely(ionic_rx_page_alloc(q, page_info))) {
 				sg_elem->addr = 0;
 				sg_elem->len = 0;
 				return;
@@ -409,14 +426,8 @@ void ionic_rx_empty(struct ionic_queue *q)
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


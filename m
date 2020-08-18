Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6AC248EE4
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgHRTos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgHRToh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:44:37 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C882FC061342
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:36 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id n32so12689957pgb.22
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lkaTI5zfSAVH+ZH0FW6PbE7UwzofYRPR+OAwQ1y4D5k=;
        b=vFL/OGjdBTcVsfRswEGEqKJeF2Cu/NUSNxeVdPsZ0b2Q6Xa6mRt6EtdB19pFQ7KZu9
         yGyZ0zyZvvJPgNGo4zKhNBpPPlAAMoi349VEpxiCRz/RjrFYUzfgl5qRUv80JmVGUvH3
         kYv3bL4e694zOBUB8PyZhpkuHH3nIh5gP92dNqltd++KItjJZTfAH85NdNg1b9PghKqZ
         azr7U1xgKsVrZ7hZX1flF1YZSISdt43rEr+nGOQa+ykeYLtskUVzGBO/4ZW3/VCNhems
         V9uck0d8jY3pd8DWTvr+kLYX6a+C3EIZolZ9h7DaQC3+jT+vtj/paRlDp7MHh2GMHLwG
         H1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lkaTI5zfSAVH+ZH0FW6PbE7UwzofYRPR+OAwQ1y4D5k=;
        b=SxXK/CjnZgp7TDPPSsIIJAUzfwGh4F9LNHTSzqIqYE4/wcfeeTyioRoV0408FYIDHZ
         HtcY0BQl6ZL+OXqtQbKGGLqGd/MjQ1ZAiKliSF+zmlSndVn3TvBYfyYzfKqao7rWCG8U
         AzD+LXWstw2FlqnB+g+QyfuzxmG+KcXrw4x7uDpPIfQjL5hIq/rr9icQSpt9AjgKnUUA
         1nikx7nHDyB+XirHXHRKhAjJRlybmwAuzQYQLHV3SR3/w4M6q37Z7gQj5qbdWtxYrqtI
         VIpuht/KaN6r3kCGC15QRt9LFq5LZtZe0dKuRe5M44QtlZ0UDed+qQpvhqEb5U5QfJxN
         QMsg==
X-Gm-Message-State: AOAM533Y9nu0eBTTr6Uw0rmE08IBx7noXXYuSVnVBx2Hsctz0v1HilEo
        O4m55BdYtP3phGwu9LFpP0N0//7mrvrBoDrzCS7HnI/A1k0ITygW4IqSYRQK4VS1lvQs4ZNTMMa
        CAgcxQjdutq134ZIlI4mNCduFii3J8GTeslAmFN5a8wJf3g4BqMZn4UmuEZgKHrvXePnyKHEF
X-Google-Smtp-Source: ABdhPJwhJZf1o9iWS4hPOowT1Wk+8XHmtVPPnxWYexdtC4GzTok4fIq394PrMay080azpJIoDBHJ+Jwik0c5bULD
X-Received: by 2002:aa7:99cc:: with SMTP id v12mr16392188pfi.255.1597779876113;
 Tue, 18 Aug 2020 12:44:36 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:44:03 -0700
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
Message-Id: <20200818194417.2003932-5-awogbemila@google.com>
Mime-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 04/18] gve: Add support for dma_mask register
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

Add the dma_mask register and read it to set the dma_masks.
gve_alloc_page will alloc_page with:
 GFP_DMA if priv->dma_mask is 24,
 GFP_DMA32 if priv->dma_mask is 32.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  6 ++-
 drivers/net/ethernet/google/gve/gve_main.c    | 42 ++++++++++++-------
 .../net/ethernet/google/gve/gve_register.h    |  3 +-
 3 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 55b34b437764..37a3bbced36a 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -232,6 +232,9 @@ struct gve_priv {
 	struct work_struct service_task;
 	unsigned long service_task_flags;
 	unsigned long state_flags;
+
+  /* Gvnic device's dma mask, set during probe. */
+	u8 dma_mask;
 };
 
 enum gve_service_task_flags {
@@ -451,8 +454,7 @@ static inline bool gve_can_recycle_pages(struct net_device *dev)
 }
 
 /* buffers */
-int gve_alloc_page(struct gve_priv *priv, struct device *dev,
-		   struct page **page, dma_addr_t *dma,
+int gve_alloc_page(struct gve_priv *priv, struct device *dev, struct page **page, dma_addr_t *dma,
 		   enum dma_data_direction);
 void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
 		   enum dma_data_direction);
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index b0c1cfe44a73..449345d24f29 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -518,7 +518,14 @@ int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 		   struct page **page, dma_addr_t *dma,
 		   enum dma_data_direction dir)
 {
-	*page = alloc_page(GFP_KERNEL);
+	gfp_t gfp_flags = GFP_KERNEL;
+
+	if (priv->dma_mask == 24)
+		gfp_flags |= GFP_DMA;
+	else if (priv->dma_mask == 32)
+		gfp_flags |= GFP_DMA32;
+
+	*page = alloc_page(gfp_flags);
 	if (!*page) {
 		priv->page_alloc_fail++;
 		return -ENOMEM;
@@ -1083,6 +1090,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	__be32 __iomem *db_bar;
 	struct gve_registers __iomem *reg_bar;
 	struct gve_priv *priv;
+	u8 dma_mask;
 	int err;
 
 	err = pci_enable_device(pdev);
@@ -1095,19 +1103,6 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
-	if (err) {
-		dev_err(&pdev->dev, "Failed to set dma mask: err=%d\n", err);
-		goto abort_with_pci_region;
-	}
-
-	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-	if (err) {
-		dev_err(&pdev->dev,
-			"Failed to set consistent dma mask: err=%d\n", err);
-		goto abort_with_pci_region;
-	}
-
 	reg_bar = pci_iomap(pdev, GVE_REGISTER_BAR, 0);
 	if (!reg_bar) {
 		dev_err(&pdev->dev, "Failed to map pci bar!\n");
@@ -1122,10 +1117,28 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto abort_with_reg_bar;
 	}
 
+	dma_mask = readb(&reg_bar->dma_mask);
+	// Default to 64 if the register isn't set
+	if (!dma_mask)
+		dma_mask = 64;
 	gve_write_version(&reg_bar->driver_version);
 	/* Get max queues to alloc etherdev */
 	max_rx_queues = ioread32be(&reg_bar->max_tx_queues);
 	max_tx_queues = ioread32be(&reg_bar->max_rx_queues);
+
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_err(&pdev->dev, "Failed to set dma mask: err=%d\n", err);
+		goto abort_with_reg_bar;
+	}
+
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_err(&pdev->dev,
+			"Failed to set consistent dma mask: err=%d\n", err);
+		goto abort_with_reg_bar;
+	}
+
 	/* Alloc and setup the netdev and priv */
 	dev = alloc_etherdev_mqs(sizeof(*priv), max_tx_queues, max_rx_queues);
 	if (!dev) {
@@ -1160,6 +1173,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->db_bar2 = db_bar;
 	priv->service_task_flags = 0x0;
 	priv->state_flags = 0x0;
+	priv->dma_mask = dma_mask;
 
 	gve_set_probe_in_progress(priv);
 
diff --git a/drivers/net/ethernet/google/gve/gve_register.h b/drivers/net/ethernet/google/gve/gve_register.h
index 84ab8893aadd..fad8813d1bb1 100644
--- a/drivers/net/ethernet/google/gve/gve_register.h
+++ b/drivers/net/ethernet/google/gve/gve_register.h
@@ -16,7 +16,8 @@ struct gve_registers {
 	__be32	adminq_pfn;
 	__be32	adminq_doorbell;
 	__be32	adminq_event_counter;
-	u8	reserved[3];
+	u8	reserved[2];
+	u8	dma_mask;
 	u8	driver_version;
 };
 
-- 
2.28.0.220.ged08abb693-goog


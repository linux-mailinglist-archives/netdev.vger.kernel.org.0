Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0A3261ACB
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731431AbgIHSkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731802AbgIHSjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 14:39:21 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9497C0613ED
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 11:39:20 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id nk7so63287pjb.8
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 11:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=IuiqVKPIEeo+hZloP1AleOOYs96h20tcL+kHXJxfM58=;
        b=D/Oj5jzwmqBM/SmKP2UAeM/UTtrQsd8lqWZV9F2Rz7039kWzNsz6uB9t9O/V5Zg40Q
         h6UQa5lagm8kfrhsPX+vYiiLgbz2p2366fy0MMuc8mAYpqqCOEjaBR+1wVbkSSvhAbub
         yhn3CQPISuI1mFbnyPWZC8+vEc6Sf/GLcdV2wEchg56BA/vCZoToWyaasKikV/EHQEzP
         mwak/ckRwSP+zjFiP4+T0y0kWY5fuzeTTUsQrb5jkCU99KH+nbCoLInJfhdaE2UpwYmz
         YMwEE1KTVEgb5WTRMQ4xXKqXP9r44bALt2PVM0TghzktkzC/DqeSDN/2TICWCkfQEtkZ
         eFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IuiqVKPIEeo+hZloP1AleOOYs96h20tcL+kHXJxfM58=;
        b=PR5nVWnr8hI7x95MAoqrmsqOjaBLAMxe1zj7xfw38Ye/bWlnsctkJInpYoKT6JN1+o
         UdPEjAN4w5XfO9dfzHd4i5dC+dbVNEb4wFceBbU27nuXmTNBq/WQLvQY/2iL3LnX4229
         3qurVUNuerwLtEzFIxMltoOHiJ5CHJmyDGabfjUSLpCzejBaoN9jvckoA1j9gNi49T4G
         wcD1Jd8bLauIzF6w7twzXp3morcCinEX5JQHJj46VFhLYjjAxfL0jEOaCVHYVDJmgGjS
         zQ6QGOcECHk/dhYvROgmYAKsf6mj+mcYDtrt3MCl9o1V3nhK2FvYn4xugnK6A7RSy/n0
         coXQ==
X-Gm-Message-State: AOAM531O/MYyh3qWSPIDkIsKfghisk3fE4CU3tjHJSV5Uf6Y8r0dC5QM
        uSPSerTDJgiNNZSu5jv/74681pXNPQKW3wuR5EnwTxmCF8ErOSPTzGcJ1Da7uM0cy4P4jnWwPgV
        3jZAm2RQ8xeNbRtpQcfJ8UIZOCqJX2UESZeFC7w0E2pq1M421ncGkYx+gVPykGS6eG5n33wjy
X-Google-Smtp-Source: ABdhPJyzyNW5N/R92QlI/8f5++XUFQOsq6lXthYY6n423Ev+F2wEKcWDAfG8Z9LRhKkWlAbjl8rIx53HeiKfX1aO
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:aa7:864c:0:b029:13c:1611:6591 with SMTP
 id a12-20020aa7864c0000b029013c16116591mr360200pfo.14.1599590360329; Tue, 08
 Sep 2020 11:39:20 -0700 (PDT)
Date:   Tue,  8 Sep 2020 11:39:04 -0700
In-Reply-To: <20200908183909.4156744-1-awogbemila@google.com>
Message-Id: <20200908183909.4156744-5-awogbemila@google.com>
Mime-Version: 1.0
References: <20200908183909.4156744-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net-next v3 4/9] gve: Add support for dma_mask register
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
 GFP_DMA32 if priv->dma_mask is 32.
This helps in 32-bit device address cases where the guest would
run out of SWIOTLB space. Since its buffers would be allocated
GFP_DMA32, there would be less pressure on SWIOTLB.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  6 ++-
 drivers/net/ethernet/google/gve/gve_main.c    | 40 ++++++++++++-------
 .../net/ethernet/google/gve/gve_register.h    |  3 +-
 3 files changed, 32 insertions(+), 17 deletions(-)

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
index 0fc68f844edf..c69ec044f47c 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -518,7 +518,12 @@ int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 		   struct page **page, dma_addr_t *dma,
 		   enum dma_data_direction dir)
 {
-	*page = alloc_page(GFP_KERNEL);
+	gfp_t gfp_flags = GFP_KERNEL;
+
+	if (priv->dma_mask == 32)
+		gfp_flags |= GFP_DMA32;
+
+	*page = alloc_page(gfp_flags);
 	if (!*page) {
 		priv->page_alloc_fail++;
 		return -ENOMEM;
@@ -1083,6 +1088,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	__be32 __iomem *db_bar;
 	struct gve_registers __iomem *reg_bar;
 	struct gve_priv *priv;
+	u8 dma_mask;
 	int err;
 
 	err = pci_enable_device(pdev);
@@ -1095,19 +1101,6 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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
@@ -1122,10 +1115,28 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -1158,6 +1169,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->db_bar2 = db_bar;
 	priv->service_task_flags = 0x0;
 	priv->state_flags = 0x0;
+	priv->dma_mask = dma_mask;
 
 	gve_set_probe_in_progress(priv);
 	priv->gve_wq = alloc_ordered_workqueue("gve", 0);
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
2.28.0.526.ge36021eeef-goog


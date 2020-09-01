Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30BC25A100
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgIAVwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbgIAVwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 17:52:04 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F16C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 14:52:04 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id mu14so1132139pjb.7
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 14:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=MPnRJ02GXcB1odHc4kcWJHJj72ELeZL12/LRGhlXO+U=;
        b=qRBVToSZfxNMEyfWWSIskImVuySB8g67Eb7zRAQTcCDaaIlUt5Zu4RbT/hBp1rqZvF
         30MRkG2njqcJmm9ijRFjcsi8aXDYi3keFLMePQaQAtneawGSsJsigyW5D6F3XCUX1RW2
         qD8siljKgA/ejJps++ABrv+a50r9vdLJWFGpkHtyll2aHoulqIHgvu6GXIJPAMmr9qY0
         Lb9+lBd6mObbloeFLifYmP+XQ9UK85qc2RrZkfh/K3x404fSqcSSNzpj66tjggTUCtvI
         1EMFTklY9u3yFK8i3xFbztJzAjrektSvQabr0sknQdtjDWL7a8OwxO0iNazDfHt7yeHP
         Ejyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MPnRJ02GXcB1odHc4kcWJHJj72ELeZL12/LRGhlXO+U=;
        b=DXSbOGn9MW59FF3oDkvHwc5Xg2tgrkHs9tllu4BVWTutISiXfEXN49OpJ2ctBisesF
         xPtTbNaxahYUyibnWepAKqlxWS5P7Hkf0/Onx6pt9dxr9aKokU9UBqIzuKZ8ESUEPp0v
         rPd9/m+c8dMdNqipb3cPEqa1qCuf+yC/rpyVxge/csStbuZeyaV5bt8SlTkSy5CWTsPf
         nMe6CA4bqSazHvI0Le9JmaqU4D+1zpJwU87H7YwGTdczLubjVCvEQndvsTlpzDlkJbWy
         VbJYF0n7LEHm5Fa46Aoj/zLwVC9Ok7FyQht1GGBCPL47pjiq1ZemvCtRzBSQS42YiypS
         Vt2w==
X-Gm-Message-State: AOAM530/MuNYtfZyi4kzVM2kjbkYrj5mTMx5+iWCDOTQyN6bVtAZieBc
        tg1BNNUIVPeKcegfAzKkhs9nngT1sRDAyp8FgCVu8UtB9QtgwNe6aBER+9k50Rlyuq6piyEXiYc
        ZWUwKdml71Yi7gvSIMuFuc+TJrEOkhMH5Iw6zJusBGh+SEohNz1SnJCdiEWQkkj/0S+ywGm0e
X-Google-Smtp-Source: ABdhPJybTnBmQYOME4o5MQlGsHvt8TUROxTdAu5pz2MdMd1iFBW1+jqbaGsXALnGUdIaaBNNSQ8wBLA4himo/BT9
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a62:7c43:0:b029:139:858b:8033 with SMTP
 id x64-20020a627c430000b0290139858b8033mr3845788pfc.3.1598997123848; Tue, 01
 Sep 2020 14:52:03 -0700 (PDT)
Date:   Tue,  1 Sep 2020 14:51:44 -0700
In-Reply-To: <20200901215149.2685117-1-awogbemila@google.com>
Message-Id: <20200901215149.2685117-5-awogbemila@google.com>
Mime-Version: 1.0
References: <20200901215149.2685117-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH net-next v2 4/9] gve: Add support for dma_mask register
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
index a0b8c1e8ed98..b176fcef19de 100644
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
2.28.0.402.g5ffc5be6b7-goog


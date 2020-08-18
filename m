Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE09248EF0
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgHRTp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbgHRTpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:45:10 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C85C061342
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:45:09 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id e30so13561718pfj.0
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ifA7qxZdJvI1VDeaHIOR+Ips3AY9jLHB1Oe8tLsYDro=;
        b=J2ZerK6ZtPaUlE/NdS08vVR/N1UU/GzlI+USSD5cFYwVZZwIEMEF2jvpWDrM8Ia8cO
         y+eDRJz1W2T5JpxYIdAcXAxS+gee+0BbwKZixlH3z3W+oReA5EDs+S0zBHkA/ep9g/H+
         Iz9+fCCoJFP/IIp5UJWHlQfoH/f+q5bSSz9MhgPvmm05g+2mMrL+Lk0vSSSIi684tPbs
         mRrFrakOcguzB9SQdrjuHqBFewJwJty3Ky727+WcUiUFvYsz6W47gX/HnckuvN3RebWW
         zf90VLxN5IzX7EGW0ZmC3U8yrwn9vrK62WlS/LjL98elvGuYToXZia13fo+1V7vCnGnw
         NS2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ifA7qxZdJvI1VDeaHIOR+Ips3AY9jLHB1Oe8tLsYDro=;
        b=Smlj5lN8vNc6A1MDf8nQrTp8KATu1bVrhwPi0HCHRClAVJGKQ7UVW6wq1uQ+0J4ysI
         eP/sFMcwB4lgoSs92LOwQYJ/e3ohUt09MTntqdZ8PoWMmxabTF02uOBOcPRUTJjg71ll
         if0G5PlkbTMnndGqGubXBhI/KFD6xE/cGdpdztgv8WkBHqPXF8kjJT9eEpVoFolYofSN
         nCOg/zFmnyMGVQqpcJ0JeqphZXj17pKYuEOoUeVXDdtizrzpDoAGrVPuOLO9qLNm0W4w
         yd/lx08nbLE80A/Jgxhl7jvoWoczb6uy59M4zFxMel4unZEL95Mg/VZgH1QkEjNKnnmX
         Czdw==
X-Gm-Message-State: AOAM533BCZxT1ofduy1Rv4I18WITiQWExTQ3HTvJgXehEOlHzo1jsBFE
        KWzxFEOWPjH22EHiD8BP6EfmMfEse8tk9OMF4SgxlXsN5NyshFl8g4L2b++E1HUng+/nPJiXeem
        RtXHvImy1cO69AEQ8G2ezanq4Bb9xb89BzUIpunpuO4VtdBHGQU2GX9PjscUd4BSfD0aRdH1O
X-Google-Smtp-Source: ABdhPJw7x1VgKdGwy0XP9Wwh43MaUAsjMc7g94ncjSK+2xzB0swYF25QdezeaCqv5GfL6WrYmuJQejfn1zvaKSp9
X-Received: by 2002:a63:b21b:: with SMTP id x27mr14204146pge.284.1597779909353;
 Tue, 18 Aug 2020 12:45:09 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:44:13 -0700
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
Message-Id: <20200818194417.2003932-15-awogbemila@google.com>
Mime-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 14/18] gve: Move the irq db indexes out of the ntfy
 block struct
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

Giving the device access to other kernel structs is not ideal.
Move the indexes into their own array and just keep pointers to
them in the ntfy block struct.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        | 13 ++++---
 drivers/net/ethernet/google/gve/gve_adminq.c |  2 +-
 drivers/net/ethernet/google/gve/gve_main.c   | 37 ++++++++++++++------
 3 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 8b1773c45cb6..bacb4070c755 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -174,13 +174,13 @@ struct gve_tx_ring {
  * associated with that irq.
  */
 struct gve_notify_block {
-	__be32 irq_db_index; /* idx into Bar2 - set by device, must be 1st */
+	__be32 *irq_db_index; /* pointer to idx into Bar2 */
 	char name[IFNAMSIZ + 16]; /* name registered with the kernel */
 	struct napi_struct napi; /* kernel napi struct for this block */
 	struct gve_priv *priv;
 	struct gve_tx_ring *tx; /* tx rings on this block */
 	struct gve_rx_ring *rx; /* rx rings on this block */
-} ____cacheline_aligned;
+};
 
 /* Tracks allowed and current queue settings */
 struct gve_queue_config {
@@ -194,13 +194,18 @@ struct gve_qpl_config {
 	unsigned long *qpl_id_map; /* bitmap of used qpl ids */
 };
 
+struct gve_irq_db {
+	__be32 index;
+} ____cacheline_aligned;
+
 struct gve_priv {
 	struct net_device *dev;
 	struct gve_tx_ring *tx; /* array of tx_cfg.num_queues */
 	struct gve_rx_ring *rx; /* array of rx_cfg.num_queues */
 	struct gve_queue_page_list *qpls; /* array of num qpls */
 	struct gve_notify_block *ntfy_blocks; /* array of num_ntfy_blks */
-	dma_addr_t ntfy_block_bus;
+	struct gve_irq_db *irq_db_indices; /* array of num_ntfy_blks */
+	dma_addr_t irq_db_indices_bus;
 	struct msix_entry *msix_vectors; /* array of num_ntfy_blks + 1 */
 	char mgmt_msix_name[IFNAMSIZ + 16];
 	u32 mgmt_msix_idx;
@@ -438,7 +443,7 @@ static inline void gve_clear_report_stats(struct gve_priv *priv)
 static inline __be32 __iomem *gve_irq_doorbell(struct gve_priv *priv,
 					       struct gve_notify_block *block)
 {
-	return &priv->db_bar2[be32_to_cpu(block->irq_db_index)];
+	return &priv->db_bar2[be32_to_cpu(*block->irq_db_index)];
 }
 
 /* Returns the index into ntfy_blocks of the given tx ring's block
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index bb21891d06a2..5d6784c4fc41 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -292,7 +292,7 @@ int gve_adminq_configure_device_resources(struct gve_priv *priv,
 		.num_counters = cpu_to_be32(num_counters),
 		.irq_db_addr = cpu_to_be64(db_array_bus_addr),
 		.num_irq_dbs = cpu_to_be32(num_ntfy_blks),
-		.irq_db_stride = cpu_to_be32(sizeof(priv->ntfy_blocks[0])),
+		.irq_db_stride = cpu_to_be32(sizeof(*priv->irq_db_indices)),
 		.ntfy_blk_msix_base_idx =
 					cpu_to_be32(GVE_NTFY_BLK_BASE_MSIX_IDX),
 	};
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index de22c60d1fea..ee434d3ca5e7 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -239,15 +239,24 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
 		dev_err(&priv->pdev->dev, "Did not receive management vector.\n");
 		goto abort_with_msix_enabled;
 	}
-	priv->ntfy_blocks =
+
+	priv->irq_db_indices =
 		dma_alloc_coherent(&priv->pdev->dev,
 				   priv->num_ntfy_blks *
-				   sizeof(*priv->ntfy_blocks),
-				   &priv->ntfy_block_bus, GFP_KERNEL);
-	if (!priv->ntfy_blocks) {
+				   sizeof(*priv->irq_db_indices),
+				   &priv->irq_db_indices_bus, GFP_KERNEL);
+	if (!priv->irq_db_indices) {
 		err = -ENOMEM;
 		goto abort_with_mgmt_vector;
 	}
+
+	priv->ntfy_blocks = kvzalloc(priv->num_ntfy_blks *
+				     sizeof(*priv->ntfy_blocks), GFP_KERNEL);
+	if (!priv->ntfy_blocks) {
+		err = -ENOMEM;
+		goto abort_with_irq_db_indices;
+	}
+
 	/* Setup the other blocks - the first n-1 vectors */
 	for (i = 0; i < priv->num_ntfy_blks; i++) {
 		struct gve_notify_block *block = &priv->ntfy_blocks[i];
@@ -265,6 +274,7 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
 		}
 		irq_set_affinity_hint(priv->msix_vectors[msix_idx].vector,
 				      get_cpu_mask(i % active_cpus));
+		block->irq_db_index = &priv->irq_db_indices[i].index;
 	}
 	return 0;
 abort_with_some_ntfy_blocks:
@@ -276,10 +286,13 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
 				      NULL);
 		free_irq(priv->msix_vectors[msix_idx].vector, block);
 	}
-	dma_free_coherent(&priv->pdev->dev, priv->num_ntfy_blks *
-			  sizeof(*priv->ntfy_blocks),
-			  priv->ntfy_blocks, priv->ntfy_block_bus);
+	kvfree(priv->ntfy_blocks);
 	priv->ntfy_blocks = NULL;
+abort_with_irq_db_indices:
+	dma_free_coherent(&priv->pdev->dev, priv->num_ntfy_blks *
+			  sizeof(*priv->irq_db_indices),
+			  priv->irq_db_indices, priv->irq_db_indices_bus);
+	priv->irq_db_indices = NULL;
 abort_with_mgmt_vector:
 	free_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector, priv);
 abort_with_msix_enabled:
@@ -303,10 +316,12 @@ static void gve_free_notify_blocks(struct gve_priv *priv)
 				      NULL);
 		free_irq(priv->msix_vectors[msix_idx].vector, block);
 	}
-	dma_free_coherent(&priv->pdev->dev,
-			  priv->num_ntfy_blks * sizeof(*priv->ntfy_blocks),
-			  priv->ntfy_blocks, priv->ntfy_block_bus);
+	kvfree(priv->ntfy_blocks);
 	priv->ntfy_blocks = NULL;
+	dma_free_coherent(&priv->pdev->dev, priv->num_ntfy_blks *
+			  sizeof(*priv->irq_db_indices),
+			  priv->irq_db_indices, priv->irq_db_indices_bus);
+	priv->irq_db_indices = NULL;
 	free_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector, priv);
 	pci_disable_msix(priv->pdev);
 	kvfree(priv->msix_vectors);
@@ -329,7 +344,7 @@ static int gve_setup_device_resources(struct gve_priv *priv)
 	err = gve_adminq_configure_device_resources(priv,
 						    priv->counter_array_bus,
 						    priv->num_event_counters,
-						    priv->ntfy_block_bus,
+						    priv->irq_db_indices_bus,
 						    priv->num_ntfy_blks);
 	if (unlikely(err)) {
 		dev_err(&priv->pdev->dev,
-- 
2.28.0.220.ged08abb693-goog


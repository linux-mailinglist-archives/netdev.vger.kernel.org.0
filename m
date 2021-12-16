Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81ECD47671A
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 01:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhLPArN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 19:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhLPArL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 19:47:11 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B1EC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:10 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id k21-20020a63f015000000b0033db7baf101so2427326pgh.19
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6OEtlas5nY1bjouVNYnoq+29JHD3AcGvaHAcF1Dvy+M=;
        b=DSjafhk5n/78bUs1lZrzWOCQsJTVHyWsWZW/vj6lcJ9Wu5a5uWODqi2A2h+nedSvNo
         ccXrzxtNWf2MHYm/TWLCGPKylfwIACSnQIan/V85Q0YsgW3Oalvedpkb0GG3VDSQYaFO
         YeVwIda0PzlQZG9rkjQDc2TgfRR1y6K31X/s3ptZkw48a/6fJZ2gSO+fd9t3ppx4o74D
         Ge05abUzaOtBvcwkPySp4LI9Ndz6hl0Xsi9sdsx2YeZmknnRLZ2HuYizjVpHVXrSvOvb
         APMp2gnRr8OX6eYSfKBwYivfotO7luaO0CeELwrRdZP6T8wcLmtzZCJmlXWYkUj92WHb
         ApNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6OEtlas5nY1bjouVNYnoq+29JHD3AcGvaHAcF1Dvy+M=;
        b=lBpI1cU2k3oF0XMItviiUBKBKM89WpGc2WplEej3SIE2ML4xH/j6r3Q4s4H8Zs+Dgy
         yLuEqw+MgsEKGWpb9T7jD+nr46vMGnnqeW/orbN340LBRUkdVum5D8GIQrHcqDVPQs3Y
         b29n2RGUFODl2F6lP1vkfEUx5+hQ+iNeMMYEdDJBEGVbLezi64o07rG1nPE55xy4qV24
         Dp/zb7gTz3x6pjBG8O5+MBZXIydvFKklqRXBHz/rXkUZuWiBD0mf7OWDB53jOELm9kfl
         zj4qo3v2FPS74xtLmSMeTOF3Px/CB/U8CRra/HY73PjHO8Ncip5wBnde1VczgK/ZyUDv
         rYpw==
X-Gm-Message-State: AOAM533FD4ArCQL8cM4aqg3cTww3RBvAJyPFUkLiuPTxG20kDPeWiXmz
        QaVwMVYN3uitluL6D+GVF7m4BPsvLC1F2Qsb5fO1cKYxyruAX5f2bWmPTv48kRTzxc8v43WetLg
        a73XyOq9R3HHtPX8ZySGsZlv5j5/7yxi549wanEV7gwNDnF9KFW7jTgOsJO/nzdhppmg=
X-Google-Smtp-Source: ABdhPJy07fHpA9wSN/7GMQOZIjDkovPp8l4zPJ3BI/8/T7qkOLm1UFtdgUwUXcCCfU+FlJaJoSe8k2mRzpOlwA==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:964d:9084:bbdd:97a9])
 (user=jeroendb job=sendgmr) by 2002:a63:9207:: with SMTP id
 o7mr9835599pgd.430.1639615630233; Wed, 15 Dec 2021 16:47:10 -0800 (PST)
Date:   Wed, 15 Dec 2021 16:46:46 -0800
In-Reply-To: <20211216004652.1021911-1-jeroendb@google.com>
Message-Id: <20211216004652.1021911-3-jeroendb@google.com>
Mime-Version: 1.0
References: <20211216004652.1021911-1-jeroendb@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH net-next 2/8] gve: Move the irq db indexes out of the ntfy
 block struct
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Giving the device access to other kernel structs is not ideal.
Move the indexes into their own array and just keep pointers to
them in the ntfy block struct.

Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        | 13 ++++---
 drivers/net/ethernet/google/gve/gve_adminq.c |  2 +-
 drivers/net/ethernet/google/gve/gve_dqo.h    |  2 +-
 drivers/net/ethernet/google/gve/gve_main.c   | 36 ++++++++++++++------
 4 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index b719f72281c4..b6bd8f679127 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -441,13 +441,13 @@ struct gve_tx_ring {
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
@@ -466,6 +466,10 @@ struct gve_options_dqo_rda {
 	u16 rx_buff_ring_entries; /* number of rx_buff descriptors */
 };
 
+struct gve_irq_db {
+	__be32 index;
+} ____cacheline_aligned;
+
 struct gve_ptype {
 	u8 l3_type;  /* `gve_l3_type` in gve_adminq.h */
 	u8 l4_type;  /* `gve_l4_type` in gve_adminq.h */
@@ -492,7 +496,8 @@ struct gve_priv {
 	struct gve_rx_ring *rx; /* array of rx_cfg.num_queues */
 	struct gve_queue_page_list *qpls; /* array of num qpls */
 	struct gve_notify_block *ntfy_blocks; /* array of num_ntfy_blks */
-	dma_addr_t ntfy_block_bus;
+	struct gve_irq_db *irq_db_indices; /* array of num_ntfy_blks */
+	dma_addr_t irq_db_indices_bus;
 	struct msix_entry *msix_vectors; /* array of num_ntfy_blks + 1 */
 	char mgmt_msix_name[IFNAMSIZ + 16];
 	u32 mgmt_msix_idx;
@@ -733,7 +738,7 @@ static inline void gve_clear_report_stats(struct gve_priv *priv)
 static inline __be32 __iomem *gve_irq_doorbell(struct gve_priv *priv,
 					       struct gve_notify_block *block)
 {
-	return &priv->db_bar2[be32_to_cpu(block->irq_db_index)];
+	return &priv->db_bar2[be32_to_cpu(*block->irq_db_index)];
 }
 
 /* Returns the index into ntfy_blocks of the given tx ring's block
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 326b56b49216..2ad7f57f7e5b 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -462,7 +462,7 @@ int gve_adminq_configure_device_resources(struct gve_priv *priv,
 		.num_counters = cpu_to_be32(num_counters),
 		.irq_db_addr = cpu_to_be64(db_array_bus_addr),
 		.num_irq_dbs = cpu_to_be32(num_ntfy_blks),
-		.irq_db_stride = cpu_to_be32(sizeof(priv->ntfy_blocks[0])),
+		.irq_db_stride = cpu_to_be32(sizeof(*priv->irq_db_indices)),
 		.ntfy_blk_msix_base_idx =
 					cpu_to_be32(GVE_NTFY_BLK_BASE_MSIX_IDX),
 		.queue_format = priv->queue_format,
diff --git a/drivers/net/ethernet/google/gve/gve_dqo.h b/drivers/net/ethernet/google/gve/gve_dqo.h
index 836042364124..b2e2fb015693 100644
--- a/drivers/net/ethernet/google/gve/gve_dqo.h
+++ b/drivers/net/ethernet/google/gve/gve_dqo.h
@@ -73,7 +73,7 @@ static inline void
 gve_write_irq_doorbell_dqo(const struct gve_priv *priv,
 			   const struct gve_notify_block *block, u32 val)
 {
-	u32 index = be32_to_cpu(block->irq_db_index);
+	u32 index = be32_to_cpu(*block->irq_db_index);
 
 	iowrite32(val, &priv->db_bar2[index]);
 }
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 59b66f679e46..348b4cfc4a12 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -334,15 +334,23 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
 		dev_err(&priv->pdev->dev, "Did not receive management vector.\n");
 		goto abort_with_msix_enabled;
 	}
-	priv->ntfy_blocks =
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
@@ -361,6 +369,7 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
 		}
 		irq_set_affinity_hint(priv->msix_vectors[msix_idx].vector,
 				      get_cpu_mask(i % active_cpus));
+		block->irq_db_index = &priv->irq_db_indices[i].index;
 	}
 	return 0;
 abort_with_some_ntfy_blocks:
@@ -372,10 +381,13 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
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
@@ -403,10 +415,12 @@ static void gve_free_notify_blocks(struct gve_priv *priv)
 		free_irq(priv->msix_vectors[msix_idx].vector, block);
 	}
 	free_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector, priv);
-	dma_free_coherent(&priv->pdev->dev,
-			  priv->num_ntfy_blks * sizeof(*priv->ntfy_blocks),
-			  priv->ntfy_blocks, priv->ntfy_block_bus);
+	kvfree(priv->ntfy_blocks);
 	priv->ntfy_blocks = NULL;
+	dma_free_coherent(&priv->pdev->dev, priv->num_ntfy_blks *
+			  sizeof(*priv->irq_db_indices),
+			  priv->irq_db_indices, priv->irq_db_indices_bus);
+	priv->irq_db_indices = NULL;
 	pci_disable_msix(priv->pdev);
 	kvfree(priv->msix_vectors);
 	priv->msix_vectors = NULL;
@@ -428,7 +442,7 @@ static int gve_setup_device_resources(struct gve_priv *priv)
 	err = gve_adminq_configure_device_resources(priv,
 						    priv->counter_array_bus,
 						    priv->num_event_counters,
-						    priv->ntfy_block_bus,
+						    priv->irq_db_indices_bus,
 						    priv->num_ntfy_blks);
 	if (unlikely(err)) {
 		dev_err(&priv->pdev->dev,
-- 
2.34.1.173.g76aa8bc2d0-goog


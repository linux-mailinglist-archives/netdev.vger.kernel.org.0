Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDDFD6C8921
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 00:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCXXOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 19:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjCXXOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 19:14:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764AC19120
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 16:14:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAD89B8266F
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 23:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E5FC433EF;
        Fri, 24 Mar 2023 23:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679699642;
        bh=/HlbVc4x7B2fCHJ6xM6gjxDIA9D0AzLdoxaVdVDFPwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhNqvC6GX4wOhd5be9icCOb7fM19uuNFimkdr8/QiodMAZ+DxJSPfN/zcANoCEl1a
         zGqzNHU3WmE63USXBZkJOT5rPf1CLYa5iz82wz/3RIOYXQs3BfgIeXQHoXhU/rYQ9P
         bQ1uGzvCQrniIqBEuk1F6fQQ73cxSmrNMFxf/xt2788dzEs9D87c+yoapMqHIJLRty
         gioom2GaP8SPtoCn3Ywf45gZB0uM5C3tiL9epuWSAscNPuDFpgoY+pVtqUCPD6UJ5k
         Yfit7i4kSUgA9lYobTRVIdm4IE8FDQkRWnqCbMCXgCjWRMklkqViAWuzHLvZSsseyt
         ZnqB/IAT+XZYQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eli Cohen <elic@nvidia.com>, Shay Drory <shayd@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next V2 14/15] net/mlx5: Provide external API for allocating vectors
Date:   Fri, 24 Mar 2023 16:13:40 -0700
Message-Id: <20230324231341.29808-15-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324231341.29808-1-saeed@kernel.org>
References: <20230324231341.29808-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Provide external API to be used by other drivers relying on mlx5_core,
for allocating MSIX vectors. An example for such a driver would be
mlx5_vdpa.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 52 +++++++++++++++++++
 include/linux/mlx5/driver.h                   |  6 +++
 2 files changed, 58 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 7fa63d31ae5b..e12e528c09f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -483,6 +483,58 @@ struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
 	return irq;
 }
 
+/**
+ * mlx5_msix_alloc - allocate msix interrupt
+ * @dev: mlx5 device from which to request
+ * @handler: interrupt handler
+ * @affdesc: affinity descriptor
+ * @name: interrupt name
+ *
+ * Returns: struct msi_map with result encoded.
+ * Note: the caller must make sure to release the irq by calling
+ *       mlx5_msix_free() if shutdown was initiated.
+ */
+struct msi_map mlx5_msix_alloc(struct mlx5_core_dev *dev,
+			       irqreturn_t (*handler)(int, void *),
+			       const struct irq_affinity_desc *affdesc,
+			       const char *name)
+{
+	struct msi_map map;
+	int err;
+
+	if (!dev->pdev) {
+		map.virq = 0;
+		map.index = -EINVAL;
+		return map;
+	}
+
+	map = pci_msix_alloc_irq_at(dev->pdev, MSI_ANY_INDEX, affdesc);
+	if (!map.virq)
+		return map;
+
+	err = request_irq(map.virq, handler, 0, name, NULL);
+	if (err) {
+		mlx5_core_warn(dev, "err %d\n", err);
+		pci_msix_free_irq(dev->pdev, map);
+		map.virq = 0;
+		map.index = -ENOMEM;
+	}
+	return map;
+}
+EXPORT_SYMBOL(mlx5_msix_alloc);
+
+/**
+ * mlx5_msix_free - free a previously allocated msix interrupt
+ * @dev: mlx5 device associated with interrupt
+ * @map: map previously returned by mlx5_msix_alloc()
+ */
+void mlx5_msix_free(struct mlx5_core_dev *dev, struct msi_map map)
+{
+	free_irq(map.virq, NULL);
+	pci_msix_free_irq(dev->pdev, map);
+}
+EXPORT_SYMBOL(mlx5_msix_free);
+
 /**
  * mlx5_irqs_release_vectors - release one or more IRQs back to the system.
  * @irqs: IRQs to be released.
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f33389b42209..df0f82110249 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1308,4 +1308,10 @@ enum {
 	MLX5_OCTWORD = 16,
 };
 
+struct msi_map mlx5_msix_alloc(struct mlx5_core_dev *dev,
+			       irqreturn_t (*handler)(int, void *),
+			       const struct irq_affinity_desc *affdesc,
+			       const char *name);
+void mlx5_msix_free(struct mlx5_core_dev *dev, struct msi_map map);
+
 #endif /* MLX5_DRIVER_H */
-- 
2.39.2


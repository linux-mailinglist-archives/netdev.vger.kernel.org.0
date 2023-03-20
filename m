Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BD56C1ED3
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjCTSA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCTSAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931351EBF5
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:55:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CE05B8106C
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 17:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED31C4339B;
        Mon, 20 Mar 2023 17:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679334720;
        bh=Qh0Id78HZ0A/0Qvqe/i0eRkeco1JoW5kD1G2WBRG2NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGTc6m3S/yoejmRllOAimOgSFxCLlCqmGu5H/dqLgPkncwszGAYjj1kzi3iHnG7sE
         hGDTFKkdca+2u4u9MONy9SmU/VyUJEYAo5mUvHgQ9cGxUmNumGDlAY6hRxgIIP3oiO
         haZc7YS5TfkJnU48c2Tn9rgA+qST4Jc7WA3Fa6YCezIqAJNRJa8DXdGlihZZkULTdd
         HKmrj2jnHuuPIjAUKtAnv3eU8MxYALLPYurHMTJm1s4qM4PtHdlDfE348hbz60RRaA
         hibIOz6p6OoNK4ZveRTQB+rWp2K1KDtT4VK9AZDPFNKlxF/rZDF4dkPimXT78W3f23
         B4Y+QPvP+hnoQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [net-next 14/14] net/mlx5: Provide external API for allocating vectors
Date:   Mon, 20 Mar 2023 10:51:44 -0700
Message-Id: <20230320175144.153187-15-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320175144.153187-1-saeed@kernel.org>
References: <20230320175144.153187-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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


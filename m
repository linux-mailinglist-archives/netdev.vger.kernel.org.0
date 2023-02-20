Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9478469C546
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjBTGRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjBTGR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:17:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10ABFF2B
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 22:17:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76D96B80AB6
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 06:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B45C433D2;
        Mon, 20 Feb 2023 06:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676873822;
        bh=8HBekiqZ8bZAzGZNe+NBMdJ59+lOu9PnxgbsS/QgP3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8vidRdMLQfxqg5s3kq+zQu0pKXDyTxYdFInNb+F6fFEp/4CvyGOQp11MbloyZa2D
         JCKck8jgVcxw8HLqsyhMUD9W+hrQ39MVER5HjT0oQZ9ZXJfxoozh9fElsR/T/BXJKU
         xEKgjiQus7NTuyiaIW5E1KASQp+7csHqnhZPXBbaS7nKuexYgLBdp0kA8J+fCxGqV9
         g3+Dync2t1AdS8a0rC1JRLcOtGBsEIfvAyAkGtLZarTiux1jR6YMVhw2DVd8+E1zaH
         MIzM/FRIgOzp5dyDBUNuhN6cg7Pad73UwcKU/BZzaJfe2GqhmLA4b/3iLkyjJbgyam
         fZYEGMEzkZwiA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next 09/14] net/mlx5: Refactor completion irq request/release code
Date:   Sun, 19 Feb 2023 22:14:37 -0800
Message-Id: <20230220061442.403092-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230220061442.403092-1-saeed@kernel.org>
References: <20230220061442.403092-1-saeed@kernel.org>
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

Break the request and release functions into pci and sub-functions
devices handling for better readability, eventually making the code
symmetric in terms of request/release.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 70 +++++++++++++-------
 1 file changed, 46 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 452f2b2612c6..0649b47703a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -804,44 +804,28 @@ void mlx5_eq_update_ci(struct mlx5_eq *eq, u32 cc, bool arm)
 }
 EXPORT_SYMBOL(mlx5_eq_update_ci);
 
-static void comp_irqs_release(struct mlx5_core_dev *dev)
+static void comp_irqs_release_pci(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
 
-	if (mlx5_core_is_sf(dev))
-		mlx5_irq_affinity_irqs_release(dev, table->comp_irqs, table->num_comp_eqs);
-	else
-		mlx5_irqs_release_vectors(table->comp_irqs, table->num_comp_eqs);
-	kfree(table->comp_irqs);
+	mlx5_irqs_release_vectors(table->comp_irqs, table->num_comp_eqs);
 }
 
-static int comp_irqs_request(struct mlx5_core_dev *dev)
+static int comp_irqs_request_pci(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
 	const struct cpumask *prev = cpu_none_mask;
 	const struct cpumask *mask;
-	int ncomp_eqs = table->num_comp_eqs;
+	int ncomp_eqs;
 	u16 *cpus;
 	int ret;
 	int cpu;
 	int i;
 
 	ncomp_eqs = table->num_comp_eqs;
-	table->comp_irqs = kcalloc(ncomp_eqs, sizeof(*table->comp_irqs), GFP_KERNEL);
-	if (!table->comp_irqs)
-		return -ENOMEM;
-	if (mlx5_core_is_sf(dev)) {
-		ret = mlx5_irq_affinity_irqs_request_auto(dev, ncomp_eqs, table->comp_irqs);
-		if (ret < 0)
-			goto free_irqs;
-		return ret;
-	}
-
 	cpus = kcalloc(ncomp_eqs, sizeof(*cpus), GFP_KERNEL);
-	if (!cpus) {
+	if (!cpus)
 		ret = -ENOMEM;
-		goto free_irqs;
-	}
 
 	i = 0;
 	rcu_read_lock();
@@ -857,12 +841,50 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
 	rcu_read_unlock();
 	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
 	kfree(cpus);
-	if (ret < 0)
-		goto free_irqs;
 	return ret;
+}
+
+static void comp_irqs_release_sf(struct mlx5_core_dev *dev)
+{
+	struct mlx5_eq_table *table = dev->priv.eq_table;
+
+	mlx5_irq_affinity_irqs_release(dev, table->comp_irqs, table->num_comp_eqs);
+}
+
+static int comp_irqs_request_sf(struct mlx5_core_dev *dev)
+{
+	struct mlx5_eq_table *table = dev->priv.eq_table;
+	int ncomp_eqs = table->num_comp_eqs;
+
+	return mlx5_irq_affinity_irqs_request_auto(dev, ncomp_eqs, table->comp_irqs);
+}
+
+static void comp_irqs_release(struct mlx5_core_dev *dev)
+{
+	struct mlx5_eq_table *table = dev->priv.eq_table;
+
+	mlx5_core_is_sf(dev) ? comp_irqs_release_sf(dev) :
+			       comp_irqs_release_pci(dev);
 
-free_irqs:
 	kfree(table->comp_irqs);
+}
+
+static int comp_irqs_request(struct mlx5_core_dev *dev)
+{
+	struct mlx5_eq_table *table = dev->priv.eq_table;
+	int ncomp_eqs;
+	int ret;
+
+	ncomp_eqs = table->num_comp_eqs;
+	table->comp_irqs = kcalloc(ncomp_eqs, sizeof(*table->comp_irqs), GFP_KERNEL);
+	if (!table->comp_irqs)
+		return -ENOMEM;
+
+	ret = mlx5_core_is_sf(dev) ? comp_irqs_request_sf(dev) :
+				     comp_irqs_request_pci(dev);
+	if (ret < 0)
+		kfree(table->comp_irqs);
+
 	return ret;
 }
 
-- 
2.39.1


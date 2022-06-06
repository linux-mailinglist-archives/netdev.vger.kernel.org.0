Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A140B53E28D
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiFFHOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 03:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiFFHON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 03:14:13 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CA823140;
        Mon,  6 Jun 2022 00:14:11 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654499648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8/spSkG48ZCb5AaW/OX1PXeTSCTspY6xIl9KOwnlQEE=;
        b=HKbJr/9P6lZoMfgp514GsqB9AzkN6RClucSsvn4YoglgScPcGxpWvpyMvmnZCqA4ADFhB/
        K2CRbBlNyR5YJRNBXTF5sv8/iMZmrG/81kqx7WSNXty4rzUc8+K3dnBta1sTlO6Tc4hm0x
        92o2Oack6RKuc+sxHHAxujuivfg6408=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] net/mlx5: Add affinity for each irq
Date:   Mon,  6 Jun 2022 15:13:51 +0800
Message-Id: <20220606071351.3550997-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx5 would allocate no less than one irq for per cpu, we can bond each
irq to a cpu to improve interrupt performance.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 662f1d55e30e..d13fc403fe78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -624,11 +624,27 @@ int mlx5_irq_table_get_num_comp(struct mlx5_irq_table *table)
 	return table->pf_pool->xa_num_irqs.max - table->pf_pool->xa_num_irqs.min;
 }
 
+static void mlx5_calc_sets(struct irq_affinity *affd, unsigned int nvecs)
+{
+	int i;
+
+	affd->nr_sets = (nvecs - 1) / num_possible_cpus() + 1;
+
+	for (i = 0; i < affd->nr_sets; i++) {
+		affd->set_size[i] = min(nvecs, num_possible_cpus());
+		nvecs -= num_possible_cpus();
+	}
+}
+
 int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 {
 	int num_eqs = MLX5_CAP_GEN(dev, max_num_eqs) ?
 		      MLX5_CAP_GEN(dev, max_num_eqs) :
 		      1 << MLX5_CAP_GEN(dev, log_max_eq);
+	struct irq_affinity affd = {
+		.pre_vectors = 0,
+		.calc_sets   = mlx5_calc_sets,
+	};
 	int total_vec;
 	int pf_vec;
 	int err;
@@ -644,7 +660,8 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 		total_vec += MLX5_IRQ_CTRL_SF_MAX +
 			MLX5_COMP_EQS_PER_SF * mlx5_sf_max_functions(dev);
 
-	total_vec = pci_alloc_irq_vectors(dev->pdev, 1, total_vec, PCI_IRQ_MSIX);
+	total_vec = pci_alloc_irq_vectors_affinity(dev->pdev, 1, total_vec,
+						   PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, &affd);
 	if (total_vec < 0)
 		return total_vec;
 	pf_vec = min(pf_vec, total_vec);
-- 
2.25.1


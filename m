Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F0541E4A6
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350304AbhI3XRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:17:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350170AbhI3XQu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:16:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 489BB61A7C;
        Thu, 30 Sep 2021 23:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633043707;
        bh=BcHFYpVr2qBK6YZXkBga82rtpkWmLVCWUF/SzF5xsic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMRKnxqKXoSHO41YRXPhPvrqnrF4DcGgM1tmCWPgkvcXTvRXjgw1Bdiz2Ir4b4mjC
         YO0JO0H71inzCsOOYVoErpDwMERUObq1uZ4JTIxWZR96cDgLbOBvojCh8AnlxwCJtb
         kY6oJ9ZOxAQICqa0SJh8k4AiAieO4D+iTq3JJKKo+zz/RxP97LNn6UuO2HTQ+axmxd
         ANWgwFSOC4lDdSiwYN+eHxbfc3PXMW+asncsJn4KCxKkfUPtc5bW8O0e6L2yKuxjIa
         BmFEbqoOVUgGuQKuuwx1nQHDmElH2RzI223Ja6KZjnUZPmtckPYa1m0JCN0JswLcGs
         kVwagq/fabPeQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/10] net/mlx5: Fix setting number of EQs of SFs
Date:   Thu, 30 Sep 2021 16:14:59 -0700
Message-Id: <20210930231501.39062-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930231501.39062-1-saeed@kernel.org>
References: <20210930231501.39062-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

When setting number of completion EQs of the SF, consider number of
online CPUs.
Without this consideration, when number of online cpus are less than 8,
unnecessary 8 completion EQs are allocated.

Fixes: c36326d38d93 ("net/mlx5: Round-Robin EQs over IRQs")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index df54f62a38ac..763c83a02380 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -633,8 +633,9 @@ void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 int mlx5_irq_table_get_sfs_vec(struct mlx5_irq_table *table)
 {
 	if (table->sf_comp_pool)
-		return table->sf_comp_pool->xa_num_irqs.max -
-			table->sf_comp_pool->xa_num_irqs.min + 1;
+		return min_t(int, num_online_cpus(),
+			     table->sf_comp_pool->xa_num_irqs.max -
+			     table->sf_comp_pool->xa_num_irqs.min + 1);
 	else
 		return mlx5_irq_table_get_num_comp(table);
 }
-- 
2.31.1


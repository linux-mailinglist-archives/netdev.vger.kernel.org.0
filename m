Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF9E47D893
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 22:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbhLVVMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 16:12:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54742 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238062AbhLVVMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 16:12:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C514BB81E6E
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 21:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CA6C36AEA;
        Wed, 22 Dec 2021 21:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640207526;
        bh=uGc2D8Z6Ym7xIIDT7+Ww6HZQPN5LHmGLAS0h057aefA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Doxs4XoLMCCdXVI6C7U76APE5TSvrUYlsQB3HziwFTLxYvAcLzr+m+oYS5itSLGYL
         Sk825miSnaiopG3NWxCNHLyDkBWyvqSXxSWRvEsif9oCRVi4hmT/05P5fSPfgzM9Eu
         yjStuwlnDwrauroWDR2k5ry8nA7a7b4F3RgS5Z7+GhGN8xcEdHI2yvX2DC85aaelUX
         FsVVE10RCyrlay8jVf3RaVqjptSgn0KK6yUdZbMmnnURn50oIA4AZDIqOa7QdrkVgp
         lDiNHz+KUnXUWsqmZU0RdSVRCY+EB/nKvS2+dbbNowNH6TATWrdwvhY27NwaAMBr7r
         XAIOcyPS50yLw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 03/11] net/mlx5: Use first online CPU instead of hard coded CPU
Date:   Wed, 22 Dec 2021 13:11:53 -0800
Message-Id: <20211222211201.77469-4-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222211201.77469-1-saeed@kernel.org>
References: <20211222211201.77469-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Hard coded CPU (0 in our case) might be offline. Hence, use the first
online CPU instead.

Fixes: f891b7cdbdcd ("net/mlx5: Enable single IRQ for PCI Function")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 830444f927d4..0e84c005d160 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -398,7 +398,7 @@ irq_pool_request_vector(struct mlx5_irq_pool *pool, int vecidx,
 	cpumask_copy(irq->mask, affinity);
 	if (!irq_pool_is_sf_pool(pool) && !pool->xa_num_irqs.max &&
 	    cpumask_empty(irq->mask))
-		cpumask_set_cpu(0, irq->mask);
+		cpumask_set_cpu(cpumask_first(cpu_online_mask), irq->mask);
 	irq_set_affinity_hint(irq->irqn, irq->mask);
 unlock:
 	mutex_unlock(&pool->lock);
-- 
2.33.1


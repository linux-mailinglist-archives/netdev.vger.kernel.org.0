Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06C43E51AE
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 06:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhHJEAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhHJEAE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 00:00:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02D6361052;
        Tue, 10 Aug 2021 03:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628567983;
        bh=eT944fd4u2ysauXwgMIKLI72gj8On/Rn0sX/Rce8NdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSBtat7MQb90C/j5M0/3klcoWJZoRNpLr4YAxM0UnfvDzz1yRJeQfpY0BWj4cs55t
         imvEJujoW4zASJrxC5Nf/HEq4hPMS4z+apbQCfK38jkvETqbBko+hI00oFiNCtgE9w
         OdObNjw0uwJ2mKnunElwG8vij0D4+VtbZ6LujhQaiEI2GV4yslIKFztFRu+aRNPBZp
         7Gv13MYXG6jNKIz9nTMRXembJHw4uoTgqIoVbY+lLhOXhbgja1RwGJZ+Lrofe/5OU5
         yvW2o+Kzn7VlyAYRYbw8GHcRG4WO1hNciVX6Ssxy5+DwZfySaPl/clJq2QB00biskX
         FXRGyQedxKnFw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/12] net/mlx5: Set all field of mlx5_irq before inserting it to the xarray
Date:   Mon,  9 Aug 2021 20:59:19 -0700
Message-Id: <20210810035923.345745-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810035923.345745-1-saeed@kernel.org>
References: <20210810035923.345745-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Currently irq->pool is set after the irq is insert to the xarray.
Set irq->pool before the irq is inserted to the xarray.

Fixes: 71e084e26414 ("net/mlx5: Allocating a pool of MSI-X vectors for SFs")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 95e60da33f03..7b923f6b5462 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -214,6 +214,7 @@ static struct mlx5_irq *irq_request(struct mlx5_irq_pool *pool, int i)
 		err = -ENOMEM;
 		goto err_cpumask;
 	}
+	irq->pool = pool;
 	kref_init(&irq->kref);
 	irq->index = i;
 	err = xa_err(xa_store(&pool->irqs, irq->index, irq, GFP_KERNEL));
@@ -222,7 +223,6 @@ static struct mlx5_irq *irq_request(struct mlx5_irq_pool *pool, int i)
 			      irq->index, err);
 		goto err_xa;
 	}
-	irq->pool = pool;
 	return irq;
 err_xa:
 	free_cpumask_var(irq->mask);
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E40C486ECD
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344244AbiAGAaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiAGAaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:30:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7194C061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47ED961DE7
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B86C36AE5;
        Fri,  7 Jan 2022 00:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641515411;
        bh=c30UAgK4ZkN2dw4774tcf2FpVaaUlRgHgxMM/sQHsOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t14Q4P4exh0nJRK7vMavPTiwZDDX4GXDZIYoQTOwPKx+Vb79vWlt3EJstt2zj2Fk1
         bL26L017tNIA2dKhdWsaKqEUxmp/6HRHYhK+s5Q1YJt9C37t/VkFCrHKa9E/29zPC0
         bTWLV0MLQ0riujblcjBZU+5vYSDfSdOidmX8xEWXpCPLMPiAa9bYuBWdAo5AT11FM8
         DTpQ5kISWnahYFdrimaEKvApp9vJNvzbKZi06xDXgpYUgmSofK0FpkyFLFIQdXspSC
         1fs0h/exeIxpqVvSioNt7g+Bad3BaOUr3RQ3ZVhfpFzg9SrJ6Vjsqlw+YmDvhkY1qM
         UsPrNqpvd/xbQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 03/15] net/mlx5: Move affinity assignment into irq_request
Date:   Thu,  6 Jan 2022 16:29:44 -0800
Message-Id: <20220107002956.74849-4-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107002956.74849-1-saeed@kernel.org>
References: <20220107002956.74849-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Move affinity binding of the IRQ to irq_request function in order to
bind the IRQ before inserting it to the xarray.

After this change, the IRQ is ready for use when inserted to the xarray.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 22 ++++++++-----------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 510a9b91ff9a..656a55114600 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -215,7 +215,8 @@ static bool irq_pool_is_sf_pool(struct mlx5_irq_pool *pool)
 	return !strncmp("mlx5_sf", pool->name, strlen("mlx5_sf"));
 }
 
-static struct mlx5_irq *irq_request(struct mlx5_irq_pool *pool, int i)
+static struct mlx5_irq *irq_request(struct mlx5_irq_pool *pool, int i,
+				    struct cpumask *affinity)
 {
 	struct mlx5_core_dev *dev = pool->dev;
 	char name[MLX5_MAX_IRQ_NAME];
@@ -244,6 +245,10 @@ static struct mlx5_irq *irq_request(struct mlx5_irq_pool *pool, int i)
 		err = -ENOMEM;
 		goto err_cpumask;
 	}
+	if (affinity) {
+		cpumask_copy(irq->mask, affinity);
+		irq_set_affinity_hint(irq->irqn, irq->mask);
+	}
 	irq->pool = pool;
 	irq->refcount = 1;
 	irq->index = i;
@@ -255,6 +260,7 @@ static struct mlx5_irq *irq_request(struct mlx5_irq_pool *pool, int i)
 	}
 	return irq;
 err_xa:
+	irq_set_affinity_hint(irq->irqn, NULL);
 	free_cpumask_var(irq->mask);
 err_cpumask:
 	free_irq(irq->irqn, &irq->nh);
@@ -304,7 +310,6 @@ int mlx5_irq_get_index(struct mlx5_irq *irq)
 static struct mlx5_irq *irq_pool_create_irq(struct mlx5_irq_pool *pool,
 					    struct cpumask *affinity)
 {
-	struct mlx5_irq *irq;
 	u32 irq_index;
 	int err;
 
@@ -312,12 +317,7 @@ static struct mlx5_irq *irq_pool_create_irq(struct mlx5_irq_pool *pool,
 		       GFP_KERNEL);
 	if (err)
 		return ERR_PTR(err);
-	irq = irq_request(pool, irq_index);
-	if (IS_ERR(irq))
-		return irq;
-	cpumask_copy(irq->mask, affinity);
-	irq_set_affinity_hint(irq->irqn, irq->mask);
-	return irq;
+	return irq_request(pool, irq_index, affinity);
 }
 
 /* looking for the irq with the smallest refcount and the same affinity */
@@ -392,11 +392,7 @@ irq_pool_request_vector(struct mlx5_irq_pool *pool, int vecidx,
 		irq_get_locked(irq);
 		goto unlock;
 	}
-	irq = irq_request(pool, vecidx);
-	if (IS_ERR(irq) || !affinity)
-		goto unlock;
-	cpumask_copy(irq->mask, affinity);
-	irq_set_affinity_hint(irq->irqn, irq->mask);
+	irq = irq_request(pool, vecidx, affinity);
 unlock:
 	mutex_unlock(&pool->lock);
 	return irq;
-- 
2.33.1


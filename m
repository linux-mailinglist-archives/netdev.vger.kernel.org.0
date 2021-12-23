Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E20E47E7E0
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 20:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244859AbhLWTEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 14:04:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37642 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244871AbhLWTEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 14:04:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2B4961F6A
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEC5C36AED;
        Thu, 23 Dec 2021 19:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640286288;
        bh=uGc2D8Z6Ym7xIIDT7+Ww6HZQPN5LHmGLAS0h057aefA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeXBZzE/Od2v2U0KGx6fWS5cSA6L3ZXPa3jzRDNSNpAE54dP9Wu8Nxa1uvuvY5W8h
         PhxHr8zwhoooCJzIp7mJJpOEk7N9ruvwgrnwS3qSSgmsL2teZrD/jddyXLWmxztEJF
         yuN7Lb6XNzapdDAVfTlshsxjAfX60GxHQkIrryuQOil9oJWHcLUL4hmX1FWaFeNTWb
         llTzJTz3nI9P/pK20jK1cBbWQz6iIwyIRQhnFgjTuD4NKTNopxnoJM1SPUA4R+kLfI
         t0yGPc5v66UrYHaBt1faXQrUOCm8mmneZvNHcIP19FhH5T/VzaFHO5E/pAfzLGjFzh
         beopvD95WWH6A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 03/12] net/mlx5: Use first online CPU instead of hard coded CPU
Date:   Thu, 23 Dec 2021 11:04:32 -0800
Message-Id: <20211223190441.153012-4-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211223190441.153012-1-saeed@kernel.org>
References: <20211223190441.153012-1-saeed@kernel.org>
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


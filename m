Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3120F47D88F
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 22:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbhLVVMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 16:12:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41268 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237972AbhLVVMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 16:12:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A45361D09
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 21:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8079FC36AE8;
        Wed, 22 Dec 2021 21:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640207526;
        bh=SlhTlYjoMyQbM07VFuF4OSVvD4Rz4uxvnSAp4PaeDns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIbnqVWs+QhIHo7IcI2eVYDZ59IWbByCb+/4nRaHFs2iSVY8GWKroET/Bgc8bx6Cu
         4OOoZJ7qXEQbYDDsOzWUWfjy6uki7PW6pg7i/+Zxk+9iwOKIRGelQuYfKRtSKb/8PT
         VIAT8Mnu2RK7/hOa14Cn8rsPbk8vV+KxtsoTQdSH9I1MkFabaZau+0hNwXWUf2hnf/
         FRyg9BW1r+WrBOGUFaiJNWZ2Mf8/Z2I/zbzwSWR05HgJC98uQ8K8O34UqJy+1D/NO2
         tMONVdmPZkONUBAY8/sCo4MngcnXam4HrGx0PCTCmAvfBUMcii7HrSdBGWhiRksn1S
         f1ZzVfNcd/Tuw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/11] net/mlx5: Fix error print in case of IRQ request failed
Date:   Wed, 22 Dec 2021 13:11:54 -0800
Message-Id: <20211222211201.77469-5-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222211201.77469-1-saeed@kernel.org>
References: <20211222211201.77469-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

In case IRQ layer failed to find or to request irq, the driver is
printing the first cpu of the provided affinity as part of the error
print. Empty affinity is a valid input for the IRQ layer, and it is
an error to call cpumask_first() on empty affinity.

Remove the first cpu print from the error message.

Fixes: c36326d38d93 ("net/mlx5: Round-Robin EQs over IRQs")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 0e84c005d160..bcee30f5de0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -356,8 +356,8 @@ static struct mlx5_irq *irq_pool_request_affinity(struct mlx5_irq_pool *pool,
 	new_irq = irq_pool_create_irq(pool, affinity);
 	if (IS_ERR(new_irq)) {
 		if (!least_loaded_irq) {
-			mlx5_core_err(pool->dev, "Didn't find IRQ for cpu = %u\n",
-				      cpumask_first(affinity));
+			mlx5_core_err(pool->dev, "Didn't find a matching IRQ. err = %ld\n",
+				      PTR_ERR(new_irq));
 			mutex_unlock(&pool->lock);
 			return new_irq;
 		}
-- 
2.33.1


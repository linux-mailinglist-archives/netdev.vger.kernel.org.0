Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8CA47E7E1
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 20:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349934AbhLWTEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 14:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244882AbhLWTEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 14:04:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E89CC061401
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 11:04:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BE9761F6A
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EA8C36AE5;
        Thu, 23 Dec 2021 19:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640286288;
        bh=SlhTlYjoMyQbM07VFuF4OSVvD4Rz4uxvnSAp4PaeDns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xy+vPizINF2Bz9UR1B7LkWhVYogdgR/Mxtc4r8PMdjF3IBPQn1VEaPmuo9xCU445f
         yrs97GnQhoX1tY2i9rtDROMaKVWORG5/FnNamNApTVRaeJmCZvYpTyBPj53AEtobn9
         aBMML6ONe+dmc1cd8YAZ21Sh0OL/TCcan+NDrbW7vzK8i1BoSeKBhjoH8ewzKPugZt
         beoWX8K+EqF3L3TIaUFfb49lX5EPTbUBzIaasiLaHiFdow/cG1EA+8PtFO7RxWMRdB
         6/e2DnxO8ZL2TqJwt6vv/YdPscUiERRZhLVo3oEgW/VC2NC5oW0tlp7quDy6CpfHd6
         2bhUwoWRtmd0w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 04/12] net/mlx5: Fix error print in case of IRQ request failed
Date:   Thu, 23 Dec 2021 11:04:33 -0800
Message-Id: <20211223190441.153012-5-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211223190441.153012-1-saeed@kernel.org>
References: <20211223190441.153012-1-saeed@kernel.org>
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


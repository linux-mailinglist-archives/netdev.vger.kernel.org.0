Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9140A2D3359
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731391AbgLHUQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731141AbgLHUPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:15:07 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 12/15] net/mlx5: Arm only EQs with EQEs
Date:   Tue,  8 Dec 2020 11:35:52 -0800
Message-Id: <20201208193555.674504-13-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208193555.674504-1-saeed@kernel.org>
References: <20201208193555.674504-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Currently, when more than one EQ is sharing an IRQ, and this IRQ is
being interrupted, all the EQs sharing the IRQ will be armed. This is
done regardless of whether an EQ has EQE.
When multiple EQs are sharing an IRQ, one or more EQs can have valid
EQEs.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 4ea5d6ddf56a..fc0afa03d407 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -136,7 +136,7 @@ static int mlx5_eq_comp_int(struct notifier_block *nb,
 
 	eqe = next_eqe_sw(eq);
 	if (!eqe)
-		goto out;
+		return 0;
 
 	do {
 		struct mlx5_core_cq *cq;
@@ -161,8 +161,6 @@ static int mlx5_eq_comp_int(struct notifier_block *nb,
 		++eq->cons_index;
 
 	} while ((++num_eqes < MLX5_EQ_POLLING_BUDGET) && (eqe = next_eqe_sw(eq)));
-
-out:
 	eq_update_ci(eq, 1);
 
 	if (cqn != -1)
@@ -250,9 +248,9 @@ static int mlx5_eq_async_int(struct notifier_block *nb,
 		++eq->cons_index;
 
 	} while ((++num_eqes < MLX5_EQ_POLLING_BUDGET) && (eqe = next_eqe_sw(eq)));
+	eq_update_ci(eq, 1);
 
 out:
-	eq_update_ci(eq, 1);
 	mlx5_eq_async_int_unlock(eq_async, recovery, &flags);
 
 	return unlikely(recovery) ? num_eqes : 0;
-- 
2.26.2


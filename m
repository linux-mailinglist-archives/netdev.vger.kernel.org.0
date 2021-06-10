Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345F03A215A
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhFJAYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230154AbhFJAYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 20:24:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 266BB61405;
        Thu, 10 Jun 2021 00:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623284541;
        bh=UT4bRoY4r750vnIS8n/ntKe6s0TAOpA/C9HJkEv3Cd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPIFQ1SJ7sgxpQ2aS84Jnau+cK3uy4ZbfTyHSycgRfmNeCVxYBE+70gAJW6fd99nW
         4jQYM3sDwrm4XgTWVLeDJl3wTEL3UgmLxie9vjnfLt6ZNQ35EKqqXkNTedKt6gOd0d
         PDpx8CLG+hbp8fC4GmOLI5su1dSY0iuEfFXODAPhFndtAvbiXxCV6xciw2C9fPfoLh
         zpJeCUIJsut5+J2FUYUr2QyEDKpSRnTM7xIPMO5EEG2kZ4ghmghP2S+dv1kzChhYXG
         31IAJk3Iqf3zDxLKESHTdw67NTYJ2Y7GPzwWIXNh3Xkg6DKylrAvArN/AgLrMHinkw
         IW767WjyBxbQw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/12] Revert "net/mlx5: Arm only EQs with EQEs"
Date:   Wed,  9 Jun 2021 17:21:53 -0700
Message-Id: <20210610002155.196735-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610002155.196735-1-saeed@kernel.org>
References: <20210610002155.196735-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

In the scenario described below, an EQ can remain in FIRED state which
can result in missing an interrupt generation.

The scenario:

device                       mlx5_core driver
------                       ----------------
EQ1.eqe generated
EQ1.MSI-X sent
EQ1.state = FIRED
EQ2.eqe generated
                             mlx5_irq()
                               polls - eq1_eqes()
                               arm eq1
                               polls - eq2_eqes()
                               arm eq2
EQ2.MSI-X sent
EQ2.state = FIRED
                              mlx5_irq()
                              polls - eq2_eqes() -- no eqes found
                              driver skips EQ arming;

->EQ2 remains fired, misses generating interrupt.

Hence, always arm the EQ by reverting the cited commit in fixes tag.

Fixes: d894892dda25 ("net/mlx5: Arm only EQs with EQEs")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 77c0ca655975..940333410267 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -136,7 +136,7 @@ static int mlx5_eq_comp_int(struct notifier_block *nb,
 
 	eqe = next_eqe_sw(eq);
 	if (!eqe)
-		return 0;
+		goto out;
 
 	do {
 		struct mlx5_core_cq *cq;
@@ -161,6 +161,8 @@ static int mlx5_eq_comp_int(struct notifier_block *nb,
 		++eq->cons_index;
 
 	} while ((++num_eqes < MLX5_EQ_POLLING_BUDGET) && (eqe = next_eqe_sw(eq)));
+
+out:
 	eq_update_ci(eq, 1);
 
 	if (cqn != -1)
@@ -248,9 +250,9 @@ static int mlx5_eq_async_int(struct notifier_block *nb,
 		++eq->cons_index;
 
 	} while ((++num_eqes < MLX5_EQ_POLLING_BUDGET) && (eqe = next_eqe_sw(eq)));
-	eq_update_ci(eq, 1);
 
 out:
+	eq_update_ci(eq, 1);
 	mlx5_eq_async_int_unlock(eq_async, recovery, &flags);
 
 	return unlikely(recovery) ? num_eqes : 0;
-- 
2.31.1


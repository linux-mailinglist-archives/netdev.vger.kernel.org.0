Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DEC348832
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 06:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhCYFFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 01:05:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229675AbhCYFEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 01:04:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38DA961A1B;
        Thu, 25 Mar 2021 05:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616648688;
        bh=Tb6EPv32gTzB1Gy9OHbchWVSYs+bK4gxqpclhW6IiWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCmmkR8EoMJQuqIXtEkftijLESnugt+Zm/WOuk8rg7YFDjpjnEMMm36VSc4FlM4y0
         Vw9beA5qWLtXftUp/VU22z5fFc9qct4Mz3H5scJ0HLnliHIPOp6AE9gJ8de5x1iy3O
         9+8sgrsPhDtH0oQYsJN/vsfUS5WaMyksQN/YN86nkor/4xI8gHqaGFTLpAOfEAK5Or
         1ChyobK5a0uCSekX0t/Ze2MbjrKCRmyC4WdOr3xnSyBWG37i2VuZaiwKFtW4LY89UP
         YVEVTV7fF+V3aIZOFmgk7JLrcXN2n5uRCjYwIbm7a1XFo5wgckZoswr9L8fapwNmCO
         emYZgW2hqD8CQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: Generalize RQ activation
Date:   Wed, 24 Mar 2021 22:04:33 -0700
Message-Id: <20210325050438.261511-11-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325050438.261511-1-saeed@kernel.org>
References: <20210325050438.261511-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Support RQ activation for RQs without an ICOSQ in the main flow, like
existing trap-RQ and like PTP-RQ that will be introduced in the coming
patches in the patchset.
With this patch, remove the wrapper in traps to deactivate the trap-RQ.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c | 15 ++-------------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  5 ++++-
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index 987035346cfc..d6e6641e9288 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -128,16 +128,6 @@ static void mlx5e_destroy_trap_direct_rq_tir(struct mlx5_core_dev *mdev, struct
 	mlx5e_destroy_tir(mdev, tir);
 }
 
-static void mlx5e_activate_trap_rq(struct mlx5e_rq *rq)
-{
-	set_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
-}
-
-static void mlx5e_deactivate_trap_rq(struct mlx5e_rq *rq)
-{
-	clear_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
-}
-
 static void mlx5e_build_trap_params(struct mlx5_core_dev *mdev,
 				    int max_mtu, u16 q_counter,
 				    struct mlx5e_trap *t)
@@ -202,15 +192,14 @@ void mlx5e_close_trap(struct mlx5e_trap *trap)
 static void mlx5e_activate_trap(struct mlx5e_trap *trap)
 {
 	napi_enable(&trap->napi);
-	mlx5e_activate_trap_rq(&trap->rq);
-	napi_schedule(&trap->napi);
+	mlx5e_activate_rq(&trap->rq);
 }
 
 void mlx5e_deactivate_trap(struct mlx5e_priv *priv)
 {
 	struct mlx5e_trap *trap = priv->en_trap;
 
-	mlx5e_deactivate_trap_rq(&trap->rq);
+	mlx5e_deactivate_rq(&trap->rq);
 	napi_disable(&trap->napi);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 638449f2d7ea..b25e1501e236 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -886,7 +886,10 @@ int mlx5e_open_rq(struct mlx5e_params *params, struct mlx5e_rq_param *param,
 void mlx5e_activate_rq(struct mlx5e_rq *rq)
 {
 	set_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
-	mlx5e_trigger_irq(rq->icosq);
+	if (rq->icosq)
+		mlx5e_trigger_irq(rq->icosq);
+	else
+		napi_schedule(rq->cq.napi);
 }
 
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
-- 
2.30.2


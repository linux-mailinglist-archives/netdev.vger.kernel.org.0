Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E10334E01F
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhC3E2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:28:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230244AbhC3E1r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:27:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 874AD61999;
        Tue, 30 Mar 2021 04:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617078466;
        bh=EwvjAiY8IFI8GgSon7OHmzXeeXYKEbc/OVKaTIwQPc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXSDEfg+rL+nu9SCUyfuH6LpaEZKZgJauHe6ZaW++TdYOK/5d8yQ0pkvn+5x7I0+D
         xE6A/t8iwdE8xy4KmRf1leAqRVvf/Uli/vhBclEcRB+PYkUCAzS1d6YNhvme3l3bUH
         cPtqsMbtQGOttcFDgzZ2s5DUZP8v1ITlLLIWjQN8gm62BfGId5JRQ0P/N5Zjl9sLox
         u598kuM+OuA2JykrC6BMgT3HAhHi8AwwQ2ga5ClXLG0b0YnEkIqvYtW8y0SN2lrkoA
         ivdvd3RllOwVjJOdu0F4G+IL3/Af6Sg55rA4QYZtEsnu+0yzRGwduByduMkMvlV8Xi
         BtnsNCmL1230w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/12] net/mlx5e: Refactor RX reporter diagnostics
Date:   Mon, 29 Mar 2021 21:27:34 -0700
Message-Id: <20210330042741.198601-6-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330042741.198601-1-saeed@kernel.org>
References: <20210330042741.198601-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Break RX diagnostics function into smaller helpers. This enables easier
enhancement in the next patch in the set.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/reporter_rx.c       | 104 +++++++++++-------
 1 file changed, 66 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 34b3b316b688..78d801bac8f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -230,8 +230,9 @@ static int mlx5e_reporter_icosq_diagnose(struct mlx5e_icosq *icosq, u8 hw_state,
 	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 }
 
-static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
-						   struct devlink_fmsg *fmsg)
+static int
+mlx5e_rx_reporter_build_diagnose_output_rq_common(struct mlx5e_rq *rq,
+						  struct devlink_fmsg *fmsg)
 {
 	u16 wqe_counter;
 	int wqes_sz;
@@ -247,14 +248,6 @@ static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 	wq_head = mlx5e_rqwq_get_head(rq);
 	wqe_counter = mlx5e_rqwq_get_wqe_counter(rq);
 
-	err = devlink_fmsg_obj_nest_start(fmsg);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_u32_pair_put(fmsg, "channel ix", rq->ix);
-	if (err)
-		return err;
-
 	err = devlink_fmsg_u32_pair_put(fmsg, "rqn", rq->rqn);
 	if (err)
 		return err;
@@ -300,61 +293,96 @@ static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 			return err;
 	}
 
-	err = devlink_fmsg_obj_nest_end(fmsg);
+	return 0;
+}
+
+static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
+						   struct devlink_fmsg *fmsg)
+{
+	int err;
+
+	err = devlink_fmsg_obj_nest_start(fmsg);
 	if (err)
 		return err;
 
-	return 0;
+	err = devlink_fmsg_u32_pair_put(fmsg, "channel ix", rq->ix);
+	if (err)
+		return err;
+
+	err = mlx5e_rx_reporter_build_diagnose_output_rq_common(rq, fmsg);
+	if (err)
+		return err;
+
+	return devlink_fmsg_obj_nest_end(fmsg);
 }
 
-static int mlx5e_rx_reporter_diagnose(struct devlink_health_reporter *reporter,
-				      struct devlink_fmsg *fmsg,
-				      struct netlink_ext_ack *extack)
+static int mlx5e_rx_reporter_diagnose_generic_rq(struct mlx5e_rq *rq,
+						 struct devlink_fmsg *fmsg)
 {
-	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
-	struct mlx5e_params *params = &priv->channels.params;
-	struct mlx5e_rq *generic_rq;
+	struct mlx5e_priv *priv = rq->priv;
+	struct mlx5e_params *params;
 	u32 rq_stride, rq_sz;
-	int i, err = 0;
-
-	mutex_lock(&priv->state_lock);
-
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
-		goto unlock;
+	int err;
 
-	generic_rq = &priv->channels.c[0]->rq;
-	rq_sz = mlx5e_rqwq_get_size(generic_rq);
+	params = &priv->channels.params;
+	rq_sz = mlx5e_rqwq_get_size(rq);
 	rq_stride = BIT(mlx5e_mpwqe_get_log_stride_size(priv->mdev, params, NULL));
 
-	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "Common config");
-	if (err)
-		goto unlock;
-
 	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "RQ");
 	if (err)
-		goto unlock;
+		return err;
 
 	err = devlink_fmsg_u8_pair_put(fmsg, "type", params->rq_wq_type);
 	if (err)
-		goto unlock;
+		return err;
 
 	err = devlink_fmsg_u64_pair_put(fmsg, "stride size", rq_stride);
 	if (err)
-		goto unlock;
+		return err;
 
 	err = devlink_fmsg_u32_pair_put(fmsg, "size", rq_sz);
 	if (err)
-		goto unlock;
+		return err;
 
-	err = mlx5e_health_cq_common_diag_fmsg(&generic_rq->cq, fmsg);
+	err = mlx5e_health_cq_common_diag_fmsg(&rq->cq, fmsg);
 	if (err)
-		goto unlock;
+		return err;
 
-	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
+	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
+}
+
+static int
+mlx5e_rx_reporter_diagnose_common_config(struct devlink_health_reporter *reporter,
+					 struct devlink_fmsg *fmsg)
+{
+	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
+	struct mlx5e_rq *generic_rq = &priv->channels.c[0]->rq;
+	int err;
+
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "Common config");
 	if (err)
+		return err;
+
+	err = mlx5e_rx_reporter_diagnose_generic_rq(generic_rq, fmsg);
+	if (err)
+		return err;
+
+	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
+}
+
+static int mlx5e_rx_reporter_diagnose(struct devlink_health_reporter *reporter,
+				      struct devlink_fmsg *fmsg,
+				      struct netlink_ext_ack *extack)
+{
+	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
+	int i, err = 0;
+
+	mutex_lock(&priv->state_lock);
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		goto unlock;
 
-	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
+	err = mlx5e_rx_reporter_diagnose_common_config(reporter, fmsg);
 	if (err)
 		goto unlock;
 
-- 
2.30.2


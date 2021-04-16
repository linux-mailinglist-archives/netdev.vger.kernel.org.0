Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD0336281D
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239731AbhDPSzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:55:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236516AbhDPSzL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:55:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BA25613BB;
        Fri, 16 Apr 2021 18:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599286;
        bh=dEzhXy9n92IIbSsFn2fig1tFteehP7Nn7naPtQ2uaWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjeUQ3XnUSGTQsNiQlEoQOV0/bW1+949y7DFanhG+VMWymCxIDU7cdZhXdenwEvoy
         f3+XuN+5jvKY6Fl36uFplOEGZCXtZRvwU1uKZS7zt6OX9dBjMlN8AW4VXB1HWsrzTR
         PcUtZ7ioo3CHDLL7JLHBH6QAEOObwRDOta/mt6Wu44b3y8H1GrFwGQ9KtZ+yGYyN9K
         7MlbenMsGszv5GjgLXFHbH0Y1dGzWhTbAy6+Es8bTsvMalTcb77zPRNiVgs0uem4aS
         W2ZdBa3dUlISe3kPaav9ez+Mzmg3l7mW7hoK21dhzSoB0poSMSxfoSLUjqJrpLg59x
         3kbOCazcTFVVA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/14] net/mlx5: Enhance diagnostics info for TX/RX reporters
Date:   Fri, 16 Apr 2021 11:54:30 -0700
Message-Id: <20210416185430.62584-15-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416185430.62584-1-saeed@kernel.org>
References: <20210416185430.62584-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add ts_format to 'Common Config' section of the TX/RX devlink reporters
diagnostics info. Possible values for ts_format: 'RT' or 'FRC'
which stands for: Real Time and Free Running Counters correspondingly.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index f9fdf3606bbd..0eb125316fe2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -323,10 +323,12 @@ static int mlx5e_rx_reporter_diagnose_generic_rq(struct mlx5e_rq *rq,
 	struct mlx5e_priv *priv = rq->priv;
 	struct mlx5e_params *params;
 	u32 rq_stride, rq_sz;
+	bool real_time;
 	int err;
 
 	params = &priv->channels.params;
 	rq_sz = mlx5e_rqwq_get_size(rq);
+	real_time =  mlx5_is_real_time_rq(priv->mdev);
 	rq_stride = BIT(mlx5e_mpwqe_get_log_stride_size(priv->mdev, params, NULL));
 
 	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "RQ");
@@ -345,6 +347,10 @@ static int mlx5e_rx_reporter_diagnose_generic_rq(struct mlx5e_rq *rq,
 	if (err)
 		return err;
 
+	err = devlink_fmsg_string_pair_put(fmsg, "ts_format", real_time ? "RT" : "FRC");
+	if (err)
+		return err;
+
 	err = mlx5e_health_cq_common_diag_fmsg(&rq->cq, fmsg);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 1a0505bd1e9a..9d361efd5ff7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -257,12 +257,14 @@ mlx5e_tx_reporter_diagnose_generic_txqsq(struct devlink_fmsg *fmsg,
 					 struct mlx5e_txqsq *txqsq)
 {
 	u32 sq_stride, sq_sz;
+	bool real_time;
 	int err;
 
 	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "SQ");
 	if (err)
 		return err;
 
+	real_time =  mlx5_is_real_time_sq(txqsq->mdev);
 	sq_sz = mlx5_wq_cyc_get_size(&txqsq->wq);
 	sq_stride = MLX5_SEND_WQE_BB;
 
@@ -274,6 +276,10 @@ mlx5e_tx_reporter_diagnose_generic_txqsq(struct devlink_fmsg *fmsg,
 	if (err)
 		return err;
 
+	err = devlink_fmsg_string_pair_put(fmsg, "ts_format", real_time ? "RT" : "FRC");
+	if (err)
+		return err;
+
 	err = mlx5e_health_cq_common_diag_fmsg(&txqsq->cq, fmsg);
 	if (err)
 		return err;
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9CE348830
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 06:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhCYFFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 01:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229666AbhCYFEr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 01:04:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42E9661A1F;
        Thu, 25 Mar 2021 05:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616648687;
        bh=CkvTTdysrmsS7UDiAFMcQsXcQ4Ddzc3KqFCvP+IbHZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAj2EDqJQYAnc4URmUweYUbZWZvD6uqRtqm2tD+VW3BZyoMVvh9lvD+/vEsKDOJEW
         vaeMC7lbAtfXUmS4AynGgzyBXw7+TN/EdUwQCma3wuA5/wV8J01MeDv7EC+tuWyMX2
         UDEN+179K49XD0G5/cs8eI2mjRKHCXEjuPGe3C3oZfpEHyDP4m36rmjZUZsnR2xUIR
         +6WGO3p92JMK9QWIAUlQ0SuNVH58CSfLkeWJJyG2JRtGXY1uONrTdAOWOE+tO5Slpo
         3y9sYRdZBviMOJSvwGnATkzifXWit2X3wImkIaftVHx/Djg7SRhyMaRefrxvaKzxdT
         b5asOMaN54fKw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5: Add helper to set time-stamp translator on a queue
Date:   Wed, 24 Mar 2021 22:04:31 -0700
Message-Id: <20210325050438.261511-9-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325050438.261511-1-saeed@kernel.org>
References: <20210325050438.261511-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Translation method on the time-stamp is set by the capabilities. Avoid
code duplication by using a helper to set ptp_cyc2time callback on a
queue.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c    |  4 +---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   |  8 ++------
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h | 11 +++++++++++
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 27b5c7b143b2..fb93edf910b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -183,9 +183,7 @@ static int mlx5e_ptp_alloc_txqsq(struct mlx5e_port_ptp *c, int txq_ix,
 	if (!MLX5_CAP_ETH(mdev, wqe_vlan_insert))
 		set_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state);
 	sq->stop_room = param->stop_room;
-	sq->ptp_cyc2time = mlx5_is_real_time_sq(mdev) ?
-			   mlx5_real_time_cyc2time :
-			   mlx5_timecounter_cyc2time;
+	sq->ptp_cyc2time = mlx5_sq_ts_translator(mdev);
 
 	node = dev_to_node(mlx5_core_dma_dev(mdev));
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 4ffe42641a2e..72aef60c4efc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -404,9 +404,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	rq->hw_mtu  = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	rq->xdpsq   = &c->rq_xdpsq;
 	rq->xsk_pool = xsk_pool;
-	rq->ptp_cyc2time = mlx5_is_real_time_rq(mdev) ?
-			   mlx5_real_time_cyc2time :
-			   mlx5_timecounter_cyc2time;
+	rq->ptp_cyc2time = mlx5_rq_ts_translator(mdev);
 
 	if (rq->xsk_pool)
 		rq->stats = &c->priv->channel_stats[c->ix].xskrq;
@@ -1141,9 +1139,7 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	if (param->is_mpw)
 		set_bit(MLX5E_SQ_STATE_MPWQE, &sq->state);
 	sq->stop_room = param->stop_room;
-	sq->ptp_cyc2time = mlx5_is_real_time_sq(mdev) ?
-			   mlx5_real_time_cyc2time :
-			   mlx5_timecounter_cyc2time;
+	sq->ptp_cyc2time = mlx5_sq_ts_translator(mdev);
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
 	err = mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
index a12c7da618a7..ceae6bc378e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
@@ -105,4 +105,15 @@ static inline ktime_t mlx5_real_time_cyc2time(struct mlx5_clock *clock,
 }
 #endif
 
+static inline cqe_ts_to_ns mlx5_rq_ts_translator(struct mlx5_core_dev *mdev)
+{
+	return mlx5_is_real_time_rq(mdev) ? mlx5_real_time_cyc2time :
+					    mlx5_timecounter_cyc2time;
+}
+
+static inline cqe_ts_to_ns mlx5_sq_ts_translator(struct mlx5_core_dev *mdev)
+{
+	return mlx5_is_real_time_sq(mdev) ? mlx5_real_time_cyc2time :
+					    mlx5_timecounter_cyc2time;
+}
 #endif
-- 
2.30.2


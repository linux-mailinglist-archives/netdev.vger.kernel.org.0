Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4E7388754
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244227AbhESGIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:08:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238725AbhESGHc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1259613B4;
        Wed, 19 May 2021 06:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404373;
        bh=e8odYyZKcPDH3XYm9115kGbNnwxo6ckzZzATiGke4lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYTb3/dKAbeOkjyJw4Kp8s+5QiNAZVPcIejQwFG72oWS8gBtYOQTJIvMzh+Y+p10l
         wX8i0OieEldQfsYTcVnyIhwzz+xXouFc9EZet9JeSsd4JTWfbFz8kaMa/wzKDUGvZc
         687iXD8cvK5d/x/IePqFJuZQgT1aswj6h9T7+VBctg35aZIXDHmhgsNxgBlXjMn94f
         K2nvUbwzZKp50eJPhsQPBWBajSHLsJP0n21G2tRCf+OQ2ahdw5rvshxJYdtxsiwHMa
         9gqz7UqBbiEdq/AE2p5Zb5wtxmCSkBs0SILb5bUyeH8+EB3QJgFMivIP/9RxmDztNj
         zTdyMrl0P5j5w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 16/16] mlx5e: add add missing BH locking around napi_schdule()
Date:   Tue, 18 May 2021 23:05:23 -0700
Message-Id: <20210519060523.17875-17-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

It's not correct to call napi_schedule() in pure process
context. Because we use __raise_softirq_irqoff() we require
callers to be in a context which will eventually lead to
softirq handling (hardirq, bh disabled, etc.).

With code as is users will see:

 NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!

Fixes: a8dd7ac12fc3 ("net/mlx5e: Generalize RQ activation")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d1b9a4040d60..ad0f69480b9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -889,10 +889,13 @@ int mlx5e_open_rq(struct mlx5e_params *params, struct mlx5e_rq_param *param,
 void mlx5e_activate_rq(struct mlx5e_rq *rq)
 {
 	set_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
-	if (rq->icosq)
+	if (rq->icosq) {
 		mlx5e_trigger_irq(rq->icosq);
-	else
+	} else {
+		local_bh_disable();
 		napi_schedule(rq->cq.napi);
+		local_bh_enable();
+	}
 }
 
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
-- 
2.31.1


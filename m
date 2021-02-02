Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F18B30B840
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhBBHCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 02:02:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232281AbhBBG4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:56:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7559B64EE5;
        Tue,  2 Feb 2021 06:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248918;
        bh=yem73DVlg8Sy6MDK+eY7blGAKRvP7b8qQRDAItspzXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKZwARw61aaq35suRbfGBpAMJDcpvL0TiAwEuMOFnIPvOwprZnURk8jWjkEWtUN2x
         lYCyWlbfSL04FXIgGqksQVGUUeiX8AOy7DTEv2YDTgOSiKZxcsN0ytYoOPMszJ6oUM
         1yWjyXDmEA5wAGvHieWeMaqvmy9Df47Zaui6oX3++MCKuEIFChiVCe8gU3KHYsAwin
         lMrCUGlqKwUBZU3HfSxxj9hX6SXcft6Fimd1gFdfhXhMJD86Iybyk+UB8bEneVZlPC
         iECZHhCZpFqPRw3CuCEDXmXRy4NEm8lDhFjkWYf3IaNeRnOhjTF1gPhLiCk9SjKPLf
         k1f39lZKjCIsQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/14] net/mlx5e: Enable napi in channel's activation stage
Date:   Mon,  1 Feb 2021 22:54:51 -0800
Message-Id: <20210202065457.613312-9-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202065457.613312-1-saeed@kernel.org>
References: <20210202065457.613312-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

The channel's napi is first needed upon activation, not creation.
Minimize its enabled scope by moving it from the channel's open/close
stage into the activate/deactivate stage.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c  | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 14 ++++++--------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index eeddd1137dda..a76cfefec708 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -428,16 +428,13 @@ static int mlx5e_ptp_open_queues(struct mlx5e_port_ptp *c,
 	if (err)
 		return err;
 
-	napi_enable(&c->napi);
-
 	err = mlx5e_ptp_open_txqsqs(c, cparams);
 	if (err)
-		goto disable_napi;
+		goto close_cqs;
 
 	return 0;
 
-disable_napi:
-	napi_disable(&c->napi);
+close_cqs:
 	mlx5e_ptp_close_cqs(c);
 
 	return err;
@@ -446,7 +443,6 @@ static int mlx5e_ptp_open_queues(struct mlx5e_port_ptp *c,
 static void mlx5e_ptp_close_queues(struct mlx5e_port_ptp *c)
 {
 	mlx5e_ptp_close_txqsqs(c);
-	napi_disable(&c->napi);
 	mlx5e_ptp_close_cqs(c);
 }
 
@@ -515,6 +511,8 @@ void mlx5e_ptp_activate_channel(struct mlx5e_port_ptp *c)
 {
 	int tc;
 
+	napi_enable(&c->napi);
+
 	for (tc = 0; tc < c->num_tc; tc++)
 		mlx5e_activate_txqsq(&c->ptpsq[tc].txqsq);
 }
@@ -525,4 +523,6 @@ void mlx5e_ptp_deactivate_channel(struct mlx5e_port_ptp *c)
 
 	for (tc = 0; tc < c->num_tc; tc++)
 		mlx5e_deactivate_txqsq(&c->ptpsq[tc].txqsq);
+
+	napi_disable(&c->napi);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b9d2cb6f178d..41c611197211 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1892,13 +1892,11 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 	if (err)
 		goto err_close_rx_cq;
 
-	napi_enable(&c->napi);
-
 	spin_lock_init(&c->async_icosq_lock);
 
 	err = mlx5e_open_icosq(c, params, &cparam->async_icosq, &c->async_icosq);
 	if (err)
-		goto err_disable_napi;
+		goto err_close_xdpsq_cq;
 
 	err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->icosq);
 	if (err)
@@ -1941,9 +1939,7 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 err_close_async_icosq:
 	mlx5e_close_icosq(&c->async_icosq);
 
-err_disable_napi:
-	napi_disable(&c->napi);
-
+err_close_xdpsq_cq:
 	if (c->xdp)
 		mlx5e_close_cq(&c->rq_xdpsq.cq);
 
@@ -1974,7 +1970,6 @@ static void mlx5e_close_queues(struct mlx5e_channel *c)
 	mlx5e_close_sqs(c);
 	mlx5e_close_icosq(&c->icosq);
 	mlx5e_close_icosq(&c->async_icosq);
-	napi_disable(&c->napi);
 	if (c->xdp)
 		mlx5e_close_cq(&c->rq_xdpsq.cq);
 	mlx5e_close_cq(&c->rq.cq);
@@ -2059,6 +2054,8 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
 {
 	int tc;
 
+	napi_enable(&c->napi);
+
 	for (tc = 0; tc < c->num_tc; tc++)
 		mlx5e_activate_txqsq(&c->sq[tc]);
 	mlx5e_activate_icosq(&c->icosq);
@@ -2081,8 +2078,9 @@ static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
 	mlx5e_deactivate_icosq(&c->icosq);
 	for (tc = 0; tc < c->num_tc; tc++)
 		mlx5e_deactivate_txqsq(&c->sq[tc]);
-
 	mlx5e_qos_deactivate_queues(c);
+
+	napi_disable(&c->napi);
 }
 
 static void mlx5e_close_channel(struct mlx5e_channel *c)
-- 
2.29.2


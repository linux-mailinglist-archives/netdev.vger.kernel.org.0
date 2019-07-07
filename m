Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188C8614BF
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 13:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfGGLx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 07:53:28 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58845 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726363AbfGGLx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 07:53:26 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 14:53:19 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x67BrJLv031039;
        Sun, 7 Jul 2019 14:53:19 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        ayal@mellanox.com, jiri@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 08/16] net/mlx5e: Extend tx diagnose function
Date:   Sun,  7 Jul 2019 14:53:00 +0300
Message-Id: <1562500388-16847-9-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

The following patches in the set enhance the diagnostics info of tx
reporter. Therefore, it is better to pass a pointer to the SQ for
further data extraction.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 3e03a1ac8e5a..dd6417930461 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -138,15 +138,22 @@ static int mlx5e_tx_reporter_recover(struct devlink_health_reporter *reporter,
 
 static int
 mlx5e_tx_reporter_build_diagnose_output(struct devlink_fmsg *fmsg,
-					u32 sqn, u8 state, bool stopped)
+					struct mlx5e_txqsq *sq)
 {
+	struct mlx5e_priv *priv = sq->channel->priv;
+	bool stopped = netif_xmit_stopped(sq->txq);
+	u8 state;
 	int err;
 
+	err = mlx5_core_query_sq_state(priv->mdev, sq->sqn, &state);
+	if (err)
+		return err;
+
 	err = devlink_fmsg_obj_nest_start(fmsg);
 	if (err)
 		return err;
 
-	err = devlink_fmsg_u32_pair_put(fmsg, "sqn", sqn);
+	err = devlink_fmsg_u32_pair_put(fmsg, "sqn", sq->sqn);
 	if (err)
 		return err;
 
@@ -183,15 +190,8 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
 	for (i = 0; i < priv->channels.num * priv->channels.params.num_tc;
 	     i++) {
 		struct mlx5e_txqsq *sq = priv->txq2sq[i];
-		u8 state;
-
-		err = mlx5_core_query_sq_state(priv->mdev, sq->sqn, &state);
-		if (err)
-			goto unlock;
 
-		err = mlx5e_tx_reporter_build_diagnose_output(fmsg, sq->sqn,
-							      state,
-							      netif_xmit_stopped(sq->txq));
+		err = mlx5e_tx_reporter_build_diagnose_output(fmsg, sq);
 		if (err)
 			goto unlock;
 	}
-- 
1.8.3.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAE4614C3
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 13:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfGGLxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 07:53:38 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58844 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726369AbfGGLx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 07:53:27 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 14:53:19 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x67BrJLw031039;
        Sun, 7 Jul 2019 14:53:19 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        ayal@mellanox.com, jiri@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 09/16] net/mlx5e: Extend tx reporter diagnostics output
Date:   Sun,  7 Jul 2019 14:53:01 +0300
Message-Id: <1562500388-16847-10-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Enhance tx reporter's diagnostics output to include: information common
to all SQs: SQ size, SQ stride size.
In addition add channel ix, cc and pc.

$ devlink health diagnose pci/0000:00:0b.0 reporter tx
Common config:
   SQ: stride size: 64 size: 1024
 SQs:
   channel ix: 0 sqn: 4283 HW state: 1 stopped: false cc: 0 pc: 0
   channel ix: 1 sqn: 4288 HW state: 1 stopped: false cc: 0 pc: 0
   channel ix: 2 sqn: 4293 HW state: 1 stopped: false cc: 0 pc: 0
   channel ix: 3 sqn: 4298 HW state: 1 stopped: false cc: 0 pc: 0

$ devlink health diagnose pci/0000:00:0b.0 reporter tx -jp
{
    "Common config": [
        "SQ": {
            "stride size": 64,
            "size": 1024
        } ],
    "SQs": [ {
            "channel ix": 0,
            "sqn": 4283,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0
        },{
            "channel ix": 1,
            "sqn": 4288,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0
        },{
            "channel ix": 2,
            "sqn": 4293,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0
        },{
            "channel ix": 3,
            "sqn": 4298,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0
         } ]
}

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/health.c    | 30 ++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |  3 ++
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 42 ++++++++++++++++++++++
 3 files changed, 75 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index 60166e5432ae..0d44b081259f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -4,6 +4,36 @@
 #include "health.h"
 #include "lib/eq.h"
 
+int mlx5e_reporter_named_obj_nest_start(struct devlink_fmsg *fmsg, char *name)
+{
+	int err;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_obj_nest_start(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg *fmsg)
+{
+	int err;
+
+	err = devlink_fmsg_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn)
 {
 	struct mlx5_core_dev *mdev = channel->mdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index 960aa18c425d..0fecad63135c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -11,6 +11,9 @@
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
 int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq);
 
+int mlx5e_reporter_named_obj_nest_start(struct devlink_fmsg *fmsg, char *name);
+int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg *fmsg);
+
 #define MLX5E_REPORTER_PER_Q_MAX_LEN 256
 
 struct mlx5e_err_ctx {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index dd6417930461..c481f7142a12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -153,6 +153,10 @@ static int mlx5e_tx_reporter_recover(struct devlink_health_reporter *reporter,
 	if (err)
 		return err;
 
+	err = devlink_fmsg_u32_pair_put(fmsg, "channel ix", sq->channel->ix);
+	if (err)
+		return err;
+
 	err = devlink_fmsg_u32_pair_put(fmsg, "sqn", sq->sqn);
 	if (err)
 		return err;
@@ -165,6 +169,14 @@ static int mlx5e_tx_reporter_recover(struct devlink_health_reporter *reporter,
 	if (err)
 		return err;
 
+	err = devlink_fmsg_u32_pair_put(fmsg, "cc", sq->cc);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "pc", sq->pc);
+	if (err)
+		return err;
+
 	err = devlink_fmsg_obj_nest_end(fmsg);
 	if (err)
 		return err;
@@ -176,6 +188,9 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
 				      struct devlink_fmsg *fmsg)
 {
 	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
+	struct mlx5e_txqsq *generic_sq = priv->txq2sq[0];
+	u32 sq_stride, sq_sz;
+
 	int i, err = 0;
 
 	mutex_lock(&priv->state_lock);
@@ -183,6 +198,33 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		goto unlock;
 
+	sq_sz = mlx5_wq_cyc_get_size(&generic_sq->wq);
+	sq_stride = MLX5_SEND_WQE_BB;
+
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "Common config");
+	if (err)
+		goto unlock;
+
+	err = mlx5e_reporter_named_obj_nest_start(fmsg, "SQ");
+	if (err)
+		goto unlock;
+
+	err = devlink_fmsg_u64_pair_put(fmsg, "stride size", sq_stride);
+	if (err)
+		goto unlock;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "size", sq_sz);
+	if (err)
+		goto unlock;
+
+	err = devlink_fmsg_arr_pair_nest_end(fmsg);
+	if (err)
+		goto unlock;
+
+	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		goto unlock;
+
 	err = devlink_fmsg_arr_pair_nest_start(fmsg, "SQs");
 	if (err)
 		goto unlock;
-- 
1.8.3.1


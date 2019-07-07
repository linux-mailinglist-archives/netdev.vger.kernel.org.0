Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92828614C0
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 13:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfGGLx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 07:53:28 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58858 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726401AbfGGLx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 07:53:28 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 14:53:19 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x67BrJLx031039;
        Sun, 7 Jul 2019 14:53:19 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        ayal@mellanox.com, jiri@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 10/16] net/mlx5e: Add cq info to tx reporter diagnose
Date:   Sun,  7 Jul 2019 14:53:02 +0300
Message-Id: <1562500388-16847-11-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add cq information to general diagnose output: CQ size and stride size.
Per SQ add information about the related CQ: cqn and CQ's HW status.

$ devlink health diagnose pci/0000:00:0b.0 reporter tx
Common config:
   SQ: stride size: 64 size: 1024
   CQ: stride size: 64 size: 1024
 SQs:
   channel ix: 0 sqn: 4283 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 1030 HW status: 0
   channel ix: 1 sqn: 4288 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 1034 HW status: 0
   channel ix: 2 sqn: 4293 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 1038 HW status: 0
   channel ix: 3 sqn: 4298 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 1042 HW status: 0

$ devlink health diagnose pci/0000:00:0b.0 reporter tx -jp
{
    "Common config": [
        "SQ": {
            "stride size": 64,
            "size": 1024
        },
        "CQ": {
            "stride size": 64,
            "size": 1024
        } ],
    "SQs": [ {
            "channel ix": 0,
            "sqn": 4283,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0,
            "CQ": {
                "cqn": 1030,
                "HW status": 0
            }
        },{
            "channel ix": 1,
            "sqn": 4288,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0,
            "CQ": {
                "cqn": 1034,
                "HW status": 0
            }
        },{
            "channel ix": 2,
            "sqn": 4293,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0,
            "CQ": {
                "cqn": 1038,
                "HW status": 0
            }
        },{
            "channel ix": 3,
            "sqn": 4298,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0,
            "CQ": {
                "cqn": 1042,
                "HW status": 0
            }
        } ]
}

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/health.c    | 62 ++++++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |  2 +
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |  8 +++
 drivers/net/ethernet/mellanox/mlx5/core/wq.c       |  5 ++
 drivers/net/ethernet/mellanox/mlx5/core/wq.h       |  1 +
 5 files changed, 78 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index 0d44b081259f..a266717d41e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -34,6 +34,68 @@ int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg *fmsg)
 	return 0;
 }
 
+int mlx5e_reporter_cq_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg)
+{
+	struct mlx5e_priv *priv = cq->channel->priv;
+	u32 out[MLX5_ST_SZ_DW(query_cq_out)] = {};
+	u8 hw_status;
+	void *cqc;
+	int err;
+
+	err = mlx5_core_query_cq(priv->mdev, &cq->mcq, out, sizeof(out));
+	if (err)
+		return err;
+
+	cqc = MLX5_ADDR_OF(query_cq_out, out, cq_context);
+	hw_status = MLX5_GET(cqc, cqc, status);
+
+	err = mlx5e_reporter_named_obj_nest_start(fmsg, "CQ");
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "cqn", cq->mcq.cqn);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u8_pair_put(fmsg, "HW status", hw_status);
+	if (err)
+		return err;
+
+	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+int mlx5e_reporter_cq_common_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg)
+{
+	u8 cq_log_stride;
+	u32 cq_sz;
+	int err;
+
+	cq_sz = mlx5_cqwq_get_size(&cq->wq);
+	cq_log_stride = mlx5_cqwq_get_log_stride_size(&cq->wq);
+
+	err = mlx5e_reporter_named_obj_nest_start(fmsg, "CQ");
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u64_pair_put(fmsg, "stride size", BIT(cq_log_stride));
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "size", cq_sz);
+	if (err)
+		return err;
+
+	err = mlx5e_reporter_named_obj_nest_end(fmsg);
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
index 0fecad63135c..b0c8bda3d25f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -11,6 +11,8 @@
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
 int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq);
 
+int mlx5e_reporter_cq_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg);
+int mlx5e_reporter_cq_common_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg);
 int mlx5e_reporter_named_obj_nest_start(struct devlink_fmsg *fmsg, char *name);
 int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg *fmsg);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index c481f7142a12..47e788cf05bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -177,6 +177,10 @@ static int mlx5e_tx_reporter_recover(struct devlink_health_reporter *reporter,
 	if (err)
 		return err;
 
+	err = mlx5e_reporter_cq_diagnose(&sq->cq, fmsg);
+	if (err)
+		return err;
+
 	err = devlink_fmsg_obj_nest_end(fmsg);
 	if (err)
 		return err;
@@ -221,6 +225,10 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
 	if (err)
 		goto unlock;
 
+	err = mlx5e_reporter_cq_common_diagnose(&generic_sq->cq, fmsg);
+	if (err)
+		goto unlock;
+
 	err = mlx5e_reporter_named_obj_nest_end(fmsg);
 	if (err)
 		goto unlock;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.c b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
index 953cc8efba69..dd2315ce4441 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
@@ -44,6 +44,11 @@ u32 mlx5_cqwq_get_size(struct mlx5_cqwq *wq)
 	return wq->fbc.sz_m1 + 1;
 }
 
+u8 mlx5_cqwq_get_log_stride_size(struct mlx5_cqwq *wq)
+{
+	return wq->fbc.log_stride;
+}
+
 u32 mlx5_wq_ll_get_size(struct mlx5_wq_ll *wq)
 {
 	return (u32)wq->fbc.sz_m1 + 1;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.h b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
index f1ec58c9e9e3..55791f71a778 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
@@ -89,6 +89,7 @@ int mlx5_cqwq_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *param,
 		     void *cqc, struct mlx5_cqwq *wq,
 		     struct mlx5_wq_ctrl *wq_ctrl);
 u32 mlx5_cqwq_get_size(struct mlx5_cqwq *wq);
+u8 mlx5_cqwq_get_log_stride_size(struct mlx5_cqwq *wq);
 
 int mlx5_wq_ll_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *param,
 		      void *wqc, struct mlx5_wq_ll *wq,
-- 
1.8.3.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A5434E020
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhC3E2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230247AbhC3E1r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:27:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDB1D6199A;
        Tue, 30 Mar 2021 04:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617078467;
        bh=/1sTHEpCb2gF/Zje2wPQFVbmODMI+amBfFpVE0WSDRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdHO11URJflbynSk9Sm/IbJfZG12XLD3x2Y6RRQTw5bZ3Kjr/gaHDf4PJJ+ZA8j9Y
         ogEx/IsbqwhMtKdReE7EnG1OkzE9MnaLc49vUlrJGbN+ROsA/8aIiQGwzGG15YxKrp
         JGVmqkics5Ar2UOvYkNixdhVvZvPvNkvgNluGrTOoTb4QJ7520U4BZiu+d0o9i4zU7
         MjUT3Riyn6Xy44heDvSUIBKxvaRPyYWoPZrPzzt2KAAl5wBQif61l2y3yBw2I7mntG
         WsQLR3LTkakyXSmO8qjMeHVw6E2UL612kH3tbPPGI+PgmUg/7AEh94W3ZFZ2hmBs5p
         OWUSg+erknTYA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/12] net/mlx5e: Add PTP RQ to RX reporter
Date:   Mon, 29 Mar 2021 21:27:35 -0700
Message-Id: <20210330042741.198601-7-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330042741.198601-1-saeed@kernel.org>
References: <20210330042741.198601-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

When present, add the PTP RQ to the RX reporter.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/reporter_rx.c       | 68 ++++++++++++++++++-
 1 file changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 78d801bac8f5..f9fdf3606bbd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -5,6 +5,7 @@
 #include "params.h"
 #include "txrx.h"
 #include "devlink.h"
+#include "ptp.h"
 
 static int mlx5e_query_rq_state(struct mlx5_core_dev *dev, u32 rqn, u8 *state)
 {
@@ -351,12 +352,34 @@ static int mlx5e_rx_reporter_diagnose_generic_rq(struct mlx5e_rq *rq,
 	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 }
 
+static int
+mlx5e_rx_reporter_diagnose_common_ptp_config(struct mlx5e_priv *priv, struct mlx5e_ptp *ptp_ch,
+					     struct devlink_fmsg *fmsg)
+{
+	int err;
+
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "PTP");
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "filter_type", priv->tstamp.rx_filter);
+	if (err)
+		return err;
+
+	err = mlx5e_rx_reporter_diagnose_generic_rq(&ptp_ch->rq, fmsg);
+	if (err)
+		return err;
+
+	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
+}
+
 static int
 mlx5e_rx_reporter_diagnose_common_config(struct devlink_health_reporter *reporter,
 					 struct devlink_fmsg *fmsg)
 {
 	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
 	struct mlx5e_rq *generic_rq = &priv->channels.c[0]->rq;
+	struct mlx5e_ptp *ptp_ch = priv->channels.ptp;
 	int err;
 
 	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "Common config");
@@ -367,14 +390,45 @@ mlx5e_rx_reporter_diagnose_common_config(struct devlink_health_reporter *reporte
 	if (err)
 		return err;
 
+	if (ptp_ch && test_bit(MLX5E_PTP_STATE_RX, ptp_ch->state)) {
+		err = mlx5e_rx_reporter_diagnose_common_ptp_config(priv, ptp_ch, fmsg);
+		if (err)
+			return err;
+	}
+
 	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 }
 
+static int mlx5e_rx_reporter_build_diagnose_output_ptp_rq(struct mlx5e_rq *rq,
+							  struct devlink_fmsg *fmsg)
+{
+	int err;
+
+	err = devlink_fmsg_obj_nest_start(fmsg);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_string_pair_put(fmsg, "channel", "ptp");
+	if (err)
+		return err;
+
+	err = mlx5e_rx_reporter_build_diagnose_output_rq_common(rq, fmsg);
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
 static int mlx5e_rx_reporter_diagnose(struct devlink_health_reporter *reporter,
 				      struct devlink_fmsg *fmsg,
 				      struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
+	struct mlx5e_ptp *ptp_ch = priv->channels.ptp;
 	int i, err = 0;
 
 	mutex_lock(&priv->state_lock);
@@ -397,9 +451,12 @@ static int mlx5e_rx_reporter_diagnose(struct devlink_health_reporter *reporter,
 		if (err)
 			goto unlock;
 	}
+	if (ptp_ch && test_bit(MLX5E_PTP_STATE_RX, ptp_ch->state)) {
+		err = mlx5e_rx_reporter_build_diagnose_output_ptp_rq(&ptp_ch->rq, fmsg);
+		if (err)
+			goto unlock;
+	}
 	err = devlink_fmsg_arr_pair_nest_end(fmsg);
-	if (err)
-		goto unlock;
 unlock:
 	mutex_unlock(&priv->state_lock);
 	return err;
@@ -531,6 +588,7 @@ static int mlx5e_rx_reporter_dump_rq(struct mlx5e_priv *priv, struct devlink_fms
 static int mlx5e_rx_reporter_dump_all_rqs(struct mlx5e_priv *priv,
 					  struct devlink_fmsg *fmsg)
 {
+	struct mlx5e_ptp *ptp_ch = priv->channels.ptp;
 	struct mlx5_rsc_key key = {};
 	int i, err;
 
@@ -563,6 +621,12 @@ static int mlx5e_rx_reporter_dump_all_rqs(struct mlx5e_priv *priv,
 			return err;
 	}
 
+	if (ptp_ch && test_bit(MLX5E_PTP_STATE_RX, ptp_ch->state)) {
+		err = mlx5e_health_queue_dump(priv, fmsg, ptp_ch->rq.rqn, "PTP RQ");
+		if (err)
+			return err;
+	}
+
 	return devlink_fmsg_arr_pair_nest_end(fmsg);
 }
 
-- 
2.30.2


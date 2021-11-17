Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2370453F93
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbhKQEhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233100AbhKQEhL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:37:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AA8461057;
        Wed, 17 Nov 2021 04:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637123652;
        bh=ncQNbEfxSifNw5yovNSNN65a4vz0bo1cwHTw7TjHoUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7fb0+A+BtY++LpIUm9eOT3aeb+5LyTmHD396ddVsSp/qJQIk226hgKucJhz2jv/e
         PEO1+FK1ToCY8oMxP5Xt+CJUislbsSfAJWtUkftlrhgev4Hcl9Dzum8Oeg7u6J5oNE
         4htSKobPsdU2RCSP2qVCBUcfbmubY9QUtl6cy/Ez300C+jvs6+nNvQDLmVIVPoBDum
         /ZeZzKkecQYUcKmz2exZxHvF0iCGTQ/Xxhd00E4Kz16Lxjw+4Y7csOQ/cLI761lW4A
         ZE39lTow1PEglZSKUqB0Tpm1ZKHUM9dGF7m9xBkrasHsKXYgLPHbhU3nncrcsdwgLj
         7lTx4YoIoMQOw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 14/15] net/mlx5: E-switch, Enable vport QoS on demand
Date:   Tue, 16 Nov 2021 20:33:56 -0800
Message-Id: <20211117043357.345072-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117043357.345072-1-saeed@kernel.org>
References: <20211117043357.345072-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Vports' QoS is not commonly used but consume SW/HW resources, which
becomes an issue on BlueField SoC systems.
Don't enable QoS on vports by default on eswitch mode change and enable
when it's going to be used by one of the top level users:
- configuring TC matchall filter with police action;
- setting rate with legacy NDO API;
- calling devlink ops->rate_leaf_*() callbacks.

Disable vport QoS on vport cleanup.

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/legacy.c  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c | 82 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/esw/qos.h | 12 +--
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  9 +-
 4 files changed, 64 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index df277a6cddc0..2b52f7c09152 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -522,9 +522,7 @@ int mlx5_eswitch_set_vport_rate(struct mlx5_eswitch *esw, u16 vport,
 		return PTR_ERR(evport);
 
 	mutex_lock(&esw->state_lock);
-	err = mlx5_esw_qos_set_vport_min_rate(esw, evport, min_rate, NULL);
-	if (!err)
-		err = mlx5_esw_qos_set_vport_max_rate(esw, evport, max_rate, NULL);
+	err = mlx5_esw_qos_set_vport_rate(esw, evport, max_rate, min_rate);
 	mutex_unlock(&esw->state_lock);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index c6cc67cb4f6a..304abc293086 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -204,10 +204,8 @@ static int esw_qos_normalize_groups_min_rate(struct mlx5_eswitch *esw, u32 divid
 	return 0;
 }
 
-int mlx5_esw_qos_set_vport_min_rate(struct mlx5_eswitch *esw,
-				    struct mlx5_vport *evport,
-				    u32 min_rate,
-				    struct netlink_ext_ack *extack)
+static int esw_qos_set_vport_min_rate(struct mlx5_eswitch *esw, struct mlx5_vport *evport,
+				      u32 min_rate, struct netlink_ext_ack *extack)
 {
 	u32 fw_max_bw_share, previous_min_rate;
 	bool min_rate_supported;
@@ -231,10 +229,8 @@ int mlx5_esw_qos_set_vport_min_rate(struct mlx5_eswitch *esw,
 	return err;
 }
 
-int mlx5_esw_qos_set_vport_max_rate(struct mlx5_eswitch *esw,
-				    struct mlx5_vport *evport,
-				    u32 max_rate,
-				    struct netlink_ext_ack *extack)
+static int esw_qos_set_vport_max_rate(struct mlx5_eswitch *esw, struct mlx5_vport *evport,
+				      u32 max_rate, struct netlink_ext_ack *extack)
 {
 	u32 act_max_rate = max_rate;
 	bool max_rate_supported;
@@ -605,8 +601,8 @@ void mlx5_esw_qos_destroy(struct mlx5_eswitch *esw)
 	mutex_unlock(&esw->state_lock);
 }
 
-int mlx5_esw_qos_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
-			      u32 max_rate, u32 bw_share)
+static int esw_qos_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
+				u32 max_rate, u32 bw_share)
 {
 	int err;
 
@@ -615,7 +611,7 @@ int mlx5_esw_qos_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 		return 0;
 
 	if (vport->qos.enabled)
-		return -EEXIST;
+		return 0;
 
 	vport->qos.group = esw->qos.group0;
 
@@ -645,31 +641,55 @@ void mlx5_esw_qos_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vpo
 		esw_warn(esw->dev, "E-Switch destroy TSAR vport element failed (vport=%d,err=%d)\n",
 			 vport->vport, err);
 
-	vport->qos.enabled = false;
+	memset(&vport->qos, 0, sizeof(vport->qos));
 	trace_mlx5_esw_vport_qos_destroy(vport);
 }
 
+int mlx5_esw_qos_set_vport_rate(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
+				u32 min_rate, u32 max_rate)
+{
+	int err;
+
+	lockdep_assert_held(&esw->state_lock);
+	err = esw_qos_vport_enable(esw, vport, 0, 0);
+	if (err)
+		return err;
+
+	err = esw_qos_set_vport_min_rate(esw, vport, min_rate, NULL);
+	if (!err)
+		err = esw_qos_set_vport_max_rate(esw, vport, max_rate, NULL);
+
+	return err;
+}
+
 int mlx5_esw_qos_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num, u32 rate_mbps)
 {
 	u32 ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
 	struct mlx5_vport *vport;
 	u32 bitmask;
+	int err;
 
 	vport = mlx5_eswitch_get_vport(esw, vport_num);
 	if (IS_ERR(vport))
 		return PTR_ERR(vport);
 
-	if (!vport->qos.enabled)
-		return -EOPNOTSUPP;
-
-	MLX5_SET(scheduling_context, ctx, max_average_bw, rate_mbps);
-	bitmask = MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_MAX_AVERAGE_BW;
+	mutex_lock(&esw->state_lock);
+	if (!vport->qos.enabled) {
+		/* Eswitch QoS wasn't enabled yet. Enable it and vport QoS. */
+		err = esw_qos_vport_enable(esw, vport, rate_mbps, vport->qos.bw_share);
+	} else {
+		MLX5_SET(scheduling_context, ctx, max_average_bw, rate_mbps);
+
+		bitmask = MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_MAX_AVERAGE_BW;
+		err = mlx5_modify_scheduling_element_cmd(esw->dev,
+							 SCHEDULING_HIERARCHY_E_SWITCH,
+							 ctx,
+							 vport->qos.esw_tsar_ix,
+							 bitmask);
+	}
+	mutex_unlock(&esw->state_lock);
 
-	return mlx5_modify_scheduling_element_cmd(esw->dev,
-						  SCHEDULING_HIERARCHY_E_SWITCH,
-						  ctx,
-						  vport->qos.esw_tsar_ix,
-						  bitmask);
+	return err;
 }
 
 #define MLX5_LINKSPEED_UNIT 125000 /* 1Mbps in Bps */
@@ -728,7 +748,12 @@ int mlx5_esw_devlink_rate_leaf_tx_share_set(struct devlink_rate *rate_leaf, void
 		return err;
 
 	mutex_lock(&esw->state_lock);
-	err = mlx5_esw_qos_set_vport_min_rate(esw, vport, tx_share, extack);
+	err = esw_qos_vport_enable(esw, vport, 0, 0);
+	if (err)
+		goto unlock;
+
+	err = esw_qos_set_vport_min_rate(esw, vport, tx_share, extack);
+unlock:
 	mutex_unlock(&esw->state_lock);
 	return err;
 }
@@ -749,7 +774,12 @@ int mlx5_esw_devlink_rate_leaf_tx_max_set(struct devlink_rate *rate_leaf, void *
 		return err;
 
 	mutex_lock(&esw->state_lock);
-	err = mlx5_esw_qos_set_vport_max_rate(esw, vport, tx_max, extack);
+	err = esw_qos_vport_enable(esw, vport, 0, 0);
+	if (err)
+		goto unlock;
+
+	err = esw_qos_set_vport_max_rate(esw, vport, tx_max, extack);
+unlock:
 	mutex_unlock(&esw->state_lock);
 	return err;
 }
@@ -846,7 +876,9 @@ int mlx5_esw_qos_vport_update_group(struct mlx5_eswitch *esw,
 	int err;
 
 	mutex_lock(&esw->state_lock);
-	err = esw_qos_vport_update_group(esw, vport, group, extack);
+	err = esw_qos_vport_enable(esw, vport, 0, 0);
+	if (!err)
+		err = esw_qos_vport_update_group(esw, vport, group, extack);
 	mutex_unlock(&esw->state_lock);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
index 28451abe2d2f..91b66c1b9881 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
@@ -6,18 +6,10 @@
 
 #ifdef CONFIG_MLX5_ESWITCH
 
-int mlx5_esw_qos_set_vport_min_rate(struct mlx5_eswitch *esw,
-				    struct mlx5_vport *evport,
-				    u32 min_rate,
-				    struct netlink_ext_ack *extack);
-int mlx5_esw_qos_set_vport_max_rate(struct mlx5_eswitch *esw,
-				    struct mlx5_vport *evport,
-				    u32 max_rate,
-				    struct netlink_ext_ack *extack);
+int mlx5_esw_qos_set_vport_rate(struct mlx5_eswitch *esw, struct mlx5_vport *evport,
+				u32 max_rate, u32 min_rate);
 void mlx5_esw_qos_create(struct mlx5_eswitch *esw);
 void mlx5_esw_qos_destroy(struct mlx5_eswitch *esw);
-int mlx5_esw_qos_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
-			      u32 max_rate, u32 bw_share);
 void mlx5_esw_qos_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 
 int mlx5_esw_devlink_rate_leaf_tx_share_set(struct devlink_rate *rate_leaf, void *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index ec5b1641d40c..2d188f462028 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -781,9 +781,6 @@ static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 	if (err)
 		return err;
 
-	/* Attach vport to the eswitch rate limiter */
-	mlx5_esw_qos_vport_enable(esw, vport, vport->qos.max_rate, vport->qos.bw_share);
-
 	if (mlx5_esw_is_manager_vport(esw, vport_num))
 		return 0;
 
@@ -1746,8 +1743,10 @@ int mlx5_eswitch_get_vport_config(struct mlx5_eswitch *esw,
 	ivi->qos = evport->info.qos;
 	ivi->spoofchk = evport->info.spoofchk;
 	ivi->trusted = evport->info.trusted;
-	ivi->min_tx_rate = evport->qos.min_rate;
-	ivi->max_tx_rate = evport->qos.max_rate;
+	if (evport->qos.enabled) {
+		ivi->min_tx_rate = evport->qos.min_rate;
+		ivi->max_tx_rate = evport->qos.max_rate;
+	}
 	mutex_unlock(&esw->state_lock);
 
 	return 0;
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3EB3F261F
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238263AbhHTE4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233877AbhHTE4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 00:56:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9B49610A3;
        Fri, 20 Aug 2021 04:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629435329;
        bh=ZSv7oZgOz3CqJriiuM/HaGRJK2k534wpq6DN56iD8H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWe4J8+G/X0W+xj09Pboi22qf0I4f/XjRLNNt0L5ffHnlmi3MKULdBDi3US6RdaFI
         La/pAnldyXuLO/C711/ZnTOSyeSdvqTmRdA8HFiywv5KpUGU6jRGd+LAgVaXC7oMMV
         6SFZXCpfkw84EBSm9EsEYk1bdp+RT6djuAbPufWLX0zVtxvv6hQZ+MFuio6K9pwPRA
         v6Ezfv4RW8rpbtPlrVFx0Zoq6DGg/MI8RqoVSl++p5/71fE2ppaMYPXwLIdQaGlcEx
         CAV9YyNbYzdAZrT30jYH6mc2/rpNxX0PDfQOGGgLu+jUi4wO0n7TFDlQTVVVQk7/pi
         jld02bgPv2OBw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Huy Nguyen <huyn@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5: E-switch, Move QoS related code to dedicated file
Date:   Thu, 19 Aug 2021 21:55:10 -0700
Message-Id: <20210820045515.265297-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820045515.265297-1-saeed@kernel.org>
References: <20210820045515.265297-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Move eswitch QoS related code into dedicated file. Provide eswitch API
to access this code meaning it is isolated and restricted to be used
only by eswitch.c. Exception is legacy NDO vf set rate, which moved to
esw/legacy.c.

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Huy Nguyen <huyn@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/esw/legacy.c  |  18 +
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c | 295 +++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/esw/qos.h |  19 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 310 +-----------------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  10 +-
 7 files changed, 346 insertions(+), 316 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 024d72b3b1aa..63032cd6efb1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -53,11 +53,13 @@ mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
 # Core extra
 #
 mlx5_core-$(CONFIG_MLX5_ESWITCH)   += eswitch.o eswitch_offloads.o eswitch_offloads_termtbl.o \
-				      ecpf.o rdma.o esw/legacy.o
+				      ecpf.o rdma.o esw/legacy.o \
+				      esw/devlink_port.o esw/vporttbl.o esw/qos.o
+
 mlx5_core-$(CONFIG_MLX5_ESWITCH)   += esw/acl/helper.o \
 				      esw/acl/egress_lgcy.o esw/acl/egress_ofld.o \
-				      esw/acl/ingress_lgcy.o esw/acl/ingress_ofld.o \
-				      esw/devlink_port.o esw/vporttbl.o
+				      esw/acl/ingress_lgcy.o esw/acl/ingress_ofld.o
+
 mlx5_core-$(CONFIG_MLX5_BRIDGE)    += esw/bridge.o en/rep/bridge.o
 
 mlx5_core-$(CONFIG_MLX5_MPFS)      += lib/mpfs.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1bd2bc05fb94..6603d9c823a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4689,7 +4689,7 @@ static int apply_police_params(struct mlx5e_priv *priv, u64 rate,
 		rate_mbps = max_t(u32, rate, 1);
 	}
 
-	err = mlx5_esw_modify_vport_rate(esw, vport_num, rate_mbps);
+	err = mlx5_esw_qos_modify_vport_rate(esw, vport_num, rate_mbps);
 	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "failed applying action to hardware");
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index d9041b16611d..2b52f7c09152 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -11,6 +11,7 @@
 #include "mlx5_core.h"
 #include "eswitch.h"
 #include "fs_core.h"
+#include "esw/qos.h"
 
 enum {
 	LEGACY_VEPA_PRIO = 0,
@@ -508,3 +509,20 @@ int mlx5_eswitch_set_vport_trust(struct mlx5_eswitch *esw,
 	mutex_unlock(&esw->state_lock);
 	return err;
 }
+
+int mlx5_eswitch_set_vport_rate(struct mlx5_eswitch *esw, u16 vport,
+				u32 max_rate, u32 min_rate)
+{
+	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
+	int err;
+
+	if (!mlx5_esw_allowed(esw))
+		return -EPERM;
+	if (IS_ERR(evport))
+		return PTR_ERR(evport);
+
+	mutex_lock(&esw->state_lock);
+	err = mlx5_esw_qos_set_vport_rate(esw, evport, max_rate, min_rate);
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
new file mode 100644
index 000000000000..7f4a8a927115
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -0,0 +1,295 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include "eswitch.h"
+#include "esw/qos.h"
+
+/* Minimum supported BW share value by the HW is 1 Mbit/sec */
+#define MLX5_MIN_BW_SHARE 1
+
+#define MLX5_RATE_TO_BW_SHARE(rate, divider, limit) \
+	min_t(u32, max_t(u32, (rate) / (divider), MLX5_MIN_BW_SHARE), limit)
+
+static int esw_qos_vport_config(struct mlx5_eswitch *esw,
+				struct mlx5_vport *vport,
+				u32 max_rate, u32 bw_share)
+{
+	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
+	struct mlx5_core_dev *dev = esw->dev;
+	void *vport_elem;
+	u32 bitmask = 0;
+	int err;
+
+	if (!MLX5_CAP_GEN(dev, qos) || !MLX5_CAP_QOS(dev, esw_scheduling))
+		return -EOPNOTSUPP;
+
+	if (!vport->qos.enabled)
+		return -EIO;
+
+	MLX5_SET(scheduling_context, sched_ctx, element_type,
+		 SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT);
+	vport_elem = MLX5_ADDR_OF(scheduling_context, sched_ctx,
+				  element_attributes);
+	MLX5_SET(vport_element, vport_elem, vport_number, vport->vport);
+	MLX5_SET(scheduling_context, sched_ctx, parent_element_id, esw->qos.root_tsar_ix);
+	MLX5_SET(scheduling_context, sched_ctx, max_average_bw, max_rate);
+	MLX5_SET(scheduling_context, sched_ctx, bw_share, bw_share);
+	bitmask |= MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_MAX_AVERAGE_BW;
+	bitmask |= MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_BW_SHARE;
+
+	err = mlx5_modify_scheduling_element_cmd(dev,
+						 SCHEDULING_HIERARCHY_E_SWITCH,
+						 sched_ctx,
+						 vport->qos.esw_tsar_ix,
+						 bitmask);
+	if (err) {
+		esw_warn(esw->dev, "E-Switch modify TSAR vport element failed (vport=%d,err=%d)\n",
+			 vport->vport, err);
+		return err;
+	}
+
+	return 0;
+}
+
+static u32 calculate_vports_min_rate_divider(struct mlx5_eswitch *esw)
+{
+	u32 fw_max_bw_share = MLX5_CAP_QOS(esw->dev, max_tsar_bw_share);
+	struct mlx5_vport *evport;
+	u32 max_guarantee = 0;
+	unsigned long i;
+
+	mlx5_esw_for_each_vport(esw, i, evport) {
+		if (!evport->enabled || evport->qos.min_rate < max_guarantee)
+			continue;
+		max_guarantee = evport->qos.min_rate;
+	}
+
+	if (max_guarantee)
+		return max_t(u32, max_guarantee / fw_max_bw_share, 1);
+	return 0;
+}
+
+static int normalize_vports_min_rate(struct mlx5_eswitch *esw)
+{
+	u32 fw_max_bw_share = MLX5_CAP_QOS(esw->dev, max_tsar_bw_share);
+	u32 divider = calculate_vports_min_rate_divider(esw);
+	struct mlx5_vport *evport;
+	u32 vport_max_rate;
+	u32 vport_min_rate;
+	unsigned long i;
+	u32 bw_share;
+	int err;
+
+	mlx5_esw_for_each_vport(esw, i, evport) {
+		if (!evport->enabled)
+			continue;
+		vport_min_rate = evport->qos.min_rate;
+		vport_max_rate = evport->qos.max_rate;
+		bw_share = 0;
+
+		if (divider)
+			bw_share = MLX5_RATE_TO_BW_SHARE(vport_min_rate,
+							 divider,
+							 fw_max_bw_share);
+
+		if (bw_share == evport->qos.bw_share)
+			continue;
+
+		err = esw_qos_vport_config(esw, evport, vport_max_rate,
+					   bw_share);
+		if (!err)
+			evport->qos.bw_share = bw_share;
+		else
+			return err;
+	}
+
+	return 0;
+}
+
+int mlx5_esw_qos_set_vport_rate(struct mlx5_eswitch *esw, struct mlx5_vport *evport,
+				u32 max_rate, u32 min_rate)
+{
+	bool min_rate_supported;
+	bool max_rate_supported;
+	u32 previous_min_rate;
+	u32 fw_max_bw_share;
+	int err;
+
+	fw_max_bw_share = MLX5_CAP_QOS(esw->dev, max_tsar_bw_share);
+	min_rate_supported = MLX5_CAP_QOS(esw->dev, esw_bw_share) &&
+				fw_max_bw_share >= MLX5_MIN_BW_SHARE;
+	max_rate_supported = MLX5_CAP_QOS(esw->dev, esw_rate_limit);
+
+	if (!esw->qos.enabled || !evport->enabled || !evport->qos.enabled)
+		return -EOPNOTSUPP;
+
+	if ((min_rate && !min_rate_supported) || (max_rate && !max_rate_supported))
+		return -EOPNOTSUPP;
+
+	if (min_rate == evport->qos.min_rate)
+		goto set_max_rate;
+
+	previous_min_rate = evport->qos.min_rate;
+	evport->qos.min_rate = min_rate;
+	err = normalize_vports_min_rate(esw);
+	if (err) {
+		evport->qos.min_rate = previous_min_rate;
+		return err;
+	}
+
+set_max_rate:
+	if (max_rate == evport->qos.max_rate)
+		return 0;
+
+	err = esw_qos_vport_config(esw, evport, max_rate, evport->qos.bw_share);
+	if (!err)
+		evport->qos.max_rate = max_rate;
+
+	return err;
+}
+
+static bool esw_qos_element_type_supported(struct mlx5_core_dev *dev, int type)
+{
+	switch (type) {
+	case SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR:
+		return MLX5_CAP_QOS(dev, esw_element_type) &
+		       ELEMENT_TYPE_CAP_MASK_TASR;
+	case SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT:
+		return MLX5_CAP_QOS(dev, esw_element_type) &
+		       ELEMENT_TYPE_CAP_MASK_VPORT;
+	case SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT_TC:
+		return MLX5_CAP_QOS(dev, esw_element_type) &
+		       ELEMENT_TYPE_CAP_MASK_VPORT_TC;
+	case SCHEDULING_CONTEXT_ELEMENT_TYPE_PARA_VPORT_TC:
+		return MLX5_CAP_QOS(dev, esw_element_type) &
+		       ELEMENT_TYPE_CAP_MASK_PARA_VPORT_TC;
+	}
+	return false;
+}
+
+void mlx5_esw_qos_create(struct mlx5_eswitch *esw)
+{
+	u32 tsar_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
+	struct mlx5_core_dev *dev = esw->dev;
+	__be32 *attr;
+	int err;
+
+	if (!MLX5_CAP_GEN(dev, qos) || !MLX5_CAP_QOS(dev, esw_scheduling))
+		return;
+
+	if (!esw_qos_element_type_supported(dev, SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR))
+		return;
+
+	if (esw->qos.enabled)
+		return;
+
+	MLX5_SET(scheduling_context, tsar_ctx, element_type,
+		 SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR);
+
+	attr = MLX5_ADDR_OF(scheduling_context, tsar_ctx, element_attributes);
+	*attr = cpu_to_be32(TSAR_ELEMENT_TSAR_TYPE_DWRR << 16);
+
+	err = mlx5_create_scheduling_element_cmd(dev,
+						 SCHEDULING_HIERARCHY_E_SWITCH,
+						 tsar_ctx,
+						 &esw->qos.root_tsar_ix);
+	if (err) {
+		esw_warn(dev, "E-Switch create TSAR failed (%d)\n", err);
+		return;
+	}
+
+	esw->qos.enabled = true;
+}
+
+void mlx5_esw_qos_destroy(struct mlx5_eswitch *esw)
+{
+	int err;
+
+	if (!esw->qos.enabled)
+		return;
+
+	err = mlx5_destroy_scheduling_element_cmd(esw->dev,
+						  SCHEDULING_HIERARCHY_E_SWITCH,
+						  esw->qos.root_tsar_ix);
+	if (err)
+		esw_warn(esw->dev, "E-Switch destroy TSAR failed (%d)\n", err);
+
+	esw->qos.enabled = false;
+}
+
+int mlx5_esw_qos_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
+			      u32 max_rate, u32 bw_share)
+{
+	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
+	struct mlx5_core_dev *dev = esw->dev;
+	void *vport_elem;
+	int err;
+
+	lockdep_assert_held(&esw->state_lock);
+	if (!esw->qos.enabled)
+		return 0;
+
+	if (vport->qos.enabled)
+		return -EEXIST;
+
+	MLX5_SET(scheduling_context, sched_ctx, element_type,
+		 SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT);
+	vport_elem = MLX5_ADDR_OF(scheduling_context, sched_ctx, element_attributes);
+	MLX5_SET(vport_element, vport_elem, vport_number, vport->vport);
+	MLX5_SET(scheduling_context, sched_ctx, parent_element_id, esw->qos.root_tsar_ix);
+	MLX5_SET(scheduling_context, sched_ctx, max_average_bw, max_rate);
+	MLX5_SET(scheduling_context, sched_ctx, bw_share, bw_share);
+
+	err = mlx5_create_scheduling_element_cmd(dev,
+						 SCHEDULING_HIERARCHY_E_SWITCH,
+						 sched_ctx,
+						 &vport->qos.esw_tsar_ix);
+	if (err)
+		esw_warn(dev, "E-Switch create TSAR vport element failed (vport=%d,err=%d)\n",
+			 vport->vport, err);
+	else
+		vport->qos.enabled = true;
+
+	return err;
+}
+
+void mlx5_esw_qos_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
+{
+	int err;
+
+	lockdep_assert_held(&esw->state_lock);
+	if (!esw->qos.enabled || !vport->qos.enabled)
+		return;
+
+	err = mlx5_destroy_scheduling_element_cmd(esw->dev,
+						  SCHEDULING_HIERARCHY_E_SWITCH,
+						  vport->qos.esw_tsar_ix);
+	if (err)
+		esw_warn(esw->dev, "E-Switch destroy TSAR vport element failed (vport=%d,err=%d)\n",
+			 vport->vport, err);
+
+	vport->qos.enabled = false;
+}
+
+int mlx5_esw_qos_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num, u32 rate_mbps)
+{
+	u32 ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
+	struct mlx5_vport *vport;
+	u32 bitmask;
+
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
+	if (!vport->qos.enabled)
+		return -EOPNOTSUPP;
+
+	MLX5_SET(scheduling_context, ctx, max_average_bw, rate_mbps);
+	bitmask = MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_MAX_AVERAGE_BW;
+
+	return mlx5_modify_scheduling_element_cmd(esw->dev,
+						  SCHEDULING_HIERARCHY_E_SWITCH,
+						  ctx,
+						  vport->qos.esw_tsar_ix,
+						  bitmask);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
new file mode 100644
index 000000000000..7329405282ad
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_ESW_QOS_H__
+#define __MLX5_ESW_QOS_H__
+
+#ifdef CONFIG_MLX5_ESWITCH
+
+int mlx5_esw_qos_set_vport_rate(struct mlx5_eswitch *esw, struct mlx5_vport *evport,
+				u32 max_rate, u32 min_rate);
+void mlx5_esw_qos_create(struct mlx5_eswitch *esw);
+void mlx5_esw_qos_destroy(struct mlx5_eswitch *esw);
+int mlx5_esw_qos_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
+			      u32 max_rate, u32 bw_share);
+void mlx5_esw_qos_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
+
+#endif
+
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 2fde9f59e8b4..ec136b499204 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -38,6 +38,7 @@
 #include <linux/mlx5/mpfs.h>
 #include "esw/acl/lgcy.h"
 #include "esw/legacy.h"
+#include "esw/qos.h"
 #include "mlx5_core.h"
 #include "lib/eq.h"
 #include "eswitch.h"
@@ -740,201 +741,6 @@ static void esw_vport_change_handler(struct work_struct *work)
 	mutex_unlock(&esw->state_lock);
 }
 
-static bool element_type_supported(struct mlx5_eswitch *esw, int type)
-{
-	const struct mlx5_core_dev *dev = esw->dev;
-
-	switch (type) {
-	case SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR:
-		return MLX5_CAP_QOS(dev, esw_element_type) &
-		       ELEMENT_TYPE_CAP_MASK_TASR;
-	case SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT:
-		return MLX5_CAP_QOS(dev, esw_element_type) &
-		       ELEMENT_TYPE_CAP_MASK_VPORT;
-	case SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT_TC:
-		return MLX5_CAP_QOS(dev, esw_element_type) &
-		       ELEMENT_TYPE_CAP_MASK_VPORT_TC;
-	case SCHEDULING_CONTEXT_ELEMENT_TYPE_PARA_VPORT_TC:
-		return MLX5_CAP_QOS(dev, esw_element_type) &
-		       ELEMENT_TYPE_CAP_MASK_PARA_VPORT_TC;
-	}
-	return false;
-}
-
-/* Vport QoS management */
-static void esw_create_tsar(struct mlx5_eswitch *esw)
-{
-	u32 tsar_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {0};
-	struct mlx5_core_dev *dev = esw->dev;
-	__be32 *attr;
-	int err;
-
-	if (!MLX5_CAP_GEN(dev, qos) || !MLX5_CAP_QOS(dev, esw_scheduling))
-		return;
-
-	if (!element_type_supported(esw, SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR))
-		return;
-
-	if (esw->qos.enabled)
-		return;
-
-	MLX5_SET(scheduling_context, tsar_ctx, element_type,
-		 SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR);
-
-	attr = MLX5_ADDR_OF(scheduling_context, tsar_ctx, element_attributes);
-	*attr = cpu_to_be32(TSAR_ELEMENT_TSAR_TYPE_DWRR << 16);
-
-	err = mlx5_create_scheduling_element_cmd(dev,
-						 SCHEDULING_HIERARCHY_E_SWITCH,
-						 tsar_ctx,
-						 &esw->qos.root_tsar_id);
-	if (err) {
-		esw_warn(esw->dev, "E-Switch create TSAR failed (%d)\n", err);
-		return;
-	}
-
-	esw->qos.enabled = true;
-}
-
-static void esw_destroy_tsar(struct mlx5_eswitch *esw)
-{
-	int err;
-
-	if (!esw->qos.enabled)
-		return;
-
-	err = mlx5_destroy_scheduling_element_cmd(esw->dev,
-						  SCHEDULING_HIERARCHY_E_SWITCH,
-						  esw->qos.root_tsar_id);
-	if (err)
-		esw_warn(esw->dev, "E-Switch destroy TSAR failed (%d)\n", err);
-
-	esw->qos.enabled = false;
-}
-
-static int esw_vport_enable_qos(struct mlx5_eswitch *esw,
-				struct mlx5_vport *vport,
-				u32 initial_max_rate, u32 initial_bw_share)
-{
-	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {0};
-	struct mlx5_core_dev *dev = esw->dev;
-	void *vport_elem;
-	int err = 0;
-
-	if (!esw->qos.enabled)
-		return 0;
-
-	if (vport->qos.enabled)
-		return -EEXIST;
-
-	MLX5_SET(scheduling_context, sched_ctx, element_type,
-		 SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT);
-	vport_elem = MLX5_ADDR_OF(scheduling_context, sched_ctx,
-				  element_attributes);
-	MLX5_SET(vport_element, vport_elem, vport_number, vport->vport);
-	MLX5_SET(scheduling_context, sched_ctx, parent_element_id,
-		 esw->qos.root_tsar_id);
-	MLX5_SET(scheduling_context, sched_ctx, max_average_bw,
-		 initial_max_rate);
-	MLX5_SET(scheduling_context, sched_ctx, bw_share, initial_bw_share);
-
-	err = mlx5_create_scheduling_element_cmd(dev,
-						 SCHEDULING_HIERARCHY_E_SWITCH,
-						 sched_ctx,
-						 &vport->qos.esw_tsar_ix);
-	if (err) {
-		esw_warn(esw->dev, "E-Switch create TSAR vport element failed (vport=%d,err=%d)\n",
-			 vport->vport, err);
-		return err;
-	}
-
-	vport->qos.enabled = true;
-	return 0;
-}
-
-static void esw_vport_disable_qos(struct mlx5_eswitch *esw,
-				  struct mlx5_vport *vport)
-{
-	int err;
-
-	if (!vport->qos.enabled)
-		return;
-
-	err = mlx5_destroy_scheduling_element_cmd(esw->dev,
-						  SCHEDULING_HIERARCHY_E_SWITCH,
-						  vport->qos.esw_tsar_ix);
-	if (err)
-		esw_warn(esw->dev, "E-Switch destroy TSAR vport element failed (vport=%d,err=%d)\n",
-			 vport->vport, err);
-
-	vport->qos.enabled = false;
-}
-
-static int esw_vport_qos_config(struct mlx5_eswitch *esw,
-				struct mlx5_vport *vport,
-				u32 max_rate, u32 bw_share)
-{
-	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {0};
-	struct mlx5_core_dev *dev = esw->dev;
-	void *vport_elem;
-	u32 bitmask = 0;
-	int err = 0;
-
-	if (!MLX5_CAP_GEN(dev, qos) || !MLX5_CAP_QOS(dev, esw_scheduling))
-		return -EOPNOTSUPP;
-
-	if (!vport->qos.enabled)
-		return -EIO;
-
-	MLX5_SET(scheduling_context, sched_ctx, element_type,
-		 SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT);
-	vport_elem = MLX5_ADDR_OF(scheduling_context, sched_ctx,
-				  element_attributes);
-	MLX5_SET(vport_element, vport_elem, vport_number, vport->vport);
-	MLX5_SET(scheduling_context, sched_ctx, parent_element_id,
-		 esw->qos.root_tsar_id);
-	MLX5_SET(scheduling_context, sched_ctx, max_average_bw,
-		 max_rate);
-	MLX5_SET(scheduling_context, sched_ctx, bw_share, bw_share);
-	bitmask |= MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_MAX_AVERAGE_BW;
-	bitmask |= MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_BW_SHARE;
-
-	err = mlx5_modify_scheduling_element_cmd(dev,
-						 SCHEDULING_HIERARCHY_E_SWITCH,
-						 sched_ctx,
-						 vport->qos.esw_tsar_ix,
-						 bitmask);
-	if (err) {
-		esw_warn(esw->dev, "E-Switch modify TSAR vport element failed (vport=%d,err=%d)\n",
-			 vport->vport, err);
-		return err;
-	}
-
-	return 0;
-}
-
-int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num,
-			       u32 rate_mbps)
-{
-	u32 ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
-	struct mlx5_vport *vport;
-
-	vport = mlx5_eswitch_get_vport(esw, vport_num);
-	if (IS_ERR(vport))
-		return PTR_ERR(vport);
-
-	if (!vport->qos.enabled)
-		return -EOPNOTSUPP;
-
-	MLX5_SET(scheduling_context, ctx, max_average_bw, rate_mbps);
-
-	return mlx5_modify_scheduling_element_cmd(esw->dev,
-						  SCHEDULING_HIERARCHY_E_SWITCH,
-						  ctx,
-						  vport->qos.esw_tsar_ix,
-						  MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_MAX_AVERAGE_BW);
-}
-
 static void node_guid_gen_from_mac(u64 *node_guid, const u8 *mac)
 {
 	((u8 *)node_guid)[7] = mac[0];
@@ -976,7 +782,7 @@ static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 		return err;
 
 	/* Attach vport to the eswitch rate limiter */
-	esw_vport_enable_qos(esw, vport, vport->qos.max_rate, vport->qos.bw_share);
+	mlx5_esw_qos_vport_enable(esw, vport, vport->qos.max_rate, vport->qos.bw_share);
 
 	if (mlx5_esw_is_manager_vport(esw, vport_num))
 		return 0;
@@ -1013,7 +819,7 @@ static void esw_vport_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 					      vport_num, 1,
 					      MLX5_VPORT_ADMIN_STATE_DOWN);
 
-	esw_vport_disable_qos(esw, vport);
+	mlx5_esw_qos_vport_disable(esw, vport);
 	esw_vport_cleanup_acl(esw, vport);
 }
 
@@ -1454,7 +1260,7 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 
 	mlx5_eswitch_update_num_of_vfs(esw, num_vfs);
 
-	esw_create_tsar(esw);
+	mlx5_esw_qos_create(esw);
 
 	esw->mode = mode;
 
@@ -1484,7 +1290,7 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 	if (mode == MLX5_ESWITCH_OFFLOADS)
 		mlx5_rescan_drivers(esw->dev);
 
-	esw_destroy_tsar(esw);
+	mlx5_esw_qos_destroy(esw);
 	mlx5_esw_acls_ns_cleanup(esw);
 	return err;
 }
@@ -1553,7 +1359,7 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
 	if (old_mode == MLX5_ESWITCH_OFFLOADS)
 		mlx5_rescan_drivers(esw->dev);
 
-	esw_destroy_tsar(esw);
+	mlx5_esw_qos_destroy(esw);
 	mlx5_esw_acls_ns_cleanup(esw);
 
 	if (clear_vf)
@@ -2050,110 +1856,6 @@ int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 	return err;
 }
 
-static u32 calculate_vports_min_rate_divider(struct mlx5_eswitch *esw)
-{
-	u32 fw_max_bw_share = MLX5_CAP_QOS(esw->dev, max_tsar_bw_share);
-	struct mlx5_vport *evport;
-	u32 max_guarantee = 0;
-	unsigned long i;
-
-	mlx5_esw_for_each_vport(esw, i, evport) {
-		if (!evport->enabled || evport->qos.min_rate < max_guarantee)
-			continue;
-		max_guarantee = evport->qos.min_rate;
-	}
-
-	if (max_guarantee)
-		return max_t(u32, max_guarantee / fw_max_bw_share, 1);
-	return 0;
-}
-
-static int normalize_vports_min_rate(struct mlx5_eswitch *esw)
-{
-	u32 fw_max_bw_share = MLX5_CAP_QOS(esw->dev, max_tsar_bw_share);
-	u32 divider = calculate_vports_min_rate_divider(esw);
-	struct mlx5_vport *evport;
-	u32 vport_max_rate;
-	u32 vport_min_rate;
-	unsigned long i;
-	u32 bw_share;
-	int err;
-
-	mlx5_esw_for_each_vport(esw, i, evport) {
-		if (!evport->enabled)
-			continue;
-		vport_min_rate = evport->qos.min_rate;
-		vport_max_rate = evport->qos.max_rate;
-		bw_share = 0;
-
-		if (divider)
-			bw_share = MLX5_RATE_TO_BW_SHARE(vport_min_rate,
-							 divider,
-							 fw_max_bw_share);
-
-		if (bw_share == evport->qos.bw_share)
-			continue;
-
-		err = esw_vport_qos_config(esw, evport, vport_max_rate,
-					   bw_share);
-		if (!err)
-			evport->qos.bw_share = bw_share;
-		else
-			return err;
-	}
-
-	return 0;
-}
-
-int mlx5_eswitch_set_vport_rate(struct mlx5_eswitch *esw, u16 vport,
-				u32 max_rate, u32 min_rate)
-{
-	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
-	u32 fw_max_bw_share;
-	u32 previous_min_rate;
-	bool min_rate_supported;
-	bool max_rate_supported;
-	int err = 0;
-
-	if (!mlx5_esw_allowed(esw))
-		return -EPERM;
-	if (IS_ERR(evport))
-		return PTR_ERR(evport);
-
-	fw_max_bw_share = MLX5_CAP_QOS(esw->dev, max_tsar_bw_share);
-	min_rate_supported = MLX5_CAP_QOS(esw->dev, esw_bw_share) &&
-				fw_max_bw_share >= MLX5_MIN_BW_SHARE;
-	max_rate_supported = MLX5_CAP_QOS(esw->dev, esw_rate_limit);
-
-	if ((min_rate && !min_rate_supported) || (max_rate && !max_rate_supported))
-		return -EOPNOTSUPP;
-
-	mutex_lock(&esw->state_lock);
-
-	if (min_rate == evport->qos.min_rate)
-		goto set_max_rate;
-
-	previous_min_rate = evport->qos.min_rate;
-	evport->qos.min_rate = min_rate;
-	err = normalize_vports_min_rate(esw);
-	if (err) {
-		evport->qos.min_rate = previous_min_rate;
-		goto unlock;
-	}
-
-set_max_rate:
-	if (max_rate == evport->qos.max_rate)
-		goto unlock;
-
-	err = esw_vport_qos_config(esw, evport, max_rate, evport->qos.bw_share);
-	if (!err)
-		evport->qos.max_rate = max_rate;
-
-unlock:
-	mutex_unlock(&esw->state_lock);
-	return err;
-}
-
 int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
 				 u16 vport_num,
 				 struct ifla_vf_stats *vf_stats)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 3be34b24e737..ebeccee38a57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -76,11 +76,6 @@ struct mlx5_mapped_obj {
 #define MLX5_MAX_MC_PER_VPORT(dev) \
 	(1 << MLX5_CAP_GEN(dev, log_max_current_mc_list))
 
-#define MLX5_MIN_BW_SHARE 1
-
-#define MLX5_RATE_TO_BW_SHARE(rate, divider, limit) \
-	min_t(u32, max_t(u32, (rate) / (divider), MLX5_MIN_BW_SHARE), limit)
-
 #define mlx5_esw_has_fwd_fdb(dev) \
 	MLX5_CAP_ESW_FLOWTABLE(dev, fdb_multi_path_to_table)
 
@@ -310,7 +305,7 @@ struct mlx5_eswitch {
 
 	struct {
 		bool            enabled;
-		u32             root_tsar_id;
+		u32             root_tsar_ix;
 	} qos;
 
 	struct mlx5_esw_bridge_offloads *br_offloads;
@@ -336,8 +331,7 @@ int mlx5_esw_offloads_vport_metadata_set(struct mlx5_eswitch *esw, bool enable);
 u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw);
 void mlx5_esw_match_metadata_free(struct mlx5_eswitch *esw, u32 metadata);
 
-int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num,
-			       u32 rate_mbps);
+int mlx5_esw_qos_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num, u32 rate_mbps);
 
 /* E-Switch API */
 int mlx5_eswitch_init(struct mlx5_core_dev *dev);
-- 
2.31.1


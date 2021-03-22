Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE703450B5
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhCVU0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231383AbhCVUZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:25:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CEF961993;
        Mon, 22 Mar 2021 20:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616444735;
        bh=w+imUhtXnMs9Kr8EmCwYCqIqt9Ci9Br2HY6Zj975PVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFTdfVY2d0V7Jxmdy7fJyIZxVNsSJclJ9a/1ZohW0v68rowDqwARO9X2s6ADKem6p
         6kyK8Ul+YRZSZZ34HT9duh8gZshMUquT2tzHQCj1CkayHksFY2sWmHvBrROt5AWgnC
         ofi6Fp7MyQliFiNgyotME6TTshMvsdMnyTb0DMlnLEQpAbgjuJsyQnLi1X89u1yHCr
         KF8GUlTuB3wvBRRNqXow+xyFdTfSnoPN8flRcFwAexW0FSkyLkyezJgShL85mMlX9j
         U9RaaYoYA6X/Knr2StmwgmEpQY9yTwl6YLXIDwPpe4SFyV9T5QPo3By9i6F8mSNyxs
         v1PVjDmDW6SLg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 6/6] net/mlx5: SF, do not use ecpu bit for vhca state processing
Date:   Mon, 22 Mar 2021 13:25:24 -0700
Message-Id: <20210322202524.68886-7-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322202524.68886-1-saeed@kernel.org>
References: <20210322202524.68886-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Device firmware doesn't handle ecpu bit for vhca state processing
events and commands. Instead device firmware refers to the unique
function id to distinguish SF of different PCI functions.

When ecpu bit is used, firmware returns a syndrome.

mlx5_cmd_check:780:(pid 872): MODIFY_VHCA_STATE(0xb0e) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x263211)
mlx5_sf_dev_table_create:248:(pid 872): SF DEV table create err = -22

Hence, avoid using ecpu bit.

Fixes: 8f0105418668 ("net/mlx5: SF, Add port add delete functionality")
Fixes: 90d010b8634b ("net/mlx5: SF, Add auxiliary device support")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.c  |  4 +---
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c |  8 +++----
 .../mellanox/mlx5/core/sf/vhca_event.c        | 22 +++++++++----------
 .../mellanox/mlx5/core/sf/vhca_event.h        |  7 +++---
 4 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
index b265f27b2166..90b524c59f3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -181,15 +181,13 @@ static int mlx5_sf_dev_vhca_arm_all(struct mlx5_sf_dev_table *table)
 	u16 max_functions;
 	u16 function_id;
 	int err = 0;
-	bool ecpu;
 	int i;
 
 	max_functions = mlx5_sf_max_functions(dev);
 	function_id = MLX5_CAP_GEN(dev, sf_base_id);
-	ecpu = mlx5_read_embedded_cpu(dev);
 	/* Arm the vhca context as the vhca event notifier */
 	for (i = 0; i < max_functions; i++) {
-		err = mlx5_vhca_event_arm(dev, function_id, ecpu);
+		err = mlx5_vhca_event_arm(dev, function_id);
 		if (err)
 			return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index 0914909806cb..a5a0f60bef66 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -6,7 +6,7 @@
 #include "sf.h"
 #include "mlx5_ifc_vhca_event.h"
 #include "vhca_event.h"
-#include "ecpf.h"
+#include "mlx5_core.h"
 
 struct mlx5_sf_hw {
 	u32 usr_sfnum;
@@ -18,7 +18,6 @@ struct mlx5_sf_hw_table {
 	struct mlx5_core_dev *dev;
 	struct mlx5_sf_hw *sfs;
 	int max_local_functions;
-	u8 ecpu: 1;
 	struct mutex table_lock; /* Serializes sf deletion and vhca state change handler. */
 	struct notifier_block vhca_nb;
 };
@@ -72,7 +71,7 @@ int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
 	if (err)
 		goto err;
 
-	err = mlx5_modify_vhca_sw_id(dev, hw_fn_id, table->ecpu, usr_sfnum);
+	err = mlx5_modify_vhca_sw_id(dev, hw_fn_id, usr_sfnum);
 	if (err)
 		goto vhca_err;
 
@@ -118,7 +117,7 @@ void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u16 id)
 
 	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, id);
 	mutex_lock(&table->table_lock);
-	err = mlx5_cmd_query_vhca_state(dev, hw_fn_id, table->ecpu, out, sizeof(out));
+	err = mlx5_cmd_query_vhca_state(dev, hw_fn_id, out, sizeof(out));
 	if (err)
 		goto err;
 	state = MLX5_GET(query_vhca_state_out, out, vhca_state_context.vhca_state);
@@ -164,7 +163,6 @@ int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
 	table->dev = dev;
 	table->sfs = sfs;
 	table->max_local_functions = max_functions;
-	table->ecpu = mlx5_read_embedded_cpu(dev);
 	dev->priv.sf_hw_table = table;
 	mlx5_core_dbg(dev, "SF HW table: max sfs = %d\n", max_functions);
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c
index f1c2068d4f2a..28b14b05086f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c
@@ -19,52 +19,51 @@ struct mlx5_vhca_event_work {
 	struct mlx5_vhca_state_event event;
 };
 
-int mlx5_cmd_query_vhca_state(struct mlx5_core_dev *dev, u16 function_id,
-			      bool ecpu, u32 *out, u32 outlen)
+int mlx5_cmd_query_vhca_state(struct mlx5_core_dev *dev, u16 function_id, u32 *out, u32 outlen)
 {
 	u32 in[MLX5_ST_SZ_DW(query_vhca_state_in)] = {};
 
 	MLX5_SET(query_vhca_state_in, in, opcode, MLX5_CMD_OP_QUERY_VHCA_STATE);
 	MLX5_SET(query_vhca_state_in, in, function_id, function_id);
-	MLX5_SET(query_vhca_state_in, in, embedded_cpu_function, ecpu);
+	MLX5_SET(query_vhca_state_in, in, embedded_cpu_function, 0);
 
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
 }
 
 static int mlx5_cmd_modify_vhca_state(struct mlx5_core_dev *dev, u16 function_id,
-				      bool ecpu, u32 *in, u32 inlen)
+				      u32 *in, u32 inlen)
 {
 	u32 out[MLX5_ST_SZ_DW(modify_vhca_state_out)] = {};
 
 	MLX5_SET(modify_vhca_state_in, in, opcode, MLX5_CMD_OP_MODIFY_VHCA_STATE);
 	MLX5_SET(modify_vhca_state_in, in, function_id, function_id);
-	MLX5_SET(modify_vhca_state_in, in, embedded_cpu_function, ecpu);
+	MLX5_SET(modify_vhca_state_in, in, embedded_cpu_function, 0);
 
 	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
 }
 
-int mlx5_modify_vhca_sw_id(struct mlx5_core_dev *dev, u16 function_id, bool ecpu, u32 sw_fn_id)
+int mlx5_modify_vhca_sw_id(struct mlx5_core_dev *dev, u16 function_id, u32 sw_fn_id)
 {
 	u32 out[MLX5_ST_SZ_DW(modify_vhca_state_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(modify_vhca_state_in)] = {};
 
 	MLX5_SET(modify_vhca_state_in, in, opcode, MLX5_CMD_OP_MODIFY_VHCA_STATE);
 	MLX5_SET(modify_vhca_state_in, in, function_id, function_id);
-	MLX5_SET(modify_vhca_state_in, in, embedded_cpu_function, ecpu);
+	MLX5_SET(modify_vhca_state_in, in, embedded_cpu_function, 0);
 	MLX5_SET(modify_vhca_state_in, in, vhca_state_field_select.sw_function_id, 1);
 	MLX5_SET(modify_vhca_state_in, in, vhca_state_context.sw_function_id, sw_fn_id);
 
 	return mlx5_cmd_exec_inout(dev, modify_vhca_state, in, out);
 }
 
-int mlx5_vhca_event_arm(struct mlx5_core_dev *dev, u16 function_id, bool ecpu)
+int mlx5_vhca_event_arm(struct mlx5_core_dev *dev, u16 function_id)
 {
 	u32 in[MLX5_ST_SZ_DW(modify_vhca_state_in)] = {};
 
 	MLX5_SET(modify_vhca_state_in, in, vhca_state_context.arm_change_event, 1);
 	MLX5_SET(modify_vhca_state_in, in, vhca_state_field_select.arm_change_event, 1);
 
-	return mlx5_cmd_modify_vhca_state(dev, function_id, ecpu, in, sizeof(in));
+	return mlx5_cmd_modify_vhca_state(dev, function_id, in, sizeof(in));
 }
 
 static void
@@ -73,7 +72,7 @@ mlx5_vhca_event_notify(struct mlx5_core_dev *dev, struct mlx5_vhca_state_event *
 	u32 out[MLX5_ST_SZ_DW(query_vhca_state_out)] = {};
 	int err;
 
-	err = mlx5_cmd_query_vhca_state(dev, event->function_id, event->ecpu, out, sizeof(out));
+	err = mlx5_cmd_query_vhca_state(dev, event->function_id, out, sizeof(out));
 	if (err)
 		return;
 
@@ -82,7 +81,7 @@ mlx5_vhca_event_notify(struct mlx5_core_dev *dev, struct mlx5_vhca_state_event *
 	event->new_vhca_state = MLX5_GET(query_vhca_state_out, out,
 					 vhca_state_context.vhca_state);
 
-	mlx5_vhca_event_arm(dev, event->function_id, event->ecpu);
+	mlx5_vhca_event_arm(dev, event->function_id);
 
 	blocking_notifier_call_chain(&dev->priv.vhca_state_notifier->n_head, 0, event);
 }
@@ -111,7 +110,6 @@ mlx5_vhca_state_change_notifier(struct notifier_block *nb, unsigned long type, v
 	INIT_WORK(&work->work, &mlx5_vhca_state_work_handler);
 	work->notifier = notifier;
 	work->event.function_id = be16_to_cpu(eqe->data.vhca_state.function_id);
-	work->event.ecpu = be16_to_cpu(eqe->data.vhca_state.ec_function);
 	mlx5_events_work_enqueue(notifier->dev, &work->work);
 	return NOTIFY_OK;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.h
index 1fe1ec6f4d4b..013cdfe90616 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.h
@@ -10,7 +10,6 @@ struct mlx5_vhca_state_event {
 	u16 function_id;
 	u16 sw_function_id;
 	u8 new_vhca_state;
-	bool ecpu;
 };
 
 static inline bool mlx5_vhca_event_supported(const struct mlx5_core_dev *dev)
@@ -25,10 +24,10 @@ void mlx5_vhca_event_start(struct mlx5_core_dev *dev);
 void mlx5_vhca_event_stop(struct mlx5_core_dev *dev);
 int mlx5_vhca_event_notifier_register(struct mlx5_core_dev *dev, struct notifier_block *nb);
 void mlx5_vhca_event_notifier_unregister(struct mlx5_core_dev *dev, struct notifier_block *nb);
-int mlx5_modify_vhca_sw_id(struct mlx5_core_dev *dev, u16 function_id, bool ecpu, u32 sw_fn_id);
-int mlx5_vhca_event_arm(struct mlx5_core_dev *dev, u16 function_id, bool ecpu);
+int mlx5_modify_vhca_sw_id(struct mlx5_core_dev *dev, u16 function_id, u32 sw_fn_id);
+int mlx5_vhca_event_arm(struct mlx5_core_dev *dev, u16 function_id);
 int mlx5_cmd_query_vhca_state(struct mlx5_core_dev *dev, u16 function_id,
-			      bool ecpu, u32 *out, u32 outlen);
+			      u32 *out, u32 outlen);
 #else
 
 static inline void mlx5_vhca_state_cap_handle(struct mlx5_core_dev *dev, void *set_hca_cap)
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895473010AC
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbhAVXKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:10:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:32870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729390AbhAVTiS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 14:38:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6093D23B16;
        Fri, 22 Jan 2021 19:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611344229;
        bh=vjvY5sGoNuesfQtho9N/J4mf9yuTquZ/NV6jHfbc/+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFo3c0v1XTwBWygh9xsREHn97WnuzMCWZR/fObytdz2Z+rrMBPIxcNFcARJsghSvD
         8Tms9tDPUhBXT9jFeO2pDJSBj7phdUyJay7kFpWUDdtfEUaFAPBAfVCiDFYka6fCLJ
         A589832DJaCnMdlbGQ3lhG1VaH1RsUWoUOncyfFIwhtrZ0DegrTqEoGeWzTNF9fM8P
         tQGaSk0d2IEIWUhjhfnA56CpKLfxhuEKt/yKntITiA8WJIhEakbvjSfui9TJpn0vu0
         x5q+dRavSA9bpDZbBCjuLEgm2/iKvZdFFWtQX/AMov18wY0ufM6Lo5mWb0V265/+xW
         njBqufl0uymww==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        alexander.duyck@gmail.com, sridhar.samudrala@intel.com,
        edwin.peer@broadcom.com, dsahern@kernel.org, kiran.patil@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        dan.j.williams@intel.com, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V10 05/14] net/mlx5: Introduce vhca state event notifier
Date:   Fri, 22 Jan 2021 11:36:49 -0800
Message-Id: <20210122193658.282884-6-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122193658.282884-1-saeed@kernel.org>
References: <20210122193658.282884-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

vhca state events indicates change in the state of the vhca that may
occur due to a SF allocation, deallocation or enabling/disabling the
SF HCA.

Introduce vhca state event handler which will be used by SF devlink
port manager and SF hardware id allocator in subsequent patches
to act on the event.

This enables single entity to subscribe, query and rearm the event
for a function.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |   9 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/events.c  |   7 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  16 ++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 .../mlx5/core/sf/mlx5_ifc_vhca_event.h        |  82 ++++++++
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   |  45 +++++
 .../mellanox/mlx5/core/sf/vhca_event.c        | 189 ++++++++++++++++++
 .../mellanox/mlx5/core/sf/vhca_event.h        |  57 ++++++
 include/linux/mlx5/driver.h                   |   4 +
 12 files changed, 422 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 6e4d7bb7fea2..d6c48582e7a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -203,3 +203,12 @@ config MLX5_SW_STEERING
 	default y
 	help
 	Build support for software-managed steering in the NIC.
+
+config MLX5_SF
+	bool "Mellanox Technologies subfunction device support using auxiliary device"
+	depends on MLX5_CORE && MLX5_CORE_EN
+	default n
+	help
+	Build support for subfuction device in the NIC. A Mellanox subfunction
+	device can support RDMA, netdevice and vdpa device.
+	It is similar to a SRIOV VF but it doesn't require SRIOV support.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 134bd038ae8a..22ef2ebbee96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -86,3 +86,7 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 					steering/dr_ste_v0.o \
 					steering/dr_cmd.o steering/dr_fw.o \
 					steering/dr_action.o steering/fs_dr.o
+#
+# SF device
+#
+mlx5_core-$(CONFIG_MLX5_SF) += sf/vhca_event.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 50c7b9ee80c3..47dcc3ac2cf0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -464,6 +464,8 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_ALLOC_MEMIC:
 	case MLX5_CMD_OP_MODIFY_XRQ:
 	case MLX5_CMD_OP_RELEASE_XRQ_ERROR:
+	case MLX5_CMD_OP_QUERY_VHCA_STATE:
+	case MLX5_CMD_OP_MODIFY_VHCA_STATE:
 		*status = MLX5_DRIVER_STATUS_ABORTED;
 		*synd = MLX5_DRIVER_SYND;
 		return -EIO;
@@ -657,6 +659,8 @@ const char *mlx5_command_str(int command)
 	MLX5_COMMAND_STR_CASE(DESTROY_UMEM);
 	MLX5_COMMAND_STR_CASE(RELEASE_XRQ_ERROR);
 	MLX5_COMMAND_STR_CASE(MODIFY_XRQ);
+	MLX5_COMMAND_STR_CASE(QUERY_VHCA_STATE);
+	MLX5_COMMAND_STR_CASE(MODIFY_VHCA_STATE);
 	default: return "unknown command opcode";
 	}
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index fc0afa03d407..421febebc658 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -595,6 +595,9 @@ static void gather_async_events_mask(struct mlx5_core_dev *dev, u64 mask[4])
 		async_event_mask |=
 			(1ull << MLX5_EVENT_TYPE_ESW_FUNCTIONS_CHANGED);
 
+	if (MLX5_CAP_GEN_MAX(dev, vhca_state))
+		async_event_mask |= (1ull << MLX5_EVENT_TYPE_VHCA_STATE_CHANGE);
+
 	mask[0] = async_event_mask;
 
 	if (MLX5_CAP_GEN(dev, event_cap))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 3ce17c3d7a00..5523d218e5fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -110,6 +110,8 @@ static const char *eqe_type_str(u8 type)
 		return "MLX5_EVENT_TYPE_CMD";
 	case MLX5_EVENT_TYPE_ESW_FUNCTIONS_CHANGED:
 		return "MLX5_EVENT_TYPE_ESW_FUNCTIONS_CHANGED";
+	case MLX5_EVENT_TYPE_VHCA_STATE_CHANGE:
+		return "MLX5_EVENT_TYPE_VHCA_STATE_CHANGE";
 	case MLX5_EVENT_TYPE_PAGE_REQUEST:
 		return "MLX5_EVENT_TYPE_PAGE_REQUEST";
 	case MLX5_EVENT_TYPE_PAGE_FAULT:
@@ -403,3 +405,8 @@ int mlx5_notifier_call_chain(struct mlx5_events *events, unsigned int event, voi
 {
 	return atomic_notifier_call_chain(&events->nh, event, data);
 }
+
+void mlx5_events_work_enqueue(struct mlx5_core_dev *dev, struct work_struct *work)
+{
+	queue_work(dev->priv.events->wq, work);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index ca6f2fc39ea0..b16f57befe52 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -73,6 +73,7 @@
 #include "ecpf.h"
 #include "lib/hv_vhca.h"
 #include "diag/rsc_dump.h"
+#include "sf/vhca_event.h"
 
 MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
 MODULE_DESCRIPTION("Mellanox 5th generation network adapters (ConnectX series) core driver");
@@ -567,6 +568,8 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 	if (MLX5_CAP_GEN_MAX(dev, mkey_by_name))
 		MLX5_SET(cmd_hca_cap, set_hca_cap, mkey_by_name, 1);
 
+	mlx5_vhca_state_cap_handle(dev, set_hca_cap);
+
 	return set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
 }
 
@@ -884,6 +887,12 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 		goto err_eswitch_cleanup;
 	}
 
+	err = mlx5_vhca_event_init(dev);
+	if (err) {
+		mlx5_core_err(dev, "Failed to init vhca event notifier %d\n", err);
+		goto err_fpga_cleanup;
+	}
+
 	dev->dm = mlx5_dm_create(dev);
 	if (IS_ERR(dev->dm))
 		mlx5_core_warn(dev, "Failed to init device memory%d\n", err);
@@ -894,6 +903,8 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 
 	return 0;
 
+err_fpga_cleanup:
+	mlx5_fpga_cleanup(dev);
 err_eswitch_cleanup:
 	mlx5_eswitch_cleanup(dev->priv.eswitch);
 err_sriov_cleanup:
@@ -925,6 +936,7 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 	mlx5_hv_vhca_destroy(dev->hv_vhca);
 	mlx5_fw_tracer_destroy(dev->tracer);
 	mlx5_dm_cleanup(dev);
+	mlx5_vhca_event_cleanup(dev);
 	mlx5_fpga_cleanup(dev);
 	mlx5_eswitch_cleanup(dev->priv.eswitch);
 	mlx5_sriov_cleanup(dev);
@@ -1129,6 +1141,8 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 		goto err_sriov;
 	}
 
+	mlx5_vhca_event_start(dev);
+
 	err = mlx5_ec_init(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to init embedded CPU\n");
@@ -1146,6 +1160,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 err_sriov:
 	mlx5_ec_cleanup(dev);
 err_ec:
+	mlx5_vhca_event_stop(dev);
 	mlx5_cleanup_fs(dev);
 err_fs:
 	mlx5_accel_tls_cleanup(dev);
@@ -1173,6 +1188,7 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 {
 	mlx5_sriov_detach(dev);
 	mlx5_ec_cleanup(dev);
+	mlx5_vhca_event_stop(dev);
 	mlx5_cleanup_fs(dev);
 	mlx5_accel_ipsec_cleanup(dev);
 	mlx5_accel_tls_cleanup(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 0a0302ce7144..a33b7496d748 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -259,4 +259,6 @@ void mlx5_set_nic_state(struct mlx5_core_dev *dev, u8 state);
 
 void mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup);
 int mlx5_load_one(struct mlx5_core_dev *dev, bool boot);
+
+void mlx5_events_work_enqueue(struct mlx5_core_dev *dev, struct work_struct *work);
 #endif /* __MLX5_CORE_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h
new file mode 100644
index 000000000000..1daf5a122ba3
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+
+#ifndef __MLX5_IFC_VHCA_EVENT_H__
+#define __MLX5_IFC_VHCA_EVENT_H__
+
+enum mlx5_ifc_vhca_state {
+	MLX5_VHCA_STATE_INVALID = 0x0,
+	MLX5_VHCA_STATE_ALLOCATED = 0x1,
+	MLX5_VHCA_STATE_ACTIVE = 0x2,
+	MLX5_VHCA_STATE_IN_USE = 0x3,
+	MLX5_VHCA_STATE_TEARDOWN_REQUEST = 0x4,
+};
+
+struct mlx5_ifc_vhca_state_context_bits {
+	u8         arm_change_event[0x1];
+	u8         reserved_at_1[0xb];
+	u8         vhca_state[0x4];
+	u8         reserved_at_10[0x10];
+
+	u8         sw_function_id[0x20];
+
+	u8         reserved_at_40[0x80];
+};
+
+struct mlx5_ifc_query_vhca_state_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x40];
+
+	struct mlx5_ifc_vhca_state_context_bits vhca_state_context;
+};
+
+struct mlx5_ifc_query_vhca_state_in_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         embedded_cpu_function[0x1];
+	u8         reserved_at_41[0xf];
+	u8         function_id[0x10];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_vhca_state_field_select_bits {
+	u8         reserved_at_0[0x1e];
+	u8         sw_function_id[0x1];
+	u8         arm_change_event[0x1];
+};
+
+struct mlx5_ifc_modify_vhca_state_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x40];
+};
+
+struct mlx5_ifc_modify_vhca_state_in_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         embedded_cpu_function[0x1];
+	u8         reserved_at_41[0xf];
+	u8         function_id[0x10];
+
+	struct mlx5_ifc_vhca_state_field_select_bits vhca_state_field_select;
+
+	struct mlx5_ifc_vhca_state_context_bits vhca_state_context;
+};
+
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
new file mode 100644
index 000000000000..623191679b49
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+
+#ifndef __MLX5_SF_H__
+#define __MLX5_SF_H__
+
+#include <linux/mlx5/driver.h>
+
+static inline u16 mlx5_sf_start_function_id(const struct mlx5_core_dev *dev)
+{
+	return MLX5_CAP_GEN(dev, sf_base_id);
+}
+
+#ifdef CONFIG_MLX5_SF
+
+static inline bool mlx5_sf_supported(const struct mlx5_core_dev *dev)
+{
+	return MLX5_CAP_GEN(dev, sf);
+}
+
+static inline u16 mlx5_sf_max_functions(const struct mlx5_core_dev *dev)
+{
+	if (!mlx5_sf_supported(dev))
+		return 0;
+	if (MLX5_CAP_GEN(dev, max_num_sf))
+		return MLX5_CAP_GEN(dev, max_num_sf);
+	else
+		return 1 << MLX5_CAP_GEN(dev, log_max_sf);
+}
+
+#else
+
+static inline bool mlx5_sf_supported(const struct mlx5_core_dev *dev)
+{
+	return false;
+}
+
+static inline u16 mlx5_sf_max_functions(const struct mlx5_core_dev *dev)
+{
+	return 0;
+}
+
+#endif
+
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c
new file mode 100644
index 000000000000..af2f2dd9db25
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c
@@ -0,0 +1,189 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+
+#include <linux/mlx5/driver.h>
+#include "mlx5_ifc_vhca_event.h"
+#include "mlx5_core.h"
+#include "vhca_event.h"
+#include "ecpf.h"
+
+struct mlx5_vhca_state_notifier {
+	struct mlx5_core_dev *dev;
+	struct mlx5_nb nb;
+	struct blocking_notifier_head n_head;
+};
+
+struct mlx5_vhca_event_work {
+	struct work_struct work;
+	struct mlx5_vhca_state_notifier *notifier;
+	struct mlx5_vhca_state_event event;
+};
+
+int mlx5_cmd_query_vhca_state(struct mlx5_core_dev *dev, u16 function_id,
+			      bool ecpu, u32 *out, u32 outlen)
+{
+	u32 in[MLX5_ST_SZ_DW(query_vhca_state_in)] = {};
+
+	MLX5_SET(query_vhca_state_in, in, opcode, MLX5_CMD_OP_QUERY_VHCA_STATE);
+	MLX5_SET(query_vhca_state_in, in, function_id, function_id);
+	MLX5_SET(query_vhca_state_in, in, embedded_cpu_function, ecpu);
+
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
+}
+
+static int mlx5_cmd_modify_vhca_state(struct mlx5_core_dev *dev, u16 function_id,
+				      bool ecpu, u32 *in, u32 inlen)
+{
+	u32 out[MLX5_ST_SZ_DW(modify_vhca_state_out)] = {};
+
+	MLX5_SET(modify_vhca_state_in, in, opcode, MLX5_CMD_OP_MODIFY_VHCA_STATE);
+	MLX5_SET(modify_vhca_state_in, in, function_id, function_id);
+	MLX5_SET(modify_vhca_state_in, in, embedded_cpu_function, ecpu);
+
+	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
+}
+
+int mlx5_modify_vhca_sw_id(struct mlx5_core_dev *dev, u16 function_id, bool ecpu, u32 sw_fn_id)
+{
+	u32 out[MLX5_ST_SZ_DW(modify_vhca_state_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(modify_vhca_state_in)] = {};
+
+	MLX5_SET(modify_vhca_state_in, in, opcode, MLX5_CMD_OP_MODIFY_VHCA_STATE);
+	MLX5_SET(modify_vhca_state_in, in, function_id, function_id);
+	MLX5_SET(modify_vhca_state_in, in, embedded_cpu_function, ecpu);
+	MLX5_SET(modify_vhca_state_in, in, vhca_state_field_select.sw_function_id, 1);
+	MLX5_SET(modify_vhca_state_in, in, vhca_state_context.sw_function_id, sw_fn_id);
+
+	return mlx5_cmd_exec_inout(dev, modify_vhca_state, in, out);
+}
+
+int mlx5_vhca_event_arm(struct mlx5_core_dev *dev, u16 function_id, bool ecpu)
+{
+	u32 in[MLX5_ST_SZ_DW(modify_vhca_state_in)] = {};
+
+	MLX5_SET(modify_vhca_state_in, in, vhca_state_context.arm_change_event, 1);
+	MLX5_SET(modify_vhca_state_in, in, vhca_state_field_select.arm_change_event, 1);
+
+	return mlx5_cmd_modify_vhca_state(dev, function_id, ecpu, in, sizeof(in));
+}
+
+static void
+mlx5_vhca_event_notify(struct mlx5_core_dev *dev, struct mlx5_vhca_state_event *event)
+{
+	u32 out[MLX5_ST_SZ_DW(query_vhca_state_out)] = {};
+	int err;
+
+	err = mlx5_cmd_query_vhca_state(dev, event->function_id, event->ecpu, out, sizeof(out));
+	if (err)
+		return;
+
+	event->sw_function_id = MLX5_GET(query_vhca_state_out, out,
+					 vhca_state_context.sw_function_id);
+	event->new_vhca_state = MLX5_GET(query_vhca_state_out, out,
+					 vhca_state_context.vhca_state);
+
+	mlx5_vhca_event_arm(dev, event->function_id, event->ecpu);
+
+	blocking_notifier_call_chain(&dev->priv.vhca_state_notifier->n_head, 0, event);
+}
+
+static void mlx5_vhca_state_work_handler(struct work_struct *_work)
+{
+	struct mlx5_vhca_event_work *work = container_of(_work, struct mlx5_vhca_event_work, work);
+	struct mlx5_vhca_state_notifier *notifier = work->notifier;
+	struct mlx5_core_dev *dev = notifier->dev;
+
+	mlx5_vhca_event_notify(dev, &work->event);
+}
+
+static int
+mlx5_vhca_state_change_notifier(struct notifier_block *nb, unsigned long type, void *data)
+{
+	struct mlx5_vhca_state_notifier *notifier =
+				mlx5_nb_cof(nb, struct mlx5_vhca_state_notifier, nb);
+	struct mlx5_vhca_event_work *work;
+	struct mlx5_eqe *eqe = data;
+
+	work = kzalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work)
+		return NOTIFY_DONE;
+	INIT_WORK(&work->work, &mlx5_vhca_state_work_handler);
+	work->notifier = notifier;
+	work->event.function_id = be16_to_cpu(eqe->data.vhca_state.function_id);
+	work->event.ecpu = be16_to_cpu(eqe->data.vhca_state.ec_function);
+	mlx5_events_work_enqueue(notifier->dev, &work->work);
+	return NOTIFY_OK;
+}
+
+void mlx5_vhca_state_cap_handle(struct mlx5_core_dev *dev, void *set_hca_cap)
+{
+	if (!mlx5_vhca_event_supported(dev))
+		return;
+
+	MLX5_SET(cmd_hca_cap, set_hca_cap, vhca_state, 1);
+	MLX5_SET(cmd_hca_cap, set_hca_cap, event_on_vhca_state_allocated, 1);
+	MLX5_SET(cmd_hca_cap, set_hca_cap, event_on_vhca_state_active, 1);
+	MLX5_SET(cmd_hca_cap, set_hca_cap, event_on_vhca_state_in_use, 1);
+	MLX5_SET(cmd_hca_cap, set_hca_cap, event_on_vhca_state_teardown_request, 1);
+}
+
+int mlx5_vhca_event_init(struct mlx5_core_dev *dev)
+{
+	struct mlx5_vhca_state_notifier *notifier;
+
+	if (!mlx5_vhca_event_supported(dev))
+		return 0;
+
+	notifier = kzalloc(sizeof(*notifier), GFP_KERNEL);
+	if (!notifier)
+		return -ENOMEM;
+
+	dev->priv.vhca_state_notifier = notifier;
+	notifier->dev = dev;
+	BLOCKING_INIT_NOTIFIER_HEAD(&notifier->n_head);
+	MLX5_NB_INIT(&notifier->nb, mlx5_vhca_state_change_notifier, VHCA_STATE_CHANGE);
+	return 0;
+}
+
+void mlx5_vhca_event_cleanup(struct mlx5_core_dev *dev)
+{
+	if (!mlx5_vhca_event_supported(dev))
+		return;
+
+	kfree(dev->priv.vhca_state_notifier);
+	dev->priv.vhca_state_notifier = NULL;
+}
+
+void mlx5_vhca_event_start(struct mlx5_core_dev *dev)
+{
+	struct mlx5_vhca_state_notifier *notifier;
+
+	if (!dev->priv.vhca_state_notifier)
+		return;
+
+	notifier = dev->priv.vhca_state_notifier;
+	mlx5_eq_notifier_register(dev, &notifier->nb);
+}
+
+void mlx5_vhca_event_stop(struct mlx5_core_dev *dev)
+{
+	struct mlx5_vhca_state_notifier *notifier;
+
+	if (!dev->priv.vhca_state_notifier)
+		return;
+
+	notifier = dev->priv.vhca_state_notifier;
+	mlx5_eq_notifier_unregister(dev, &notifier->nb);
+}
+
+int mlx5_vhca_event_notifier_register(struct mlx5_core_dev *dev, struct notifier_block *nb)
+{
+	if (!dev->priv.vhca_state_notifier)
+		return -EOPNOTSUPP;
+	return blocking_notifier_chain_register(&dev->priv.vhca_state_notifier->n_head, nb);
+}
+
+void mlx5_vhca_event_notifier_unregister(struct mlx5_core_dev *dev, struct notifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&dev->priv.vhca_state_notifier->n_head, nb);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.h
new file mode 100644
index 000000000000..1fe1ec6f4d4b
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+
+#ifndef __MLX5_VHCA_EVENT_H__
+#define __MLX5_VHCA_EVENT_H__
+
+#ifdef CONFIG_MLX5_SF
+
+struct mlx5_vhca_state_event {
+	u16 function_id;
+	u16 sw_function_id;
+	u8 new_vhca_state;
+	bool ecpu;
+};
+
+static inline bool mlx5_vhca_event_supported(const struct mlx5_core_dev *dev)
+{
+	return MLX5_CAP_GEN_MAX(dev, vhca_state);
+}
+
+void mlx5_vhca_state_cap_handle(struct mlx5_core_dev *dev, void *set_hca_cap);
+int mlx5_vhca_event_init(struct mlx5_core_dev *dev);
+void mlx5_vhca_event_cleanup(struct mlx5_core_dev *dev);
+void mlx5_vhca_event_start(struct mlx5_core_dev *dev);
+void mlx5_vhca_event_stop(struct mlx5_core_dev *dev);
+int mlx5_vhca_event_notifier_register(struct mlx5_core_dev *dev, struct notifier_block *nb);
+void mlx5_vhca_event_notifier_unregister(struct mlx5_core_dev *dev, struct notifier_block *nb);
+int mlx5_modify_vhca_sw_id(struct mlx5_core_dev *dev, u16 function_id, bool ecpu, u32 sw_fn_id);
+int mlx5_vhca_event_arm(struct mlx5_core_dev *dev, u16 function_id, bool ecpu);
+int mlx5_cmd_query_vhca_state(struct mlx5_core_dev *dev, u16 function_id,
+			      bool ecpu, u32 *out, u32 outlen);
+#else
+
+static inline void mlx5_vhca_state_cap_handle(struct mlx5_core_dev *dev, void *set_hca_cap)
+{
+}
+
+static inline int mlx5_vhca_event_init(struct mlx5_core_dev *dev)
+{
+	return 0;
+}
+
+static inline void mlx5_vhca_event_cleanup(struct mlx5_core_dev *dev)
+{
+}
+
+static inline void mlx5_vhca_event_start(struct mlx5_core_dev *dev)
+{
+}
+
+static inline void mlx5_vhca_event_stop(struct mlx5_core_dev *dev)
+{
+}
+
+#endif
+
+#endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f93bfe7473aa..ffba0786051e 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -507,6 +507,7 @@ struct mlx5_devcom;
 struct mlx5_fw_reset;
 struct mlx5_eq_table;
 struct mlx5_irq_table;
+struct mlx5_vhca_state_notifier;
 
 struct mlx5_rate_limit {
 	u32			rate;
@@ -603,6 +604,9 @@ struct mlx5_priv {
 
 	struct mlx5_bfreg_data		bfregs;
 	struct mlx5_uars_page	       *uar;
+#ifdef CONFIG_MLX5_SF
+	struct mlx5_vhca_state_notifier *vhca_state_notifier;
+#endif
 };
 
 enum mlx5_device_state {
-- 
2.26.2


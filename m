Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA9843A51C
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhJYU5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232868AbhJYU5C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 16:57:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD1AE61078;
        Mon, 25 Oct 2021 20:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635195280;
        bh=lihve8XgaL5xeOvxQZThiTTwVFWnFHFLAPOX4qTUTIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZd1dSghpAnlIvp6I2UfVGIQm+X21+QtyVgEvs2JLo4rJaCNYd2QYK9+cZDUQQ5Bv
         LIQVJl8MVVLl+/mH6ORwOjG9EMBTpdpDmpk+xUxjHIQZbbjphQl3RPYaLRkorVvlWP
         ZF5qDtqut3x0C6oXVuwK+hP/ipe5BkS2S6GekCMe/B2/0NxHMxjnjxSZADqzQB7mWT
         GsNGwtDgO3wRst+Y2K5GoYN5ze9soD3e72fxo3ESY2HeVjHJs/Y3fv125qeGXnpfjg
         5ctuJ8YLWLHT+4EujQkos/wPiofuPguF24/o5acH9zb8MXj0Et1++9Xit9+e8Z04KC
         +poXcgleeHA1w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/14] net/mlx5: SF_DEV Add SF device trace points
Date:   Mon, 25 Oct 2021 13:54:31 -0700
Message-Id: <20211025205431.365080-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025205431.365080-1-saeed@kernel.org>
References: <20211025205431.365080-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Add SF device add and delete specific trace points.

echo mlx5:mlx5_sf_dev_add >> /sys/kernel/debug/tracing/set_event
echo mlx5:mlx5_sf_dev_del >> /sys/kernel/debug/tracing/set_event
echo mlx5:mlx5_sf_vhca_event >> /sys/kernel/debug/tracing/set_event

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst | 21 +++++++
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.c  | 23 ++++++--
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.h  |  1 +
 .../mlx5/core/sf/dev/diag/dev_tracepoint.h    | 58 +++++++++++++++++++
 .../mlx5/core/sf/diag/vhca_tracepoint.h       | 40 +++++++++++++
 .../mellanox/mlx5/core/sf/vhca_event.c        |  3 +
 6 files changed, 140 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/diag/dev_tracepoint.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/diag/vhca_tracepoint.h

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index d6c10408adc4..5edf50d7dbd5 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -739,3 +739,24 @@ SF tracepoints:
     $ cat /sys/kernel/debug/tracing/trace
     ...
     devlink-9519    [046] ..... 24624.400271: mlx5_sf_hwc_deferred_free: (0000:06:00.0) hw_id=0x8000
+
+- mlx5_sf_vhca_event: trace SF vhca event and state::
+
+    $ echo mlx5:mlx5_sf_vhca_event >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    kworker/u128:3-9093    [046] ..... 24625.365525: mlx5_sf_vhca_event: (0000:06:00.0) hw_id=0x8000 sfnum=88 vhca_state=1
+
+- mlx5_sf_dev_add : trace SF device add event::
+
+    $ echo mlx5:mlx5_sf_dev_add>> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    kworker/u128:3-9093    [000] ..... 24616.524495: mlx5_sf_dev_add: (0000:06:00.0) sfdev=00000000fc5d96fd aux_id=4 hw_id=0x8000 sfnum=88
+
+- mlx5_sf_dev_del : trace SF device delete event::
+
+    $ echo mlx5:mlx5_sf_dev_del >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    kworker/u128:3-9093    [044] ..... 24624.400749: mlx5_sf_dev_del: (0000:06:00.0) sfdev=00000000fc5d96fd aux_id=4 hw_id=0x8000 sfnum=88
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
index 871c2fbe18d3..f37db7cc32a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -9,6 +9,8 @@
 #include "sf/sf.h"
 #include "sf/mlx5_ifc_vhca_event.h"
 #include "ecpf.h"
+#define CREATE_TRACE_POINTS
+#include "diag/dev_tracepoint.h"
 
 struct mlx5_sf_dev_table {
 	struct xarray devices;
@@ -66,13 +68,18 @@ static void mlx5_sf_dev_release(struct device *device)
 	kfree(sf_dev);
 }
 
-static void mlx5_sf_dev_remove(struct mlx5_sf_dev *sf_dev)
+static void mlx5_sf_dev_remove(struct mlx5_core_dev *dev, struct mlx5_sf_dev *sf_dev)
 {
+	int id;
+
+	id = sf_dev->adev.id;
+	trace_mlx5_sf_dev_del(dev, sf_dev, id);
+
 	auxiliary_device_delete(&sf_dev->adev);
 	auxiliary_device_uninit(&sf_dev->adev);
 }
 
-static void mlx5_sf_dev_add(struct mlx5_core_dev *dev, u16 sf_index, u32 sfnum)
+static void mlx5_sf_dev_add(struct mlx5_core_dev *dev, u16 sf_index, u16 fn_id, u32 sfnum)
 {
 	struct mlx5_sf_dev_table *table = dev->priv.sf_dev_table;
 	struct mlx5_sf_dev *sf_dev;
@@ -100,6 +107,7 @@ static void mlx5_sf_dev_add(struct mlx5_core_dev *dev, u16 sf_index, u32 sfnum)
 	sf_dev->adev.dev.groups = sf_attr_groups;
 	sf_dev->sfnum = sfnum;
 	sf_dev->parent_mdev = dev;
+	sf_dev->fn_id = fn_id;
 
 	if (!table->max_sfs) {
 		mlx5_adev_idx_free(id);
@@ -109,6 +117,8 @@ static void mlx5_sf_dev_add(struct mlx5_core_dev *dev, u16 sf_index, u32 sfnum)
 	}
 	sf_dev->bar_base_addr = table->base_address + (sf_index * table->sf_bar_length);
 
+	trace_mlx5_sf_dev_add(dev, sf_dev, id);
+
 	err = auxiliary_device_init(&sf_dev->adev);
 	if (err) {
 		mlx5_adev_idx_free(id);
@@ -128,7 +138,7 @@ static void mlx5_sf_dev_add(struct mlx5_core_dev *dev, u16 sf_index, u32 sfnum)
 	return;
 
 xa_err:
-	mlx5_sf_dev_remove(sf_dev);
+	mlx5_sf_dev_remove(dev, sf_dev);
 add_err:
 	mlx5_core_err(dev, "SF DEV: fail device add for index=%d sfnum=%d err=%d\n",
 		      sf_index, sfnum, err);
@@ -139,7 +149,7 @@ static void mlx5_sf_dev_del(struct mlx5_core_dev *dev, struct mlx5_sf_dev *sf_de
 	struct mlx5_sf_dev_table *table = dev->priv.sf_dev_table;
 
 	xa_erase(&table->devices, sf_index);
-	mlx5_sf_dev_remove(sf_dev);
+	mlx5_sf_dev_remove(dev, sf_dev);
 }
 
 static int
@@ -178,7 +188,8 @@ mlx5_sf_dev_state_change_handler(struct notifier_block *nb, unsigned long event_
 		break;
 	case MLX5_VHCA_STATE_ACTIVE:
 		if (!sf_dev)
-			mlx5_sf_dev_add(table->dev, sf_index, event->sw_function_id);
+			mlx5_sf_dev_add(table->dev, sf_index, event->function_id,
+					event->sw_function_id);
 		break;
 	default:
 		break;
@@ -260,7 +271,7 @@ static void mlx5_sf_dev_destroy_all(struct mlx5_sf_dev_table *table)
 
 	xa_for_each(&table->devices, index, sf_dev) {
 		xa_erase(&table->devices, index);
-		mlx5_sf_dev_remove(sf_dev);
+		mlx5_sf_dev_remove(table->dev, sf_dev);
 	}
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
index 149fd9e698cf..2a66a427ef15 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
@@ -16,6 +16,7 @@ struct mlx5_sf_dev {
 	struct mlx5_core_dev *mdev;
 	phys_addr_t bar_base_addr;
 	u32 sfnum;
+	u16 fn_id;
 };
 
 void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/diag/dev_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/diag/dev_tracepoint.h
new file mode 100644
index 000000000000..7f7c9af5deed
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/diag/dev_tracepoint.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mlx5
+
+#if !defined(_MLX5_SF_DEV_TP_) || defined(TRACE_HEADER_MULTI_READ)
+#define _MLX5_SF_DEV_TP_
+
+#include <linux/tracepoint.h>
+#include <linux/mlx5/driver.h>
+#include "../../dev/dev.h"
+
+DECLARE_EVENT_CLASS(mlx5_sf_dev_template,
+		    TP_PROTO(const struct mlx5_core_dev *dev,
+			     const struct mlx5_sf_dev *sfdev,
+			     int aux_id),
+		    TP_ARGS(dev, sfdev, aux_id),
+		    TP_STRUCT__entry(__string(devname, dev_name(dev->device))
+				     __field(const struct mlx5_sf_dev*, sfdev)
+				     __field(int, aux_id)
+				     __field(u16, hw_fn_id)
+				     __field(u32, sfnum)
+		    ),
+		    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+				   __entry->sfdev = sfdev;
+				   __entry->aux_id = aux_id;
+				   __entry->hw_fn_id = sfdev->fn_id;
+				   __entry->sfnum = sfdev->sfnum;
+		    ),
+		    TP_printk("(%s) sfdev=%pK aux_id=%d hw_id=0x%x sfnum=%u\n",
+			      __get_str(devname), __entry->sfdev,
+			      __entry->aux_id, __entry->hw_fn_id,
+			      __entry->sfnum)
+);
+
+DEFINE_EVENT(mlx5_sf_dev_template, mlx5_sf_dev_add,
+	     TP_PROTO(const struct mlx5_core_dev *dev,
+		      const struct mlx5_sf_dev *sfdev,
+		      int aux_id),
+	     TP_ARGS(dev, sfdev, aux_id)
+	     );
+
+DEFINE_EVENT(mlx5_sf_dev_template, mlx5_sf_dev_del,
+	     TP_PROTO(const struct mlx5_core_dev *dev,
+		      const struct mlx5_sf_dev *sfdev,
+		      int aux_id),
+	     TP_ARGS(dev, sfdev, aux_id)
+	     );
+
+#endif /* _MLX5_SF_DEV_TP_ */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH sf/dev/diag
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE dev_tracepoint
+#include <trace/define_trace.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/vhca_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/vhca_tracepoint.h
new file mode 100644
index 000000000000..fd814a190b8b
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/vhca_tracepoint.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mlx5
+
+#if !defined(_MLX5_SF_VHCA_TP_) || defined(TRACE_HEADER_MULTI_READ)
+#define _MLX5_SF_VHCA_TP_
+
+#include <linux/tracepoint.h>
+#include <linux/mlx5/driver.h>
+#include "sf/vhca_event.h"
+
+TRACE_EVENT(mlx5_sf_vhca_event,
+	    TP_PROTO(const struct mlx5_core_dev *dev,
+		     const struct mlx5_vhca_state_event *event),
+	    TP_ARGS(dev, event),
+	    TP_STRUCT__entry(__string(devname, dev_name(dev->device))
+			     __field(u16, hw_fn_id)
+			     __field(u32, sfnum)
+			     __field(u8, vhca_state)
+			    ),
+	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+		    __entry->hw_fn_id = event->function_id;
+		    __entry->sfnum = event->sw_function_id;
+		    __entry->vhca_state = event->new_vhca_state;
+	    ),
+	    TP_printk("(%s) hw_id=0x%x sfnum=%u vhca_state=%d\n",
+		      __get_str(devname), __entry->hw_fn_id,
+		      __entry->sfnum, __entry->vhca_state)
+);
+
+#endif /* _MLX5_SF_VHCA_TP_ */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH sf/diag
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE vhca_tracepoint
+#include <trace/define_trace.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c
index 28b14b05086f..d908fba968f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c
@@ -6,6 +6,8 @@
 #include "mlx5_core.h"
 #include "vhca_event.h"
 #include "ecpf.h"
+#define CREATE_TRACE_POINTS
+#include "diag/vhca_tracepoint.h"
 
 struct mlx5_vhca_state_notifier {
 	struct mlx5_core_dev *dev;
@@ -82,6 +84,7 @@ mlx5_vhca_event_notify(struct mlx5_core_dev *dev, struct mlx5_vhca_state_event *
 					 vhca_state_context.vhca_state);
 
 	mlx5_vhca_event_arm(dev, event->function_id);
+	trace_mlx5_sf_vhca_event(dev, event);
 
 	blocking_notifier_call_chain(&dev->priv.vhca_state_notifier->n_head, 0, event);
 }
-- 
2.31.1


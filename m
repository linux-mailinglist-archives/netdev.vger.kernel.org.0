Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57A943A51A
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhJYU5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233920AbhJYU5C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 16:57:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EF9461073;
        Mon, 25 Oct 2021 20:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635195279;
        bh=IGwjR3jcAbRA7JFHtSS2ia+bVyOm1a9J8cuxnEbKcSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdCsQd0YNcmwhikLOE2SXTPdbLuvZFrVlrFQuiquOuZKY0HbbKFvN4YIx0QdjKld4
         GJKbPTvsx3xSIoTkHxagGD2ck90AinC8drvvAjfqtK+Tkmq6ajaainOlKPkmR2vJXr
         cURojAB4rwJvpRk2NYxKpkhK+snZm/WMV1LNFJVq4Tuvy0y4T663AgWmobKqG57Xd/
         o+b3+h4zaV6OAKp+dYIwDstKQ+jfV/v+ELff0YkGKKf2j2hqiKd+ehqAPfiTlyEuXH
         xRH5rH2ttRENs8ljRBXM8Je0w7+CXeLDG9Bowe4s/AI/sInfI2DWeuSRbqna0r5fCX
         Bf+fmcxemcLrA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/14] net/mlx5: SF, Add SF trace points
Date:   Mon, 25 Oct 2021 13:54:30 -0700
Message-Id: <20211025205431.365080-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025205431.365080-1-saeed@kernel.org>
References: <20211025205431.365080-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Add support for trace events for SFs to improve debugging.
This covers
(a) port add and free trace points
(b) device level trace points
(c) SF hardware context add, free trace points.
(d) SF function activate/deacticate and state trace points

SF events examples:
echo mlx5:mlx5_sf_add >> /sys/kernel/debug/tracing/set_event
echo mlx5:mlx5_sf_free >> /sys/kernel/debug/tracing/set_event
echo mlx5:mlx5_sf_hwc_alloc >> /sys/kernel/debug/tracing/set_event
echo mlx5:mlx5_sf_hwc_free >> /sys/kernel/debug/tracing/set_event
echo mlx5:mlx5_sf_hwc_deferred_free >> /sys/kernel/debug/tracing/set_event
echo mlx5:mlx5_sf_update_state >> /sys/kernel/debug/tracing/set_event
echo mlx5:mlx5_sf_activate >> /sys/kernel/debug/tracing/set_event
echo mlx5:mlx5_sf_deactivate >> /sys/kernel/debug/tracing/set_event

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst |  37 ++++
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  |   8 +
 .../mlx5/core/sf/diag/sf_tracepoint.h         | 173 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c |   4 +
 4 files changed, 222 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/diag/sf_tracepoint.h

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index 2ee74a49be9d..d6c10408adc4 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -702,3 +702,40 @@ Eswitch QoS tracepoints:
     $ cat /sys/kernel/debug/tracing/trace
     ...
     <...>-27418   [006] .... 76547.187258: mlx5_esw_group_qos_destroy: (0000:82:00.0) group=000000007b576bb3 tsar_ix=1
+
+SF tracepoints:
+
+- mlx5_sf_add: trace addition of the SF port::
+
+    $ echo mlx5:mlx5_sf_add >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    devlink-9363    [031] ..... 24610.188722: mlx5_sf_add: (0000:06:00.0) port_index=32768 controller=0 hw_id=0x8000 sfnum=88
+
+- mlx5_sf_free: trace freeing of the SF port::
+
+    $ echo mlx5:mlx5_sf_free >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    devlink-9830    [038] ..... 26300.404749: mlx5_sf_free: (0000:06:00.0) port_index=32768 controller=0 hw_id=0x8000
+
+- mlx5_sf_hwc_alloc: trace allocating of the hardware SF context::
+
+    $ echo mlx5:mlx5_sf_hwc_alloc >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    devlink-9775    [031] ..... 26296.385259: mlx5_sf_hwc_alloc: (0000:06:00.0) controller=0 hw_id=0x8000 sfnum=88
+
+- mlx5_sf_hwc_free: trace freeing of the hardware SF context::
+
+    $ echo mlx5:mlx5_sf_hwc_free >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    kworker/u128:3-9093    [046] ..... 24625.365771: mlx5_sf_hwc_free: (0000:06:00.0) hw_id=0x8000
+
+- mlx5_sf_hwc_deferred_free : trace deferred freeing of the hardware SF context::
+
+    $ echo mlx5:mlx5_sf_hwc_deferred_free >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    devlink-9519    [046] ..... 24624.400271: mlx5_sf_hwc_deferred_free: (0000:06:00.0) hw_id=0x8000
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index e1bb3acf45e6..3be659cd91f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -8,6 +8,8 @@
 #include "mlx5_ifc_vhca_event.h"
 #include "vhca_event.h"
 #include "ecpf.h"
+#define CREATE_TRACE_POINTS
+#include "diag/sf_tracepoint.h"
 
 struct mlx5_sf {
 	struct devlink_port dl_port;
@@ -112,6 +114,7 @@ static void mlx5_sf_free(struct mlx5_sf_table *table, struct mlx5_sf *sf)
 {
 	mlx5_sf_id_erase(table, sf);
 	mlx5_sf_hw_table_sf_free(table->dev, sf->controller, sf->id);
+	trace_mlx5_sf_free(table->dev, sf->port_index, sf->controller, sf->hw_fn_id);
 	kfree(sf);
 }
 
@@ -209,6 +212,7 @@ static int mlx5_sf_activate(struct mlx5_core_dev *dev, struct mlx5_sf *sf,
 		return err;
 
 	sf->hw_state = MLX5_VHCA_STATE_ACTIVE;
+	trace_mlx5_sf_activate(dev, sf->port_index, sf->controller, sf->hw_fn_id);
 	return 0;
 }
 
@@ -224,6 +228,7 @@ static int mlx5_sf_deactivate(struct mlx5_core_dev *dev, struct mlx5_sf *sf)
 		return err;
 
 	sf->hw_state = MLX5_VHCA_STATE_TEARDOWN_REQUEST;
+	trace_mlx5_sf_deactivate(dev, sf->port_index, sf->controller, sf->hw_fn_id);
 	return 0;
 }
 
@@ -293,6 +298,7 @@ static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 	if (err)
 		goto esw_err;
 	*new_port_index = sf->port_index;
+	trace_mlx5_sf_add(dev, sf->port_index, sf->controller, sf->hw_fn_id, new_attr->sfnum);
 	return 0;
 
 esw_err:
@@ -442,6 +448,8 @@ static int mlx5_sf_vhca_event(struct notifier_block *nb, unsigned long opcode, v
 	update = mlx5_sf_state_update_check(sf, event->new_vhca_state);
 	if (update)
 		sf->hw_state = event->new_vhca_state;
+	trace_mlx5_sf_update_state(table->dev, sf->port_index, sf->controller,
+				   sf->hw_fn_id, sf->hw_state);
 sf_err:
 	mutex_unlock(&table->sf_state_lock);
 	mlx5_sf_table_put(table);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/sf_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/sf_tracepoint.h
new file mode 100644
index 000000000000..8bf1cd90930d
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/sf_tracepoint.h
@@ -0,0 +1,173 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mlx5
+
+#if !defined(_MLX5_SF_TP_) || defined(TRACE_HEADER_MULTI_READ)
+#define _MLX5_SF_TP_
+
+#include <linux/tracepoint.h>
+#include <linux/mlx5/driver.h>
+#include "sf/vhca_event.h"
+
+TRACE_EVENT(mlx5_sf_add,
+	    TP_PROTO(const struct mlx5_core_dev *dev,
+		     unsigned int port_index,
+		     u32 controller,
+		     u16 hw_fn_id,
+		     u32 sfnum),
+	    TP_ARGS(dev, port_index, controller, hw_fn_id, sfnum),
+	    TP_STRUCT__entry(__string(devname, dev_name(dev->device))
+			     __field(unsigned int, port_index)
+			     __field(u32, controller)
+			     __field(u16, hw_fn_id)
+			     __field(u32, sfnum)
+			    ),
+	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+		    __entry->port_index = port_index;
+		    __entry->controller = controller;
+		    __entry->hw_fn_id = hw_fn_id;
+		    __entry->sfnum = sfnum;
+	    ),
+	    TP_printk("(%s) port_index=%u controller=%u hw_id=0x%x sfnum=%u\n",
+		      __get_str(devname), __entry->port_index, __entry->controller,
+		      __entry->hw_fn_id, __entry->sfnum)
+);
+
+TRACE_EVENT(mlx5_sf_free,
+	    TP_PROTO(const struct mlx5_core_dev *dev,
+		     unsigned int port_index,
+		     u32 controller,
+		     u16 hw_fn_id),
+	    TP_ARGS(dev, port_index, controller, hw_fn_id),
+	    TP_STRUCT__entry(__string(devname, dev_name(dev->device))
+			     __field(unsigned int, port_index)
+			     __field(u32, controller)
+			     __field(u16, hw_fn_id)
+			    ),
+	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+		    __entry->port_index = port_index;
+		    __entry->controller = controller;
+		    __entry->hw_fn_id = hw_fn_id;
+	    ),
+	    TP_printk("(%s) port_index=%u controller=%u hw_id=0x%x\n",
+		      __get_str(devname), __entry->port_index, __entry->controller,
+		      __entry->hw_fn_id)
+);
+
+TRACE_EVENT(mlx5_sf_hwc_alloc,
+	    TP_PROTO(const struct mlx5_core_dev *dev,
+		     u32 controller,
+		     u16 hw_fn_id,
+		     u32 sfnum),
+	    TP_ARGS(dev, controller, hw_fn_id, sfnum),
+	    TP_STRUCT__entry(__string(devname, dev_name(dev->device))
+			     __field(u32, controller)
+			     __field(u16, hw_fn_id)
+			     __field(u32, sfnum)
+			    ),
+	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+		    __entry->controller = controller;
+		    __entry->hw_fn_id = hw_fn_id;
+		    __entry->sfnum = sfnum;
+	    ),
+	    TP_printk("(%s) controller=%u hw_id=0x%x sfnum=%u\n",
+		      __get_str(devname), __entry->controller, __entry->hw_fn_id,
+		      __entry->sfnum)
+);
+
+TRACE_EVENT(mlx5_sf_hwc_free,
+	    TP_PROTO(const struct mlx5_core_dev *dev,
+		     u16 hw_fn_id),
+	    TP_ARGS(dev, hw_fn_id),
+	    TP_STRUCT__entry(__string(devname, dev_name(dev->device))
+			     __field(u16, hw_fn_id)
+			    ),
+	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+		    __entry->hw_fn_id = hw_fn_id;
+	    ),
+	    TP_printk("(%s) hw_id=0x%x\n", __get_str(devname), __entry->hw_fn_id)
+);
+
+TRACE_EVENT(mlx5_sf_hwc_deferred_free,
+	    TP_PROTO(const struct mlx5_core_dev *dev,
+		     u16 hw_fn_id),
+	    TP_ARGS(dev, hw_fn_id),
+	    TP_STRUCT__entry(__string(devname, dev_name(dev->device))
+			     __field(u16, hw_fn_id)
+			    ),
+	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+		    __entry->hw_fn_id = hw_fn_id;
+	    ),
+	    TP_printk("(%s) hw_id=0x%x\n", __get_str(devname), __entry->hw_fn_id)
+);
+
+DECLARE_EVENT_CLASS(mlx5_sf_state_template,
+		    TP_PROTO(const struct mlx5_core_dev *dev,
+			     u32 port_index,
+			     u32 controller,
+			     u16 hw_fn_id),
+		    TP_ARGS(dev, port_index, controller, hw_fn_id),
+		    TP_STRUCT__entry(__string(devname, dev_name(dev->device))
+				     __field(unsigned int, port_index)
+				     __field(u32, controller)
+				     __field(u16, hw_fn_id)),
+		    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+				   __entry->port_index = port_index;
+				   __entry->controller = controller;
+				   __entry->hw_fn_id = hw_fn_id;
+		    ),
+		    TP_printk("(%s) port_index=%u controller=%u hw_id=0x%x\n",
+			      __get_str(devname), __entry->port_index, __entry->controller,
+			      __entry->hw_fn_id)
+);
+
+DEFINE_EVENT(mlx5_sf_state_template, mlx5_sf_activate,
+	     TP_PROTO(const struct mlx5_core_dev *dev,
+		      u32 port_index,
+		      u32 controller,
+		      u16 hw_fn_id),
+	     TP_ARGS(dev, port_index, controller, hw_fn_id)
+	     );
+
+DEFINE_EVENT(mlx5_sf_state_template, mlx5_sf_deactivate,
+	     TP_PROTO(const struct mlx5_core_dev *dev,
+		      u32 port_index,
+		      u32 controller,
+		      u16 hw_fn_id),
+	     TP_ARGS(dev, port_index, controller, hw_fn_id)
+	     );
+
+TRACE_EVENT(mlx5_sf_update_state,
+	    TP_PROTO(const struct mlx5_core_dev *dev,
+		     unsigned int port_index,
+		     u32 controller,
+		     u16 hw_fn_id,
+		     u8 state),
+	    TP_ARGS(dev, port_index, controller, hw_fn_id, state),
+	    TP_STRUCT__entry(__string(devname, dev_name(dev->device))
+			     __field(unsigned int, port_index)
+			     __field(u32, controller)
+			     __field(u16, hw_fn_id)
+			     __field(u8, state)
+			    ),
+	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+		    __entry->port_index = port_index;
+		    __entry->controller = controller;
+		    __entry->hw_fn_id = hw_fn_id;
+		    __entry->state = state;
+	    ),
+	    TP_printk("(%s) port_index=%u controller=%u hw_id=0x%x state=%u\n",
+		      __get_str(devname), __entry->port_index, __entry->controller,
+		      __entry->hw_fn_id, __entry->state)
+);
+
+#endif /* _MLX5_SF_TP_ */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH sf/diag
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE sf_tracepoint
+#include <trace/define_trace.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index d9c69123c1ab..252d6017387d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -8,6 +8,7 @@
 #include "ecpf.h"
 #include "mlx5_core.h"
 #include "eswitch.h"
+#include "diag/sf_tracepoint.h"
 
 struct mlx5_sf_hw {
 	u32 usr_sfnum;
@@ -142,6 +143,7 @@ int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 controller, u32 usr
 			goto vhca_err;
 	}
 
+	trace_mlx5_sf_hwc_alloc(dev, controller, hw_fn_id, usr_sfnum);
 	mutex_unlock(&table->table_lock);
 	return sw_id;
 
@@ -172,6 +174,7 @@ static void mlx5_sf_hw_table_hwc_sf_free(struct mlx5_core_dev *dev,
 	mlx5_cmd_dealloc_sf(dev, hwc->start_fn_id + idx);
 	hwc->sfs[idx].allocated = false;
 	hwc->sfs[idx].pending_delete = false;
+	trace_mlx5_sf_hwc_free(dev, hwc->start_fn_id + idx);
 }
 
 void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u32 controller, u16 id)
@@ -195,6 +198,7 @@ void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u32 controller
 		hwc->sfs[id].allocated = false;
 	} else {
 		hwc->sfs[id].pending_delete = true;
+		trace_mlx5_sf_hwc_deferred_free(dev, hw_fn_id);
 	}
 err:
 	mutex_unlock(&table->table_lock);
-- 
2.31.1


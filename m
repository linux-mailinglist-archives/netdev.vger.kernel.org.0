Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E33A3F2625
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238227AbhHTE43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237993AbhHTE4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 00:56:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9D56610E6;
        Fri, 20 Aug 2021 04:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629435332;
        bh=QNS7t+YS8Bf3ZxhLm9xiq4FrrMN5B92xcMgRP/1hOrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzJpiAAqAe2hY9ho35v6NxUdxZ0Ut6UBYB7tWf59jjTxZfUZq+llkOYM0yxKRxvcM
         7FZYcvF2vF9QGUeVJQslkN6sNHkcrolNy9vU1yVNFzeNnV2cHGMux7EG6Y2h1Gw+R0
         wyXX2IjHdWT3K8nDW6GdsExzvFwRL5wzjnD2NIkoSuZHiMapHPHB1EmID2cIeN23ps
         PIeWkZ+gZ9AIEPL+tKWyEMYo35PUexXCJTzSDieUPrz8yh5w+I/6vK9ORJp9l8GYOW
         p7VJzPmSfgxyMHM7SATmfG+e/xQi+EUD69j1AYYN6by3/fXDuaSydYNut0m7gBEeRD
         Xm0q439rVdZkQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Huy Nguyen <huyn@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5: E-switch, Add QoS tracepoints
Date:   Thu, 19 Aug 2021 21:55:15 -0700
Message-Id: <20210820045515.265297-16-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820045515.265297-1-saeed@kernel.org>
References: <20210820045515.265297-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Add tracepoints to log QoS enabling/disabling/configuration for vports
and rate groups.

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Huy Nguyen <huyn@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst |  44 +++++++
 .../mlx5/core/esw/diag/qos_tracepoint.h       | 123 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c |  13 +-
 3 files changed, 179 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/diag/qos_tracepoint.h

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index ef8cb62e82a1..4b59cf2c599f 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -656,3 +656,47 @@ Bridge offloads tracepoints:
     $ cat /sys/kernel/debug/tracing/trace
     ...
     ip-5387    [000] ...1       573713: mlx5_esw_bridge_vport_cleanup: vport_num=1
+
+Eswitch QoS tracepoints:
+
+- mlx5_esw_vport_qos_create: trace creation of transmit scheduler arbiter for vport::
+
+    $ echo mlx5:mlx5_esw_vport_qos_create >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    <...>-23496   [018] .... 73136.838831: mlx5_esw_vport_qos_create: (0000:82:00.0) vport=2 tsar_ix=4 bw_share=0, max_rate=0 group=000000007b576bb3
+
+- mlx5_esw_vport_qos_config: trace configuration of transmit scheduler arbiter for vport::
+
+    $ echo mlx5:mlx5_esw_vport_qos_config >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    <...>-26548   [023] .... 75754.223823: mlx5_esw_vport_qos_config: (0000:82:00.0) vport=1 tsar_ix=3 bw_share=34, max_rate=10000 group=000000007b576bb3
+
+- mlx5_esw_vport_qos_destroy: trace deletion of transmit scheduler arbiter for vport::
+
+    $ echo mlx5:mlx5_esw_vport_qos_destroy >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    <...>-27418   [004] .... 76546.680901: mlx5_esw_vport_qos_destroy: (0000:82:00.0) vport=1 tsar_ix=3
+
+- mlx5_esw_group_qos_create: trace creation of transmit scheduler arbiter for rate group::
+
+    $ echo mlx5:mlx5_esw_group_qos_create >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    <...>-26578   [008] .... 75776.022112: mlx5_esw_group_qos_create: (0000:82:00.0) group=000000008dac63ea tsar_ix=5
+
+- mlx5_esw_group_qos_config: trace configuration of transmit scheduler arbiter for rate group::
+
+    $ echo mlx5:mlx5_esw_group_qos_config >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    <...>-27303   [020] .... 76461.455356: mlx5_esw_group_qos_config: (0000:82:00.0) group=000000008dac63ea tsar_ix=5 bw_share=100 max_rate=20000
+
+- mlx5_esw_group_qos_destroy: trace deletion of transmit scheduler arbiter for group::
+
+    $ echo mlx5:mlx5_esw_group_qos_destroy >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    <...>-27418   [006] .... 76547.187258: mlx5_esw_group_qos_destroy: (0000:82:00.0) group=000000007b576bb3 tsar_ix=1
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/qos_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/qos_tracepoint.h
new file mode 100644
index 000000000000..458baf0c6415
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/qos_tracepoint.h
@@ -0,0 +1,123 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mlx5
+
+#if !defined(_MLX5_ESW_TP_) || defined(TRACE_HEADER_MULTI_READ)
+#define _MLX5_ESW_TP_
+
+#include <linux/tracepoint.h>
+#include "eswitch.h"
+
+TRACE_EVENT(mlx5_esw_vport_qos_destroy,
+	    TP_PROTO(const struct mlx5_vport *vport),
+	    TP_ARGS(vport),
+	    TP_STRUCT__entry(__string(devname, dev_name(vport->dev->device))
+			     __field(unsigned short, vport_id)
+			     __field(unsigned int,   tsar_ix)
+			     ),
+	    TP_fast_assign(__assign_str(devname, dev_name(vport->dev->device));
+		    __entry->vport_id = vport->vport;
+		    __entry->tsar_ix = vport->qos.esw_tsar_ix;
+	    ),
+	    TP_printk("(%s) vport=%hu tsar_ix=%u\n",
+		      __get_str(devname), __entry->vport_id, __entry->tsar_ix
+		      )
+);
+
+DECLARE_EVENT_CLASS(mlx5_esw_vport_qos_template,
+		    TP_PROTO(const struct mlx5_vport *vport, u32 bw_share, u32 max_rate),
+		    TP_ARGS(vport, bw_share, max_rate),
+		    TP_STRUCT__entry(__string(devname, dev_name(vport->dev->device))
+				     __field(unsigned short, vport_id)
+				     __field(unsigned int, tsar_ix)
+				     __field(unsigned int, bw_share)
+				     __field(unsigned int, max_rate)
+				     __field(void *, group)
+				     ),
+		    TP_fast_assign(__assign_str(devname, dev_name(vport->dev->device));
+			    __entry->vport_id = vport->vport;
+			    __entry->tsar_ix = vport->qos.esw_tsar_ix;
+			    __entry->bw_share = bw_share;
+			    __entry->max_rate = max_rate;
+			    __entry->group = vport->qos.group;
+		    ),
+		    TP_printk("(%s) vport=%hu tsar_ix=%u bw_share=%u, max_rate=%u group=%p\n",
+			      __get_str(devname), __entry->vport_id, __entry->tsar_ix,
+			      __entry->bw_share, __entry->max_rate, __entry->group
+			      )
+);
+
+DEFINE_EVENT(mlx5_esw_vport_qos_template, mlx5_esw_vport_qos_create,
+	     TP_PROTO(const struct mlx5_vport *vport, u32 bw_share, u32 max_rate),
+	     TP_ARGS(vport, bw_share, max_rate)
+	     );
+
+DEFINE_EVENT(mlx5_esw_vport_qos_template, mlx5_esw_vport_qos_config,
+	     TP_PROTO(const struct mlx5_vport *vport, u32 bw_share, u32 max_rate),
+	     TP_ARGS(vport, bw_share, max_rate)
+	     );
+
+DECLARE_EVENT_CLASS(mlx5_esw_group_qos_template,
+		    TP_PROTO(const struct mlx5_core_dev *dev,
+			     const struct mlx5_esw_rate_group *group,
+			     unsigned int tsar_ix),
+		    TP_ARGS(dev, group, tsar_ix),
+		    TP_STRUCT__entry(__string(devname, dev_name(dev->device))
+				     __field(const void *, group)
+				     __field(unsigned int, tsar_ix)
+				     ),
+		    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+			    __entry->group = group;
+			    __entry->tsar_ix = tsar_ix;
+		    ),
+		    TP_printk("(%s) group=%p tsar_ix=%u\n",
+			      __get_str(devname), __entry->group, __entry->tsar_ix
+			      )
+);
+
+DEFINE_EVENT(mlx5_esw_group_qos_template, mlx5_esw_group_qos_create,
+	     TP_PROTO(const struct mlx5_core_dev *dev,
+		      const struct mlx5_esw_rate_group *group,
+		      unsigned int tsar_ix),
+	     TP_ARGS(dev, group, tsar_ix)
+	     );
+
+DEFINE_EVENT(mlx5_esw_group_qos_template, mlx5_esw_group_qos_destroy,
+	     TP_PROTO(const struct mlx5_core_dev *dev,
+		      const struct mlx5_esw_rate_group *group,
+		      unsigned int tsar_ix),
+	     TP_ARGS(dev, group, tsar_ix)
+	     );
+
+TRACE_EVENT(mlx5_esw_group_qos_config,
+	    TP_PROTO(const struct mlx5_core_dev *dev,
+		     const struct mlx5_esw_rate_group *group,
+		     unsigned int tsar_ix, u32 bw_share, u32 max_rate),
+	    TP_ARGS(dev, group, tsar_ix, bw_share, max_rate),
+	    TP_STRUCT__entry(__string(devname, dev_name(dev->device))
+			     __field(const void *, group)
+			     __field(unsigned int, tsar_ix)
+			     __field(unsigned int, bw_share)
+			     __field(unsigned int, max_rate)
+			     ),
+	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+		    __entry->group = group;
+		    __entry->tsar_ix = tsar_ix;
+		    __entry->bw_share = bw_share;
+		    __entry->max_rate = max_rate;
+	    ),
+	    TP_printk("(%s) group=%p tsar_ix=%u bw_share=%u max_rate=%u\n",
+		      __get_str(devname), __entry->group, __entry->tsar_ix,
+		      __entry->bw_share, __entry->max_rate
+		      )
+);
+#endif /* _MLX5_ESW_TP_ */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH esw/diag
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE qos_tracepoint
+#include <trace/define_trace.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 692c9d543f75..985e305179d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -4,6 +4,8 @@
 #include "eswitch.h"
 #include "esw/qos.h"
 #include "en/port.h"
+#define CREATE_TRACE_POINTS
+#include "diag/qos_tracepoint.h"
 
 /* Minimum supported BW share value by the HW is 1 Mbit/sec */
 #define MLX5_MIN_BW_SHARE 1
@@ -54,6 +56,8 @@ static int esw_qos_group_config(struct mlx5_eswitch *esw, struct mlx5_esw_rate_g
 	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "E-Switch modify group TSAR element failed");
 
+	trace_mlx5_esw_group_qos_config(dev, group, group->tsar_ix, bw_share, max_rate);
+
 	return err;
 }
 
@@ -89,6 +93,8 @@ static int esw_qos_vport_config(struct mlx5_eswitch *esw,
 		return err;
 	}
 
+	trace_mlx5_esw_vport_qos_config(vport, bw_share, max_rate);
+
 	return 0;
 }
 
@@ -461,6 +467,7 @@ esw_qos_create_rate_group(struct mlx5_eswitch *esw, struct netlink_ext_ack *exta
 			goto err_min_rate;
 		}
 	}
+	trace_mlx5_esw_group_qos_create(esw->dev, group, group->tsar_ix);
 
 	return group;
 
@@ -496,6 +503,7 @@ static int esw_qos_destroy_rate_group(struct mlx5_eswitch *esw,
 	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "E-Switch destroy TSAR_ID failed");
 
+	trace_mlx5_esw_group_qos_destroy(esw->dev, group, group->tsar_ix);
 	kfree(group);
 	return err;
 }
@@ -613,8 +621,10 @@ int mlx5_esw_qos_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 	vport->qos.group = esw->qos.group0;
 
 	err = esw_qos_vport_create_sched_element(esw, vport, max_rate, bw_share);
-	if (!err)
+	if (!err) {
 		vport->qos.enabled = true;
+		trace_mlx5_esw_vport_qos_create(vport, bw_share, max_rate);
+	}
 
 	return err;
 }
@@ -637,6 +647,7 @@ void mlx5_esw_qos_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vpo
 			 vport->vport, err);
 
 	vport->qos.enabled = false;
+	trace_mlx5_esw_vport_qos_destroy(vport);
 }
 
 int mlx5_esw_qos_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num, u32 rate_mbps)
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267353A227F
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhFJDAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhFJDAW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A71816142E;
        Thu, 10 Jun 2021 02:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293907;
        bh=5FWYjzI0wqza3+803TAgiZddT0IXHafmPsmvvWyzXNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3VdXi5hkLhwYo13iXs21ZqoRzduXteSSslWfSsaDFCDFLJiyf/imHwweHu+yu0bH
         a9k3RflEgS0fucfAJJCfUrcBIOtf2Dm5kpXi+MIZzZ34LShp+iU/CKbizTdDv+vvra
         M0xQ42URlm0fa7hPZl7F6wIhd84WmsTYPE5gcyu2Xr45MFUpQOJTo5YSzlnEtzsZkD
         2APnyjTJ9JLiTiAOEML5f8OwDf1dkE/McyWlPepKKC6jPyJrJqVgO8Uvcn4YoaCRS3
         HNego78ccYlGaO0pQoxqSdnX72yoLM4KMGStUH3xaEDBHS48gMDZaN/qqUZ9ZRywdm
         s4RgCbclen5Aw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 16/16] net/mlx5: Bridge, add tracepoints
Date:   Wed,  9 Jun 2021 19:58:14 -0700
Message-Id: <20210610025814.274607-17-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Move private bridge structures to dedicated headers that is accessible to
bridge tracepoint header. Implemented following tracepoints:

- Initialize FDB entry.
- Refresh FDB entry.
- Cleanup FDB entry.
- Create VLAN.
- Cleanup VLAN.
- Attach port to bridge.
- Detach port from bridge.

Usage example:

># cd /sys/kernel/debug/tracing
># echo mlx5:mlx5_esw_bridge_fdb_entry_init >> set_event
># cat trace
...
   kworker/u20:1-96      [001] ....   231.892503: mlx5_esw_bridge_fdb_entry_init: net_device=enp8s0f0_0 addr=e4:fd:05:08:00:02 vid=3 flags=0 lastuse=4294895695

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst |  56 +++++++++
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  |  75 ++++--------
 .../mellanox/mlx5/core/esw/bridge_priv.h      |  53 ++++++++
 .../mlx5/core/esw/diag/bridge_tracepoint.h    | 113 ++++++++++++++++++
 4 files changed, 247 insertions(+), 50 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index 058882dca17b..ef8cb62e82a1 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -600,3 +600,59 @@ tc and eswitch offloads tracepoints:
     $ cat /sys/kernel/debug/tracing/trace
     ...
     kworker/u48:7-2221  [009] ...1  1475.387435: mlx5e_rep_neigh_update: netdev: ens1f0 MAC: 24:8a:07:9a:17:9a IPv4: 1.1.1.10 IPv6: ::ffff:1.1.1.10 neigh_connected=1
+
+Bridge offloads tracepoints:
+
+- mlx5_esw_bridge_fdb_entry_init: trace bridge FDB entry offloaded to mlx5::
+
+    $ echo mlx5:mlx5_esw_bridge_fdb_entry_init >> set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    kworker/u20:9-2217    [003] ...1   318.582243: mlx5_esw_bridge_fdb_entry_init: net_device=enp8s0f0_0 addr=e4:fd:05:08:00:02 vid=0 flags=0 used=0
+
+- mlx5_esw_bridge_fdb_entry_cleanup: trace bridge FDB entry deleted from mlx5::
+
+    $ echo mlx5:mlx5_esw_bridge_fdb_entry_cleanup >> set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    ip-2581    [005] ...1   318.629871: mlx5_esw_bridge_fdb_entry_cleanup: net_device=enp8s0f0_1 addr=e4:fd:05:08:00:03 vid=0 flags=0 used=16
+
+- mlx5_esw_bridge_fdb_entry_refresh: trace bridge FDB entry offload refreshed in
+  mlx5::
+
+    $ echo mlx5:mlx5_esw_bridge_fdb_entry_refresh >> set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    kworker/u20:8-3849    [003] ...1       466716: mlx5_esw_bridge_fdb_entry_refresh: net_device=enp8s0f0_0 addr=e4:fd:05:08:00:02 vid=3 flags=0 used=0
+
+- mlx5_esw_bridge_vlan_create: trace bridge VLAN object add on mlx5
+  representor::
+
+    $ echo mlx5:mlx5_esw_bridge_vlan_create >> set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    ip-2560    [007] ...1   318.460258: mlx5_esw_bridge_vlan_create: vid=1 flags=6
+
+- mlx5_esw_bridge_vlan_cleanup: trace bridge VLAN object delete from mlx5
+  representor::
+
+    $ echo mlx5:mlx5_esw_bridge_vlan_cleanup >> set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    bridge-2582    [007] ...1   318.653496: mlx5_esw_bridge_vlan_cleanup: vid=2 flags=8
+
+- mlx5_esw_bridge_vport_init: trace mlx5 vport assigned with bridge upper
+  device::
+
+    $ echo mlx5:mlx5_esw_bridge_vport_init >> set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    ip-2560    [007] ...1   318.458915: mlx5_esw_bridge_vport_init: vport_num=1
+
+- mlx5_esw_bridge_vport_cleanup: trace mlx5 vport removed from bridge upper
+  device::
+
+    $ echo mlx5:mlx5_esw_bridge_vport_cleanup >> set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    ip-5387    [000] ...1       573713: mlx5_esw_bridge_vport_cleanup: vport_num=1
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index b6345619cbfe..a6e1d4f78268 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1,17 +1,15 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2021 Mellanox Technologies. */
 
-#include <linux/netdevice.h>
 #include <linux/list.h>
-#include <linux/rhashtable.h>
-#include <linux/xarray.h>
-#include <linux/if_bridge.h>
-#include <linux/if_vlan.h>
-#include <linux/if_ether.h>
+#include <linux/notifier.h>
+#include <net/netevent.h>
 #include <net/switchdev.h>
 #include "bridge.h"
 #include "eswitch.h"
-#include "fs_core.h"
+#include "bridge_priv.h"
+#define CREATE_TRACE_POINTS
+#include "diag/bridge_tracepoint.h"
 
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE 64000
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM 0
@@ -39,31 +37,6 @@ enum {
 	MLX5_ESW_BRIDGE_LEVEL_SKIP_TABLE,
 };
 
-struct mlx5_esw_bridge_fdb_key {
-	unsigned char addr[ETH_ALEN];
-	u16 vid;
-};
-
-enum {
-	MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER = BIT(0),
-};
-
-struct mlx5_esw_bridge_fdb_entry {
-	struct mlx5_esw_bridge_fdb_key key;
-	struct rhash_head ht_node;
-	struct net_device *dev;
-	struct list_head list;
-	struct list_head vlan_list;
-	u16 vport_num;
-	u16 flags;
-
-	struct mlx5_flow_handle *ingress_handle;
-	struct mlx5_fc *ingress_counter;
-	unsigned long lastuse;
-	struct mlx5_flow_handle *egress_handle;
-	struct mlx5_flow_handle *filter_handle;
-};
-
 static const struct rhashtable_params fdb_ht_params = {
 	.key_offset = offsetof(struct mlx5_esw_bridge_fdb_entry, key),
 	.key_len = sizeof(struct mlx5_esw_bridge_fdb_key),
@@ -71,19 +44,6 @@ static const struct rhashtable_params fdb_ht_params = {
 	.automatic_shrinking = true,
 };
 
-struct mlx5_esw_bridge_vlan {
-	u16 vid;
-	u16 flags;
-	struct list_head fdb_list;
-	struct mlx5_pkt_reformat *pkt_reformat_push;
-	struct mlx5_pkt_reformat *pkt_reformat_pop;
-};
-
-struct mlx5_esw_bridge_port {
-	u16 vport_num;
-	struct xarray vlans;
-};
-
 enum {
 	MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG = BIT(0),
 };
@@ -697,10 +657,23 @@ static void mlx5_esw_bridge_port_erase(struct mlx5_esw_bridge_port *port,
 	xa_erase(&bridge->vports, port->vport_num);
 }
 
+static void mlx5_esw_bridge_fdb_entry_refresh(unsigned long lastuse,
+					      struct mlx5_esw_bridge_fdb_entry *entry)
+{
+	trace_mlx5_esw_bridge_fdb_entry_refresh(entry);
+
+	entry->lastuse = lastuse;
+	mlx5_esw_bridge_fdb_offload_notify(entry->dev, entry->key.addr,
+					   entry->key.vid,
+					   SWITCHDEV_FDB_ADD_TO_BRIDGE);
+}
+
 static void
 mlx5_esw_bridge_fdb_entry_cleanup(struct mlx5_esw_bridge_fdb_entry *entry,
 				  struct mlx5_esw_bridge *bridge)
 {
+	trace_mlx5_esw_bridge_fdb_entry_cleanup(entry);
+
 	rhashtable_remove_fast(&bridge->fdb_ht, &entry->ht_node, fdb_ht_params);
 	mlx5_del_flow_rules(entry->egress_handle);
 	if (entry->filter_handle)
@@ -842,6 +815,7 @@ mlx5_esw_bridge_vlan_create(u16 vid, u16 flags, struct mlx5_esw_bridge_port *por
 	if (err)
 		goto err_xa_insert;
 
+	trace_mlx5_esw_bridge_vlan_create(vlan);
 	return vlan;
 
 err_xa_insert:
@@ -884,6 +858,7 @@ static void mlx5_esw_bridge_vlan_cleanup(struct mlx5_esw_bridge_port *port,
 					 struct mlx5_esw_bridge_vlan *vlan,
 					 struct mlx5_esw_bridge *bridge)
 {
+	trace_mlx5_esw_bridge_vlan_cleanup(vlan);
 	mlx5_esw_bridge_vlan_flush(vlan, bridge);
 	mlx5_esw_bridge_vlan_erase(port, vlan);
 	kvfree(vlan);
@@ -1007,6 +982,8 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsi
 	else
 		INIT_LIST_HEAD(&entry->vlan_list);
 	list_add(&entry->list, &bridge->fdb_list);
+
+	trace_mlx5_esw_bridge_fdb_entry_init(entry);
 	return entry;
 
 err_ht_init:
@@ -1078,6 +1055,7 @@ static int mlx5_esw_bridge_vport_init(struct mlx5_esw_bridge_offloads *br_offloa
 			 vport->vport, err);
 		goto err_port_insert;
 	}
+	trace_mlx5_esw_bridge_vport_init(port);
 
 	vport->bridge = bridge;
 	return 0;
@@ -1106,6 +1084,7 @@ static int mlx5_esw_bridge_vport_cleanup(struct mlx5_esw_bridge_offloads *br_off
 		return -EINVAL;
 	}
 
+	trace_mlx5_esw_bridge_vport_cleanup(port);
 	mlx5_esw_bridge_port_vlans_flush(port, bridge);
 	mlx5_esw_bridge_port_erase(port, bridge);
 	kvfree(port);
@@ -1266,11 +1245,7 @@ void mlx5_esw_bridge_update(struct mlx5_esw_bridge_offloads *br_offloads)
 				continue;
 
 			if (time_after(lastuse, entry->lastuse)) {
-				entry->lastuse = lastuse;
-				/* refresh existing bridge entry */
-				mlx5_esw_bridge_fdb_offload_notify(entry->dev, entry->key.addr,
-								   entry->key.vid,
-								   SWITCHDEV_FDB_ADD_TO_BRIDGE);
+				mlx5_esw_bridge_fdb_entry_refresh(lastuse, entry);
 			} else if (time_is_before_jiffies(entry->lastuse + bridge->ageing_time)) {
 				mlx5_esw_bridge_fdb_offload_notify(entry->dev, entry->key.addr,
 								   entry->key.vid,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
new file mode 100644
index 000000000000..d9ab2e8bc2cb
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#ifndef _MLX5_ESW_BRIDGE_PRIVATE_
+#define _MLX5_ESW_BRIDGE_PRIVATE_
+
+#include <linux/netdevice.h>
+#include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
+#include <linux/if_ether.h>
+#include <linux/rhashtable.h>
+#include <linux/xarray.h>
+#include "fs_core.h"
+
+struct mlx5_esw_bridge_fdb_key {
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+};
+
+enum {
+	MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER = BIT(0),
+};
+
+struct mlx5_esw_bridge_fdb_entry {
+	struct mlx5_esw_bridge_fdb_key key;
+	struct rhash_head ht_node;
+	struct net_device *dev;
+	struct list_head list;
+	struct list_head vlan_list;
+	u16 vport_num;
+	u16 flags;
+
+	struct mlx5_flow_handle *ingress_handle;
+	struct mlx5_fc *ingress_counter;
+	unsigned long lastuse;
+	struct mlx5_flow_handle *egress_handle;
+	struct mlx5_flow_handle *filter_handle;
+};
+
+struct mlx5_esw_bridge_vlan {
+	u16 vid;
+	u16 flags;
+	struct list_head fdb_list;
+	struct mlx5_pkt_reformat *pkt_reformat_push;
+	struct mlx5_pkt_reformat *pkt_reformat_pop;
+};
+
+struct mlx5_esw_bridge_port {
+	u16 vport_num;
+	struct xarray vlans;
+};
+
+#endif /* _MLX5_ESW_BRIDGE_PRIVATE_ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h
new file mode 100644
index 000000000000..227964b7d3b9
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mlx5
+
+#if !defined(_MLX5_ESW_BRIDGE_TRACEPOINT_) || defined(TRACE_HEADER_MULTI_READ)
+#define _MLX5_ESW_BRIDGE_TRACEPOINT_
+
+#include <linux/tracepoint.h>
+#include "../bridge_priv.h"
+
+DECLARE_EVENT_CLASS(mlx5_esw_bridge_fdb_template,
+		    TP_PROTO(const struct mlx5_esw_bridge_fdb_entry *fdb),
+		    TP_ARGS(fdb),
+		    TP_STRUCT__entry(
+			    __array(char, dev_name, IFNAMSIZ)
+			    __array(unsigned char, addr, ETH_ALEN)
+			    __field(u16, vid)
+			    __field(u16, flags)
+			    __field(unsigned int, used)
+			    ),
+		    TP_fast_assign(
+			    strncpy(__entry->dev_name,
+				    netdev_name(fdb->dev),
+				    IFNAMSIZ);
+			    memcpy(__entry->addr, fdb->key.addr, ETH_ALEN);
+			    __entry->vid = fdb->key.vid;
+			    __entry->flags = fdb->flags;
+			    __entry->used = jiffies_to_msecs(jiffies - fdb->lastuse)
+			    ),
+		    TP_printk("net_device=%s addr=%pM vid=%hu flags=%hx used=%u",
+			      __entry->dev_name,
+			      __entry->addr,
+			      __entry->vid,
+			      __entry->flags,
+			      __entry->used / 1000)
+	);
+
+DEFINE_EVENT(mlx5_esw_bridge_fdb_template,
+	     mlx5_esw_bridge_fdb_entry_init,
+	     TP_PROTO(const struct mlx5_esw_bridge_fdb_entry *fdb),
+	     TP_ARGS(fdb)
+	);
+DEFINE_EVENT(mlx5_esw_bridge_fdb_template,
+	     mlx5_esw_bridge_fdb_entry_refresh,
+	     TP_PROTO(const struct mlx5_esw_bridge_fdb_entry *fdb),
+	     TP_ARGS(fdb)
+	);
+DEFINE_EVENT(mlx5_esw_bridge_fdb_template,
+	     mlx5_esw_bridge_fdb_entry_cleanup,
+	     TP_PROTO(const struct mlx5_esw_bridge_fdb_entry *fdb),
+	     TP_ARGS(fdb)
+	);
+
+DECLARE_EVENT_CLASS(mlx5_esw_bridge_vlan_template,
+		    TP_PROTO(const struct mlx5_esw_bridge_vlan *vlan),
+		    TP_ARGS(vlan),
+		    TP_STRUCT__entry(
+			    __field(u16, vid)
+			    __field(u16, flags)
+			    ),
+		    TP_fast_assign(
+			    __entry->vid = vlan->vid;
+			    __entry->flags = vlan->flags;
+			    ),
+		    TP_printk("vid=%hu flags=%hx",
+			      __entry->vid,
+			      __entry->flags)
+	);
+
+DEFINE_EVENT(mlx5_esw_bridge_vlan_template,
+	     mlx5_esw_bridge_vlan_create,
+	     TP_PROTO(const struct mlx5_esw_bridge_vlan *vlan),
+	     TP_ARGS(vlan)
+	);
+DEFINE_EVENT(mlx5_esw_bridge_vlan_template,
+	     mlx5_esw_bridge_vlan_cleanup,
+	     TP_PROTO(const struct mlx5_esw_bridge_vlan *vlan),
+	     TP_ARGS(vlan)
+	);
+
+DECLARE_EVENT_CLASS(mlx5_esw_bridge_port_template,
+		    TP_PROTO(const struct mlx5_esw_bridge_port *port),
+		    TP_ARGS(port),
+		    TP_STRUCT__entry(
+			    __field(u16, vport_num)
+			    ),
+		    TP_fast_assign(
+			    __entry->vport_num = port->vport_num;
+			    ),
+		    TP_printk("vport_num=%hu", __entry->vport_num)
+	);
+
+DEFINE_EVENT(mlx5_esw_bridge_port_template,
+	     mlx5_esw_bridge_vport_init,
+	     TP_PROTO(const struct mlx5_esw_bridge_port *port),
+	     TP_ARGS(port)
+	);
+DEFINE_EVENT(mlx5_esw_bridge_port_template,
+	     mlx5_esw_bridge_vport_cleanup,
+	     TP_PROTO(const struct mlx5_esw_bridge_port *port),
+	     TP_ARGS(port)
+	);
+
+#endif
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH esw/diag
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE bridge_tracepoint
+#include <trace/define_trace.h>
-- 
2.31.1


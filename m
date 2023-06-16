Return-Path: <netdev+bounces-11596-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93C8E733A93
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:13:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C588F1C2039F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC5FA20997;
	Fri, 16 Jun 2023 20:11:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6369E1F160
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7BAC433BA;
	Fri, 16 Jun 2023 20:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946299;
	bh=pOqZaq0U4g2zNI7u4yKhnVPMy4POfu+M4BrIvyjlB5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6PBxEjNmzLzB+5xPWOLqX+3BXJe6ZzesOFb7/gqjdSqnF8H/oI0kTtysjTN1/7WX
	 uLMrtLypAanzihf/2etKzB0KRq+gMkQrPhvHg0ea/tV/hG1HsU7pWBiEz6glFQPvdg
	 1ddJevXjAjr6kkgsBElU+psGK5+pgHklZTUO7CkNCaB8iD/qNJ6MtbOjBLGRHtYJik
	 0QwjUwuMgV7oxtN123UYtDHSfMzxd2bNTictui3dtsvw4BMnK+BU8hRS9ExHMb37S4
	 DD8K4n+bfQUEqKadVsqxgeogyAjQnEP/MzbLvEBxxx2G8M3yWwi6kPvec/0oLv0bQv
	 CisvvLhphY5cA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>
Subject: [net-next 07/15] net/mlx5: Bridge, expose FDB state via debugfs
Date: Fri, 16 Jun 2023 13:11:05 -0700
Message-Id: <20230616201113.45510-8-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616201113.45510-1-saeed@kernel.org>
References: <20230616201113.45510-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vlad Buslov <vladbu@nvidia.com>

For debugging purposes expose offloaded FDB state (flags, counters, etc.)
via debugfs inside 'esw' root directory. Example debugfs file output:

$ cat mlx5/0000\:08\:00.0/esw/bridge/bridge1/fdb
DEV              MAC               VLAN              PACKETS                BYTES              LASTUSE FLAGS
enp8s0f0_1       e4:0a:05:08:00:06    2                    2                  204           4295567112   0x0
enp8s0f0_0       e4:0a:05:08:00:03    2                    3                  278           4295567112   0x0

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  3 +-
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  |  4 +
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  |  2 +
 .../mellanox/mlx5/core/esw/bridge_debugfs.c   | 89 +++++++++++++++++++
 .../mellanox/mlx5/core/esw/bridge_priv.h      |  6 ++
 5 files changed, 103 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_debugfs.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index ddf1e352f51d..35f00700a4d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -75,7 +75,8 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)   += esw/acl/helper.o \
 				      esw/acl/egress_lgcy.o esw/acl/egress_ofld.o \
 				      esw/acl/ingress_lgcy.o esw/acl/ingress_ofld.o
 
-mlx5_core-$(CONFIG_MLX5_BRIDGE)    += esw/bridge.o esw/bridge_mcast.o en/rep/bridge.o
+mlx5_core-$(CONFIG_MLX5_BRIDGE)    += esw/bridge.o esw/bridge_mcast.o esw/bridge_debugfs.o \
+				      en/rep/bridge.o
 
 mlx5_core-$(CONFIG_THERMAL)        += thermal.o
 mlx5_core-$(CONFIG_MLX5_MPFS)      += lib/mpfs.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index eaa9b328abd5..f4fe1daa4afd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -863,6 +863,7 @@ static struct mlx5_esw_bridge *mlx5_esw_bridge_create(struct net_device *br_netd
 	bridge->ageing_time = clock_t_to_jiffies(BR_DEFAULT_AGEING_TIME);
 	bridge->vlan_proto = ETH_P_8021Q;
 	list_add(&bridge->list, &br_offloads->bridges);
+	mlx5_esw_bridge_debugfs_init(br_netdev, bridge);
 
 	return bridge;
 
@@ -886,6 +887,7 @@ static void mlx5_esw_bridge_put(struct mlx5_esw_bridge_offloads *br_offloads,
 	if (--bridge->refcnt)
 		return;
 
+	mlx5_esw_bridge_debugfs_cleanup(bridge);
 	mlx5_esw_bridge_egress_table_cleanup(bridge);
 	mlx5_esw_bridge_mcast_disable(bridge);
 	list_del(&bridge->list);
@@ -1904,6 +1906,7 @@ struct mlx5_esw_bridge_offloads *mlx5_esw_bridge_init(struct mlx5_eswitch *esw)
 	xa_init(&br_offloads->ports);
 	br_offloads->esw = esw;
 	esw->br_offloads = br_offloads;
+	mlx5_esw_bridge_debugfs_offloads_init(br_offloads);
 
 	return br_offloads;
 }
@@ -1919,6 +1922,7 @@ void mlx5_esw_bridge_cleanup(struct mlx5_eswitch *esw)
 
 	mlx5_esw_bridge_flush(br_offloads);
 	WARN_ON(!xa_empty(&br_offloads->ports));
+	mlx5_esw_bridge_debugfs_offloads_cleanup(br_offloads);
 
 	esw->br_offloads = NULL;
 	kvfree(br_offloads);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index 2f7ad3bdba5e..c2c7c70d99eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -10,6 +10,7 @@
 #include <linux/xarray.h>
 #include "eswitch.h"
 
+struct dentry;
 struct mlx5_flow_table;
 struct mlx5_flow_group;
 
@@ -17,6 +18,7 @@ struct mlx5_esw_bridge_offloads {
 	struct mlx5_eswitch *esw;
 	struct list_head bridges;
 	struct xarray ports;
+	struct dentry *debugfs_root;
 
 	struct notifier_block netdev_nb;
 	struct notifier_block nb_blk;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_debugfs.c
new file mode 100644
index 000000000000..b6a45eff28f5
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_debugfs.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include <linux/debugfs.h>
+#include "bridge.h"
+#include "bridge_priv.h"
+
+static void *mlx5_esw_bridge_debugfs_start(struct seq_file *seq, loff_t *pos);
+static void *mlx5_esw_bridge_debugfs_next(struct seq_file *seq, void *v, loff_t *pos);
+static void mlx5_esw_bridge_debugfs_stop(struct seq_file *seq, void *v);
+static int mlx5_esw_bridge_debugfs_show(struct seq_file *seq, void *v);
+
+static const struct seq_operations mlx5_esw_bridge_debugfs_sops = {
+	.start	= mlx5_esw_bridge_debugfs_start,
+	.next	= mlx5_esw_bridge_debugfs_next,
+	.stop	= mlx5_esw_bridge_debugfs_stop,
+	.show	= mlx5_esw_bridge_debugfs_show,
+};
+DEFINE_SEQ_ATTRIBUTE(mlx5_esw_bridge_debugfs);
+
+static void *mlx5_esw_bridge_debugfs_start(struct seq_file *seq, loff_t *pos)
+{
+	struct mlx5_esw_bridge *bridge = seq->private;
+
+	rtnl_lock();
+	return *pos ? seq_list_start(&bridge->fdb_list, *pos - 1) : SEQ_START_TOKEN;
+}
+
+static void *mlx5_esw_bridge_debugfs_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct mlx5_esw_bridge *bridge = seq->private;
+
+	return seq_list_next(v == SEQ_START_TOKEN ? &bridge->fdb_list : v, &bridge->fdb_list, pos);
+}
+
+static void mlx5_esw_bridge_debugfs_stop(struct seq_file *seq, void *v)
+{
+	rtnl_unlock();
+}
+
+static int mlx5_esw_bridge_debugfs_show(struct seq_file *seq, void *v)
+{
+	struct mlx5_esw_bridge_fdb_entry *entry;
+	u64 packets, bytes, lastuse;
+
+	if (v == SEQ_START_TOKEN) {
+		seq_printf(seq, "%-16s %-17s %4s %20s %20s %20s %5s\n",
+			   "DEV", "MAC", "VLAN", "PACKETS", "BYTES", "LASTUSE", "FLAGS");
+		return 0;
+	}
+
+	entry = list_entry(v, struct mlx5_esw_bridge_fdb_entry, list);
+	mlx5_fc_query_cached_raw(entry->ingress_counter, &bytes, &packets, &lastuse);
+	seq_printf(seq, "%-16s %-17pM %4d %20llu %20llu %20llu %#5x\n",
+		   entry->dev->name, entry->key.addr, entry->key.vid, packets, bytes, lastuse,
+		   entry->flags);
+	return 0;
+}
+
+void mlx5_esw_bridge_debugfs_init(struct net_device *br_netdev, struct mlx5_esw_bridge *bridge)
+{
+	if (!bridge->br_offloads->debugfs_root)
+		return;
+
+	bridge->debugfs_dir = debugfs_create_dir(br_netdev->name,
+						 bridge->br_offloads->debugfs_root);
+	debugfs_create_file("fdb", 0444, bridge->debugfs_dir, bridge,
+			    &mlx5_esw_bridge_debugfs_fops);
+}
+
+void mlx5_esw_bridge_debugfs_cleanup(struct mlx5_esw_bridge *bridge)
+{
+	debugfs_remove_recursive(bridge->debugfs_dir);
+	bridge->debugfs_dir = NULL;
+}
+
+void mlx5_esw_bridge_debugfs_offloads_init(struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	if (!br_offloads->esw->debugfs_root)
+		return;
+
+	br_offloads->debugfs_root = debugfs_create_dir("bridge", br_offloads->esw->debugfs_root);
+}
+
+void mlx5_esw_bridge_debugfs_offloads_cleanup(struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	debugfs_remove_recursive(br_offloads->debugfs_root);
+	br_offloads->debugfs_root = NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
index c9595801bdb4..4911cc32161b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
@@ -199,6 +199,7 @@ struct mlx5_esw_bridge {
 	int refcnt;
 	struct list_head list;
 	struct mlx5_esw_bridge_offloads *br_offloads;
+	struct dentry *debugfs_dir;
 
 	struct list_head fdb_list;
 	struct rhashtable fdb_ht;
@@ -241,4 +242,9 @@ void mlx5_esw_bridge_port_mdb_vlan_flush(struct mlx5_esw_bridge_port *port,
 					 struct mlx5_esw_bridge_vlan *vlan);
 void mlx5_esw_bridge_mdb_flush(struct mlx5_esw_bridge *bridge);
 
+void mlx5_esw_bridge_debugfs_offloads_init(struct mlx5_esw_bridge_offloads *br_offloads);
+void mlx5_esw_bridge_debugfs_offloads_cleanup(struct mlx5_esw_bridge_offloads *br_offloads);
+void mlx5_esw_bridge_debugfs_init(struct net_device *br_netdev, struct mlx5_esw_bridge *bridge);
+void mlx5_esw_bridge_debugfs_cleanup(struct mlx5_esw_bridge *bridge);
+
 #endif /* _MLX5_ESW_BRIDGE_PRIVATE_ */
-- 
2.40.1



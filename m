Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195B43A2277
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhFJDA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229966AbhFJDAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2F8A61421;
        Thu, 10 Jun 2021 02:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293903;
        bh=S83HIPxLK+/Xf/RTRhcjFZ8q7nuaYLPgkYsyWcssyDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MaWWoVXqO6Uv/qzH/jW7Caw2gddLh+z9ul8rjsbZdA3+etnBJdzdNLGT4BTJnujCG
         wGOwYH6JLhV2T1hujLUpalvwMSTtSpq4P1ZFQdPukx2a+7vM1h+N8BHRceWxN6ZL9T
         51zO6IxQNyvwEEPA1ySLsrzn+dxB295nG347oBRzuiW0IQdnwb4im7z+ksSHcOfWYz
         tSB/bzJKzcgxuiECAdSp9Nwe4zKEgDadIXkKTtbsVwE1j/8BEix45ZWCWi302Wkta8
         7W7PMZHTMEd4HUqOHLk0k1APoQYyVLSN1oeVNM6Mar0FOEx/rUKVWLg7KfeP69z5Cw
         9H0WX+00eUYrQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/16] net/mlx5: Bridge, add offload infrastructure
Date:   Wed,  9 Jun 2021 19:58:07 -0700
Message-Id: <20210610025814.274607-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Create new files bridge.{c|h} in en/rep directory that implement bridge
interaction with representor netdevices and handle required
events/notifications, bridge.{c|h} in esw directory that implement all
necessary eswitch offloading infrastructure and works on vport/eswitch
level. Provide new kconfig MLX5_BRIDGE which is automatically selected when
both kernel bridge and mlx5 eswitch configs are enabled.

Provide basic infrastructure for bridge offloads:

- struct mlx5_esw_bridge_offloads - per-eswitch bridge offload structure
that encapsulates generic bridge-offloads data (notifier blocks, ingress
flow table/group, etc.) that is created/deleted on enable/disable eswitch
offloads.

- struct mlx5_esw_bridge - per-bridge structure that encapsulates
per-bridge data (reference counter, FDB, egress flow table/group, etc.)
that is created when first eswitch represetor is attached to new bridge and
deleted when last representor is removed from the bridge as a result of
NETDEV_CHANGEUPPER event.

The bridge tables are created with new priority FDB_BR_OFFLOAD in FDB
namespace. The new priority is between tc-miss and slow path priorities.
Priority consist of two levels: the ingress table that is global per
eswitch and matches incoming packets by src_mac/vid and redirects them to
next level (egress table) that is chosen according to ingress port bridge
membership and matches on dst_mac/vid in order to redirect packet to vport
according to the following diagram:

                +
                |
      +---------v----------+
      |                    |
      |   FDB_TC_OFFLOAD   |
      |                    |
      +---------+----------+
                |
                |
      +---------v----------+
      |                    |
      |   FDB_FT_OFFLOAD   |
      |                    |
      +---------+----------+
                |
                |
      +---------v----------+
      |                    |
      |    FDB_TC_MISS     |
      |                    |
      +---------+----------+
                |
+--------------------------------------+
|               |                      |
|        +------+                      |
|        |                             |
| +------v--------+   FDB_BR_OFFLOAD   |
| | INGRESS_TABLE |                    |
| +------+---+----+                    |
|        |   |      match              |
|        |   +---------+               |
|        |             |               |    +-------+
|        |     +-------v-------+ match |    |       |
|        |     | EGRESS_TABLE  +------------> vport |
|        |     +-------+-------+       |    |       |
|        |             |               |    +-------+
|        |    miss     |               |
|        +------+------+               |
|               |                      |
+--------------------------------------+
                |
                |
      +---------v----------+
      |                    |
      |   FDB_SLOW_PATH    |
      |                    |
      +---------+----------+
                |
                v

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  10 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   1 +
 .../mellanox/mlx5/core/en/rep/bridge.c        | 108 ++++++
 .../mellanox/mlx5/core/en/rep/bridge.h        |  21 ++
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   3 +
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 354 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  |  30 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   6 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   6 +
 include/linux/mlx5/fs.h                       |   1 +
 10 files changed, 540 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 461a43f338e6..d62f90aedade 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -79,6 +79,16 @@ config MLX5_ESWITCH
 	        Legacy SRIOV mode (L2 mac vlan steering based).
 	        Switchdev mode (eswitch offloads).
 
+config MLX5_BRIDGE
+	bool
+	depends on MLX5_ESWITCH && BRIDGE
+	default y
+	help
+	  mlx5 ConnectX offloads support for Ethernet Bridging (BRIDGE).
+	  Enable adding representors of mlx5 uplink and VF ports to Bridge and
+	  offloading rules for traffic between such ports. Supports VLANs (trunk and
+	  access modes).
+
 config MLX5_CLS_ACT
 	bool "MLX5 TC classifier action support"
 	depends on MLX5_ESWITCH && NET_CLS_ACT
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 8dbdf1aef00f..b5072a3a2585 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -56,6 +56,7 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)   += esw/acl/helper.o \
 				      esw/acl/ingress_lgcy.o esw/acl/ingress_ofld.o \
 				      esw/devlink_port.o esw/vporttbl.o
 mlx5_core-$(CONFIG_MLX5_TC_SAMPLE) += esw/sample.o
+mlx5_core-$(CONFIG_MLX5_BRIDGE)    += esw/bridge.o en/rep/bridge.o
 
 mlx5_core-$(CONFIG_MLX5_MPFS)      += lib/mpfs.o
 mlx5_core-$(CONFIG_VXLAN)          += lib/vxlan.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
new file mode 100644
index 000000000000..de7a68488a9d
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#include <linux/netdevice.h>
+#include <net/netevent.h>
+#include <net/switchdev.h>
+#include "bridge.h"
+#include "esw/bridge.h"
+#include "en_rep.h"
+
+static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr)
+{
+	struct mlx5_esw_bridge_offloads *br_offloads = container_of(nb,
+								    struct mlx5_esw_bridge_offloads,
+								    netdev_nb);
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct netdev_notifier_changeupper_info *info = ptr;
+	struct netlink_ext_ack *extack;
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	struct net_device *upper;
+	struct mlx5e_priv *priv;
+	u16 vport_num;
+
+	if (!mlx5e_eswitch_rep(dev))
+		return 0;
+
+	upper = info->upper_dev;
+	if (!netif_is_bridge_master(upper))
+		return 0;
+
+	esw = br_offloads->esw;
+	priv = netdev_priv(dev);
+	if (esw != priv->mdev->priv.eswitch)
+		return 0;
+
+	rpriv = priv->ppriv;
+	vport_num = rpriv->rep->vport;
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+
+	return info->linking ?
+		mlx5_esw_bridge_vport_link(upper->ifindex, br_offloads, vport, extack) :
+		mlx5_esw_bridge_vport_unlink(upper->ifindex, br_offloads, vport, extack);
+}
+
+static int mlx5_esw_bridge_switchdev_port_event(struct notifier_block *nb,
+						unsigned long event, void *ptr)
+{
+	int err = 0;
+
+	switch (event) {
+	case NETDEV_PRECHANGEUPPER:
+		break;
+
+	case NETDEV_CHANGEUPPER:
+		err = mlx5_esw_bridge_port_changeupper(nb, ptr);
+		break;
+	}
+
+	return notifier_from_errno(err);
+}
+
+void mlx5e_rep_bridge_init(struct mlx5e_priv *priv)
+{
+	struct mlx5_esw_bridge_offloads *br_offloads;
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5_eswitch *esw =
+		mdev->priv.eswitch;
+	int err;
+
+	rtnl_lock();
+	br_offloads = mlx5_esw_bridge_init(esw);
+	rtnl_unlock();
+	if (IS_ERR(br_offloads)) {
+		esw_warn(mdev, "Failed to init esw bridge (err=%ld)\n", PTR_ERR(br_offloads));
+		return;
+	}
+
+	br_offloads->netdev_nb.notifier_call = mlx5_esw_bridge_switchdev_port_event;
+	err = register_netdevice_notifier(&br_offloads->netdev_nb);
+	if (err) {
+		esw_warn(mdev, "Failed to register bridge offloads netdevice notifier (err=%d)\n",
+			 err);
+		mlx5_esw_bridge_cleanup(esw);
+	}
+}
+
+void mlx5e_rep_bridge_cleanup(struct mlx5e_priv *priv)
+{
+	struct mlx5_esw_bridge_offloads *br_offloads;
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5_eswitch *esw =
+		mdev->priv.eswitch;
+
+	br_offloads = esw->br_offloads;
+	if (!br_offloads)
+		return;
+
+	unregister_netdevice_notifier(&br_offloads->netdev_nb);
+	rtnl_lock();
+	mlx5_esw_bridge_cleanup(esw);
+	rtnl_unlock();
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.h
new file mode 100644
index 000000000000..fbeb64242831
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#ifndef __MLX5_EN_REP_BRIDGE__
+#define __MLX5_EN_REP_BRIDGE__
+
+#include "en.h"
+
+#if IS_ENABLED(CONFIG_MLX5_BRIDGE)
+
+void mlx5e_rep_bridge_init(struct mlx5e_priv *priv);
+void mlx5e_rep_bridge_cleanup(struct mlx5e_priv *priv);
+
+#else /* CONFIG_MLX5_BRIDGE */
+
+static inline void mlx5e_rep_bridge_init(struct mlx5e_priv *priv) {}
+static inline void mlx5e_rep_bridge_cleanup(struct mlx5e_priv *priv) {}
+
+#endif /* CONFIG_MLX5_BRIDGE */
+
+#endif /* __MLX5_EN_REP_BRIDGE__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 40db54412041..8290e0086178 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -45,6 +45,7 @@
 #include "en_tc.h"
 #include "en/rep/tc.h"
 #include "en/rep/neigh.h"
+#include "en/rep/bridge.h"
 #include "en/devlink.h"
 #include "fs_core.h"
 #include "lib/mlx5.h"
@@ -981,6 +982,7 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 	mlx5e_dcbnl_initialize(priv);
 	mlx5e_dcbnl_init_app(priv);
 	mlx5e_rep_neigh_init(rpriv);
+	mlx5e_rep_bridge_init(priv);
 
 	netdev->wanted_features |= NETIF_F_HW_TC;
 
@@ -1002,6 +1004,7 @@ static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 	netif_device_detach(priv->netdev);
 	rtnl_unlock();
 
+	mlx5e_rep_bridge_cleanup(priv);
 	mlx5e_rep_neigh_cleanup(rpriv);
 	mlx5e_dcbnl_delete_app(priv);
 	mlx5_notifier_unregister(mdev, &priv->events_nb);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
new file mode 100644
index 000000000000..b503562f97d0
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -0,0 +1,354 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#include <linux/netdevice.h>
+#include <linux/list.h>
+#include <net/switchdev.h>
+#include "bridge.h"
+#include "eswitch.h"
+#include "fs_core.h"
+
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE 64000
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM 0
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO (MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE - 1)
+
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE 64000
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM 0
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO (MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE - 1)
+
+enum {
+	MLX5_ESW_BRIDGE_LEVEL_INGRESS_TABLE,
+	MLX5_ESW_BRIDGE_LEVEL_EGRESS_TABLE,
+};
+
+struct mlx5_esw_bridge {
+	int ifindex;
+	int refcnt;
+	struct list_head list;
+
+	struct mlx5_flow_table *egress_ft;
+	struct mlx5_flow_group *egress_mac_fg;
+};
+
+static struct mlx5_flow_table *
+mlx5_esw_bridge_table_create(int max_fte, u32 level, struct mlx5_eswitch *esw)
+{
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_core_dev *dev = esw->dev;
+	struct mlx5_flow_namespace *ns;
+	struct mlx5_flow_table *fdb;
+
+	ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_FDB);
+	if (!ns) {
+		esw_warn(dev, "Failed to get FDB namespace\n");
+		return ERR_PTR(-ENOENT);
+	}
+
+	ft_attr.max_fte = max_fte;
+	ft_attr.level = level;
+	ft_attr.prio = FDB_BR_OFFLOAD;
+	fdb = mlx5_create_flow_table(ns, &ft_attr);
+	if (IS_ERR(fdb))
+		esw_warn(dev, "Failed to create bridge FDB Table (err=%ld)\n", PTR_ERR(fdb));
+
+	return fdb;
+}
+
+static struct mlx5_flow_group *
+mlx5_esw_bridge_ingress_mac_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *ingress_ft)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *fg;
+	u32 *in, *match;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return ERR_PTR(-ENOMEM);
+
+	MLX5_SET(create_flow_group_in, in, match_criteria_enable,
+		 MLX5_MATCH_OUTER_HEADERS | MLX5_MATCH_MISC_PARAMETERS_2);
+	match = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.smac_47_16);
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.smac_15_0);
+
+	MLX5_SET(fte_match_param, match, misc_parameters_2.metadata_reg_c_0,
+		 mlx5_eswitch_get_vport_metadata_mask());
+
+	MLX5_SET(create_flow_group_in, in, start_flow_index,
+		 MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM);
+	MLX5_SET(create_flow_group_in, in, end_flow_index,
+		 MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO);
+
+	fg = mlx5_create_flow_group(ingress_ft, in);
+	if (IS_ERR(fg))
+		esw_warn(esw->dev,
+			 "Failed to create bridge ingress table MAC flow group (err=%ld)\n",
+			 PTR_ERR(fg));
+
+	kvfree(in);
+	return fg;
+}
+
+static struct mlx5_flow_group *
+mlx5_esw_bridge_egress_mac_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *egress_ft)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *fg;
+	u32 *in, *match;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return ERR_PTR(-ENOMEM);
+
+	MLX5_SET(create_flow_group_in, in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
+	match = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.dmac_47_16);
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.dmac_15_0);
+
+	MLX5_SET(create_flow_group_in, in, start_flow_index,
+		 MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM);
+	MLX5_SET(create_flow_group_in, in, end_flow_index,
+		 MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO);
+
+	fg = mlx5_create_flow_group(egress_ft, in);
+	if (IS_ERR(fg))
+		esw_warn(esw->dev,
+			 "Failed to create bridge egress table MAC flow group (err=%ld)\n",
+			 PTR_ERR(fg));
+	kvfree(in);
+	return fg;
+}
+
+static int
+mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	struct mlx5_flow_table *ingress_ft;
+	struct mlx5_flow_group *mac_fg;
+	int err;
+
+	ingress_ft = mlx5_esw_bridge_table_create(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE,
+						  MLX5_ESW_BRIDGE_LEVEL_INGRESS_TABLE,
+						  br_offloads->esw);
+	if (IS_ERR(ingress_ft))
+		return PTR_ERR(ingress_ft);
+
+	mac_fg = mlx5_esw_bridge_ingress_mac_fg_create(br_offloads->esw, ingress_ft);
+	if (IS_ERR(mac_fg)) {
+		err = PTR_ERR(mac_fg);
+		goto err_mac_fg;
+	}
+
+	br_offloads->ingress_ft = ingress_ft;
+	br_offloads->ingress_mac_fg = mac_fg;
+	return 0;
+
+err_mac_fg:
+	mlx5_destroy_flow_table(ingress_ft);
+	return err;
+}
+
+static void
+mlx5_esw_bridge_ingress_table_cleanup(struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	mlx5_destroy_flow_group(br_offloads->ingress_mac_fg);
+	br_offloads->ingress_mac_fg = NULL;
+	mlx5_destroy_flow_table(br_offloads->ingress_ft);
+	br_offloads->ingress_ft = NULL;
+}
+
+static int
+mlx5_esw_bridge_egress_table_init(struct mlx5_esw_bridge_offloads *br_offloads,
+				  struct mlx5_esw_bridge *bridge)
+{
+	struct mlx5_flow_table *egress_ft;
+	struct mlx5_flow_group *mac_fg;
+	int err;
+
+	egress_ft = mlx5_esw_bridge_table_create(MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE,
+						 MLX5_ESW_BRIDGE_LEVEL_EGRESS_TABLE,
+						 br_offloads->esw);
+	if (IS_ERR(egress_ft))
+		return PTR_ERR(egress_ft);
+
+	mac_fg = mlx5_esw_bridge_egress_mac_fg_create(br_offloads->esw, egress_ft);
+	if (IS_ERR(mac_fg)) {
+		err = PTR_ERR(mac_fg);
+		goto err_mac_fg;
+	}
+
+	bridge->egress_ft = egress_ft;
+	bridge->egress_mac_fg = mac_fg;
+	return 0;
+
+err_mac_fg:
+	mlx5_destroy_flow_table(egress_ft);
+	return err;
+}
+
+static void
+mlx5_esw_bridge_egress_table_cleanup(struct mlx5_esw_bridge *bridge)
+{
+	mlx5_destroy_flow_group(bridge->egress_mac_fg);
+	mlx5_destroy_flow_table(bridge->egress_ft);
+}
+
+static struct mlx5_esw_bridge *mlx5_esw_bridge_create(int ifindex,
+						      struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	struct mlx5_esw_bridge *bridge;
+	int err;
+
+	bridge = kvzalloc(sizeof(*bridge), GFP_KERNEL);
+	if (!bridge)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlx5_esw_bridge_egress_table_init(br_offloads, bridge);
+	if (err)
+		goto err_egress_tbl;
+
+	bridge->ifindex = ifindex;
+	bridge->refcnt = 1;
+	list_add(&bridge->list, &br_offloads->bridges);
+
+	return bridge;
+
+err_egress_tbl:
+	kvfree(bridge);
+	return ERR_PTR(err);
+}
+
+static void mlx5_esw_bridge_get(struct mlx5_esw_bridge *bridge)
+{
+	bridge->refcnt++;
+}
+
+static void mlx5_esw_bridge_put(struct mlx5_esw_bridge_offloads *br_offloads,
+				struct mlx5_esw_bridge *bridge)
+{
+	if (--bridge->refcnt)
+		return;
+
+	mlx5_esw_bridge_egress_table_cleanup(bridge);
+	list_del(&bridge->list);
+	kvfree(bridge);
+
+	if (list_empty(&br_offloads->bridges))
+		mlx5_esw_bridge_ingress_table_cleanup(br_offloads);
+}
+
+static struct mlx5_esw_bridge *
+mlx5_esw_bridge_lookup(int ifindex, struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	struct mlx5_esw_bridge *bridge;
+
+	ASSERT_RTNL();
+
+	list_for_each_entry(bridge, &br_offloads->bridges, list) {
+		if (bridge->ifindex == ifindex) {
+			mlx5_esw_bridge_get(bridge);
+			return bridge;
+		}
+	}
+
+	if (!br_offloads->ingress_ft) {
+		int err = mlx5_esw_bridge_ingress_table_init(br_offloads);
+
+		if (err)
+			return ERR_PTR(err);
+	}
+
+	bridge = mlx5_esw_bridge_create(ifindex, br_offloads);
+	if (IS_ERR(bridge) && list_empty(&br_offloads->bridges))
+		mlx5_esw_bridge_ingress_table_cleanup(br_offloads);
+	return bridge;
+}
+
+static int mlx5_esw_bridge_vport_init(struct mlx5_esw_bridge *bridge,
+				      struct mlx5_vport *vport)
+{
+	vport->bridge = bridge;
+	return 0;
+}
+
+static int mlx5_esw_bridge_vport_cleanup(struct mlx5_esw_bridge_offloads *br_offloads,
+					 struct mlx5_vport *vport)
+{
+	mlx5_esw_bridge_put(br_offloads, vport->bridge);
+	vport->bridge = NULL;
+	return 0;
+}
+
+int mlx5_esw_bridge_vport_link(int ifindex, struct mlx5_esw_bridge_offloads *br_offloads,
+			       struct mlx5_vport *vport, struct netlink_ext_ack *extack)
+{
+	struct mlx5_esw_bridge *bridge;
+
+	WARN_ON(vport->bridge);
+
+	bridge = mlx5_esw_bridge_lookup(ifindex, br_offloads);
+	if (IS_ERR(bridge)) {
+		NL_SET_ERR_MSG_MOD(extack, "Error checking for existing bridge with same ifindex");
+		return PTR_ERR(bridge);
+	}
+
+	return mlx5_esw_bridge_vport_init(bridge, vport);
+}
+
+int mlx5_esw_bridge_vport_unlink(int ifindex, struct mlx5_esw_bridge_offloads *br_offloads,
+				 struct mlx5_vport *vport, struct netlink_ext_ack *extack)
+{
+	if (!vport->bridge) {
+		NL_SET_ERR_MSG_MOD(extack, "Port is not attached to any bridge");
+		return -EINVAL;
+	}
+	if (vport->bridge->ifindex != ifindex) {
+		NL_SET_ERR_MSG_MOD(extack, "Port is attached to another bridge");
+		return -EINVAL;
+	}
+
+	return mlx5_esw_bridge_vport_cleanup(br_offloads, vport);
+}
+
+static void mlx5_esw_bridge_flush(struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	struct mlx5_eswitch *esw = br_offloads->esw;
+	struct mlx5_vport *vport;
+	unsigned long i;
+
+	mlx5_esw_for_each_vport(esw, i, vport)
+		if (vport->bridge)
+			mlx5_esw_bridge_vport_cleanup(br_offloads, vport);
+
+	WARN_ONCE(!list_empty(&br_offloads->bridges),
+		  "Cleaning up bridge offloads while still having bridges attached\n");
+}
+
+struct mlx5_esw_bridge_offloads *mlx5_esw_bridge_init(struct mlx5_eswitch *esw)
+{
+	struct mlx5_esw_bridge_offloads *br_offloads;
+
+	br_offloads = kvzalloc(sizeof(*br_offloads), GFP_KERNEL);
+	if (!br_offloads)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&br_offloads->bridges);
+	br_offloads->esw = esw;
+	esw->br_offloads = br_offloads;
+
+	return br_offloads;
+}
+
+void mlx5_esw_bridge_cleanup(struct mlx5_eswitch *esw)
+{
+	struct mlx5_esw_bridge_offloads *br_offloads = esw->br_offloads;
+
+	if (!br_offloads)
+		return;
+
+	mlx5_esw_bridge_flush(br_offloads);
+
+	esw->br_offloads = NULL;
+	kvfree(br_offloads);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
new file mode 100644
index 000000000000..319b6f1db0ba
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#ifndef __MLX5_ESW_BRIDGE_H__
+#define __MLX5_ESW_BRIDGE_H__
+
+#include <linux/notifier.h>
+#include <linux/list.h>
+#include "eswitch.h"
+
+struct mlx5_flow_table;
+struct mlx5_flow_group;
+
+struct mlx5_esw_bridge_offloads {
+	struct mlx5_eswitch *esw;
+	struct list_head bridges;
+	struct notifier_block netdev_nb;
+
+	struct mlx5_flow_table *ingress_ft;
+	struct mlx5_flow_group *ingress_mac_fg;
+};
+
+struct mlx5_esw_bridge_offloads *mlx5_esw_bridge_init(struct mlx5_eswitch *esw);
+void mlx5_esw_bridge_cleanup(struct mlx5_eswitch *esw);
+int mlx5_esw_bridge_vport_link(int ifindex, struct mlx5_esw_bridge_offloads *br_offloads,
+			       struct mlx5_vport *vport, struct netlink_ext_ack *extack);
+int mlx5_esw_bridge_vport_unlink(int ifindex, struct mlx5_esw_bridge_offloads *br_offloads,
+				 struct mlx5_vport *vport, struct netlink_ext_ack *extack);
+
+#endif /* __MLX5_ESW_BRIDGE_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 55404eabff39..48cac5bf606d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -150,6 +150,8 @@ enum mlx5_eswitch_vport_event {
 	MLX5_VPORT_PROMISC_CHANGE = BIT(3),
 };
 
+struct mlx5_esw_bridge;
+
 struct mlx5_vport {
 	struct mlx5_core_dev    *dev;
 	struct hlist_head       uc_list[MLX5_L2_ADDR_HASH_SIZE];
@@ -178,6 +180,7 @@ struct mlx5_vport {
 	enum mlx5_eswitch_vport_event enabled_events;
 	int index;
 	struct devlink_port *dl_port;
+	struct mlx5_esw_bridge *bridge;
 };
 
 struct mlx5_esw_indir_table;
@@ -271,6 +274,8 @@ enum {
 	MLX5_ESWITCH_REG_C1_LOOPBACK_ENABLED = BIT(1),
 };
 
+struct mlx5_esw_bridge_offloads;
+
 struct mlx5_eswitch {
 	struct mlx5_core_dev    *dev;
 	struct mlx5_nb          nb;
@@ -300,6 +305,7 @@ struct mlx5_eswitch {
 		u32             root_tsar_id;
 	} qos;
 
+	struct mlx5_esw_bridge_offloads *br_offloads;
 	struct mlx5_esw_offload offloads;
 	int                     mode;
 	u16                     manager_vport;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index fc70c4ed8469..fc37ac9eab12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2786,6 +2786,12 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 		goto out_err;
 	}
 
+	maj_prio = fs_create_prio(&steering->fdb_root_ns->ns, FDB_BR_OFFLOAD, 2);
+	if (IS_ERR(maj_prio)) {
+		err = PTR_ERR(maj_prio);
+		goto out_err;
+	}
+
 	maj_prio = fs_create_prio(&steering->fdb_root_ns->ns, FDB_SLOW_PATH, 1);
 	if (IS_ERR(maj_prio)) {
 		err = PTR_ERR(maj_prio);
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 271f2f4d6b60..77746f7e35b8 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -88,6 +88,7 @@ enum {
 	FDB_TC_OFFLOAD,
 	FDB_FT_OFFLOAD,
 	FDB_TC_MISS,
+	FDB_BR_OFFLOAD,
 	FDB_SLOW_PATH,
 	FDB_PER_VPORT,
 };
-- 
2.31.1


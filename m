Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A8A432C31
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhJSDXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:23:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231970AbhJSDXF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 23:23:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0FDE61356;
        Tue, 19 Oct 2021 03:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634613653;
        bh=pu8QyZjNZ4427LbRtGLY5TlO84pt075uPe6TWyU18IM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOceSBmTBgTGGmGXKfmPyFeGf2TSV+tT4e8+L4mhNf2pAd2EXow17jAe8CFvSbhwp
         +D9Bp0n57p4wfyN2RnaPm6LKDyvNdc2oTLbC7+WlNCrRkn4zSBqO7fMMnsFGjdgqTW
         LcrcGNJBP853eda5s+RNef2Fa5gz2VD6LDa8jFmsE2asSD+A9wuafIp91sL7/y3+Rn
         56syhBoxZDpEycEIbfCy65LngbgXEiwwutPX3pilLAoVfWqhsz/YcvmBGsjdet/B3w
         w0x+ewCOv7lnrqlaBofrTkiFP0TNdRoyjMLzsx+zzfJzzVH2USP/Op33V9p65pcqXO
         Q5p/VhyWuMSrg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/13] net/mlx5: Lag, add support to create definers for LAG
Date:   Mon, 18 Oct 2021 20:20:42 -0700
Message-Id: <20211019032047.55660-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019032047.55660-1-saeed@kernel.org>
References: <20211019032047.55660-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Every definer will consist of a flow table with a single hash group
with exactly two flow table entries, one for each device port.
The destination of these entries is the uplink vport according to the
port state and hash policy.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |   1 +
 .../mellanox/mlx5/core/lag/port_sel.c         | 203 ++++++++++++++++++
 .../mellanox/mlx5/core/lag/port_sel.h         |  13 ++
 4 files changed, 220 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index b37724fc5387..17baa254f9ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -588,8 +588,10 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	if (!(bond_status & 0x3))
 		return 0;
 
-	if (lag_upper_info)
+	if (lag_upper_info) {
 		tracker->tx_type = lag_upper_info->tx_type;
+		tracker->hash_type = lag_upper_info->hash_type;
+	}
 
 	/* Determine bonding status:
 	 * A device is considered bonded if both its physical ports are slaves
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 670061e60d89..f0e8b3412c13 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -33,6 +33,7 @@ struct lag_tracker {
 	enum   netdev_lag_tx_type           tx_type;
 	struct netdev_lag_lower_state_info  netdev_state[MLX5_MAX_PORTS];
 	unsigned int is_bonded:1;
+	enum netdev_lag_hash hash_type;
 };
 
 /* LAG data of a ConnectX card.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
index 6095f1049bdb..06bc7c7dbb6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
@@ -4,6 +4,95 @@
 #include <linux/netdevice.h>
 #include "lag.h"
 
+enum {
+	MLX5_LAG_FT_LEVEL_DEFINER,
+};
+
+static struct mlx5_flow_group *
+mlx5_create_hash_flow_group(struct mlx5_flow_table *ft,
+			    struct mlx5_flow_definer *definer)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *fg;
+	u32 *in;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return ERR_PTR(-ENOMEM);
+
+	MLX5_SET(create_flow_group_in, in, match_definer_id,
+		 mlx5_get_match_definer_id(definer));
+	MLX5_SET(create_flow_group_in, in, start_flow_index, 0);
+	MLX5_SET(create_flow_group_in, in, end_flow_index, MLX5_MAX_PORTS - 1);
+	MLX5_SET(create_flow_group_in, in, group_type,
+		 MLX5_CREATE_FLOW_GROUP_IN_GROUP_TYPE_HASH_SPLIT);
+
+	fg = mlx5_create_flow_group(ft, in);
+	kvfree(in);
+	return fg;
+}
+
+static int mlx5_lag_create_port_sel_table(struct mlx5_lag *ldev,
+					  struct mlx5_lag_definer *lag_definer,
+					  u8 port1, u8 port2)
+{
+	struct mlx5_core_dev *dev = ldev->pf[MLX5_LAG_P1].dev;
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_destination dest = {};
+	MLX5_DECLARE_FLOW_ACT(flow_act);
+	struct mlx5_flow_namespace *ns;
+	int err, i;
+
+	ft_attr.max_fte = MLX5_MAX_PORTS;
+	ft_attr.level = MLX5_LAG_FT_LEVEL_DEFINER;
+
+	ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_PORT_SEL);
+	if (!ns) {
+		mlx5_core_warn(dev, "Failed to get port selection namespace\n");
+		return -EOPNOTSUPP;
+	}
+
+	lag_definer->ft = mlx5_create_flow_table(ns, &ft_attr);
+	if (IS_ERR(lag_definer->ft)) {
+		mlx5_core_warn(dev, "Failed to create port selection table\n");
+		return PTR_ERR(lag_definer->ft);
+	}
+
+	lag_definer->fg = mlx5_create_hash_flow_group(lag_definer->ft,
+						      lag_definer->definer);
+	if (IS_ERR(lag_definer->fg)) {
+		err = PTR_ERR(lag_definer->fg);
+		goto destroy_ft;
+	}
+
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_UPLINK;
+	dest.vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
+	flow_act.flags |= FLOW_ACT_NO_APPEND;
+	for (i = 0; i < MLX5_MAX_PORTS; i++) {
+		u8 affinity = i == 0 ? port1 : port2;
+
+		dest.vport.vhca_id = MLX5_CAP_GEN(ldev->pf[affinity - 1].dev,
+						  vhca_id);
+		lag_definer->rules[i] = mlx5_add_flow_rules(lag_definer->ft,
+							    NULL, &flow_act,
+							    &dest, 1);
+		if (IS_ERR(lag_definer->rules[i])) {
+			err = PTR_ERR(lag_definer->rules[i]);
+			while (i--)
+				mlx5_del_flow_rules(lag_definer->rules[i]);
+			goto destroy_fg;
+		}
+	}
+
+	return 0;
+
+destroy_fg:
+	mlx5_destroy_flow_group(lag_definer->fg);
+destroy_ft:
+	mlx5_destroy_flow_table(lag_definer->ft);
+	return err;
+}
+
 static int mlx5_lag_set_definer_inner(u32 *match_definer_mask,
 				      enum mlx5_traffic_types tt)
 {
@@ -186,6 +275,120 @@ static int mlx5_lag_set_definer(u32 *match_definer_mask,
 	return format_id;
 }
 
+static struct mlx5_lag_definer *
+mlx5_lag_create_definer(struct mlx5_lag *ldev, enum netdev_lag_hash hash,
+			enum mlx5_traffic_types tt, bool tunnel, u8 port1,
+			u8 port2)
+{
+	struct mlx5_core_dev *dev = ldev->pf[MLX5_LAG_P1].dev;
+	struct mlx5_lag_definer *lag_definer;
+	u32 *match_definer_mask;
+	int format_id, err;
+
+	lag_definer = kzalloc(sizeof(*lag_definer), GFP_KERNEL);
+	if (!lag_definer)
+		return ERR_PTR(ENOMEM);
+
+	match_definer_mask = kvzalloc(MLX5_FLD_SZ_BYTES(match_definer,
+							match_mask),
+				      GFP_KERNEL);
+	if (!match_definer_mask) {
+		err = -ENOMEM;
+		goto free_lag_definer;
+	}
+
+	format_id = mlx5_lag_set_definer(match_definer_mask, tt, tunnel, hash);
+	lag_definer->definer =
+		mlx5_create_match_definer(dev, MLX5_FLOW_NAMESPACE_PORT_SEL,
+					  format_id, match_definer_mask);
+	if (IS_ERR(lag_definer->definer)) {
+		err = PTR_ERR(lag_definer->definer);
+		goto free_mask;
+	}
+
+	err = mlx5_lag_create_port_sel_table(ldev, lag_definer, port1, port2);
+	if (err)
+		goto destroy_match_definer;
+
+	kvfree(match_definer_mask);
+
+	return lag_definer;
+
+destroy_match_definer:
+	mlx5_destroy_match_definer(dev, lag_definer->definer);
+free_mask:
+	kvfree(match_definer_mask);
+free_lag_definer:
+	kfree(lag_definer);
+	return ERR_PTR(err);
+}
+
+static void mlx5_lag_destroy_definer(struct mlx5_lag *ldev,
+				     struct mlx5_lag_definer *lag_definer)
+{
+	struct mlx5_core_dev *dev = ldev->pf[MLX5_LAG_P1].dev;
+	int i;
+
+	for (i = 0; i < MLX5_MAX_PORTS; i++)
+		mlx5_del_flow_rules(lag_definer->rules[i]);
+	mlx5_destroy_flow_group(lag_definer->fg);
+	mlx5_destroy_flow_table(lag_definer->ft);
+	mlx5_destroy_match_definer(dev, lag_definer->definer);
+	kfree(lag_definer);
+}
+
+static void mlx5_lag_destroy_definers(struct mlx5_lag *ldev)
+{
+	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
+	int tt;
+
+	for_each_set_bit(tt, port_sel->tt_map, MLX5_NUM_TT) {
+		if (port_sel->outer.definers[tt])
+			mlx5_lag_destroy_definer(ldev,
+						 port_sel->outer.definers[tt]);
+		if (port_sel->inner.definers[tt])
+			mlx5_lag_destroy_definer(ldev,
+						 port_sel->inner.definers[tt]);
+	}
+}
+
+static int mlx5_lag_create_definers(struct mlx5_lag *ldev,
+				    enum netdev_lag_hash hash_type,
+				    u8 port1, u8 port2)
+{
+	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
+	struct mlx5_lag_definer *lag_definer;
+	int tt, err;
+
+	for_each_set_bit(tt, port_sel->tt_map, MLX5_NUM_TT) {
+		lag_definer = mlx5_lag_create_definer(ldev, hash_type, tt,
+						      false, port1, port2);
+		if (IS_ERR(lag_definer)) {
+			err = PTR_ERR(lag_definer);
+			goto destroy_definers;
+		}
+		port_sel->outer.definers[tt] = lag_definer;
+
+		if (!port_sel->tunnel)
+			continue;
+
+		lag_definer =
+			mlx5_lag_create_definer(ldev, hash_type, tt,
+						true, port1, port2);
+		if (IS_ERR(lag_definer)) {
+			err = PTR_ERR(lag_definer);
+			goto destroy_definers;
+		}
+		port_sel->inner.definers[tt] = lag_definer;
+	}
+
+	return 0;
+
+destroy_definers:
+	mlx5_lag_destroy_definers(ldev);
+	return err;
+}
+
 static void set_tt_map(struct mlx5_lag_port_sel *port_sel,
 		       enum netdev_lag_hash hash)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
index c55736d2484d..1b9e2130a0a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
@@ -6,9 +6,22 @@
 
 #include "lib/fs_ttc.h"
 
+struct mlx5_lag_definer {
+	struct mlx5_flow_definer *definer;
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_group *fg;
+	struct mlx5_flow_handle *rules[MLX5_MAX_PORTS];
+};
+
+struct mlx5_lag_ttc {
+	struct mlx5_lag_definer *definers[MLX5_NUM_TT];
+};
+
 struct mlx5_lag_port_sel {
 	DECLARE_BITMAP(tt_map, MLX5_NUM_TT);
 	bool   tunnel;
+	struct mlx5_lag_ttc outer;
+	struct mlx5_lag_ttc inner;
 };
 
 #endif /* __MLX5_LAG_FS_H__ */
-- 
2.31.1


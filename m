Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF392432C37
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbhJSDXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:23:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232086AbhJSDXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 23:23:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E15BE6135A;
        Tue, 19 Oct 2021 03:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634613654;
        bh=o/ObgCeV1qf+Y+fu4skUp+dKcXpnZ7rq12ouf2KR7No=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W//FEK8wPtptiR82oP08ymEnXbIvJIrOTQO5m7CpnyFqgYC2RnWWdiKUisARyQ5MP
         mv8Gej2IA+5WVybWpDD6cw3mJmMNUCXLAwUZPvw025FpXnmWHGOwTS3OtTXRGuMYHc
         dpxVQV5DR648aBXOeWN5zABcUg29zsFb1hlW+y08iGjl3CDVCXI0sjWBgz3KpC8fOg
         I7i7re4aT7n4qMb630z+PftdRO4mfvbOKuBuRxO38e5OyjNcAFknrQMtI3hweBbI9O
         KUAZdSlK381GEdfP7mRE7YGWZ9DZLr/Y8Vu2bESUXsp/d3sx7/yhonHF6lY34vY+52
         1zQwEyWsPvEgw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/13] net/mlx5: Lag, add support to create/destroy/modify port selection
Date:   Mon, 18 Oct 2021 20:20:44 -0700
Message-Id: <20211019032047.55660-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019032047.55660-1-saeed@kernel.org>
References: <20211019032047.55660-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Add create function, build the steering tables, TTC and definers
according to the LAG hash type.

The destroy function, destroys all the steering components.

The modify functions is used when the bond mapping changes and it
iterates over all the rules in the definers and modifies them to steer
the packet to the relevant active ports.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../mellanox/mlx5/core/lag/port_sel.c         | 98 +++++++++++++++++++
 .../mellanox/mlx5/core/lag/port_sel.h         | 24 +++++
 3 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index fb123e26927d..bdb271b604d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -37,7 +37,7 @@ mlx5_core-$(CONFIG_MLX5_EN_ARFS)     += en_arfs.o
 mlx5_core-$(CONFIG_MLX5_EN_RXNFC)    += en_fs_ethtool.o
 mlx5_core-$(CONFIG_MLX5_CORE_EN_DCB) += en_dcbnl.o en/port_buffer.o
 mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) += en/hv_vhca_stats.o
-mlx5_core-$(CONFIG_MLX5_ESWITCH)     += lag/mp.o lib/geneve.o lib/port_tun.o \
+mlx5_core-$(CONFIG_MLX5_ESWITCH)     += lag/mp.o lag/port_sel.o lib/geneve.o lib/port_tun.o \
 					en_rep.o en/rep/bond.o en/mod_hdr.o \
 					en/mapping.o
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
index a855b9e86791..adc836b3d857 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
@@ -511,3 +511,101 @@ static int mlx5_lag_create_inner_ttc_table(struct mlx5_lag *ldev)
 
 	return 0;
 }
+
+int mlx5_lag_port_sel_create(struct mlx5_lag *ldev,
+			     enum netdev_lag_hash hash_type, u8 port1, u8 port2)
+{
+	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
+	int err;
+
+	set_tt_map(port_sel, hash_type);
+	err = mlx5_lag_create_definers(ldev, hash_type, port1, port2);
+	if (err)
+		return err;
+
+	if (port_sel->tunnel) {
+		err = mlx5_lag_create_inner_ttc_table(ldev);
+		if (err)
+			goto destroy_definers;
+	}
+
+	err = mlx5_lag_create_ttc_table(ldev);
+	if (err)
+		goto destroy_inner;
+
+	return 0;
+
+destroy_inner:
+	if (port_sel->tunnel)
+		mlx5_destroy_ttc_table(port_sel->inner.ttc);
+destroy_definers:
+	mlx5_lag_destroy_definers(ldev);
+	return err;
+}
+
+static int
+mlx5_lag_modify_definers_destinations(struct mlx5_lag *ldev,
+				      struct mlx5_lag_definer **definers,
+				      u8 port1, u8 port2)
+{
+	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
+	struct mlx5_flow_destination dest = {};
+	int err;
+	int tt;
+
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_UPLINK;
+	dest.vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
+
+	for_each_set_bit(tt, port_sel->tt_map, MLX5_NUM_TT) {
+		struct mlx5_flow_handle **rules = definers[tt]->rules;
+
+		if (ldev->v2p_map[MLX5_LAG_P1] != port1) {
+			dest.vport.vhca_id =
+				MLX5_CAP_GEN(ldev->pf[port1 - 1].dev, vhca_id);
+			err = mlx5_modify_rule_destination(rules[MLX5_LAG_P1],
+							   &dest, NULL);
+			if (err)
+				return err;
+		}
+
+		if (ldev->v2p_map[MLX5_LAG_P2] != port2) {
+			dest.vport.vhca_id =
+				MLX5_CAP_GEN(ldev->pf[port2 - 1].dev, vhca_id);
+			err = mlx5_modify_rule_destination(rules[MLX5_LAG_P2],
+							   &dest, NULL);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
+int mlx5_lag_port_sel_modify(struct mlx5_lag *ldev, u8 port1, u8 port2)
+{
+	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
+	int err;
+
+	err = mlx5_lag_modify_definers_destinations(ldev,
+						    port_sel->outer.definers,
+						    port1, port2);
+	if (err)
+		return err;
+
+	if (!port_sel->tunnel)
+		return 0;
+
+	return mlx5_lag_modify_definers_destinations(ldev,
+						     port_sel->inner.definers,
+						     port1, port2);
+}
+
+void mlx5_lag_port_sel_destroy(struct mlx5_lag *ldev)
+{
+	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
+
+	mlx5_destroy_ttc_table(port_sel->outer.ttc);
+	if (port_sel->tunnel)
+		mlx5_destroy_ttc_table(port_sel->inner.ttc);
+	mlx5_lag_destroy_definers(ldev);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
index 045dceec0fab..6d15b28a42fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
@@ -25,4 +25,28 @@ struct mlx5_lag_port_sel {
 	struct mlx5_lag_ttc inner;
 };
 
+#ifdef CONFIG_MLX5_ESWITCH
+
+int mlx5_lag_port_sel_modify(struct mlx5_lag *ldev, u8 port1, u8 port2);
+void mlx5_lag_port_sel_destroy(struct mlx5_lag *ldev);
+int mlx5_lag_port_sel_create(struct mlx5_lag *ldev,
+			     enum netdev_lag_hash hash_type, u8 port1,
+			     u8 port2);
+
+#else /* CONFIG_MLX5_ESWITCH */
+static inline int mlx5_lag_port_sel_create(struct mlx5_lag *ldev,
+					   enum netdev_lag_hash hash_type,
+					   u8 port1, u8 port2)
+{
+	return 0;
+}
+
+static inline int mlx5_lag_port_sel_modify(struct mlx5_lag *ldev, u8 port1,
+					   u8 port2)
+{
+	return 0;
+}
+
+static inline void mlx5_lag_port_sel_destroy(struct mlx5_lag *ldev) {}
+#endif /* CONFIG_MLX5_ESWITCH */
 #endif /* __MLX5_LAG_FS_H__ */
-- 
2.31.1


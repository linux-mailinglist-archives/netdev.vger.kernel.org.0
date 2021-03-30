Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EBA34E024
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhC3E2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:28:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230257AbhC3E1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:27:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C54DA6196A;
        Tue, 30 Mar 2021 04:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617078468;
        bh=Wg0waRK+fKyOL2vdPI8i4YE/ETu2GR7RqwN1Z097agc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SolswcCbqSfqmj1GMMzlcWItmw52kdpYzbOPIf42Cwx7TLxDJgQE65sGu8L7Qrl8f
         3Vwo60Lh1Qvz3XVJCZmAtgdk9sx/6fnPbUET2fyWo2tSH7Eo/Mq1AbdL68s0EnsyYS
         WmHdp6oEMBF4lcuFWgpTqAbyB6JcoYnZ+tqpDLKog1XatBGYDMongMz+h25xwzaQbX
         xI0UG5E/fuJceJ1zxNitmNZLA2JDUkzMim2R6mSDtMTQR6/pToNJy7TuIGBuVKLVf9
         RCPkHMxlJJwAnmABdTcQj5/vS33TMpAi6wDY9sPaD9P91IEBscDKHW3wJfTqCHDxcl
         4BNXESXiYxx3g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/12] net/mlx5e: Introduce Flow Steering UDP API
Date:   Mon, 29 Mar 2021 21:27:37 -0700
Message-Id: <20210330042741.198601-9-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330042741.198601-1-saeed@kernel.org>
References: <20210330042741.198601-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add a new FS API which captures the UDP traffic from the traffic
classifier into a dedicated FS table. This API handles both UDP over
IPv4 and IPv6 in the same manner. The tables (one for UDPv4 and another
for UDPv6) consist of a group matching the UDP destination port and a
must-be-last group which contains a default rule redirecting the
unmatched packets back to the RSS logic.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   4 +
 .../mellanox/mlx5/core/en/fs_tt_redirect.c    | 343 ++++++++++++++++++
 .../mellanox/mlx5/core/en/fs_tt_redirect.h    |  19 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   2 +-
 5 files changed, 368 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 8cb2625472c3..9cf7de72df52 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -27,7 +27,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
 		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/pool.o \
 		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o en/ptp.o \
-		en/qos.o en/trap.o
+		en/qos.o en/trap.o en/fs_tt_redirect.o
 
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 3dfec5943a33..496f5b9fe070 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -137,6 +137,7 @@ enum {
 	MLX5E_L2_FT_LEVEL,
 	MLX5E_TTC_FT_LEVEL,
 	MLX5E_INNER_TTC_FT_LEVEL,
+	MLX5E_FS_TT_UDP_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 #ifdef CONFIG_MLX5_EN_TLS
 	MLX5E_ACCEL_FS_TCP_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 #endif
@@ -241,6 +242,8 @@ static inline int mlx5e_arfs_disable(struct mlx5e_priv *priv) {	return -EOPNOTSU
 struct mlx5e_accel_fs_tcp;
 #endif
 
+struct mlx5e_fs_udp;
+
 struct mlx5e_flow_steering {
 	struct mlx5_flow_namespace      *ns;
 	struct mlx5_flow_namespace      *egress_ns;
@@ -259,6 +262,7 @@ struct mlx5e_flow_steering {
 #ifdef CONFIG_MLX5_EN_TLS
 	struct mlx5e_accel_fs_tcp      *accel_tcp;
 #endif
+	struct mlx5e_fs_udp            *udp;
 };
 
 struct ttc_params {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
new file mode 100644
index 000000000000..c37a7a7929c3
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
@@ -0,0 +1,343 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, Mellanox Technologies inc. All rights reserved. */
+
+#include <linux/netdevice.h>
+#include "en/fs_tt_redirect.h"
+#include "fs_core.h"
+
+enum fs_udp_type {
+	FS_IPV4_UDP,
+	FS_IPV6_UDP,
+	FS_UDP_NUM_TYPES,
+};
+
+struct mlx5e_fs_udp {
+	struct mlx5e_flow_table tables[FS_UDP_NUM_TYPES];
+	struct mlx5_flow_handle *default_rules[FS_UDP_NUM_TYPES];
+	int ref_cnt;
+};
+
+static char *fs_udp_type2str(enum fs_udp_type i)
+{
+	switch (i) {
+	case FS_IPV4_UDP:
+		return "UDP v4";
+	default: /* FS_IPV6_UDP */
+		return "UDP v6";
+	}
+}
+
+static enum mlx5e_traffic_types fs_udp2tt(enum fs_udp_type i)
+{
+	switch (i) {
+	case FS_IPV4_UDP:
+		return MLX5E_TT_IPV4_UDP;
+	default: /* FS_IPV6_UDP */
+		return MLX5E_TT_IPV6_UDP;
+	}
+}
+
+static enum fs_udp_type tt2fs_udp(enum mlx5e_traffic_types i)
+{
+	switch (i) {
+	case MLX5E_TT_IPV4_UDP:
+		return FS_IPV4_UDP;
+	case MLX5E_TT_IPV6_UDP:
+		return FS_IPV6_UDP;
+	default:
+		return FS_UDP_NUM_TYPES;
+	}
+}
+
+void mlx5e_fs_tt_redirect_del_rule(struct mlx5_flow_handle *rule)
+{
+	mlx5_del_flow_rules(rule);
+}
+
+static void fs_udp_set_dport_flow(struct mlx5_flow_spec *spec, enum fs_udp_type type,
+				  u16 udp_dport)
+{
+	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_protocol);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_protocol, IPPROTO_UDP);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_version);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_version,
+		 type == FS_IPV4_UDP ? 4 : 6);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.udp_dport);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.udp_dport, udp_dport);
+}
+
+struct mlx5_flow_handle *
+mlx5e_fs_tt_redirect_udp_add_rule(struct mlx5e_priv *priv,
+				  enum mlx5e_traffic_types ttc_type,
+				  u32 tir_num, u16 d_port)
+{
+	enum fs_udp_type type = tt2fs_udp(ttc_type);
+	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_table *ft = NULL;
+	MLX5_DECLARE_FLOW_ACT(flow_act);
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
+	struct mlx5e_fs_udp *fs_udp;
+	int err;
+
+	if (type == FS_UDP_NUM_TYPES)
+		return ERR_PTR(-EINVAL);
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return ERR_PTR(-ENOMEM);
+
+	fs_udp = priv->fs.udp;
+	ft = fs_udp->tables[type].t;
+
+	fs_udp_set_dport_flow(spec, type, d_port);
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
+	dest.tir_num = tir_num;
+
+	rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
+	kvfree(spec);
+
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		netdev_err(priv->netdev, "%s: add %s rule failed, err %d\n",
+			   __func__, fs_udp_type2str(type), err);
+	}
+	return rule;
+}
+
+static int fs_udp_add_default_rule(struct mlx5e_priv *priv, enum fs_udp_type type)
+{
+	struct mlx5e_flow_table *fs_udp_t;
+	struct mlx5_flow_destination dest;
+	MLX5_DECLARE_FLOW_ACT(flow_act);
+	struct mlx5_flow_handle *rule;
+	struct mlx5e_fs_udp *fs_udp;
+	int err;
+
+	fs_udp = priv->fs.udp;
+	fs_udp_t = &fs_udp->tables[type];
+
+	dest = mlx5e_ttc_get_default_dest(priv, fs_udp2tt(type));
+	rule = mlx5_add_flow_rules(fs_udp_t->t, NULL, &flow_act, &dest, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		netdev_err(priv->netdev,
+			   "%s: add default rule failed, fs type=%d, err %d\n",
+			   __func__, type, err);
+		return err;
+	}
+
+	fs_udp->default_rules[type] = rule;
+	return 0;
+}
+
+#define MLX5E_FS_UDP_NUM_GROUPS	(2)
+#define MLX5E_FS_UDP_GROUP1_SIZE	(BIT(16))
+#define MLX5E_FS_UDP_GROUP2_SIZE	(BIT(0))
+#define MLX5E_FS_UDP_TABLE_SIZE		(MLX5E_FS_UDP_GROUP1_SIZE +\
+					 MLX5E_FS_UDP_GROUP2_SIZE)
+static int fs_udp_create_groups(struct mlx5e_flow_table *ft, enum fs_udp_type type)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	void *outer_headers_c;
+	int ix = 0;
+	u32 *in;
+	int err;
+	u8 *mc;
+
+	ft->g = kcalloc(MLX5E_FS_UDP_NUM_GROUPS, sizeof(*ft->g), GFP_KERNEL);
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if  (!in || !ft->g) {
+		kfree(ft->g);
+		kvfree(in);
+		return -ENOMEM;
+	}
+
+	mc = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+	outer_headers_c = MLX5_ADDR_OF(fte_match_param, mc, outer_headers);
+	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, ip_protocol);
+	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, ip_version);
+
+	switch (type) {
+	case FS_IPV4_UDP:
+	case FS_IPV6_UDP:
+		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, udp_dport);
+		break;
+	default:
+		err = -EINVAL;
+		goto out;
+	}
+	/* Match on udp protocol, Ipv4/6 and dport */
+	MLX5_SET_CFG(in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix += MLX5E_FS_UDP_GROUP1_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
+	if (IS_ERR(ft->g[ft->num_groups]))
+		goto err;
+	ft->num_groups++;
+
+	/* Default Flow Group */
+	memset(in, 0, inlen);
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix += MLX5E_FS_UDP_GROUP2_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
+	if (IS_ERR(ft->g[ft->num_groups]))
+		goto err;
+	ft->num_groups++;
+
+	kvfree(in);
+	return 0;
+
+err:
+	err = PTR_ERR(ft->g[ft->num_groups]);
+	ft->g[ft->num_groups] = NULL;
+out:
+	kvfree(in);
+
+	return err;
+}
+
+static int fs_udp_create_table(struct mlx5e_priv *priv, enum fs_udp_type type)
+{
+	struct mlx5e_flow_table *ft = &priv->fs.udp->tables[type];
+	struct mlx5_flow_table_attr ft_attr = {};
+	int err;
+
+	ft->num_groups = 0;
+
+	ft_attr.max_fte = MLX5E_FS_UDP_TABLE_SIZE;
+	ft_attr.level = MLX5E_FS_TT_UDP_FT_LEVEL;
+	ft_attr.prio = MLX5E_NIC_PRIO;
+
+	ft->t = mlx5_create_flow_table(priv->fs.ns, &ft_attr);
+	if (IS_ERR(ft->t)) {
+		err = PTR_ERR(ft->t);
+		ft->t = NULL;
+		return err;
+	}
+
+	netdev_dbg(priv->netdev, "Created fs %s table id %u level %u\n",
+		   fs_udp_type2str(type), ft->t->id, ft->t->level);
+
+	err = fs_udp_create_groups(ft, type);
+	if (err)
+		goto err;
+
+	err = fs_udp_add_default_rule(priv, type);
+	if (err)
+		goto err;
+
+	return 0;
+
+err:
+	mlx5e_destroy_flow_table(ft);
+	return err;
+}
+
+static void fs_udp_destroy_table(struct mlx5e_fs_udp *fs_udp, int i)
+{
+	if (IS_ERR_OR_NULL(fs_udp->tables[i].t))
+		return;
+
+	mlx5_del_flow_rules(fs_udp->default_rules[i]);
+	mlx5e_destroy_flow_table(&fs_udp->tables[i]);
+	fs_udp->tables[i].t = NULL;
+}
+
+static int fs_udp_disable(struct mlx5e_priv *priv)
+{
+	int err, i;
+
+	for (i = 0; i < FS_UDP_NUM_TYPES; i++) {
+		/* Modify ttc rules destination to point back to the indir TIRs */
+		err = mlx5e_ttc_fwd_default_dest(priv, fs_udp2tt(i));
+		if (err) {
+			netdev_err(priv->netdev,
+				   "%s: modify ttc[%d] default destination failed, err(%d)\n",
+				   __func__, fs_udp2tt(i), err);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int fs_udp_enable(struct mlx5e_priv *priv)
+{
+	struct mlx5_flow_destination dest = {};
+	int err, i;
+
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	for (i = 0; i < FS_UDP_NUM_TYPES; i++) {
+		dest.ft = priv->fs.udp->tables[i].t;
+
+		/* Modify ttc rules destination to point on the accel_fs FTs */
+		err = mlx5e_ttc_fwd_dest(priv, fs_udp2tt(i), &dest);
+		if (err) {
+			netdev_err(priv->netdev,
+				   "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
+				   __func__, fs_udp2tt(i), err);
+			return err;
+		}
+	}
+	return 0;
+}
+
+void mlx5e_fs_tt_redirect_udp_destroy(struct mlx5e_priv *priv)
+{
+	struct mlx5e_fs_udp *fs_udp = priv->fs.udp;
+	int i;
+
+	if (!fs_udp)
+		return;
+
+	if (--fs_udp->ref_cnt)
+		return;
+
+	fs_udp_disable(priv);
+
+	for (i = 0; i < FS_UDP_NUM_TYPES; i++)
+		fs_udp_destroy_table(fs_udp, i);
+
+	kfree(fs_udp);
+	priv->fs.udp = NULL;
+}
+
+int mlx5e_fs_tt_redirect_udp_create(struct mlx5e_priv *priv)
+{
+	int i, err;
+
+	if (priv->fs.udp) {
+		priv->fs.udp->ref_cnt++;
+		return 0;
+	}
+
+	priv->fs.udp = kzalloc(sizeof(*priv->fs.udp), GFP_KERNEL);
+	if (!priv->fs.udp)
+		return -ENOMEM;
+
+	for (i = 0; i < FS_UDP_NUM_TYPES; i++) {
+		err = fs_udp_create_table(priv, i);
+		if (err)
+			goto err_destroy_tables;
+	}
+
+	err = fs_udp_enable(priv);
+	if (err)
+		goto err_destroy_tables;
+
+	priv->fs.udp->ref_cnt = 1;
+
+	return 0;
+
+err_destroy_tables:
+	while (--i >= 0)
+		fs_udp_destroy_table(priv->fs.udp, i);
+
+	kfree(priv->fs.udp);
+	priv->fs.udp = NULL;
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.h
new file mode 100644
index 000000000000..b840d5cafb57
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#ifndef __MLX5E_FS_TT_REDIRECT_H__
+#define __MLX5E_FS_TT_REDIRECT_H__
+
+#include "en.h"
+#include "en/fs.h"
+
+void mlx5e_fs_tt_redirect_del_rule(struct mlx5_flow_handle *rule);
+
+/* UDP traffic type redirect */
+struct mlx5_flow_handle *
+mlx5e_fs_tt_redirect_udp_add_rule(struct mlx5e_priv *priv,
+				  enum mlx5e_traffic_types ttc_type,
+				  u32 tir_num, u16 d_port);
+void mlx5e_fs_tt_redirect_udp_destroy(struct mlx5e_priv *priv);
+int mlx5e_fs_tt_redirect_udp_create(struct mlx5e_priv *priv);
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index d2c0e61527ab..b9ebacdcbdfe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -105,7 +105,7 @@
 #define ETHTOOL_PRIO_NUM_LEVELS 1
 #define ETHTOOL_NUM_PRIOS 11
 #define ETHTOOL_MIN_LEVEL (KERNEL_MIN_LEVEL + ETHTOOL_NUM_PRIOS)
-/* Promiscuous, Vlan, mac, ttc, inner ttc, {aRFS/accel/{esp, esp_err}} */
+/* Promiscuous, Vlan, mac, ttc, inner ttc, {UDP/aRFS/accel/{esp, esp_err}} */
 #define KERNEL_NIC_PRIO_NUM_LEVELS 7
 #define KERNEL_NIC_NUM_PRIOS 1
 /* One more level for tc */
-- 
2.30.2


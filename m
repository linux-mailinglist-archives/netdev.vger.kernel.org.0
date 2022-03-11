Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC864D5C96
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347264AbiCKHmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347243AbiCKHlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:41:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E831C1B7608
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:40:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F66A61B0E
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0D3C340F5;
        Fri, 11 Mar 2022 07:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646984447;
        bh=00db200u/jtEM57e93BHyxAP5Fqtq9PyxrPTMo9lbPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1Ds9XTinAq13Ejbyk7xTpkU9AM2uW5vPlXR+eRIViXX4W9FA20A4zhXdXKA8nYRC
         05QfnFfiqFc+coyns2CBpkmzFB97cZ2vncbdZCJgs0TbbGXgQmWE51glXTP3bVqUKb
         iU8bm5E/SQI2+cKnZ3o1jgcqzFkYMgIhhh43ph7BGU/pkfzG4IFDI6RBq1b6Z+QQ+m
         oW5cLdmei/etiKPFeZ1Cm3/0fWdFqGMG6jU3/spf4nLWZ+YD4NI+WqtI2sTEYPKRPY
         Ku8aTvYNJkfxABhV2yT01H+Zt+O2J73xiDvCYCqTe6IHCA8PE1VOGNgMLtvIRhBC8k
         ZMdaKKuWTHYLw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5: CT: Add software steering ct flow steering provider
Date:   Thu, 10 Mar 2022 23:40:27 -0800
Message-Id: <20220311074031.645168-12-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220311074031.645168-1-saeed@kernel.org>
References: <20220311074031.645168-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

fs_core layer adds extra book keeping that is either unneeded for CT, or
unused by the underlying software steering, such as allocating FTEs and
FTE ids, saving the match key and mask, and autogroups management.
On top of that, direct steering has a translation layer (fs_dr) from PRM
commands to direct steering objects, for example, creating temporary
dr_action objects. This has a performance impact when dealing
with CT high insertion rate.

To use direct steering (smfs) directly for ct, add a tc ct fs smfs
implementation. Instead of dmfs autogroups, smfs ct fs uses one of 4
predefined dr matchers in CT and CT-NAT tables, for each combination
of tuple ethertype (ipv4/ipv6), and tuple ip_proto (udp/tcp) that
is currently used by nf flow table flow offload.

At rule insertions, validate the flow rule fits one of the predfined
matcher, and insert to it.

To fill the dr_actions of the rule efficiently, create the fwd to post_ct
tbl dr_action at fs init, the count dr_action at counter creation,
and re-use the already pre-allocated modify header dr_action.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   6 +-
 .../ethernet/mellanox/mlx5/core/en/tc/ct_fs.h |  27 +-
 .../mellanox/mlx5/core/en/tc/ct_fs_dmfs.c     |  17 +-
 .../mellanox/mlx5/core/en/tc/ct_fs_smfs.c     | 366 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  24 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |   2 +
 6 files changed, 435 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index f68a9db18698..4bc666714a35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -55,7 +55,11 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/a
 					en/tc/act/ct.o en/tc/act/sample.o en/tc/act/ptype.o \
 					en/tc/act/redirect_ingress.o
 
-mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o en/tc/ct_fs_dmfs.o
+ifneq ($(CONFIG_MLX5_TC_CT),)
+	mlx5_core-y			     += en/tc_ct.o en/tc/ct_fs_dmfs.o
+	mlx5_core-$(CONFIG_MLX5_SW_STEERING) += en/tc/ct_fs_smfs.o
+endif
+
 mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
 
 #
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs.h
index 0df12d490f2b..bb6b1a979ba1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs.h
@@ -7,18 +7,43 @@
 struct mlx5_ct_fs {
 	const struct net_device *netdev;
 	struct mlx5_core_dev *dev;
+
+	/* private data */
+	void *priv_data[];
 };
 
 struct mlx5_ct_fs_rule {
 };
 
 struct mlx5_ct_fs_ops {
+	int (*init)(struct mlx5_ct_fs *fs, struct mlx5_flow_table *ct,
+		    struct mlx5_flow_table *ct_nat, struct mlx5_flow_table *post_ct);
+	void (*destroy)(struct mlx5_ct_fs *fs);
+
 	struct mlx5_ct_fs_rule * (*ct_rule_add)(struct mlx5_ct_fs *fs,
 						struct mlx5_flow_spec *spec,
-						struct mlx5_flow_attr *attr);
+						struct mlx5_flow_attr *attr,
+						struct flow_rule *flow_rule);
 	void (*ct_rule_del)(struct mlx5_ct_fs *fs, struct mlx5_ct_fs_rule *fs_rule);
+
+	size_t priv_size;
 };
 
+static inline void *mlx5_ct_fs_priv(struct mlx5_ct_fs *fs)
+{
+	return &fs->priv_data;
+}
+
 struct mlx5_ct_fs_ops *mlx5_ct_fs_dmfs_ops_get(void);
 
+#if IS_ENABLED(CONFIG_MLX5_SW_STEERING)
+struct mlx5_ct_fs_ops *mlx5_ct_fs_smfs_ops_get(void);
+#else
+static inline struct mlx5_ct_fs_ops *
+mlx5_ct_fs_smfs_ops_get(void)
+{
+	return NULL;
+}
+#endif /* IS_ENABLED(CONFIG_MLX5_SW_STEERING) */
+
 #endif /* __MLX5_EN_TC_CT_FS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_dmfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_dmfs.c
index 94bd525ca62e..ae4f55be48ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_dmfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_dmfs.c
@@ -14,9 +14,21 @@ struct mlx5_ct_fs_dmfs_rule {
 	struct mlx5_flow_attr *attr;
 };
 
+static int
+mlx5_ct_fs_dmfs_init(struct mlx5_ct_fs *fs, struct mlx5_flow_table *ct,
+		     struct mlx5_flow_table *ct_nat, struct mlx5_flow_table *post_ct)
+{
+	return 0;
+}
+
+static void
+mlx5_ct_fs_dmfs_destroy(struct mlx5_ct_fs *fs)
+{
+}
+
 static struct mlx5_ct_fs_rule *
 mlx5_ct_fs_dmfs_ct_rule_add(struct mlx5_ct_fs *fs, struct mlx5_flow_spec *spec,
-			    struct mlx5_flow_attr *attr)
+			    struct mlx5_flow_attr *attr, struct flow_rule *flow_rule)
 {
 	struct mlx5e_priv *priv = netdev_priv(fs->netdev);
 	struct mlx5_ct_fs_dmfs_rule *dmfs_rule;
@@ -56,6 +68,9 @@ mlx5_ct_fs_dmfs_ct_rule_del(struct mlx5_ct_fs *fs, struct mlx5_ct_fs_rule *fs_ru
 static struct mlx5_ct_fs_ops dmfs_ops = {
 	.ct_rule_add = mlx5_ct_fs_dmfs_ct_rule_add,
 	.ct_rule_del = mlx5_ct_fs_dmfs_ct_rule_del,
+
+	.init = mlx5_ct_fs_dmfs_init,
+	.destroy = mlx5_ct_fs_dmfs_destroy,
 };
 
 struct mlx5_ct_fs_ops *mlx5_ct_fs_dmfs_ops_get(void)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c
new file mode 100644
index 000000000000..6da8b87c0475
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c
@@ -0,0 +1,366 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. */
+
+#include "en_tc.h"
+#include "en/tc_priv.h"
+#include "en/tc_ct.h"
+#include "en/tc/ct_fs.h"
+
+#include "lib/smfs.h"
+
+#define INIT_ERR_PREFIX "ct_fs_smfs init failed"
+#define ct_dbg(fmt, args...)\
+	netdev_dbg(fs->netdev, "ct_fs_smfs debug: " fmt "\n", ##args)
+#define MLX5_CT_TCP_FLAGS_MASK cpu_to_be16(be32_to_cpu(TCP_FLAG_RST | TCP_FLAG_FIN) >> 16)
+
+struct mlx5_ct_fs_smfs_matchers {
+	struct mlx5dr_matcher *ipv4_tcp;
+	struct mlx5dr_matcher *ipv4_udp;
+	struct mlx5dr_matcher *ipv6_tcp;
+	struct mlx5dr_matcher *ipv6_udp;
+};
+
+struct mlx5_ct_fs_smfs {
+	struct mlx5_ct_fs_smfs_matchers ct_matchers;
+	struct mlx5_ct_fs_smfs_matchers ct_matchers_nat;
+	struct mlx5dr_action *fwd_action;
+	struct mlx5_flow_table *ct_nat;
+};
+
+struct mlx5_ct_fs_smfs_rule {
+	struct mlx5_ct_fs_rule fs_rule;
+	struct mlx5dr_rule *rule;
+	struct mlx5dr_action *count_action;
+};
+
+static inline void
+mlx5_ct_fs_smfs_fill_mask(struct mlx5_ct_fs *fs, struct mlx5_flow_spec *spec, bool ipv4, bool tcp)
+{
+	void *headers_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, outer_headers);
+
+	if (likely(MLX5_CAP_FLOWTABLE_NIC_RX(fs->dev, ft_field_support.outer_ip_version)))
+		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ip_version);
+	else
+		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ethertype);
+
+	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ip_protocol);
+	if (likely(ipv4)) {
+		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c,
+				 src_ipv4_src_ipv6.ipv4_layout.ipv4);
+		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c,
+				 dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
+	} else {
+		memset(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
+				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+		       0xFF,
+		       MLX5_FLD_SZ_BYTES(fte_match_set_lyr_2_4,
+					 dst_ipv4_dst_ipv6.ipv6_layout.ipv6));
+		memset(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
+				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
+		       0xFF,
+		       MLX5_FLD_SZ_BYTES(fte_match_set_lyr_2_4,
+					 src_ipv4_src_ipv6.ipv6_layout.ipv6));
+	}
+
+	if (likely(tcp)) {
+		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, tcp_sport);
+		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, tcp_dport);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, tcp_flags,
+			 ntohs(MLX5_CT_TCP_FLAGS_MASK));
+	} else {
+		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, udp_sport);
+		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, udp_dport);
+	}
+
+	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG, 0, MLX5_CT_ZONE_MASK);
+}
+
+static struct mlx5dr_matcher *
+mlx5_ct_fs_smfs_matcher_create(struct mlx5_ct_fs *fs, struct mlx5dr_table *tbl, bool ipv4,
+			       bool tcp, u32 priority)
+{
+	struct mlx5dr_matcher *dr_matcher;
+	struct mlx5_flow_spec *spec;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return ERR_PTR(-ENOMEM);
+
+	mlx5_ct_fs_smfs_fill_mask(fs, spec, ipv4, tcp);
+	spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS_2 | MLX5_MATCH_OUTER_HEADERS;
+
+	dr_matcher = mlx5_smfs_matcher_create(tbl, priority, spec);
+	kfree(spec);
+	if (!dr_matcher)
+		return ERR_PTR(-EINVAL);
+
+	return dr_matcher;
+}
+
+static int
+mlx5_ct_fs_smfs_matchers_create(struct mlx5_ct_fs *fs, struct mlx5dr_table *tbl,
+				struct mlx5_ct_fs_smfs_matchers *ct_matchers)
+{
+	const struct net_device *netdev = fs->netdev;
+	u32 prio = 0;
+	int err;
+
+	ct_matchers->ipv4_tcp = mlx5_ct_fs_smfs_matcher_create(fs, tbl, true, true, prio);
+	if (IS_ERR(ct_matchers->ipv4_tcp)) {
+		err = PTR_ERR(ct_matchers->ipv4_tcp);
+		netdev_warn(netdev,
+			    "%s, failed to create ipv4 tcp matcher, err: %d\n",
+			    INIT_ERR_PREFIX, err);
+		return err;
+	}
+
+	++prio;
+	ct_matchers->ipv4_udp = mlx5_ct_fs_smfs_matcher_create(fs, tbl, true, false, prio);
+	if (IS_ERR(ct_matchers->ipv4_udp)) {
+		err = PTR_ERR(ct_matchers->ipv4_udp);
+		netdev_warn(netdev,
+			    "%s, failed to create ipv4 udp matcher, err: %d\n",
+			    INIT_ERR_PREFIX, err);
+		goto err_matcher_ipv4_udp;
+	}
+
+	++prio;
+	ct_matchers->ipv6_tcp = mlx5_ct_fs_smfs_matcher_create(fs, tbl, false, true, prio);
+	if (IS_ERR(ct_matchers->ipv6_tcp)) {
+		err = PTR_ERR(ct_matchers->ipv6_tcp);
+		netdev_warn(netdev,
+			    "%s, failed to create ipv6 tcp matcher, err: %d\n",
+			    INIT_ERR_PREFIX, err);
+		goto err_matcher_ipv6_tcp;
+	}
+
+	++prio;
+	ct_matchers->ipv6_udp = mlx5_ct_fs_smfs_matcher_create(fs, tbl, false, false, prio);
+	if (IS_ERR(ct_matchers->ipv6_udp)) {
+		err = PTR_ERR(ct_matchers->ipv6_udp);
+		netdev_warn(netdev,
+			    "%s, failed to create ipv6 tcp matcher, err: %d\n",
+			     INIT_ERR_PREFIX, err);
+		goto err_matcher_ipv6_udp;
+	}
+
+	return 0;
+
+err_matcher_ipv6_udp:
+	mlx5_smfs_matcher_destroy(ct_matchers->ipv6_tcp);
+err_matcher_ipv6_tcp:
+	mlx5_smfs_matcher_destroy(ct_matchers->ipv4_udp);
+err_matcher_ipv4_udp:
+	mlx5_smfs_matcher_destroy(ct_matchers->ipv4_tcp);
+	return 0;
+}
+
+static void
+mlx5_ct_fs_smfs_matchers_destroy(struct mlx5_ct_fs_smfs_matchers *ct_matchers)
+{
+	mlx5_smfs_matcher_destroy(ct_matchers->ipv6_udp);
+	mlx5_smfs_matcher_destroy(ct_matchers->ipv6_tcp);
+	mlx5_smfs_matcher_destroy(ct_matchers->ipv4_udp);
+	mlx5_smfs_matcher_destroy(ct_matchers->ipv4_tcp);
+}
+
+static int
+mlx5_ct_fs_smfs_init(struct mlx5_ct_fs *fs, struct mlx5_flow_table *ct,
+		     struct mlx5_flow_table *ct_nat, struct mlx5_flow_table *post_ct)
+{
+	struct mlx5dr_table *ct_tbl, *ct_nat_tbl, *post_ct_tbl;
+	struct mlx5_ct_fs_smfs *fs_smfs = mlx5_ct_fs_priv(fs);
+	int err;
+
+	post_ct_tbl = mlx5_smfs_table_get_from_fs_ft(post_ct);
+	ct_nat_tbl = mlx5_smfs_table_get_from_fs_ft(ct_nat);
+	ct_tbl = mlx5_smfs_table_get_from_fs_ft(ct);
+	fs_smfs->ct_nat = ct_nat;
+
+	if (!ct_tbl || !ct_nat_tbl || !post_ct_tbl) {
+		netdev_warn(fs->netdev, "ct_fs_smfs: failed to init, missing backing dr tables");
+		return -EOPNOTSUPP;
+	}
+
+	ct_dbg("using smfs steering");
+
+	err = mlx5_ct_fs_smfs_matchers_create(fs, ct_tbl, &fs_smfs->ct_matchers);
+	if (err)
+		goto err_init;
+
+	err = mlx5_ct_fs_smfs_matchers_create(fs, ct_nat_tbl, &fs_smfs->ct_matchers_nat);
+	if (err)
+		goto err_matchers_nat;
+
+	fs_smfs->fwd_action = mlx5_smfs_action_create_dest_table(post_ct_tbl);
+	if (!fs_smfs->fwd_action) {
+		err = -EINVAL;
+		goto err_action_create;
+	}
+
+	return 0;
+
+err_action_create:
+	mlx5_ct_fs_smfs_matchers_destroy(&fs_smfs->ct_matchers_nat);
+err_matchers_nat:
+	mlx5_ct_fs_smfs_matchers_destroy(&fs_smfs->ct_matchers);
+err_init:
+	return err;
+}
+
+static void
+mlx5_ct_fs_smfs_destroy(struct mlx5_ct_fs *fs)
+{
+	struct mlx5_ct_fs_smfs *fs_smfs = mlx5_ct_fs_priv(fs);
+
+	mlx5_smfs_action_destroy(fs_smfs->fwd_action);
+	mlx5_ct_fs_smfs_matchers_destroy(&fs_smfs->ct_matchers_nat);
+	mlx5_ct_fs_smfs_matchers_destroy(&fs_smfs->ct_matchers);
+}
+
+static inline bool
+mlx5_tc_ct_valid_used_dissector_keys(const u32 used_keys)
+{
+#define DISSECTOR_BIT(name) BIT(FLOW_DISSECTOR_KEY_ ## name)
+	const u32 basic_keys = DISSECTOR_BIT(BASIC) | DISSECTOR_BIT(CONTROL) |
+			       DISSECTOR_BIT(PORTS) | DISSECTOR_BIT(META);
+	const u32 ipv4_tcp = basic_keys | DISSECTOR_BIT(IPV4_ADDRS) | DISSECTOR_BIT(TCP);
+	const u32 ipv4_udp = basic_keys | DISSECTOR_BIT(IPV4_ADDRS);
+	const u32 ipv6_tcp = basic_keys | DISSECTOR_BIT(IPV6_ADDRS) | DISSECTOR_BIT(TCP);
+	const u32 ipv6_udp = basic_keys | DISSECTOR_BIT(IPV6_ADDRS);
+
+	return (used_keys == ipv4_tcp || used_keys == ipv4_udp || used_keys == ipv6_tcp ||
+		used_keys == ipv6_udp);
+}
+
+static bool
+mlx5_ct_fs_smfs_ct_validate_flow_rule(struct mlx5_ct_fs *fs, struct flow_rule *flow_rule)
+{
+	struct flow_match_ipv4_addrs ipv4_addrs;
+	struct flow_match_ipv6_addrs ipv6_addrs;
+	struct flow_match_control control;
+	struct flow_match_basic basic;
+	struct flow_match_ports ports;
+	struct flow_match_tcp tcp;
+
+	if (!mlx5_tc_ct_valid_used_dissector_keys(flow_rule->match.dissector->used_keys)) {
+		ct_dbg("rule uses unexpected dissectors (0x%08x)",
+		       flow_rule->match.dissector->used_keys);
+		return false;
+	}
+
+	flow_rule_match_basic(flow_rule, &basic);
+	flow_rule_match_control(flow_rule, &control);
+	flow_rule_match_ipv4_addrs(flow_rule, &ipv4_addrs);
+	flow_rule_match_ipv6_addrs(flow_rule, &ipv6_addrs);
+	flow_rule_match_ports(flow_rule, &ports);
+	flow_rule_match_tcp(flow_rule, &tcp);
+
+	if (basic.mask->n_proto != htons(0xFFFF) ||
+	    (basic.key->n_proto != htons(ETH_P_IP) && basic.key->n_proto != htons(ETH_P_IPV6)) ||
+	    basic.mask->ip_proto != 0xFF ||
+	    (basic.key->ip_proto != IPPROTO_UDP && basic.key->ip_proto != IPPROTO_TCP)) {
+		ct_dbg("rule uses unexpected basic match (n_proto 0x%04x/0x%04x, ip_proto 0x%02x/0x%02x)",
+		       ntohs(basic.key->n_proto), ntohs(basic.mask->n_proto),
+		       basic.key->ip_proto, basic.mask->ip_proto);
+		return false;
+	}
+
+	if (ports.mask->src != htons(0xFFFF) || ports.mask->dst != htons(0xFFFF)) {
+		ct_dbg("rule uses ports match (src 0x%04x, dst 0x%04x)",
+		       ports.mask->src, ports.mask->dst);
+		return false;
+	}
+
+	if (basic.key->ip_proto == IPPROTO_TCP && tcp.mask->flags != MLX5_CT_TCP_FLAGS_MASK) {
+		ct_dbg("rule uses unexpected tcp match (flags 0x%02x)", tcp.mask->flags);
+		return false;
+	}
+
+	return true;
+}
+
+static struct mlx5_ct_fs_rule *
+mlx5_ct_fs_smfs_ct_rule_add(struct mlx5_ct_fs *fs, struct mlx5_flow_spec *spec,
+			    struct mlx5_flow_attr *attr, struct flow_rule *flow_rule)
+{
+	struct mlx5_ct_fs_smfs *fs_smfs = mlx5_ct_fs_priv(fs);
+	struct mlx5_ct_fs_smfs_matchers *matchers;
+	struct mlx5_ct_fs_smfs_rule *smfs_rule;
+	struct mlx5dr_action *actions[5];
+	struct mlx5dr_matcher *matcher;
+	struct mlx5dr_rule *rule;
+	int num_actions = 0, err;
+	bool nat, tcp, ipv4;
+
+	if (!mlx5_ct_fs_smfs_ct_validate_flow_rule(fs, flow_rule))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	smfs_rule = kzalloc(sizeof(*smfs_rule), GFP_KERNEL);
+	if (!smfs_rule)
+		return ERR_PTR(-ENOMEM);
+
+	smfs_rule->count_action = mlx5_smfs_action_create_flow_counter(mlx5_fc_id(attr->counter));
+	if (!smfs_rule->count_action) {
+		err = -EINVAL;
+		goto err_count;
+	}
+
+	actions[num_actions++] = smfs_rule->count_action;
+	actions[num_actions++] = attr->modify_hdr->action.dr_action;
+	actions[num_actions++] = fs_smfs->fwd_action;
+
+	nat = (attr->ft == fs_smfs->ct_nat);
+	ipv4 = mlx5e_tc_get_ip_version(spec, true) == 4;
+	tcp = MLX5_GET(fte_match_param, spec->match_value,
+		       outer_headers.ip_protocol) == IPPROTO_TCP;
+
+	matchers = nat ? &fs_smfs->ct_matchers_nat : &fs_smfs->ct_matchers;
+	matcher = ipv4 ? (tcp ? matchers->ipv4_tcp : matchers->ipv4_udp) :
+			 (tcp ? matchers->ipv6_tcp : matchers->ipv6_udp);
+
+	rule = mlx5_smfs_rule_create(matcher, spec, num_actions, actions,
+				     MLX5_FLOW_CONTEXT_FLOW_SOURCE_ANY_VPORT);
+	if (!rule) {
+		err = -EINVAL;
+		goto err_rule;
+	}
+
+	smfs_rule->rule = rule;
+
+	return &smfs_rule->fs_rule;
+
+err_rule:
+	mlx5_smfs_action_destroy(smfs_rule->count_action);
+err_count:
+	kfree(smfs_rule);
+	return ERR_PTR(err);
+}
+
+static void
+mlx5_ct_fs_smfs_ct_rule_del(struct mlx5_ct_fs *fs, struct mlx5_ct_fs_rule *fs_rule)
+{
+	struct mlx5_ct_fs_smfs_rule *smfs_rule = container_of(fs_rule,
+							      struct mlx5_ct_fs_smfs_rule,
+							      fs_rule);
+
+	mlx5_smfs_rule_destroy(smfs_rule->rule);
+	mlx5_smfs_action_destroy(smfs_rule->count_action);
+	kfree(smfs_rule);
+}
+
+static struct mlx5_ct_fs_ops fs_smfs_ops = {
+	.ct_rule_add = mlx5_ct_fs_smfs_ct_rule_add,
+	.ct_rule_del = mlx5_ct_fs_smfs_ct_rule_del,
+
+	.init = mlx5_ct_fs_smfs_init,
+	.destroy = mlx5_ct_fs_smfs_destroy,
+
+	.priv_size = sizeof(struct mlx5_ct_fs_smfs),
+};
+
+struct mlx5_ct_fs_ops *
+mlx5_ct_fs_smfs_ops_get(void)
+{
+	return &fs_smfs_ops;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 09e88d8e17d3..ca1510399d1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -26,9 +26,8 @@
 #include "en.h"
 #include "en_tc.h"
 #include "en_rep.h"
+#include "fs_core.h"
 
-#define MLX5_CT_ZONE_BITS (mlx5e_tc_attr_to_reg_mappings[ZONE_TO_REG].mlen)
-#define MLX5_CT_ZONE_MASK GENMASK(MLX5_CT_ZONE_BITS - 1, 0)
 #define MLX5_CT_STATE_ESTABLISHED_BIT BIT(1)
 #define MLX5_CT_STATE_TRK_BIT BIT(2)
 #define MLX5_CT_STATE_NAT_BIT BIT(3)
@@ -819,7 +818,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	mlx5_tc_ct_set_tuple_match(ct_priv, spec, flow_rule);
 	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG, entry->tuple.zone, MLX5_CT_ZONE_MASK);
 
-	zone_rule->rule = ct_priv->fs_ops->ct_rule_add(ct_priv->fs, spec, attr);
+	zone_rule->rule = ct_priv->fs_ops->ct_rule_add(ct_priv->fs, spec, attr, flow_rule);
 	if (IS_ERR(zone_rule->rule)) {
 		err = PTR_ERR(zone_rule->rule);
 		ct_dbg("Failed to add ct entry rule, nat: %d", nat);
@@ -1966,9 +1965,17 @@ mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *priv,
 static int
 mlx5_tc_ct_fs_init(struct mlx5_tc_ct_priv *ct_priv)
 {
+	struct mlx5_flow_table *post_ct = mlx5e_tc_post_act_get_ft(ct_priv->post_act);
 	struct mlx5_ct_fs_ops *fs_ops = mlx5_ct_fs_dmfs_ops_get();
+	int err;
+
+	if (ct_priv->ns_type == MLX5_FLOW_NAMESPACE_FDB &&
+	    ct_priv->dev->priv.steering->mode == MLX5_FLOW_STEERING_MODE_SMFS) {
+		ct_dbg("Using SMFS ct flow steering provider");
+		fs_ops = mlx5_ct_fs_smfs_ops_get();
+	}
 
-	ct_priv->fs = kzalloc(sizeof(*ct_priv->fs), GFP_KERNEL);
+	ct_priv->fs = kzalloc(sizeof(*ct_priv->fs) + fs_ops->priv_size, GFP_KERNEL);
 	if (!ct_priv->fs)
 		return -ENOMEM;
 
@@ -1976,7 +1983,15 @@ mlx5_tc_ct_fs_init(struct mlx5_tc_ct_priv *ct_priv)
 	ct_priv->fs->dev = ct_priv->dev;
 	ct_priv->fs_ops = fs_ops;
 
+	err = ct_priv->fs_ops->init(ct_priv->fs, ct_priv->ct, ct_priv->ct_nat, post_ct);
+	if (err)
+		goto err_init;
+
 	return 0;
+
+err_init:
+	kfree(ct_priv->fs);
+	return err;
 }
 
 static int
@@ -2155,6 +2170,7 @@ mlx5_tc_ct_clean(struct mlx5_tc_ct_priv *ct_priv)
 
 	chains = ct_priv->chains;
 
+	ct_priv->fs_ops->destroy(ct_priv->fs);
 	kfree(ct_priv->fs);
 
 	mlx5_chains_destroy_global_table(chains, ct_priv->ct_nat);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 2b21c7b97a52..36d3652bf829 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -86,6 +86,8 @@ struct mlx5_ct_attr {
 
 #define REG_MAPPING_MLEN(reg) (mlx5e_tc_attr_to_reg_mappings[reg].mlen)
 #define REG_MAPPING_MOFFSET(reg) (mlx5e_tc_attr_to_reg_mappings[reg].moffset)
+#define MLX5_CT_ZONE_BITS (mlx5e_tc_attr_to_reg_mappings[ZONE_TO_REG].mlen)
+#define MLX5_CT_ZONE_MASK GENMASK(MLX5_CT_ZONE_BITS - 1, 0)
 
 #if IS_ENABLED(CONFIG_MLX5_TC_CT)
 
-- 
2.35.1


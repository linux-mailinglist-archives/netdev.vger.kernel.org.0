Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDDB3562BF
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348561AbhDGEzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:55:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348536AbhDGEyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:54:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF213613D1;
        Wed,  7 Apr 2021 04:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617771279;
        bh=O/6FsqBeBB6aLqnxQkEhDiRFkZ+FUk0nQAIkK9pKJOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YU5MRhNBFqdv7EG9wr0VQ8u1+eUW9tZiHdXzJH8wi7eYdfA6pA+k6FlilGcLozNL/
         BywGoV84EJAWDnuUOKOW/eQNzOGNnx77akjsp4Vt1EVssTsxZF8mw0xjZWII0GXU5X
         bnnErQrYvaKSAAyHZranwJgXfXCMS7ChUuc2Dng69LgVpTMwkgpavvRZTp7VACOSLK
         wKiHzWOFzhyoDjZS+gKHvR9Pb9D80awG+CVlpynk+8TzQYU/8FPPodq9/cjbwHgzF5
         5E+jFNiC+f8X3dQm7R0wsHEWaWVbcybU1P79aGmDXCXps1PZrgjpsH9Z6M8448aMDE
         FgbdyHt/zEP5Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/13] net/mlx5e: TC, Add sampler termination table API
Date:   Tue,  6 Apr 2021 21:54:16 -0700
Message-Id: <20210407045421.148987-9-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407045421.148987-1-saeed@kernel.org>
References: <20210407045421.148987-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Sampled packets are sent to software using termination tables. There
is only one rule in that table that is to forward sampled packets to
the e-switch management vport.

Create a sampler termination table and rule for each eswitch.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   | 12 +++
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 11 +++
 .../ethernet/mellanox/mlx5/core/esw/sample.c  | 96 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/esw/sample.h  |  8 ++
 6 files changed, 129 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 9d623e38d783..461a43f338e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -104,6 +104,18 @@ config MLX5_TC_CT
 
 	  If unsure, set to Y
 
+config MLX5_TC_SAMPLE
+	bool "MLX5 TC sample offload support"
+	depends on MLX5_CLS_ACT
+	default y
+	help
+	  Say Y here if you want to support offloading sample rules via tc
+	  sample action.
+	  If set to N, will not be able to configure tc rules with sample
+	  action.
+
+	  If unsure, set to Y
+
 config MLX5_CORE_EN_DCB
 	bool "Data Center Bridging (DCB) Support"
 	default y
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 5bedc2c4d26f..8bde58379ac6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -55,6 +55,7 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)   += esw/acl/helper.o \
 				      esw/acl/egress_lgcy.o esw/acl/egress_ofld.o \
 				      esw/acl/ingress_lgcy.o esw/acl/ingress_ofld.o \
 				      esw/devlink_port.o esw/vporttbl.o
+mlx5_core-$(CONFIG_MLX5_TC_SAMPLE) += esw/sample.o
 
 mlx5_core-$(CONFIG_MLX5_MPFS)      += lib/mpfs.o
 mlx5_core-$(CONFIG_VXLAN)          += lib/vxlan.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 931fa619cb01..22585015c7a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -89,6 +89,7 @@ struct mlx5_rep_uplink_priv {
 	struct mapping_ctx *tunnel_enc_opts_mapping;
 
 	struct mlx5_tc_ct_priv *ct_priv;
+	struct mlx5_esw_psample *esw_psample;
 
 	/* support eswitch vports bonding */
 	struct mlx5e_rep_bond *bond;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 85782d12ffb2..1a403112defd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -66,6 +66,7 @@
 #include "en/mod_hdr.h"
 #include "en/tc_priv.h"
 #include "en/tc_tun_encap.h"
+#include "esw/sample.h"
 #include "lib/devcom.h"
 #include "lib/geneve.h"
 #include "lib/fs_chains.h"
@@ -4876,6 +4877,10 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 					       &esw->offloads.mod_hdr,
 					       MLX5_FLOW_NAMESPACE_FDB);
 
+#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
+	uplink_priv->esw_psample = mlx5_esw_sample_init(netdev_priv(priv->netdev));
+#endif
+
 	mapping = mapping_create(sizeof(struct tunnel_match_key),
 				 TUNNEL_INFO_BITS_MASK, true);
 	if (IS_ERR(mapping)) {
@@ -4913,6 +4918,9 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 err_enc_opts_mapping:
 	mapping_destroy(uplink_priv->tunnel_mapping);
 err_tun_mapping:
+#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
+	mlx5_esw_sample_cleanup(uplink_priv->esw_psample);
+#endif
 	mlx5_tc_ct_clean(uplink_priv->ct_priv);
 	netdev_warn(priv->netdev,
 		    "Failed to initialize tc (eswitch), err: %d", err);
@@ -4931,6 +4939,9 @@ void mlx5e_tc_esw_cleanup(struct rhashtable *tc_ht)
 	mapping_destroy(uplink_priv->tunnel_enc_opts_mapping);
 	mapping_destroy(uplink_priv->tunnel_mapping);
 
+#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
+	mlx5_esw_sample_cleanup(uplink_priv->esw_psample);
+#endif
 	mlx5_tc_ct_clean(uplink_priv->ct_priv);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
new file mode 100644
index 000000000000..9bd996e8d28a
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#include "esw/sample.h"
+#include "eswitch.h"
+
+struct mlx5_esw_psample {
+	struct mlx5e_priv *priv;
+	struct mlx5_flow_table *termtbl;
+	struct mlx5_flow_handle *termtbl_rule;
+};
+
+static int
+sampler_termtbl_create(struct mlx5_esw_psample *esw_psample)
+{
+	struct mlx5_core_dev *dev = esw_psample->priv->mdev;
+	struct mlx5_eswitch *esw = dev->priv.eswitch;
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_namespace *root_ns;
+	struct mlx5_flow_act act = {};
+	int err;
+
+	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(dev, termination_table))  {
+		mlx5_core_warn(dev, "termination table is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	root_ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_FDB);
+	if (!root_ns) {
+		mlx5_core_warn(dev, "failed to get FDB flow namespace\n");
+		return -EOPNOTSUPP;
+	}
+
+	ft_attr.flags = MLX5_FLOW_TABLE_TERMINATION | MLX5_FLOW_TABLE_UNMANAGED;
+	ft_attr.autogroup.max_num_groups = 1;
+	ft_attr.prio = FDB_SLOW_PATH;
+	ft_attr.max_fte = 1;
+	ft_attr.level = 1;
+	esw_psample->termtbl = mlx5_create_auto_grouped_flow_table(root_ns, &ft_attr);
+	if (IS_ERR(esw_psample->termtbl)) {
+		err = PTR_ERR(esw_psample->termtbl);
+		mlx5_core_warn(dev, "failed to create termtbl, err: %d\n", err);
+		return err;
+	}
+
+	act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	dest.vport.num = esw->manager_vport;
+	esw_psample->termtbl_rule = mlx5_add_flow_rules(esw_psample->termtbl, NULL, &act, &dest, 1);
+	if (IS_ERR(esw_psample->termtbl_rule)) {
+		err = PTR_ERR(esw_psample->termtbl_rule);
+		mlx5_core_warn(dev, "failed to create termtbl rule, err: %d\n", err);
+		mlx5_destroy_flow_table(esw_psample->termtbl);
+		return err;
+	}
+
+	return 0;
+}
+
+static void
+sampler_termtbl_destroy(struct mlx5_esw_psample *esw_psample)
+{
+	mlx5_del_flow_rules(esw_psample->termtbl_rule);
+	mlx5_destroy_flow_table(esw_psample->termtbl);
+}
+
+struct mlx5_esw_psample *
+mlx5_esw_sample_init(struct mlx5e_priv *priv)
+{
+	struct mlx5_esw_psample *esw_psample;
+	int err;
+
+	esw_psample = kzalloc(sizeof(*esw_psample), GFP_KERNEL);
+	if (!esw_psample)
+		return ERR_PTR(-ENOMEM);
+	esw_psample->priv = priv;
+	err = sampler_termtbl_create(esw_psample);
+	if (err)
+		goto err_termtbl;
+
+	return esw_psample;
+
+err_termtbl:
+	kfree(esw_psample);
+	return ERR_PTR(err);
+}
+
+void
+mlx5_esw_sample_cleanup(struct mlx5_esw_psample *esw_psample)
+{
+	if (IS_ERR_OR_NULL(esw_psample))
+		return;
+
+	sampler_termtbl_destroy(esw_psample);
+	kfree(esw_psample);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
index 35a5e6dddcd0..e42e3cb01c8c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
@@ -4,10 +4,18 @@
 #ifndef __MLX5_EN_TC_SAMPLE_H__
 #define __MLX5_EN_TC_SAMPLE_H__
 
+#include "en.h"
+
 struct mlx5_sample_attr {
 	u32 group_num;
 	u32 rate;
 	u32 trunc_size;
 };
 
+struct mlx5_esw_psample *
+mlx5_esw_sample_init(struct mlx5e_priv *priv);
+
+void
+mlx5_esw_sample_cleanup(struct mlx5_esw_psample *esw_psample);
+
 #endif /* __MLX5_EN_TC_SAMPLE_H__ */
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212CA539845
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 22:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244431AbiEaUzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 16:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243614AbiEaUzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 16:55:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1379CF70
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 13:55:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3978561319
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 20:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838D2C3411C;
        Tue, 31 May 2022 20:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654030505;
        bh=0EL7jx0MiKVhmpJvzgVhVfxfUpRBZ6j4iFtOPu62fjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h7NrW6D+3IqrFyBuhbka/1jXX8409pZeA/cyNmZGE9WwB377fvP3y4UUMu2w77eLP
         x1FzyNeco9DtrUE5cYApf/JhITowguAqN1TSQobepF2XwO/upMDsNl50a24ejcrv6l
         mZzphnebFaq/9wmogYZsJev4S25FfYO0xe5ps1GnZ2eHzJOc9YElChfyqzt0J2VpYi
         cuSROX9QMJacbuC8kMM+Kdmmnaebtmm/jRzq0ctEGupC8GnSD26oxBxNsw6nFWc2uh
         mLRw2m3ytZMdcRHLQBjQxBuyPI1rPJ91TzmX0E+HkGc1ASdD1gICZk9UhIUUVrRfSq
         22ylFEX19nsmA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/7] net/mlx5e: TC NIC mode, fix tc chains miss table
Date:   Tue, 31 May 2022 13:54:42 -0700
Message-Id: <20220531205447.99236-3-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220531205447.99236-1-saeed@kernel.org>
References: <20220531205447.99236-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

The cited commit changed promisc table to be created on demand with the
highest priority in the NIC table replacing the vlan table, this caused
tc NIC tables miss flow to skip the prmoisc table because it use vlan
table as miss table.

OVS offload in NIC mode use promisc by default so any unicast packet
which will be handled by tc NIC tables miss flow will skip the promisc
rule and will be dropped.

Fix this by adding new empty table in new tc level with low priority and
point the nic tc chain miss to it, the new table is managed so it will
point to vlan table if promisc is disabled and to promisc table if enabled.

Fixes: 1c46d7409f30 ("net/mlx5e: Optimize promiscuous mode")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 38 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  2 +-
 3 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 4130a871de61..6e3a90a959e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -12,6 +12,7 @@ struct mlx5e_post_act;
 enum {
 	MLX5E_TC_FT_LEVEL = 0,
 	MLX5E_TC_TTC_FT_LEVEL,
+	MLX5E_TC_MISS_LEVEL,
 };
 
 struct mlx5e_tc_table {
@@ -20,6 +21,7 @@ struct mlx5e_tc_table {
 	 */
 	struct mutex			t_lock;
 	struct mlx5_flow_table		*t;
+	struct mlx5_flow_table		*miss_t;
 	struct mlx5_fs_chains           *chains;
 	struct mlx5e_post_act		*post_act;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 49dea02a12d2..34bf11cdf90f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4714,6 +4714,33 @@ static int mlx5e_tc_nic_get_ft_size(struct mlx5_core_dev *dev)
 	return tc_tbl_size;
 }
 
+static int mlx5e_tc_nic_create_miss_table(struct mlx5e_priv *priv)
+{
+	struct mlx5_flow_table **ft = &priv->fs.tc.miss_t;
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_namespace *ns;
+	int err = 0;
+
+	ft_attr.max_fte = 1;
+	ft_attr.autogroup.max_num_groups = 1;
+	ft_attr.level = MLX5E_TC_MISS_LEVEL;
+	ft_attr.prio = 0;
+	ns = mlx5_get_flow_namespace(priv->mdev, MLX5_FLOW_NAMESPACE_KERNEL);
+
+	*ft = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
+	if (IS_ERR(*ft)) {
+		err = PTR_ERR(*ft);
+		netdev_err(priv->netdev, "failed to create tc nic miss table err=%d\n", err);
+	}
+
+	return err;
+}
+
+static void mlx5e_tc_nic_destroy_miss_table(struct mlx5e_priv *priv)
+{
+	mlx5_destroy_flow_table(priv->fs.tc.miss_t);
+}
+
 int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 {
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
@@ -4746,19 +4773,23 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	}
 	tc->mapping = chains_mapping;
 
+	err = mlx5e_tc_nic_create_miss_table(priv);
+	if (err)
+		goto err_chains;
+
 	if (MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ignore_flow_level))
 		attr.flags = MLX5_CHAINS_AND_PRIOS_SUPPORTED |
 			MLX5_CHAINS_IGNORE_FLOW_LEVEL_SUPPORTED;
 	attr.ns = MLX5_FLOW_NAMESPACE_KERNEL;
 	attr.max_ft_sz = mlx5e_tc_nic_get_ft_size(dev);
 	attr.max_grp_num = MLX5E_TC_TABLE_NUM_GROUPS;
-	attr.default_ft = mlx5e_vlan_get_flowtable(priv->fs.vlan);
+	attr.default_ft = priv->fs.tc.miss_t;
 	attr.mapping = chains_mapping;
 
 	tc->chains = mlx5_chains_create(dev, &attr);
 	if (IS_ERR(tc->chains)) {
 		err = PTR_ERR(tc->chains);
-		goto err_chains;
+		goto err_miss;
 	}
 
 	tc->post_act = mlx5e_tc_post_act_init(priv, tc->chains, MLX5_FLOW_NAMESPACE_KERNEL);
@@ -4781,6 +4812,8 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	mlx5_tc_ct_clean(tc->ct);
 	mlx5e_tc_post_act_destroy(tc->post_act);
 	mlx5_chains_destroy(tc->chains);
+err_miss:
+	mlx5e_tc_nic_destroy_miss_table(priv);
 err_chains:
 	mapping_destroy(chains_mapping);
 err_mapping:
@@ -4821,6 +4854,7 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 	mlx5e_tc_post_act_destroy(tc->post_act);
 	mapping_destroy(tc->mapping);
 	mlx5_chains_destroy(tc->chains);
+	mlx5e_tc_nic_destroy_miss_table(priv);
 }
 
 int mlx5e_tc_ht_init(struct rhashtable *tc_ht)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 84caffe4c278..fdcf7f529330 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -114,7 +114,7 @@
 #define KERNEL_MIN_LEVEL (KERNEL_NIC_PRIO_NUM_LEVELS + 1)
 
 #define KERNEL_NIC_TC_NUM_PRIOS  1
-#define KERNEL_NIC_TC_NUM_LEVELS 2
+#define KERNEL_NIC_TC_NUM_LEVELS 3
 
 #define ANCHOR_NUM_LEVELS 1
 #define ANCHOR_NUM_PRIOS 1
-- 
2.36.1


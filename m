Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC18A584766
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbiG1U63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbiG1U5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:57:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F73578239
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:57:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EA4CB82452
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B10C433C1;
        Thu, 28 Jul 2022 20:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041857;
        bh=Z/PeLX0vXZLcI45oxfbzi0dA1jNHTZIkGhShOa4/rcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1JjjZsFbXCAdnZv0xi70SicmJcCEbPs9RdgjEMeaLQs9TkASKGTfCRDTkY50tyR5
         8a7Hb3yW6zjtw1LPKjnJtY09QmLmbRF0iws+jWgZzpFuulWXCX2Xm72otE370exHSs
         1lyr4bBSPbV/Gu1oDVu92PTdfijbyQTuhmbcDzULfiRYswDCxh0sCeeuAm3WiWitH/
         wnn+6sDjr4IniwUMR4TEAFrlLv2lok/6/m37pe1bo53Ss8Dm8VhBwy+mhgha2hgwWv
         zpGJkqtQxq9SaXPlXzjXXpohX9JUcWsHGjWe/b956w3i5xuFw0J3SmbCYenY7k7RI/
         ehh7uzOrAxTJw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: Make mlx5e_tc_table private
Date:   Thu, 28 Jul 2022 13:57:21 -0700
Message-Id: <20220728205728.143074-9-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728205728.143074-1-saeed@kernel.org>
References: <20220728205728.143074-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

Move mlx5e_tc_table struct to en_tc.c thus make it private.
Introduce allocation and deallocation functions as part of the tc API
to allow this switch smoothly.

Convert mlx5e_nic_chain() macro to a function of en_tc.c.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   | 24 ---------
 .../mellanox/mlx5/core/en/tc/act/goto.c       |  2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |  9 ++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 49 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  4 ++
 6 files changed, 59 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 928bfd261967..f9cffc495201 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -15,30 +15,6 @@ enum {
 	MLX5E_TC_MISS_LEVEL,
 };
 
-struct mlx5e_tc_table {
-	/* Protects the dynamic assignment of the t parameter
-	 * which is the nic tc root table.
-	 */
-	struct mutex			t_lock;
-	struct mlx5e_priv		*priv;
-	struct mlx5_flow_table		*t;
-	struct mlx5_flow_table		*miss_t;
-	struct mlx5_fs_chains           *chains;
-	struct mlx5e_post_act		*post_act;
-
-	struct rhashtable               ht;
-
-	struct mod_hdr_tbl mod_hdr;
-	struct mutex hairpin_tbl_lock; /* protects hairpin_tbl */
-	DECLARE_HASHTABLE(hairpin_tbl, 8);
-
-	struct notifier_block     netdevice_nb;
-	struct netdev_net_notifier	netdevice_nn;
-
-	struct mlx5_tc_ct_priv         *ct;
-	struct mapping_ctx             *mapping;
-};
-
 struct mlx5e_flow_table {
 	int num_groups;
 	struct mlx5_flow_table *t;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
index 4726bcb46eec..eaa6d6a41bbd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
@@ -21,7 +21,7 @@ validate_goto_chain(struct mlx5e_priv *priv,
 	u32 max_chain;
 
 	esw = priv->mdev->priv.eswitch;
-	chains = is_esw ? esw_chains(esw) : mlx5e_nic_chains(priv);
+	chains = is_esw ? esw_chains(esw) : mlx5e_nic_chains(priv->fs.tc);
 	max_chain = mlx5_chains_get_chain_range(chains);
 	reformat_and_fwd = is_esw ?
 			   MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev, reformat_and_fwd_to_table) :
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 74bbcb9d2257..10c9a8a79d00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -11,7 +11,6 @@
 
 #define MLX5E_TC_MAX_SPLITS 1
 
-#define mlx5e_nic_chains(priv) ((priv)->fs.tc->chains)
 
 enum {
 	MLX5E_TC_FLOW_FLAG_INGRESS               = MLX5E_TC_FLAG_INGRESS_BIT,
@@ -44,6 +43,8 @@ struct mlx5e_tc_flow_parse_attr {
 	struct mlx5e_tc_act_parse_state parse_state;
 };
 
+struct mlx5_fs_chains *mlx5e_nic_chains(struct mlx5e_tc_table *tc);
+
 /* Helper struct for accessing a struct containing list_head array.
  * Containing struct
  *   |- Helper array
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 82dc114284da..86c5533950f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -38,6 +38,7 @@
 #include <linux/mlx5/mpfs.h>
 #include "en.h"
 #include "en_rep.h"
+#include "en_tc.h"
 #include "lib/mpfs.h"
 #include "en/ptp.h"
 
@@ -1347,9 +1348,11 @@ int mlx5e_fs_init(struct mlx5e_priv *priv)
 	priv->fs.vlan = kvzalloc(sizeof(*priv->fs.vlan), GFP_KERNEL);
 	if (!priv->fs.vlan)
 		goto err;
-	priv->fs.tc = kvzalloc(sizeof(*priv->fs.tc), GFP_KERNEL);
-	if (!priv->fs.tc)
+
+	priv->fs.tc = mlx5e_tc_table_alloc();
+	if (IS_ERR(priv->fs.tc))
 		goto err_free_vlan;
+
 	return 0;
 err_free_vlan:
 	kvfree(priv->fs.vlan);
@@ -1360,7 +1363,7 @@ int mlx5e_fs_init(struct mlx5e_priv *priv)
 
 void mlx5e_fs_cleanup(struct mlx5e_priv *priv)
 {
-	kvfree(priv->fs.tc);
+	mlx5e_tc_table_free(priv->fs.tc);
 	kvfree(priv->fs.vlan);
 	priv->fs.vlan = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 6f2654290c6e..f19894564119 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -71,6 +71,30 @@
 #define MLX5E_TC_TABLE_NUM_GROUPS 4
 #define MLX5E_TC_TABLE_MAX_GROUP_SIZE BIT(18)
 
+struct mlx5e_tc_table {
+	/* Protects the dynamic assignment of the t parameter
+	 * which is the nic tc root table.
+	 */
+	struct mutex			t_lock;
+	struct mlx5e_priv		*priv;
+	struct mlx5_flow_table		*t;
+	struct mlx5_flow_table		*miss_t;
+	struct mlx5_fs_chains           *chains;
+	struct mlx5e_post_act		*post_act;
+
+	struct rhashtable               ht;
+
+	struct mod_hdr_tbl mod_hdr;
+	struct mutex hairpin_tbl_lock; /* protects hairpin_tbl */
+	DECLARE_HASHTABLE(hairpin_tbl, 8);
+
+	struct notifier_block     netdevice_nb;
+	struct netdev_net_notifier	netdevice_nn;
+
+	struct mlx5_tc_ct_priv         *ct;
+	struct mapping_ctx             *mapping;
+};
+
 struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	[CHAIN_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_0,
@@ -108,6 +132,24 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	[PACKET_COLOR_TO_REG] = packet_color_to_reg,
 };
 
+struct mlx5e_tc_table *mlx5e_tc_table_alloc(void)
+{
+	struct mlx5e_tc_table *tc;
+
+	tc = kvzalloc(sizeof(*tc), GFP_KERNEL);
+	return tc ? tc : ERR_PTR(-ENOMEM);
+}
+
+void mlx5e_tc_table_free(struct mlx5e_tc_table *tc)
+{
+	kvfree(tc);
+}
+
+struct mlx5_fs_chains *mlx5e_nic_chains(struct mlx5e_tc_table *tc)
+{
+	return tc->chains;
+}
+
 /* To avoid false lock dependency warning set the tc_ht lock
  * class different than the lock class of the ht being used when deleting
  * last flow from a group and then deleting a group, we get into del_sw_flow_group()
@@ -1084,10 +1126,10 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 			     struct mlx5_flow_attr *attr)
 {
 	struct mlx5_flow_context *flow_context = &spec->flow_context;
-	struct mlx5_fs_chains *nic_chains = mlx5e_nic_chains(priv);
 	struct mlx5_nic_flow_attr *nic_attr = attr->nic_attr;
 	struct mlx5e_tc_table *tc = priv->fs.tc;
 	struct mlx5_flow_destination dest[2] = {};
+	struct mlx5_fs_chains *nic_chains;
 	struct mlx5_flow_act flow_act = {
 		.action = attr->action,
 		.flags    = FLOW_ACT_NO_APPEND,
@@ -1096,6 +1138,7 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 	struct mlx5_flow_table *ft;
 	int dest_ix = 0;
 
+	nic_chains = mlx5e_nic_chains(tc);
 	flow_context->flags |= FLOW_CONTEXT_HAS_TAG;
 	flow_context->flow_tag = nic_attr->flow_tag;
 
@@ -1250,7 +1293,7 @@ void mlx5e_del_offloaded_nic_rule(struct mlx5e_priv *priv,
 				  struct mlx5_flow_handle *rule,
 				  struct mlx5_flow_attr *attr)
 {
-	struct mlx5_fs_chains *nic_chains = mlx5e_nic_chains(priv);
+	struct mlx5_fs_chains *nic_chains = mlx5e_nic_chains(priv->fs.tc);
 
 	mlx5_del_flow_rules(rule);
 
@@ -1282,7 +1325,7 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	mutex_lock(&priv->fs.tc->t_lock);
 	if (!mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD)) &&
 	    !IS_ERR_OR_NULL(tc->t)) {
-		mlx5_chains_put_table(mlx5e_nic_chains(priv), 0, 1, MLX5E_TC_FT_LEVEL);
+		mlx5_chains_put_table(mlx5e_nic_chains(tc), 0, 1, MLX5E_TC_FT_LEVEL);
 		priv->fs.tc->t = NULL;
 	}
 	mutex_unlock(&priv->fs.tc->t_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 517f2252b5ff..6ce1ab6b86b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -356,6 +356,8 @@ mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
 #endif
 
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
+struct mlx5e_tc_table *mlx5e_tc_table_alloc(void);
+void mlx5e_tc_table_free(struct mlx5e_tc_table *tc);
 static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
 {
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
@@ -376,6 +378,8 @@ static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
 
 bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb);
 #else /* CONFIG_MLX5_CLS_ACT */
+static inline struct mlx5e_tc_table *mlx5e_tc_table_alloc(void) { return NULL; }
+static inline void mlx5e_tc_table_free(struct mlx5e_tc_table *tc) {}
 static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
 { return false; }
 static inline bool
-- 
2.37.1


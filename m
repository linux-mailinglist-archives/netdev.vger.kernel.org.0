Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD905584767
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbiG1U6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbiG1U5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:57:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F28678218
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:57:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42446B8259B
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9EAC433D7;
        Thu, 28 Jul 2022 20:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041856;
        bh=uVfCoSNWB/v79kuW/1eAddHYpslR6uwfzmZCudnL2q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJ+0c7rBoEEeoPEivMO23j4k3mzLL1fidvihNt/voStW9YB5TO4TgBYjp5iohA7zX
         CvtK0s8dVyhEFs+Ibqfb6fbeLbkJhLu2ulAdTsqe84TQbf4HD5v9Ay7Gt9B0529Gro
         3mm9N8w+PfQBqPsoSCHJKg4kS/VkGDEwj9bXcHNAXvOa6impHzjWtjzEhrbGCkpfPw
         OcuG8xWYdwQZBw+fF8amQzJX9iNby+cKPaEud2hwZ0xEP0SyNYMPeZ+UyhZaa3p6fq
         vCHFHActuhDIy+Rd6x7sPthKyQjhFUQogTcl7mAS2GA1sM/DlcTsONTXZX2HnUX2h2
         Sj1XhUgV7PmMQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: Convert mlx5e_tc_table member of mlx5e_flow_steering to pointer
Date:   Thu, 28 Jul 2022 13:57:20 -0700
Message-Id: <20220728205728.143074-8-saeed@kernel.org>
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

Make fs.tc be a pointer and allocate it dynamically.
Add mlx5e_priv pointer to mlx5e_tc_table, and thus get a work-around to
accessing priv via tc when handling tc events inside mlx5e_tc_netdev_event.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  3 +-
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 11 +++-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 61 +++++++++----------
 4 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 6e3a90a959e9..928bfd261967 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -20,6 +20,7 @@ struct mlx5e_tc_table {
 	 * which is the nic tc root table.
 	 */
 	struct mutex			t_lock;
+	struct mlx5e_priv		*priv;
 	struct mlx5_flow_table		*t;
 	struct mlx5_flow_table		*miss_t;
 	struct mlx5_fs_chains           *chains;
@@ -169,7 +170,7 @@ struct mlx5e_flow_steering {
 #ifdef CONFIG_MLX5_EN_RXNFC
 	struct mlx5e_ethtool_steering   ethtool;
 #endif
-	struct mlx5e_tc_table           tc;
+	struct mlx5e_tc_table           *tc;
 	struct mlx5e_promisc_table      promisc;
 	struct mlx5e_vlan_table         *vlan;
 	struct mlx5e_l2_table           l2;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index d2bdfd6872bc..74bbcb9d2257 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -11,7 +11,7 @@
 
 #define MLX5E_TC_MAX_SPLITS 1
 
-#define mlx5e_nic_chains(priv) ((priv)->fs.tc.chains)
+#define mlx5e_nic_chains(priv) ((priv)->fs.tc->chains)
 
 enum {
 	MLX5E_TC_FLOW_FLAG_INGRESS               = MLX5E_TC_FLAG_INGRESS_BIT,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index d2f0773f95c6..82dc114284da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1346,12 +1346,21 @@ int mlx5e_fs_init(struct mlx5e_priv *priv)
 {
 	priv->fs.vlan = kvzalloc(sizeof(*priv->fs.vlan), GFP_KERNEL);
 	if (!priv->fs.vlan)
-		return -ENOMEM;
+		goto err;
+	priv->fs.tc = kvzalloc(sizeof(*priv->fs.tc), GFP_KERNEL);
+	if (!priv->fs.tc)
+		goto err_free_vlan;
 	return 0;
+err_free_vlan:
+	kvfree(priv->fs.vlan);
+	priv->fs.vlan = NULL;
+err:
+	return -ENOMEM;
 }
 
 void mlx5e_fs_cleanup(struct mlx5e_priv *priv)
 {
+	kvfree(priv->fs.tc);
 	kvfree(priv->fs.vlan);
 	priv->fs.vlan = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c3ec23f883cd..6f2654290c6e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -280,7 +280,7 @@ get_ct_priv(struct mlx5e_priv *priv)
 		return uplink_priv->ct_priv;
 	}
 
-	return priv->fs.tc.ct;
+	return priv->fs.tc->ct;
 }
 
 static struct mlx5e_tc_psample *
@@ -314,7 +314,7 @@ get_post_action(struct mlx5e_priv *priv)
 		return uplink_priv->post_act;
 	}
 
-	return priv->fs.tc.post_act;
+	return priv->fs.tc->post_act;
 }
 
 struct mlx5_flow_handle *
@@ -569,7 +569,7 @@ get_mod_hdr_table(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow)
 
 	return mlx5e_get_flow_namespace(flow) == MLX5_FLOW_NAMESPACE_FDB ?
 		&esw->offloads.mod_hdr :
-		&priv->fs.tc.mod_hdr;
+		&priv->fs.tc->mod_hdr;
 }
 
 static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv,
@@ -877,7 +877,7 @@ static struct mlx5e_hairpin_entry *mlx5e_hairpin_get(struct mlx5e_priv *priv,
 	struct mlx5e_hairpin_entry *hpe;
 	u32 hash_key = hash_hairpin_info(peer_vhca_id, prio);
 
-	hash_for_each_possible(priv->fs.tc.hairpin_tbl, hpe,
+	hash_for_each_possible(priv->fs.tc->hairpin_tbl, hpe,
 			       hairpin_hlist, hash_key) {
 		if (hpe->peer_vhca_id == peer_vhca_id && hpe->prio == prio) {
 			refcount_inc(&hpe->refcnt);
@@ -892,10 +892,10 @@ static void mlx5e_hairpin_put(struct mlx5e_priv *priv,
 			      struct mlx5e_hairpin_entry *hpe)
 {
 	/* no more hairpin flows for us, release the hairpin pair */
-	if (!refcount_dec_and_mutex_lock(&hpe->refcnt, &priv->fs.tc.hairpin_tbl_lock))
+	if (!refcount_dec_and_mutex_lock(&hpe->refcnt, &priv->fs.tc->hairpin_tbl_lock))
 		return;
 	hash_del(&hpe->hairpin_hlist);
-	mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
+	mutex_unlock(&priv->fs.tc->hairpin_tbl_lock);
 
 	if (!IS_ERR_OR_NULL(hpe->hp)) {
 		netdev_dbg(priv->netdev, "del hairpin: peer %s\n",
@@ -979,10 +979,10 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	mutex_lock(&priv->fs.tc.hairpin_tbl_lock);
+	mutex_lock(&priv->fs.tc->hairpin_tbl_lock);
 	hpe = mlx5e_hairpin_get(priv, peer_id, match_prio);
 	if (hpe) {
-		mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
+		mutex_unlock(&priv->fs.tc->hairpin_tbl_lock);
 		wait_for_completion(&hpe->res_ready);
 
 		if (IS_ERR(hpe->hp)) {
@@ -994,7 +994,7 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 
 	hpe = kzalloc(sizeof(*hpe), GFP_KERNEL);
 	if (!hpe) {
-		mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
+		mutex_unlock(&priv->fs.tc->hairpin_tbl_lock);
 		return -ENOMEM;
 	}
 
@@ -1006,9 +1006,9 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 	refcount_set(&hpe->refcnt, 1);
 	init_completion(&hpe->res_ready);
 
-	hash_add(priv->fs.tc.hairpin_tbl, &hpe->hairpin_hlist,
+	hash_add(priv->fs.tc->hairpin_tbl, &hpe->hairpin_hlist,
 		 hash_hairpin_info(peer_id, match_prio));
-	mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
+	mutex_unlock(&priv->fs.tc->hairpin_tbl_lock);
 
 	params.log_data_size = 16;
 	params.log_data_size = min_t(u8, params.log_data_size,
@@ -1086,7 +1086,7 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 	struct mlx5_flow_context *flow_context = &spec->flow_context;
 	struct mlx5_fs_chains *nic_chains = mlx5e_nic_chains(priv);
 	struct mlx5_nic_flow_attr *nic_attr = attr->nic_attr;
-	struct mlx5e_tc_table *tc = &priv->fs.tc;
+	struct mlx5e_tc_table *tc = priv->fs.tc;
 	struct mlx5_flow_destination dest[2] = {};
 	struct mlx5_flow_act flow_act = {
 		.action = attr->action,
@@ -1148,7 +1148,7 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 			mutex_unlock(&tc->t_lock);
 			netdev_err(priv->netdev,
 				   "Failed to create tc offload table\n");
-			rule = ERR_CAST(priv->fs.tc.t);
+			rule = ERR_CAST(priv->fs.tc->t);
 			goto err_ft_get;
 		}
 	}
@@ -1267,7 +1267,7 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 				  struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_flow_attr *attr = flow->attr;
-	struct mlx5e_tc_table *tc = &priv->fs.tc;
+	struct mlx5e_tc_table *tc = priv->fs.tc;
 
 	flow_flag_clear(flow, OFFLOADED);
 
@@ -1279,13 +1279,13 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	/* Remove root table if no rules are left to avoid
 	 * extra steering hops.
 	 */
-	mutex_lock(&priv->fs.tc.t_lock);
+	mutex_lock(&priv->fs.tc->t_lock);
 	if (!mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD)) &&
 	    !IS_ERR_OR_NULL(tc->t)) {
 		mlx5_chains_put_table(mlx5e_nic_chains(priv), 0, 1, MLX5E_TC_FT_LEVEL);
-		priv->fs.tc.t = NULL;
+		priv->fs.tc->t = NULL;
 	}
-	mutex_unlock(&priv->fs.tc.t_lock);
+	mutex_unlock(&priv->fs.tc->t_lock);
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		mlx5e_detach_mod_hdr(priv, flow);
@@ -4021,7 +4021,7 @@ static struct rhashtable *get_tc_ht(struct mlx5e_priv *priv,
 		rpriv = priv->ppriv;
 		return &rpriv->tc_ht;
 	} else /* NIC offload */
-		return &priv->fs.tc.ht;
+		return &priv->fs.tc->ht;
 }
 
 static bool is_peer_flow_needed(struct mlx5e_tc_flow *flow)
@@ -4740,11 +4740,11 @@ static void mlx5e_tc_hairpin_update_dead_peer(struct mlx5e_priv *priv,
 
 	peer_vhca_id = MLX5_CAP_GEN(peer_mdev, vhca_id);
 
-	mutex_lock(&priv->fs.tc.hairpin_tbl_lock);
-	hash_for_each(priv->fs.tc.hairpin_tbl, bkt, hpe, hairpin_hlist)
+	mutex_lock(&priv->fs.tc->hairpin_tbl_lock);
+	hash_for_each(priv->fs.tc->hairpin_tbl, bkt, hpe, hairpin_hlist)
 		if (refcount_inc_not_zero(&hpe->refcnt))
 			list_add(&hpe->dead_peer_wait_list, &init_wait_list);
-	mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
+	mutex_unlock(&priv->fs.tc->hairpin_tbl_lock);
 
 	list_for_each_entry_safe(hpe, tmp, &init_wait_list, dead_peer_wait_list) {
 		wait_for_completion(&hpe->res_ready);
@@ -4759,7 +4759,6 @@ static int mlx5e_tc_netdev_event(struct notifier_block *this,
 				 unsigned long event, void *ptr)
 {
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
-	struct mlx5e_flow_steering *fs;
 	struct mlx5e_priv *peer_priv;
 	struct mlx5e_tc_table *tc;
 	struct mlx5e_priv *priv;
@@ -4770,8 +4769,7 @@ static int mlx5e_tc_netdev_event(struct notifier_block *this,
 		return NOTIFY_DONE;
 
 	tc = container_of(this, struct mlx5e_tc_table, netdevice_nb);
-	fs = container_of(tc, struct mlx5e_flow_steering, tc);
-	priv = container_of(fs, struct mlx5e_priv, fs);
+	priv = tc->priv;
 	peer_priv = netdev_priv(ndev);
 	if (priv == peer_priv ||
 	    !(priv->netdev->features & NETIF_F_HW_TC))
@@ -4800,7 +4798,7 @@ static int mlx5e_tc_nic_get_ft_size(struct mlx5_core_dev *dev)
 
 static int mlx5e_tc_nic_create_miss_table(struct mlx5e_priv *priv)
 {
-	struct mlx5_flow_table **ft = &priv->fs.tc.miss_t;
+	struct mlx5_flow_table **ft = &priv->fs.tc->miss_t;
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_namespace *ns;
 	int err = 0;
@@ -4822,12 +4820,12 @@ static int mlx5e_tc_nic_create_miss_table(struct mlx5e_priv *priv)
 
 static void mlx5e_tc_nic_destroy_miss_table(struct mlx5e_priv *priv)
 {
-	mlx5_destroy_flow_table(priv->fs.tc.miss_t);
+	mlx5_destroy_flow_table(priv->fs.tc->miss_t);
 }
 
 int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 {
-	struct mlx5e_tc_table *tc = &priv->fs.tc;
+	struct mlx5e_tc_table *tc = priv->fs.tc;
 	struct mlx5_core_dev *dev = priv->mdev;
 	struct mapping_ctx *chains_mapping;
 	struct mlx5_chains_attr attr = {};
@@ -4838,6 +4836,7 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	mutex_init(&tc->t_lock);
 	mutex_init(&tc->hairpin_tbl_lock);
 	hash_init(tc->hairpin_tbl);
+	tc->priv = priv;
 
 	err = rhashtable_init(&tc->ht, &tc_ht_params);
 	if (err)
@@ -4867,7 +4866,7 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	attr.ns = MLX5_FLOW_NAMESPACE_KERNEL;
 	attr.max_ft_sz = mlx5e_tc_nic_get_ft_size(dev);
 	attr.max_grp_num = MLX5E_TC_TABLE_NUM_GROUPS;
-	attr.default_ft = priv->fs.tc.miss_t;
+	attr.default_ft = priv->fs.tc->miss_t;
 	attr.mapping = chains_mapping;
 
 	tc->chains = mlx5_chains_create(dev, &attr);
@@ -4877,7 +4876,7 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	}
 
 	tc->post_act = mlx5e_tc_post_act_init(priv, tc->chains, MLX5_FLOW_NAMESPACE_KERNEL);
-	tc->ct = mlx5_tc_ct_init(priv, tc->chains, &priv->fs.tc.mod_hdr,
+	tc->ct = mlx5_tc_ct_init(priv, tc->chains, &tc->mod_hdr,
 				 MLX5_FLOW_NAMESPACE_KERNEL, tc->post_act);
 
 	tc->netdevice_nb.notifier_call = mlx5e_tc_netdev_event;
@@ -4916,7 +4915,7 @@ static void _mlx5e_tc_del_flow(void *ptr, void *arg)
 
 void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 {
-	struct mlx5e_tc_table *tc = &priv->fs.tc;
+	struct mlx5e_tc_table *tc = priv->fs.tc;
 
 	if (tc->netdevice_nb.notifier_call)
 		unregister_netdevice_notifier_dev_net(priv->netdev,
@@ -5121,7 +5120,7 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	u32 chain = 0, chain_tag, reg_b, zone_restore_id;
 	struct mlx5e_priv *priv = netdev_priv(skb->dev);
-	struct mlx5e_tc_table *tc = &priv->fs.tc;
+	struct mlx5e_tc_table *tc = priv->fs.tc;
 	struct mlx5_mapped_obj mapped_obj;
 	struct tc_skb_ext *tc_skb_ext;
 	int err;
-- 
2.37.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60673275164
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgIWGYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgIWGYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 02:24:46 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3544A2223E;
        Wed, 23 Sep 2020 06:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600842285;
        bh=pkLLh0tLFK0sIPQsZB+2tl0OzqH/vSbMIkhrryzrJQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2XnFz5R48MPYBGRRIdYn+KxyFnDJXvxm5jUjF9QaZenVpW+OGcexjb8G3xTxbdKLn
         mBynkbTuYjuAifj8/V3YCKQ4PWuFGv3VGZwjVFVPrqda/oeyEN+D73o3HYzswJm38Z
         2PonZLERzcm8cNoqp2zJKmmmofcomE8wsqjeDW1M=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: Keep direct reference to mlx5_core_dev in tc ct
Date:   Tue, 22 Sep 2020 23:24:34 -0700
Message-Id: <20200923062438.15997-12-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923062438.15997-1-saeed@kernel.org>
References: <20200923062438.15997-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

Keep and use a direct reference to the mlx5 core device in all of
tc_ct code instead of accessing it via a pointer to mlx5 eswitch
in order to support nic mode ct offload for VF devices that don't
have a valid eswitch pointer set.

Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 37 +++++++++----------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index fe78de54179e..b5f8ed30047b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -39,7 +39,7 @@
 	netdev_dbg(ct_priv->netdev, "ct_debug: " fmt "\n", ##args)
 
 struct mlx5_tc_ct_priv {
-	struct mlx5_eswitch *esw;
+	struct mlx5_core_dev *dev;
 	const struct net_device *netdev;
 	struct mod_hdr_tbl *mod_hdr_tbl;
 	struct idr fte_ids;
@@ -397,7 +397,7 @@ mlx5_tc_ct_shared_counter_put(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_en
 	if (!refcount_dec_and_test(&entry->shared_counter->refcount))
 		return;
 
-	mlx5_fc_destroy(ct_priv->esw->dev, entry->shared_counter->counter);
+	mlx5_fc_destroy(ct_priv->dev, entry->shared_counter->counter);
 	kfree(entry->shared_counter);
 }
 
@@ -412,7 +412,7 @@ mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
 	ct_dbg("Deleting ct entry rule in zone %d", entry->tuple.zone);
 
 	mlx5_tc_rule_delete(netdev_priv(ct_priv->netdev), zone_rule->rule, attr);
-	mlx5e_mod_hdr_detach(ct_priv->esw->dev,
+	mlx5e_mod_hdr_detach(ct_priv->dev,
 			     ct_priv->mod_hdr_tbl, zone_rule->mh);
 	mapping_remove(ct_priv->labels_mapping, attr->ct_attr.ct_labels_id);
 	kfree(attr);
@@ -424,7 +424,6 @@ mlx5_tc_ct_entry_del_rules(struct mlx5_tc_ct_priv *ct_priv,
 {
 	mlx5_tc_ct_entry_del_rule(ct_priv, entry, true);
 	mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
-
 }
 
 static struct flow_action_entry *
@@ -451,25 +450,25 @@ mlx5_tc_ct_entry_set_registers(struct mlx5_tc_ct_priv *ct_priv,
 			       u8 zone_restore_id)
 {
 	enum mlx5_flow_namespace_type ns = ct_priv->ns_type;
-	struct mlx5_eswitch *esw = ct_priv->esw;
+	struct mlx5_core_dev *dev = ct_priv->dev;
 	int err;
 
-	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts, ns,
+	err = mlx5e_tc_match_to_reg_set(dev, mod_acts, ns,
 					CTSTATE_TO_REG, ct_state);
 	if (err)
 		return err;
 
-	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts, ns,
+	err = mlx5e_tc_match_to_reg_set(dev, mod_acts, ns,
 					MARK_TO_REG, mark);
 	if (err)
 		return err;
 
-	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts, ns,
+	err = mlx5e_tc_match_to_reg_set(dev, mod_acts, ns,
 					LABELS_TO_REG, labels_id);
 	if (err)
 		return err;
 
-	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts, ns,
+	err = mlx5e_tc_match_to_reg_set(dev, mod_acts, ns,
 					ZONE_RESTORE_TO_REG, zone_restore_id);
 	if (err)
 		return err;
@@ -479,7 +478,7 @@ mlx5_tc_ct_entry_set_registers(struct mlx5_tc_ct_priv *ct_priv,
 	 * reg_b upon miss.
 	 */
 	if (ns != MLX5_FLOW_NAMESPACE_FDB) {
-		err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts, ns,
+		err = mlx5e_tc_match_to_reg_set(dev, mod_acts, ns,
 						NIC_ZONE_RESTORE_TO_REG, zone_restore_id);
 		if (err)
 			return err;
@@ -564,7 +563,7 @@ mlx5_tc_ct_entry_create_nat(struct mlx5_tc_ct_priv *ct_priv,
 			    struct mlx5e_tc_mod_hdr_acts *mod_acts)
 {
 	struct flow_action *flow_action = &flow_rule->action;
-	struct mlx5_core_dev *mdev = ct_priv->esw->dev;
+	struct mlx5_core_dev *mdev = ct_priv->dev;
 	struct flow_action_entry *act;
 	size_t action_size;
 	char *modact;
@@ -640,7 +639,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 	if (err)
 		goto err_mapping;
 
-	*mh = mlx5e_mod_hdr_attach(ct_priv->esw->dev,
+	*mh = mlx5e_mod_hdr_attach(ct_priv->dev,
 				   ct_priv->mod_hdr_tbl,
 				   ct_priv->ns_type,
 				   &mod_acts);
@@ -721,7 +720,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	return 0;
 
 err_rule:
-	mlx5e_mod_hdr_detach(ct_priv->esw->dev,
+	mlx5e_mod_hdr_detach(ct_priv->dev,
 			     ct_priv->mod_hdr_tbl, zone_rule->mh);
 	mapping_remove(ct_priv->labels_mapping, attr->ct_attr.ct_labels_id);
 err_mod_hdr:
@@ -737,7 +736,7 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 {
 	struct mlx5_ct_tuple rev_tuple = entry->tuple;
 	struct mlx5_ct_shared_counter *shared_counter;
-	struct mlx5_eswitch *esw = ct_priv->esw;
+	struct mlx5_core_dev *dev = ct_priv->dev;
 	struct mlx5_ct_entry *rev_entry;
 	__be16 tmp_port;
 
@@ -776,7 +775,7 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	if (!shared_counter)
 		return ERR_PTR(-ENOMEM);
 
-	shared_counter->counter = mlx5_fc_create(esw->dev, true);
+	shared_counter->counter = mlx5_fc_create(dev, true);
 	if (IS_ERR(shared_counter->counter)) {
 		ct_dbg("Failed to create counter for ct entry");
 		kfree(shared_counter);
@@ -1159,7 +1158,7 @@ static int tc_ct_pre_ct_add_rules(struct mlx5_ct_ft *ct_ft,
 {
 	struct mlx5_tc_ct_priv *ct_priv = ct_ft->ct_priv;
 	struct mlx5e_tc_mod_hdr_acts pre_mod_acts = {};
-	struct mlx5_core_dev *dev = ct_priv->esw->dev;
+	struct mlx5_core_dev *dev = ct_priv->dev;
 	struct mlx5_flow_table *ft = pre_ct->ft;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act flow_act = {};
@@ -1246,7 +1245,7 @@ tc_ct_pre_ct_del_rules(struct mlx5_ct_ft *ct_ft,
 		       struct mlx5_tc_ct_pre *pre_ct)
 {
 	struct mlx5_tc_ct_priv *ct_priv = ct_ft->ct_priv;
-	struct mlx5_core_dev *dev = ct_priv->esw->dev;
+	struct mlx5_core_dev *dev = ct_priv->dev;
 
 	mlx5_del_flow_rules(pre_ct->flow_rule);
 	mlx5_del_flow_rules(pre_ct->miss_rule);
@@ -1260,7 +1259,7 @@ mlx5_tc_ct_alloc_pre_ct(struct mlx5_ct_ft *ct_ft,
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_tc_ct_priv *ct_priv = ct_ft->ct_priv;
-	struct mlx5_core_dev *dev = ct_priv->esw->dev;
+	struct mlx5_core_dev *dev = ct_priv->dev;
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_namespace *ns;
 	struct mlx5_flow_table *ft;
@@ -1932,8 +1931,8 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 
 	ct_priv->ns_type = ns_type;
 	ct_priv->chains = chains;
-	ct_priv->esw = priv->mdev->priv.eswitch;
 	ct_priv->netdev = priv->netdev;
+	ct_priv->dev = priv->mdev;
 	ct_priv->mod_hdr_tbl = mod_hdr;
 	ct_priv->ct = mlx5_chains_create_global_table(chains);
 	if (IS_ERR(ct_priv->ct)) {
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3EB69B8E1
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 10:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjBRJFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 04:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjBRJFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 04:05:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E9B48E3D
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 01:05:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DB56B821FE
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 09:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB8BC433D2;
        Sat, 18 Feb 2023 09:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676711127;
        bh=BWTYODeRR3BNIEnxMUNZbZGNJ2RaeZ8GV3S4BZ8U1Yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRjo4ZzwFS9CCkynBuXmSAXImpjzDrjP3O4NGpXSm6tXNFsz6aQYEnZBsYiHafkDu
         KyAbTtHFpsb++8+fpby1DRXkrPkUXSuOaMRAxo8vTQniq1WsZFjtVTAyk4uiaKv5BE
         2LK/D2cjaexHGRVF9LaN4zHXDuYl7SwVXISkE3I5VafdzlzNF6U2xqK2uut+qbsJN/
         +NbW+noEy7CRXsQzpPJa54BcLyxnDHP9wtP6QZe6si+pSIjeEwwradYAflvzyC/tFO
         s5eLwaqFO+cWhYlsnGBTdtDCYO59aNL2azfLPQjM5AmyFfnbGXzQ1EbezWaMU0szlw
         DUvF7SHVZHy0Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: [net-next V2 5/9] net/mlx5e: Implement CT entry update
Date:   Sat, 18 Feb 2023 01:05:09 -0800
Message-Id: <20230218090513.284718-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230218090513.284718-1-saeed@kernel.org>
References: <20230218090513.284718-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

With support for UDP NEW offload the flow_table may now send updates for
existing flows. Support properly replacing existing entries by updating
flow restore_cookie and replacing the rule with new one with the same match
but new mod_hdr action that sets updated ctinfo.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 118 +++++++++++++++++-
 1 file changed, 117 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 193562c14c44..a7e0ab69fecf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -871,6 +871,68 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	return err;
 }
 
+static int
+mlx5_tc_ct_entry_replace_rule(struct mlx5_tc_ct_priv *ct_priv,
+			      struct flow_rule *flow_rule,
+			      struct mlx5_ct_entry *entry,
+			      bool nat, u8 zone_restore_id)
+{
+	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
+	struct mlx5_flow_attr *attr = zone_rule->attr, *old_attr;
+	struct mlx5e_mod_hdr_handle *mh;
+	struct mlx5_ct_fs_rule *rule;
+	struct mlx5_flow_spec *spec;
+	int err;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	old_attr = mlx5_alloc_flow_attr(ct_priv->ns_type);
+	if (!old_attr) {
+		err = -ENOMEM;
+		goto err_attr;
+	}
+	*old_attr = *attr;
+
+	err = mlx5_tc_ct_entry_create_mod_hdr(ct_priv, attr, flow_rule, &mh, zone_restore_id,
+					      nat, mlx5_tc_ct_entry_has_nat(entry));
+	if (err) {
+		ct_dbg("Failed to create ct entry mod hdr");
+		goto err_mod_hdr;
+	}
+
+	mlx5_tc_ct_set_tuple_match(ct_priv, spec, flow_rule);
+	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG, entry->tuple.zone, MLX5_CT_ZONE_MASK);
+
+	rule = ct_priv->fs_ops->ct_rule_add(ct_priv->fs, spec, attr, flow_rule);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		ct_dbg("Failed to add replacement ct entry rule, nat: %d", nat);
+		goto err_rule;
+	}
+
+	ct_priv->fs_ops->ct_rule_del(ct_priv->fs, zone_rule->rule);
+	zone_rule->rule = rule;
+	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, old_attr, zone_rule->mh);
+	zone_rule->mh = mh;
+
+	kfree(old_attr);
+	kvfree(spec);
+	ct_dbg("Replaced ct entry rule in zone %d", entry->tuple.zone);
+
+	return 0;
+
+err_rule:
+	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, zone_rule->attr, mh);
+	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
+err_mod_hdr:
+	kfree(old_attr);
+err_attr:
+	kvfree(spec);
+	return err;
+}
+
 static bool
 mlx5_tc_ct_entry_valid(struct mlx5_ct_entry *entry)
 {
@@ -1065,6 +1127,52 @@ mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
 	return err;
 }
 
+static int
+mlx5_tc_ct_entry_replace_rules(struct mlx5_tc_ct_priv *ct_priv,
+			       struct flow_rule *flow_rule,
+			       struct mlx5_ct_entry *entry,
+			       u8 zone_restore_id)
+{
+	int err;
+
+	err = mlx5_tc_ct_entry_replace_rule(ct_priv, flow_rule, entry, false,
+					    zone_restore_id);
+	if (err)
+		return err;
+
+	err = mlx5_tc_ct_entry_replace_rule(ct_priv, flow_rule, entry, true,
+					    zone_restore_id);
+	if (err)
+		mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
+	return err;
+}
+
+static int
+mlx5_tc_ct_block_flow_offload_replace(struct mlx5_ct_ft *ft, struct flow_rule *flow_rule,
+				      struct mlx5_ct_entry *entry, unsigned long cookie)
+{
+	struct mlx5_tc_ct_priv *ct_priv = ft->ct_priv;
+	int err;
+
+	err = mlx5_tc_ct_entry_replace_rules(ct_priv, flow_rule, entry, ft->zone_restore_id);
+	if (!err)
+		return 0;
+
+	/* If failed to update the entry, then look it up again under ht_lock
+	 * protection and properly delete it.
+	 */
+	spin_lock_bh(&ct_priv->ht_lock);
+	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie, cts_ht_params);
+	if (entry) {
+		rhashtable_remove_fast(&ft->ct_entries_ht, &entry->node, cts_ht_params);
+		spin_unlock_bh(&ct_priv->ht_lock);
+		mlx5_tc_ct_entry_put(entry);
+	} else {
+		spin_unlock_bh(&ct_priv->ht_lock);
+	}
+	return err;
+}
+
 static int
 mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 				  struct flow_cls_offload *flow)
@@ -1087,9 +1195,17 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 	spin_lock_bh(&ct_priv->ht_lock);
 	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie, cts_ht_params);
 	if (entry && refcount_inc_not_zero(&entry->refcnt)) {
+		if (entry->restore_cookie == meta_action->ct_metadata.cookie) {
+			spin_unlock_bh(&ct_priv->ht_lock);
+			mlx5_tc_ct_entry_put(entry);
+			return -EEXIST;
+		}
+		entry->restore_cookie = meta_action->ct_metadata.cookie;
 		spin_unlock_bh(&ct_priv->ht_lock);
+
+		err = mlx5_tc_ct_block_flow_offload_replace(ft, flow_rule, entry, cookie);
 		mlx5_tc_ct_entry_put(entry);
-		return -EEXIST;
+		return err;
 	}
 	spin_unlock_bh(&ct_priv->ht_lock);
 
-- 
2.39.1


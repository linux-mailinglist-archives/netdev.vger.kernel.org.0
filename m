Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837B3350804
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbhCaURH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:17:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236460AbhCaUQh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 16:16:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C14F610A0;
        Wed, 31 Mar 2021 20:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617221797;
        bh=wymT3bUgHQ2B3rPs+Od8GE3omoldf3+OGvS855VdeF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dir9AKAHOCKBoBoZUvwZ+mFhgP78zR/AjehN6fKK99ipvQ9nMPHnG3R/ZdT0JY4Xb
         cQMwslB9cqeLdKXhHyFlK9T/kymDojYIJuyXxjLeFA3OXljqKyiPHeFkIgVUTdTP4k
         y54AOZZvFZe5fVNXLMsih0siz0T4cNln1mpJS/k30VdmKZMF4crAojNlo3vbQSPHQx
         nfqkX5g7I0VWAhUH8JC+PJmROEcTpgTck5JHtouAxOgZVAVAGkcdr9xlyvjmaBzdrL
         Zk558k22tccLDxk2xO2JYe17XoUTvwhKmG9wATZpnuwAcQfMeSjpehboxgUVgbX3gN
         LDIuaqge5iNnQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/9] net/mlx5e: Fix mapping of ct_label zero
Date:   Wed, 31 Mar 2021 13:14:16 -0700
Message-Id: <20210331201424.331095-2-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210331201424.331095-1-saeed@kernel.org>
References: <20210331201424.331095-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

ct_label 0 is a default label each flow has and therefore
there can be rules that match on ct_label=0 without a prior
rule that set the ct_label to this value.

The ct_label value is not used directly in the HW rules and
instead it is mapped to some id within a defined range and this
id is used to set and match the metadata register which carries
the ct_label.

If we have a rule that matches on ct_label=0, the hw rule will
perform matching on a value that is != 0 because of the mapping
from label to id. Since the metadata register default value is
0 and it was never set before to anything else by an action that
sets the ct_label, there will always be a mismatch between that
register and the value in the rule.

To support such rule, a forced mapping of ct_label 0 to id=0
is done so that it will match the metadata register default
value of 0.

Fixes: 54b154ecfb8c ("net/mlx5e: CT: Map 128 bits labels to 32 bit map ID")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 36 +++++++++++++++----
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index b2cd29847a37..68e54cc1cd16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -185,6 +185,28 @@ mlx5_tc_ct_entry_has_nat(struct mlx5_ct_entry *entry)
 	return !!(entry->tuple_nat_node.next);
 }
 
+static int
+mlx5_get_label_mapping(struct mlx5_tc_ct_priv *ct_priv,
+		       u32 *labels, u32 *id)
+{
+	if (!memchr_inv(labels, 0, sizeof(u32) * 4)) {
+		*id = 0;
+		return 0;
+	}
+
+	if (mapping_add(ct_priv->labels_mapping, labels, id))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static void
+mlx5_put_label_mapping(struct mlx5_tc_ct_priv *ct_priv, u32 id)
+{
+	if (id)
+		mapping_remove(ct_priv->labels_mapping, id);
+}
+
 static int
 mlx5_tc_ct_rule_to_tuple(struct mlx5_ct_tuple *tuple, struct flow_rule *rule)
 {
@@ -436,7 +458,7 @@ mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
 	mlx5_tc_rule_delete(netdev_priv(ct_priv->netdev), zone_rule->rule, attr);
 	mlx5e_mod_hdr_detach(ct_priv->dev,
 			     ct_priv->mod_hdr_tbl, zone_rule->mh);
-	mapping_remove(ct_priv->labels_mapping, attr->ct_attr.ct_labels_id);
+	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
 	kfree(attr);
 }
 
@@ -639,8 +661,8 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 	if (!meta)
 		return -EOPNOTSUPP;
 
-	err = mapping_add(ct_priv->labels_mapping, meta->ct_metadata.labels,
-			  &attr->ct_attr.ct_labels_id);
+	err = mlx5_get_label_mapping(ct_priv, meta->ct_metadata.labels,
+				     &attr->ct_attr.ct_labels_id);
 	if (err)
 		return -EOPNOTSUPP;
 	if (nat) {
@@ -677,7 +699,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 
 err_mapping:
 	dealloc_mod_hdr_actions(&mod_acts);
-	mapping_remove(ct_priv->labels_mapping, attr->ct_attr.ct_labels_id);
+	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
 	return err;
 }
 
@@ -745,7 +767,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 err_rule:
 	mlx5e_mod_hdr_detach(ct_priv->dev,
 			     ct_priv->mod_hdr_tbl, zone_rule->mh);
-	mapping_remove(ct_priv->labels_mapping, attr->ct_attr.ct_labels_id);
+	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
 err_mod_hdr:
 	kfree(attr);
 err_attr:
@@ -1197,7 +1219,7 @@ void mlx5_tc_ct_match_del(struct mlx5_tc_ct_priv *priv, struct mlx5_ct_attr *ct_
 	if (!priv || !ct_attr->ct_labels_id)
 		return;
 
-	mapping_remove(priv->labels_mapping, ct_attr->ct_labels_id);
+	mlx5_put_label_mapping(priv, ct_attr->ct_labels_id);
 }
 
 int
@@ -1280,7 +1302,7 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 		ct_labels[1] = key->ct_labels[1] & mask->ct_labels[1];
 		ct_labels[2] = key->ct_labels[2] & mask->ct_labels[2];
 		ct_labels[3] = key->ct_labels[3] & mask->ct_labels[3];
-		if (mapping_add(priv->labels_mapping, ct_labels, &ct_attr->ct_labels_id))
+		if (mlx5_get_label_mapping(priv, ct_labels, &ct_attr->ct_labels_id))
 			return -EOPNOTSUPP;
 		mlx5e_tc_match_to_reg_match(spec, LABELS_TO_REG, ct_attr->ct_labels_id,
 					    MLX5_CT_LABELS_MASK);
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C898B392675
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbhE0EiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229825AbhE0EiF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:38:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 120D6613D4;
        Thu, 27 May 2021 04:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622090192;
        bh=YyNT5Y+HxjiYUgHOlivZQb7c3BT3RYY/zNrK/BKGxhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAOWFhkzIrv3+BF8mjHJKsd0tyM+dcOoMTV9pu2o2hAMm1OnpgYDQqWaN0R9qiXtx
         +6oTS/BcGe971pfJnLuiZ2FtmFSCG5x79GZHUUs7J5M667UXuwq98HCMTnMcnDpU4Q
         T3eq8K61S4iXWbJluvZXcp07Lgnr963VSBl0DKN7cUjJaimilTZnw9B+8bf3oNc2JO
         +fHAalaR8pWV4VefKyt4Z1s2v7ILkKhEzSSQxD9bQPW+V6KXh1QwevTDz5HpROJ/fK
         LXdqyGb8ozjACGQRYzh+Jk6HyJ1kVls5tKWbkDC4Rz2URsjLocZF9idvTdBMLsu+Jn
         nFofVh3f1e6Tw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/17] net/mlx5: CT: Avoid reusing modify header context for natted entries
Date:   Wed, 26 May 2021 21:35:54 -0700
Message-Id: <20210527043609.654854-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527043609.654854-1-saeed@kernel.org>
References: <20210527043609.654854-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Currently the driver is designed to reuse header modify context entries.
Natted entries will always have a unique modify header, as such the
modify header hashtable lookup is introducing an overhead. When the
hashtable size exceeded 200k entries the tested insertion rate dropped
from ~10k entries/sec to ~300 entries/sec.

Don't use the re-use mechanism when creating modify headers
for natted tuples.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 50 ++++++++++++++-----
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index edf19f1c19ff..e3b0fd78184e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -150,6 +150,11 @@ struct mlx5_ct_entry {
 	unsigned long flags;
 };
 
+static void
+mlx5_tc_ct_entry_destroy_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
+				 struct mlx5_flow_attr *attr,
+				 struct mlx5e_mod_hdr_handle *mh);
+
 static const struct rhashtable_params cts_ht_params = {
 	.head_offset = offsetof(struct mlx5_ct_entry, node),
 	.key_offset = offsetof(struct mlx5_ct_entry, cookie),
@@ -458,8 +463,7 @@ mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
 	ct_dbg("Deleting ct entry rule in zone %d", entry->tuple.zone);
 
 	mlx5_tc_rule_delete(netdev_priv(ct_priv->netdev), zone_rule->rule, attr);
-	mlx5e_mod_hdr_detach(ct_priv->dev,
-			     ct_priv->mod_hdr_tbl, zone_rule->mh);
+	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, zone_rule->attr, zone_rule->mh);
 	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
 	kfree(attr);
 }
@@ -686,15 +690,27 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 	if (err)
 		goto err_mapping;
 
-	*mh = mlx5e_mod_hdr_attach(ct_priv->dev,
-				   ct_priv->mod_hdr_tbl,
-				   ct_priv->ns_type,
-				   &mod_acts);
-	if (IS_ERR(*mh)) {
-		err = PTR_ERR(*mh);
-		goto err_mapping;
+	if (nat) {
+		attr->modify_hdr = mlx5_modify_header_alloc(ct_priv->dev, ct_priv->ns_type,
+							    mod_acts.num_actions,
+							    mod_acts.actions);
+		if (IS_ERR(attr->modify_hdr)) {
+			err = PTR_ERR(attr->modify_hdr);
+			goto err_mapping;
+		}
+
+		*mh = NULL;
+	} else {
+		*mh = mlx5e_mod_hdr_attach(ct_priv->dev,
+					   ct_priv->mod_hdr_tbl,
+					   ct_priv->ns_type,
+					   &mod_acts);
+		if (IS_ERR(*mh)) {
+			err = PTR_ERR(*mh);
+			goto err_mapping;
+		}
+		attr->modify_hdr = mlx5e_mod_hdr_get(*mh);
 	}
-	attr->modify_hdr = mlx5e_mod_hdr_get(*mh);
 
 	dealloc_mod_hdr_actions(&mod_acts);
 	return 0;
@@ -705,6 +721,17 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 	return err;
 }
 
+static void
+mlx5_tc_ct_entry_destroy_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
+				 struct mlx5_flow_attr *attr,
+				 struct mlx5e_mod_hdr_handle *mh)
+{
+	if (mh)
+		mlx5e_mod_hdr_detach(ct_priv->dev, ct_priv->mod_hdr_tbl, mh);
+	else
+		mlx5_modify_header_dealloc(ct_priv->dev, attr->modify_hdr);
+}
+
 static int
 mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 			  struct flow_rule *flow_rule,
@@ -767,8 +794,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	return 0;
 
 err_rule:
-	mlx5e_mod_hdr_detach(ct_priv->dev,
-			     ct_priv->mod_hdr_tbl, zone_rule->mh);
+	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, zone_rule->attr, zone_rule->mh);
 	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
 err_mod_hdr:
 	kfree(attr);
-- 
2.31.1


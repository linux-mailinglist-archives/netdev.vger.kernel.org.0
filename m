Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D65270348
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgIRR27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgIRR2x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:28:53 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ABA02311D;
        Fri, 18 Sep 2020 17:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600450132;
        bh=G2GLGZMcYoKrTv8GFfETI4VWoIoRI7y6M0e+QAagpYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ENpKRQkMKIKFPnYX7KRa4t/9aGlMNshyVwxwgMZJ5Wtyo1clfUYxQ5VGYzNWu3Ox
         eu8aOjX76AeVWOrUr3iEa8CLElR4SvGjzoQTyXUhLIaP3pN6dYSeWDMEtIwM7dSJYq
         aerywWN+yNcCro8H0WVCRiTtRYi98ivv3h4+pwX0=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/15] net/mlx5e: CT: Fix freeing ct_label mapping
Date:   Fri, 18 Sep 2020 10:28:29 -0700
Message-Id: <20200918172839.310037-6-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918172839.310037-1-saeed@kernel.org>
References: <20200918172839.310037-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

Add missing mapping remove call when removing ct rule,
as the mapping was allocated when ct rule was adding with ct_label.
Also there is a missing mapping remove call in error flow.

Fixes: 54b154ecfb8c ("net/mlx5e: CT: Map 128 bits labels to 32 bit map ID")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 21 +++++++++++----
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    | 26 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  6 +++--
 3 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index c6bc9224c3b1..bc5f72ec3623 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -699,6 +699,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 err_rule:
 	mlx5e_mod_hdr_detach(ct_priv->esw->dev,
 			     &esw->offloads.mod_hdr, zone_rule->mh);
+	mapping_remove(ct_priv->labels_mapping, attr->ct_attr.ct_labels_id);
 err_mod_hdr:
 	kfree(spec);
 	return err;
@@ -958,12 +959,22 @@ mlx5_tc_ct_add_no_trk_match(struct mlx5e_priv *priv,
 	return 0;
 }
 
+void mlx5_tc_ct_match_del(struct mlx5e_priv *priv, struct mlx5_ct_attr *ct_attr)
+{
+	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
+
+	if (!ct_priv || !ct_attr->ct_labels_id)
+		return;
+
+	mapping_remove(ct_priv->labels_mapping, ct_attr->ct_labels_id);
+}
+
 int
-mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
-		       struct mlx5_flow_spec *spec,
-		       struct flow_cls_offload *f,
-		       struct mlx5_ct_attr *ct_attr,
-		       struct netlink_ext_ack *extack)
+mlx5_tc_ct_match_add(struct mlx5e_priv *priv,
+		     struct mlx5_flow_spec *spec,
+		     struct flow_cls_offload *f,
+		     struct mlx5_ct_attr *ct_attr,
+		     struct netlink_ext_ack *extack)
 {
 	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 3baef917a677..708c216325d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -87,12 +87,15 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv);
 void
 mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv);
 
+void
+mlx5_tc_ct_match_del(struct mlx5e_priv *priv, struct mlx5_ct_attr *ct_attr);
+
 int
-mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
-		       struct mlx5_flow_spec *spec,
-		       struct flow_cls_offload *f,
-		       struct mlx5_ct_attr *ct_attr,
-		       struct netlink_ext_ack *extack);
+mlx5_tc_ct_match_add(struct mlx5e_priv *priv,
+		     struct mlx5_flow_spec *spec,
+		     struct flow_cls_offload *f,
+		     struct mlx5_ct_attr *ct_attr,
+		     struct netlink_ext_ack *extack);
 int
 mlx5_tc_ct_add_no_trk_match(struct mlx5e_priv *priv,
 			    struct mlx5_flow_spec *spec);
@@ -130,12 +133,15 @@ mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv)
 {
 }
 
+static inline void
+mlx5_tc_ct_match_del(struct mlx5e_priv *priv, struct mlx5_ct_attr *ct_attr) {}
+
 static inline int
-mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
-		       struct mlx5_flow_spec *spec,
-		       struct flow_cls_offload *f,
-		       struct mlx5_ct_attr *ct_attr,
-		       struct netlink_ext_ack *extack)
+mlx5_tc_ct_match_add(struct mlx5e_priv *priv,
+		     struct mlx5_flow_spec *spec,
+		     struct flow_cls_offload *f,
+		     struct mlx5_ct_attr *ct_attr,
+		     struct netlink_ext_ack *extack)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 7be282d2ddde..bf0c6f063941 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1312,6 +1312,8 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 		}
 	kvfree(attr->parse_attr);
 
+	mlx5_tc_ct_match_del(priv, &flow->esw_attr->ct_attr);
+
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		mlx5e_detach_mod_hdr(priv, flow);
 
@@ -4399,8 +4401,8 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 		goto err_free;
 
 	/* actions validation depends on parsing the ct matches first */
-	err = mlx5_tc_ct_parse_match(priv, &parse_attr->spec, f,
-				     &flow->esw_attr->ct_attr, extack);
+	err = mlx5_tc_ct_match_add(priv, &parse_attr->spec, f,
+				   &flow->esw_attr->ct_attr, extack);
 	if (err)
 		goto err_free;
 
-- 
2.26.2


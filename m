Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A82D4C1FF7
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244988AbiBWXkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244970AbiBWXkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:40:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9925B8B6;
        Wed, 23 Feb 2022 15:39:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0403D61994;
        Wed, 23 Feb 2022 23:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FEFC340EB;
        Wed, 23 Feb 2022 23:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645659580;
        bh=eKlvFR+Cs49zIzqh8w++OOKU/H0cr8G92YPcgDlWAsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FmjcGJoCbMXRFYE2/YgHx1W/L4r/81ND9sqaPl7gEUOJmrPYzaNsdVcE84nmiVx+A
         eUl4T7vAbIhFbrG3PqWy9eU7Pl/Wnc+kngZyaHzxr1aZ3/R3uNtwPg3lf7vbii3AqV
         hj7xbLoPt5sAZiUwAf55rd6yrjSqNCs5pyFLquuiSxPG8aZ2G8uk/nmKr7T5rRbw15
         utcUx6OL2caPBJYfKgvq/seVqAw67KRaRZkgwGiIm3onLD57KK0DZSBDEhHcF9dSaG
         VDr5MJqkHc+fIhOFeZ+d/EfuBDeLjRwohUwvZcvSC9aXSMoe13fXzrNW9/JuiXEG6F
         qtYYDpbpvEmsQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [for-next v2 05/17] net/mlx5: E-switch, add drop rule support to ingress ACL
Date:   Wed, 23 Feb 2022 15:39:18 -0800
Message-Id: <20220223233930.319301-6-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223233930.319301-1-saeed@kernel.org>
References: <20220223233930.319301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Support inserting an ingress ACL drop rule on the uplink in
switchdev mode. This will be used by downstream patches to offload
active-backup lag mode. The drop rule (if created) is the first rule
in the ACL.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c | 87 +++++++++++++++++++
 .../mellanox/mlx5/core/esw/acl/ofld.h         | 15 ++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  3 +
 3 files changed, 105 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
index 39e948bc1204..a994e71e05c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
@@ -92,6 +92,7 @@ static int esw_acl_ingress_mod_metadata_create(struct mlx5_eswitch *esw,
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_MOD_HDR | MLX5_FLOW_CONTEXT_ACTION_ALLOW;
 	flow_act.modify_hdr = vport->ingress.offloads.modify_metadata;
+	flow_act.fg = vport->ingress.offloads.metadata_allmatch_grp;
 	vport->ingress.offloads.modify_metadata_rule =
 				mlx5_add_flow_rules(vport->ingress.acl,
 						    NULL, &flow_act, NULL, 0);
@@ -117,6 +118,36 @@ static void esw_acl_ingress_mod_metadata_destroy(struct mlx5_eswitch *esw,
 	vport->ingress.offloads.modify_metadata_rule = NULL;
 }
 
+static int esw_acl_ingress_src_port_drop_create(struct mlx5_eswitch *esw,
+						struct mlx5_vport *vport)
+{
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_flow_handle *flow_rule;
+	int err = 0;
+
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
+	flow_act.fg = vport->ingress.offloads.drop_grp;
+	flow_rule = mlx5_add_flow_rules(vport->ingress.acl, NULL, &flow_act, NULL, 0);
+	if (IS_ERR(flow_rule)) {
+		err = PTR_ERR(flow_rule);
+		goto out;
+	}
+
+	vport->ingress.offloads.drop_rule = flow_rule;
+out:
+	return err;
+}
+
+static void esw_acl_ingress_src_port_drop_destroy(struct mlx5_eswitch *esw,
+						  struct mlx5_vport *vport)
+{
+	if (!vport->ingress.offloads.drop_rule)
+		return;
+
+	mlx5_del_flow_rules(vport->ingress.offloads.drop_rule);
+	vport->ingress.offloads.drop_rule = NULL;
+}
+
 static int esw_acl_ingress_ofld_rules_create(struct mlx5_eswitch *esw,
 					     struct mlx5_vport *vport)
 {
@@ -154,6 +185,7 @@ static void esw_acl_ingress_ofld_rules_destroy(struct mlx5_eswitch *esw,
 {
 	esw_acl_ingress_allow_rule_destroy(vport);
 	esw_acl_ingress_mod_metadata_destroy(esw, vport);
+	esw_acl_ingress_src_port_drop_destroy(esw, vport);
 }
 
 static int esw_acl_ingress_ofld_groups_create(struct mlx5_eswitch *esw,
@@ -170,10 +202,29 @@ static int esw_acl_ingress_ofld_groups_create(struct mlx5_eswitch *esw,
 	if (!flow_group_in)
 		return -ENOMEM;
 
+	if (vport->vport == MLX5_VPORT_UPLINK) {
+		/* This group can hold an FTE to drop all traffic.
+		 * Need in case LAG is enabled.
+		 */
+		MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, flow_index);
+		MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, flow_index);
+
+		g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
+		if (IS_ERR(g)) {
+			ret = PTR_ERR(g);
+			esw_warn(esw->dev, "vport[%d] ingress create drop flow group, err(%d)\n",
+				 vport->vport, ret);
+			goto drop_err;
+		}
+		vport->ingress.offloads.drop_grp = g;
+		flow_index++;
+	}
+
 	if (esw_acl_ingress_prio_tag_enabled(esw, vport)) {
 		/* This group is to hold FTE to match untagged packets when prio_tag
 		 * is enabled.
 		 */
+		memset(flow_group_in, 0, inlen);
 		match_criteria = MLX5_ADDR_OF(create_flow_group_in,
 					      flow_group_in, match_criteria);
 		MLX5_SET(create_flow_group_in, flow_group_in,
@@ -221,6 +272,11 @@ static int esw_acl_ingress_ofld_groups_create(struct mlx5_eswitch *esw,
 		vport->ingress.offloads.metadata_prio_tag_grp = NULL;
 	}
 prio_tag_err:
+	if (!IS_ERR_OR_NULL(vport->ingress.offloads.drop_grp)) {
+		mlx5_destroy_flow_group(vport->ingress.offloads.drop_grp);
+		vport->ingress.offloads.drop_grp = NULL;
+	}
+drop_err:
 	kvfree(flow_group_in);
 	return ret;
 }
@@ -236,6 +292,11 @@ static void esw_acl_ingress_ofld_groups_destroy(struct mlx5_vport *vport)
 		mlx5_destroy_flow_group(vport->ingress.offloads.metadata_prio_tag_grp);
 		vport->ingress.offloads.metadata_prio_tag_grp = NULL;
 	}
+
+	if (vport->ingress.offloads.drop_grp) {
+		mlx5_destroy_flow_group(vport->ingress.offloads.drop_grp);
+		vport->ingress.offloads.drop_grp = NULL;
+	}
 }
 
 int esw_acl_ingress_ofld_setup(struct mlx5_eswitch *esw,
@@ -252,6 +313,8 @@ int esw_acl_ingress_ofld_setup(struct mlx5_eswitch *esw,
 
 	if (mlx5_eswitch_vport_match_metadata_enabled(esw))
 		num_ftes++;
+	if (vport->vport == MLX5_VPORT_UPLINK)
+		num_ftes++;
 	if (esw_acl_ingress_prio_tag_enabled(esw, vport))
 		num_ftes++;
 
@@ -320,3 +383,27 @@ int mlx5_esw_acl_ingress_vport_bond_update(struct mlx5_eswitch *esw, u16 vport_n
 	vport->metadata = vport->default_metadata;
 	return err;
 }
+
+int mlx5_esw_acl_ingress_vport_drop_rule_create(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	struct mlx5_vport *vport = mlx5_eswitch_get_vport(esw, vport_num);
+
+	if (IS_ERR(vport)) {
+		esw_warn(esw->dev, "vport(%d) invalid!\n", vport_num);
+		return PTR_ERR(vport);
+	}
+
+	return esw_acl_ingress_src_port_drop_create(esw, vport);
+}
+
+void mlx5_esw_acl_ingress_vport_drop_rule_destroy(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	struct mlx5_vport *vport = mlx5_eswitch_get_vport(esw, vport_num);
+
+	if (WARN_ON_ONCE(IS_ERR(vport))) {
+		esw_warn(esw->dev, "vport(%d) invalid!\n", vport_num);
+		return;
+	}
+
+	esw_acl_ingress_src_port_drop_destroy(esw, vport);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
index c57869b93d60..11d3d3978848 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
@@ -6,6 +6,7 @@
 
 #include "eswitch.h"
 
+#ifdef CONFIG_MLX5_ESWITCH
 /* Eswitch acl egress external APIs */
 int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 void esw_acl_egress_ofld_cleanup(struct mlx5_vport *vport);
@@ -25,5 +26,19 @@ int esw_acl_ingress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vpor
 void esw_acl_ingress_ofld_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 int mlx5_esw_acl_ingress_vport_bond_update(struct mlx5_eswitch *esw, u16 vport_num,
 					   u32 metadata);
+void mlx5_esw_acl_ingress_vport_drop_rule_destroy(struct mlx5_eswitch *esw, u16 vport_num);
+int mlx5_esw_acl_ingress_vport_drop_rule_create(struct mlx5_eswitch *esw, u16 vport_num);
 
+#else /* CONFIG_MLX5_ESWITCH */
+static void
+mlx5_esw_acl_ingress_vport_drop_rule_destroy(struct mlx5_eswitch *esw,
+					     u16 vport_num)
+{}
+
+static int mlx5_esw_acl_ingress_vport_drop_rule_create(struct mlx5_eswitch *esw,
+						       u16 vport_num)
+{
+	return 0;
+}
+#endif /* CONFIG_MLX5_ESWITCH */
 #endif /* __MLX5_ESWITCH_ACL_OFLD_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index ead5e8acc8be..1d01e6ee6ef1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -113,8 +113,11 @@ struct vport_ingress {
 		 * packet with metadata.
 		 */
 		struct mlx5_flow_group *metadata_allmatch_grp;
+		/* Optional group to add a drop all rule */
+		struct mlx5_flow_group *drop_grp;
 		struct mlx5_modify_hdr *modify_metadata;
 		struct mlx5_flow_handle *modify_metadata_rule;
+		struct mlx5_flow_handle *drop_rule;
 	} offloads;
 };
 
-- 
2.35.1


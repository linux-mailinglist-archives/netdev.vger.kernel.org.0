Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33C3640F02
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbiLBUP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbiLBUPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:15:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB51F233C
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:15:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62E15B82289
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D89C433C1;
        Fri,  2 Dec 2022 20:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670012147;
        bh=9U7b9OdmB6Weqc+OG3tIC9SO/e1m7JqmgZemgxkWv7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HsH/mrndGIiX35hI6sfxssULuKoa/0kFR3lMWCULpcTJLKGgsTU9preNK7opzhssd
         2v3372xy/UZCJjQvfDZM/ok4rwtkhh9Q9ZoXwpFchfTbIJnrM/3YFT58uHSJ+lvf9h
         Bh9AI/cNwIRkm78VD+zV0EHT8naMBNnNZ27yGcdcvjWeFfzpxvfhExSY1x/nmFtu8C
         qKIV26UckoI8wzAeoj2H9sH2XlVAJSxnbXI0Gv6V9ymmKb6x9F0BwWTM7VAQ2fl1DN
         tDsU6uovCN2LR+geogl0YZgA1EtiMpnM1WlISl5PNFPgFeWP5wlcWR/C9imfjxyWAI
         zpd8SMJsey4xQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 07/13] net/mlx5e: Skip IPsec encryption for TX path without matching policy
Date:   Fri,  2 Dec 2022 22:14:51 +0200
Message-Id: <fcbdca451b92435919daf827a18cfb5c2badf9c4.1670011885.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011885.git.leonro@nvidia.com>
References: <cover.1670011885.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Software implementation of IPsec skips encryption of packets in TX
path if no matching policy is found. So align HW implementation to
this behavior, by requiring matching reqid for offloaded policy and
SA.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  7 ++++
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  4 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 39 ++++++++++++++++---
 3 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 65f73a5c29ba..8f08dbf2206e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -184,6 +184,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	memcpy(&attrs->daddr, x->id.daddr.a6, sizeof(attrs->daddr));
 	attrs->family = x->props.family;
 	attrs->type = x->xso.type;
+	attrs->reqid = x->props.reqid;
 }
 
 static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
@@ -267,6 +268,11 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 				    x->replay_esn->replay_window);
 			return -EINVAL;
 		}
+
+		if (!x->props.reqid) {
+			netdev_info(netdev, "Cannot offload without reqid\n");
+			return -EINVAL;
+		}
 	}
 	return 0;
 }
@@ -503,6 +509,7 @@ mlx5e_ipsec_build_accel_pol_attrs(struct mlx5e_ipsec_pol_entry *pol_entry,
 	attrs->dir = x->xdo.dir;
 	attrs->action = x->action;
 	attrs->type = XFRM_DEV_OFFLOAD_PACKET;
+	attrs->reqid = x->xfrm_vec[0].reqid;
 }
 
 static int mlx5e_xfrm_add_policy(struct xfrm_policy *x)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 2e7654e90314..492be255d267 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -77,6 +77,7 @@ struct mlx5_accel_esp_xfrm_attrs {
 	u8 family;
 	u32 replay_window;
 	u32 authsize;
+	u32 reqid;
 };
 
 enum mlx5_ipsec_cap {
@@ -178,12 +179,13 @@ struct mlx5_accel_pol_xfrm_attrs {
 	u8 action;
 	u8 type : 2;
 	u8 dir : 2;
+	u32 reqid;
 };
 
 struct mlx5e_ipsec_pol_entry {
 	struct xfrm_policy *x;
 	struct mlx5e_ipsec *ipsec;
-	struct mlx5_flow_handle *rule;
+	struct mlx5e_ipsec_rule ipsec_rule;
 	struct mlx5_accel_pol_xfrm_attrs attrs;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 8ba92b00afdb..9f19f4b59a70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -456,6 +456,17 @@ static void setup_fte_reg_a(struct mlx5_flow_spec *spec)
 		 misc_parameters_2.metadata_reg_a, MLX5_ETH_WQE_FT_META_IPSEC);
 }
 
+static void setup_fte_reg_c0(struct mlx5_flow_spec *spec, u32 reqid)
+{
+	/* Pass policy check before choosing this SA */
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
+
+	MLX5_SET(fte_match_param, spec->match_criteria,
+		 misc_parameters_2.metadata_reg_c_0, reqid);
+	MLX5_SET(fte_match_param, spec->match_value,
+		 misc_parameters_2.metadata_reg_c_0, reqid);
+}
+
 static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
 			       struct mlx5_flow_act *flow_act)
 {
@@ -470,6 +481,11 @@ static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
 			 MLX5_ACTION_IN_FIELD_METADATA_REG_B);
 		ns_type = MLX5_FLOW_NAMESPACE_KERNEL;
 		break;
+	case XFRM_DEV_OFFLOAD_OUT:
+		MLX5_SET(set_action_in, action, field,
+			 MLX5_ACTION_IN_FIELD_METADATA_REG_C_0);
+		ns_type = MLX5_FLOW_NAMESPACE_EGRESS;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -646,6 +662,7 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		setup_fte_reg_a(spec);
 		break;
 	case XFRM_DEV_OFFLOAD_PACKET:
+		setup_fte_reg_c0(spec, attrs->reqid);
 		err = setup_pkt_reformat(mdev, attrs, &flow_act);
 		if (err)
 			goto err_pkt_reformat;
@@ -712,6 +729,11 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 
 	setup_fte_no_frags(spec);
 
+	err = setup_modify_header(mdev, attrs->reqid, XFRM_DEV_OFFLOAD_OUT,
+				  &flow_act);
+	if (err)
+		goto err_mod_header;
+
 	switch (attrs->action) {
 	case XFRM_POLICY_ALLOW:
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
@@ -741,10 +763,13 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 	}
 
 	kvfree(spec);
-	pol_entry->rule = rule;
+	pol_entry->ipsec_rule.rule = rule;
+	pol_entry->ipsec_rule.modify_hdr = flow_act.modify_hdr;
 	return 0;
 
 err_action:
+	mlx5_modify_header_dealloc(mdev, flow_act.modify_hdr);
+err_mod_header:
 	kvfree(spec);
 err_alloc:
 	tx_ft_put(pol_entry->ipsec);
@@ -807,7 +832,7 @@ static int rx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 	}
 
 	kvfree(spec);
-	pol_entry->rule = rule;
+	pol_entry->ipsec_rule.rule = rule;
 	return 0;
 
 err_action:
@@ -964,16 +989,18 @@ int mlx5e_accel_ipsec_fs_add_pol(struct mlx5e_ipsec_pol_entry *pol_entry)
 
 void mlx5e_accel_ipsec_fs_del_pol(struct mlx5e_ipsec_pol_entry *pol_entry)
 {
+	struct mlx5e_ipsec_rule *ipsec_rule = &pol_entry->ipsec_rule;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_pol2dev(pol_entry);
 
-	mlx5_del_flow_rules(pol_entry->rule);
+	mlx5_del_flow_rules(ipsec_rule->rule);
 
-	if (pol_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT) {
-		tx_ft_put(pol_entry->ipsec);
+	if (pol_entry->attrs.dir == XFRM_DEV_OFFLOAD_IN) {
+		rx_ft_put(mdev, pol_entry->ipsec, pol_entry->attrs.family);
 		return;
 	}
 
-	rx_ft_put(mdev, pol_entry->ipsec, pol_entry->attrs.family);
+	mlx5_modify_header_dealloc(mdev, ipsec_rule->modify_hdr);
+	tx_ft_put(pol_entry->ipsec);
 }
 
 void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
-- 
2.38.1


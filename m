Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F8B595A13
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiHPL0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbiHPL0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:26:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF683ECE7
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:41:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B76960FBE
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61175C433C1;
        Tue, 16 Aug 2022 10:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646475;
        bh=xZtcsG/8FyCVemE2shVW02VcWSUkOKH7yjkbqlz8f5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTScxYRux4iTvphszMp0wYikQvUVfOfeU7y3MsAzM/f04tKfMf8D5kZHf/3FZMfRK
         KQQeBaMlHG0pBrq808gdDiZ/ANL+LN52BGvsH6MR8vHcEGXv4/fcFzVIWvqPi9vVak
         lAUVfQ9rP3HA1E3lZBsr0glEDtZsUOD7BrahIFxpz439hR0c6hf5vasjIdykM0YD7h
         /ucLtGFyD5KU8ji6LMwIX/YYopsWp8rbFI4okDzQE0vU8XIuLz+KF8epdFnrV2lncx
         S99JM2B8f4H7R/ESxp2vkUfwmkv7u68F0U86t9StO0fUkLHIOIDGzDAeINf62iIQmM
         4UqlpBd87RDvg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 25/26] net/mlx5e: Skip IPsec encryption for TX path without matching policy
Date:   Tue, 16 Aug 2022 13:38:13 +0300
Message-Id: <51ee028577396c051604703c46bd31d706b4b387.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660641154.git.leonro@nvidia.com>
References: <cover.1660641154.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Software implementation of IPsec skips encryption of packets in TX
path if no matching policy is found. So align HW implementation to
this behavior, by requiring matching reqid for offloaded policy and
SA.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  2 +
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  4 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 39 ++++++++++++++++---
 3 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 7f93ec8ed3dc..6017aaabaabd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -187,6 +187,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	memcpy(&attrs->daddr, x->id.daddr.a6, sizeof(attrs->daddr));
 	attrs->family = x->props.family;
 	attrs->type = x->xso.type;
+	attrs->reqid = x->props.reqid;
 }
 
 static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
@@ -519,6 +520,7 @@ mlx5e_ipsec_build_accel_pol_attrs(struct mlx5e_ipsec_pol_entry *pol_entry,
 	attrs->dir = x->xdo.dir;
 	attrs->action = x->action;
 	attrs->type = XFRM_DEV_OFFLOAD_FULL;
+	attrs->reqid = x->xfrm_vec[0].reqid;
 }
 
 static int mlx5e_xfrm_add_policy(struct xfrm_policy *x)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 0fcab9ad9949..5c3ca03d21da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -77,6 +77,7 @@ struct mlx5_accel_esp_xfrm_attrs {
 	u8 family;
 	u32 replay_window;
 	u32 authsize;
+	u32 reqid;
 };
 
 enum mlx5_ipsec_cap {
@@ -173,12 +174,13 @@ struct mlx5_accel_pol_xfrm_attrs {
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
index e6b5c9526e1a..7b0071837f46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -460,6 +460,17 @@ static void setup_fte_reg_a(struct mlx5_flow_spec *spec)
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
@@ -474,6 +485,11 @@ static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
 			 MLX5_ACTION_IN_FIELD_METADATA_REG_B);
 		ns_type = MLX5_FLOW_NAMESPACE_KERNEL;
 		break;
+	case XFRM_DEV_OFFLOAD_OUT:
+		MLX5_SET(set_action_in, action, field,
+			 MLX5_ACTION_IN_FIELD_METADATA_REG_C_0);
+		ns_type = MLX5_FLOW_NAMESPACE_EGRESS_KERNEL;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -650,6 +666,7 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		setup_fte_reg_a(spec);
 		break;
 	case XFRM_DEV_OFFLOAD_FULL:
+		setup_fte_reg_c0(spec, attrs->reqid);
 		err = setup_pkt_reformat(mdev, attrs, &flow_act);
 		if (err)
 			goto err_pkt_reformat;
@@ -715,6 +732,11 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 
 	setup_fte_no_frags(spec);
 
+	err = setup_modify_header(mdev, attrs->reqid, XFRM_DEV_OFFLOAD_OUT,
+				  &flow_act);
+	if (err)
+		goto err_mod_header;
+
 	switch (attrs->action) {
 	case XFRM_POLICY_ALLOW:
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
@@ -744,10 +766,13 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
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
@@ -810,7 +835,7 @@ static int rx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
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
2.37.2


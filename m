Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2A8595A01
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbiHPL0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbiHPLZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:25:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95547FEE8F
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:39:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EF17B816A4
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C554C433D6;
        Tue, 16 Aug 2022 10:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646382;
        bh=JMjLPuGyy57vq1QPLDA6ZeFA+wNUJvzaPW+OmDBqJ7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGGarKsopl4MzGUkg712ZUUVkpE0XhgG4ARRNhR1QroJa1aiQvFNlk8VKuIqd2h5z
         nrA188Vxz8lL2cZQuP2C7Js1Ab1twzSLa3tiG/l52E2mRKQ9EwOaL/9gqjvc3grbZt
         08p6nAGlTr20ogVi7oTfPw43CdGAlJyEwN6LqAnDIdVYnHHwz0O2JkbOJcNuaDJpEZ
         /6FfzIa9/JALwXetHYAnuIRrLA8s3aWMGtyyYrjW0gL1zq4YCZRycdZiAR2To96vPg
         JhtEHChNR1uyhWD3+FJvKMhQhqkJNMw5JjtPYCHNB+bY8OT66mBSSJiSrSO1a+EEDA
         FzGuqM+OJ/UOA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 15/26] net/mlx5e: Flatten the IPsec RX add rule path
Date:   Tue, 16 Aug 2022 13:38:03 +0300
Message-Id: <19ae045211c99e1ccba98c42b979c77ac89e984c.1660641154.git.leonro@nvidia.com>
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

Rewrote the IPsec RX add rule path to be less convoluted
and don't rely on pre-initialized variables. The code now has clean
linear flow with clean separation between error and success paths.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 88 +++++++++++--------
 2 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 9acb3e98c823..67f38cb16d34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -121,7 +121,7 @@ struct mlx5e_ipsec_esn_state {
 
 struct mlx5e_ipsec_rule {
 	struct mlx5_flow_handle *rule;
-	struct mlx5_modify_hdr *set_modify_hdr;
+	struct mlx5_modify_hdr *modify_hdr;
 };
 
 struct mlx5e_ipsec_modify_state_work {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 19e22780f846..03b0ce7b09df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -405,20 +405,52 @@ static void setup_fte_reg_a(struct mlx5_flow_spec *spec)
 		 misc_parameters_2.metadata_reg_a, MLX5_ETH_WQE_FT_META_IPSEC);
 }
 
-static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
+static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
+			       struct mlx5_flow_act *flow_act)
 {
 	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
+	enum mlx5_flow_namespace_type ns_type;
+	struct mlx5_modify_hdr *modify_hdr;
+
+	MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
+	switch (dir) {
+	case XFRM_DEV_OFFLOAD_IN:
+		MLX5_SET(set_action_in, action, field,
+			 MLX5_ACTION_IN_FIELD_METADATA_REG_B);
+		ns_type = MLX5_FLOW_NAMESPACE_KERNEL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	MLX5_SET(set_action_in, action, data, val);
+	MLX5_SET(set_action_in, action, offset, 0);
+	MLX5_SET(set_action_in, action, length, 32);
+
+	modify_hdr = mlx5_modify_header_alloc(mdev, ns_type, 1, action);
+	if (IS_ERR(modify_hdr)) {
+		mlx5_core_err(mdev, "Failed to allocate modify_header %ld\n",
+			      PTR_ERR(modify_hdr));
+		return PTR_ERR(modify_hdr);
+	}
+
+	flow_act->modify_hdr = modify_hdr;
+	flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	return 0;
+}
+
+static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
 	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
-	struct mlx5_modify_hdr *modify_hdr = NULL;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	struct mlx5e_ipsec_rx *rx;
-	int err = 0;
+	int err;
 
 	rx = rx_ft_get(mdev, ipsec, attrs->family);
 	if (IS_ERR(rx))
@@ -427,7 +459,7 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec) {
 		err = -ENOMEM;
-		goto out_err;
+		goto err_alloc;
 	}
 
 	if (attrs->family == AF_INET)
@@ -439,51 +471,35 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	setup_fte_esp(spec);
 	setup_fte_no_frags(spec);
 
-	/* Set bit[31] ipsec marker */
-	/* Set bit[23-0] ipsec_obj_id */
-	MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
-	MLX5_SET(set_action_in, action, field, MLX5_ACTION_IN_FIELD_METADATA_REG_B);
-	MLX5_SET(set_action_in, action, data,
-		 (sa_entry->ipsec_obj_id | BIT(31)));
-	MLX5_SET(set_action_in, action, offset, 0);
-	MLX5_SET(set_action_in, action, length, 32);
-
-	modify_hdr = mlx5_modify_header_alloc(mdev, MLX5_FLOW_NAMESPACE_KERNEL,
-					      1, action);
-	if (IS_ERR(modify_hdr)) {
-		err = PTR_ERR(modify_hdr);
-		mlx5_core_err(mdev,
-			      "fail to alloc ipsec set modify_header_id err=%d\n", err);
-		modify_hdr = NULL;
-		goto out_err;
-	}
+	err = setup_modify_header(mdev, sa_entry->ipsec_obj_id | BIT(31),
+				  XFRM_DEV_OFFLOAD_IN, &flow_act);
+	if (err)
+		goto err_mod_header;
 
 	flow_act.ipsec_obj_id = sa_entry->ipsec_obj_id;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			  MLX5_FLOW_CONTEXT_ACTION_IPSEC_DECRYPT |
-			  MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+			   MLX5_FLOW_CONTEXT_ACTION_IPSEC_DECRYPT;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	flow_act.modify_hdr = modify_hdr;
 	dest.ft = rx->rx_err.ft;
 	rule = mlx5_add_flow_rules(rx->ft.sa, spec, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		mlx5_core_err(mdev, "fail to add RX ipsec rule err=%d\n", err);
-		goto out_err;
+		goto err_add_flow;
 	}
+	kvfree(spec);
 
 	ipsec_rule->rule = rule;
-	ipsec_rule->set_modify_hdr = modify_hdr;
-	goto out;
-
-out_err:
-	if (modify_hdr)
-		mlx5_modify_header_dealloc(mdev, modify_hdr);
-	rx_ft_put(mdev, ipsec, attrs->family);
+	ipsec_rule->modify_hdr = flow_act.modify_hdr;
+	return 0;
 
-out:
+err_add_flow:
+	mlx5_modify_header_dealloc(mdev, flow_act.modify_hdr);
+err_mod_header:
 	kvfree(spec);
+err_alloc:
+	rx_ft_put(mdev, ipsec, attrs->family);
 	return err;
 }
 
@@ -558,7 +574,7 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		return;
 	}
 
-	mlx5_modify_header_dealloc(mdev, ipsec_rule->set_modify_hdr);
+	mlx5_modify_header_dealloc(mdev, ipsec_rule->modify_hdr);
 	rx_ft_put(mdev, sa_entry->ipsec, sa_entry->attrs.family);
 }
 
-- 
2.37.2


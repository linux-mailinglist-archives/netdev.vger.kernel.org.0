Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE1E640EF1
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbiLBUMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbiLBULk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:11:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13862F1CD4
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:11:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A081D6221E
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D55C433C1;
        Fri,  2 Dec 2022 20:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670011894;
        bh=3wvahVP62xO9ka70VAYJcfJqtvSEBF8q0TQ8QBgR+uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u72mPg/ZNEbEl0ykmTAx3w92xlIPBe2KBXbEhfRye0z7j1FvaOf1InLi4AxPmPqr2
         pOtQUAfwmd/aptJFNv0gSEH4KwSPI5vLuI/p7MzIaIYoM6os6C0epkJFE58D/+X6my
         Ev107tAsiDxPyCcKSIkfeoUEDnL9e23GyAMvywr/E44ODf0iFWHNNXE64f7UEIJkrd
         RzmAqiiAbpvdUzR13j7Vz3XmTB0WyaLliGZgTKD7t5ifoyC3BhWWc9EORttmXBFxkH
         fPRDOsDGVBZTYVQK0CuD2e2Ux8ZUep2oC1cJ76WuDb88KhaH9lGQhfGXSaeMIrrsDO
         F008LSBxdzYiA==
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
Subject: [PATCH xfrm-next 13/16] net/mlx5e: Flatten the IPsec RX add rule path
Date:   Fri,  2 Dec 2022 22:10:34 +0200
Message-Id: <edd2219ed50e8243b4033f13331dda9c27791652.1670011671.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011671.git.leonro@nvidia.com>
References: <cover.1670011671.git.leonro@nvidia.com>
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

Rewrote the IPsec RX add rule path to be less convoluted
and don't rely on pre-initialized variables. The code now has clean
linear flow with clean separation between error and success paths.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 88 +++++++++++--------
 2 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 2c9aedf6b0ef..990378d52fd4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -126,7 +126,7 @@ struct mlx5e_ipsec_esn_state {
 
 struct mlx5e_ipsec_rule {
 	struct mlx5_flow_handle *rule;
-	struct mlx5_modify_hdr *set_modify_hdr;
+	struct mlx5_modify_hdr *modify_hdr;
 };
 
 struct mlx5e_ipsec_modify_state_work {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 4c5904544bda..b81046c71e6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -400,20 +400,52 @@ static void setup_fte_reg_a(struct mlx5_flow_spec *spec)
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
@@ -422,7 +454,7 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec) {
 		err = -ENOMEM;
-		goto out_err;
+		goto err_alloc;
 	}
 
 	if (attrs->family == AF_INET)
@@ -434,52 +466,36 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
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
 
 	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
 	flow_act.crypto.obj_id = sa_entry->ipsec_obj_id;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
-			  MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+			   MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT;
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
 
@@ -555,7 +571,7 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		return;
 	}
 
-	mlx5_modify_header_dealloc(mdev, ipsec_rule->set_modify_hdr);
+	mlx5_modify_header_dealloc(mdev, ipsec_rule->modify_hdr);
 	rx_ft_put(mdev, sa_entry->ipsec, sa_entry->attrs.family);
 }
 
-- 
2.38.1


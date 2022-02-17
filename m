Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDE54B9A47
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbiBQH53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:57:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236791AbiBQH47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:56:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A98766B
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:56:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D860F61B45
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674F3C340E8;
        Thu, 17 Feb 2022 07:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645084599;
        bh=+ALdIofxr/EWP6l3LefAQer4pamtY5IWqqbsnjgAMBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ta3Z2NRiydn90oBb6SxsegKdwffRWrInSRWRXyC+1n6J1JvUQ82j9KNSgsb/2Fj52
         H45davEdmdMZ+XkQA6wPbV3LnaRHYfYNiDNHklRFgs7fYXykaXOd8uaGR3/nS0uQ0D
         JW6cRz7oryPF1qXFpCsOu8yKDMMYXlsgAPTPL8M85pslEbW/O3hlHu4TpCHJi0fNou
         Vl02i/h7hwB8tbYokdmdOjlozikHKVx8swcr50+byMSHryY+edU1xt3qnTEP4i09WA
         pzRUgLdxaD+nijMEQoofppoE1kf6S4GfXVwEoV6Q1okA89EAVxLsWnRV9REyvmg42V
         UEz5qUehhP7Cw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: Add post act offload/unoffload API
Date:   Wed, 16 Feb 2022 23:56:27 -0800
Message-Id: <20220217075632.831542-11-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217075632.831542-1-saeed@kernel.org>
References: <20220217075632.831542-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Introduce mlx5e_tc_post_act_offload() and mlx5e_tc_post_act_unoffload()
to be able to unoffload and reoffload existing post action rules handles.
For example in neigh update events, the driver removes and readds rules in
hardware.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/post_act.c       | 67 +++++++++++++------
 .../mellanox/mlx5/core/en/tc/post_act.h       |  8 +++
 2 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
index 9e0e229cf164..ce7ba1951e25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
@@ -75,21 +75,47 @@ mlx5e_tc_post_act_destroy(struct mlx5e_post_act *post_act)
 	kfree(post_act);
 }
 
+int
+mlx5e_tc_post_act_offload(struct mlx5e_post_act *post_act,
+			  struct mlx5e_post_act_handle *handle)
+{
+	struct mlx5_flow_spec *spec;
+	int err;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	/* Post action rule matches on fte_id and executes original rule's tc rule action */
+	mlx5e_tc_match_to_reg_match(spec, FTEID_TO_REG, handle->id, MLX5_POST_ACTION_MASK);
+
+	handle->rule = mlx5_tc_rule_insert(post_act->priv, spec, handle->attr);
+	if (IS_ERR(handle->rule)) {
+		err = PTR_ERR(handle->rule);
+		netdev_warn(post_act->priv->netdev, "Failed to add post action rule");
+		goto err_rule;
+	}
+
+	kvfree(spec);
+	return 0;
+
+err_rule:
+	kvfree(spec);
+	return err;
+}
+
 struct mlx5e_post_act_handle *
 mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *attr)
 {
 	u32 attr_sz = ns_to_attr_sz(post_act->ns_type);
-	struct mlx5e_post_act_handle *handle = NULL;
-	struct mlx5_flow_attr *post_attr = NULL;
-	struct mlx5_flow_spec *spec = NULL;
+	struct mlx5e_post_act_handle *handle;
+	struct mlx5_flow_attr *post_attr;
 	int err;
 
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	post_attr = mlx5_alloc_flow_attr(post_act->ns_type);
-	if (!handle || !spec || !post_attr) {
+	if (!handle || !post_attr) {
 		kfree(post_attr);
-		kvfree(spec);
 		kfree(handle);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -113,36 +139,35 @@ mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *at
 	if (err)
 		goto err_xarray;
 
-	/* Post action rule matches on fte_id and executes original rule's
-	 * tc rule action
-	 */
-	mlx5e_tc_match_to_reg_match(spec, FTEID_TO_REG,
-				    handle->id, MLX5_POST_ACTION_MASK);
-
-	handle->rule = mlx5_tc_rule_insert(post_act->priv, spec, post_attr);
-	if (IS_ERR(handle->rule)) {
-		err = PTR_ERR(handle->rule);
-		netdev_warn(post_act->priv->netdev, "Failed to add post action rule");
-		goto err_rule;
-	}
 	handle->attr = post_attr;
+	err = mlx5e_tc_post_act_offload(post_act, handle);
+	if (err)
+		goto err_rule;
+
 
-	kvfree(spec);
 	return handle;
 
 err_rule:
 	xa_erase(&post_act->ids, handle->id);
 err_xarray:
 	kfree(post_attr);
-	kvfree(spec);
 	kfree(handle);
 	return ERR_PTR(err);
 }
 
 void
-mlx5e_tc_post_act_del(struct mlx5e_post_act *post_act, struct mlx5e_post_act_handle *handle)
+mlx5e_tc_post_act_unoffload(struct mlx5e_post_act *post_act,
+			    struct mlx5e_post_act_handle *handle)
 {
 	mlx5_tc_rule_delete(post_act->priv, handle->rule, handle->attr);
+	handle->rule = NULL;
+}
+
+void
+mlx5e_tc_post_act_del(struct mlx5e_post_act *post_act, struct mlx5e_post_act_handle *handle)
+{
+	if (!IS_ERR_OR_NULL(handle->rule))
+		mlx5e_tc_post_act_unoffload(post_act, handle);
 	xa_erase(&post_act->ids, handle->id);
 	kfree(handle->attr);
 	kfree(handle);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h
index b530ec1981a5..f476774c0b75 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h
@@ -24,6 +24,14 @@ mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *at
 void
 mlx5e_tc_post_act_del(struct mlx5e_post_act *post_act, struct mlx5e_post_act_handle *handle);
 
+int
+mlx5e_tc_post_act_offload(struct mlx5e_post_act *post_act,
+			  struct mlx5e_post_act_handle *handle);
+
+void
+mlx5e_tc_post_act_unoffload(struct mlx5e_post_act *post_act,
+			    struct mlx5e_post_act_handle *handle);
+
 struct mlx5_flow_table *
 mlx5e_tc_post_act_get_ft(struct mlx5e_post_act *post_act);
 
-- 
2.34.1


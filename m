Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85C3641962
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiLCWOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiLCWNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:13:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFD21CB3F
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:13:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56314B807E9
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F53C433D7;
        Sat,  3 Dec 2022 22:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105628;
        bh=8JgKjUDvNHuk6W+h3RwSapp5tLyA/fv9hZmt/7s2T1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOzcKv2Y/KrxnLJSwPWUE3ErrST7a5fvap07JU1cqVWOxGcNC5rYr0BA1GSaIb10t
         pvpW6j3X8jGruFVFURDfCzn981PR1eYaemzx/PnPglUC3vqB1Wh0bJJkyj4sCQLzQY
         ejceLIQoRKcZztVqylB2NYlbFTBLMCvcolI2Ho1YKYPK+eiMmKP9lfta45Wl5eLDOG
         VsdDzeRYCNj5SpaMcCpl4H9o3krfgz77ZdTvaHHeb6tY4J4w6obN19yIykhc7/9i8x
         TaTR/DBG9dw9ii9LnSqVHWMBhGiYvknq0CuNJdkWUNKr+WNkXYH6V9gq5mtb9YDhYC
         kQbwsPtfCdfdQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: TC, validate action list per attribute
Date:   Sat,  3 Dec 2022 14:13:27 -0800
Message-Id: <20221203221337.29267-6-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221203221337.29267-1-saeed@kernel.org>
References: <20221203221337.29267-1-saeed@kernel.org>
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

From: Oz Shlomo <ozsh@nvidia.com>

Currently the entire flow action list is validate for offload limitations.
For example, flow with both forward and drop actions are declared invalid
due to hardware restrictions.
However, a multi-table hardware model changes the limitations from a flow
scope to a single flow attribute scope.

Apply offload limitations to flow attributes instead of the entire flow.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 62 ++++++++++---------
 1 file changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 46222541e435..7eaf6c73b091 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1724,6 +1724,30 @@ clean_encap_dests(struct mlx5e_priv *priv,
 	}
 }
 
+static int
+verify_attr_actions(u32 actions, struct netlink_ext_ack *extack)
+{
+	if (!(actions &
+	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
+		NL_SET_ERR_MSG_MOD(extack, "Rule must have at least one forward/drop action");
+		return -EOPNOTSUPP;
+	}
+
+	if (!(~actions &
+	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
+		NL_SET_ERR_MSG_MOD(extack, "Rule cannot support forward+drop action");
+		return -EOPNOTSUPP;
+	}
+
+	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
+	    actions & MLX5_FLOW_CONTEXT_ACTION_DROP) {
+		NL_SET_ERR_MSG_MOD(extack, "Drop with modify header action is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int
 post_process_attr(struct mlx5e_tc_flow *flow,
 		  struct mlx5_flow_attr *attr,
@@ -1734,6 +1758,10 @@ post_process_attr(struct mlx5e_tc_flow *flow,
 	bool vf_tun;
 	int err = 0;
 
+	err = verify_attr_actions(attr->action, extack);
+	if (err)
+		goto err_out;
+
 	err = set_encap_dests(flow->priv, flow, attr, extack, &vf_tun);
 	if (err)
 		goto err_out;
@@ -3532,36 +3560,6 @@ actions_match_supported(struct mlx5e_priv *priv,
 	ct_clear = flow->attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
 	ct_flow = flow_flag_test(flow, CT) && !ct_clear;
 
-	if (!(actions &
-	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
-		NL_SET_ERR_MSG_MOD(extack, "Rule must have at least one forward/drop action");
-		return false;
-	}
-
-	if (!(~actions &
-	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
-		NL_SET_ERR_MSG_MOD(extack, "Rule cannot support forward+drop action");
-		return false;
-	}
-
-	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
-	    actions & MLX5_FLOW_CONTEXT_ACTION_DROP) {
-		NL_SET_ERR_MSG_MOD(extack, "Drop with modify header action is not supported");
-		return false;
-	}
-
-	if (!(~actions &
-	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
-		NL_SET_ERR_MSG_MOD(extack, "Rule cannot support forward+drop action");
-		return false;
-	}
-
-	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
-	    actions & MLX5_FLOW_CONTEXT_ACTION_DROP) {
-		NL_SET_ERR_MSG_MOD(extack, "Drop with modify header action is not supported");
-		return false;
-	}
-
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
 	    !modify_header_match_supported(priv, &parse_attr->spec, flow_action,
 					   actions, ct_flow, ct_clear, extack))
@@ -3957,6 +3955,10 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
+	err = verify_attr_actions(attr->action, extack);
+	if (err)
+		return err;
+
 	if (!actions_match_supported(priv, flow_action, parse_state->actions,
 				     parse_attr, flow, extack))
 		return -EOPNOTSUPP;
-- 
2.38.1


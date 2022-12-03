Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E316F64196A
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiLCWOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiLCWOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:14:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9BB1E702
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:13:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5150EB807E9
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCD1C43470;
        Sat,  3 Dec 2022 22:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105635;
        bh=GYoGEmff3ChzHF4xZA1uXTqvplq1hFKEKqa0p+SPuXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kH+3Qt68O0QP/BPDQ/2Go6nWK4V5oHFwAy+ba71NFhww/nLYUokbgcoLOzozGQxaD
         K166qgf7cVz8Yaj1MhtT9Kr376E0Sbx4fsprJa7x8jKUK4qB8IMjA2BCTBwWOEmX4U
         xDBsNxzbXx5VF8Ef2WL0DnlyDlRriLm9YEWc8cObglV1oOTYYdrsiO9aW3Ds7IRx8Q
         x05ajfSuoHqLdIWf9Dkjl9jAjeAvBoE3FFpcnrYuCo6phV9bSpKTi8xXxD8/n29S4h
         sFHC1nAtqmsyyxAWrpm8u9luXiERvBWSaw+cCDc7Jycq8HSaGIhFgpgHSWRWLwyKyv
         acvH8uDUn9XOQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: TC, allow meter jump control action
Date:   Sat,  3 Dec 2022 14:13:33 -0800
Message-Id: <20221203221337.29267-12-saeed@kernel.org>
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

Separate the matchall police action validation from flower validation.
Isolate the action validation logic in the police action parser.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/police.c     | 52 +++++++++++++++----
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  4 --
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 21 ++++----
 3 files changed, 54 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
index 81aa4185c64a..898fe16a4384 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
@@ -4,20 +4,54 @@
 #include "act.h"
 #include "en/tc_priv.h"
 
+static bool police_act_validate_control(enum flow_action_id act_id,
+					struct netlink_ext_ack *extack)
+{
+	if (act_id != FLOW_ACTION_PIPE &&
+	    act_id != FLOW_ACTION_ACCEPT &&
+	    act_id != FLOW_ACTION_JUMP &&
+	    act_id != FLOW_ACTION_DROP) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when conform-exceed action is not pipe, ok, jump or drop");
+		return false;
+	}
+
+	return true;
+}
+
+static int police_act_validate(const struct flow_action_entry *act,
+			       struct netlink_ext_ack *extack)
+{
+	if (!police_act_validate_control(act->police.exceed.act_id, extack) ||
+	    !police_act_validate_control(act->police.notexceed.act_id, extack))
+		return -EOPNOTSUPP;
+
+	if (act->police.peakrate_bytes_ps ||
+	    act->police.avrate || act->police.overhead) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when peakrate/avrate/overhead is configured");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.rate_pkt_ps) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "QoS offload not support packets per second");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static bool
 tc_act_can_offload_police(struct mlx5e_tc_act_parse_state *parse_state,
 			  const struct flow_action_entry *act,
 			  int act_index,
 			  struct mlx5_flow_attr *attr)
 {
-	if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
-	    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
-		NL_SET_ERR_MSG_MOD(parse_state->extack,
-				   "Offload not supported when conform action is not pipe or ok");
-		return false;
-	}
-	if (mlx5e_policer_validate(parse_state->flow_action, act,
-				   parse_state->extack))
+	int err;
+
+	err = police_act_validate(act, parse_state->extack);
+	if (err)
 		return false;
 
 	return !!mlx5e_get_flow_meters(parse_state->flow->priv->mdev);
@@ -79,7 +113,7 @@ tc_act_police_offload(struct mlx5e_priv *priv,
 	struct mlx5e_flow_meter_handle *meter;
 	int err = 0;
 
-	err = mlx5e_policer_validate(&fl_act->action, act, fl_act->extack);
+	err = police_act_validate(act, fl_act->extack);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 2e42d7c5451e..2b7fd1c0e643 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -211,8 +211,4 @@ struct mlx5e_flow_meters *mlx5e_get_flow_meters(struct mlx5_core_dev *dev);
 void *mlx5e_get_match_headers_value(u32 flags, struct mlx5_flow_spec *spec);
 void *mlx5e_get_match_headers_criteria(u32 flags, struct mlx5_flow_spec *spec);
 
-int mlx5e_policer_validate(const struct flow_action *action,
-			   const struct flow_action_entry *act,
-			   struct netlink_ext_ack *extack);
-
 #endif /* __MLX5_EN_TC_PRIV_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 338e0b21d0b3..227fa6ef9e41 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4939,10 +4939,17 @@ static int apply_police_params(struct mlx5e_priv *priv, u64 rate,
 	return err;
 }
 
-int mlx5e_policer_validate(const struct flow_action *action,
-			   const struct flow_action_entry *act,
-			   struct netlink_ext_ack *extack)
+static int
+tc_matchall_police_validate(const struct flow_action *action,
+			    const struct flow_action_entry *act,
+			    struct netlink_ext_ack *extack)
 {
+	if (act->police.notexceed.act_id != FLOW_ACTION_CONTINUE) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when conform action is not continue");
+		return -EOPNOTSUPP;
+	}
+
 	if (act->police.exceed.act_id != FLOW_ACTION_DROP) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Offload not supported when exceed action is not drop");
@@ -4993,13 +5000,7 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
-			if (act->police.notexceed.act_id != FLOW_ACTION_CONTINUE) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "Offload not supported when conform action is not continue");
-				return -EOPNOTSUPP;
-			}
-
-			err = mlx5e_policer_validate(flow_action, act, extack);
+			err = tc_matchall_police_validate(flow_action, act, extack);
 			if (err)
 				return err;
 
-- 
2.38.1


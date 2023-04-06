Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACED6D8D31
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbjDFCDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbjDFCDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:03:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D50868D
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD52D618D6
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE59C4339B;
        Thu,  6 Apr 2023 02:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746572;
        bh=HsZnVgZJB25dMn+m3zsej8B/+jrMkzfB+ewt73JCaI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=biKfjMxaCUXtKHmWv31BB6RpMxu2310ahFnwrm1wgS1rdHg5nwi+oV3rc1/vL8Qpl
         01oUVoim6X0nZD/iPi0pWIyo3OsmgtGu19j38aA/lXoDxTRM/cwd6y6urJ1yw631ye
         WGWD+S9l8uKtyEA2YwO1wEvtzmnOIlL9/AieRLjP4DmyVRIHIwRAb1VRVNFQUolV56
         hHf9pMV+/7eaGHsbM2f1FSKWWiUkZN1w6xzTBNuJFDeS8ZSg7LhVjgUC++JB9d+zSd
         9Y3FG89sNRAvC4XyLIGtWwPywItUmFURtdZS3FBnzp2tfrndw5IFDjxdJKYmFFQbYY
         PFAQJGwac2iZw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: TC, Remove sample and ct limitation
Date:   Wed,  5 Apr 2023 19:02:27 -0700
Message-Id: <20230406020232.83844-11-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406020232.83844-1-saeed@kernel.org>
References: <20230406020232.83844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Sample action before a ct nat action was not supported when only
chain was restored on misses. As to work around that limitation,
ct action was reordered to be first (so if hw misses on ct
action, packet wasn't modified). This reordering wasn't possible
if there was a sample action before the ct nat action, as we had to
sample the packet before the nat operation.

Now that the misses continue from the relevant tc ct action
in software and ct action is no longer reordered, this case
is supported.

Remove this limitation.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/sample.c     | 20 -------------------
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  | 11 +++++-----
 2 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
index 2c0196431302..2df02f99cecf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
@@ -6,25 +6,6 @@
 #include "en/tc_priv.h"
 #include "en/tc/act/sample.h"
 
-static bool
-tc_act_can_offload_sample(struct mlx5e_tc_act_parse_state *parse_state,
-			  const struct flow_action_entry *act,
-			  int act_index,
-			  struct mlx5_flow_attr *attr)
-{
-	struct netlink_ext_ack *extack = parse_state->extack;
-	bool ct_nat;
-
-	ct_nat = attr->ct_attr.ct_action & TCA_CT_ACT_NAT;
-
-	if (flow_flag_test(parse_state->flow, CT) && ct_nat) {
-		NL_SET_ERR_MSG_MOD(extack, "Sample action with CT NAT is not supported");
-		return false;
-	}
-
-	return true;
-}
-
 static int
 tc_act_parse_sample(struct mlx5e_tc_act_parse_state *parse_state,
 		    const struct flow_action_entry *act,
@@ -65,7 +46,6 @@ tc_act_is_multi_table_act_sample(struct mlx5e_priv *priv,
 }
 
 struct mlx5e_tc_act mlx5e_tc_act_sample = {
-	.can_offload = tc_act_can_offload_sample,
 	.parse_action = tc_act_parse_sample,
 	.is_multi_table_act = tc_act_is_multi_table_act_sample,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 451fd4342a5a..ba2b1f24ff14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -25,12 +25,11 @@ enum {
 	MLX5E_TC_FLOW_FLAG_DUP                   = MLX5E_TC_FLOW_BASE + 4,
 	MLX5E_TC_FLOW_FLAG_NOT_READY             = MLX5E_TC_FLOW_BASE + 5,
 	MLX5E_TC_FLOW_FLAG_DELETED               = MLX5E_TC_FLOW_BASE + 6,
-	MLX5E_TC_FLOW_FLAG_CT                    = MLX5E_TC_FLOW_BASE + 7,
-	MLX5E_TC_FLOW_FLAG_L3_TO_L2_DECAP        = MLX5E_TC_FLOW_BASE + 8,
-	MLX5E_TC_FLOW_FLAG_TUN_RX                = MLX5E_TC_FLOW_BASE + 9,
-	MLX5E_TC_FLOW_FLAG_FAILED                = MLX5E_TC_FLOW_BASE + 10,
-	MLX5E_TC_FLOW_FLAG_SAMPLE                = MLX5E_TC_FLOW_BASE + 11,
-	MLX5E_TC_FLOW_FLAG_USE_ACT_STATS	 = MLX5E_TC_FLOW_BASE + 12,
+	MLX5E_TC_FLOW_FLAG_L3_TO_L2_DECAP        = MLX5E_TC_FLOW_BASE + 7,
+	MLX5E_TC_FLOW_FLAG_TUN_RX                = MLX5E_TC_FLOW_BASE + 8,
+	MLX5E_TC_FLOW_FLAG_FAILED                = MLX5E_TC_FLOW_BASE + 9,
+	MLX5E_TC_FLOW_FLAG_SAMPLE                = MLX5E_TC_FLOW_BASE + 10,
+	MLX5E_TC_FLOW_FLAG_USE_ACT_STATS         = MLX5E_TC_FLOW_BASE + 11,
 };
 
 struct mlx5e_tc_flow_parse_attr {
-- 
2.39.2


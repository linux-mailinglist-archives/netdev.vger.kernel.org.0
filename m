Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A948F6D8D2A
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbjDFCC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbjDFCCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:02:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C844ED2
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F08C8611FB
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C06C433EF;
        Thu,  6 Apr 2023 02:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746565;
        bh=cmPgonVD0I6L0iBRNRPk7UYQ8TU4vGa9AcqLRgUan20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfhoiCdTPrD4gSJTNIDpVYaGy5SR3W6rwxQfhfMjC9C0olc/ePZHowWWQ+ZwMytF1
         /HU8CwtZjN/up3BYsuj0PHvcs+2Nhjc95C+0u5aYqvor+weGptwMADQVc+7roD+xB8
         uqzd0lVsVmwMaMr5z0C8q8bmXnQjWCa8+tNupDWDIT60IaOWKyU0WhRjknhMuMzOQ3
         o+AiaxxOTYvuTjAJuopTDW6miC6gBIBk2dV2SjpYOiyBHBwCj2ja+tRDqEPt9HPOel
         hGVZTnUnc52e4CzuW4+ZgIqfqj+/pt0Yd4c/oDtMOuZvSMFopGQt8MsyWiOPXnMs1a
         usUOJyYm+HfbA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: TC, Move main flow attribute cleanup to helper func
Date:   Wed,  5 Apr 2023 19:02:20 -0700
Message-Id: <20230406020232.83844-4-saeed@kernel.org>
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

Actions that can be setup per flow attribute (so per split rule)
are cleaned up from mlx5_free_flow_attr(), mlx5e_tc_del_fdb_flow(),
and free_flow_post_acts().

Remove the duplication by re-using the helper function for
the main flow attribute and split rules attributes.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 27 +++++++------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a4cf1818e8fe..cafab7634fb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -177,7 +177,8 @@ static struct lock_class_key tc_ht_wq_key;
 
 static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow);
 static void free_flow_post_acts(struct mlx5e_tc_flow *flow);
-static void mlx5_free_flow_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr);
+static void mlx5_free_flow_attr_actions(struct mlx5e_tc_flow *flow,
+					struct mlx5_flow_attr *attr);
 
 void
 mlx5e_tc_match_to_reg_match(struct mlx5_flow_spec *spec,
@@ -2021,7 +2022,7 @@ static void free_branch_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *
 	if (!attr)
 		return;
 
-	mlx5_free_flow_attr(flow, attr);
+	mlx5_free_flow_attr_actions(flow, attr);
 	kvfree(attr->parse_attr);
 	kfree(attr);
 }
@@ -2053,18 +2054,8 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (flow->decap_route)
 		mlx5e_detach_decap_route(priv, flow);
 
-	clean_encap_dests(priv, flow, attr);
-
 	mlx5_tc_ct_match_del(get_ct_priv(priv), &flow->attr->ct_attr);
 
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
-		mlx5e_mod_hdr_dealloc(&attr->parse_attr->mod_hdr_acts);
-		mlx5e_tc_detach_mod_hdr(priv, flow, attr);
-	}
-
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
-		mlx5_fc_destroy(esw_attr->counter_dev, attr->counter);
-
 	if (esw_attr->int_port)
 		mlx5e_tc_int_port_put(mlx5e_get_int_port_priv(priv), esw_attr->int_port);
 
@@ -2077,8 +2068,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	mlx5e_tc_act_stats_del_flow(get_act_stats_handle(priv), flow);
 
 	free_flow_post_acts(flow);
-	free_branch_attr(flow, attr->branch_true);
-	free_branch_attr(flow, attr->branch_false);
+	mlx5_free_flow_attr_actions(flow, attr);
 
 	kvfree(attr->esw_attr->rx_tun_attr);
 	kvfree(attr->parse_attr);
@@ -3797,9 +3787,7 @@ free_flow_post_acts(struct mlx5e_tc_flow *flow)
 		if (list_is_last(&attr->list, &flow->attrs))
 			break;
 
-		mlx5_free_flow_attr(flow, attr);
-		free_branch_attr(flow, attr->branch_true);
-		free_branch_attr(flow, attr->branch_false);
+		mlx5_free_flow_attr_actions(flow, attr);
 
 		list_del(&attr->list);
 		kvfree(attr->parse_attr);
@@ -4434,7 +4422,7 @@ mlx5_alloc_flow_attr(enum mlx5_flow_namespace_type type)
 }
 
 static void
-mlx5_free_flow_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr)
+mlx5_free_flow_attr_actions(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr)
 {
 	struct mlx5_core_dev *counter_dev = get_flow_counter_dev(flow);
 
@@ -4453,6 +4441,9 @@ mlx5_free_flow_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr)
 		mlx5e_mod_hdr_dealloc(&attr->parse_attr->mod_hdr_acts);
 		mlx5e_tc_detach_mod_hdr(flow->priv, flow, attr);
 	}
+
+	free_branch_attr(flow, attr->branch_true);
+	free_branch_attr(flow, attr->branch_false);
 }
 
 static int
-- 
2.39.2


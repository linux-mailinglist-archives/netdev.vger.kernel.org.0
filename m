Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FE358473B
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbiG1UrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiG1UrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:47:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22F667CA8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:46:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A649B82594
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182B5C433B5;
        Thu, 28 Jul 2022 20:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041217;
        bh=G6STRyf/b2PSDs9WcK5B+aWVcDZ7M6TgKrn/hgOR/so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJe7J204YmpHKP5YNHUXVj3+vVCH7eEIDQR6iF/gfak2EdC3DNU418sJyrRXqEpqy
         PxI2/ZRJ8lJEE2TyY6PeHZ0v3Glm7KDG6bnk9+dQIJuu1N1uLM/tliV+lrVvEHxHfU
         jEQYpSbCEyXlnVyQAX3obCmxuE2+39bmSL+q3XZB+eOP+QpIgueTPD+aoK2SbtDA+V
         y5fI7kYJQ9c76pkU7DUq3/nY1yDKGREvwBWs9dQ6kXlWqz8AbLc4xTiow0qOJjYo1+
         QKzr51myhq8lEnvsgaMe4aZ0BXfAWtmzv4ywp+fncMQwT77ZgxZCtsW/emy5cDW9Uw
         LWQanjKLKhn5g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: [net 6/9] net/mlx5e: Modify slow path rules to go to slow fdb
Date:   Thu, 28 Jul 2022 13:46:37 -0700
Message-Id: <20220728204640.139990-7-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728204640.139990-1-saeed@kernel.org>
References: <20220728204640.139990-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

While extending available range of supported chains/prios referenced commit
also modified slow path rules to go to FT chain instead of actual slow FDB.
However neither of existing users of the MLX5_ATTR_FLAG_SLOW_PATH
flag (tunnel encap entries with invalid encap and flows with trap action)
need to match on FT chain. After bridge offload was implemented packets of
such flows can also be matched by bridge priority tables which is
undesirable. Restore slow path flows implementation to redirect packets to
slow_fdb.

Fixes: 278d51f24330 ("net/mlx5: E-Switch, Increase number of chains and priorities")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 23 ++++++++++++++-----
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 2ce3728576d1..eb79810199d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -230,10 +230,8 @@ esw_setup_ft_dest(struct mlx5_flow_destination *dest,
 }
 
 static void
-esw_setup_slow_path_dest(struct mlx5_flow_destination *dest,
-			 struct mlx5_flow_act *flow_act,
-			 struct mlx5_fs_chains *chains,
-			 int i)
+esw_setup_accept_dest(struct mlx5_flow_destination *dest, struct mlx5_flow_act *flow_act,
+		      struct mlx5_fs_chains *chains, int i)
 {
 	if (mlx5_chains_ignore_flow_level_supported(chains))
 		flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
@@ -241,6 +239,16 @@ esw_setup_slow_path_dest(struct mlx5_flow_destination *dest,
 	dest[i].ft = mlx5_chains_get_tc_end_ft(chains);
 }
 
+static void
+esw_setup_slow_path_dest(struct mlx5_flow_destination *dest, struct mlx5_flow_act *flow_act,
+			 struct mlx5_eswitch *esw, int i)
+{
+	if (MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ignore_flow_level))
+		flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest[i].ft = esw->fdb_table.offloads.slow_fdb;
+}
+
 static int
 esw_setup_chain_dest(struct mlx5_flow_destination *dest,
 		     struct mlx5_flow_act *flow_act,
@@ -475,8 +483,11 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 	} else if (attr->dest_ft) {
 		esw_setup_ft_dest(dest, flow_act, esw, attr, spec, *i);
 		(*i)++;
-	} else if (mlx5e_tc_attr_flags_skip(attr->flags)) {
-		esw_setup_slow_path_dest(dest, flow_act, chains, *i);
+	} else if (attr->flags & MLX5_ATTR_FLAG_SLOW_PATH) {
+		esw_setup_slow_path_dest(dest, flow_act, esw, *i);
+		(*i)++;
+	} else if (attr->flags & MLX5_ATTR_FLAG_ACCEPT) {
+		esw_setup_accept_dest(dest, flow_act, chains, *i);
 		(*i)++;
 	} else if (attr->dest_chain) {
 		err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain,
-- 
2.37.1


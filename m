Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60927647A96
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiLIAOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiLIAOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:14:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E5B8D190
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CD73620F5
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF2CC433F1;
        Fri,  9 Dec 2022 00:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544875;
        bh=qAGx321CP3aM+kfNg+9xEhWYU6jHlQECtC/l25rbZJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgiStvwEnxbV1NPLO1WIGQmt/xEZc2C6+sVMwaPHr/I9jP6VgiI8RriaFPzbgTnXu
         FMPtUSFp/MWSxQAxRp+VcqnLNVcbpSXWCPpRg4bUXrbSpbrJlnfxsPFL9cBbHjdA23
         LPwOOPL3rh/RXR2VUIFBwXQ03HP0sP2VpzYe/RHGuhXXhp4SY/6gbftLggUUhHBO+6
         mMtjyGwYYXNus0qxy5HCES2vv6HMyqbZBFxUYFw5gOqG0IJexaMC2n9nRHQosKDhm0
         iQsXfVgnf+U762oDHiSjOBeBwOgGOG5lb7ow4/RxbqAfcNjFpA3m1RqbZjIE+X8fDs
         JV5GiBzOr2fIQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 05/15] net/mlx5: DR, Handle FT action in a separate function
Date:   Thu,  8 Dec 2022 16:14:10 -0800
Message-Id: <20221209001420.142794-6-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209001420.142794-1-saeed@kernel.org>
References: <20221209001420.142794-1-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

As preparation for range action support, moving the handling
of final ICM address for flow table action to a separate function.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 127 +++++++++++-------
 1 file changed, 81 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index b1dfad274a39..fc44fee2f9c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -634,6 +634,83 @@ static void dr_action_print_sequence(struct mlx5dr_domain *dmn,
 			   actions[i]->action_type);
 }
 
+static int dr_action_get_dest_fw_tbl_addr(struct mlx5dr_matcher *matcher,
+					  struct mlx5dr_action_dest_tbl *dest_tbl,
+					  bool is_rx_rule,
+					  u64 *final_icm_addr)
+{
+	struct mlx5dr_cmd_query_flow_table_details output;
+	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
+	int ret;
+
+	if (!dest_tbl->fw_tbl.rx_icm_addr) {
+		ret = mlx5dr_cmd_query_flow_table(dmn->mdev,
+						  dest_tbl->fw_tbl.type,
+						  dest_tbl->fw_tbl.id,
+						  &output);
+		if (ret) {
+			mlx5dr_err(dmn,
+				   "Failed mlx5_cmd_query_flow_table ret: %d\n",
+				   ret);
+			return ret;
+		}
+
+		dest_tbl->fw_tbl.tx_icm_addr = output.sw_owner_icm_root_1;
+		dest_tbl->fw_tbl.rx_icm_addr = output.sw_owner_icm_root_0;
+	}
+
+	*final_icm_addr = is_rx_rule ? dest_tbl->fw_tbl.rx_icm_addr :
+				       dest_tbl->fw_tbl.tx_icm_addr;
+	return 0;
+}
+
+static int dr_action_get_dest_sw_tbl_addr(struct mlx5dr_matcher *matcher,
+					  struct mlx5dr_action_dest_tbl *dest_tbl,
+					  bool is_rx_rule,
+					  u64 *final_icm_addr)
+{
+	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
+	struct mlx5dr_icm_chunk *chunk;
+
+	if (dest_tbl->tbl->dmn != dmn) {
+		mlx5dr_err(dmn,
+			   "Destination table belongs to a different domain\n");
+		return -EINVAL;
+	}
+
+	if (dest_tbl->tbl->level <= matcher->tbl->level) {
+		mlx5_core_dbg_once(dmn->mdev,
+				   "Connecting table to a lower/same level destination table\n");
+		mlx5dr_dbg(dmn,
+			   "Connecting table at level %d to a destination table at level %d\n",
+			   matcher->tbl->level,
+			   dest_tbl->tbl->level);
+	}
+
+	chunk = is_rx_rule ? dest_tbl->tbl->rx.s_anchor->chunk :
+			     dest_tbl->tbl->tx.s_anchor->chunk;
+
+	*final_icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(chunk);
+	return 0;
+}
+
+static int dr_action_get_dest_tbl_addr(struct mlx5dr_matcher *matcher,
+				       struct mlx5dr_action_dest_tbl *dest_tbl,
+				       bool is_rx_rule,
+				       u64 *final_icm_addr)
+{
+	if (dest_tbl->is_fw_tbl)
+		return dr_action_get_dest_fw_tbl_addr(matcher,
+						      dest_tbl,
+						      is_rx_rule,
+						      final_icm_addr);
+
+	return dr_action_get_dest_sw_tbl_addr(matcher,
+					      dest_tbl,
+					      is_rx_rule,
+					      final_icm_addr);
+}
+
 #define WITH_VLAN_NUM_HW_ACTIONS 6
 
 int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
@@ -661,8 +738,6 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 	action_domain = dr_action_get_action_domain(dmn->type, nic_dmn->type);
 
 	for (i = 0; i < num_actions; i++) {
-		struct mlx5dr_action_dest_tbl *dest_tbl;
-		struct mlx5dr_icm_chunk *chunk;
 		struct mlx5dr_action *action;
 		int max_actions_type = 1;
 		u32 action_type;
@@ -676,50 +751,10 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			break;
 		case DR_ACTION_TYP_FT:
 			dest_action = action;
-			dest_tbl = action->dest_tbl;
-			if (!dest_tbl->is_fw_tbl) {
-				if (dest_tbl->tbl->dmn != dmn) {
-					mlx5dr_err(dmn,
-						   "Destination table belongs to a different domain\n");
-					return -EINVAL;
-				}
-				if (dest_tbl->tbl->level <= matcher->tbl->level) {
-					mlx5_core_dbg_once(dmn->mdev,
-							   "Connecting table to a lower/same level destination table\n");
-					mlx5dr_dbg(dmn,
-						   "Connecting table at level %d to a destination table at level %d\n",
-						   matcher->tbl->level,
-						   dest_tbl->tbl->level);
-				}
-				chunk = rx_rule ? dest_tbl->tbl->rx.s_anchor->chunk :
-					dest_tbl->tbl->tx.s_anchor->chunk;
-				attr.final_icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(chunk);
-			} else {
-				struct mlx5dr_cmd_query_flow_table_details output;
-				int ret;
-
-				/* get the relevant addresses */
-				if (!action->dest_tbl->fw_tbl.rx_icm_addr) {
-					ret = mlx5dr_cmd_query_flow_table(dmn->mdev,
-									  dest_tbl->fw_tbl.type,
-									  dest_tbl->fw_tbl.id,
-									  &output);
-					if (!ret) {
-						dest_tbl->fw_tbl.tx_icm_addr =
-							output.sw_owner_icm_root_1;
-						dest_tbl->fw_tbl.rx_icm_addr =
-							output.sw_owner_icm_root_0;
-					} else {
-						mlx5dr_err(dmn,
-							   "Failed mlx5_cmd_query_flow_table ret: %d\n",
-							   ret);
-						return ret;
-					}
-				}
-				attr.final_icm_addr = rx_rule ?
-					dest_tbl->fw_tbl.rx_icm_addr :
-					dest_tbl->fw_tbl.tx_icm_addr;
-			}
+			ret = dr_action_get_dest_tbl_addr(matcher, action->dest_tbl,
+							  rx_rule, &attr.final_icm_addr);
+			if (ret)
+				return ret;
 			break;
 		case DR_ACTION_TYP_QP:
 			mlx5dr_info(dmn, "Domain doesn't support QP\n");
-- 
2.38.1


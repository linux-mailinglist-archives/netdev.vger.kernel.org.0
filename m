Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14F4543BE0
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 20:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbiFHS71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 14:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbiFHS7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 14:59:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389893BBC6
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 11:59:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6F6E61C4A
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 18:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B59C34116;
        Wed,  8 Jun 2022 18:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654714760;
        bh=8bjdwgGoh8YLr14oND9gADNMlMD0TkUQ9Bw+RhY0JxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeFe6K1LQESA6Z7MTAYoom9xyiUaKtR5OXLp6KoMifabpJNTpCqbK/fczNzEF6Tdv
         OEM0ozmOXenV6b5d0F0TUWP7PZMVsIuyLdUWZywmCljiQ+hd3cKmbBl/i7dYahCMPi
         8mE0csHPnu8wUpPLO27oNbbxhvMfpLJoSY/HL/stF03ybi3QKzEHIHijlGEu4tqLR3
         AW6UJkYDDNE4+/fLGL1e/657JtjtBTjoMlIt1xPHYgf3csqvVAt9ldRxaaucRem4b1
         wtVMrmCkHrU/5ymjdzDbmewx7AFR54yqDyyNG41qQ4D962kNtuLvAlq1F/QSZnybcH
         z1ScvWFETXjgg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 6/6] net/mlx5: fs, fail conflicting actions
Date:   Wed,  8 Jun 2022 11:58:55 -0700
Message-Id: <20220608185855.19818-7-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220608185855.19818-1-saeed@kernel.org>
References: <20220608185855.19818-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

When combining two steering rules into one check
not only do they share the same actions but those
actions are also the same. This resolves an issue where
when creating two different rules with the same match
the actions are overwritten and one of the rules is deleted
a FW syndrome can be seen in dmesg.

mlx5_core 0000:03:00.0: mlx5_cmd_check:819:(pid 2105): DEALLOC_MODIFY_HEADER_CONTEXT(0x941) op_mod(0x0) failed, status bad resource state(0x9), syndrome (0x1ab444)

Fixes: 0d235c3fabb7 ("net/mlx5: Add hash table to search FTEs in a flow-group")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 35 +++++++++++++++++--
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index fdcf7f529330..21e5c709b2d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1574,9 +1574,22 @@ static struct mlx5_flow_rule *find_flow_rule(struct fs_fte *fte,
 	return NULL;
 }
 
-static bool check_conflicting_actions(u32 action1, u32 action2)
+static bool check_conflicting_actions_vlan(const struct mlx5_fs_vlan *vlan0,
+					   const struct mlx5_fs_vlan *vlan1)
 {
-	u32 xored_actions = action1 ^ action2;
+	return vlan0->ethtype != vlan1->ethtype ||
+	       vlan0->vid != vlan1->vid ||
+	       vlan0->prio != vlan1->prio;
+}
+
+static bool check_conflicting_actions(const struct mlx5_flow_act *act1,
+				      const struct mlx5_flow_act *act2)
+{
+	u32 action1 = act1->action;
+	u32 action2 = act2->action;
+	u32 xored_actions;
+
+	xored_actions = action1 ^ action2;
 
 	/* if one rule only wants to count, it's ok */
 	if (action1 == MLX5_FLOW_CONTEXT_ACTION_COUNT ||
@@ -1593,6 +1606,22 @@ static bool check_conflicting_actions(u32 action1, u32 action2)
 			     MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2))
 		return true;
 
+	if (action1 & MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT &&
+	    act1->pkt_reformat != act2->pkt_reformat)
+		return true;
+
+	if (action1 & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
+	    act1->modify_hdr != act2->modify_hdr)
+		return true;
+
+	if (action1 & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH &&
+	    check_conflicting_actions_vlan(&act1->vlan[0], &act2->vlan[0]))
+		return true;
+
+	if (action1 & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2 &&
+	    check_conflicting_actions_vlan(&act1->vlan[1], &act2->vlan[1]))
+		return true;
+
 	return false;
 }
 
@@ -1600,7 +1629,7 @@ static int check_conflicting_ftes(struct fs_fte *fte,
 				  const struct mlx5_flow_context *flow_context,
 				  const struct mlx5_flow_act *flow_act)
 {
-	if (check_conflicting_actions(flow_act->action, fte->action.action)) {
+	if (check_conflicting_actions(flow_act, &fte->action)) {
 		mlx5_core_warn(get_dev(&fte->node),
 			       "Found two FTEs with conflicting actions\n");
 		return -EEXIST;
-- 
2.36.1


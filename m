Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3EF84C206D
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245176AbiBXAM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245158AbiBXAMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:12:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C395F4DD
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:12:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42F13B8228B
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C55C340F1;
        Thu, 24 Feb 2022 00:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645661539;
        bh=/KTuRGkSeBSzN5vbZ+8JpNAHMYy5QpUy+vpGQtA4YMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7CDaFFN4XTc3lqJUoxrwFzwwvBhvW9rKPR3Xi8/EKi8x/P8Tj2pTlTwo8NU5/xp5
         DfdoGupEunqNL3htUhCwcgDiKg7rwPVIetXiSe7WGxeH/aOiifZvWmiqfZFtC0AbCl
         NMz0WPUK7plA4U3JzWB3tz0k0G6ki5QzdyDOIEt2t427deiU3AzrJNkiI+9FZQhXnz
         Xt6FW9c4eRaOljQC1TzpN/PW3MPqa+yNgJ5t5As6VHCQwI1K/pwqhV3lbrwpDAfJJU
         UEHjVFEymFDI/cIfmGPF8n/a5wk56q+AsfOCWtM0UGPRcM8XYqrSH+5g4YxTvMYeIl
         uJkdZoruurE4Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 03/19] net/mlx5: DR, Fix slab-out-of-bounds in mlx5_cmd_dr_create_fte
Date:   Wed, 23 Feb 2022 16:11:07 -0800
Message-Id: <20220224001123.365265-4-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224001123.365265-1-saeed@kernel.org>
References: <20220224001123.365265-1-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When adding a rule with 32 destinations, we hit the following out-of-band
access issue:

  BUG: KASAN: slab-out-of-bounds in mlx5_cmd_dr_create_fte+0x18ee/0x1e70

This patch fixes the issue by both increasing the allocated buffers to
accommodate for the needed actions and by checking the number of actions
to prevent this issue when a rule with too many actions is provided.

Fixes: 1ffd498901c1 ("net/mlx5: DR, Increase supported num of actions to 32")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/fs_dr.c       | 33 +++++++++++++++----
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index a476da2424f8..3f311462bedf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -233,7 +233,11 @@ static bool contain_vport_reformat_action(struct mlx5_flow_rule *dst)
 		dst->dest_attr.vport.flags & MLX5_FLOW_DEST_VPORT_REFORMAT_ID;
 }
 
-#define MLX5_FLOW_CONTEXT_ACTION_MAX  32
+/* We want to support a rule with 32 destinations, which means we need to
+ * account for 32 destinations plus usually a counter plus one more action
+ * for a multi-destination flow table.
+ */
+#define MLX5_FLOW_CONTEXT_ACTION_MAX  34
 static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 				  struct mlx5_flow_table *ft,
 				  struct mlx5_flow_group *group,
@@ -403,9 +407,9 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 			enum mlx5_flow_destination_type type = dst->dest_attr.type;
 			u32 id;
 
-			if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX ||
-			    num_term_actions >= MLX5_FLOW_CONTEXT_ACTION_MAX) {
-				err = -ENOSPC;
+			if (fs_dr_num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX ||
+			    num_term_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
+				err = -EOPNOTSUPP;
 				goto free_actions;
 			}
 
@@ -478,8 +482,9 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 			    MLX5_FLOW_DESTINATION_TYPE_COUNTER)
 				continue;
 
-			if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
-				err = -ENOSPC;
+			if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX ||
+			    fs_dr_num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
+				err = -EOPNOTSUPP;
 				goto free_actions;
 			}
 
@@ -499,14 +504,28 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 	params.match_sz = match_sz;
 	params.match_buf = (u64 *)fte->val;
 	if (num_term_actions == 1) {
-		if (term_actions->reformat)
+		if (term_actions->reformat) {
+			if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
+				err = -EOPNOTSUPP;
+				goto free_actions;
+			}
 			actions[num_actions++] = term_actions->reformat;
+		}
 
+		if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
+			err = -EOPNOTSUPP;
+			goto free_actions;
+		}
 		actions[num_actions++] = term_actions->dest;
 	} else if (num_term_actions > 1) {
 		bool ignore_flow_level =
 			!!(fte->action.flags & FLOW_ACT_IGNORE_FLOW_LEVEL);
 
+		if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX ||
+		    fs_dr_num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
+			err = -EOPNOTSUPP;
+			goto free_actions;
+		}
 		tmp_action = mlx5dr_action_create_mult_dest_tbl(domain,
 								term_actions,
 								num_term_actions,
-- 
2.35.1


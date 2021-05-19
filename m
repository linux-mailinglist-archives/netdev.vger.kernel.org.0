Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1581A388753
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244103AbhESGIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:08:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239602AbhESGHc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5571B613AC;
        Wed, 19 May 2021 06:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404372;
        bh=2AOx7Zv/D8pja3f9d5vucks+T8WeXOiI/DKRq1z30ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDoE23yM9WIxJgiIVYJiLZqxkKXsEfkU9r96NvXmhAzWL1HjNVL4HUTHqm1qBN46e
         /hEs6eU+WIiP2OEAE+3HLhxfLm9AuJFB2FQBTkS4YwdN5/F7A+wNzf1kjnw1lJcD7+
         xAYOJtfXcmmP+J+uK4llWEHyIASmoq7Y7wAVUoXQiuUSEXdS36WSwW9uV4J+culJfm
         H6umUo43Du7TfIoEYrYb2mrWpJHtpzPx3Jy8ydB63SMpDGdoh/Q3kAK5DQHwxVUHiP
         Hboq+kq5M/PI15sLHwSatWebUPRzHv4qqCQQDLknKK4Aw+ZHElLO3+7OaDg1EFtNeJ
         fD1XfMswx8gaw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 15/16] net/mlx5: Set term table as an unmanaged flow table
Date:   Tue, 18 May 2021 23:05:22 -0700
Message-Id: <20210519060523.17875-16-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

Termination tables are restricted to have the default miss action and
cannot be set to forward to another table in case of a miss.
If the fs prio of the termination table is not the last one in the
list, fs_core will attempt to attach it to another table.

Set the unmanaged ft flag when creating the termination table ft
and select the tc offload prio for it to prevent fs_core from selecting
the forwarding to next ft miss action and use the default one.

In addition, set the flow that forwards to the termination table to
ignore ft level restrictions since the ft level is not set by fs_core
for unamanged fts.

Fixes: 249ccc3c95bd ("net/mlx5e: Add support for offloading traffic from uplink to uplink")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index d61bee2d35fe..b45954905845 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -76,10 +76,11 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 	/* As this is the terminating action then the termination table is the
 	 * same prio as the slow path
 	 */
-	ft_attr.flags = MLX5_FLOW_TABLE_TERMINATION |
+	ft_attr.flags = MLX5_FLOW_TABLE_TERMINATION | MLX5_FLOW_TABLE_UNMANAGED |
 			MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
-	ft_attr.prio = FDB_SLOW_PATH;
+	ft_attr.prio = FDB_TC_OFFLOAD;
 	ft_attr.max_fte = 1;
+	ft_attr.level = 1;
 	ft_attr.autogroup.max_num_groups = 1;
 	tt->termtbl = mlx5_create_auto_grouped_flow_table(root_ns, &ft_attr);
 	if (IS_ERR(tt->termtbl)) {
@@ -217,6 +218,7 @@ mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 	int i;
 
 	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, termination_table) ||
+	    !MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ignore_flow_level) ||
 	    attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH ||
 	    !mlx5_eswitch_offload_is_uplink_port(esw, spec))
 		return false;
@@ -289,6 +291,7 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 	/* create the FTE */
 	flow_act->action &= ~MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
 	flow_act->pkt_reformat = NULL;
+	flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
 	rule = mlx5_add_flow_rules(fdb, spec, flow_act, dest, num_dest);
 	if (IS_ERR(rule))
 		goto revert_changes;
-- 
2.31.1


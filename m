Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86FA388745
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240502AbhESGHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:07:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238044AbhESGHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 354D6613AF;
        Wed, 19 May 2021 06:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404366;
        bh=IjPQyGARqgqsCnZhEeXB8vWDFSVypy6GT3CY7uocjrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYpmBsUQBni+YUxDP6cKWdZCKmFXgYZajilhepfmyOkCU/pCdPcccBkl+zfhe4LSM
         UW66IjeAKgmxB7+pg3wfxgnYrE2KaDerFW9I2rWpL1RF841KUvo3uHCZaqZK68+STa
         j6RYRlQngIMj/bCYpxbu3prFvXKkXUbgIfUXVWeP4xAJ7qiziPiEpwl83HxMFiAJVW
         UH+5st6Ecv4QV7wnOYyYNsc3f3hoQTqnLHhXk1W5aoyg+jcHBdO/fysg6gvZTz6sRu
         6xI/2kCA52g2tc5qKtA0sCOLg6M0T/NB7bGskueadSfLjhcZksg6ZPu8gmmfshIVyH
         MerxlCxQZAl5g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 03/16] net/mlx5: Set reformat action when needed for termination rules
Date:   Tue, 18 May 2021 23:05:10 -0700
Message-Id: <20210519060523.17875-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

For remote mirroring, after the tunnel packets are received, they are
decapsulated and sent to representor, then re-encapsulated and sent
out over another tunnel. So reformat action is set only when the
destination is required to do encapsulation.

Fixes: 249ccc3c95bd ("net/mlx5e: Add support for offloading traffic from uplink to uplink")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mlx5/core/eswitch_offloads_termtbl.c      | 31 ++++++-------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index a81ece94f599..e3e7fdd396ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -172,19 +172,6 @@ mlx5_eswitch_termtbl_put(struct mlx5_eswitch *esw,
 	}
 }
 
-static bool mlx5_eswitch_termtbl_is_encap_reformat(struct mlx5_pkt_reformat *rt)
-{
-	switch (rt->reformat_type) {
-	case MLX5_REFORMAT_TYPE_L2_TO_VXLAN:
-	case MLX5_REFORMAT_TYPE_L2_TO_NVGRE:
-	case MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL:
-	case MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL:
-		return true;
-	default:
-		return false;
-	}
-}
-
 static void
 mlx5_eswitch_termtbl_actions_move(struct mlx5_flow_act *src,
 				  struct mlx5_flow_act *dst)
@@ -202,14 +189,6 @@ mlx5_eswitch_termtbl_actions_move(struct mlx5_flow_act *src,
 			memset(&src->vlan[1], 0, sizeof(src->vlan[1]));
 		}
 	}
-
-	if (src->action & MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT &&
-	    mlx5_eswitch_termtbl_is_encap_reformat(src->pkt_reformat)) {
-		src->action &= ~MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
-		dst->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
-		dst->pkt_reformat = src->pkt_reformat;
-		src->pkt_reformat = NULL;
-	}
 }
 
 static bool mlx5_eswitch_offload_is_uplink_port(const struct mlx5_eswitch *esw,
@@ -279,6 +258,14 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 		if (dest[i].type != MLX5_FLOW_DESTINATION_TYPE_VPORT)
 			continue;
 
+		if (attr->dests[num_vport_dests].flags & MLX5_ESW_DEST_ENCAP) {
+			term_tbl_act.action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+			term_tbl_act.pkt_reformat = attr->dests[num_vport_dests].pkt_reformat;
+		} else {
+			term_tbl_act.action &= ~MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+			term_tbl_act.pkt_reformat = NULL;
+		}
+
 		/* get the terminating table for the action list */
 		tt = mlx5_eswitch_termtbl_get_create(esw, &term_tbl_act,
 						     &dest[i], attr);
@@ -301,6 +288,8 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 		goto revert_changes;
 
 	/* create the FTE */
+	flow_act->action &= ~MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+	flow_act->pkt_reformat = NULL;
 	rule = mlx5_add_flow_rules(fdb, spec, flow_act, dest, num_dest);
 	if (IS_ERR(rule))
 		goto revert_changes;
-- 
2.31.1


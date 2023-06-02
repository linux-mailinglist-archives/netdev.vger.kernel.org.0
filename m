Return-Path: <netdev+bounces-7555-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E2FB672099E
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:15:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D81C28091B
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 533C01EA78;
	Fri,  2 Jun 2023 19:13:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5B11E53B
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F14C433A1;
	Fri,  2 Jun 2023 19:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685733188;
	bh=MDAWxVfYS8YboyTj5Pxe0e27WMK92SbdY5tmV2HlLZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ethhpOKQEh4kHV4dZ9bGWpc6q3/AxhfoltnjwIDAp6F5ERXezNE8cSSgEZhIflftd
	 Vf5UjYmUdjyUSUnjXr2LFTSKgsZ9PS2hiPFkVEPktmvZx63xl42KgRqRJR2dkyBvb3
	 TZsPA6zsOFZUPOGkMIszAuQZq4qef+uebAkpwGhAK0Y/WBGmLWJoiU6rozId1LKdws
	 S3wEl0V2mE6Myu+FOyJ99EYJhVvIJX0BrFXmyDmazzhISZX7y7+WH2UORh1BKMdDjS
	 2FAm0ffUPR9/eUCFfG0tjav1x9EQdQYp1rWV7wYW9dxrE+BNlOiZOzajtmPh1K66ZG
	 nnWS4sxPG3YmA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [net-next V2 07/14] net/mlx5: E-switch, refactor FDB miss rule add/remove
Date: Fri,  2 Jun 2023 12:12:54 -0700
Message-Id: <20230602191301.47004-8-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230602191301.47004-1-saeed@kernel.org>
References: <20230602191301.47004-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

Currently, E-switch FDB have a single peer miss rule.
In order to support more than one peer, refactor E-switch FDB to
have peer miss rule per peer, and change the code to add/remove a
rule from specific peer.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h        | 2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index eadc39542e5e..2a941e1cc686 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -218,7 +218,7 @@ struct mlx5_eswitch_fdb {
 			struct mlx5_flow_group *send_to_vport_grp;
 			struct mlx5_flow_group *send_to_vport_meta_grp;
 			struct mlx5_flow_group *peer_miss_grp;
-			struct mlx5_flow_handle **peer_miss_rules;
+			struct mlx5_flow_handle **peer_miss_rules[MLX5_MAX_PORTS];
 			struct mlx5_flow_group *miss_grp;
 			struct mlx5_flow_handle **send_to_vport_meta_rules;
 			struct mlx5_flow_handle *miss_rule_uni;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index ca69ed487413..a7f352777d9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1132,7 +1132,7 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 		flows[vport->index] = flow;
 	}
 
-	esw->fdb_table.offloads.peer_miss_rules = flows;
+	esw->fdb_table.offloads.peer_miss_rules[mlx5_get_dev_index(peer_dev)] = flows;
 
 	kvfree(spec);
 	return 0;
@@ -1160,13 +1160,14 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 	return err;
 }
 
-static void esw_del_fdb_peer_miss_rules(struct mlx5_eswitch *esw)
+static void esw_del_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
+					struct mlx5_core_dev *peer_dev)
 {
 	struct mlx5_flow_handle **flows;
 	struct mlx5_vport *vport;
 	unsigned long i;
 
-	flows = esw->fdb_table.offloads.peer_miss_rules;
+	flows = esw->fdb_table.offloads.peer_miss_rules[mlx5_get_dev_index(peer_dev)];
 
 	mlx5_esw_for_each_vf_vport(esw, i, vport, mlx5_core_max_vfs(esw->dev))
 		mlx5_del_flow_rules(flows[vport->index]);
@@ -2700,7 +2701,7 @@ static void mlx5_esw_offloads_unpair(struct mlx5_eswitch *esw,
 	mlx5e_tc_clean_fdb_peer_flows(esw);
 #endif
 	mlx5_esw_offloads_rep_event_unpair(esw, peer_esw);
-	esw_del_fdb_peer_miss_rules(esw);
+	esw_del_fdb_peer_miss_rules(esw, peer_esw->dev);
 }
 
 static int mlx5_esw_offloads_pair(struct mlx5_eswitch *esw,
-- 
2.40.1



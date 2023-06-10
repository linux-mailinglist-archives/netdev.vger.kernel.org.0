Return-Path: <netdev+bounces-9767-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AD3172A7AE
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:45:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 997F71C21110
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:45:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E564C5CB8;
	Sat, 10 Jun 2023 01:43:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B873A5390
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5C8C433AA;
	Sat, 10 Jun 2023 01:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686361391;
	bh=/NDVrca7++d8YvkWHsmqniDnfUbos0HQq+usHNxLxJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0gup4XHYGxXaAAkt7b+qqWwuJTLgS4Mqw/dnBKhF8JmvO+qtNxJhYdJ01WcRLwhd
	 5BkSO3tI+q3LhXQq+pgjwSJOF2C5nKwd7IIlNNi4a+IK+d7VYQ9oKxy0cHOw/lxT+J
	 /XNRLzW4KnM8G/r6ipmsavaE3epbhIRwqYpHdTJTuJ4QopO513L8t+sKRdQqq7+imn
	 +mEFQGWJXGknBcKoJ+Q2hm0H1lZABenHLNdoB6SnI4HhuQrsYGoNFzE+I3SLCHQFnV
	 F1BKkCAQpXT5lIDJ3+aB9SqtK9VqSTSNaq4mWG9DuRj/Bd2y+H+nNiwUHIdtv6gszK
	 NeQ2X7FV1n5rQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Jurgens <danielj@nvidia.com>,
	William Tu <witu@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [net-next 06/15] net/mlx5: Add/remove peer miss rules for EC VFs
Date: Fri,  9 Jun 2023 18:42:45 -0700
Message-Id: <20230610014254.343576-7-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230610014254.343576-1-saeed@kernel.org>
References: <20230610014254.343576-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Daniel Jurgens <danielj@nvidia.com>

Add and remove the peer miss rules for EC VFs. It's possible that there
are different amounts of total VFs per function so only create rules for
the minimum number of max VFs.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 68798aed792f..fdf482f6fb34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1125,11 +1125,32 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 		flows[vport->index] = flow;
 	}
 
+	if (mlx5_core_ec_sriov_enabled(esw->dev)) {
+		mlx5_esw_for_each_ec_vf_vport(esw, i, vport, mlx5_core_max_ec_vfs(esw->dev)) {
+			if (i >= mlx5_core_max_ec_vfs(peer_dev))
+				break;
+			esw_set_peer_miss_rule_source_port(esw, peer_dev->priv.eswitch,
+							   spec, vport->vport);
+			flow = mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
+						   spec, &flow_act, &dest, 1);
+			if (IS_ERR(flow)) {
+				err = PTR_ERR(flow);
+				goto add_ec_vf_flow_err;
+			}
+			flows[vport->index] = flow;
+		}
+	}
 	esw->fdb_table.offloads.peer_miss_rules[mlx5_get_dev_index(peer_dev)] = flows;
 
 	kvfree(spec);
 	return 0;
 
+add_ec_vf_flow_err:
+	mlx5_esw_for_each_ec_vf_vport(esw, i, vport, mlx5_core_max_ec_vfs(esw->dev)) {
+		if (!flows[vport->index])
+			continue;
+		mlx5_del_flow_rules(flows[vport->index]);
+	}
 add_vf_flow_err:
 	mlx5_esw_for_each_vf_vport(esw, i, vport, mlx5_core_max_vfs(esw->dev)) {
 		if (!flows[vport->index])
@@ -1162,6 +1183,17 @@ static void esw_del_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 
 	flows = esw->fdb_table.offloads.peer_miss_rules[mlx5_get_dev_index(peer_dev)];
 
+	if (mlx5_core_ec_sriov_enabled(esw->dev)) {
+		mlx5_esw_for_each_ec_vf_vport(esw, i, vport, mlx5_core_max_ec_vfs(esw->dev)) {
+			/* The flow for a particular vport could be NULL if the other ECPF
+			 * has fewer or no VFs enabled
+			 */
+			if (!flows[vport->index])
+				continue;
+			mlx5_del_flow_rules(flows[vport->index]);
+		}
+	}
+
 	mlx5_esw_for_each_vf_vport(esw, i, vport, mlx5_core_max_vfs(esw->dev))
 		mlx5_del_flow_rules(flows[vport->index]);
 
-- 
2.40.1



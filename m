Return-Path: <netdev+bounces-7554-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1289972099A
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:15:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC181281AE3
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F3F1EA62;
	Fri,  2 Jun 2023 19:13:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445C21E534
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1226DC433AC;
	Fri,  2 Jun 2023 19:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685733188;
	bh=phNa4lDyS/mtlWLUPBjgf/99yax01Gs043JMuquMuFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYtKQMzJzDH9dxaxOTTWeJaMUhlfZ2z6b7IjzuD1rHWsPhP2LGdrp6HU1UoXQ+lzE
	 uWDbPaQR3Jlbgy0cSjgYCLpsdf879HoqcW7MFPxxHuMHjfBGvixn+pBNGTl5QYBUvZ
	 atrP/Ys1Tig+HEoEfiUIGvtGcq7L3TMfYCqCModEhWymsdK3zLa/uzrxdOU17IvtLj
	 tAubKbWca36QtLKnj8Q83yd5q3oUAf8RstRx0jqXjK3slJAYOB0aMYbcSYgZMuK264
	 0O/esenEFrf2ZdzBDYCbpyazsf3z2OphftQq9u68HNRswxHUrRIRf5UfekekYdkIYB
	 sAGx3gJarsjrQ==
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
Subject: [net-next V2 06/14] net/mlx5: E-switch, enlarge peer miss group table
Date: Fri,  2 Jun 2023 12:12:53 -0700
Message-Id: <20230602191301.47004-7-saeed@kernel.org>
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

There is an implicit assumption that peer miss group table
require to handle only a single peer.
Also, there is an assumption that total_vports of the master
is greater or equal to the total_vports of each peer.
Change the code to support peer miss group for more than one peer.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index a767f3d52c76..ca69ed487413 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1573,6 +1573,7 @@ esw_create_peer_esw_miss_group(struct mlx5_eswitch *esw,
 			       u32 *flow_group_in,
 			       int *ix)
 {
+	int max_peer_ports = (esw->total_vports - 1) * (MLX5_MAX_PORTS - 1);
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_group *g;
 	void *match_criteria;
@@ -1599,8 +1600,8 @@ esw_create_peer_esw_miss_group(struct mlx5_eswitch *esw,
 
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, *ix);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
-		 *ix + esw->total_vports - 1);
-	*ix += esw->total_vports;
+		 *ix + max_peer_ports);
+	*ix += max_peer_ports + 1;
 
 	g = mlx5_create_flow_group(fdb, flow_group_in);
 	if (IS_ERR(g)) {
@@ -1702,7 +1703,7 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	 * total vports of the peer (currently is also uses esw->total_vports).
 	 */
 	table_size = MLX5_MAX_PORTS * (esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ) +
-		     esw->total_vports * 2 + MLX5_ESW_MISS_FLOWS;
+		     esw->total_vports * MLX5_MAX_PORTS + MLX5_ESW_MISS_FLOWS;
 
 	/* create the slow path fdb with encap set, so further table instances
 	 * can be created at run time while VFs are probed if the FW allows that.
-- 
2.40.1



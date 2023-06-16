Return-Path: <netdev+bounces-11574-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2544C733A53
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:03:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51DD51C2107C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 969A11F952;
	Fri, 16 Jun 2023 20:01:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBE71F93D
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360DDC433CA;
	Fri, 16 Jun 2023 20:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686945688;
	bh=g6MvtojYznDx3RMnUlGBCG20iAyTZnKkWTji/XFebm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sv6EQjgilvixALnoVHBatWyO9i/DtCOqKPiJEf9SpREYPxuVD1fZMGr4VrhZn+wFi
	 W3LJI5GsVRkfS60aynwZTSyD/HYS9QZIlWP73c9Hd5hPlfOFlEyQ0z2gFq2ze9+z3T
	 uvOwe8C7O4wvZVnzL3W5/n2nP1WRjqho3bltfYLlEJsnUkqMhN97o6C5TBOkTkhPqO
	 dobnMR6qV8+K1/QZg4eIONnWHH+dpNxHq2oL7grSr4IwZ1Liqm3XvGLM7czPjzhD3F
	 tiJvG6Xaj4ta8HOjS2C9lJ2b4FkKVDLqT/DJEHPZSb0+Dit8SXg5/5j5/Dl4fdBOh8
	 3OzIMA5lpbOtw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Chris Mi <cmi@nvidia.com>,
	Paul Blakey <paulb@nvidia.com>
Subject: [net 05/12] net/mlx5e: TC, Cleanup ct resources for nic flow
Date: Fri, 16 Jun 2023 13:01:12 -0700
Message-Id: <20230616200119.44163-6-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616200119.44163-1-saeed@kernel.org>
References: <20230616200119.44163-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chris Mi <cmi@nvidia.com>

The cited commit removes special handling of CT action. But it
removes too much. Pre ct/ct_nat tables and some other resources
are not destroyed due to the cited commit.

Fix it by adding it back.

Fixes: 08fe94ec5f77 ("net/mlx5e: TC, Remove special handling of CT action")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 8a5a8703f0a3..b9b1da751a3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1439,6 +1439,7 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 		mlx5e_hairpin_flow_del(priv, flow);
 
 	free_flow_post_acts(flow);
+	mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), attr);
 
 	kvfree(attr->parse_attr);
 	kfree(flow->attr);
-- 
2.40.1



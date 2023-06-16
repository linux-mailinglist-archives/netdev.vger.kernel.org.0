Return-Path: <netdev+bounces-11576-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55F65733A55
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:04:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 108DD2818C9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24D321F953;
	Fri, 16 Jun 2023 20:01:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36F11ED3D
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A856C433BA;
	Fri, 16 Jun 2023 20:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686945690;
	bh=UuTL/VbBkhjUO51tLbcAE6W/vVdZqhQWPnHnY6pOpyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWv38m5WM1euGHRpNIXm3q+6fsZNvFmmS27NVkkMZbDeDU/tDxnTo9oNtkObHHwq/
	 nSwGeektkskXcsK2U9HVPIItQf5+KVi8ejY3U1fZ3mNtRVNeEikbY50Gqe88gtFPpj
	 dCKcGRP0rWjjuW1J7SDadybR91bz2S9wgMK1XIzjnFcKeUq7/1k7wA4HUg0CU6xbXq
	 g4x8awguA5FNAj4R40f5Nnhr+ypshSIUCxPM+LRI4vaRK+t3bxWB/30HueW0mQT6CT
	 rgqP+1vAFcpFcqJ12ULYkV5AObFoNMy016jqlYFuhdY2CK5t6eDBAWVqjFyH4Gx6Jh
	 +iql+WHsIibLw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Alex Vesker <valex@nvidia.com>
Subject: [net 07/12] net/mlx5: DR, Fix wrong action data allocation in decap action
Date: Fri, 16 Jun 2023 13:01:14 -0700
Message-Id: <20230616200119.44163-8-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When TUNNEL_L3_TO_L2 decap action was created, a pointer to a local
variable was passed as its HW action data, resulting in attempt to
free invalid address:

  BUG: KASAN: invalid-free in mlx5dr_action_destroy+0x318/0x410 [mlx5_core]

Fixes: 4781df92f4da ("net/mlx5: DR, Move STEv0 modify header logic")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_action.c  | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 57e22c5170df..0f783e7906cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1421,9 +1421,13 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 	}
 	case DR_ACTION_TYP_TNL_L3_TO_L2:
 	{
-		u8 hw_actions[DR_ACTION_CACHE_LINE_SIZE] = {};
+		u8 *hw_actions;
 		int ret;
 
+		hw_actions = kzalloc(DR_ACTION_CACHE_LINE_SIZE, GFP_KERNEL);
+		if (!hw_actions)
+			return -ENOMEM;
+
 		ret = mlx5dr_ste_set_action_decap_l3_list(dmn->ste_ctx,
 							  data, data_sz,
 							  hw_actions,
@@ -1431,6 +1435,7 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 							  &action->rewrite->num_of_actions);
 		if (ret) {
 			mlx5dr_dbg(dmn, "Failed creating decap l3 action list\n");
+			kfree(hw_actions);
 			return ret;
 		}
 
@@ -1440,6 +1445,7 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 		ret = mlx5dr_ste_alloc_modify_hdr(action);
 		if (ret) {
 			mlx5dr_dbg(dmn, "Failed preparing reformat data\n");
+			kfree(hw_actions);
 			return ret;
 		}
 		return 0;
-- 
2.40.1



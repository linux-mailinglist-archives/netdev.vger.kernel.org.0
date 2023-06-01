Return-Path: <netdev+bounces-6973-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D972C719122
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:14:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 719821C20FFF
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 03:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E54644C84;
	Thu,  1 Jun 2023 03:10:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3B979F1
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 03:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB56C4339E;
	Thu,  1 Jun 2023 03:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685589058;
	bh=BwVNEAKMQrgFHGpg/63vwwyGrSq1f0dQw+q227RKUuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXqrzgg0MDFYT2K1YS1mne9vUQ+lY22D0ztSWT1zHpiCY+Fwkdyy8S06pJNTQlrVW
	 cz+Y3qxO9OGwhkDSbpjDkr2LI1Uon1uVZfs8fLmn/pfcDv+Sj0rh0jJJwRjuKd68fh
	 NYr2kscmT5bD7M4BNFkdpqZoAf2hEzzNOwR/Rpg8nTLCYfyx1vQkOUb3/zNv5O7N3o
	 DIHhOx5cR76KCGf4MjOLb1EoJmfeNwxskNFQM1OioJqLuZNAuLv4OEp2Mdle25E06g
	 H8AFq3FJyiInm2vDOCdIlejyWzFfRYTBhg7KJYx/PE0qo9NUnkqA6nEr3zdbNsaV9C
	 4zAOE9mNXN83w==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>
Subject: [net 4/5] net/mlx5e: Fix error handling in mlx5e_refresh_tirs
Date: Wed, 31 May 2023 20:10:50 -0700
Message-Id: <20230601031051.131529-5-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601031051.131529-1-saeed@kernel.org>
References: <20230601031051.131529-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

Allocation failure is outside the critical lock section and should
return immediately rather than jumping to the unlock section.

Also unlock as soon as required and remove the now redundant jump label.

Fixes: 80a2a9026b24 ("net/mlx5e: Add a lock on tir list")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_common.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index 1f90594499c6..41c396e76457 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -150,10 +150,8 @@ int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb,
 
 	inlen = MLX5_ST_SZ_BYTES(modify_tir_in);
 	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!in)
+		return -ENOMEM;
 
 	if (enable_uc_lb)
 		lb_flags = MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST;
@@ -171,14 +169,13 @@ int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb,
 		tirn = tir->tirn;
 		err = mlx5_core_modify_tir(mdev, tirn, in);
 		if (err)
-			goto out;
+			break;
 	}
+	mutex_unlock(&mdev->mlx5e_res.hw_objs.td.list_lock);
 
-out:
 	kvfree(in);
 	if (err)
 		netdev_err(priv->netdev, "refresh tir(0x%x) failed, %d\n", tirn, err);
-	mutex_unlock(&mdev->mlx5e_res.hw_objs.td.list_lock);
 
 	return err;
 }
-- 
2.40.1



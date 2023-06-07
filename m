Return-Path: <netdev+bounces-9076-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C032727048
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 23:08:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3780B2815E4
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A745846FE4;
	Wed,  7 Jun 2023 21:04:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562013D380
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 21:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BE9C433D2;
	Wed,  7 Jun 2023 21:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686171882;
	bh=jkQIavP0egw0W+tGs44PZmvMJfnRcnxtusr/15lMK+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roPbpXBwT1dQzBheL8YS3crGmA1tpHrwAWWsv01XLx1Ia9MGyPcLV5vHG8nDkK6m+
	 0E76dk1uo3MEzRjcngfZgieDtOwFLIdeHqJRkfVOtFdVblDeRWQrhOPIsrcXQ9Fv97
	 6pES7GhODfE3sJbBoE93A90rsy1nV0ev4LPD+9pywPqzTL4wsOoBbbcpPtFSjScaVa
	 U2iK6JYNQQFBVX/VUt+jrcE49q7TuA6RmtJlz/0vt3i3JSEp174Fg+nYXvcyKnVrNN
	 fZCMTqfnt/+7cRtp2Lop1bnaRaPn8RCNWKoQh3oLhvyUkIyA7SkoJK1N6nMAOGuSbt
	 oNM0SbKubztmg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-rdma@vger.kernel.org,
	Jiri Pirko <jiri@nvidia.com>
Subject: [net-next V2 12/14] net/mlx5: Skip inline mode check after mlx5_eswitch_enable_locked() failure
Date: Wed,  7 Jun 2023 14:04:08 -0700
Message-Id: <20230607210410.88209-13-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607210410.88209-1-saeed@kernel.org>
References: <20230607210410.88209-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Commit bffaa916588e ("net/mlx5: E-Switch, Add control for inline mode")
added inline mode checking to esw_offloads_start() with a warning
printed out in case there is a problem. Tne inline mode checking was
done even after mlx5_eswitch_enable_locked() call failed, which is
pointless.

Later on, commit 8c98ee77d911 ("net/mlx5e: E-Switch, Add extack messages
to devlink callbacks") converted the error/warning prints to extack
setting, which caused that the inline mode check error to overwrite
possible previous extack message when mlx5_eswitch_enable_locked()
failed. User then gets confusing error message.

Fix this by skipping check of inline mode after
mlx5_eswitch_enable_locked() call failed.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 29de4e759f4f..eafb098db6b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2178,6 +2178,7 @@ static int esw_offloads_start(struct mlx5_eswitch *esw,
 				   "Failed setting eswitch to offloads");
 		esw->mode = MLX5_ESWITCH_LEGACY;
 		mlx5_rescan_drivers(esw->dev);
+		return err;
 	}
 	if (esw->offloads.inline_mode == MLX5_INLINE_MODE_NONE) {
 		if (mlx5_eswitch_inline_mode_get(esw,
@@ -2187,7 +2188,7 @@ static int esw_offloads_start(struct mlx5_eswitch *esw,
 					   "Inline mode is different between vports");
 		}
 	}
-	return err;
+	return 0;
 }
 
 static void mlx5_esw_offloads_rep_mark_set(struct mlx5_eswitch *esw,
-- 
2.40.1



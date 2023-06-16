Return-Path: <netdev+bounces-11591-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C204733A88
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:12:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DBBD1C2107D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE4F51F938;
	Fri, 16 Jun 2023 20:11:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980281ED58
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02012C433C0;
	Fri, 16 Jun 2023 20:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946293;
	bh=bpHxazJpKXnJzRID5mHNLZ4TrFf3SKoBNaTNc5BV9+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=miz94XSgjvN6xJh2fXorz/Woba2WmO154y9dV8B3Wkp9owYkiL4RRKoC9/jzd5bzr
	 WMBsBYkNHtrFTTx4dXR0ileiiFNXPU7ifxb30iMmO97U8Nnk4mJSQCW1qgAWidZDyI
	 0tZTEHgX+LmOcS7dt1ZGLIkM9X2SRbbPrKpr3rp5KyM+DLVnoikyFjHVg1dh2vYODR
	 MUO763Hbizh1q+7cWE795aFga0k1hsE04je9YuUg5hAP/Wo2koVIRfLVSRtk4AN0fR
	 AW/sZST8ZpuZtPEOKs9kYcKdP/iPPweilAEPfP8OaHtufeb814dduKgigeZWw64yTY
	 BxUPPgI/hoZjw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drory <shayd@nvidia.com>
Subject: [net-next 02/15] net/mlx5: Expose timeout for sync reset unload stage
Date: Fri, 16 Jun 2023 13:11:00 -0700
Message-Id: <20230616201113.45510-3-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616201113.45510-1-saeed@kernel.org>
References: <20230616201113.45510-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Moshe Shemesh <moshe@nvidia.com>

Expose new timoueout in Default Timeouts Register to be used on sync
reset flow running on smart NIC. In this flow the driver should know how
much time to wait from getting unload request till firmware will ask the
PF to continue to next stage of the flow.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c | 4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h | 1 +
 include/linux/mlx5/mlx5_ifc.h                      | 4 +++-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
index 696e45e2bd06..a87d0178ebf3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
@@ -24,7 +24,8 @@ static const u32 tout_def_sw_val[MAX_TIMEOUT_TYPES] = {
 	[MLX5_TO_TEARDOWN_MS] = 3000,
 	[MLX5_TO_FSM_REACTIVATE_MS] = 5000,
 	[MLX5_TO_RECLAIM_PAGES_MS] = 5000,
-	[MLX5_TO_RECLAIM_VFS_PAGES_MS] = 120000
+	[MLX5_TO_RECLAIM_VFS_PAGES_MS] = 120000,
+	[MLX5_TO_RESET_UNLOAD_MS] = 300000
 };
 
 static void tout_set(struct mlx5_core_dev *dev, u64 val, enum mlx5_timeouts_types type)
@@ -146,6 +147,7 @@ static int tout_query_dtor(struct mlx5_core_dev *dev)
 	MLX5_TIMEOUT_FILL(fsm_reactivate_to, out, dev, MLX5_TO_FSM_REACTIVATE_MS, 0);
 	MLX5_TIMEOUT_FILL(reclaim_pages_to, out, dev, MLX5_TO_RECLAIM_PAGES_MS, 0);
 	MLX5_TIMEOUT_FILL(reclaim_vfs_pages_to, out, dev, MLX5_TO_RECLAIM_VFS_PAGES_MS, 0);
+	MLX5_TIMEOUT_FILL(reset_unload_to, out, dev, MLX5_TO_RESET_UNLOAD_MS, 0);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
index bc9e9aeda847..99e0a05526fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
@@ -26,6 +26,7 @@ enum mlx5_timeouts_types {
 	MLX5_TO_FSM_REACTIVATE_MS,
 	MLX5_TO_RECLAIM_PAGES_MS,
 	MLX5_TO_RECLAIM_VFS_PAGES_MS,
+	MLX5_TO_RESET_UNLOAD_MS,
 
 	MAX_TIMEOUT_TYPES
 };
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 1f4f62cb9f34..14892e795808 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3117,7 +3117,9 @@ struct mlx5_ifc_dtor_reg_bits {
 
 	struct mlx5_ifc_default_timeout_bits reclaim_vfs_pages_to;
 
-	u8         reserved_at_1c0[0x40];
+	struct mlx5_ifc_default_timeout_bits reset_unload_to;
+
+	u8         reserved_at_1c0[0x20];
 };
 
 enum {
-- 
2.40.1



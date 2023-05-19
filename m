Return-Path: <netdev+bounces-3974-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84FC9709E9F
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:56:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EB261C2121C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F6F712B89;
	Fri, 19 May 2023 17:56:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD1212B6E
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0EDC4339C;
	Fri, 19 May 2023 17:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518971;
	bh=vCOUPBBOyDIPjG2zNdvcxi0SKNue21JjHLnFljvpKWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDnHTaQdwWKAUk4DiEDf39X6w3+3Gbu1Rrv2DT+Umj82NhOwduhXK7aTGs4OyHUex
	 cGbuFlniTdG3dU72UVBZuXYN9qMHoWvtZXFpwICIhVy5XeJLYG0fAQwq04JuAnwtRi
	 pUxYeuyVbsEbjKGZa8/QIerwGbwaYzOkiegTK4RTnO676tXJPUn/KZiSiazSJ487xT
	 ESQHZEz5LC4Hc9jX7Nxzf17GgHiCY4JHMTlXynTJ0cTT1TbnRoohmhFa62DEg3Rkjr
	 IeDUQhk+FaMkvpj5VMatp3vBEbkvV+58HvPDStsmNh8E7PFMjmqNhCZfTnyuJVYAyB
	 ARlHLcLkGS2Rw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>
Subject: [net-next 02/15] net/mlx5: E-Switch, Remove redundant check
Date: Fri, 19 May 2023 10:55:44 -0700
Message-Id: <20230519175557.15683-3-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519175557.15683-1-saeed@kernel.org>
References: <20230519175557.15683-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

The call to mlx5_eswitch_enable() also does the same check
and if E-Switch not supported it returns 0 without any change.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 20d7662c10fb..f07d00929162 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -74,9 +74,6 @@ static int mlx5_device_enable_sriov(struct mlx5_core_dev *dev, int num_vfs)
 	struct mlx5_core_sriov *sriov = &dev->priv.sriov;
 	int err, vf, num_msix_count;
 
-	if (!MLX5_ESWITCH_MANAGER(dev))
-		goto enable_vfs_hca;
-
 	err = mlx5_eswitch_enable(dev->priv.eswitch, num_vfs);
 	if (err) {
 		mlx5_core_warn(dev,
@@ -84,7 +81,6 @@ static int mlx5_device_enable_sriov(struct mlx5_core_dev *dev, int num_vfs)
 		return err;
 	}
 
-enable_vfs_hca:
 	num_msix_count = mlx5_get_default_msix_vec_count(dev, num_vfs);
 	for (vf = 0; vf < num_vfs; vf++) {
 		/* Notify the VF before its enablement to let it set
-- 
2.40.1



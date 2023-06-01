Return-Path: <netdev+bounces-7008-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 029C27192F4
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:05:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BE701C20F4F
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF39B17753;
	Thu,  1 Jun 2023 06:01:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5723817737
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0506DC4339C;
	Thu,  1 Jun 2023 06:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685599305;
	bh=8eVbIntkMIM9iGQOc1XpuFdLFiMCKsiMxSe47jDlkJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIn5qd2tWVKC2bfn6teC+1PSYhAR3YkuDRyeNtpFa6KEuuoGEf7TxHtORL4X3XrqQ
	 z36P+/TSn6iAZyBQnf7mOW8iKGiTgCZas2OGRfOTdGSUYVpk2YEi8XceSctlmeMnFG
	 ogMHVX5YHxam+c983dA7rv6iHrMN7lqGunZ3UTY7aLmF575grjPyuPao/hWF+YIXJY
	 ZPh4TVDZQcbZNIrxzjr6Mx/nbHRwSI/bZQ+WT1NsJWZAiHwHYPmZJ9QJ0X/pVg4hCE
	 E3adX/3mNR4viWfXtNZf0Or/Ti5HISuI6xiRYCCtDKh4+5IgojOsiAu4NHTHEB6XJ0
	 c41VI2iUv6loA==
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
Subject: [net-next 12/14] net/mlx5: E-switch, mark devcom as not ready when all eswitches are unpaired
Date: Wed, 31 May 2023 23:01:16 -0700
Message-Id: <20230601060118.154015-13-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601060118.154015-1-saeed@kernel.org>
References: <20230601060118.154015-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

Whenever an eswitch is unpaired with another, the driver mark devcom
as not ready. While this is correct in case we are pairing only two
eswitches, in order to support pairing of more than two eswitches,
driver need to mark devcom as not ready only when all eswitches are
unpaired.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h         | 1 +
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 9833d1a587cc..d6e4ca436f39 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -343,6 +343,7 @@ struct mlx5_eswitch {
 	int                     mode;
 	u16                     manager_vport;
 	u16                     first_host_vport;
+	u8			num_peers;
 	struct mlx5_esw_functions esw_funcs;
 	struct {
 		u32             large_group_num;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index aeb15b10048e..09367a320741 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2836,6 +2836,8 @@ static int mlx5_esw_offloads_devcom_event(int event,
 
 		esw->paired[mlx5_get_dev_index(peer_esw->dev)] = true;
 		peer_esw->paired[mlx5_get_dev_index(esw->dev)] = true;
+		esw->num_peers++;
+		peer_esw->num_peers++;
 		mlx5_devcom_comp_set_ready(devcom, MLX5_DEVCOM_ESW_OFFLOADS, true);
 		break;
 
@@ -2843,7 +2845,10 @@ static int mlx5_esw_offloads_devcom_event(int event,
 		if (!esw->paired[mlx5_get_dev_index(peer_esw->dev)])
 			break;
 
-		mlx5_devcom_comp_set_ready(devcom, MLX5_DEVCOM_ESW_OFFLOADS, false);
+		peer_esw->num_peers--;
+		esw->num_peers--;
+		if (!esw->num_peers && !peer_esw->num_peers)
+			mlx5_devcom_comp_set_ready(devcom, MLX5_DEVCOM_ESW_OFFLOADS, false);
 		esw->paired[mlx5_get_dev_index(peer_esw->dev)] = false;
 		peer_esw->paired[mlx5_get_dev_index(esw->dev)] = false;
 		mlx5_esw_offloads_unpair(peer_esw, esw);
@@ -2884,6 +2889,7 @@ void mlx5_esw_offloads_devcom_init(struct mlx5_eswitch *esw)
 				       mlx5_esw_offloads_devcom_event,
 				       esw);
 
+	esw->num_peers = 0;
 	mlx5_devcom_send_event(devcom,
 			       MLX5_DEVCOM_ESW_OFFLOADS,
 			       ESW_OFFLOADS_DEVCOM_PAIR, esw);
-- 
2.40.1



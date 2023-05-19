Return-Path: <netdev+bounces-3984-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DCF1709EAD
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 560FF1C2121A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 446EA13ACF;
	Fri, 19 May 2023 17:56:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1076814A80
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D05C433D2;
	Fri, 19 May 2023 17:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518979;
	bh=sSeYlxuZHgnrZy2/LeDPoMw1zfpOJ9TV12aiayc6jdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OEOnHHyX9VO5T6mcV5RHv8BGfghwj0JNmnF3yrkmTx5ov3dqrAZ2AqmnXGTaa1Rqm
	 Ju7TOLQJfAtRsyYtiqfwAHKPKH7xtb4eNlixYnjBgMZPtbt670JYT6qQTopriDMorr
	 UO1SC3AYsbcDP6WKEkWALqxRtskn+d90aYE44kfo9VuvxDsebVhNMYQonBCyHGX3id
	 hcIR6CubGSm/APvvZr+SzKJjxDvXjzSI3A314gWQ3A7JW8gsbbFVOdjOfI0U6amfM1
	 W2y0CKN5+r9GhLLGIAZqGuuxdtmesQzVLalDna1Q2++lxQ+M3/VUxZTFNxrG94jxpY
	 eGjfBk5Wyvbmg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>
Subject: [net-next 12/15] net/mlx5: E-Switch, Use RoCE version 2 for loopback traffic
Date: Fri, 19 May 2023 10:55:54 -0700
Message-Id: <20230519175557.15683-13-saeed@kernel.org>
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

Could be port initializing eswitch doesn't support RoCE version 1
but all ports should support RoCE version 2.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
index 540cf05f6373..15bb562b3846 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
@@ -115,7 +115,7 @@ static int mlx5_rdma_enable_roce_steering(struct mlx5_core_dev *dev)
 
 static void mlx5_rdma_del_roce_addr(struct mlx5_core_dev *dev)
 {
-	mlx5_core_roce_gid_set(dev, 0, 0, 0,
+	mlx5_core_roce_gid_set(dev, 0, MLX5_ROCE_VERSION_2, 0,
 			       NULL, NULL, false, 0, 1);
 }
 
@@ -135,7 +135,7 @@ static int mlx5_rdma_add_roce_addr(struct mlx5_core_dev *dev)
 
 	mlx5_rdma_make_default_gid(dev, &gid);
 	return mlx5_core_roce_gid_set(dev, 0,
-				      MLX5_ROCE_VERSION_1,
+				      MLX5_ROCE_VERSION_2,
 				      0, gid.raw, mac,
 				      false, 0, 1);
 }
-- 
2.40.1



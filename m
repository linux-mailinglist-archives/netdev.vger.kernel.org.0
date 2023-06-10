Return-Path: <netdev+bounces-9769-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFC2D72A7B2
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:45:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BC1C281AD0
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D87324C98;
	Sat, 10 Jun 2023 01:43:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCF76FC7
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9ADC433B4;
	Sat, 10 Jun 2023 01:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686361393;
	bh=f+uV6OO2UdVkLOXJAoAZNzsYjGo5bCpVkGq9Js1L3u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTzDoFFbP1WNo7GxR9WgorvHBUrY5b8YLmXGYNUNvPpVNcTqQJ8WhjbJKwIMmfNSK
	 Pf2+0Ss3ynhnLMiz3I8iqYAZSxGrfYQYuEdAUSgryJBzSpYDbmDTaoZrSWcZ3CMi4n
	 sd/udXV76Lx6SuYymsbY67ulXeSGYWvigw0Kj7A/XSRMZmVFF9wrCDHzyYEbKG57ED
	 ADH0g5L1Ro22n2JWfCQXWu6yDrsKC0iXrUL29y3xLa0tGFehCO0SiIOHjjtGX+Z/SP
	 u/TRpwgoAq+woF6jRZO3MpsJ0Vlntwc7WN2KS/w9lKxDKf7JaPyVecKjjzJ3+lhgtE
	 fSXF95YeyHZcA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Jurgens <danielj@nvidia.com>,
	William Tu <witu@nvidia.com>
Subject: [net-next 08/15] net/mlx5: Use correct vport when restoring GUIDs
Date: Fri,  9 Jun 2023 18:42:47 -0700
Message-Id: <20230610014254.343576-9-saeed@kernel.org>
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

Prior to enabling EC VF functionality the vport number and function ID
were always the same. That's not the case now. Use the correct vport
number to modify the HCA vport context.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index f07d00929162..c2463a1d7035 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -37,7 +37,7 @@
 #include "mlx5_irq.h"
 #include "eswitch.h"
 
-static int sriov_restore_guids(struct mlx5_core_dev *dev, int vf)
+static int sriov_restore_guids(struct mlx5_core_dev *dev, int vf, u16 func_id)
 {
 	struct mlx5_core_sriov *sriov = &dev->priv.sriov;
 	struct mlx5_hca_vport_context *in;
@@ -59,7 +59,7 @@ static int sriov_restore_guids(struct mlx5_core_dev *dev, int vf)
 			!!(in->node_guid) * MLX5_HCA_VPORT_SEL_NODE_GUID |
 			!!(in->policy) * MLX5_HCA_VPORT_SEL_STATE_POLICY;
 
-		err = mlx5_core_modify_hca_vport_context(dev, 1, 1, vf + 1, in);
+		err = mlx5_core_modify_hca_vport_context(dev, 1, 1, func_id, in);
 		if (err)
 			mlx5_core_warn(dev, "modify vport context failed, unable to restore VF %d settings\n", vf);
 
@@ -73,6 +73,7 @@ static int mlx5_device_enable_sriov(struct mlx5_core_dev *dev, int num_vfs)
 {
 	struct mlx5_core_sriov *sriov = &dev->priv.sriov;
 	int err, vf, num_msix_count;
+	int vport_num;
 
 	err = mlx5_eswitch_enable(dev->priv.eswitch, num_vfs);
 	if (err) {
@@ -104,7 +105,10 @@ static int mlx5_device_enable_sriov(struct mlx5_core_dev *dev, int num_vfs)
 
 		sriov->vfs_ctx[vf].enabled = 1;
 		if (MLX5_CAP_GEN(dev, port_type) == MLX5_CAP_PORT_TYPE_IB) {
-			err = sriov_restore_guids(dev, vf);
+			vport_num = mlx5_core_ec_sriov_enabled(dev) ?
+					mlx5_core_ec_vf_vport_base(dev) + vf
+					: vf + 1;
+			err = sriov_restore_guids(dev, vf, vport_num);
 			if (err) {
 				mlx5_core_warn(dev,
 					       "failed to restore VF %d settings, err %d\n",
-- 
2.40.1



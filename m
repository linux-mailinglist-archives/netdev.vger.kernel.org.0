Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A1D42FF7C
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239418AbhJPAl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239343AbhJPAlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D74A61246;
        Sat, 16 Oct 2021 00:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634344748;
        bh=VupHiu4XT+GbRWNF1pdJKjXmKJ7X2nQLfR2ebsLvSbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3gAKoILdPnMxOWBCp1lIRRZedI7X0ukRH+MwvZeLmEMnmGGSqnC/dSc2uCLljCdk
         dycf8Ephcpq3LABLulQVZWztQUTwaZ7MjgHbGfezgXPVupLtzx9eNy+byJvF9tXHxX
         SQElTKVguS7x33V1SDE0rfzvUw8yXHWFdYOqvGllIWtYdEeRhCFdssGADf3WK/GsGl
         9Q32mEBw8puXIeQlM35+dDu2l+PYGZxH3Edm/GKM4nuBuP/qrwBTan4gxxH2acvbO5
         kIJQuhB9EtOaguxKREjrJ9P+YGN0V8rJHZ4rKnuitmkv2Ju6fQw79bTTAQbuZh7oaL
         GdsNWWnUqBSKA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Rongwei Liu <rongweil@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/13] net/mlx5: Check return status first when querying system_image_guid
Date:   Fri, 15 Oct 2021 17:38:59 -0700
Message-Id: <20211016003902.57116-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211016003902.57116-1-saeed@kernel.org>
References: <20211016003902.57116-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rongwei Liu <rongweil@nvidia.com>

When querying system_image_guid from firmware, we should check return
value first. The buffer content is valid only if query succeed.

Signed-off-by: Rongwei Liu <rongweil@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 4c1440a95ad7..8846d30a380a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -421,19 +421,21 @@ int mlx5_query_nic_vport_system_image_guid(struct mlx5_core_dev *mdev,
 {
 	u32 *out;
 	int outlen = MLX5_ST_SZ_BYTES(query_nic_vport_context_out);
+	int err;
 
 	out = kvzalloc(outlen, GFP_KERNEL);
 	if (!out)
 		return -ENOMEM;
 
-	mlx5_query_nic_vport_context(mdev, 0, out);
+	err = mlx5_query_nic_vport_context(mdev, 0, out);
+	if (err)
+		goto out;
 
 	*system_image_guid = MLX5_GET64(query_nic_vport_context_out, out,
 					nic_vport_context.system_image_guid);
-
+out:
 	kvfree(out);
-
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_vport_system_image_guid);
 
@@ -1133,19 +1135,20 @@ EXPORT_SYMBOL_GPL(mlx5_nic_vport_unaffiliate_multiport);
 u64 mlx5_query_nic_system_image_guid(struct mlx5_core_dev *mdev)
 {
 	int port_type_cap = MLX5_CAP_GEN(mdev, port_type);
-	u64 tmp = 0;
+	u64 tmp;
+	int err;
 
 	if (mdev->sys_image_guid)
 		return mdev->sys_image_guid;
 
 	if (port_type_cap == MLX5_CAP_PORT_TYPE_ETH)
-		mlx5_query_nic_vport_system_image_guid(mdev, &tmp);
+		err = mlx5_query_nic_vport_system_image_guid(mdev, &tmp);
 	else
-		mlx5_query_hca_vport_system_image_guid(mdev, &tmp);
+		err = mlx5_query_hca_vport_system_image_guid(mdev, &tmp);
 
-	mdev->sys_image_guid = tmp;
+	mdev->sys_image_guid = err ? 0 : tmp;
 
-	return tmp;
+	return mdev->sys_image_guid;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_system_image_guid);
 
-- 
2.31.1


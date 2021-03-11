Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E231336CED
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhCKHKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232011AbhCKHJn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 02:09:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BB7665033;
        Thu, 11 Mar 2021 07:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615446582;
        bh=4cmQFbIvDo4DA8ca22DVZRhsGZXwrK29WBCv/ckoI7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJ+Esr/qSqG16IAEwreRZY3yVQ9MBAQ2/2/OM4ji3maO2LbleVpQCPmNKTF6bmTB3
         WD9CPUyY1ucVgP3AmBQMv5W2jiYFRrh30kQhvw81noTTSdZs7Re0ifuj1B0mNMMpEO
         /3+ZSkuE0sAm8yhNZRK3Z+25X2ucUbZF/IljrRLBys6dQdCsQQcmaZHzshoimy+ksn
         eCe8uo/RNieYm/I8RNlQPwGV9eWWujZWNgLZiB8f8qFrA8BqXzs9zRb7u/uI8/Tsjk
         YdPowX2pNFm/wGzo67X/qJSwl9lqIc8xGpp7gYKJ4QTFyui5PXZ4s0LyywkGlnSJMI
         juQ/mP8dR5XIQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 6/9] RDMA/mlx5: Use represntor E-Switch when getting netdev and metadata
Date:   Wed, 10 Mar 2021 23:09:12 -0800
Message-Id: <20210311070915.321814-7-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311070915.321814-1-saeed@kernel.org>
References: <20210311070915.321814-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Now that a pointer to the managing E-Switch is stored in the representor
use it.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/fs.c     | 2 +-
 drivers/infiniband/hw/mlx5/ib_rep.c | 2 +-
 drivers/infiniband/hw/mlx5/main.c   | 3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 25da0b05b4e2..01370d9a871a 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -879,7 +879,7 @@ static void mlx5_ib_set_rule_source_port(struct mlx5_ib_dev *dev,
 				    misc_parameters_2);
 
 		MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
-			 mlx5_eswitch_get_vport_metadata_for_match(esw,
+			 mlx5_eswitch_get_vport_metadata_for_match(rep->esw,
 								   rep->vport));
 		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
 				    misc_parameters_2);
diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 9164cc069ad4..4eae7131b0ce 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -20,7 +20,7 @@ mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	rep->rep_data[REP_IB].priv = ibdev;
 	write_lock(&ibdev->port[vport_index].roce.netdev_lock);
 	ibdev->port[vport_index].roce.netdev =
-		mlx5_ib_get_rep_netdev(dev->priv.eswitch, rep->vport);
+		mlx5_ib_get_rep_netdev(rep->esw, rep->vport);
 	write_unlock(&ibdev->port[vport_index].roce.netdev_lock);
 
 	return 0;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0d69a697d75f..7a7f6ccd02a5 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -126,7 +126,6 @@ static struct mlx5_roce *mlx5_get_rep_roce(struct mlx5_ib_dev *dev,
 					   struct net_device *ndev,
 					   u8 *port_num)
 {
-	struct mlx5_eswitch *esw = dev->mdev->priv.eswitch;
 	struct net_device *rep_ndev;
 	struct mlx5_ib_port *port;
 	int i;
@@ -137,7 +136,7 @@ static struct mlx5_roce *mlx5_get_rep_roce(struct mlx5_ib_dev *dev,
 			continue;
 
 		read_lock(&port->roce.netdev_lock);
-		rep_ndev = mlx5_ib_get_rep_netdev(esw,
+		rep_ndev = mlx5_ib_get_rep_netdev(port->rep->esw,
 						  port->rep->vport);
 		if (rep_ndev == ndev) {
 			read_unlock(&port->roce.netdev_lock);
-- 
2.29.2


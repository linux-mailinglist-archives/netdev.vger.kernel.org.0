Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470F12B078F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 15:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgKLO3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 09:29:06 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8075 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgKLO3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 09:29:06 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CX3r03f61zLtvy;
        Thu, 12 Nov 2020 22:28:48 +0800 (CST)
Received: from localhost (10.174.176.180) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 12 Nov 2020
 22:28:54 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <saeedm@nvidia.com>, <leon@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <vuhuong@mellanox.com>, <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net/mlx5: Fix passing zero to 'PTR_ERR'
Date:   Thu, 12 Nov 2020 22:28:45 +0800
Message-ID: <20201112142845.54580-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.176.180]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix smatch warnings:

drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c:105 esw_acl_egress_lgcy_setup() warn: passing zero to 'PTR_ERR'
drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c:177 esw_acl_egress_ofld_setup() warn: passing zero to 'PTR_ERR'
drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c:184 esw_acl_ingress_lgcy_setup() warn: passing zero to 'PTR_ERR'
drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c:262 esw_acl_ingress_ofld_setup() warn: passing zero to 'PTR_ERR'

esw_acl_table_create() never returns NULL, so
NULL test should be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
index d46f8b225ebe..2b85d4777303 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
@@ -101,7 +101,7 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 	vport->egress.acl = esw_acl_table_create(esw, vport->vport,
 						 MLX5_FLOW_NAMESPACE_ESW_EGRESS,
 						 table_size);
-	if (IS_ERR_OR_NULL(vport->egress.acl)) {
+	if (IS_ERR(vport->egress.acl)) {
 		err = PTR_ERR(vport->egress.acl);
 		vport->egress.acl = NULL;
 		goto out;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
index c3faae67e4d6..4c74e2690d57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
@@ -173,7 +173,7 @@ int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 		table_size++;
 	vport->egress.acl = esw_acl_table_create(esw, vport->vport,
 						 MLX5_FLOW_NAMESPACE_ESW_EGRESS, table_size);
-	if (IS_ERR_OR_NULL(vport->egress.acl)) {
+	if (IS_ERR(vport->egress.acl)) {
 		err = PTR_ERR(vport->egress.acl);
 		vport->egress.acl = NULL;
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index b68976b378b8..d64fad2823e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -180,7 +180,7 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 		vport->ingress.acl = esw_acl_table_create(esw, vport->vport,
 							  MLX5_FLOW_NAMESPACE_ESW_INGRESS,
 							  table_size);
-		if (IS_ERR_OR_NULL(vport->ingress.acl)) {
+		if (IS_ERR(vport->ingress.acl)) {
 			err = PTR_ERR(vport->ingress.acl);
 			vport->ingress.acl = NULL;
 			return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
index 4e55d7225a26..548c005ea633 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
@@ -258,7 +258,7 @@ int esw_acl_ingress_ofld_setup(struct mlx5_eswitch *esw,
 	vport->ingress.acl = esw_acl_table_create(esw, vport->vport,
 						  MLX5_FLOW_NAMESPACE_ESW_INGRESS,
 						  num_ftes);
-	if (IS_ERR_OR_NULL(vport->ingress.acl)) {
+	if (IS_ERR(vport->ingress.acl)) {
 		err = PTR_ERR(vport->ingress.acl);
 		vport->ingress.acl = NULL;
 		return err;
-- 
2.17.1


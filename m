Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3822D335E
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731407AbgLHUQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731151AbgLHUPI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:15:08 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        YueHaibing <yuehaibing@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 13/15] net/mlx5: Fix passing zero to 'PTR_ERR'
Date:   Tue,  8 Dec 2020 11:35:53 -0800
Message-Id: <20201208193555.674504-14-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208193555.674504-1-saeed@kernel.org>
References: <20201208193555.674504-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fix smatch warnings:

drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c:105 esw_acl_egress_lgcy_setup() warn: passing zero to 'PTR_ERR'
drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c:177 esw_acl_egress_ofld_setup() warn: passing zero to 'PTR_ERR'
drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c:184 esw_acl_ingress_lgcy_setup() warn: passing zero to 'PTR_ERR'
drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c:262 esw_acl_ingress_ofld_setup() warn: passing zero to 'PTR_ERR'

esw_acl_table_create() never returns NULL, so
NULL test should be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
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
2.26.2


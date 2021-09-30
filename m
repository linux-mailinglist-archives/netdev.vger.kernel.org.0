Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5D541E4A2
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350219AbhI3XQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346146AbhI3XQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:16:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48DF861A7F;
        Thu, 30 Sep 2021 23:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633043705;
        bh=In24AEgCVGvKAdv8L2bW96QtQXb3PIaN+oO0piXgDAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGfDZobP6t+6M5tl+bkgVeS4OZAA+eo2BaxMB0zJS2YpYItxryAOufortcJwr92zG
         5XUt1WIHT2Px7R6wnUfwVukbUJHiJSkNb91jsXxzn1NZkv0GtnZdfSUst8sUdMn3Xv
         j+zx/CcG0wDy6bINN89zRjA6/ppTO8sqk/bO/wqOllkstApc+04+UmwEAUHYF57Ry0
         AR0FjXYh7/lklpnRBqga5hWSU4+3njihTjOr4tjgUSG5PRxNfGk94VCkWQusmLnpPb
         5oKR5dyEFsPTfATVL+zSxsQvJ59+7Tr6NDnUDEECUViXQeZhAk1Vz4qiZW1DVnPJOr
         Cnko/57MURgxQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/10] net/mlx5: E-Switch, Fix double allocation of acl flow counter
Date:   Thu, 30 Sep 2021 16:14:55 -0700
Message-Id: <20210930231501.39062-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930231501.39062-1-saeed@kernel.org>
References: <20210930231501.39062-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

Flow counter is allocated in eswitch legacy acl setting functions
without checking if already allocated by previous setting. Add a check
to avoid such double allocation.

Fixes: 07bab9502641 ("net/mlx5: E-Switch, Refactor eswitch ingress acl codes")
Fixes: ea651a86d468 ("net/mlx5: E-Switch, Refactor eswitch egress acl codes")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c         | 12 ++++++++----
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c        |  4 +++-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
index 0399a396d166..60a73990017c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
@@ -79,12 +79,16 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 	int dest_num = 0;
 	int err = 0;
 
-	if (MLX5_CAP_ESW_EGRESS_ACL(esw->dev, flow_counter)) {
+	if (vport->egress.legacy.drop_counter) {
+		drop_counter = vport->egress.legacy.drop_counter;
+	} else if (MLX5_CAP_ESW_EGRESS_ACL(esw->dev, flow_counter)) {
 		drop_counter = mlx5_fc_create(esw->dev, false);
-		if (IS_ERR(drop_counter))
+		if (IS_ERR(drop_counter)) {
 			esw_warn(esw->dev,
 				 "vport[%d] configure egress drop rule counter err(%ld)\n",
 				 vport->vport, PTR_ERR(drop_counter));
+			drop_counter = NULL;
+		}
 		vport->egress.legacy.drop_counter = drop_counter;
 	}
 
@@ -123,7 +127,7 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
 
 	/* Attach egress drop flow counter */
-	if (!IS_ERR_OR_NULL(drop_counter)) {
+	if (drop_counter) {
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
 		drop_ctr_dst.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
 		drop_ctr_dst.counter_id = mlx5_fc_id(drop_counter);
@@ -162,7 +166,7 @@ void esw_acl_egress_lgcy_cleanup(struct mlx5_eswitch *esw,
 	esw_acl_egress_table_destroy(vport);
 
 clean_drop_counter:
-	if (!IS_ERR_OR_NULL(vport->egress.legacy.drop_counter)) {
+	if (vport->egress.legacy.drop_counter) {
 		mlx5_fc_destroy(esw->dev, vport->egress.legacy.drop_counter);
 		vport->egress.legacy.drop_counter = NULL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index f75b86abaf1c..b1a5199260f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -160,7 +160,9 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 
 	esw_acl_ingress_lgcy_rules_destroy(vport);
 
-	if (MLX5_CAP_ESW_INGRESS_ACL(esw->dev, flow_counter)) {
+	if (vport->ingress.legacy.drop_counter) {
+		counter = vport->ingress.legacy.drop_counter;
+	} else if (MLX5_CAP_ESW_INGRESS_ACL(esw->dev, flow_counter)) {
 		counter = mlx5_fc_create(esw->dev, false);
 		if (IS_ERR(counter)) {
 			esw_warn(esw->dev,
-- 
2.31.1


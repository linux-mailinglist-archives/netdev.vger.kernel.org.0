Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914AC64196C
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiLCWOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiLCWOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:14:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD491E3F3
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:13:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 160D060B9B
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3E6C433D7;
        Sat,  3 Dec 2022 22:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105637;
        bh=yz+N4SgMBpDZouOzYTPMlEDsqxQKQIRnJp+ejnXEloo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIF+R9FElfhurTxJre5VoP0D38Q9k1k84KrkvOrT/b/IVfiofbYLWatt9n7qySeSP
         ZlKCxpaFpmz9r3MCGCPcQXAMWFB5pe29ew5jpBHReGFEUEalE+73FynzFb0ple4b8r
         aDUA1oU6pznjqpdmUY2hui2ODv+4Tk8XVkGW/47nYegVFTL+FeHrwtst6nSJ7et867
         KfO+LrQrNYI4kiYMdsKqDGqNaaVJMnx3RHrv/ZUHJ0LS5PI3yN4GPPU2j0TnChS1qg
         VIPM+NxqWvGCJ3AHc+iUhRl74De0PLGgDuKRUjWZEDjvj8CNVaofiiBQvOM2BTeWrp
         szUbcyceVmNlw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 13/15] net/mlx5: SRIOV, Recreate egress ACL table on config change
Date:   Sat,  3 Dec 2022 14:13:35 -0800
Message-Id: <20221203221337.29267-14-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221203221337.29267-1-saeed@kernel.org>
References: <20221203221337.29267-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

The egress ACL table has flow group for cvlan and flow group for drop.
A downstream patch will add also svlan flow steering rule and so will
need a flow group for svlan. Recreating the egress ACL table enables us
to keep one group for allowed traffic, either cvlan or svlan and one
group for drop traffic, similar to the ingress ACL table.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c  | 82 ++++++++++---------
 .../mellanox/mlx5/core/esw/acl/lgcy.h         |  4 +
 .../ethernet/mellanox/mlx5/core/esw/legacy.c  |  3 +
 3 files changed, 52 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
index 60a73990017c..83ecad5ea80b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
@@ -69,8 +69,8 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 {
 	struct mlx5_flow_destination drop_ctr_dst = {};
 	struct mlx5_flow_destination *dst = NULL;
-	struct mlx5_fc *drop_counter = NULL;
 	struct mlx5_flow_act flow_act = {};
+	struct mlx5_fc *drop_counter;
 	/* The egress acl table contains 2 rules:
 	 * 1)Allow traffic with vlan_tag=vst_vlan_id
 	 * 2)Drop all other traffic.
@@ -79,41 +79,23 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 	int dest_num = 0;
 	int err = 0;
 
-	if (vport->egress.legacy.drop_counter) {
-		drop_counter = vport->egress.legacy.drop_counter;
-	} else if (MLX5_CAP_ESW_EGRESS_ACL(esw->dev, flow_counter)) {
-		drop_counter = mlx5_fc_create(esw->dev, false);
-		if (IS_ERR(drop_counter)) {
-			esw_warn(esw->dev,
-				 "vport[%d] configure egress drop rule counter err(%ld)\n",
-				 vport->vport, PTR_ERR(drop_counter));
-			drop_counter = NULL;
-		}
-		vport->egress.legacy.drop_counter = drop_counter;
-	}
-
-	esw_acl_egress_lgcy_rules_destroy(vport);
-
-	if (!vport->info.vlan && !vport->info.qos) {
-		esw_acl_egress_lgcy_cleanup(esw, vport);
+	esw_acl_egress_lgcy_cleanup(esw, vport);
+	if (!vport->info.vlan && !vport->info.qos)
 		return 0;
-	}
 
-	if (!vport->egress.acl) {
-		vport->egress.acl = esw_acl_table_create(esw, vport,
-							 MLX5_FLOW_NAMESPACE_ESW_EGRESS,
-							 table_size);
-		if (IS_ERR(vport->egress.acl)) {
-			err = PTR_ERR(vport->egress.acl);
-			vport->egress.acl = NULL;
-			goto out;
-		}
-
-		err = esw_acl_egress_lgcy_groups_create(esw, vport);
-		if (err)
-			goto out;
+	vport->egress.acl = esw_acl_table_create(esw, vport,
+						 MLX5_FLOW_NAMESPACE_ESW_EGRESS,
+						 table_size);
+	if (IS_ERR(vport->egress.acl)) {
+		err = PTR_ERR(vport->egress.acl);
+		vport->egress.acl = NULL;
+		goto out;
 	}
 
+	err = esw_acl_egress_lgcy_groups_create(esw, vport);
+	if (err)
+		goto out;
+
 	esw_debug(esw->dev,
 		  "vport[%d] configure egress rules, vlan(%d) qos(%d)\n",
 		  vport->vport, vport->info.vlan, vport->info.qos);
@@ -127,6 +109,7 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
 
 	/* Attach egress drop flow counter */
+	drop_counter = vport->egress.legacy.drop_counter;
 	if (drop_counter) {
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
 		drop_ctr_dst.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
@@ -157,17 +140,42 @@ void esw_acl_egress_lgcy_cleanup(struct mlx5_eswitch *esw,
 				 struct mlx5_vport *vport)
 {
 	if (IS_ERR_OR_NULL(vport->egress.acl))
-		goto clean_drop_counter;
+		return;
 
 	esw_debug(esw->dev, "Destroy vport[%d] E-Switch egress ACL\n", vport->vport);
 
 	esw_acl_egress_lgcy_rules_destroy(vport);
 	esw_acl_egress_lgcy_groups_destroy(vport);
 	esw_acl_egress_table_destroy(vport);
+}
 
-clean_drop_counter:
-	if (vport->egress.legacy.drop_counter) {
-		mlx5_fc_destroy(esw->dev, vport->egress.legacy.drop_counter);
-		vport->egress.legacy.drop_counter = NULL;
+void esw_acl_egress_lgcy_create_counter(struct mlx5_eswitch *esw,
+					struct mlx5_vport *vport)
+{
+	struct mlx5_fc *counter;
+
+	vport->egress.legacy.drop_counter = NULL;
+
+	if (!MLX5_CAP_ESW_EGRESS_ACL(esw->dev, flow_counter))
+		return;
+
+	counter = mlx5_fc_create(esw->dev, false);
+	if (IS_ERR(counter)) {
+		esw_warn(esw->dev,
+			 "vport[%d] configure egress drop rule counter failed\n",
+			 vport->vport);
+		return;
 	}
+
+	vport->egress.legacy.drop_counter = counter;
+}
+
+void esw_acl_egress_lgcy_destroy_counter(struct mlx5_eswitch *esw,
+					 struct mlx5_vport *vport)
+{
+	if (!vport->egress.legacy.drop_counter)
+		return;
+
+	mlx5_fc_destroy(esw->dev, vport->egress.legacy.drop_counter);
+	vport->egress.legacy.drop_counter = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h
index c4a624ffca43..aa5523eb0abd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h
@@ -9,6 +9,10 @@
 /* Eswitch acl egress external APIs */
 int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 void esw_acl_egress_lgcy_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
+void esw_acl_egress_lgcy_create_counter(struct mlx5_eswitch *esw,
+					struct mlx5_vport *vport);
+void esw_acl_egress_lgcy_destroy_counter(struct mlx5_eswitch *esw,
+					 struct mlx5_vport *vport);
 
 /* Eswitch acl ingress external APIs */
 int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index 97a104668723..bddf1086d771 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -361,6 +361,7 @@ int esw_legacy_vport_acl_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vpor
 	if (ret)
 		goto ingress_err;
 
+	esw_acl_egress_lgcy_create_counter(esw, vport);
 	ret = esw_acl_egress_lgcy_setup(esw, vport);
 	if (ret)
 		goto egress_err;
@@ -368,6 +369,7 @@ int esw_legacy_vport_acl_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vpor
 	return 0;
 
 egress_err:
+	esw_acl_egress_lgcy_destroy_counter(esw, vport);
 	esw_acl_ingress_lgcy_cleanup(esw, vport);
 ingress_err:
 	esw_acl_ingress_lgcy_destroy_counter(esw, vport);
@@ -380,6 +382,7 @@ void esw_legacy_vport_acl_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *v
 		return;
 
 	esw_acl_egress_lgcy_cleanup(esw, vport);
+	esw_acl_egress_lgcy_destroy_counter(esw, vport);
 	esw_acl_ingress_lgcy_cleanup(esw, vport);
 	esw_acl_ingress_lgcy_destroy_counter(esw, vport);
 }
-- 
2.38.1


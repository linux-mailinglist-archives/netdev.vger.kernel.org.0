Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4DF4C201E
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245015AbiBWXkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244978AbiBWXkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:40:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491825A5A0;
        Wed, 23 Feb 2022 15:39:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BD43B81EDD;
        Wed, 23 Feb 2022 23:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BF4C340F1;
        Wed, 23 Feb 2022 23:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645659579;
        bh=mDj7RLvsugBTLQ9B4NA3BujPDwBOvnvOB7n0kzKZG00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GByrVs/1cUtbIsxJ7/+UrEtxc69E6XsEGnCQOAhzCDNvfLHdDNi0m7OE0pHwCzfDA
         pV7b1+bxW7SY37i7fKKFMaw+YhrkVa8jiQ91JcvGq9bdHOZiqPSPIVzPacirFNbXIr
         aX6SbmKzCZzLpGQw7kyIeBnGJ9/yenNs2NxuCi133nvWb0xJgQm7SGFWnAU0YfLcDW
         L9v4RB45XsatXNnSPP1HID7NWhJOUUoYuktDYC+RQypKOW4RMMLo3zfbkXgrmkV369
         fGMAX8cYZmXglGjqWXgSb7MGPNuxZlvlbUUU6iS2UxK4fLJSqOGEUtcnnFRECetLqE
         g6VnjVflzizkQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [for-next v2 04/17] net/mlx5: E-switch, remove special uplink ingress ACL handling
Date:   Wed, 23 Feb 2022 15:39:17 -0800
Message-Id: <20220223233930.319301-5-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223233930.319301-1-saeed@kernel.org>
References: <20220223233930.319301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

As both uplinks set the same metadata there is no need to merge
the ACL handling of both into a single one.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 65 +------------------
 1 file changed, 1 insertion(+), 64 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index efaf3be73a7b..f65231e579bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2378,60 +2378,6 @@ void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num)
 		mlx5_esw_offloads_devlink_port_unregister(esw, vport_num);
 }
 
-static int esw_set_uplink_slave_ingress_root(struct mlx5_core_dev *master,
-					     struct mlx5_core_dev *slave)
-{
-	u32 in[MLX5_ST_SZ_DW(set_flow_table_root_in)]   = {};
-	u32 out[MLX5_ST_SZ_DW(set_flow_table_root_out)] = {};
-	struct mlx5_eswitch *esw;
-	struct mlx5_flow_root_namespace *root;
-	struct mlx5_flow_namespace *ns;
-	struct mlx5_vport *vport;
-	int err;
-
-	MLX5_SET(set_flow_table_root_in, in, opcode,
-		 MLX5_CMD_OP_SET_FLOW_TABLE_ROOT);
-	MLX5_SET(set_flow_table_root_in, in, table_type, FS_FT_ESW_INGRESS_ACL);
-	MLX5_SET(set_flow_table_root_in, in, other_vport, 1);
-	MLX5_SET(set_flow_table_root_in, in, vport_number, MLX5_VPORT_UPLINK);
-
-	if (master) {
-		esw = master->priv.eswitch;
-		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_UPLINK);
-		MLX5_SET(set_flow_table_root_in, in, table_of_other_vport, 1);
-		MLX5_SET(set_flow_table_root_in, in, table_vport_number,
-			 MLX5_VPORT_UPLINK);
-
-		ns = mlx5_get_flow_vport_acl_namespace(master,
-						       MLX5_FLOW_NAMESPACE_ESW_INGRESS,
-						       vport->index);
-		root = find_root(&ns->node);
-		mutex_lock(&root->chain_lock);
-
-		MLX5_SET(set_flow_table_root_in, in,
-			 table_eswitch_owner_vhca_id_valid, 1);
-		MLX5_SET(set_flow_table_root_in, in,
-			 table_eswitch_owner_vhca_id,
-			 MLX5_CAP_GEN(master, vhca_id));
-		MLX5_SET(set_flow_table_root_in, in, table_id,
-			 root->root_ft->id);
-	} else {
-		esw = slave->priv.eswitch;
-		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_UPLINK);
-		ns = mlx5_get_flow_vport_acl_namespace(slave,
-						       MLX5_FLOW_NAMESPACE_ESW_INGRESS,
-						       vport->index);
-		root = find_root(&ns->node);
-		mutex_lock(&root->chain_lock);
-		MLX5_SET(set_flow_table_root_in, in, table_id, root->root_ft->id);
-	}
-
-	err = mlx5_cmd_exec(slave, in, sizeof(in), out, sizeof(out));
-	mutex_unlock(&root->chain_lock);
-
-	return err;
-}
-
 static int esw_set_slave_root_fdb(struct mlx5_core_dev *master,
 				  struct mlx5_core_dev *slave)
 {
@@ -2613,15 +2559,10 @@ int mlx5_eswitch_offloads_config_single_fdb(struct mlx5_eswitch *master_esw,
 {
 	int err;
 
-	err = esw_set_uplink_slave_ingress_root(master_esw->dev,
-						slave_esw->dev);
-	if (err)
-		return -EINVAL;
-
 	err = esw_set_slave_root_fdb(master_esw->dev,
 				     slave_esw->dev);
 	if (err)
-		goto err_fdb;
+		return err;
 
 	err = esw_set_master_egress_rule(master_esw->dev,
 					 slave_esw->dev);
@@ -2633,9 +2574,6 @@ int mlx5_eswitch_offloads_config_single_fdb(struct mlx5_eswitch *master_esw,
 err_acl:
 	esw_set_slave_root_fdb(NULL, slave_esw->dev);
 
-err_fdb:
-	esw_set_uplink_slave_ingress_root(NULL, slave_esw->dev);
-
 	return err;
 }
 
@@ -2644,7 +2582,6 @@ void mlx5_eswitch_offloads_destroy_single_fdb(struct mlx5_eswitch *master_esw,
 {
 	esw_unset_master_egress_rule(master_esw->dev);
 	esw_set_slave_root_fdb(NULL, slave_esw->dev);
-	esw_set_uplink_slave_ingress_root(NULL, slave_esw->dev);
 }
 
 #define ESW_OFFLOADS_DEVCOM_PAIR	(0)
-- 
2.35.1


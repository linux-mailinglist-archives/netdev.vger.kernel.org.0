Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0D552B2AF
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiERGt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbiERGtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:49:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E83322294
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93C7460BD3
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08F8C385A5;
        Wed, 18 May 2022 06:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856587;
        bh=WSosdGPYXW/y8RsIU8165ym1uqBgcUy4fJQL+Sc7/X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQIh7GKGw4j2T6XlgUnimoL4n9l96YdboWf22MGNe+JHpDQteBmAbF5xoqvcfDsFz
         aIrmWF9QAHixJGCEn+cXkTWAA+guZX0/0Ga0WL7kChhusIRZhRX1QibHMNy0P8V3mD
         AYeoop5QbsL38dIpaAvc0UVa2daYpvapPuD46X4l5Z0Am5/5x8dqbX2ZbpYvAoT6Al
         yGYKk9eFq/92bIwDE8QIZH9g09No/A/tjleoYRSeKfLCfbneiFAyRqAUrhZqS/GYOu
         TCpX7ZGsmHcvyZHWunXjq7P5TXF5REgT1vfjAhZlSW2J3Eu4XR0cPsbPsEj6Ttau+o
         gFOrEp6V7heTQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/16] net/mlx5: Allocate virtually contiguous memory in vport.c
Date:   Tue, 17 May 2022 23:49:26 -0700
Message-Id: <20220518064938.128220-5-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518064938.128220-1-saeed@kernel.org>
References: <20220518064938.128220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Physical continuity is not necessary, and requested allocation size might
be larger than PAGE_SIZE.
Hence, use v-alloc/free API.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 52 +++++++++----------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 8846d30a380a..ac020cb78072 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -280,7 +280,7 @@ int mlx5_query_nic_vport_mac_list(struct mlx5_core_dev *dev,
 	out_sz = MLX5_ST_SZ_BYTES(query_nic_vport_context_in) +
 			req_list_size * MLX5_ST_SZ_BYTES(mac_address_layout);
 
-	out = kzalloc(out_sz, GFP_KERNEL);
+	out = kvzalloc(out_sz, GFP_KERNEL);
 	if (!out)
 		return -ENOMEM;
 
@@ -307,7 +307,7 @@ int mlx5_query_nic_vport_mac_list(struct mlx5_core_dev *dev,
 		ether_addr_copy(addr_list[i], mac_addr);
 	}
 out:
-	kfree(out);
+	kvfree(out);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_vport_mac_list);
@@ -335,7 +335,7 @@ int mlx5_modify_nic_vport_mac_list(struct mlx5_core_dev *dev,
 	in_sz = MLX5_ST_SZ_BYTES(modify_nic_vport_context_in) +
 		list_size * MLX5_ST_SZ_BYTES(mac_address_layout);
 
-	in = kzalloc(in_sz, GFP_KERNEL);
+	in = kvzalloc(in_sz, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
 
@@ -360,7 +360,7 @@ int mlx5_modify_nic_vport_mac_list(struct mlx5_core_dev *dev,
 	}
 
 	err = mlx5_cmd_exec(dev, in, in_sz, out, sizeof(out));
-	kfree(in);
+	kvfree(in);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_modify_nic_vport_mac_list);
@@ -386,7 +386,7 @@ int mlx5_modify_nic_vport_vlans(struct mlx5_core_dev *dev,
 		list_size * MLX5_ST_SZ_BYTES(vlan_layout);
 
 	memset(out, 0, sizeof(out));
-	in = kzalloc(in_sz, GFP_KERNEL);
+	in = kvzalloc(in_sz, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
 
@@ -411,7 +411,7 @@ int mlx5_modify_nic_vport_vlans(struct mlx5_core_dev *dev,
 	}
 
 	err = mlx5_cmd_exec(dev, in, in_sz, out, sizeof(out));
-	kfree(in);
+	kvfree(in);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_modify_nic_vport_vlans);
@@ -542,8 +542,8 @@ int mlx5_query_hca_vport_gid(struct mlx5_core_dev *dev, u8 other_vport,
 
 	out_sz += nout * sizeof(*gid);
 
-	in = kzalloc(in_sz, GFP_KERNEL);
-	out = kzalloc(out_sz, GFP_KERNEL);
+	in = kvzalloc(in_sz, GFP_KERNEL);
+	out = kvzalloc(out_sz, GFP_KERNEL);
 	if (!in || !out) {
 		err = -ENOMEM;
 		goto out;
@@ -573,8 +573,8 @@ int mlx5_query_hca_vport_gid(struct mlx5_core_dev *dev, u8 other_vport,
 	gid->global.interface_id = tmp->global.interface_id;
 
 out:
-	kfree(in);
-	kfree(out);
+	kvfree(in);
+	kvfree(out);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_hca_vport_gid);
@@ -607,8 +607,8 @@ int mlx5_query_hca_vport_pkey(struct mlx5_core_dev *dev, u8 other_vport,
 
 	out_sz += nout * MLX5_ST_SZ_BYTES(pkey);
 
-	in = kzalloc(in_sz, GFP_KERNEL);
-	out = kzalloc(out_sz, GFP_KERNEL);
+	in = kvzalloc(in_sz, GFP_KERNEL);
+	out = kvzalloc(out_sz, GFP_KERNEL);
 	if (!in || !out) {
 		err = -ENOMEM;
 		goto out;
@@ -638,8 +638,8 @@ int mlx5_query_hca_vport_pkey(struct mlx5_core_dev *dev, u8 other_vport,
 		*pkey = MLX5_GET_PR(pkey, pkarr, pkey);
 
 out:
-	kfree(in);
-	kfree(out);
+	kvfree(in);
+	kvfree(out);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_hca_vport_pkey);
@@ -658,7 +658,7 @@ int mlx5_query_hca_vport_context(struct mlx5_core_dev *dev,
 
 	is_group_manager = MLX5_CAP_GEN(dev, vport_group_manager);
 
-	out = kzalloc(out_sz, GFP_KERNEL);
+	out = kvzalloc(out_sz, GFP_KERNEL);
 	if (!out)
 		return -ENOMEM;
 
@@ -717,7 +717,7 @@ int mlx5_query_hca_vport_context(struct mlx5_core_dev *dev,
 					    system_image_guid);
 
 ex:
-	kfree(out);
+	kvfree(out);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_hca_vport_context);
@@ -728,7 +728,7 @@ int mlx5_query_hca_vport_system_image_guid(struct mlx5_core_dev *dev,
 	struct mlx5_hca_vport_context *rep;
 	int err;
 
-	rep = kzalloc(sizeof(*rep), GFP_KERNEL);
+	rep = kvzalloc(sizeof(*rep), GFP_KERNEL);
 	if (!rep)
 		return -ENOMEM;
 
@@ -736,7 +736,7 @@ int mlx5_query_hca_vport_system_image_guid(struct mlx5_core_dev *dev,
 	if (!err)
 		*sys_image_guid = rep->sys_image_guid;
 
-	kfree(rep);
+	kvfree(rep);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_hca_vport_system_image_guid);
@@ -747,7 +747,7 @@ int mlx5_query_hca_vport_node_guid(struct mlx5_core_dev *dev,
 	struct mlx5_hca_vport_context *rep;
 	int err;
 
-	rep = kzalloc(sizeof(*rep), GFP_KERNEL);
+	rep = kvzalloc(sizeof(*rep), GFP_KERNEL);
 	if (!rep)
 		return -ENOMEM;
 
@@ -755,7 +755,7 @@ int mlx5_query_hca_vport_node_guid(struct mlx5_core_dev *dev,
 	if (!err)
 		*node_guid = rep->node_guid;
 
-	kfree(rep);
+	kvfree(rep);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_hca_vport_node_guid);
@@ -770,7 +770,7 @@ int mlx5_query_nic_vport_promisc(struct mlx5_core_dev *mdev,
 	int outlen = MLX5_ST_SZ_BYTES(query_nic_vport_context_out);
 	int err;
 
-	out = kzalloc(outlen, GFP_KERNEL);
+	out = kvzalloc(outlen, GFP_KERNEL);
 	if (!out)
 		return -ENOMEM;
 
@@ -786,7 +786,7 @@ int mlx5_query_nic_vport_promisc(struct mlx5_core_dev *mdev,
 				nic_vport_context.promisc_all);
 
 out:
-	kfree(out);
+	kvfree(out);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_vport_promisc);
@@ -874,7 +874,7 @@ int mlx5_nic_vport_query_local_lb(struct mlx5_core_dev *mdev, bool *status)
 	int value;
 	int err;
 
-	out = kzalloc(outlen, GFP_KERNEL);
+	out = kvzalloc(outlen, GFP_KERNEL);
 	if (!out)
 		return -ENOMEM;
 
@@ -891,7 +891,7 @@ int mlx5_nic_vport_query_local_lb(struct mlx5_core_dev *mdev, bool *status)
 	*status = !value;
 
 out:
-	kfree(out);
+	kvfree(out);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_nic_vport_query_local_lb);
@@ -1033,7 +1033,7 @@ int mlx5_core_modify_hca_vport_context(struct mlx5_core_dev *dev,
 
 	mlx5_core_dbg(dev, "vf %d\n", vf);
 	is_group_manager = MLX5_CAP_GEN(dev, vport_group_manager);
-	in = kzalloc(in_sz, GFP_KERNEL);
+	in = kvzalloc(in_sz, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
 
@@ -1065,7 +1065,7 @@ int mlx5_core_modify_hca_vport_context(struct mlx5_core_dev *dev,
 		 req->cap_mask1_perm);
 	err = mlx5_cmd_exec_in(dev, modify_hca_vport_context, in);
 ex:
-	kfree(in);
+	kvfree(in);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_core_modify_hca_vport_context);
-- 
2.36.1


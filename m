Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75679573FD4
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiGMW72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiGMW7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:59:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82112A42D
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:59:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28EBD618B0
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D48FC3411E;
        Wed, 13 Jul 2022 22:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657753154;
        bh=27IGSCFJ6LHAVLvwMn0wzzHk36RSDscTpcvklwdL4Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNhHU06CFXbFdmP1qOwePof6SU3VaXSGRw5MX4kLaf+9Aiub881nNPd5kUyDFcUfI
         FYUFMHp4Yn4omqGe+q1P3nuwElPOwEdDXRWyPhHy1Tz6+tf2UvLuQSKxwWpL842cXL
         c5ibsAvGjUKdzwQvkU/3IvcSUp/PEpIdJAJy39K/FvUiIa6od4urwoKRRHdOFT1XcL
         ACICfAIN4ZrtW+u2lUQM9vaAR/p/9Q6qfNXFZuZAGCpVxn7THTSe6eKlDh4lVYE8tr
         47nww6m2Ym+x1dTLPOj7ykK96L9T/gONeGDQHD7OugtlHiGmTQmYwRKJjGB41Hx0NS
         MhQtJ2q5+4AUA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Yishai Hadas <yishaih@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 03/15] net/mlx5: Use software VHCA id when it's supported
Date:   Wed, 13 Jul 2022 15:58:47 -0700
Message-Id: <20220713225859.401241-4-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713225859.401241-1-saeed@kernel.org>
References: <20220713225859.401241-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

Use software VHCA id when it's supported by the firmware.

A unique id is allocated upon mlx5_mdev_init() and freed upon
mlx5_mdev_uninit(), as such it stays the same during the full life cycle
of the device including upon health recovery if occurred.

The conjunction of sw_vhca_id with sw_owner_id will be a global unique
id per function which uses mlx5_core.

The sw_vhca_id is set upon init_hca command and is used to specify the
VHCA that the NIC vport is affiliated with.

This functionality is needed upon migration of VM which is MPV based.
(i.e. multi port device).

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |  4 ++
 .../net/ethernet/mellanox/mlx5/core/main.c    | 49 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 14 ++++--
 include/linux/mlx5/driver.h                   |  1 +
 4 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index cfb8bedba512..079fa44ada71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -289,6 +289,10 @@ int mlx5_cmd_init_hca(struct mlx5_core_dev *dev, uint32_t *sw_owner_id)
 				       sw_owner_id[i]);
 	}
 
+	if (MLX5_CAP_GEN_2_MAX(dev, sw_vhca_id_valid) &&
+	    dev->priv.sw_vhca_id > 0)
+		MLX5_SET(init_hca_in, in, sw_vhca_id, dev->priv.sw_vhca_id);
+
 	return mlx5_cmd_exec_in(dev, init_hca, in);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index a9e51c1b7738..8b621c1ddd14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -90,6 +90,8 @@ module_param_named(prof_sel, prof_sel, uint, 0444);
 MODULE_PARM_DESC(prof_sel, "profile selector. Valid range 0 - 2");
 
 static u32 sw_owner_id[4];
+#define MAX_SW_VHCA_ID (BIT(__mlx5_bit_sz(cmd_hca_cap_2, sw_vhca_id)) - 1)
+static DEFINE_IDA(sw_vhca_ida);
 
 enum {
 	MLX5_ATOMIC_REQ_MODE_BE = 0x0,
@@ -492,6 +494,31 @@ static int max_uc_list_get_devlink_param(struct mlx5_core_dev *dev)
 	return err;
 }
 
+static int handle_hca_cap_2(struct mlx5_core_dev *dev, void *set_ctx)
+{
+	void *set_hca_cap;
+	int err;
+
+	if (!MLX5_CAP_GEN_MAX(dev, hca_cap_2))
+		return 0;
+
+	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL_2);
+	if (err)
+		return err;
+
+	if (!MLX5_CAP_GEN_2_MAX(dev, sw_vhca_id_valid) ||
+	    !(dev->priv.sw_vhca_id > 0))
+		return 0;
+
+	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx,
+				   capability);
+	memcpy(set_hca_cap, dev->caps.hca[MLX5_CAP_GENERAL_2]->cur,
+	       MLX5_ST_SZ_BYTES(cmd_hca_cap_2));
+	MLX5_SET(cmd_hca_cap_2, set_hca_cap, sw_vhca_id_valid, 1);
+
+	return set_caps(dev, set_ctx, MLX5_CAP_GENERAL_2);
+}
+
 static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	struct mlx5_profile *prof = &dev->profile;
@@ -662,6 +689,13 @@ static int set_hca_cap(struct mlx5_core_dev *dev)
 		goto out;
 	}
 
+	memset(set_ctx, 0, set_sz);
+	err = handle_hca_cap_2(dev, set_ctx);
+	if (err) {
+		mlx5_core_err(dev, "handle_hca_cap_2 failed\n");
+		goto out;
+	}
+
 out:
 	kfree(set_ctx);
 	return err;
@@ -1506,6 +1540,18 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	if (err)
 		goto err_hca_caps;
 
+	/* The conjunction of sw_vhca_id with sw_owner_id will be a global
+	 * unique id per function which uses mlx5_core.
+	 * Those values are supplied to FW as part of the init HCA command to
+	 * be used by both driver and FW when it's applicable.
+	 */
+	dev->priv.sw_vhca_id = ida_alloc_range(&sw_vhca_ida, 1,
+					       MAX_SW_VHCA_ID,
+					       GFP_KERNEL);
+	if (dev->priv.sw_vhca_id < 0)
+		mlx5_core_err(dev, "failed to allocate sw_vhca_id, err=%d\n",
+			      dev->priv.sw_vhca_id);
+
 	return 0;
 
 err_hca_caps:
@@ -1530,6 +1576,9 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
 
+	if (priv->sw_vhca_id > 0)
+		ida_free(&sw_vhca_ida, dev->priv.sw_vhca_id);
+
 	mlx5_hca_caps_free(dev);
 	mlx5_adev_cleanup(dev);
 	mlx5_pagealloc_cleanup(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index ac020cb78072..d5c317325030 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1086,9 +1086,17 @@ int mlx5_nic_vport_affiliate_multiport(struct mlx5_core_dev *master_mdev,
 		goto free;
 
 	MLX5_SET(modify_nic_vport_context_in, in, field_select.affiliation, 1);
-	MLX5_SET(modify_nic_vport_context_in, in,
-		 nic_vport_context.affiliated_vhca_id,
-		 MLX5_CAP_GEN(master_mdev, vhca_id));
+	if (MLX5_CAP_GEN_2(master_mdev, sw_vhca_id_valid)) {
+		MLX5_SET(modify_nic_vport_context_in, in,
+			 nic_vport_context.vhca_id_type, VHCA_ID_TYPE_SW);
+		MLX5_SET(modify_nic_vport_context_in, in,
+			 nic_vport_context.affiliated_vhca_id,
+			 MLX5_CAP_GEN_2(master_mdev, sw_vhca_id));
+	} else {
+		MLX5_SET(modify_nic_vport_context_in, in,
+			 nic_vport_context.affiliated_vhca_id,
+			 MLX5_CAP_GEN(master_mdev, vhca_id));
+	}
 	MLX5_SET(modify_nic_vport_context_in, in,
 		 nic_vport_context.affiliation_criteria,
 		 MLX5_CAP_GEN(port_mdev, affiliate_nic_vport_criteria));
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index bd882884b23c..ecda6e63d5f2 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -610,6 +610,7 @@ struct mlx5_priv {
 	spinlock_t              ctx_lock;
 	struct mlx5_adev       **adev;
 	int			adev_idx;
+	int			sw_vhca_id;
 	struct mlx5_events      *events;
 
 	struct mlx5_flow_steering *steering;
-- 
2.36.1


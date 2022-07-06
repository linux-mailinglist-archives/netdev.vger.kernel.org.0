Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01E15695D3
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbiGFXYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234342AbiGFXYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:24:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148D92BB3C
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:24:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CA1BB81F3C
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A81C3411C;
        Wed,  6 Jul 2022 23:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149870;
        bh=lP6gX8rZgBAOcJhHn5swZ1Lhj3ULGWZDD1wKT2vd80Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwjA+bdS6tRH25XcLFrkP/Yea14qmOZZNxjWl7FTvJL8UoP24Ux1ZitP4npznEkix
         imQRc6i2d9Z1YSmFPqtbViMkLRTYDsue/3gg2Txu4xzclr6wWQuRa2r0B1pbgicxY8
         e9xSj32owcH0mtDJ8Qup8nMm4nceqg6fmBYdSD6hu9VtXcUBXWoyF6cz++jhUsNMa8
         sId3x6S7ul2TwCSSKFQgvAy/N38a3y+aYofTUIlPLBhBIXswy4KVqd4/LmAv1eHRw/
         GCIAb+pRnByJUvUjTRRa1NBn55GUAQjnuJgsKuxMLXZrGrJ+Wv2kDncorzII1uxdGf
         rz10L45JjUujg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 05/15] net/mlx5: Use devl_ API in mlx5_esw_devlink_sf_port_register
Date:   Wed,  6 Jul 2022 16:24:11 -0700
Message-Id: <20220706232421.41269-6-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706232421.41269-1-saeed@kernel.org>
References: <20220706232421.41269-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

The function mlx5_esw_devlink_sf_port_register() calls
devlink_port_register() and devlink_rate_leaf_create(). Use devl_ API to
call devl_port_register() and devl_rate_leaf_create() accordingly and
add devlink instance lock in driver paths to this function.

Similarly, use devl_ API to call devl_port_unregister() and
devl_rate_leaf_destroy() in mlx5_esw_devlink_sf_port_unregister() and
ensure locking devlink instance lock on all the paths to this function
too.

This will be used by the downstream patch to invoke
mlx5_devlink_eswitch_mode_set() with devlink lock held.

Note this patch is taking devlink lock on mlx5_devlink_sf_port_new/del()
which are devlink callbacks for port_new/del(). We will take these locks
off once these callbacks will be locked by devlink too.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/esw/devlink_port.c | 10 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c   |  4 ++++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index a8f7618831f5..9bc7be95db54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -156,11 +156,11 @@ int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_p
 	devlink_port_attrs_pci_sf_set(dl_port, controller, pfnum, sfnum, !!controller);
 	devlink = priv_to_devlink(dev);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, vport_num);
-	err = devlink_port_register(devlink, dl_port, dl_port_index);
+	err = devl_port_register(devlink, dl_port, dl_port_index);
 	if (err)
 		return err;
 
-	err = devlink_rate_leaf_create(dl_port, vport);
+	err = devl_rate_leaf_create(dl_port, vport);
 	if (err)
 		goto rate_err;
 
@@ -168,7 +168,7 @@ int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_p
 	return 0;
 
 rate_err:
-	devlink_port_unregister(dl_port);
+	devl_port_unregister(dl_port);
 	return err;
 }
 
@@ -182,9 +182,9 @@ void mlx5_esw_devlink_sf_port_unregister(struct mlx5_eswitch *esw, u16 vport_num
 
 	if (vport->dl_port->devlink_rate) {
 		mlx5_esw_qos_vport_update_group(esw, vport, NULL, NULL);
-		devlink_rate_leaf_destroy(vport->dl_port);
+		devl_rate_leaf_destroy(vport->dl_port);
 	}
 
-	devlink_port_unregister(vport->dl_port);
+	devl_port_unregister(vport->dl_port);
 	vport->dl_port = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 7d955a4d9f14..2068c22ff367 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -355,7 +355,9 @@ int mlx5_devlink_sf_port_new(struct devlink *devlink,
 				   "Port add is only supported in eswitch switchdev mode or SF ports are disabled.");
 		return -EOPNOTSUPP;
 	}
+	devl_lock(devlink);
 	err = mlx5_sf_add(dev, table, new_attr, extack, new_port_index);
+	devl_unlock(devlink);
 	mlx5_sf_table_put(table);
 	return err;
 }
@@ -400,7 +402,9 @@ int mlx5_devlink_sf_port_del(struct devlink *devlink, unsigned int port_index,
 		goto sf_err;
 	}
 
+	devl_lock(devlink);
 	mlx5_esw_offloads_sf_vport_disable(esw, sf->hw_fn_id);
+	devl_unlock(devlink);
 	mlx5_sf_id_erase(table, sf);
 
 	mutex_lock(&table->sf_state_lock);
-- 
2.36.1


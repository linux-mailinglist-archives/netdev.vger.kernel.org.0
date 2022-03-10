Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A344D3DFB
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238837AbiCJASF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238955AbiCJARs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:17:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16619123428
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:16:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA446B8245A
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 00:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361D8C340F9;
        Thu, 10 Mar 2022 00:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646871406;
        bh=nik0Y1O4AKUydLn7kOqnkj/OPz0Y9n9jcIDNXqlXbTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCfu8Fa9v5wu23a99DCucKZwaRs04nTmSgGEbLCuu23iUFjRU5llTSIeeZfZjcVOF
         ttxRxUQKXrcI3ircs31aIf2bDci1kmYaBBNnXUuBxbn8airHqwtLXjMAcf2TxzaKtv
         s25x+YuTBGq+A+7WzLexe+1S6vE7ZnfVMFrF4fHLs89UJoyJiW7WQW2MmTtdjDtZbu
         5Qe0TuCnNAKFBTw1c/hUYLAkLNw1xglOI+gNMLdy+lALqE8+euM1Re/t1FXzw00/2Y
         QHT0VftDwiCAVFLzUZym6G+R+6Falne1rd96UbAvAwixGGLpUbYtLaXipt3vh/qPfU
         4VgA7mVQBBhJg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com
Cc:     netdev@vger.kernel.org, leonro@nvidia.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFT net-next 4/6] eth: mlxsw: switch to explicit locking for port registration
Date:   Wed,  9 Mar 2022 16:16:30 -0800
Message-Id: <20220310001632.470337-5-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220310001632.470337-1-kuba@kernel.org>
References: <20220310001632.470337-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Explicitly lock the devlink instance and use devl_ API.

This will be used by the subsequent patch to invoke
.port_split / .port_unsplit callbacks with devlink
instance lock held.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c     |  4 ++--
 drivers/net/ethernet/mellanox/mlxsw/minimal.c  |  6 ++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 14 ++++++++++++++
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 0bf1d64644ba..e2a6a759eb6c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2983,7 +2983,7 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u16 local_port,
 	attrs.switch_id.id_len = switch_id_len;
 	mlxsw_core_port->local_port = local_port;
 	devlink_port_attrs_set(devlink_port, &attrs);
-	err = devlink_port_register(devlink, devlink_port, local_port);
+	err = devl_port_register(devlink, devlink_port, local_port);
 	if (err)
 		memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
 	return err;
@@ -2995,7 +2995,7 @@ static void __mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u16 local_port
 					&mlxsw_core->ports[local_port];
 	struct devlink_port *devlink_port = &mlxsw_core_port->devlink_port;
 
-	devlink_port_unregister(devlink_port);
+	devl_port_unregister(devlink_port);
 	memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 060209983438..3bc012dafd08 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -422,6 +422,7 @@ static int mlxsw_m_init(struct mlxsw_core *mlxsw_core,
 			struct netlink_ext_ack *extack)
 {
 	struct mlxsw_m *mlxsw_m = mlxsw_core_driver_priv(mlxsw_core);
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 	int err;
 
 	mlxsw_m->core = mlxsw_core;
@@ -437,7 +438,9 @@ static int mlxsw_m_init(struct mlxsw_core *mlxsw_core,
 		return err;
 	}
 
+	devl_lock(devlink);
 	err = mlxsw_m_ports_create(mlxsw_m);
+	devl_unlock(devlink);
 	if (err) {
 		dev_err(mlxsw_m->bus_info->dev, "Failed to create ports\n");
 		return err;
@@ -449,8 +452,11 @@ static int mlxsw_m_init(struct mlxsw_core *mlxsw_core,
 static void mlxsw_m_fini(struct mlxsw_core *mlxsw_core)
 {
 	struct mlxsw_m *mlxsw_m = mlxsw_core_driver_priv(mlxsw_core);
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 
+	devl_lock(devlink);
 	mlxsw_m_ports_remove(mlxsw_m);
+	devl_unlock(devlink);
 }
 
 static const struct mlxsw_config_profile mlxsw_m_config_profile;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 7b7b17183d10..1e823b669d1c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2025,6 +2025,7 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u16 local_port,
 			       struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 	struct mlxsw_sp_port_mapping port_mapping;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	enum mlxsw_reg_pmtdb_status status;
@@ -2062,6 +2063,7 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u16 local_port,
 
 	port_mapping = mlxsw_sp_port->mapping;
 
+	devl_lock(devlink);
 	for (i = 0; i < count; i++) {
 		u16 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
 
@@ -2075,11 +2077,13 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u16 local_port,
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to create split ports\n");
 		goto err_port_split_create;
 	}
+	devl_unlock(devlink);
 
 	return 0;
 
 err_port_split_create:
 	mlxsw_sp_port_unsplit_create(mlxsw_sp, count, pmtdb_pl);
+	devl_unlock(devlink);
 	return err;
 }
 
@@ -2087,6 +2091,7 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u16 local_port,
 				 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	char pmtdb_pl[MLXSW_REG_PMTDB_LEN];
 	unsigned int count;
@@ -2118,6 +2123,7 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u16 local_port,
 		return err;
 	}
 
+	devl_lock(devlink);
 	for (i = 0; i < count; i++) {
 		u16 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
 
@@ -2126,6 +2132,7 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u16 local_port,
 	}
 
 	mlxsw_sp_port_unsplit_create(mlxsw_sp, count, pmtdb_pl);
+	devl_unlock(devlink);
 
 	return 0;
 }
@@ -2818,6 +2825,7 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 			 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 	int err;
 
 	mlxsw_sp->core = mlxsw_core;
@@ -2978,7 +2986,9 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		goto err_sample_trigger_init;
 	}
 
+	devl_lock(devlink);
 	err = mlxsw_sp_ports_create(mlxsw_sp);
+	devl_unlock(devlink);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to create ports\n");
 		goto err_ports_create;
@@ -3159,8 +3169,12 @@ static int mlxsw_sp4_init(struct mlxsw_core *mlxsw_core,
 static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 
+	devl_lock(devlink);
 	mlxsw_sp_ports_remove(mlxsw_sp);
+	devl_unlock(devlink);
+
 	rhashtable_destroy(&mlxsw_sp->sample_trigger_ht);
 	mlxsw_sp_port_module_info_fini(mlxsw_sp);
 	mlxsw_sp_dpipe_fini(mlxsw_sp);
-- 
2.34.1


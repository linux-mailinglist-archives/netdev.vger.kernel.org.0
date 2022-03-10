Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F224D3DF9
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238953AbiCJARs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238948AbiCJARr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:17:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAD995A1F
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:16:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2351960C5E
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 00:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41D9C340EF;
        Thu, 10 Mar 2022 00:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646871406;
        bh=T3MEs6NDMTrNTBFq6hfHOYwCSGTq+B78km3z1dX2DeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9CGaBZftbHLL7zfhojIm9ATnPlD5xLTtC/ZkKhkhhv21nzyisNBRT0Z/XNX6Rvan
         enFBmkni6K83URQzN6nTcFTJBjzVQQMIJbaqBX+v3/mPvPfI4ppfcPNV4xr1YAAKEs
         IZLwWE7145qoIxuhb2oq9M4UleJ5e8S+CxANk5eo9L9fnIPzKcmSpkpj+47TFykqAG
         rHBYMXgbHkNzyxGfphRYmuw18aDEVpD5qKFO0DIkMeYRdjTLygRrT71llvrb49Bx6Z
         wXHZlv9RqSGhuoFidt6fJJRBRqYUCowLGZr5I9YpjS+niu/VPDBrg/7SyHrlTcsV7n
         b2qvPW6RymUWw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com
Cc:     netdev@vger.kernel.org, leonro@nvidia.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFT net-next 5/6] devlink: hold the instance lock in port_split / port_unsplit callbacks
Date:   Wed,  9 Mar 2022 16:16:31 -0800
Message-Id: <20220310001632.470337-6-kuba@kernel.org>
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

Let the core take the devlink instance lock around port splitting
and remove the now redundant locking in the drivers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  7 ----
 .../net/ethernet/netronome/nfp/nfp_devlink.c  | 32 +++++--------------
 net/core/devlink.c                            |  2 --
 3 files changed, 8 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 1e823b669d1c..8eb05090ffec 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2025,7 +2025,6 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u16 local_port,
 			       struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
-	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 	struct mlxsw_sp_port_mapping port_mapping;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	enum mlxsw_reg_pmtdb_status status;
@@ -2063,7 +2062,6 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u16 local_port,
 
 	port_mapping = mlxsw_sp_port->mapping;
 
-	devl_lock(devlink);
 	for (i = 0; i < count; i++) {
 		u16 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
 
@@ -2077,13 +2075,11 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u16 local_port,
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to create split ports\n");
 		goto err_port_split_create;
 	}
-	devl_unlock(devlink);
 
 	return 0;
 
 err_port_split_create:
 	mlxsw_sp_port_unsplit_create(mlxsw_sp, count, pmtdb_pl);
-	devl_unlock(devlink);
 	return err;
 }
 
@@ -2091,7 +2087,6 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u16 local_port,
 				 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
-	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	char pmtdb_pl[MLXSW_REG_PMTDB_LEN];
 	unsigned int count;
@@ -2123,7 +2118,6 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u16 local_port,
 		return err;
 	}
 
-	devl_lock(devlink);
 	for (i = 0; i < count; i++) {
 		u16 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
 
@@ -2132,7 +2126,6 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u16 local_port,
 	}
 
 	mlxsw_sp_port_unsplit_create(mlxsw_sp, count, pmtdb_pl);
-	devl_unlock(devlink);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 865f62958a72..6bd6f4a67c30 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -70,29 +70,21 @@ nfp_devlink_port_split(struct devlink *devlink, unsigned int port_index,
 	unsigned int lanes;
 	int ret;
 
-	devl_lock(devlink);
-
 	rtnl_lock();
 	ret = nfp_devlink_fill_eth_port_from_id(pf, port_index, &eth_port);
 	rtnl_unlock();
 	if (ret)
-		goto out;
+		return ret;
 
-	if (eth_port.port_lanes % count) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (eth_port.port_lanes % count)
+		return -EINVAL;
 
 	/* Special case the 100G CXP -> 2x40G split */
 	lanes = eth_port.port_lanes / count;
 	if (eth_port.lanes == 10 && count == 2)
 		lanes = 8 / count;
 
-	ret = nfp_devlink_set_lanes(pf, eth_port.index, lanes);
-out:
-	devl_unlock(devlink);
-
-	return ret;
+	return nfp_devlink_set_lanes(pf, eth_port.index, lanes);
 }
 
 static int
@@ -104,29 +96,21 @@ nfp_devlink_port_unsplit(struct devlink *devlink, unsigned int port_index,
 	unsigned int lanes;
 	int ret;
 
-	devl_lock(devlink);
-
 	rtnl_lock();
 	ret = nfp_devlink_fill_eth_port_from_id(pf, port_index, &eth_port);
 	rtnl_unlock();
 	if (ret)
-		goto out;
+		return ret;
 
-	if (!eth_port.is_split) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!eth_port.is_split)
+		return -EINVAL;
 
 	/* Special case the 100G CXP -> 2x40G unsplit */
 	lanes = eth_port.port_lanes;
 	if (eth_port.port_lanes == 8)
 		lanes = 10;
 
-	ret = nfp_devlink_set_lanes(pf, eth_port.index, lanes);
-out:
-	devl_unlock(devlink);
-
-	return ret;
+	return nfp_devlink_set_lanes(pf, eth_port.index, lanes);
 }
 
 static int
diff --git a/net/core/devlink.c b/net/core/devlink.c
index c30da1fc023d..3069a3833576 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8676,14 +8676,12 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_split_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_UNSPLIT,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_unsplit_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_NEW,
-- 
2.34.1


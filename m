Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5DBD4D9446
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 07:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345089AbiCOGBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 02:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345057AbiCOGBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 02:01:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5796047386
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 23:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA439612D3
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 06:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDCBC36AE5;
        Tue, 15 Mar 2022 06:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647324018;
        bh=FVX6e7xrq4JiNRJSx3oIPgP8ww6EYGzl33n4qcw5474=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVc9sIPz+dII8LP/gzo/9Wlm9nVElSoL3JKD6p1Eb9HNbwfjvmCzusWDcd2decTvy
         CB+qKVOmf8uEUGlmWRV9iQBXr9yTnvTONYiqV4r0Cuu+R1rNCIpKZiiVqKyLrthQIh
         J72YgvfwTktf548cWEnsgKonwmrvK64fpEnEB4JuaGHjEvo9Q04EZrUWWeqNdd+ZdE
         vzu+w4ffUoN1KZqwOsxlGN2k4GdkAKYt9uREFY6nl6h6GOrZhOE+SMvnGHeWpBvuzi
         Sp3ritndaGK3Q2XVk66RxdhRClA94Us06pgj4dT1zE6lCWAYNRCkfYDx72F0TH6ugT
         w6GqH6iacku0g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, idosch@nvidia.com,
        petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/6] devlink: hold the instance lock in port_split / port_unsplit callbacks
Date:   Mon, 14 Mar 2022 23:00:08 -0700
Message-Id: <20220315060009.1028519-6-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220315060009.1028519-1-kuba@kernel.org>
References: <20220315060009.1028519-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 769e5f7fa219..545ae784e9d2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8672,14 +8672,12 @@ static const struct genl_small_ops devlink_nl_ops[] = {
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


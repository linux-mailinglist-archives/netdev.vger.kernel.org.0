Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09FF3E5BDD
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241734AbhHJNik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241672AbhHJNiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:38:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F2A060EE9;
        Tue, 10 Aug 2021 13:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628602677;
        bh=Db1MP3xIgL/VeLq8W65kNJw4ggeLpjP4aKbSFa7JTUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXcdyu2Jp93JuSZYXbeiL7lCn0uWqIbEHlYIMp1WCmDEbgptqn4S5VuFqTNQJHlIU
         HtFM3Qzt+mMVCznZIxsgnAetooDXmggle2qnwlbkMDQ+c1cIdf4yr3Zv7rTobZViu9
         8bY5ZGmrY8VsXr12wnSrgJtauakA/ns2GDuOWD+wze8ki282F4PFwRc9GlUGfTDsZD
         wqsM0IUXRS5vfx1hP5NNhjWQRxSlPuds6rU1SJr6jM/r1ib21FPQUm8Wy3US3rnH97
         4OO9i8xILHN/95LNuo+yXyjLYZ8WcyeDF0PCMs/Y16R5frsd8EFLqMBj/h/wjy7MH/
         eA0TMeIMFNTuA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: [PATCH net-next 3/5] mlxsw: core: Refactor code to publish devlink ops when device is ready
Date:   Tue, 10 Aug 2021 16:37:33 +0300
Message-Id: <d22bb44311777533d903555de9559f1fe80c3802.1628599239.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628599239.git.leonro@nvidia.com>
References: <cover.1628599239.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Move devlink_register() to be last command after device is fully
initialized.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 27 +++++++++++-----------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index f080fab3de2b..a8a989070aaf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1974,12 +1974,6 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (err)
 		goto err_emad_init;
 
-	if (!reload) {
-		err = devlink_register(devlink);
-		if (err)
-			goto err_devlink_register;
-	}
-
 	if (!reload) {
 		err = mlxsw_core_params_register(mlxsw_core);
 		if (err)
@@ -2017,11 +2011,20 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	mlxsw_core->is_initialized = true;
 	devlink_params_publish(devlink);
 
-	if (!reload)
+	if (!reload) {
+		err = devlink_register(devlink);
+		if (err)
+			goto err_devlink_register;
+
 		devlink_reload_enable(devlink);
+	}
 
 	return 0;
 
+err_devlink_register:
+	devlink_params_unpublish(devlink);
+	mlxsw_core->is_initialized = false;
+	mlxsw_env_fini(mlxsw_core->env);
 err_env_init:
 	mlxsw_thermal_fini(mlxsw_core->thermal);
 err_thermal_init:
@@ -2036,9 +2039,6 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (!reload)
 		mlxsw_core_params_unregister(mlxsw_core);
 err_register_params:
-	if (!reload)
-		devlink_unregister(devlink);
-err_devlink_register:
 	mlxsw_emad_fini(mlxsw_core);
 err_emad_init:
 	kfree(mlxsw_core->lag.mapping);
@@ -2087,8 +2087,10 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 
-	if (!reload)
+	if (!reload) {
 		devlink_reload_disable(devlink);
+		devlink_unregister(devlink);
+	}
 	if (devlink_is_reload_failed(devlink)) {
 		if (!reload)
 			/* Only the parts that were not de-initialized in the
@@ -2109,8 +2111,6 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 	mlxsw_core_health_fini(mlxsw_core);
 	if (!reload)
 		mlxsw_core_params_unregister(mlxsw_core);
-	if (!reload)
-		devlink_unregister(devlink);
 	mlxsw_emad_fini(mlxsw_core);
 	kfree(mlxsw_core->lag.mapping);
 	mlxsw_ports_fini(mlxsw_core, reload);
@@ -2124,7 +2124,6 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 
 reload_fail_deinit:
 	mlxsw_core_params_unregister(mlxsw_core);
-	devlink_unregister(devlink);
 	devlink_resources_unregister(devlink, NULL);
 	devlink_free(devlink);
 }
-- 
2.31.1


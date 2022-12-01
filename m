Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249A063F596
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiLAQqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLAQqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:46:22 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68245B0DDA
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:46:17 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id vv4so5599958ejc.2
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 08:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6PmPCwisSN6edwEjWasd+zdr1/T2q3IACarVCyKDRIs=;
        b=FXpeLnfdxJrFZN5yw0tdoPzEQ+LNu0SzF7zcNau5t+Ej1wnElCJ/qOwZCa3Zu+uK8D
         2xGvZlQZlCkbkDqkDt6UpVBYppXktgA1ykzqlRZcmowzeDoQS23jAypZEAOOS+cSqtcl
         J6KGeGIr2qu0cM9t9QmP5R94J+Qo5kQiaTvqd9poe8eYN3JPteYajrFtP4WTkJDOL1ub
         MFcRtZn9gZ8ii6JTClIEnVMzm1V0GxMQJLZuV4LAof50Y8Le5LyP//PpePosZkfAE+cb
         TVvlc/iyBEDddxhCk8IZmffsxBgEKR49DxM2eTgv8RBAAqeWD6NCZVgikfSxv7Lkdftw
         S5KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6PmPCwisSN6edwEjWasd+zdr1/T2q3IACarVCyKDRIs=;
        b=uhQOm1pvvdh2C3KP0NQCwBxv78uD4IjNbRFqOhiGKf0TemOCtudrgm7m0xWvhBoclc
         2qOdfsxSriMwCBrApjO7/Q+3AGB6druwbwYHCtG0UsfKNJXU+93Q7a+NlEyFcXw1zA+q
         EdmITNHW5tl5PG98U9+J6TmUhFz/04SX0Q3oRWMPfAPlMwE+UfPwE/8dUXcnZiR1zjGG
         IObvGmLcOnXGWFmIdvMD+xFhUlJL2ecJJ2ertDeOcfTUm0TOg5nXouW6bixKFLV98Se1
         hJErTSBt9/I86uqsY0QYL7jyfo+lT8T7EfiXVa5b/W9pm89uDwDPHjx51g4uSFvTz98e
         RCwg==
X-Gm-Message-State: ANoB5pnk55f1YbT6kHUafPm6mQwTt4nOMmTV+8r/G5DX6NvSzWE/FJjj
        ANBjTwfDdTlmG+iHngF1HfsQ8834eMcW3ZzI
X-Google-Smtp-Source: AA0mqf7x4QZADPXYFbNlXrOMPitCPBGFuEPFBvqG696YquxJ+aXtJBrQGXe0bDTXXSCILni+5gz+rg==
X-Received: by 2002:a17:906:4e8c:b0:7ba:9c18:1204 with SMTP id v12-20020a1709064e8c00b007ba9c181204mr35122261eju.262.1669913175793;
        Thu, 01 Dec 2022 08:46:15 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id sg43-20020a170907a42b00b007bdf4340129sm2008105ejc.14.2022.12.01.08.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:46:14 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, yangyingliang@huawei.com, leon@kernel.org
Subject: [patch net-next RFC 3/7] mlxsw: Reorder devl_port_register/unregister() calls to be done when devlink is registered
Date:   Thu,  1 Dec 2022 17:46:04 +0100
Message-Id: <20221201164608.209537-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221201164608.209537-1-jiri@resnulli.us>
References: <20221201164608.209537-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Move the code so devl_port_register/unregister() are called only
then devlink is registered.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 24 ++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 38 ++++++++++++++-----
 3 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index a0a06e2eff82..9908fb0f2d8a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2215,8 +2215,24 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 		devl_unlock(devlink);
 		devlink_register(devlink);
 	}
+
+	if (mlxsw_driver->ports_init) {
+		if (!reload)
+			devl_lock(devlink);
+		err = mlxsw_driver->ports_init(mlxsw_core);
+		if (!reload)
+			devl_unlock(devlink);
+		if (err)
+			goto err_driver_ports_init;
+	}
+
 	return 0;
 
+err_driver_ports_init:
+	if (!reload) {
+		devlink_unregister(devlink);
+		devl_lock(devlink);
+	}
 err_driver_init:
 	mlxsw_env_fini(mlxsw_core->env);
 err_env_init:
@@ -2284,6 +2300,14 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 
+	if (mlxsw_core->driver->ports_fini) {
+		if (!reload)
+			devl_lock(devlink);
+		mlxsw_core->driver->ports_fini(mlxsw_core);
+		if (!reload)
+			devl_unlock(devlink);
+	}
+
 	if (!reload) {
 		devlink_unregister(devlink);
 		devl_lock(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index e0a6fcbbcb19..a41ca92318e8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -348,6 +348,8 @@ struct mlxsw_driver {
 		    const struct mlxsw_bus_info *mlxsw_bus_info,
 		    struct netlink_ext_ack *extack);
 	void (*fini)(struct mlxsw_core *mlxsw_core);
+	int (*ports_init)(struct mlxsw_core *mlxsw_core);
+	void (*ports_fini)(struct mlxsw_core *mlxsw_core);
 	int (*port_split)(struct mlxsw_core *mlxsw_core, u16 local_port,
 			  unsigned int count, struct netlink_ext_ack *extack);
 	int (*port_unsplit)(struct mlxsw_core *mlxsw_core, u16 local_port,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index f5b2d965d476..b216c7dd8419 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3251,16 +3251,8 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		goto err_sample_trigger_init;
 	}
 
-	err = mlxsw_sp_ports_create(mlxsw_sp);
-	if (err) {
-		dev_err(mlxsw_sp->bus_info->dev, "Failed to create ports\n");
-		goto err_ports_create;
-	}
-
 	return 0;
 
-err_ports_create:
-	rhashtable_destroy(&mlxsw_sp->sample_trigger_ht);
 err_sample_trigger_init:
 	mlxsw_sp_port_module_info_fini(mlxsw_sp);
 err_port_module_info_init:
@@ -3445,11 +3437,24 @@ static int mlxsw_sp4_init(struct mlxsw_core *mlxsw_core,
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
 }
 
+static int mlxsw_sp_ports_init(struct mlxsw_core *mlxsw_core)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	int err;
+
+	err = mlxsw_sp_ports_create(mlxsw_sp);
+	if (err) {
+		dev_err(mlxsw_sp->bus_info->dev, "Failed to create ports\n");
+		return err;
+	}
+
+	return 0;
+}
+
 static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
-	mlxsw_sp_ports_remove(mlxsw_sp);
 	rhashtable_destroy(&mlxsw_sp->sample_trigger_ht);
 	mlxsw_sp_port_module_info_fini(mlxsw_sp);
 	mlxsw_sp_dpipe_fini(mlxsw_sp);
@@ -3478,6 +3483,13 @@ static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 	mlxsw_sp_parsing_fini(mlxsw_sp);
 }
 
+static void mlxsw_sp_ports_fini(struct mlxsw_core *mlxsw_core)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+
+	mlxsw_sp_ports_remove(mlxsw_sp);
+}
+
 static const struct mlxsw_config_profile mlxsw_sp1_config_profile = {
 	.used_flood_mode                = 1,
 	.flood_mode                     = MLXSW_CMD_MBOX_CONFIG_PROFILE_FLOOD_MODE_CONTROLLED,
@@ -3934,6 +3946,8 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 	.fw_filename			= MLXSW_SP1_FW_FILENAME,
 	.init				= mlxsw_sp1_init,
 	.fini				= mlxsw_sp_fini,
+	.ports_init			= mlxsw_sp_ports_init,
+	.ports_fini			= mlxsw_sp_ports_fini,
 	.port_split			= mlxsw_sp_port_split,
 	.port_unsplit			= mlxsw_sp_port_unsplit,
 	.sb_pool_get			= mlxsw_sp_sb_pool_get,
@@ -3971,6 +3985,8 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.fw_filename			= MLXSW_SP2_FW_FILENAME,
 	.init				= mlxsw_sp2_init,
 	.fini				= mlxsw_sp_fini,
+	.ports_init			= mlxsw_sp_ports_init,
+	.ports_fini			= mlxsw_sp_ports_fini,
 	.port_split			= mlxsw_sp_port_split,
 	.port_unsplit			= mlxsw_sp_port_unsplit,
 	.ports_remove_selected		= mlxsw_sp_ports_remove_selected,
@@ -4010,6 +4026,8 @@ static struct mlxsw_driver mlxsw_sp3_driver = {
 	.fw_filename			= MLXSW_SP3_FW_FILENAME,
 	.init				= mlxsw_sp3_init,
 	.fini				= mlxsw_sp_fini,
+	.ports_init			= mlxsw_sp_ports_init,
+	.ports_fini			= mlxsw_sp_ports_fini,
 	.port_split			= mlxsw_sp_port_split,
 	.port_unsplit			= mlxsw_sp_port_unsplit,
 	.ports_remove_selected		= mlxsw_sp_ports_remove_selected,
@@ -4047,6 +4065,8 @@ static struct mlxsw_driver mlxsw_sp4_driver = {
 	.priv_size			= sizeof(struct mlxsw_sp),
 	.init				= mlxsw_sp4_init,
 	.fini				= mlxsw_sp_fini,
+	.ports_init			= mlxsw_sp_ports_init,
+	.ports_fini			= mlxsw_sp_ports_fini,
 	.port_split			= mlxsw_sp_port_split,
 	.port_unsplit			= mlxsw_sp_port_unsplit,
 	.ports_remove_selected		= mlxsw_sp_ports_remove_selected,
-- 
2.37.3


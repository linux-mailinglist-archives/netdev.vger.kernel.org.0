Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D05576D61
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 13:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiGPLDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 07:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiGPLC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 07:02:58 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EDF26AD5
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 04:02:55 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id j22so13035813ejs.2
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 04:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/9XY6Q5AA9MjpxyRmF9mHOpLEMTGRAgAw7MljtOr4fc=;
        b=xFpmbHLs2FewxXVfhDt3q1948pgAyTfPj1PYSto8tdD3L98vi8K4aLq8aJ4kV72rBR
         5/ky0bWv8KVig/EuVkGr6QzXbbV1pApwqE5/0NO7EArlKNU4j3mU2VW4T+D7j60N2wj5
         /91nPQwW6n+ABiFXBIqEu5uwiLcsITh5/b5B3PYeeb+uqHkn70Gw3Ujp44hrib44+/JH
         uMdgq0cGeRi3H7z/XfTjVRPZpAd63ntDc5QMReuaAyGXLJ80HNzYfy+gav4WRpSqQgbH
         WL8G0Vm/SAs3RCg4MpOUaJdD7uuh2g/YQqK+TqX0o1MTLNaP34qMJMxkQ/597R3C4KZb
         JK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/9XY6Q5AA9MjpxyRmF9mHOpLEMTGRAgAw7MljtOr4fc=;
        b=Rr7wBuzm8Fsciz/Fv4Ogr1IGsJ9/BqdqVvQ1sCwrCzrCleg22GRNdvkym2zrefzKZS
         kqQq9gRXQHi0x6ITuKLsZXrtzjVVRf8khkT5ECnK/GUpgQoWGGhRhPZmJfN6HKPziEOg
         /1biVRQmVFDuh4qa4GKqop9tc7U7BaANdjNYdW8u8TX2EIMQT7m6ouOFEqeEIwqLcf1f
         9voQMCvnZlw2NcVHwzsMqf+P3EKpF4FlWkQo6hwnmBsPNBCSUBXv9VxCIc7TevTypmho
         TOXkszx9qxivAfYNxJIiYULO8Ef0KHTE5WOmHn4DIiOMOIMP7NEQuwwr39j2ncsZxYCm
         3SbQ==
X-Gm-Message-State: AJIora+RJWpYTlmHXWp9GUgLWpw0nAm8/aTyKNRfKBAsTG0uYfiL9waI
        eSUIaqJWjCpEoQc2/p+Ppb8U//Mf1IaGAcUE
X-Google-Smtp-Source: AGRyM1sRbIbBjBQloHV3SPGmy5S/suRCB2CK+smSpWNcQIgL2tEG9YV5Rnuz6M1MQUfo2LDDSQ1LeA==
X-Received: by 2002:a17:906:98c9:b0:72b:40de:9afe with SMTP id zd9-20020a17090698c900b0072b40de9afemr18133014ejb.620.1657969374233;
        Sat, 16 Jul 2022 04:02:54 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id uh40-20020a170906b3a800b0072ab06bc3b5sm3056184ejc.34.2022.07.16.04.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 04:02:53 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next 6/9] mlxsw: convert driver to use unlocked devlink API during init/fini
Date:   Sat, 16 Jul 2022 13:02:38 +0200
Message-Id: <20220716110241.3390528-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220716110241.3390528-1-jiri@resnulli.us>
References: <20220716110241.3390528-1-jiri@resnulli.us>
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

Prepare for devlink reload being called with devlink->lock held and
convert the mlxsw driver to use unlocked devlink API during init and
fini flows. Take devl_lock() in reload_down() and reload_up() ops in the
meantime before reload cmd is converted to take the lock itself.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- narrowed devl_lock() in reload_down/up() only around
  mlxsw_core_bus_device_register/unregister()
- do devlink_register/unregister without holding devl_lock
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  53 +++++----
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 103 ++++++++----------
 .../ethernet/mellanox/mlxsw/spectrum1_kvdl.c  |  82 +++++++-------
 .../mellanox/mlxsw/spectrum_buffers.c         |  14 +--
 .../ethernet/mellanox/mlxsw/spectrum_cnt.c    |  62 +++++------
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c  |  88 +++++++--------
 .../mellanox/mlxsw/spectrum_policer.c         |  32 +++---
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  22 ++--
 .../ethernet/mellanox/mlxsw/spectrum_span.c   |   6 +-
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  27 +++--
 10 files changed, 248 insertions(+), 241 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index ab1cebf227fb..61eb96b93889 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -127,11 +127,11 @@ static int mlxsw_core_resources_ports_register(struct mlxsw_core *mlxsw_core)
 					  max_ports, 1,
 					  DEVLINK_RESOURCE_UNIT_ENTRY);
 
-	return devlink_resource_register(devlink,
-					 DEVLINK_RESOURCE_GENERIC_NAME_PORTS,
-					 max_ports, MLXSW_CORE_RESOURCE_PORTS,
-					 DEVLINK_RESOURCE_ID_PARENT_TOP,
-					 &ports_num_params);
+	return devl_resource_register(devlink,
+				      DEVLINK_RESOURCE_GENERIC_NAME_PORTS,
+				      max_ports, MLXSW_CORE_RESOURCE_PORTS,
+				      DEVLINK_RESOURCE_ID_PARENT_TOP,
+				      &ports_num_params);
 }
 
 static int mlxsw_ports_init(struct mlxsw_core *mlxsw_core, bool reload)
@@ -157,8 +157,8 @@ static int mlxsw_ports_init(struct mlxsw_core *mlxsw_core, bool reload)
 			goto err_resources_ports_register;
 	}
 	atomic_set(&mlxsw_core->active_ports_count, 0);
-	devlink_resource_occ_get_register(devlink, MLXSW_CORE_RESOURCE_PORTS,
-					  mlxsw_ports_occ_get, mlxsw_core);
+	devl_resource_occ_get_register(devlink, MLXSW_CORE_RESOURCE_PORTS,
+				       mlxsw_ports_occ_get, mlxsw_core);
 
 	return 0;
 
@@ -171,9 +171,9 @@ static void mlxsw_ports_fini(struct mlxsw_core *mlxsw_core, bool reload)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 
-	devlink_resource_occ_get_unregister(devlink, MLXSW_CORE_RESOURCE_PORTS);
+	devl_resource_occ_get_unregister(devlink, MLXSW_CORE_RESOURCE_PORTS);
 	if (!reload)
-		devlink_resources_unregister(priv_to_devlink(mlxsw_core));
+		devl_resources_unregister(priv_to_devlink(mlxsw_core));
 
 	kfree(mlxsw_core->ports);
 }
@@ -1488,7 +1488,9 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
 	if (!(mlxsw_core->bus->features & MLXSW_BUS_F_RESET))
 		return -EOPNOTSUPP;
 
+	devl_lock(devlink);
 	mlxsw_core_bus_device_unregister(mlxsw_core, true);
+	devl_unlock(devlink);
 	return 0;
 }
 
@@ -1498,13 +1500,17 @@ mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_re
 					struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
+	int err;
 
 	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 			     BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE);
-	return mlxsw_core_bus_device_register(mlxsw_core->bus_info,
-					      mlxsw_core->bus,
-					      mlxsw_core->bus_priv, true,
-					      devlink, extack);
+	devl_lock(devlink);
+	err = mlxsw_core_bus_device_register(mlxsw_core->bus_info,
+					     mlxsw_core->bus,
+					     mlxsw_core->bus_priv, true,
+					     devlink, extack);
+	devl_unlock(devlink);
+	return err;
 }
 
 static int mlxsw_devlink_flash_update(struct devlink *devlink,
@@ -2102,6 +2108,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 			err = -ENOMEM;
 			goto err_devlink_alloc;
 		}
+		devl_lock(devlink);
 	}
 
 	mlxsw_core = devlink_priv(devlink);
@@ -2187,6 +2194,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 
 	if (!reload) {
 		devlink_set_features(devlink, DEVLINK_F_RELOAD);
+		devl_unlock(devlink);
 		devlink_register(devlink);
 	}
 	return 0;
@@ -2214,12 +2222,14 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	mlxsw_ports_fini(mlxsw_core, reload);
 err_ports_init:
 	if (!reload)
-		devlink_resources_unregister(devlink);
+		devl_resources_unregister(devlink);
 err_register_resources:
 	mlxsw_bus->fini(bus_priv);
 err_bus_init:
-	if (!reload)
+	if (!reload) {
+		devl_unlock(devlink);
 		devlink_free(devlink);
+	}
 err_devlink_alloc:
 	return err;
 }
@@ -2255,8 +2265,10 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 
-	if (!reload)
+	if (!reload) {
 		devlink_unregister(devlink);
+		devl_lock(devlink);
+	}
 
 	if (devlink_is_reload_failed(devlink)) {
 		if (!reload)
@@ -2281,17 +2293,20 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 	kfree(mlxsw_core->lag.mapping);
 	mlxsw_ports_fini(mlxsw_core, reload);
 	if (!reload)
-		devlink_resources_unregister(devlink);
+		devl_resources_unregister(devlink);
 	mlxsw_core->bus->fini(mlxsw_core->bus_priv);
-	if (!reload)
+	if (!reload) {
 		devlink_free(devlink);
+		devl_unlock(devlink);
+	}
 
 	return;
 
 reload_fail_deinit:
 	mlxsw_core_params_unregister(mlxsw_core);
-	devlink_resources_unregister(devlink);
+	devl_resources_unregister(devlink);
 	devlink_free(devlink);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL(mlxsw_core_bus_device_unregister);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index a703ca257198..209587cf7529 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1999,7 +1999,6 @@ __mlxsw_sp_port_mapping_events_cancel(struct mlxsw_sp *mlxsw_sp)
 static void mlxsw_sp_ports_remove(struct mlxsw_sp *mlxsw_sp)
 {
 	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
-	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int i;
 
 	for (i = 1; i < max_ports; i++)
@@ -2007,12 +2006,10 @@ static void mlxsw_sp_ports_remove(struct mlxsw_sp *mlxsw_sp)
 	/* Make sure all scheduled events are processed */
 	__mlxsw_sp_port_mapping_events_cancel(mlxsw_sp);
 
-	devl_lock(devlink);
 	for (i = 1; i < max_ports; i++)
 		if (mlxsw_sp_port_created(mlxsw_sp, i))
 			mlxsw_sp_port_remove(mlxsw_sp, i);
 	mlxsw_sp_cpu_port_remove(mlxsw_sp);
-	devl_unlock(devlink);
 	kfree(mlxsw_sp->ports);
 	mlxsw_sp->ports = NULL;
 }
@@ -2034,7 +2031,6 @@ mlxsw_sp_ports_remove_selected(struct mlxsw_core *mlxsw_core,
 static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 {
 	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
-	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	struct mlxsw_sp_port_mapping_events *events;
 	struct mlxsw_sp_port_mapping *port_mapping;
 	size_t alloc_size;
@@ -2057,7 +2053,6 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 			goto err_event_enable;
 	}
 
-	devl_lock(devlink);
 	err = mlxsw_sp_cpu_port_create(mlxsw_sp);
 	if (err)
 		goto err_cpu_port_create;
@@ -2070,7 +2065,6 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 		if (err)
 			goto err_port_create;
 	}
-	devl_unlock(devlink);
 	return 0;
 
 err_port_create:
@@ -2080,7 +2074,6 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 	i = max_ports;
 	mlxsw_sp_cpu_port_remove(mlxsw_sp);
 err_cpu_port_create:
-	devl_unlock(devlink);
 err_event_enable:
 	for (i--; i >= 1; i--)
 		mlxsw_sp_port_mapping_event_set(mlxsw_sp, i, false);
@@ -3477,19 +3470,19 @@ static int mlxsw_sp1_resources_kvd_register(struct mlxsw_core *mlxsw_core)
 					      &hash_single_size_params);
 
 	kvd_size = MLXSW_CORE_RES_GET(mlxsw_core, KVD_SIZE);
-	err = devlink_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD,
-					kvd_size, MLXSW_SP_RESOURCE_KVD,
-					DEVLINK_RESOURCE_ID_PARENT_TOP,
-					&kvd_size_params);
+	err = devl_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD,
+				     kvd_size, MLXSW_SP_RESOURCE_KVD,
+				     DEVLINK_RESOURCE_ID_PARENT_TOP,
+				     &kvd_size_params);
 	if (err)
 		return err;
 
 	linear_size = profile->kvd_linear_size;
-	err = devlink_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD_LINEAR,
-					linear_size,
-					MLXSW_SP_RESOURCE_KVD_LINEAR,
-					MLXSW_SP_RESOURCE_KVD,
-					&linear_size_params);
+	err = devl_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD_LINEAR,
+				     linear_size,
+				     MLXSW_SP_RESOURCE_KVD_LINEAR,
+				     MLXSW_SP_RESOURCE_KVD,
+				     &linear_size_params);
 	if (err)
 		return err;
 
@@ -3502,20 +3495,20 @@ static int mlxsw_sp1_resources_kvd_register(struct mlxsw_core *mlxsw_core)
 	double_size /= profile->kvd_hash_double_parts +
 		       profile->kvd_hash_single_parts;
 	double_size = rounddown(double_size, MLXSW_SP_KVD_GRANULARITY);
-	err = devlink_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD_HASH_DOUBLE,
-					double_size,
-					MLXSW_SP_RESOURCE_KVD_HASH_DOUBLE,
-					MLXSW_SP_RESOURCE_KVD,
-					&hash_double_size_params);
+	err = devl_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD_HASH_DOUBLE,
+				     double_size,
+				     MLXSW_SP_RESOURCE_KVD_HASH_DOUBLE,
+				     MLXSW_SP_RESOURCE_KVD,
+				     &hash_double_size_params);
 	if (err)
 		return err;
 
 	single_size = kvd_size - double_size - linear_size;
-	err = devlink_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD_HASH_SINGLE,
-					single_size,
-					MLXSW_SP_RESOURCE_KVD_HASH_SINGLE,
-					MLXSW_SP_RESOURCE_KVD,
-					&hash_single_size_params);
+	err = devl_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD_HASH_SINGLE,
+				     single_size,
+				     MLXSW_SP_RESOURCE_KVD_HASH_SINGLE,
+				     MLXSW_SP_RESOURCE_KVD,
+				     &hash_single_size_params);
 	if (err)
 		return err;
 
@@ -3536,10 +3529,10 @@ static int mlxsw_sp2_resources_kvd_register(struct mlxsw_core *mlxsw_core)
 					  MLXSW_SP_KVD_GRANULARITY,
 					  DEVLINK_RESOURCE_UNIT_ENTRY);
 
-	return devlink_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD,
-					 kvd_size, MLXSW_SP_RESOURCE_KVD,
-					 DEVLINK_RESOURCE_ID_PARENT_TOP,
-					 &kvd_size_params);
+	return devl_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD,
+				      kvd_size, MLXSW_SP_RESOURCE_KVD,
+				      DEVLINK_RESOURCE_ID_PARENT_TOP,
+				      &kvd_size_params);
 }
 
 static int mlxsw_sp_resources_span_register(struct mlxsw_core *mlxsw_core)
@@ -3555,10 +3548,10 @@ static int mlxsw_sp_resources_span_register(struct mlxsw_core *mlxsw_core)
 	devlink_resource_size_params_init(&span_size_params, max_span, max_span,
 					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
 
-	return devlink_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_SPAN,
-					 max_span, MLXSW_SP_RESOURCE_SPAN,
-					 DEVLINK_RESOURCE_ID_PARENT_TOP,
-					 &span_size_params);
+	return devl_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_SPAN,
+				      max_span, MLXSW_SP_RESOURCE_SPAN,
+				      DEVLINK_RESOURCE_ID_PARENT_TOP,
+				      &span_size_params);
 }
 
 static int
@@ -3577,12 +3570,12 @@ mlxsw_sp_resources_rif_mac_profile_register(struct mlxsw_core *mlxsw_core)
 					  max_rif_mac_profiles, 1,
 					  DEVLINK_RESOURCE_UNIT_ENTRY);
 
-	return devlink_resource_register(devlink,
-					 "rif_mac_profiles",
-					 max_rif_mac_profiles,
-					 MLXSW_SP_RESOURCE_RIF_MAC_PROFILES,
-					 DEVLINK_RESOURCE_ID_PARENT_TOP,
-					 &size_params);
+	return devl_resource_register(devlink,
+				      "rif_mac_profiles",
+				      max_rif_mac_profiles,
+				      MLXSW_SP_RESOURCE_RIF_MAC_PROFILES,
+				      DEVLINK_RESOURCE_ID_PARENT_TOP,
+				      &size_params);
 }
 
 static int mlxsw_sp_resources_rifs_register(struct mlxsw_core *mlxsw_core)
@@ -3598,10 +3591,10 @@ static int mlxsw_sp_resources_rifs_register(struct mlxsw_core *mlxsw_core)
 	devlink_resource_size_params_init(&size_params, max_rifs, max_rifs,
 					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
 
-	return devlink_resource_register(devlink, "rifs", max_rifs,
-					 MLXSW_SP_RESOURCE_RIFS,
-					 DEVLINK_RESOURCE_ID_PARENT_TOP,
-					 &size_params);
+	return devl_resource_register(devlink, "rifs", max_rifs,
+				      MLXSW_SP_RESOURCE_RIFS,
+				      DEVLINK_RESOURCE_ID_PARENT_TOP,
+				      &size_params);
 }
 
 static int mlxsw_sp1_resources_register(struct mlxsw_core *mlxsw_core)
@@ -3639,7 +3632,7 @@ static int mlxsw_sp1_resources_register(struct mlxsw_core *mlxsw_core)
 err_policer_resources_register:
 err_resources_counter_register:
 err_resources_span_register:
-	devlink_resources_unregister(priv_to_devlink(mlxsw_core));
+	devl_resources_unregister(priv_to_devlink(mlxsw_core));
 	return err;
 }
 
@@ -3678,7 +3671,7 @@ static int mlxsw_sp2_resources_register(struct mlxsw_core *mlxsw_core)
 err_policer_resources_register:
 err_resources_counter_register:
 err_resources_span_register:
-	devlink_resources_unregister(priv_to_devlink(mlxsw_core));
+	devl_resources_unregister(priv_to_devlink(mlxsw_core));
 	return err;
 }
 
@@ -3702,15 +3695,15 @@ static int mlxsw_sp_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
 	 * granularity from the profile. In case the user
 	 * provided the sizes they are obtained via devlink.
 	 */
-	err = devlink_resource_size_get(devlink,
-					MLXSW_SP_RESOURCE_KVD_LINEAR,
-					p_linear_size);
+	err = devl_resource_size_get(devlink,
+				     MLXSW_SP_RESOURCE_KVD_LINEAR,
+				     p_linear_size);
 	if (err)
 		*p_linear_size = profile->kvd_linear_size;
 
-	err = devlink_resource_size_get(devlink,
-					MLXSW_SP_RESOURCE_KVD_HASH_DOUBLE,
-					p_double_size);
+	err = devl_resource_size_get(devlink,
+				     MLXSW_SP_RESOURCE_KVD_HASH_DOUBLE,
+				     p_double_size);
 	if (err) {
 		double_size = MLXSW_CORE_RES_GET(mlxsw_core, KVD_SIZE) -
 			      *p_linear_size;
@@ -3721,9 +3714,9 @@ static int mlxsw_sp_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
 					   MLXSW_SP_KVD_GRANULARITY);
 	}
 
-	err = devlink_resource_size_get(devlink,
-					MLXSW_SP_RESOURCE_KVD_HASH_SINGLE,
-					p_single_size);
+	err = devl_resource_size_get(devlink,
+				     MLXSW_SP_RESOURCE_KVD_HASH_SINGLE,
+				     p_single_size);
 	if (err)
 		*p_single_size = MLXSW_CORE_RES_GET(mlxsw_core, KVD_SIZE) -
 				 *p_double_size - *p_linear_size;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c
index d20e794e01ca..1e3fc989393c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c
@@ -216,8 +216,8 @@ mlxsw_sp1_kvdl_part_init(struct mlxsw_sp *mlxsw_sp,
 	u64 resource_size;
 	int err;
 
-	err = devlink_resource_size_get(devlink, info->resource_id,
-					&resource_size);
+	err = devl_resource_size_get(devlink, info->resource_id,
+				     &resource_size);
 	if (err) {
 		need_update = false;
 		resource_size = info->end_index - info->start_index + 1;
@@ -338,22 +338,22 @@ static int mlxsw_sp1_kvdl_init(struct mlxsw_sp *mlxsw_sp, void *priv)
 	err = mlxsw_sp1_kvdl_parts_init(mlxsw_sp, kvdl);
 	if (err)
 		return err;
-	devlink_resource_occ_get_register(devlink,
-					  MLXSW_SP_RESOURCE_KVD_LINEAR,
-					  mlxsw_sp1_kvdl_occ_get,
-					  kvdl);
-	devlink_resource_occ_get_register(devlink,
-					  MLXSW_SP_RESOURCE_KVD_LINEAR_SINGLE,
-					  mlxsw_sp1_kvdl_single_occ_get,
-					  kvdl);
-	devlink_resource_occ_get_register(devlink,
-					  MLXSW_SP_RESOURCE_KVD_LINEAR_CHUNKS,
-					  mlxsw_sp1_kvdl_chunks_occ_get,
-					  kvdl);
-	devlink_resource_occ_get_register(devlink,
-					  MLXSW_SP_RESOURCE_KVD_LINEAR_LARGE_CHUNKS,
-					  mlxsw_sp1_kvdl_large_chunks_occ_get,
-					  kvdl);
+	devl_resource_occ_get_register(devlink,
+				       MLXSW_SP_RESOURCE_KVD_LINEAR,
+				       mlxsw_sp1_kvdl_occ_get,
+				       kvdl);
+	devl_resource_occ_get_register(devlink,
+				       MLXSW_SP_RESOURCE_KVD_LINEAR_SINGLE,
+				       mlxsw_sp1_kvdl_single_occ_get,
+				       kvdl);
+	devl_resource_occ_get_register(devlink,
+				       MLXSW_SP_RESOURCE_KVD_LINEAR_CHUNKS,
+				       mlxsw_sp1_kvdl_chunks_occ_get,
+				       kvdl);
+	devl_resource_occ_get_register(devlink,
+				       MLXSW_SP_RESOURCE_KVD_LINEAR_LARGE_CHUNKS,
+				       mlxsw_sp1_kvdl_large_chunks_occ_get,
+				       kvdl);
 	return 0;
 }
 
@@ -362,14 +362,14 @@ static void mlxsw_sp1_kvdl_fini(struct mlxsw_sp *mlxsw_sp, void *priv)
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	struct mlxsw_sp1_kvdl *kvdl = priv;
 
-	devlink_resource_occ_get_unregister(devlink,
-					    MLXSW_SP_RESOURCE_KVD_LINEAR_LARGE_CHUNKS);
-	devlink_resource_occ_get_unregister(devlink,
-					    MLXSW_SP_RESOURCE_KVD_LINEAR_CHUNKS);
-	devlink_resource_occ_get_unregister(devlink,
-					    MLXSW_SP_RESOURCE_KVD_LINEAR_SINGLE);
-	devlink_resource_occ_get_unregister(devlink,
-					    MLXSW_SP_RESOURCE_KVD_LINEAR);
+	devl_resource_occ_get_unregister(devlink,
+					 MLXSW_SP_RESOURCE_KVD_LINEAR_LARGE_CHUNKS);
+	devl_resource_occ_get_unregister(devlink,
+					 MLXSW_SP_RESOURCE_KVD_LINEAR_CHUNKS);
+	devl_resource_occ_get_unregister(devlink,
+					 MLXSW_SP_RESOURCE_KVD_LINEAR_SINGLE);
+	devl_resource_occ_get_unregister(devlink,
+					 MLXSW_SP_RESOURCE_KVD_LINEAR);
 	mlxsw_sp1_kvdl_parts_fini(kvdl);
 }
 
@@ -396,32 +396,32 @@ int mlxsw_sp1_kvdl_resources_register(struct mlxsw_core *mlxsw_core)
 	devlink_resource_size_params_init(&size_params, 0, kvdl_max_size,
 					  MLXSW_SP1_KVDL_SINGLE_ALLOC_SIZE,
 					  DEVLINK_RESOURCE_UNIT_ENTRY);
-	err = devlink_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD_LINEAR_SINGLES,
-					MLXSW_SP1_KVDL_SINGLE_SIZE,
-					MLXSW_SP_RESOURCE_KVD_LINEAR_SINGLE,
-					MLXSW_SP_RESOURCE_KVD_LINEAR,
-					&size_params);
+	err = devl_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD_LINEAR_SINGLES,
+				     MLXSW_SP1_KVDL_SINGLE_SIZE,
+				     MLXSW_SP_RESOURCE_KVD_LINEAR_SINGLE,
+				     MLXSW_SP_RESOURCE_KVD_LINEAR,
+				     &size_params);
 	if (err)
 		return err;
 
 	devlink_resource_size_params_init(&size_params, 0, kvdl_max_size,
 					  MLXSW_SP1_KVDL_CHUNKS_ALLOC_SIZE,
 					  DEVLINK_RESOURCE_UNIT_ENTRY);
-	err = devlink_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD_LINEAR_CHUNKS,
-					MLXSW_SP1_KVDL_CHUNKS_SIZE,
-					MLXSW_SP_RESOURCE_KVD_LINEAR_CHUNKS,
-					MLXSW_SP_RESOURCE_KVD_LINEAR,
-					&size_params);
+	err = devl_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD_LINEAR_CHUNKS,
+				     MLXSW_SP1_KVDL_CHUNKS_SIZE,
+				     MLXSW_SP_RESOURCE_KVD_LINEAR_CHUNKS,
+				     MLXSW_SP_RESOURCE_KVD_LINEAR,
+				     &size_params);
 	if (err)
 		return err;
 
 	devlink_resource_size_params_init(&size_params, 0, kvdl_max_size,
 					  MLXSW_SP1_KVDL_LARGE_CHUNKS_ALLOC_SIZE,
 					  DEVLINK_RESOURCE_UNIT_ENTRY);
-	err = devlink_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD_LINEAR_LARGE_CHUNKS,
-					MLXSW_SP1_KVDL_LARGE_CHUNKS_SIZE,
-					MLXSW_SP_RESOURCE_KVD_LINEAR_LARGE_CHUNKS,
-					MLXSW_SP_RESOURCE_KVD_LINEAR,
-					&size_params);
+	err = devl_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD_LINEAR_LARGE_CHUNKS,
+				     MLXSW_SP1_KVDL_LARGE_CHUNKS_SIZE,
+				     MLXSW_SP_RESOURCE_KVD_LINEAR_LARGE_CHUNKS,
+				     MLXSW_SP_RESOURCE_KVD_LINEAR,
+				     &size_params);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index c68fc8f7ca99..c9f1c79f3f9d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -1290,12 +1290,12 @@ int mlxsw_sp_buffers_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		goto err_sb_mms_init;
 	mlxsw_sp_pool_count(mlxsw_sp, &ing_pool_count, &eg_pool_count);
-	err = devlink_sb_register(priv_to_devlink(mlxsw_sp->core), 0,
-				  mlxsw_sp->sb->sb_size,
-				  ing_pool_count,
-				  eg_pool_count,
-				  MLXSW_SP_SB_ING_TC_COUNT,
-				  MLXSW_SP_SB_EG_TC_COUNT);
+	err = devl_sb_register(priv_to_devlink(mlxsw_sp->core), 0,
+			       mlxsw_sp->sb->sb_size,
+			       ing_pool_count,
+			       eg_pool_count,
+			       MLXSW_SP_SB_ING_TC_COUNT,
+			       MLXSW_SP_SB_EG_TC_COUNT);
 	if (err)
 		goto err_devlink_sb_register;
 
@@ -1314,7 +1314,7 @@ int mlxsw_sp_buffers_init(struct mlxsw_sp *mlxsw_sp)
 
 void mlxsw_sp_buffers_fini(struct mlxsw_sp *mlxsw_sp)
 {
-	devlink_sb_unregister(priv_to_devlink(mlxsw_sp->core), 0);
+	devl_sb_unregister(priv_to_devlink(mlxsw_sp->core), 0);
 	mlxsw_sp_sb_ports_fini(mlxsw_sp);
 	kfree(mlxsw_sp->sb);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
index fc2257753b9b..ee59c79156e4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
@@ -67,16 +67,16 @@ static int mlxsw_sp_counter_sub_pools_init(struct mlxsw_sp *mlxsw_sp)
 			return -EIO;
 		sub_pool->entry_size = mlxsw_core_res_get(mlxsw_sp->core,
 							  res_id);
-		err = devlink_resource_size_get(devlink,
-						sub_pool->resource_id,
-						&sub_pool->size);
+		err = devl_resource_size_get(devlink,
+					     sub_pool->resource_id,
+					     &sub_pool->size);
 		if (err)
 			goto err_resource_size_get;
 
-		devlink_resource_occ_get_register(devlink,
-						  sub_pool->resource_id,
-						  mlxsw_sp_counter_sub_pool_occ_get,
-						  sub_pool);
+		devl_resource_occ_get_register(devlink,
+					       sub_pool->resource_id,
+					       mlxsw_sp_counter_sub_pool_occ_get,
+					       sub_pool);
 
 		sub_pool->base_index = base_index;
 		base_index += sub_pool->size;
@@ -88,8 +88,8 @@ static int mlxsw_sp_counter_sub_pools_init(struct mlxsw_sp *mlxsw_sp)
 	for (i--; i >= 0; i--) {
 		sub_pool = &pool->sub_pools[i];
 
-		devlink_resource_occ_get_unregister(devlink,
-						    sub_pool->resource_id);
+		devl_resource_occ_get_unregister(devlink,
+						 sub_pool->resource_id);
 	}
 	return err;
 }
@@ -105,8 +105,8 @@ static void mlxsw_sp_counter_sub_pools_fini(struct mlxsw_sp *mlxsw_sp)
 		sub_pool = &pool->sub_pools[i];
 
 		WARN_ON(atomic_read(&sub_pool->active_entries_count));
-		devlink_resource_occ_get_unregister(devlink,
-						    sub_pool->resource_id);
+		devl_resource_occ_get_unregister(devlink,
+						 sub_pool->resource_id);
 	}
 }
 
@@ -135,12 +135,12 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	spin_lock_init(&pool->counter_pool_lock);
 	atomic_set(&pool->active_entries_count, 0);
 
-	err = devlink_resource_size_get(devlink, MLXSW_SP_RESOURCE_COUNTERS,
-					&pool->pool_size);
+	err = devl_resource_size_get(devlink, MLXSW_SP_RESOURCE_COUNTERS,
+				     &pool->pool_size);
 	if (err)
 		goto err_pool_resource_size_get;
-	devlink_resource_occ_get_register(devlink, MLXSW_SP_RESOURCE_COUNTERS,
-					  mlxsw_sp_counter_pool_occ_get, pool);
+	devl_resource_occ_get_register(devlink, MLXSW_SP_RESOURCE_COUNTERS,
+				       mlxsw_sp_counter_pool_occ_get, pool);
 
 	pool->usage = bitmap_zalloc(pool->pool_size, GFP_KERNEL);
 	if (!pool->usage) {
@@ -157,8 +157,8 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 err_sub_pools_init:
 	bitmap_free(pool->usage);
 err_usage_alloc:
-	devlink_resource_occ_get_unregister(devlink,
-					    MLXSW_SP_RESOURCE_COUNTERS);
+	devl_resource_occ_get_unregister(devlink,
+					 MLXSW_SP_RESOURCE_COUNTERS);
 err_pool_resource_size_get:
 	kfree(pool);
 	return err;
@@ -174,8 +174,8 @@ void mlxsw_sp_counter_pool_fini(struct mlxsw_sp *mlxsw_sp)
 			       pool->pool_size);
 	WARN_ON(atomic_read(&pool->active_entries_count));
 	bitmap_free(pool->usage);
-	devlink_resource_occ_get_unregister(devlink,
-					    MLXSW_SP_RESOURCE_COUNTERS);
+	devl_resource_occ_get_unregister(devlink,
+					 MLXSW_SP_RESOURCE_COUNTERS);
 	kfree(pool);
 }
 
@@ -262,12 +262,12 @@ int mlxsw_sp_counter_resources_register(struct mlxsw_core *mlxsw_core)
 	devlink_resource_size_params_init(&size_params, pool_size,
 					  pool_size, bank_size,
 					  DEVLINK_RESOURCE_UNIT_ENTRY);
-	err = devlink_resource_register(devlink,
-					MLXSW_SP_RESOURCE_NAME_COUNTERS,
-					pool_size,
-					MLXSW_SP_RESOURCE_COUNTERS,
-					DEVLINK_RESOURCE_ID_PARENT_TOP,
-					&size_params);
+	err = devl_resource_register(devlink,
+				     MLXSW_SP_RESOURCE_NAME_COUNTERS,
+				     pool_size,
+				     MLXSW_SP_RESOURCE_COUNTERS,
+				     DEVLINK_RESOURCE_ID_PARENT_TOP,
+				     &size_params);
 	if (err)
 		return err;
 
@@ -287,12 +287,12 @@ int mlxsw_sp_counter_resources_register(struct mlxsw_core *mlxsw_core)
 		devlink_resource_size_params_init(&size_params, sub_pool_size,
 						  sub_pool_size, bank_size,
 						  DEVLINK_RESOURCE_UNIT_ENTRY);
-		err = devlink_resource_register(devlink,
-						sub_pool->resource_name,
-						sub_pool_size,
-						sub_pool->resource_id,
-						MLXSW_SP_RESOURCE_COUNTERS,
-						&size_params);
+		err = devl_resource_register(devlink,
+					     sub_pool->resource_name,
+					     sub_pool_size,
+					     sub_pool->resource_id,
+					     MLXSW_SP_RESOURCE_COUNTERS,
+					     &size_params);
 		if (err)
 			return err;
 		total_bank_config += sub_pool->bank_count;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
index c2540292702d..5416093c0e35 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
@@ -295,17 +295,17 @@ static int mlxsw_sp_dpipe_erif_table_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 
-	return devlink_dpipe_table_register(devlink,
-					    MLXSW_SP_DPIPE_TABLE_NAME_ERIF,
-					    &mlxsw_sp_erif_ops,
-					    mlxsw_sp, false);
+	return devl_dpipe_table_register(devlink,
+					 MLXSW_SP_DPIPE_TABLE_NAME_ERIF,
+					 &mlxsw_sp_erif_ops,
+					 mlxsw_sp, false);
 }
 
 static void mlxsw_sp_dpipe_erif_table_fini(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 
-	devlink_dpipe_table_unregister(devlink, MLXSW_SP_DPIPE_TABLE_NAME_ERIF);
+	devl_dpipe_table_unregister(devlink, MLXSW_SP_DPIPE_TABLE_NAME_ERIF);
 }
 
 static int mlxsw_sp_dpipe_table_host_matches_dump(struct sk_buff *skb, int type)
@@ -749,25 +749,25 @@ static int mlxsw_sp_dpipe_host4_table_init(struct mlxsw_sp *mlxsw_sp)
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int err;
 
-	err = devlink_dpipe_table_register(devlink,
-					   MLXSW_SP_DPIPE_TABLE_NAME_HOST4,
-					   &mlxsw_sp_host4_ops,
-					   mlxsw_sp, false);
+	err = devl_dpipe_table_register(devlink,
+					MLXSW_SP_DPIPE_TABLE_NAME_HOST4,
+					&mlxsw_sp_host4_ops,
+					mlxsw_sp, false);
 	if (err)
 		return err;
 
-	err = devlink_dpipe_table_resource_set(devlink,
-					       MLXSW_SP_DPIPE_TABLE_NAME_HOST4,
-					       MLXSW_SP_RESOURCE_KVD_HASH_SINGLE,
-					       MLXSW_SP_DPIPE_TABLE_RESOURCE_UNIT_HOST4);
+	err = devl_dpipe_table_resource_set(devlink,
+					    MLXSW_SP_DPIPE_TABLE_NAME_HOST4,
+					    MLXSW_SP_RESOURCE_KVD_HASH_SINGLE,
+					    MLXSW_SP_DPIPE_TABLE_RESOURCE_UNIT_HOST4);
 	if (err)
 		goto err_resource_set;
 
 	return 0;
 
 err_resource_set:
-	devlink_dpipe_table_unregister(devlink,
-				       MLXSW_SP_DPIPE_TABLE_NAME_HOST4);
+	devl_dpipe_table_unregister(devlink,
+				    MLXSW_SP_DPIPE_TABLE_NAME_HOST4);
 	return err;
 }
 
@@ -775,8 +775,8 @@ static void mlxsw_sp_dpipe_host4_table_fini(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 
-	devlink_dpipe_table_unregister(devlink,
-				       MLXSW_SP_DPIPE_TABLE_NAME_HOST4);
+	devl_dpipe_table_unregister(devlink,
+				    MLXSW_SP_DPIPE_TABLE_NAME_HOST4);
 }
 
 static int
@@ -826,25 +826,25 @@ static int mlxsw_sp_dpipe_host6_table_init(struct mlxsw_sp *mlxsw_sp)
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int err;
 
-	err = devlink_dpipe_table_register(devlink,
-					   MLXSW_SP_DPIPE_TABLE_NAME_HOST6,
-					   &mlxsw_sp_host6_ops,
-					   mlxsw_sp, false);
+	err = devl_dpipe_table_register(devlink,
+					MLXSW_SP_DPIPE_TABLE_NAME_HOST6,
+					&mlxsw_sp_host6_ops,
+					mlxsw_sp, false);
 	if (err)
 		return err;
 
-	err = devlink_dpipe_table_resource_set(devlink,
-					       MLXSW_SP_DPIPE_TABLE_NAME_HOST6,
-					       MLXSW_SP_RESOURCE_KVD_HASH_DOUBLE,
-					       MLXSW_SP_DPIPE_TABLE_RESOURCE_UNIT_HOST6);
+	err = devl_dpipe_table_resource_set(devlink,
+					    MLXSW_SP_DPIPE_TABLE_NAME_HOST6,
+					    MLXSW_SP_RESOURCE_KVD_HASH_DOUBLE,
+					    MLXSW_SP_DPIPE_TABLE_RESOURCE_UNIT_HOST6);
 	if (err)
 		goto err_resource_set;
 
 	return 0;
 
 err_resource_set:
-	devlink_dpipe_table_unregister(devlink,
-				       MLXSW_SP_DPIPE_TABLE_NAME_HOST6);
+	devl_dpipe_table_unregister(devlink,
+				    MLXSW_SP_DPIPE_TABLE_NAME_HOST6);
 	return err;
 }
 
@@ -852,8 +852,8 @@ static void mlxsw_sp_dpipe_host6_table_fini(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 
-	devlink_dpipe_table_unregister(devlink,
-				       MLXSW_SP_DPIPE_TABLE_NAME_HOST6);
+	devl_dpipe_table_unregister(devlink,
+				    MLXSW_SP_DPIPE_TABLE_NAME_HOST6);
 }
 
 static int mlxsw_sp_dpipe_table_adj_matches_dump(void *priv,
@@ -1231,25 +1231,25 @@ static int mlxsw_sp_dpipe_adj_table_init(struct mlxsw_sp *mlxsw_sp)
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int err;
 
-	err = devlink_dpipe_table_register(devlink,
-					   MLXSW_SP_DPIPE_TABLE_NAME_ADJ,
-					   &mlxsw_sp_dpipe_table_adj_ops,
-					   mlxsw_sp, false);
+	err = devl_dpipe_table_register(devlink,
+					MLXSW_SP_DPIPE_TABLE_NAME_ADJ,
+					&mlxsw_sp_dpipe_table_adj_ops,
+					mlxsw_sp, false);
 	if (err)
 		return err;
 
-	err = devlink_dpipe_table_resource_set(devlink,
-					       MLXSW_SP_DPIPE_TABLE_NAME_ADJ,
-					       MLXSW_SP_RESOURCE_KVD_LINEAR,
-					       MLXSW_SP_DPIPE_TABLE_RESOURCE_UNIT_ADJ);
+	err = devl_dpipe_table_resource_set(devlink,
+					    MLXSW_SP_DPIPE_TABLE_NAME_ADJ,
+					    MLXSW_SP_RESOURCE_KVD_LINEAR,
+					    MLXSW_SP_DPIPE_TABLE_RESOURCE_UNIT_ADJ);
 	if (err)
 		goto err_resource_set;
 
 	return 0;
 
 err_resource_set:
-	devlink_dpipe_table_unregister(devlink,
-				       MLXSW_SP_DPIPE_TABLE_NAME_ADJ);
+	devl_dpipe_table_unregister(devlink,
+				    MLXSW_SP_DPIPE_TABLE_NAME_ADJ);
 	return err;
 }
 
@@ -1257,8 +1257,8 @@ static void mlxsw_sp_dpipe_adj_table_fini(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 
-	devlink_dpipe_table_unregister(devlink,
-				       MLXSW_SP_DPIPE_TABLE_NAME_ADJ);
+	devl_dpipe_table_unregister(devlink,
+				    MLXSW_SP_DPIPE_TABLE_NAME_ADJ);
 }
 
 int mlxsw_sp_dpipe_init(struct mlxsw_sp *mlxsw_sp)
@@ -1266,7 +1266,7 @@ int mlxsw_sp_dpipe_init(struct mlxsw_sp *mlxsw_sp)
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int err;
 
-	devlink_dpipe_headers_register(devlink, &mlxsw_sp_dpipe_headers);
+	devl_dpipe_headers_register(devlink, &mlxsw_sp_dpipe_headers);
 
 	err = mlxsw_sp_dpipe_erif_table_init(mlxsw_sp);
 	if (err)
@@ -1292,7 +1292,7 @@ int mlxsw_sp_dpipe_init(struct mlxsw_sp *mlxsw_sp)
 err_host4_table_init:
 	mlxsw_sp_dpipe_erif_table_fini(mlxsw_sp);
 err_erif_table_init:
-	devlink_dpipe_headers_unregister(priv_to_devlink(mlxsw_sp->core));
+	devl_dpipe_headers_unregister(priv_to_devlink(mlxsw_sp->core));
 	return err;
 }
 
@@ -1304,5 +1304,5 @@ void mlxsw_sp_dpipe_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp_dpipe_host6_table_fini(mlxsw_sp);
 	mlxsw_sp_dpipe_host4_table_fini(mlxsw_sp);
 	mlxsw_sp_dpipe_erif_table_fini(mlxsw_sp);
-	devlink_dpipe_headers_unregister(devlink);
+	devl_dpipe_headers_unregister(devlink);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c
index 39052e5c12fd..22ebb207ce4d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c
@@ -94,10 +94,10 @@ mlxsw_sp_policer_single_rate_family_init(struct mlxsw_sp_policer_family *family)
 
 	atomic_set(&family->policers_count, 0);
 	devlink = priv_to_devlink(core);
-	devlink_resource_occ_get_register(devlink,
-					  MLXSW_SP_RESOURCE_SINGLE_RATE_POLICERS,
-					  mlxsw_sp_policer_single_rate_occ_get,
-					  family);
+	devl_resource_occ_get_register(devlink,
+				       MLXSW_SP_RESOURCE_SINGLE_RATE_POLICERS,
+				       mlxsw_sp_policer_single_rate_occ_get,
+				       family);
 
 	return 0;
 }
@@ -107,8 +107,8 @@ mlxsw_sp_policer_single_rate_family_fini(struct mlxsw_sp_policer_family *family)
 {
 	struct devlink *devlink = priv_to_devlink(family->mlxsw_sp->core);
 
-	devlink_resource_occ_get_unregister(devlink,
-					    MLXSW_SP_RESOURCE_SINGLE_RATE_POLICERS);
+	devl_resource_occ_get_unregister(devlink,
+					 MLXSW_SP_RESOURCE_SINGLE_RATE_POLICERS);
 	WARN_ON(atomic_read(&family->policers_count) != 0);
 }
 
@@ -419,22 +419,22 @@ int mlxsw_sp_policer_resources_register(struct mlxsw_core *mlxsw_core)
 	devlink_resource_size_params_init(&size_params, global_policers,
 					  global_policers, 1,
 					  DEVLINK_RESOURCE_UNIT_ENTRY);
-	err = devlink_resource_register(devlink, "global_policers",
-					global_policers,
-					MLXSW_SP_RESOURCE_GLOBAL_POLICERS,
-					DEVLINK_RESOURCE_ID_PARENT_TOP,
-					&size_params);
+	err = devl_resource_register(devlink, "global_policers",
+				     global_policers,
+				     MLXSW_SP_RESOURCE_GLOBAL_POLICERS,
+				     DEVLINK_RESOURCE_ID_PARENT_TOP,
+				     &size_params);
 	if (err)
 		return err;
 
 	devlink_resource_size_params_init(&size_params, single_rate_policers,
 					  single_rate_policers, 1,
 					  DEVLINK_RESOURCE_UNIT_ENTRY);
-	err = devlink_resource_register(devlink, "single_rate_policers",
-					single_rate_policers,
-					MLXSW_SP_RESOURCE_SINGLE_RATE_POLICERS,
-					MLXSW_SP_RESOURCE_GLOBAL_POLICERS,
-					&size_params);
+	err = devl_resource_register(devlink, "single_rate_policers",
+				     single_rate_policers,
+				     MLXSW_SP_RESOURCE_SINGLE_RATE_POLICERS,
+				     MLXSW_SP_RESOURCE_GLOBAL_POLICERS,
+				     &size_params);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 09009e80cd71..23d526f13f1c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9962,14 +9962,14 @@ static int mlxsw_sp_rifs_init(struct mlxsw_sp *mlxsw_sp)
 	idr_init(&mlxsw_sp->router->rif_mac_profiles_idr);
 	atomic_set(&mlxsw_sp->router->rif_mac_profiles_count, 0);
 	atomic_set(&mlxsw_sp->router->rifs_count, 0);
-	devlink_resource_occ_get_register(devlink,
-					  MLXSW_SP_RESOURCE_RIF_MAC_PROFILES,
-					  mlxsw_sp_rif_mac_profiles_occ_get,
-					  mlxsw_sp);
-	devlink_resource_occ_get_register(devlink,
-					  MLXSW_SP_RESOURCE_RIFS,
-					  mlxsw_sp_rifs_occ_get,
-					  mlxsw_sp);
+	devl_resource_occ_get_register(devlink,
+				       MLXSW_SP_RESOURCE_RIF_MAC_PROFILES,
+				       mlxsw_sp_rif_mac_profiles_occ_get,
+				       mlxsw_sp);
+	devl_resource_occ_get_register(devlink,
+				       MLXSW_SP_RESOURCE_RIFS,
+				       mlxsw_sp_rifs_occ_get,
+				       mlxsw_sp);
 
 	return 0;
 }
@@ -9983,9 +9983,9 @@ static void mlxsw_sp_rifs_fini(struct mlxsw_sp *mlxsw_sp)
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++)
 		WARN_ON_ONCE(mlxsw_sp->router->rifs[i]);
 
-	devlink_resource_occ_get_unregister(devlink, MLXSW_SP_RESOURCE_RIFS);
-	devlink_resource_occ_get_unregister(devlink,
-					    MLXSW_SP_RESOURCE_RIF_MAC_PROFILES);
+	devl_resource_occ_get_unregister(devlink, MLXSW_SP_RESOURCE_RIFS);
+	devl_resource_occ_get_unregister(devlink,
+					 MLXSW_SP_RESOURCE_RIF_MAC_PROFILES);
 	WARN_ON(!idr_is_empty(&mlxsw_sp->router->rif_mac_profiles_idr));
 	idr_destroy(&mlxsw_sp->router->rif_mac_profiles_idr);
 	kfree(mlxsw_sp->router->rifs);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index fe663b0ab708..39904dacf4f0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -106,8 +106,8 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		goto err_init;
 
-	devlink_resource_occ_get_register(devlink, MLXSW_SP_RESOURCE_SPAN,
-					  mlxsw_sp_span_occ_get, mlxsw_sp);
+	devl_resource_occ_get_register(devlink, MLXSW_SP_RESOURCE_SPAN,
+				       mlxsw_sp_span_occ_get, mlxsw_sp);
 	INIT_WORK(&span->work, mlxsw_sp_span_respin_work);
 
 	return 0;
@@ -123,7 +123,7 @@ void mlxsw_sp_span_fini(struct mlxsw_sp *mlxsw_sp)
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 
 	cancel_work_sync(&mlxsw_sp->span->work);
-	devlink_resource_occ_get_unregister(devlink, MLXSW_SP_RESOURCE_SPAN);
+	devl_resource_occ_get_unregister(devlink, MLXSW_SP_RESOURCE_SPAN);
 
 	WARN_ON_ONCE(!list_empty(&mlxsw_sp->span->trigger_entries_list));
 	WARN_ON_ONCE(!list_empty(&mlxsw_sp->span->analyzed_ports_list));
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index d0baba38d2a3..f4bfdb6dab9c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -1298,8 +1298,8 @@ static int mlxsw_sp_trap_policers_init(struct mlxsw_sp *mlxsw_sp)
 
 	for (i = 0; i < trap->policers_count; i++) {
 		policer_item = &trap->policer_items_arr[i];
-		err = devlink_trap_policers_register(devlink,
-						     &policer_item->policer, 1);
+		err = devl_trap_policers_register(devlink,
+						  &policer_item->policer, 1);
 		if (err)
 			goto err_trap_policer_register;
 	}
@@ -1309,8 +1309,8 @@ static int mlxsw_sp_trap_policers_init(struct mlxsw_sp *mlxsw_sp)
 err_trap_policer_register:
 	for (i--; i >= 0; i--) {
 		policer_item = &trap->policer_items_arr[i];
-		devlink_trap_policers_unregister(devlink,
-						 &policer_item->policer, 1);
+		devl_trap_policers_unregister(devlink,
+					      &policer_item->policer, 1);
 	}
 	mlxsw_sp_trap_policer_items_arr_fini(mlxsw_sp);
 	return err;
@@ -1325,8 +1325,8 @@ static void mlxsw_sp_trap_policers_fini(struct mlxsw_sp *mlxsw_sp)
 
 	for (i = trap->policers_count - 1; i >= 0; i--) {
 		policer_item = &trap->policer_items_arr[i];
-		devlink_trap_policers_unregister(devlink,
-						 &policer_item->policer, 1);
+		devl_trap_policers_unregister(devlink,
+					      &policer_item->policer, 1);
 	}
 	mlxsw_sp_trap_policer_items_arr_fini(mlxsw_sp);
 }
@@ -1381,8 +1381,7 @@ static int mlxsw_sp_trap_groups_init(struct mlxsw_sp *mlxsw_sp)
 
 	for (i = 0; i < trap->groups_count; i++) {
 		group_item = &trap->group_items_arr[i];
-		err = devlink_trap_groups_register(devlink, &group_item->group,
-						   1);
+		err = devl_trap_groups_register(devlink, &group_item->group, 1);
 		if (err)
 			goto err_trap_group_register;
 	}
@@ -1392,7 +1391,7 @@ static int mlxsw_sp_trap_groups_init(struct mlxsw_sp *mlxsw_sp)
 err_trap_group_register:
 	for (i--; i >= 0; i--) {
 		group_item = &trap->group_items_arr[i];
-		devlink_trap_groups_unregister(devlink, &group_item->group, 1);
+		devl_trap_groups_unregister(devlink, &group_item->group, 1);
 	}
 	mlxsw_sp_trap_group_items_arr_fini(mlxsw_sp);
 	return err;
@@ -1408,7 +1407,7 @@ static void mlxsw_sp_trap_groups_fini(struct mlxsw_sp *mlxsw_sp)
 		const struct mlxsw_sp_trap_group_item *group_item;
 
 		group_item = &trap->group_items_arr[i];
-		devlink_trap_groups_unregister(devlink, &group_item->group, 1);
+		devl_trap_groups_unregister(devlink, &group_item->group, 1);
 	}
 	mlxsw_sp_trap_group_items_arr_fini(mlxsw_sp);
 }
@@ -1469,8 +1468,8 @@ static int mlxsw_sp_traps_init(struct mlxsw_sp *mlxsw_sp)
 
 	for (i = 0; i < trap->traps_count; i++) {
 		trap_item = &trap->trap_items_arr[i];
-		err = devlink_traps_register(devlink, &trap_item->trap, 1,
-					     mlxsw_sp);
+		err = devl_traps_register(devlink, &trap_item->trap, 1,
+					  mlxsw_sp);
 		if (err)
 			goto err_trap_register;
 	}
@@ -1480,7 +1479,7 @@ static int mlxsw_sp_traps_init(struct mlxsw_sp *mlxsw_sp)
 err_trap_register:
 	for (i--; i >= 0; i--) {
 		trap_item = &trap->trap_items_arr[i];
-		devlink_traps_unregister(devlink, &trap_item->trap, 1);
+		devl_traps_unregister(devlink, &trap_item->trap, 1);
 	}
 	mlxsw_sp_trap_items_arr_fini(mlxsw_sp);
 	return err;
@@ -1496,7 +1495,7 @@ static void mlxsw_sp_traps_fini(struct mlxsw_sp *mlxsw_sp)
 		const struct mlxsw_sp_trap_item *trap_item;
 
 		trap_item = &trap->trap_items_arr[i];
-		devlink_traps_unregister(devlink, &trap_item->trap, 1);
+		devl_traps_unregister(devlink, &trap_item->trap, 1);
 	}
 	mlxsw_sp_trap_items_arr_fini(mlxsw_sp);
 }
-- 
2.35.3


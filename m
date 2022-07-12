Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E52571800
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbiGLLFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbiGLLFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:05:33 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D714B027F
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:28 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ss3so7623859ejc.11
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6WLXTazJgSi39VuRxUqSF+cYCh0DnzI5a0QMhJdWZ2w=;
        b=fsabsUNb1cxfY8fAf6mcNfoLFe5EyKo1G4kLrZ6qoW7GWZyvvAVbgVsCj1tybLZOID
         1MEUhIdSXzA9PgMvWV+8MyDIS9cyJOwmiZVcNFAuKWfbJ32Xp3sLzSpLDP4sNJufk2lb
         2zumazubPqkhIhWOjJcbDMrg6eAaqVOV2oSlgfTTzffa2f7s/MHuw/7DgPOVNJE0qQGY
         jEZdubk/19Wh1Zesn2Gpu1SeEcFKK+QQoDCgoz0ULI7ScquwPkvKSvtUkrXWsXnLi+LD
         m+J89a9OSyl1011QUhUB/I5ezGlS+tPcmr1e4NO+S3cZ34FgYn3L82ouvf06xTWNHljW
         hGvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6WLXTazJgSi39VuRxUqSF+cYCh0DnzI5a0QMhJdWZ2w=;
        b=37QQH30qTuvf1retOlY6DtL/qaf4WlDGS+rKGiX5x74mwNvj7yq1Afzlx7DQh9Jq2O
         MpkZGza+TIF3YrF5kqu7mu1p95k1dBppyCwEa3mS+vJvU/iAs1w0sPmv3QFr+aiG+38x
         2jr82Yn17OqC85qx4I3gXnwu0AwpMfsjej0Or70Kl2Vuy7JdeePk3Gdh1W9nm20/kMKV
         xNFXJ/ZWAn7UM2JNHopTpwl4MGJh/52vuyKH2WHhbtD+6HMXg/TOkEbSSSMCvqrFF+sd
         HEFXATRTLJfgM8qdG/fANNr7dPh8jIWaO7vEaNrr0oDh/e5q8GXBsNjHUt9M50JbitNR
         hdfQ==
X-Gm-Message-State: AJIora9vWxABsmT9j7J2LoIaoT7AIPWounD2VDJ11XV02VNuWHl1S6um
        OyRQ3B0518/Qg7J2js08DODBj+V43liOGC5X9/s=
X-Google-Smtp-Source: AGRyM1swK4l9FBsk5C6tC8sBFvGVMveRZDxPjexNoTuCG037RRZ+zBhsrpFRebCvypzPc3D1kdNFrA==
X-Received: by 2002:a17:907:7ea6:b0:72b:4afb:e8b with SMTP id qb38-20020a1709077ea600b0072b4afb0e8bmr12568804ejc.205.1657623926826;
        Tue, 12 Jul 2022 04:05:26 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id bf14-20020a0564021a4e00b0043a78236cd2sm5858502edb.89.2022.07.12.04.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:05:26 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next RFC 09/10] netdevsim: convert driver to use unlocked devlink API during init/fini
Date:   Tue, 12 Jul 2022 13:05:10 +0200
Message-Id: <20220712110511.2834647-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712110511.2834647-1-jiri@resnulli.us>
References: <20220712110511.2834647-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Prepare for devlink reload being called with devlink->lock held and
convert the netdevsim driver to use unlocked devlink API during init and
fini flows. Take devl_lock() in reload_down() and reload_up() ops in the
meantime before reload cmd is converted to take the lock itself.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/bus.c       |  19 -----
 drivers/net/netdevsim/dev.c       | 134 ++++++++++++++----------------
 drivers/net/netdevsim/fib.c       |  62 +++++++-------
 drivers/net/netdevsim/netdevsim.h |   3 -
 include/net/devlink.h             |   1 +
 net/core/devlink.c                |   6 ++
 6 files changed, 102 insertions(+), 123 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 25cb2e600d53..b5f4df1a07a3 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -72,16 +72,7 @@ new_port_store(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		return ret;
 
-	if (!mutex_trylock(&nsim_bus_dev->nsim_bus_reload_lock))
-		return -EBUSY;
-
-	if (nsim_bus_dev->in_reload) {
-		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
-		return -EBUSY;
-	}
-
 	ret = nsim_drv_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
-	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
 }
 
@@ -102,16 +93,7 @@ del_port_store(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		return ret;
 
-	if (!mutex_trylock(&nsim_bus_dev->nsim_bus_reload_lock))
-		return -EBUSY;
-
-	if (nsim_bus_dev->in_reload) {
-		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
-		return -EBUSY;
-	}
-
 	ret = nsim_drv_port_del(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
-	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
 }
 
@@ -298,7 +280,6 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count, unsigned int num_queu
 	nsim_bus_dev->num_queues = num_queues;
 	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
 	nsim_bus_dev->max_vfs = NSIM_BUS_DEV_MAX_VFS;
-	mutex_init(&nsim_bus_dev->nsim_bus_reload_lock);
 	/* Disallow using nsim_bus_dev */
 	smp_store_release(&nsim_bus_dev->init, false);
 
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 57a3ac893792..f8f3c1da6c8a 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -436,62 +436,62 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 	int err;
 
 	/* Resources for IPv4 */
-	err = devlink_resource_register(devlink, "IPv4", (u64)-1,
-					NSIM_RESOURCE_IPV4,
-					DEVLINK_RESOURCE_ID_PARENT_TOP,
-					&params);
+	err = devl_resource_register(devlink, "IPv4", (u64)-1,
+				     NSIM_RESOURCE_IPV4,
+				     DEVLINK_RESOURCE_ID_PARENT_TOP,
+				     &params);
 	if (err) {
 		pr_err("Failed to register IPv4 top resource\n");
 		goto out;
 	}
 
-	err = devlink_resource_register(devlink, "fib", (u64)-1,
-					NSIM_RESOURCE_IPV4_FIB,
-					NSIM_RESOURCE_IPV4, &params);
+	err = devl_resource_register(devlink, "fib", (u64)-1,
+				     NSIM_RESOURCE_IPV4_FIB,
+				     NSIM_RESOURCE_IPV4, &params);
 	if (err) {
 		pr_err("Failed to register IPv4 FIB resource\n");
 		return err;
 	}
 
-	err = devlink_resource_register(devlink, "fib-rules", (u64)-1,
-					NSIM_RESOURCE_IPV4_FIB_RULES,
-					NSIM_RESOURCE_IPV4, &params);
+	err = devl_resource_register(devlink, "fib-rules", (u64)-1,
+				     NSIM_RESOURCE_IPV4_FIB_RULES,
+				     NSIM_RESOURCE_IPV4, &params);
 	if (err) {
 		pr_err("Failed to register IPv4 FIB rules resource\n");
 		return err;
 	}
 
 	/* Resources for IPv6 */
-	err = devlink_resource_register(devlink, "IPv6", (u64)-1,
-					NSIM_RESOURCE_IPV6,
-					DEVLINK_RESOURCE_ID_PARENT_TOP,
-					&params);
+	err = devl_resource_register(devlink, "IPv6", (u64)-1,
+				     NSIM_RESOURCE_IPV6,
+				     DEVLINK_RESOURCE_ID_PARENT_TOP,
+				     &params);
 	if (err) {
 		pr_err("Failed to register IPv6 top resource\n");
 		goto out;
 	}
 
-	err = devlink_resource_register(devlink, "fib", (u64)-1,
-					NSIM_RESOURCE_IPV6_FIB,
-					NSIM_RESOURCE_IPV6, &params);
+	err = devl_resource_register(devlink, "fib", (u64)-1,
+				     NSIM_RESOURCE_IPV6_FIB,
+				     NSIM_RESOURCE_IPV6, &params);
 	if (err) {
 		pr_err("Failed to register IPv6 FIB resource\n");
 		return err;
 	}
 
-	err = devlink_resource_register(devlink, "fib-rules", (u64)-1,
-					NSIM_RESOURCE_IPV6_FIB_RULES,
-					NSIM_RESOURCE_IPV6, &params);
+	err = devl_resource_register(devlink, "fib-rules", (u64)-1,
+				     NSIM_RESOURCE_IPV6_FIB_RULES,
+				     NSIM_RESOURCE_IPV6, &params);
 	if (err) {
 		pr_err("Failed to register IPv6 FIB rules resource\n");
 		return err;
 	}
 
 	/* Resources for nexthops */
-	err = devlink_resource_register(devlink, "nexthops", (u64)-1,
-					NSIM_RESOURCE_NEXTHOPS,
-					DEVLINK_RESOURCE_ID_PARENT_TOP,
-					&params);
+	err = devl_resource_register(devlink, "nexthops", (u64)-1,
+				     NSIM_RESOURCE_NEXTHOPS,
+				     DEVLINK_RESOURCE_ID_PARENT_TOP,
+				     &params);
 
 out:
 	return err;
@@ -557,15 +557,15 @@ static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
 				      struct devlink *devlink)
 {
 	nsim_dev->dummy_region =
-		devlink_region_create(devlink, &dummy_region_ops,
-				      NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
-				      NSIM_DEV_DUMMY_REGION_SIZE);
+		devl_region_create(devlink, &dummy_region_ops,
+				   NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
+				   NSIM_DEV_DUMMY_REGION_SIZE);
 	return PTR_ERR_OR_ZERO(nsim_dev->dummy_region);
 }
 
 static void nsim_dev_dummy_region_exit(struct nsim_dev *nsim_dev)
 {
-	devlink_region_destroy(nsim_dev->dummy_region);
+	devl_region_destroy(nsim_dev->dummy_region);
 }
 
 static int
@@ -832,7 +832,11 @@ static void nsim_dev_trap_report_work(struct work_struct *work)
 	/* For each running port and enabled packet trap, generate a UDP
 	 * packet with a random 5-tuple and report it.
 	 */
-	devl_lock(priv_to_devlink(nsim_dev));
+	if (!devl_trylock(priv_to_devlink(nsim_dev))) {
+		schedule_delayed_work(&nsim_dev->trap_data->trap_report_dw, 0);
+		return;
+	}
+
 	list_for_each_entry(nsim_dev_port, &nsim_dev->port_list, list) {
 		if (!netif_running(nsim_dev_port->ns->netdev))
 			continue;
@@ -880,18 +884,18 @@ static int nsim_dev_traps_init(struct devlink *devlink)
 	nsim_trap_data->nsim_dev = nsim_dev;
 	nsim_dev->trap_data = nsim_trap_data;
 
-	err = devlink_trap_policers_register(devlink, nsim_trap_policers_arr,
-					     policers_count);
+	err = devl_trap_policers_register(devlink, nsim_trap_policers_arr,
+					  policers_count);
 	if (err)
 		goto err_trap_policers_cnt_free;
 
-	err = devlink_trap_groups_register(devlink, nsim_trap_groups_arr,
-					   ARRAY_SIZE(nsim_trap_groups_arr));
+	err = devl_trap_groups_register(devlink, nsim_trap_groups_arr,
+					ARRAY_SIZE(nsim_trap_groups_arr));
 	if (err)
 		goto err_trap_policers_unregister;
 
-	err = devlink_traps_register(devlink, nsim_traps_arr,
-				     ARRAY_SIZE(nsim_traps_arr), NULL);
+	err = devl_traps_register(devlink, nsim_traps_arr,
+				  ARRAY_SIZE(nsim_traps_arr), NULL);
 	if (err)
 		goto err_trap_groups_unregister;
 
@@ -903,11 +907,11 @@ static int nsim_dev_traps_init(struct devlink *devlink)
 	return 0;
 
 err_trap_groups_unregister:
-	devlink_trap_groups_unregister(devlink, nsim_trap_groups_arr,
-				       ARRAY_SIZE(nsim_trap_groups_arr));
+	devl_trap_groups_unregister(devlink, nsim_trap_groups_arr,
+				    ARRAY_SIZE(nsim_trap_groups_arr));
 err_trap_policers_unregister:
-	devlink_trap_policers_unregister(devlink, nsim_trap_policers_arr,
-					 ARRAY_SIZE(nsim_trap_policers_arr));
+	devl_trap_policers_unregister(devlink, nsim_trap_policers_arr,
+				      ARRAY_SIZE(nsim_trap_policers_arr));
 err_trap_policers_cnt_free:
 	kfree(nsim_trap_data->trap_policers_cnt_arr);
 err_trap_items_free:
@@ -923,12 +927,12 @@ static void nsim_dev_traps_exit(struct devlink *devlink)
 
 	/* caution, trap work takes devlink lock */
 	cancel_delayed_work_sync(&nsim_dev->trap_data->trap_report_dw);
-	devlink_traps_unregister(devlink, nsim_traps_arr,
-				 ARRAY_SIZE(nsim_traps_arr));
-	devlink_trap_groups_unregister(devlink, nsim_trap_groups_arr,
-				       ARRAY_SIZE(nsim_trap_groups_arr));
-	devlink_trap_policers_unregister(devlink, nsim_trap_policers_arr,
-					 ARRAY_SIZE(nsim_trap_policers_arr));
+	devl_traps_unregister(devlink, nsim_traps_arr,
+			      ARRAY_SIZE(nsim_traps_arr));
+	devl_trap_groups_unregister(devlink, nsim_trap_groups_arr,
+				    ARRAY_SIZE(nsim_trap_groups_arr));
+	devl_trap_policers_unregister(devlink, nsim_trap_policers_arr,
+				      ARRAY_SIZE(nsim_trap_policers_arr));
 	kfree(nsim_dev->trap_data->trap_policers_cnt_arr);
 	kfree(nsim_dev->trap_data->trap_items_arr);
 	kfree(nsim_dev->trap_data);
@@ -943,24 +947,19 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
 				struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
-	struct nsim_bus_dev *nsim_bus_dev;
-
-	nsim_bus_dev = nsim_dev->nsim_bus_dev;
-	if (!mutex_trylock(&nsim_bus_dev->nsim_bus_reload_lock))
-		return -EOPNOTSUPP;
 
+	devl_lock(devlink);
 	if (nsim_dev->dont_allow_reload) {
 		/* For testing purposes, user set debugfs dont_allow_reload
 		 * value to true. So forbid it.
 		 */
 		NL_SET_ERR_MSG_MOD(extack, "User forbid the reload for testing purposes");
-		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
+		devl_unlock(devlink);
 		return -EOPNOTSUPP;
 	}
-	nsim_bus_dev->in_reload = true;
 
 	nsim_dev_reload_destroy(nsim_dev);
-	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
+	devl_unlock(devlink);
 	return 0;
 }
 
@@ -969,25 +968,21 @@ static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_actio
 			      struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
-	struct nsim_bus_dev *nsim_bus_dev;
 	int ret;
 
-	nsim_bus_dev = nsim_dev->nsim_bus_dev;
-	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
-	nsim_bus_dev->in_reload = false;
-
+	devl_lock(devlink);
 	if (nsim_dev->fail_reload) {
 		/* For testing purposes, user set debugfs fail_reload
 		 * value to true. Fail right away.
 		 */
 		NL_SET_ERR_MSG_MOD(extack, "User setup the reload to fail for testing purposes");
-		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
+		devl_unlock(devlink);
 		return -EINVAL;
 	}
 
 	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
 	ret = nsim_dev_reload_create(nsim_dev, extack);
-	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
+	devl_unlock(devlink);
 	return ret;
 }
 
@@ -1434,11 +1429,9 @@ static void nsim_dev_port_del_all(struct nsim_dev *nsim_dev)
 {
 	struct nsim_dev_port *nsim_dev_port, *tmp;
 
-	devl_lock(priv_to_devlink(nsim_dev));
 	list_for_each_entry_safe(nsim_dev_port, tmp,
 				 &nsim_dev->port_list, list)
 		__nsim_dev_port_del(nsim_dev_port);
-	devl_unlock(priv_to_devlink(nsim_dev));
 }
 
 static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
@@ -1447,9 +1440,7 @@ static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
 	int i, err;
 
 	for (i = 0; i < port_count; i++) {
-		devl_lock(priv_to_devlink(nsim_dev));
 		err = __nsim_dev_port_add(nsim_dev, NSIM_DEV_PORT_TYPE_PF, i);
-		devl_unlock(priv_to_devlink(nsim_dev));
 		if (err)
 			goto err_port_del_all;
 	}
@@ -1537,6 +1528,7 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 				 nsim_bus_dev->initial_net, &nsim_bus_dev->dev);
 	if (!devlink)
 		return -ENOMEM;
+	devl_lock(devlink);
 	nsim_dev = devlink_priv(devlink);
 	nsim_dev->nsim_bus_dev = nsim_bus_dev;
 	nsim_dev->switch_id.id_len = sizeof(nsim_dev->switch_id.id);
@@ -1555,7 +1547,7 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 				      GFP_KERNEL | __GFP_NOWARN);
 	if (!nsim_dev->vfconfigs) {
 		err = -ENOMEM;
-		goto err_devlink_free;
+		goto err_devlink_unlock;
 	}
 
 	err = nsim_dev_resources_register(devlink);
@@ -1609,6 +1601,7 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
+	devl_unlock(devlink);
 	return 0;
 
 err_hwstats_exit:
@@ -1631,10 +1624,11 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
 err_dl_unregister:
-	devlink_resources_unregister(devlink);
+	devl_resources_unregister(devlink);
 err_vfc_free:
 	kfree(nsim_dev->vfconfigs);
-err_devlink_free:
+err_devlink_unlock:
+	devl_unlock(devlink);
 	devlink_free(devlink);
 	dev_set_drvdata(&nsim_bus_dev->dev, NULL);
 	return err;
@@ -1648,13 +1642,11 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 		return;
 	debugfs_remove(nsim_dev->take_snapshot);
 
-	devl_lock(devlink);
 	if (nsim_dev_get_vfs(nsim_dev)) {
 		nsim_bus_dev_set_vfs(nsim_dev->nsim_bus_dev, 0);
 		if (nsim_esw_mode_is_switchdev(nsim_dev))
 			nsim_esw_legacy_enable(nsim_dev, NULL);
 	}
-	devl_unlock(devlink);
 
 	nsim_dev_port_del_all(nsim_dev);
 	nsim_dev_hwstats_exit(nsim_dev);
@@ -1670,6 +1662,7 @@ void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
+	devl_lock(devlink);
 	devlink_unregister(devlink);
 	nsim_dev_reload_destroy(nsim_dev);
 
@@ -1677,8 +1670,9 @@ void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev_debugfs_exit(nsim_dev);
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
-	devlink_resources_unregister(devlink);
+	devl_resources_unregister(devlink);
 	kfree(nsim_dev->vfconfigs);
+	devl_unlock(devlink);
 	devlink_free(devlink);
 	dev_set_drvdata(&nsim_bus_dev->dev, NULL);
 }
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index c8f398f5bc5b..94e7512bef94 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -1453,7 +1453,7 @@ static void nsim_fib_set_max_all(struct nsim_fib_data *data,
 		int err;
 		u64 val;
 
-		err = devlink_resource_size_get(devlink, res_ids[i], &val);
+		err = devl_resource_size_get(devlink, res_ids[i], &val);
 		if (err)
 			val = (u64) -1;
 		nsim_fib_set_max(data, res_ids[i], val);
@@ -1562,26 +1562,26 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 		goto err_nexthop_nb_unregister;
 	}
 
-	devlink_resource_occ_get_register(devlink,
-					  NSIM_RESOURCE_IPV4_FIB,
-					  nsim_fib_ipv4_resource_occ_get,
-					  data);
-	devlink_resource_occ_get_register(devlink,
-					  NSIM_RESOURCE_IPV4_FIB_RULES,
-					  nsim_fib_ipv4_rules_res_occ_get,
-					  data);
-	devlink_resource_occ_get_register(devlink,
-					  NSIM_RESOURCE_IPV6_FIB,
-					  nsim_fib_ipv6_resource_occ_get,
-					  data);
-	devlink_resource_occ_get_register(devlink,
-					  NSIM_RESOURCE_IPV6_FIB_RULES,
-					  nsim_fib_ipv6_rules_res_occ_get,
-					  data);
-	devlink_resource_occ_get_register(devlink,
-					  NSIM_RESOURCE_NEXTHOPS,
-					  nsim_fib_nexthops_res_occ_get,
-					  data);
+	devl_resource_occ_get_register(devlink,
+				       NSIM_RESOURCE_IPV4_FIB,
+				       nsim_fib_ipv4_resource_occ_get,
+				       data);
+	devl_resource_occ_get_register(devlink,
+				       NSIM_RESOURCE_IPV4_FIB_RULES,
+				       nsim_fib_ipv4_rules_res_occ_get,
+				       data);
+	devl_resource_occ_get_register(devlink,
+				       NSIM_RESOURCE_IPV6_FIB,
+				       nsim_fib_ipv6_resource_occ_get,
+				       data);
+	devl_resource_occ_get_register(devlink,
+				       NSIM_RESOURCE_IPV6_FIB_RULES,
+				       nsim_fib_ipv6_rules_res_occ_get,
+				       data);
+	devl_resource_occ_get_register(devlink,
+				       NSIM_RESOURCE_NEXTHOPS,
+				       nsim_fib_nexthops_res_occ_get,
+				       data);
 	return data;
 
 err_nexthop_nb_unregister:
@@ -1604,16 +1604,16 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 
 void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data)
 {
-	devlink_resource_occ_get_unregister(devlink,
-					    NSIM_RESOURCE_NEXTHOPS);
-	devlink_resource_occ_get_unregister(devlink,
-					    NSIM_RESOURCE_IPV6_FIB_RULES);
-	devlink_resource_occ_get_unregister(devlink,
-					    NSIM_RESOURCE_IPV6_FIB);
-	devlink_resource_occ_get_unregister(devlink,
-					    NSIM_RESOURCE_IPV4_FIB_RULES);
-	devlink_resource_occ_get_unregister(devlink,
-					    NSIM_RESOURCE_IPV4_FIB);
+	devl_resource_occ_get_unregister(devlink,
+					 NSIM_RESOURCE_NEXTHOPS);
+	devl_resource_occ_get_unregister(devlink,
+					 NSIM_RESOURCE_IPV6_FIB_RULES);
+	devl_resource_occ_get_unregister(devlink,
+					 NSIM_RESOURCE_IPV6_FIB);
+	devl_resource_occ_get_unregister(devlink,
+					 NSIM_RESOURCE_IPV4_FIB_RULES);
+	devl_resource_occ_get_unregister(devlink,
+					 NSIM_RESOURCE_IPV4_FIB);
 	unregister_fib_notifier(devlink_net(devlink), &data->fib_nb);
 	unregister_nexthop_notifier(devlink_net(devlink), &data->nexthop_nb);
 	flush_work(&data->fib_event_work);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 0b122872b2c9..7d8ed8d8df5c 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -376,9 +376,6 @@ struct nsim_bus_dev {
 				  */
 	unsigned int max_vfs;
 	unsigned int num_vfs;
-	/* Lock for devlink->reload_enabled in netdevsim module */
-	struct mutex nsim_bus_reload_lock;
-	bool in_reload;
 	bool init;
 };
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 391d401ddb55..242798967a44 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1517,6 +1517,7 @@ struct device *devlink_to_dev(const struct devlink *devlink);
 
 /* Devlink instance explicit locking */
 void devl_lock(struct devlink *devlink);
+int devl_trylock(struct devlink *devlink);
 void devl_unlock(struct devlink *devlink);
 void devl_assert_locked(struct devlink *devlink);
 bool devl_lock_is_held(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 04d04e01712b..7cf4fa2daabd 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -266,6 +266,12 @@ void devl_lock(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devl_lock);
 
+int devl_trylock(struct devlink *devlink)
+{
+	return mutex_trylock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devl_trylock);
+
 void devl_unlock(struct devlink *devlink)
 {
 	mutex_unlock(&devlink->lock);
-- 
2.35.3


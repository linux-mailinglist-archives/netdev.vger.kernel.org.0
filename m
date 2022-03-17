Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E35E4DBDE1
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 05:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiCQE4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 00:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiCQE4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 00:56:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788C8208C1B
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 21:37:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 107B9B81E14
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 04:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C18BC340EF;
        Thu, 17 Mar 2022 04:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647490841;
        bh=D4HuD25bD+Xe928gku5HlWmF13QrlfcdIB7nG5TaOK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hohrqZ8pFOjR8aUTpDYXjiuS0MyhyEQCTKfVAUenshabJ7WTD5ghAJ5SO5bbT4upq
         /m+Sw1GNQdq8Exst94JS+qLHC+19DwhxwhCBbzoxyfNwsveAW1ZSL9XLhKJwsrMgcR
         OIFlI5jGJoMl0nlig+wfCnybgmTdUlKV02lIRRHaVqGfvZe34epipMnctXu21/V0nx
         kODERNQGpGRZLjfGiYmWeltaY8ZLb8NJiFXEXQBuIdLIiyAA3p+buLRoyXDlKbP7Qi
         9O8wpuVxMRz08ynT2sO82DI+NIbWXRDisF4yRg4VrmYi5HxMHFnyLr+t2Flm2OUNff
         zybG8r7srUUUw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, leonro@nvidia.com,
        saeedm@nvidia.com, idosch@idosch.org, michael.chan@broadcom.com,
        simon.horman@corigine.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/5] netdevsim: replace port_list_lock with devlink instance lock
Date:   Wed, 16 Mar 2022 21:20:21 -0700
Message-Id: <20220317042023.1470039-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220317042023.1470039-1-kuba@kernel.org>
References: <20220317042023.1470039-1-kuba@kernel.org>
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

Take advantage of the devlink instance lock for protecting
the port list. This will simplify locking even more once
all devlink callbacks hold the instance lock.

We need to add locking in nsim_dev_port_add_all() which used
to assume higher layer protection when accessing the list.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/dev.c       | 40 +++++++++++++++----------------
 drivers/net/netdevsim/netdevsim.h |  1 -
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index dbc8e88d2841..dd650d4301e5 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -576,11 +576,11 @@ static int nsim_esw_legacy_enable(struct nsim_dev *nsim_dev,
 	struct nsim_dev_port *nsim_dev_port, *tmp;
 
 	devlink_rate_nodes_destroy(devlink);
-	mutex_lock(&nsim_dev->port_list_lock);
+	devl_lock(devlink);
 	list_for_each_entry_safe(nsim_dev_port, tmp, &nsim_dev->port_list, list)
 		if (nsim_dev_port_is_vf(nsim_dev_port))
 			__nsim_dev_port_del(nsim_dev_port);
-	mutex_unlock(&nsim_dev->port_list_lock);
+	devl_unlock(devlink);
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 	return 0;
 }
@@ -835,14 +835,14 @@ static void nsim_dev_trap_report_work(struct work_struct *work)
 	/* For each running port and enabled packet trap, generate a UDP
 	 * packet with a random 5-tuple and report it.
 	 */
-	mutex_lock(&nsim_dev->port_list_lock);
+	devl_lock(priv_to_devlink(nsim_dev));
 	list_for_each_entry(nsim_dev_port, &nsim_dev->port_list, list) {
 		if (!netif_running(nsim_dev_port->ns->netdev))
 			continue;
 
 		nsim_dev_trap_report(nsim_dev_port);
 	}
-	mutex_unlock(&nsim_dev->port_list_lock);
+	devl_unlock(priv_to_devlink(nsim_dev));
 
 	schedule_delayed_work(&nsim_dev->trap_data->trap_report_dw,
 			      msecs_to_jiffies(NSIM_TRAP_REPORT_INTERVAL_MS));
@@ -924,6 +924,7 @@ static void nsim_dev_traps_exit(struct devlink *devlink)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 
+	/* caution, trap work takes devlink lock */
 	cancel_delayed_work_sync(&nsim_dev->trap_data->trap_report_dw);
 	devlink_traps_unregister(devlink, nsim_traps_arr,
 				 ARRAY_SIZE(nsim_traps_arr));
@@ -1380,8 +1381,8 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 	memcpy(attrs.switch_id.id, nsim_dev->switch_id.id, nsim_dev->switch_id.id_len);
 	attrs.switch_id.id_len = nsim_dev->switch_id.id_len;
 	devlink_port_attrs_set(devlink_port, &attrs);
-	err = devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
-				    nsim_dev_port->port_index);
+	err = devl_port_register(priv_to_devlink(nsim_dev), devlink_port,
+				 nsim_dev_port->port_index);
 	if (err)
 		goto err_port_free;
 
@@ -1396,8 +1397,8 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 	}
 
 	if (nsim_dev_port_is_vf(nsim_dev_port)) {
-		err = devlink_rate_leaf_create(&nsim_dev_port->devlink_port,
-					       nsim_dev_port);
+		err = devl_rate_leaf_create(&nsim_dev_port->devlink_port,
+					    nsim_dev_port);
 		if (err)
 			goto err_nsim_destroy;
 	}
@@ -1412,7 +1413,7 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 err_port_debugfs_exit:
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
 err_dl_port_unregister:
-	devlink_port_unregister(devlink_port);
+	devl_port_unregister(devlink_port);
 err_port_free:
 	kfree(nsim_dev_port);
 	return err;
@@ -1424,11 +1425,11 @@ static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port)
 
 	list_del(&nsim_dev_port->list);
 	if (nsim_dev_port_is_vf(nsim_dev_port))
-		devlink_rate_leaf_destroy(&nsim_dev_port->devlink_port);
+		devl_rate_leaf_destroy(&nsim_dev_port->devlink_port);
 	devlink_port_type_clear(devlink_port);
 	nsim_destroy(nsim_dev_port->ns);
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
-	devlink_port_unregister(devlink_port);
+	devl_port_unregister(devlink_port);
 	kfree(nsim_dev_port);
 }
 
@@ -1436,11 +1437,11 @@ static void nsim_dev_port_del_all(struct nsim_dev *nsim_dev)
 {
 	struct nsim_dev_port *nsim_dev_port, *tmp;
 
-	mutex_lock(&nsim_dev->port_list_lock);
+	devl_lock(priv_to_devlink(nsim_dev));
 	list_for_each_entry_safe(nsim_dev_port, tmp,
 				 &nsim_dev->port_list, list)
 		__nsim_dev_port_del(nsim_dev_port);
-	mutex_unlock(&nsim_dev->port_list_lock);
+	devl_unlock(priv_to_devlink(nsim_dev));
 }
 
 static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
@@ -1449,7 +1450,9 @@ static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
 	int i, err;
 
 	for (i = 0; i < port_count; i++) {
+		devl_lock(priv_to_devlink(nsim_dev));
 		err = __nsim_dev_port_add(nsim_dev, NSIM_DEV_PORT_TYPE_PF, i);
+		devl_unlock(priv_to_devlink(nsim_dev));
 		if (err)
 			goto err_port_del_all;
 	}
@@ -1470,7 +1473,6 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	devlink = priv_to_devlink(nsim_dev);
 	nsim_dev = devlink_priv(devlink);
 	INIT_LIST_HEAD(&nsim_dev->port_list);
-	mutex_init(&nsim_dev->port_list_lock);
 	nsim_dev->fw_update_status = true;
 	nsim_dev->fw_update_overwrite_mask = 0;
 
@@ -1544,7 +1546,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	get_random_bytes(nsim_dev->switch_id.id, nsim_dev->switch_id.id_len);
 	INIT_LIST_HEAD(&nsim_dev->port_list);
 	mutex_init(&nsim_dev->vfs_lock);
-	mutex_init(&nsim_dev->port_list_lock);
 	nsim_dev->fw_update_status = true;
 	nsim_dev->fw_update_overwrite_mask = 0;
 	nsim_dev->max_macs = NSIM_DEV_MAX_MACS_DEFAULT;
@@ -1666,7 +1667,6 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 	nsim_dev_traps_exit(devlink);
 	nsim_dev_dummy_region_exit(nsim_dev);
-	mutex_destroy(&nsim_dev->port_list_lock);
 }
 
 void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
@@ -1706,12 +1706,12 @@ int nsim_drv_port_add(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	int err;
 
-	mutex_lock(&nsim_dev->port_list_lock);
+	devl_lock(priv_to_devlink(nsim_dev));
 	if (__nsim_dev_port_lookup(nsim_dev, type, port_index))
 		err = -EEXIST;
 	else
 		err = __nsim_dev_port_add(nsim_dev, type, port_index);
-	mutex_unlock(&nsim_dev->port_list_lock);
+	devl_unlock(priv_to_devlink(nsim_dev));
 	return err;
 }
 
@@ -1722,13 +1722,13 @@ int nsim_drv_port_del(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type
 	struct nsim_dev_port *nsim_dev_port;
 	int err = 0;
 
-	mutex_lock(&nsim_dev->port_list_lock);
+	devl_lock(priv_to_devlink(nsim_dev));
 	nsim_dev_port = __nsim_dev_port_lookup(nsim_dev, type, port_index);
 	if (!nsim_dev_port)
 		err = -ENOENT;
 	else
 		__nsim_dev_port_del(nsim_dev_port);
-	mutex_unlock(&nsim_dev->port_list_lock);
+	devl_unlock(priv_to_devlink(nsim_dev));
 	return err;
 }
 
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 128f229d9b4d..8dd6f975f32d 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -274,7 +274,6 @@ struct nsim_dev {
 	struct list_head bpf_bound_maps;
 	struct netdev_phys_item_id switch_id;
 	struct list_head port_list;
-	struct mutex port_list_lock; /* protects port list */
 	bool fw_update_status;
 	u32 fw_update_overwrite_mask;
 	u32 max_macs;
-- 
2.34.1


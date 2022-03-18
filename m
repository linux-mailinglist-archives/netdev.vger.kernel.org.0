Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80274DE1BD
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 20:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240359AbiCRTZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 15:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240351AbiCRTZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 15:25:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25EE30CABE
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 12:23:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16F13B8253D
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 19:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71996C340F3;
        Fri, 18 Mar 2022 19:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647631434;
        bh=L4BNn/juTpfoigW92ZhNR9n7taT0oLp4iMb6+Vbe5e4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d01XjuzG+X5ACj90p2MR5amrd4CQcyFMQLOYMRKUAnhu4DfmoS7fCMuEIndEdWpmi
         DrsYi4GNDQzm9/S/sgSQbKNPgvOUZyZ8yJFadYHKSB/3xB13g2Gf8BHcH2m6a1/NEw
         cB/zR3DB8cmJ/q+PbQYoZuRjgjVPzKGilxYmqtR3OUxmAkXepFa3wa4dGdSTBggENP
         GlhbB0pyQFYr+KCWIrIrJE0uCTGtTqZF6sFZKZuKM10mgjpFGL9y/VBBN8EhZigBTc
         JJ00lp6dextSNRK6EWRcVYmARNagNUCIyi1UfiNjAhXJRsmUySiPNZtXRKm8BzRS/2
         FFNwIWrNimp/Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, leonro@nvidia.com,
        saeedm@nvidia.com, idosch@idosch.org, michael.chan@broadcom.com,
        simon.horman@corigine.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 4/5] netdevsim: replace vfs_lock with devlink instance lock
Date:   Fri, 18 Mar 2022 12:23:43 -0700
Message-Id: <20220318192344.1587891-5-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220318192344.1587891-1-kuba@kernel.org>
References: <20220318192344.1587891-1-kuba@kernel.org>
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

Similarly to the previous commit, use the devlink instance
lock and let it replace the vfs_lock.

nsim_esw_legacy_enable() was locked by both port lock and
vfs lock so one set of lock/unlocks goes away.

netdevsim's .eswitch_mode_set callback is now ready for
the callback to take the instance lock.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/dev.c       | 37 +++++++++++++++++--------------
 drivers/net/netdevsim/netdevsim.h |  1 -
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index dd650d4301e5..68cd1defe990 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -59,7 +59,7 @@ static struct dentry *nsim_dev_ddir;
 unsigned int nsim_dev_get_vfs(struct nsim_dev *nsim_dev)
 {
 	WARN_ON(!lockdep_rtnl_is_held() &&
-		!lockdep_is_held(&nsim_dev->vfs_lock));
+		!devl_lock_is_held(priv_to_devlink(nsim_dev)));
 
 	return nsim_dev->nsim_bus_dev->num_vfs;
 }
@@ -275,7 +275,7 @@ static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 		return -ENOMEM;
 
 	nsim_dev = file->private_data;
-	mutex_lock(&nsim_dev->vfs_lock);
+	devl_lock(priv_to_devlink(nsim_dev));
 	/* Reject if VFs are configured */
 	if (nsim_dev_get_vfs(nsim_dev)) {
 		ret = -EBUSY;
@@ -285,7 +285,7 @@ static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 		*ppos += count;
 		ret = count;
 	}
-	mutex_unlock(&nsim_dev->vfs_lock);
+	devl_unlock(priv_to_devlink(nsim_dev));
 
 	kfree(vfconfigs);
 	return ret;
@@ -339,6 +339,7 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	debugfs_create_bool("fail_trap_policer_counter_get", 0600,
 			    nsim_dev->ddir,
 			    &nsim_dev->fail_trap_policer_counter_get);
+	/* caution, dev_max_vfs write takes devlink lock */
 	debugfs_create_file("max_vfs", 0600, nsim_dev->ddir,
 			    nsim_dev, &nsim_dev_max_vfs_fops);
 
@@ -567,6 +568,9 @@ static void nsim_dev_dummy_region_exit(struct nsim_dev *nsim_dev)
 	devlink_region_destroy(nsim_dev->dummy_region);
 }
 
+static int
+__nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_type type,
+		    unsigned int port_index);
 static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port);
 
 static int nsim_esw_legacy_enable(struct nsim_dev *nsim_dev,
@@ -575,12 +579,10 @@ static int nsim_esw_legacy_enable(struct nsim_dev *nsim_dev,
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 	struct nsim_dev_port *nsim_dev_port, *tmp;
 
-	devlink_rate_nodes_destroy(devlink);
-	devl_lock(devlink);
+	devl_rate_nodes_destroy(devlink);
 	list_for_each_entry_safe(nsim_dev_port, tmp, &nsim_dev->port_list, list)
 		if (nsim_dev_port_is_vf(nsim_dev_port))
 			__nsim_dev_port_del(nsim_dev_port);
-	devl_unlock(devlink);
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 	return 0;
 }
@@ -588,11 +590,11 @@ static int nsim_esw_legacy_enable(struct nsim_dev *nsim_dev,
 static int nsim_esw_switchdev_enable(struct nsim_dev *nsim_dev,
 				     struct netlink_ext_ack *extack)
 {
-	struct nsim_bus_dev *nsim_bus_dev = nsim_dev->nsim_bus_dev;
+	struct nsim_dev_port *nsim_dev_port, *tmp;
 	int i, err;
 
 	for (i = 0; i < nsim_dev_get_vfs(nsim_dev); i++) {
-		err = nsim_drv_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_VF, i);
+		err = __nsim_dev_port_add(nsim_dev, NSIM_DEV_PORT_TYPE_VF, i);
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack, "Failed to initialize VFs' netdevsim ports");
 			pr_err("Failed to initialize VF id=%d. %d.\n", i, err);
@@ -603,8 +605,9 @@ static int nsim_esw_switchdev_enable(struct nsim_dev *nsim_dev,
 	return 0;
 
 err_port_add_vfs:
-	for (i--; i >= 0; i--)
-		nsim_drv_port_del(nsim_bus_dev, NSIM_DEV_PORT_TYPE_VF, i);
+	list_for_each_entry_safe(nsim_dev_port, tmp, &nsim_dev->port_list, list)
+		if (nsim_dev_port_is_vf(nsim_dev_port))
+			__nsim_dev_port_del(nsim_dev_port);
 	return err;
 }
 
@@ -614,7 +617,7 @@ static int nsim_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 	int err = 0;
 
-	mutex_lock(&nsim_dev->vfs_lock);
+	devl_lock(devlink);
 	if (mode == nsim_dev->esw_mode)
 		goto unlock;
 
@@ -626,7 +629,7 @@ static int nsim_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		err = -EINVAL;
 
 unlock:
-	mutex_unlock(&nsim_dev->vfs_lock);
+	devl_unlock(devlink);
 	return err;
 }
 
@@ -1545,7 +1548,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev->switch_id.id_len = sizeof(nsim_dev->switch_id.id);
 	get_random_bytes(nsim_dev->switch_id.id, nsim_dev->switch_id.id_len);
 	INIT_LIST_HEAD(&nsim_dev->port_list);
-	mutex_init(&nsim_dev->vfs_lock);
 	nsim_dev->fw_update_status = true;
 	nsim_dev->fw_update_overwrite_mask = 0;
 	nsim_dev->max_macs = NSIM_DEV_MAX_MACS_DEFAULT;
@@ -1652,13 +1654,13 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 		return;
 	debugfs_remove(nsim_dev->take_snapshot);
 
-	mutex_lock(&nsim_dev->vfs_lock);
+	devl_lock(devlink);
 	if (nsim_dev_get_vfs(nsim_dev)) {
 		nsim_bus_dev_set_vfs(nsim_dev->nsim_bus_dev, 0);
 		if (nsim_esw_mode_is_switchdev(nsim_dev))
 			nsim_esw_legacy_enable(nsim_dev, NULL);
 	}
-	mutex_unlock(&nsim_dev->vfs_lock);
+	devl_unlock(devlink);
 
 	nsim_dev_port_del_all(nsim_dev);
 	nsim_dev_hwstats_exit(nsim_dev);
@@ -1736,9 +1738,10 @@ int nsim_drv_configure_vfs(struct nsim_bus_dev *nsim_bus_dev,
 			   unsigned int num_vfs)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
+	struct devlink *devlink = priv_to_devlink(nsim_dev);
 	int ret = 0;
 
-	mutex_lock(&nsim_dev->vfs_lock);
+	devl_lock(devlink);
 	if (nsim_bus_dev->num_vfs == num_vfs)
 		goto exit_unlock;
 	if (nsim_bus_dev->num_vfs && num_vfs) {
@@ -1764,7 +1767,7 @@ int nsim_drv_configure_vfs(struct nsim_bus_dev *nsim_bus_dev,
 	}
 
 exit_unlock:
-	mutex_unlock(&nsim_dev->vfs_lock);
+	devl_unlock(devlink);
 
 	return ret;
 }
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 8dd6f975f32d..0b122872b2c9 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -261,7 +261,6 @@ struct nsim_dev {
 	struct dentry *take_snapshot;
 	struct dentry *nodes_ddir;
 
-	struct mutex vfs_lock;  /* Protects vfconfigs */
 	struct nsim_vf_config *vfconfigs;
 
 	struct bpf_offload_dev *bpf_dev;
-- 
2.34.1


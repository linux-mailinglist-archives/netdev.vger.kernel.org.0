Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0F7440C46
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 01:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhJ3XPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 19:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232035AbhJ3XPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 19:15:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02AE360FC4;
        Sat, 30 Oct 2021 23:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635635580;
        bh=rWVmf1dtMOj+UvTXZOWoJMbcnmEyxVhw6sxG7zsf1cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VK6WaXAr9itc8er492kFzN3LYpqeLi/3TWGh7MJ7mVvHa0lBQuXpr4bzIcJxfqhpd
         0ShHVfX68k96MHLJTZxnxS6Tt6R11v56kCH4Cca1dC5tvTNwytJ2r+WvYTanue970k
         pJTy7tRimgvcapDIR9sETbMxc499pk8jayktFEOTC38x3TMUmbmEha7htYV2ocOO7Q
         bEGlpTAXFAhBcO6C3xn+78Uw+F4WBeRk57ENKHFPmRy8BcMaax3vgmB7LLy/vHE//w
         o6oWA3AVdmhmWDYj9dy92zaLfYR9CKTAImvkC+1TB/VT9m9KOAQJATHCes1RLMClTV
         iQ5pT4qWRJPKw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     leon@kernel.org, idosch@idosch.org
Cc:     edwin.peer@broadcom.com, jiri@resnulli.us, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC 5/5] netdevsim: use devlink locking
Date:   Sat, 30 Oct 2021 16:12:54 -0700
Message-Id: <20211030231254.2477599-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030231254.2477599-1-kuba@kernel.org>
References: <20211030231254.2477599-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can remove all 3 mutexes and use devlink lock
instead.

For trap delayed work we need to take a ref on
the devlink instance and check if the instance
is still active.

Similar thing for the debugfs handlers which
need locking.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/bus.c       |  19 --
 drivers/net/netdevsim/dev.c       | 400 +++++++++++++++++-------------
 drivers/net/netdevsim/fib.c       |  62 ++---
 drivers/net/netdevsim/netdevsim.h |   5 -
 4 files changed, 263 insertions(+), 223 deletions(-)

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
index b15763a8e89a..3255498cadbf 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -58,8 +58,9 @@ static struct dentry *nsim_dev_ddir;
 
 unsigned int nsim_dev_get_vfs(struct nsim_dev *nsim_dev)
 {
-	WARN_ON(!lockdep_rtnl_is_held() &&
-		!lockdep_is_held(&nsim_dev->vfs_lock));
+	struct devlink *devlink = priv_to_devlink(nsim_dev);
+
+	WARN_ON(!lockdep_rtnl_is_held() && !lockdep_devlink_is_held(devlink));
 
 	return nsim_dev->nsim_bus_dev->num_vfs;
 }
@@ -74,6 +75,28 @@ nsim_bus_dev_set_vfs(struct nsim_bus_dev *nsim_bus_dev, unsigned int num_vfs)
 
 #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
 
+static int nsim_devlink_ref_open(struct inode *inode, struct file *file)
+{
+	struct nsim_dev *nsim_dev = inode->i_private;
+	struct devlink *devlink = priv_to_devlink(nsim_dev);
+
+	/* debugfs promises us that open does not race with file removal,
+	 * so if we're here the driver is still holding its main ref.
+	 */
+	devlink_get(devlink);
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static int nsim_devlink_ref_release(struct inode *inode, struct file *file)
+{
+	struct nsim_dev *nsim_dev = inode->i_private;
+	struct devlink *devlink = priv_to_devlink(nsim_dev);
+
+	devlink_put(devlink);
+	return 0;
+}
+
 static int
 nsim_dev_take_snapshot(struct devlink *devlink,
 		       const struct devlink_region_ops *ops,
@@ -109,26 +132,38 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 	if (err)
 		return err;
 
-	err = devlink_region_snapshot_id_get(devlink, &id);
+	devlink_lock(devlink);
+	if (!devlink_is_alive(devlink)) {
+		err = -ENODEV;
+		goto err_free;
+	}
+
+	err = __devlink_region_snapshot_id_get(devlink, &id);
 	if (err) {
 		pr_err("Failed to get snapshot id\n");
-		kfree(dummy_data);
-		return err;
+		goto err_free;
 	}
-	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
-					     dummy_data, id);
-	devlink_region_snapshot_id_put(devlink, id);
+
+	err = __devlink_region_snapshot_create(nsim_dev->dummy_region,
+					       dummy_data, id);
+	__devlink_region_snapshot_id_put(devlink, id);
 	if (err) {
 		pr_err("Failed to create region snapshot\n");
-		kfree(dummy_data);
-		return err;
+		goto err_free;
 	}
+	devlink_unlock(devlink);
 
 	return count;
+
+err_free:
+	kfree(dummy_data);
+	devlink_unlock(devlink);
+	return err;
 }
 
 static const struct file_operations nsim_dev_take_snapshot_fops = {
-	.open = simple_open,
+	.open = nsim_devlink_ref_open,
+	.release = nsim_devlink_ref_release,
 	.write = nsim_dev_take_snapshot_write,
 	.llseek = generic_file_llseek,
 	.owner = THIS_MODULE,
@@ -246,6 +281,7 @@ static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 {
 	struct nsim_vf_config *vfconfigs;
 	struct nsim_dev *nsim_dev;
+	struct devlink *devlink;
 	char buf[10];
 	ssize_t ret;
 	u32 val;
@@ -275,9 +311,12 @@ static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 		return -ENOMEM;
 
 	nsim_dev = file->private_data;
-	mutex_lock(&nsim_dev->vfs_lock);
-	/* Reject if VFs are configured */
-	if (nsim_dev_get_vfs(nsim_dev)) {
+	devlink = priv_to_devlink(nsim_dev);
+	devlink_lock(devlink);
+	if (!devlink_is_alive(devlink)) {
+		ret = -ENODEV;
+	} else if (nsim_dev_get_vfs(nsim_dev)) {
+		/* Reject if VFs are configured */
 		ret = -EBUSY;
 	} else {
 		swap(nsim_dev->vfconfigs, vfconfigs);
@@ -285,14 +324,15 @@ static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 		*ppos += count;
 		ret = count;
 	}
-	mutex_unlock(&nsim_dev->vfs_lock);
+	devlink_unlock(devlink);
 
 	kfree(vfconfigs);
 	return ret;
 }
 
 static const struct file_operations nsim_dev_max_vfs_fops = {
-	.open = simple_open,
+	.open = nsim_devlink_ref_open,
+	.release = nsim_devlink_ref_release,
 	.read = nsim_bus_dev_max_vfs_read,
 	.write = nsim_bus_dev_max_vfs_write,
 	.llseek = generic_file_llseek,
@@ -319,11 +359,10 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 			   &nsim_dev->max_macs);
 	debugfs_create_bool("test1", 0600, nsim_dev->ddir,
 			    &nsim_dev->test1);
-	nsim_dev->take_snapshot = debugfs_create_file("take_snapshot",
-						      0200,
-						      nsim_dev->ddir,
-						      nsim_dev,
-						&nsim_dev_take_snapshot_fops);
+	nsim_dev->take_snapshot =
+		debugfs_create_file_unsafe("take_snapshot", 0200,
+					   nsim_dev->ddir, nsim_dev,
+					   &nsim_dev_take_snapshot_fops);
 	debugfs_create_bool("dont_allow_reload", 0600, nsim_dev->ddir,
 			    &nsim_dev->dont_allow_reload);
 	debugfs_create_bool("fail_reload", 0600, nsim_dev->ddir,
@@ -339,8 +378,8 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	debugfs_create_bool("fail_trap_policer_counter_get", 0600,
 			    nsim_dev->ddir,
 			    &nsim_dev->fail_trap_policer_counter_get);
-	debugfs_create_file("max_vfs", 0600, nsim_dev->ddir,
-			    nsim_dev, &nsim_dev_max_vfs_fops);
+	debugfs_create_file_unsafe("max_vfs", 0600, nsim_dev->ddir,
+				   nsim_dev, &nsim_dev_max_vfs_fops);
 
 	nsim_dev->nodes_ddir = debugfs_create_dir("rate_nodes", nsim_dev->ddir);
 	if (IS_ERR(nsim_dev->nodes_ddir)) {
@@ -435,62 +474,62 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 	int err;
 
 	/* Resources for IPv4 */
-	err = devlink_resource_register(devlink, "IPv4", (u64)-1,
-					NSIM_RESOURCE_IPV4,
-					DEVLINK_RESOURCE_ID_PARENT_TOP,
-					&params);
+	err = __devlink_resource_register(devlink, "IPv4", (u64)-1,
+					  NSIM_RESOURCE_IPV4,
+					  DEVLINK_RESOURCE_ID_PARENT_TOP,
+					  &params);
 	if (err) {
 		pr_err("Failed to register IPv4 top resource\n");
 		goto out;
 	}
 
-	err = devlink_resource_register(devlink, "fib", (u64)-1,
-					NSIM_RESOURCE_IPV4_FIB,
-					NSIM_RESOURCE_IPV4, &params);
+	err = __devlink_resource_register(devlink, "fib", (u64)-1,
+					  NSIM_RESOURCE_IPV4_FIB,
+					  NSIM_RESOURCE_IPV4, &params);
 	if (err) {
 		pr_err("Failed to register IPv4 FIB resource\n");
-		return err;
+		goto out;
 	}
 
-	err = devlink_resource_register(devlink, "fib-rules", (u64)-1,
-					NSIM_RESOURCE_IPV4_FIB_RULES,
-					NSIM_RESOURCE_IPV4, &params);
+	err = __devlink_resource_register(devlink, "fib-rules", (u64)-1,
+					  NSIM_RESOURCE_IPV4_FIB_RULES,
+					  NSIM_RESOURCE_IPV4, &params);
 	if (err) {
 		pr_err("Failed to register IPv4 FIB rules resource\n");
-		return err;
+		goto out;
 	}
 
 	/* Resources for IPv6 */
-	err = devlink_resource_register(devlink, "IPv6", (u64)-1,
-					NSIM_RESOURCE_IPV6,
-					DEVLINK_RESOURCE_ID_PARENT_TOP,
-					&params);
+	err = __devlink_resource_register(devlink, "IPv6", (u64)-1,
+					  NSIM_RESOURCE_IPV6,
+					  DEVLINK_RESOURCE_ID_PARENT_TOP,
+					  &params);
 	if (err) {
 		pr_err("Failed to register IPv6 top resource\n");
 		goto out;
 	}
 
-	err = devlink_resource_register(devlink, "fib", (u64)-1,
-					NSIM_RESOURCE_IPV6_FIB,
-					NSIM_RESOURCE_IPV6, &params);
+	err = __devlink_resource_register(devlink, "fib", (u64)-1,
+					  NSIM_RESOURCE_IPV6_FIB,
+					  NSIM_RESOURCE_IPV6, &params);
 	if (err) {
 		pr_err("Failed to register IPv6 FIB resource\n");
-		return err;
+		goto out;
 	}
 
-	err = devlink_resource_register(devlink, "fib-rules", (u64)-1,
-					NSIM_RESOURCE_IPV6_FIB_RULES,
-					NSIM_RESOURCE_IPV6, &params);
+	err = __devlink_resource_register(devlink, "fib-rules", (u64)-1,
+					  NSIM_RESOURCE_IPV6_FIB_RULES,
+					  NSIM_RESOURCE_IPV6, &params);
 	if (err) {
 		pr_err("Failed to register IPv6 FIB rules resource\n");
-		return err;
+		goto out;
 	}
 
 	/* Resources for nexthops */
-	err = devlink_resource_register(devlink, "nexthops", (u64)-1,
-					NSIM_RESOURCE_NEXTHOPS,
-					DEVLINK_RESOURCE_ID_PARENT_TOP,
-					&params);
+	err = __devlink_resource_register(devlink, "nexthops", (u64)-1,
+					  NSIM_RESOURCE_NEXTHOPS,
+					  DEVLINK_RESOURCE_ID_PARENT_TOP,
+					  &params);
 
 out:
 	return err;
@@ -556,15 +595,15 @@ static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
 				      struct devlink *devlink)
 {
 	nsim_dev->dummy_region =
-		devlink_region_create(devlink, &dummy_region_ops,
-				      NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
-				      NSIM_DEV_DUMMY_REGION_SIZE);
+		__devlink_region_create(devlink, &dummy_region_ops,
+					NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
+					NSIM_DEV_DUMMY_REGION_SIZE);
 	return PTR_ERR_OR_ZERO(nsim_dev->dummy_region);
 }
 
 static void nsim_dev_dummy_region_exit(struct nsim_dev *nsim_dev)
 {
-	devlink_region_destroy(nsim_dev->dummy_region);
+	__devlink_region_destroy(nsim_dev->dummy_region);
 }
 
 static struct nsim_dev_port *
@@ -586,26 +625,50 @@ static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port)
 
 	list_del(&nsim_dev_port->list);
 	if (nsim_dev_port_is_vf(nsim_dev_port))
-		devlink_rate_leaf_destroy(&nsim_dev_port->devlink_port);
+		__devlink_rate_leaf_destroy(&nsim_dev_port->devlink_port);
 	devlink_port_type_clear(devlink_port);
 	nsim_destroy(nsim_dev_port->ns);
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
-	devlink_port_unregister(devlink_port);
+	__devlink_port_unregister(devlink_port);
 	kfree(nsim_dev_port);
 }
 
+static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
+			       enum nsim_dev_port_type type,
+			       unsigned int port_index);
+
+static int
+nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_type type,
+		  unsigned int port_index)
+{
+	if (__nsim_dev_port_lookup(nsim_dev, type, port_index))
+		return -EEXIST;
+	return __nsim_dev_port_add(nsim_dev, type, port_index);
+}
+
+static int
+nsim_dev_port_del(struct nsim_dev *nsim_dev, enum nsim_dev_port_type type,
+		  unsigned int port_index)
+{
+	struct nsim_dev_port *nsim_dev_port;
+
+	nsim_dev_port = __nsim_dev_port_lookup(nsim_dev, type, port_index);
+	if (!nsim_dev_port)
+		return -ENOENT;
+	__nsim_dev_port_del(nsim_dev_port);
+	return 0;
+}
+
 static int nsim_esw_legacy_enable(struct nsim_dev *nsim_dev,
 				  struct netlink_ext_ack *extack)
 {
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 	struct nsim_dev_port *nsim_dev_port, *tmp;
 
-	devlink_rate_nodes_destroy(devlink);
-	mutex_lock(&nsim_dev->port_list_lock);
+	__devlink_rate_nodes_destroy(devlink);
 	list_for_each_entry_safe(nsim_dev_port, tmp, &nsim_dev->port_list, list)
 		if (nsim_dev_port_is_vf(nsim_dev_port))
 			__nsim_dev_port_del(nsim_dev_port);
-	mutex_unlock(&nsim_dev->port_list_lock);
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 	return 0;
 }
@@ -613,11 +676,10 @@ static int nsim_esw_legacy_enable(struct nsim_dev *nsim_dev,
 static int nsim_esw_switchdev_enable(struct nsim_dev *nsim_dev,
 				     struct netlink_ext_ack *extack)
 {
-	struct nsim_bus_dev *nsim_bus_dev = nsim_dev->nsim_bus_dev;
 	int i, err;
 
 	for (i = 0; i < nsim_dev_get_vfs(nsim_dev); i++) {
-		err = nsim_drv_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_VF, i);
+		err = nsim_dev_port_add(nsim_dev, NSIM_DEV_PORT_TYPE_VF, i);
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack, "Failed to initialize VFs' netdevsim ports");
 			pr_err("Failed to initialize VF id=%d. %d.\n", i, err);
@@ -629,7 +691,7 @@ static int nsim_esw_switchdev_enable(struct nsim_dev *nsim_dev,
 
 err_port_add_vfs:
 	for (i--; i >= 0; i--)
-		nsim_drv_port_del(nsim_bus_dev, NSIM_DEV_PORT_TYPE_VF, i);
+		nsim_dev_port_del(nsim_dev, NSIM_DEV_PORT_TYPE_VF, i);
 	return err;
 }
 
@@ -637,22 +699,16 @@ static int nsim_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 					 struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
-	int err = 0;
 
-	mutex_lock(&nsim_dev->vfs_lock);
 	if (mode == nsim_dev->esw_mode)
-		goto unlock;
+		return 0;
 
 	if (mode == DEVLINK_ESWITCH_MODE_LEGACY)
-		err = nsim_esw_legacy_enable(nsim_dev, extack);
+		return nsim_esw_legacy_enable(nsim_dev, extack);
 	else if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV)
-		err = nsim_esw_switchdev_enable(nsim_dev, extack);
-	else
-		err = -EINVAL;
+		return nsim_esw_switchdev_enable(nsim_dev, extack);
 
-unlock:
-	mutex_unlock(&nsim_dev->vfs_lock);
-	return err;
+	return -EINVAL;
 }
 
 static int nsim_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
@@ -847,30 +903,51 @@ static void nsim_dev_trap_report(struct nsim_dev_port *nsim_dev_port)
 
 #define NSIM_TRAP_REPORT_INTERVAL_MS	100
 
+static void nsim_dev_trap_free(struct devlink *devlink,
+			       struct nsim_trap_data *nsim_trap_data)
+{
+	kfree(nsim_trap_data->trap_policers_cnt_arr);
+	kfree(nsim_trap_data->trap_items_arr);
+	kfree(nsim_trap_data);
+
+	devlink_put(devlink);
+}
+
 static void nsim_dev_trap_report_work(struct work_struct *work)
 {
 	struct nsim_trap_data *nsim_trap_data;
 	struct nsim_dev_port *nsim_dev_port;
 	struct nsim_dev *nsim_dev;
+	struct devlink *devlink;
+	bool down;
 
 	nsim_trap_data = container_of(work, struct nsim_trap_data,
 				      trap_report_dw.work);
 	nsim_dev = nsim_trap_data->nsim_dev;
+	devlink = priv_to_devlink(nsim_dev);
+
+	devlink_lock(devlink);
+	down = nsim_dev->trap_data != nsim_trap_data;
+	if (down)
+		goto unlock;
 
 	/* For each running port and enabled packet trap, generate a UDP
 	 * packet with a random 5-tuple and report it.
 	 */
-	mutex_lock(&nsim_dev->port_list_lock);
 	list_for_each_entry(nsim_dev_port, &nsim_dev->port_list, list) {
 		if (!netif_running(nsim_dev_port->ns->netdev))
 			continue;
 
 		nsim_dev_trap_report(nsim_dev_port);
 	}
-	mutex_unlock(&nsim_dev->port_list_lock);
 
 	schedule_delayed_work(&nsim_dev->trap_data->trap_report_dw,
 			      msecs_to_jiffies(NSIM_TRAP_REPORT_INTERVAL_MS));
+unlock:
+	devlink_unlock(devlink);
+
+	if (down)
+		nsim_dev_trap_free(devlink, nsim_trap_data);
 }
 
 static int nsim_dev_traps_init(struct devlink *devlink)
@@ -908,35 +985,36 @@ static int nsim_dev_traps_init(struct devlink *devlink)
 	nsim_trap_data->nsim_dev = nsim_dev;
 	nsim_dev->trap_data = nsim_trap_data;
 
-	err = devlink_trap_policers_register(devlink, nsim_trap_policers_arr,
-					     policers_count);
+	err = __devlink_trap_policers_register(devlink, nsim_trap_policers_arr,
+					       policers_count);
 	if (err)
 		goto err_trap_policers_cnt_free;
 
-	err = devlink_trap_groups_register(devlink, nsim_trap_groups_arr,
-					   ARRAY_SIZE(nsim_trap_groups_arr));
+	err = __devlink_trap_groups_register(devlink, nsim_trap_groups_arr,
+					     ARRAY_SIZE(nsim_trap_groups_arr));
 	if (err)
 		goto err_trap_policers_unregister;
 
-	err = devlink_traps_register(devlink, nsim_traps_arr,
-				     ARRAY_SIZE(nsim_traps_arr), NULL);
+	err = __devlink_traps_register(devlink, nsim_traps_arr,
+				       ARRAY_SIZE(nsim_traps_arr), NULL);
 	if (err)
 		goto err_trap_groups_unregister;
 
 	INIT_DELAYED_WORK(&nsim_dev->trap_data->trap_report_dw,
 			  nsim_dev_trap_report_work);
+	devlink_get(devlink);
 	schedule_delayed_work(&nsim_dev->trap_data->trap_report_dw,
 			      msecs_to_jiffies(NSIM_TRAP_REPORT_INTERVAL_MS));
 
 	return 0;
 
 err_trap_groups_unregister:
-	devlink_trap_groups_unregister(devlink, nsim_trap_groups_arr,
-				       ARRAY_SIZE(nsim_trap_groups_arr));
+	__devlink_trap_groups_unregister(devlink, nsim_trap_groups_arr,
+					 ARRAY_SIZE(nsim_trap_groups_arr));
 err_trap_policers_unregister:
-	devlink_trap_policers_unregister(devlink, nsim_trap_policers_arr,
-					 ARRAY_SIZE(nsim_trap_policers_arr));
-err_trap_policers_cnt_free:
+	__devlink_trap_policers_unregister(devlink, nsim_trap_policers_arr,
+					   ARRAY_SIZE(nsim_trap_policers_arr));
+err_trap_policers_cnt_free:;
 	kfree(nsim_trap_data->trap_policers_cnt_arr);
 err_trap_items_free:
 	kfree(nsim_trap_data->trap_items_arr);
@@ -949,16 +1027,17 @@ static void nsim_dev_traps_exit(struct devlink *devlink)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 
-	cancel_delayed_work_sync(&nsim_dev->trap_data->trap_report_dw);
-	devlink_traps_unregister(devlink, nsim_traps_arr,
-				 ARRAY_SIZE(nsim_traps_arr));
-	devlink_trap_groups_unregister(devlink, nsim_trap_groups_arr,
-				       ARRAY_SIZE(nsim_trap_groups_arr));
-	devlink_trap_policers_unregister(devlink, nsim_trap_policers_arr,
-					 ARRAY_SIZE(nsim_trap_policers_arr));
-	kfree(nsim_dev->trap_data->trap_policers_cnt_arr);
-	kfree(nsim_dev->trap_data->trap_items_arr);
-	kfree(nsim_dev->trap_data);
+	__devlink_traps_unregister(devlink, nsim_traps_arr,
+				   ARRAY_SIZE(nsim_traps_arr));
+	__devlink_trap_groups_unregister(devlink, nsim_trap_groups_arr,
+					 ARRAY_SIZE(nsim_trap_groups_arr));
+	__devlink_trap_policers_unregister(devlink, nsim_trap_policers_arr,
+					   ARRAY_SIZE(nsim_trap_policers_arr));
+
+	if (cancel_delayed_work(&nsim_dev->trap_data->trap_report_dw))
+		nsim_dev_trap_free(devlink, nsim_dev->trap_data);
+	else
+		nsim_dev->trap_data = NULL;
 }
 
 static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
@@ -970,24 +1049,16 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
 				struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
-	struct nsim_bus_dev *nsim_bus_dev;
-
-	nsim_bus_dev = nsim_dev->nsim_bus_dev;
-	if (!mutex_trylock(&nsim_bus_dev->nsim_bus_reload_lock))
-		return -EOPNOTSUPP;
 
 	if (nsim_dev->dont_allow_reload) {
 		/* For testing purposes, user set debugfs dont_allow_reload
 		 * value to true. So forbid it.
 		 */
 		NL_SET_ERR_MSG_MOD(extack, "User forbid the reload for testing purposes");
-		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 		return -EOPNOTSUPP;
 	}
-	nsim_bus_dev->in_reload = true;
 
 	nsim_dev_reload_destroy(nsim_dev);
-	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return 0;
 }
 
@@ -996,26 +1067,17 @@ static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_actio
 			      struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
-	struct nsim_bus_dev *nsim_bus_dev;
-	int ret;
-
-	nsim_bus_dev = nsim_dev->nsim_bus_dev;
-	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
-	nsim_bus_dev->in_reload = false;
 
 	if (nsim_dev->fail_reload) {
 		/* For testing purposes, user set debugfs fail_reload
 		 * value to true. Fail right away.
 		 */
 		NL_SET_ERR_MSG_MOD(extack, "User setup the reload to fail for testing purposes");
-		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 		return -EINVAL;
 	}
 
 	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
-	ret = nsim_dev_reload_create(nsim_dev, extack);
-	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
-	return ret;
+	return nsim_dev_reload_create(nsim_dev, extack);
 }
 
 static int nsim_dev_info_get(struct devlink *devlink,
@@ -1348,6 +1410,8 @@ nsim_dev_devlink_trap_drop_counter_get(struct devlink *devlink,
 }
 
 static const struct devlink_ops nsim_dev_devlink_ops = {
+	.lock_flags = DEVLINK_LOCK_ALL_OPS,
+	.owner = THIS_MODULE,
 	.eswitch_mode_set = nsim_devlink_eswitch_mode_set,
 	.eswitch_mode_get = nsim_devlink_eswitch_mode_get,
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
@@ -1405,8 +1469,9 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 	memcpy(attrs.switch_id.id, nsim_dev->switch_id.id, nsim_dev->switch_id.id_len);
 	attrs.switch_id.id_len = nsim_dev->switch_id.id_len;
 	devlink_port_attrs_set(devlink_port, &attrs);
-	err = devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
-				    nsim_dev_port->port_index);
+
+	err = __devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
+				      nsim_dev_port->port_index);
 	if (err)
 		goto err_port_free;
 
@@ -1421,8 +1486,8 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 	}
 
 	if (nsim_dev_port_is_vf(nsim_dev_port)) {
-		err = devlink_rate_leaf_create(&nsim_dev_port->devlink_port,
-					       nsim_dev_port);
+		err = __devlink_rate_leaf_create(&nsim_dev_port->devlink_port,
+						 nsim_dev_port);
 		if (err)
 			goto err_nsim_destroy;
 	}
@@ -1437,7 +1502,7 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 err_port_debugfs_exit:
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
 err_dl_port_unregister:
-	devlink_port_unregister(devlink_port);
+	__devlink_port_unregister(devlink_port);
 err_port_free:
 	kfree(nsim_dev_port);
 	return err;
@@ -1447,11 +1512,9 @@ static void nsim_dev_port_del_all(struct nsim_dev *nsim_dev)
 {
 	struct nsim_dev_port *nsim_dev_port, *tmp;
 
-	mutex_lock(&nsim_dev->port_list_lock);
 	list_for_each_entry_safe(nsim_dev_port, tmp,
 				 &nsim_dev->port_list, list)
 		__nsim_dev_port_del(nsim_dev_port);
-	mutex_unlock(&nsim_dev->port_list_lock);
 }
 
 static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
@@ -1481,7 +1544,6 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	devlink = priv_to_devlink(nsim_dev);
 	nsim_dev = devlink_priv(devlink);
 	INIT_LIST_HEAD(&nsim_dev->port_list);
-	mutex_init(&nsim_dev->port_list_lock);
 	nsim_dev->fw_update_status = true;
 	nsim_dev->fw_update_overwrite_mask = 0;
 
@@ -1489,7 +1551,12 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 
 	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
 	if (err)
-		return err;
+		goto err_unlock;
+
+	nsim_dev->take_snapshot =
+		debugfs_create_file_unsafe("take_snapshot", 0200,
+					   nsim_dev->ddir, nsim_dev,
+					   &nsim_dev_take_snapshot_fops);
 
 	err = nsim_dev_traps_init(devlink);
 	if (err)
@@ -1512,12 +1579,6 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
 	if (err)
 		goto err_psample_exit;
-
-	nsim_dev->take_snapshot = debugfs_create_file("take_snapshot",
-						      0200,
-						      nsim_dev->ddir,
-						      nsim_dev,
-						&nsim_dev_take_snapshot_fops);
 	return 0;
 
 err_psample_exit:
@@ -1530,6 +1591,7 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	nsim_dev_traps_exit(devlink);
 err_dummy_region_exit:
 	nsim_dev_dummy_region_exit(nsim_dev);
+err_unlock:
 	return err;
 }
 
@@ -1548,8 +1610,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev->switch_id.id_len = sizeof(nsim_dev->switch_id.id);
 	get_random_bytes(nsim_dev->switch_id.id, nsim_dev->switch_id.id_len);
 	INIT_LIST_HEAD(&nsim_dev->port_list);
-	mutex_init(&nsim_dev->vfs_lock);
-	mutex_init(&nsim_dev->port_list_lock);
 	nsim_dev->fw_update_status = true;
 	nsim_dev->fw_update_overwrite_mask = 0;
 	nsim_dev->max_macs = NSIM_DEV_MAX_MACS_DEFAULT;
@@ -1566,12 +1626,13 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 		goto err_devlink_free;
 	}
 
+	devlink_lock_reg(devlink);
 	err = nsim_dev_resources_register(devlink);
 	if (err)
 		goto err_vfc_free;
 
-	err = devlink_params_register(devlink, nsim_devlink_params,
-				      ARRAY_SIZE(nsim_devlink_params));
+	err = __devlink_params_register(devlink, nsim_devlink_params,
+					ARRAY_SIZE(nsim_devlink_params));
 	if (err)
 		goto err_dl_unregister;
 	nsim_devlink_set_params_init_values(nsim_dev, devlink);
@@ -1612,7 +1673,9 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
-	devlink_register(devlink);
+	__devlink_register(devlink);
+	devlink_unlock_reg(devlink);
+
 	return 0;
 
 err_psample_exit:
@@ -1630,14 +1693,15 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 err_dummy_region_exit:
 	nsim_dev_dummy_region_exit(nsim_dev);
 err_params_unregister:
-	devlink_params_unregister(devlink, nsim_devlink_params,
-				  ARRAY_SIZE(nsim_devlink_params));
+	__devlink_params_unregister(devlink, nsim_devlink_params,
+				    ARRAY_SIZE(nsim_devlink_params));
 err_dl_unregister:
-	devlink_resources_unregister(devlink, NULL);
+	__devlink_resources_unregister(devlink, NULL);
 err_vfc_free:
 	kfree(nsim_dev->vfconfigs);
+	devlink_unlock_reg(devlink);
 err_devlink_free:
-	devlink_free(devlink);
+	__devlink_free(devlink);
 	dev_set_drvdata(&nsim_bus_dev->dev, NULL);
 	return err;
 }
@@ -1650,13 +1714,11 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 		return;
 	debugfs_remove(nsim_dev->take_snapshot);
 
-	mutex_lock(&nsim_dev->vfs_lock);
 	if (nsim_dev_get_vfs(nsim_dev)) {
 		nsim_bus_dev_set_vfs(nsim_dev->nsim_bus_dev, 0);
 		if (nsim_esw_mode_is_switchdev(nsim_dev))
 			nsim_esw_legacy_enable(nsim_dev, NULL);
 	}
-	mutex_unlock(&nsim_dev->vfs_lock);
 
 	nsim_dev_port_del_all(nsim_dev);
 	nsim_dev_psample_exit(nsim_dev);
@@ -1664,7 +1726,6 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 	nsim_dev_traps_exit(devlink);
 	nsim_dev_dummy_region_exit(nsim_dev);
-	mutex_destroy(&nsim_dev->port_list_lock);
 }
 
 void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
@@ -1672,58 +1733,61 @@ void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
-	devlink_unregister(devlink);
+	devlink_lock_reg(devlink);
+	__devlink_unregister(devlink);
 	nsim_dev_reload_destroy(nsim_dev);
 
 	nsim_bpf_dev_exit(nsim_dev);
 	nsim_dev_debugfs_exit(nsim_dev);
-	devlink_params_unregister(devlink, nsim_devlink_params,
-				  ARRAY_SIZE(nsim_devlink_params));
-	devlink_resources_unregister(devlink, NULL);
+	__devlink_params_unregister(devlink, nsim_devlink_params,
+				    ARRAY_SIZE(nsim_devlink_params));
+	__devlink_resources_unregister(devlink, NULL);
 	kfree(nsim_dev->vfconfigs);
-	devlink_free(devlink);
 	dev_set_drvdata(&nsim_bus_dev->dev, NULL);
+	devlink_unlock_reg(devlink);
+	__devlink_free(devlink);
 }
 
-int nsim_drv_port_add(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type type,
+int nsim_drv_port_add(struct nsim_bus_dev *nsim_bus_dev,
+		      enum nsim_dev_port_type type,
 		      unsigned int port_index)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
-	int err;
+	struct devlink *devlink = priv_to_devlink(nsim_dev);
+	int ret;
 
-	mutex_lock(&nsim_dev->port_list_lock);
-	if (__nsim_dev_port_lookup(nsim_dev, type, port_index))
-		err = -EEXIST;
-	else
-		err = __nsim_dev_port_add(nsim_dev, type, port_index);
-	mutex_unlock(&nsim_dev->port_list_lock);
-	return err;
+	devlink_lock(devlink);
+	ret = -EBUSY;
+	if (!devlink_is_reload_failed(devlink))
+		ret = nsim_dev_port_add(nsim_dev, type, port_index);
+	devlink_unlock(devlink);
+	return ret;
 }
 
-int nsim_drv_port_del(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type type,
+int nsim_drv_port_del(struct nsim_bus_dev *nsim_bus_dev,
+		      enum nsim_dev_port_type type,
 		      unsigned int port_index)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
-	struct nsim_dev_port *nsim_dev_port;
-	int err = 0;
+	struct devlink *devlink = priv_to_devlink(nsim_dev);
+	int ret;
 
-	mutex_lock(&nsim_dev->port_list_lock);
-	nsim_dev_port = __nsim_dev_port_lookup(nsim_dev, type, port_index);
-	if (!nsim_dev_port)
-		err = -ENOENT;
-	else
-		__nsim_dev_port_del(nsim_dev_port);
-	mutex_unlock(&nsim_dev->port_list_lock);
-	return err;
+	devlink_lock(devlink);
+	ret = -EBUSY;
+	if (!devlink_is_reload_failed(devlink))
+		ret = nsim_dev_port_del(nsim_dev, type, port_index);
+	devlink_unlock(devlink);
+	return ret;
 }
 
 int nsim_drv_configure_vfs(struct nsim_bus_dev *nsim_bus_dev,
 			   unsigned int num_vfs)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
+	struct devlink *devlink = priv_to_devlink(nsim_dev);
 	int ret;
 
-	mutex_lock(&nsim_dev->vfs_lock);
+	devlink_lock(devlink);
 	if (nsim_bus_dev->num_vfs == num_vfs) {
 		ret = 0;
 		goto exit_unlock;
@@ -1751,7 +1815,7 @@ int nsim_drv_configure_vfs(struct nsim_bus_dev *nsim_bus_dev,
 	}
 
 exit_unlock:
-	mutex_unlock(&nsim_dev->vfs_lock);
+	devlink_unlock(devlink);
 
 	return ret;
 }
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 4300261e2f9e..e77670324c2a 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -1452,7 +1452,7 @@ static void nsim_fib_set_max_all(struct nsim_fib_data *data,
 		int err;
 		u64 val;
 
-		err = devlink_resource_size_get(devlink, res_ids[i], &val);
+		err = __devlink_resource_size_get(devlink, res_ids[i], &val);
 		if (err)
 			val = (u64) -1;
 		nsim_fib_set_max(data, res_ids[i], val);
@@ -1561,26 +1561,26 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
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
+	__devlink_resource_occ_get_register(devlink,
+					    NSIM_RESOURCE_IPV4_FIB,
+					    nsim_fib_ipv4_resource_occ_get,
+					    data);
+	__devlink_resource_occ_get_register(devlink,
+					    NSIM_RESOURCE_IPV4_FIB_RULES,
+					    nsim_fib_ipv4_rules_res_occ_get,
+					    data);
+	__devlink_resource_occ_get_register(devlink,
+					    NSIM_RESOURCE_IPV6_FIB,
+					    nsim_fib_ipv6_resource_occ_get,
+					    data);
+	__devlink_resource_occ_get_register(devlink,
+					    NSIM_RESOURCE_IPV6_FIB_RULES,
+					    nsim_fib_ipv6_rules_res_occ_get,
+					    data);
+	__devlink_resource_occ_get_register(devlink,
+					    NSIM_RESOURCE_NEXTHOPS,
+					    nsim_fib_nexthops_res_occ_get,
+					    data);
 	return data;
 
 err_nexthop_nb_unregister:
@@ -1603,16 +1603,16 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 
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
+	__devlink_resource_occ_get_unregister(devlink,
+					      NSIM_RESOURCE_NEXTHOPS);
+	__devlink_resource_occ_get_unregister(devlink,
+					      NSIM_RESOURCE_IPV6_FIB_RULES);
+	__devlink_resource_occ_get_unregister(devlink,
+					      NSIM_RESOURCE_IPV6_FIB);
+	__devlink_resource_occ_get_unregister(devlink,
+					      NSIM_RESOURCE_IPV4_FIB_RULES);
+	__devlink_resource_occ_get_unregister(devlink,
+					      NSIM_RESOURCE_IPV4_FIB);
 	unregister_fib_notifier(devlink_net(devlink), &data->fib_nb);
 	unregister_nexthop_notifier(devlink_net(devlink), &data->nexthop_nb);
 	flush_work(&data->fib_event_work);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index c49771f27f17..97ff4e2e72ac 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -239,7 +239,6 @@ struct nsim_dev {
 	struct dentry *take_snapshot;
 	struct dentry *nodes_ddir;
 
-	struct mutex vfs_lock;  /* Protects vfconfigs */
 	struct nsim_vf_config *vfconfigs;
 
 	struct bpf_offload_dev *bpf_dev;
@@ -252,7 +251,6 @@ struct nsim_dev {
 	struct list_head bpf_bound_maps;
 	struct netdev_phys_item_id switch_id;
 	struct list_head port_list;
-	struct mutex port_list_lock; /* protects port list */
 	bool fw_update_status;
 	u32 fw_update_overwrite_mask;
 	u32 max_macs;
@@ -355,9 +353,6 @@ struct nsim_bus_dev {
 				  */
 	unsigned int max_vfs;
 	unsigned int num_vfs;
-	/* Lock for devlink->reload_enabled in netdevsim module */
-	struct mutex nsim_bus_reload_lock;
-	bool in_reload;
 	bool init;
 };
 
-- 
2.31.1


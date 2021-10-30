Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE469440B9E
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 22:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhJ3UXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 16:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230443AbhJ3UXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 16:23:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC1B360F57;
        Sat, 30 Oct 2021 20:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635625265;
        bh=cVi19bJmHVx8C84xhubu5znXYnw9MjrF127dWJpZEF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIAMo5MpFyuSgpFtXkC07kJ6506lkhlA3XO1Rrhtc53l83NxqRNCQrf32GWSaztXN
         d6DuF4JvMTLc4Rjbf/TfpbbqHx6lYjkvsEHHVErkc4pue/z9LRgda4gl86sVjBkuEX
         NfE1naPsZECe5ldx4L2o5BDYDtc4DX0ggPUD2Yn3xO2JR2K4+zcnLgU1O5qkHGBUsV
         kQIy30SHYBpYTCVvOiora6qkNVVTTyxcGrc9D6ojVrTjvL5qhS1/B122WQeHV3oalB
         VgGqqt1xRR1FSUzjfbjKRjFMKhI9+CCUJCTJjl3uhFPZqBAJ8tWrlk85Cxj2eJJdhm
         sDIhw4PTTHh5g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/5] netdevsim: move vfconfig to nsim_dev
Date:   Sat, 30 Oct 2021 13:20:59 -0700
Message-Id: <20211030202102.2157622-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030202102.2157622-1-kuba@kernel.org>
References: <20211030202102.2157622-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When netdevsim got split into the faux bus vfconfig ended
up in the bus device (think pci_dev) which is strange because
it contains very networky not to say netdevy information.
Move it to nsim_dev, which is the driver "priv" structure
for the device.

To make sure we don't race with probe/remove take
the device lock (much like PCI).

While at it remove the NULL-checking of vfconfigs.
It appears to be pointless.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/bus.c       | 43 ++++++++----------
 drivers/net/netdevsim/dev.c       | 53 ++++++++++++++++-------
 drivers/net/netdevsim/netdev.c    | 72 +++++++++++++++----------------
 drivers/net/netdevsim/netdevsim.h | 34 ++++++++-------
 4 files changed, 111 insertions(+), 91 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 284223108d25..1e7df184419d 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -40,9 +40,6 @@ static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
 
 	if (nsim_bus_dev->max_vfs < num_vfs)
 		return -ENOMEM;
-
-	if (!nsim_bus_dev->vfconfigs)
-		return -ENOMEM;
 	nsim_bus_dev_set_vfs(nsim_bus_dev, num_vfs);
 
 	nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
@@ -70,6 +67,7 @@ nsim_bus_dev_numvfs_store(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
 	struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
+	struct nsim_dev *nsim_dev = dev_get_drvdata(dev);
 	unsigned int num_vfs;
 	int ret;
 
@@ -77,7 +75,13 @@ nsim_bus_dev_numvfs_store(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		return ret;
 
-	mutex_lock(&nsim_bus_dev->vfs_lock);
+	device_lock(dev);
+	if (!nsim_dev) {
+		ret = -ENOENT;
+		goto exit_unlock;
+	}
+
+	mutex_lock(&nsim_dev->vfs_lock);
 	if (nsim_bus_dev->num_vfs == num_vfs)
 		goto exit_good;
 	if (nsim_bus_dev->num_vfs && num_vfs) {
@@ -95,7 +99,8 @@ nsim_bus_dev_numvfs_store(struct device *dev, struct device_attribute *attr,
 exit_good:
 	ret = count;
 exit_unlock:
-	mutex_unlock(&nsim_bus_dev->vfs_lock);
+	mutex_unlock(&nsim_dev->vfs_lock);
+	device_unlock(dev);
 
 	return ret;
 }
@@ -117,7 +122,8 @@ ssize_t nsim_bus_dev_max_vfs_read(struct file *file,
 				  char __user *data,
 				  size_t count, loff_t *ppos)
 {
-	struct nsim_bus_dev *nsim_bus_dev = file->private_data;
+	struct nsim_dev *nsim_dev = file->private_data;
+	struct nsim_bus_dev *nsim_bus_dev = nsim_dev->nsim_bus_dev;
 	char buf[11];
 	ssize_t len;
 
@@ -132,7 +138,8 @@ ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 				   const char __user *data,
 				   size_t count, loff_t *ppos)
 {
-	struct nsim_bus_dev *nsim_bus_dev = file->private_data;
+	struct nsim_dev *nsim_dev = file->private_data;
+	struct nsim_bus_dev *nsim_bus_dev = nsim_dev->nsim_bus_dev;
 	struct nsim_vf_config *vfconfigs;
 	ssize_t ret;
 	char buf[10];
@@ -144,7 +151,7 @@ ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 	if (count >= sizeof(buf))
 		return -ENOSPC;
 
-	mutex_lock(&nsim_bus_dev->vfs_lock);
+	mutex_lock(&nsim_dev->vfs_lock);
 	/* Reject if VFs are configured */
 	if (nsim_bus_dev->num_vfs) {
 		ret = -EBUSY;
@@ -176,13 +183,13 @@ ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 		goto unlock;
 	}
 
-	kfree(nsim_bus_dev->vfconfigs);
-	nsim_bus_dev->vfconfigs = vfconfigs;
+	kfree(nsim_dev->vfconfigs);
+	nsim_dev->vfconfigs = vfconfigs;
 	nsim_bus_dev->max_vfs = val;
 	*ppos += count;
 	ret = count;
 unlock:
-	mutex_unlock(&nsim_bus_dev->vfs_lock);
+	mutex_unlock(&nsim_dev->vfs_lock);
 	return ret;
 }
 
@@ -428,26 +435,15 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count, unsigned int num_queu
 	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
 	nsim_bus_dev->max_vfs = NSIM_BUS_DEV_MAX_VFS;
 	mutex_init(&nsim_bus_dev->nsim_bus_reload_lock);
-	mutex_init(&nsim_bus_dev->vfs_lock);
 	/* Disallow using nsim_bus_dev */
 	smp_store_release(&nsim_bus_dev->init, false);
 
-	nsim_bus_dev->vfconfigs = kcalloc(nsim_bus_dev->max_vfs,
-					  sizeof(struct nsim_vf_config),
-					  GFP_KERNEL | __GFP_NOWARN);
-	if (!nsim_bus_dev->vfconfigs) {
-		err = -ENOMEM;
-		goto err_nsim_bus_dev_id_free;
-	}
-
 	err = device_register(&nsim_bus_dev->dev);
 	if (err)
-		goto err_nsim_vfs_free;
+		goto err_nsim_bus_dev_id_free;
 
 	return nsim_bus_dev;
 
-err_nsim_vfs_free:
-	kfree(nsim_bus_dev->vfconfigs);
 err_nsim_bus_dev_id_free:
 	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
 err_nsim_bus_dev_free:
@@ -461,7 +457,6 @@ static void nsim_bus_dev_del(struct nsim_bus_dev *nsim_bus_dev)
 	smp_store_release(&nsim_bus_dev->init, false);
 	device_unregister(&nsim_bus_dev->dev);
 	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
-	kfree(nsim_bus_dev->vfconfigs);
 	kfree(nsim_bus_dev);
 }
 
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 6c906deca71c..8157d28b32e4 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -56,6 +56,14 @@ static inline unsigned int nsim_dev_port_index_to_vf_index(unsigned int port_ind
 
 static struct dentry *nsim_dev_ddir;
 
+unsigned int nsim_dev_get_vfs(struct nsim_dev *nsim_dev)
+{
+	WARN_ON(!lockdep_rtnl_is_held() &&
+		!lockdep_is_held(&nsim_dev->vfs_lock));
+
+	return nsim_dev->nsim_bus_dev->num_vfs;
+}
+
 #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
 
 static int
@@ -260,7 +268,7 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 			    nsim_dev->ddir,
 			    &nsim_dev->fail_trap_policer_counter_get);
 	debugfs_create_file("max_vfs", 0600, nsim_dev->ddir,
-			    nsim_dev->nsim_bus_dev, &nsim_dev_max_vfs_fops);
+			    nsim_dev, &nsim_dev_max_vfs_fops);
 
 	nsim_dev->nodes_ddir = debugfs_create_dir("rate_nodes", nsim_dev->ddir);
 	if (IS_ERR(nsim_dev->nodes_ddir)) {
@@ -326,9 +334,9 @@ static int nsim_dev_port_debugfs_init(struct nsim_dev *nsim_dev,
 		unsigned int vf_id = nsim_dev_port_index_to_vf_index(port_index);
 
 		debugfs_create_u16("tx_share", 0400, nsim_dev_port->ddir,
-				   &nsim_bus_dev->vfconfigs[vf_id].min_tx_rate);
+				   &nsim_dev->vfconfigs[vf_id].min_tx_rate);
 		debugfs_create_u16("tx_max", 0400, nsim_dev_port->ddir,
-				   &nsim_bus_dev->vfconfigs[vf_id].max_tx_rate);
+				   &nsim_dev->vfconfigs[vf_id].max_tx_rate);
 		nsim_dev_port->rate_parent = debugfs_create_file("rate_parent",
 								 0400,
 								 nsim_dev_port->ddir,
@@ -508,7 +516,7 @@ int nsim_esw_switchdev_enable(struct nsim_dev *nsim_dev, struct netlink_ext_ack
 	struct nsim_bus_dev *nsim_bus_dev = nsim_dev->nsim_bus_dev;
 	int i, err;
 
-	for (i = 0; i < nsim_bus_dev->num_vfs; i++) {
+	for (i = 0; i < nsim_dev_get_vfs(nsim_dev); i++) {
 		err = nsim_dev_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_VF, i);
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack, "Failed to initialize VFs' netdevsim ports");
@@ -531,7 +539,7 @@ static int nsim_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 	int err = 0;
 
-	mutex_lock(&nsim_dev->nsim_bus_dev->vfs_lock);
+	mutex_lock(&nsim_dev->vfs_lock);
 	if (mode == nsim_dev->esw_mode)
 		goto unlock;
 
@@ -543,7 +551,7 @@ static int nsim_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		err = -EINVAL;
 
 unlock:
-	mutex_unlock(&nsim_dev->nsim_bus_dev->vfs_lock);
+	mutex_unlock(&nsim_dev->vfs_lock);
 	return err;
 }
 
@@ -1091,7 +1099,7 @@ static int nsim_leaf_tx_share_set(struct devlink_rate *devlink_rate, void *priv,
 				  u64 tx_share, struct netlink_ext_ack *extack)
 {
 	struct nsim_dev_port *nsim_dev_port = priv;
-	struct nsim_bus_dev *nsim_bus_dev = nsim_dev_port->ns->nsim_bus_dev;
+	struct nsim_dev *nsim_dev = nsim_dev_port->ns->nsim_dev;
 	int vf_id = nsim_dev_port_index_to_vf_index(nsim_dev_port->port_index);
 	int err;
 
@@ -1099,7 +1107,7 @@ static int nsim_leaf_tx_share_set(struct devlink_rate *devlink_rate, void *priv,
 	if (err)
 		return err;
 
-	nsim_bus_dev->vfconfigs[vf_id].min_tx_rate = tx_share;
+	nsim_dev->vfconfigs[vf_id].min_tx_rate = tx_share;
 	return 0;
 }
 
@@ -1107,7 +1115,7 @@ static int nsim_leaf_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
 				u64 tx_max, struct netlink_ext_ack *extack)
 {
 	struct nsim_dev_port *nsim_dev_port = priv;
-	struct nsim_bus_dev *nsim_bus_dev = nsim_dev_port->ns->nsim_bus_dev;
+	struct nsim_dev *nsim_dev = nsim_dev_port->ns->nsim_dev;
 	int vf_id = nsim_dev_port_index_to_vf_index(nsim_dev_port->port_index);
 	int err;
 
@@ -1115,7 +1123,7 @@ static int nsim_leaf_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
 	if (err)
 		return err;
 
-	nsim_bus_dev->vfconfigs[vf_id].max_tx_rate = tx_max;
+	nsim_dev->vfconfigs[vf_id].max_tx_rate = tx_max;
 	return 0;
 }
 
@@ -1271,13 +1279,12 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_type type,
 			       unsigned int port_index)
 {
-	struct nsim_bus_dev *nsim_bus_dev = nsim_dev->nsim_bus_dev;
 	struct devlink_port_attrs attrs = {};
 	struct nsim_dev_port *nsim_dev_port;
 	struct devlink_port *devlink_port;
 	int err;
 
-	if (type == NSIM_DEV_PORT_TYPE_VF && !nsim_bus_dev->num_vfs)
+	if (type == NSIM_DEV_PORT_TYPE_VF && !nsim_dev_get_vfs(nsim_dev))
 		return -EINVAL;
 
 	nsim_dev_port = kzalloc(sizeof(*nsim_dev_port), GFP_KERNEL);
@@ -1455,6 +1462,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev->switch_id.id_len = sizeof(nsim_dev->switch_id.id);
 	get_random_bytes(nsim_dev->switch_id.id, nsim_dev->switch_id.id_len);
 	INIT_LIST_HEAD(&nsim_dev->port_list);
+	mutex_init(&nsim_dev->vfs_lock);
 	mutex_init(&nsim_dev->port_list_lock);
 	nsim_dev->fw_update_status = true;
 	nsim_dev->fw_update_overwrite_mask = 0;
@@ -1464,9 +1472,17 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 
 	dev_set_drvdata(&nsim_bus_dev->dev, nsim_dev);
 
+	nsim_dev->vfconfigs = kcalloc(nsim_bus_dev->max_vfs,
+				      sizeof(struct nsim_vf_config),
+				      GFP_KERNEL | __GFP_NOWARN);
+	if (!nsim_dev->vfconfigs) {
+		err = -ENOMEM;
+		goto err_devlink_free;
+	}
+
 	err = nsim_dev_resources_register(devlink);
 	if (err)
-		goto err_devlink_free;
+		goto err_vfc_free;
 
 	err = devlink_params_register(devlink, nsim_devlink_params,
 				      ARRAY_SIZE(nsim_devlink_params));
@@ -1532,8 +1548,11 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 				  ARRAY_SIZE(nsim_devlink_params));
 err_dl_unregister:
 	devlink_resources_unregister(devlink, NULL);
+err_vfc_free:
+	kfree(nsim_dev->vfconfigs);
 err_devlink_free:
 	devlink_free(devlink);
+	dev_set_drvdata(&nsim_bus_dev->dev, NULL);
 	return err;
 }
 
@@ -1545,10 +1564,10 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 		return;
 	debugfs_remove(nsim_dev->take_snapshot);
 
-	mutex_lock(&nsim_dev->nsim_bus_dev->vfs_lock);
-	if (nsim_dev->nsim_bus_dev->num_vfs)
+	mutex_lock(&nsim_dev->vfs_lock);
+	if (nsim_dev_get_vfs(nsim_dev))
 		nsim_bus_dev_vfs_disable(nsim_dev->nsim_bus_dev);
-	mutex_unlock(&nsim_dev->nsim_bus_dev->vfs_lock);
+	mutex_unlock(&nsim_dev->vfs_lock);
 
 	nsim_dev_port_del_all(nsim_dev);
 	nsim_dev_psample_exit(nsim_dev);
@@ -1572,7 +1591,9 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
 	devlink_resources_unregister(devlink, NULL);
+	kfree(nsim_dev->vfconfigs);
 	devlink_free(devlink);
+	dev_set_drvdata(&nsim_bus_dev->dev, NULL);
 }
 
 static struct nsim_dev_port *
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 50572e0f1f52..e470e3398abc 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -82,12 +82,12 @@ nsim_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
 static int nsim_set_vf_mac(struct net_device *dev, int vf, u8 *mac)
 {
 	struct netdevsim *ns = netdev_priv(dev);
-	struct nsim_bus_dev *nsim_bus_dev = ns->nsim_bus_dev;
+	struct nsim_dev *nsim_dev = ns->nsim_dev;
 
 	/* Only refuse multicast addresses, zero address can mean unset/any. */
-	if (vf >= nsim_bus_dev->num_vfs || is_multicast_ether_addr(mac))
+	if (vf >= nsim_dev_get_vfs(nsim_dev) || is_multicast_ether_addr(mac))
 		return -EINVAL;
-	memcpy(nsim_bus_dev->vfconfigs[vf].vf_mac, mac, ETH_ALEN);
+	memcpy(nsim_dev->vfconfigs[vf].vf_mac, mac, ETH_ALEN);
 
 	return 0;
 }
@@ -96,14 +96,14 @@ static int nsim_set_vf_vlan(struct net_device *dev, int vf,
 			    u16 vlan, u8 qos, __be16 vlan_proto)
 {
 	struct netdevsim *ns = netdev_priv(dev);
-	struct nsim_bus_dev *nsim_bus_dev = ns->nsim_bus_dev;
+	struct nsim_dev *nsim_dev = ns->nsim_dev;
 
-	if (vf >= nsim_bus_dev->num_vfs || vlan > 4095 || qos > 7)
+	if (vf >= nsim_dev_get_vfs(nsim_dev) || vlan > 4095 || qos > 7)
 		return -EINVAL;
 
-	nsim_bus_dev->vfconfigs[vf].vlan = vlan;
-	nsim_bus_dev->vfconfigs[vf].qos = qos;
-	nsim_bus_dev->vfconfigs[vf].vlan_proto = vlan_proto;
+	nsim_dev->vfconfigs[vf].vlan = vlan;
+	nsim_dev->vfconfigs[vf].qos = qos;
+	nsim_dev->vfconfigs[vf].vlan_proto = vlan_proto;
 
 	return 0;
 }
@@ -111,18 +111,18 @@ static int nsim_set_vf_vlan(struct net_device *dev, int vf,
 static int nsim_set_vf_rate(struct net_device *dev, int vf, int min, int max)
 {
 	struct netdevsim *ns = netdev_priv(dev);
-	struct nsim_bus_dev *nsim_bus_dev = ns->nsim_bus_dev;
+	struct nsim_dev *nsim_dev = ns->nsim_dev;
 
 	if (nsim_esw_mode_is_switchdev(ns->nsim_dev)) {
 		pr_err("Not supported in switchdev mode. Please use devlink API.\n");
 		return -EOPNOTSUPP;
 	}
 
-	if (vf >= nsim_bus_dev->num_vfs)
+	if (vf >= nsim_dev_get_vfs(nsim_dev))
 		return -EINVAL;
 
-	nsim_bus_dev->vfconfigs[vf].min_tx_rate = min;
-	nsim_bus_dev->vfconfigs[vf].max_tx_rate = max;
+	nsim_dev->vfconfigs[vf].min_tx_rate = min;
+	nsim_dev->vfconfigs[vf].max_tx_rate = max;
 
 	return 0;
 }
@@ -130,11 +130,11 @@ static int nsim_set_vf_rate(struct net_device *dev, int vf, int min, int max)
 static int nsim_set_vf_spoofchk(struct net_device *dev, int vf, bool val)
 {
 	struct netdevsim *ns = netdev_priv(dev);
-	struct nsim_bus_dev *nsim_bus_dev = ns->nsim_bus_dev;
+	struct nsim_dev *nsim_dev = ns->nsim_dev;
 
-	if (vf >= nsim_bus_dev->num_vfs)
+	if (vf >= nsim_dev_get_vfs(nsim_dev))
 		return -EINVAL;
-	nsim_bus_dev->vfconfigs[vf].spoofchk_enabled = val;
+	nsim_dev->vfconfigs[vf].spoofchk_enabled = val;
 
 	return 0;
 }
@@ -142,11 +142,11 @@ static int nsim_set_vf_spoofchk(struct net_device *dev, int vf, bool val)
 static int nsim_set_vf_rss_query_en(struct net_device *dev, int vf, bool val)
 {
 	struct netdevsim *ns = netdev_priv(dev);
-	struct nsim_bus_dev *nsim_bus_dev = ns->nsim_bus_dev;
+	struct nsim_dev *nsim_dev = ns->nsim_dev;
 
-	if (vf >= nsim_bus_dev->num_vfs)
+	if (vf >= nsim_dev_get_vfs(nsim_dev))
 		return -EINVAL;
-	nsim_bus_dev->vfconfigs[vf].rss_query_enabled = val;
+	nsim_dev->vfconfigs[vf].rss_query_enabled = val;
 
 	return 0;
 }
@@ -154,11 +154,11 @@ static int nsim_set_vf_rss_query_en(struct net_device *dev, int vf, bool val)
 static int nsim_set_vf_trust(struct net_device *dev, int vf, bool val)
 {
 	struct netdevsim *ns = netdev_priv(dev);
-	struct nsim_bus_dev *nsim_bus_dev = ns->nsim_bus_dev;
+	struct nsim_dev *nsim_dev = ns->nsim_dev;
 
-	if (vf >= nsim_bus_dev->num_vfs)
+	if (vf >= nsim_dev_get_vfs(nsim_dev))
 		return -EINVAL;
-	nsim_bus_dev->vfconfigs[vf].trusted = val;
+	nsim_dev->vfconfigs[vf].trusted = val;
 
 	return 0;
 }
@@ -167,22 +167,22 @@ static int
 nsim_get_vf_config(struct net_device *dev, int vf, struct ifla_vf_info *ivi)
 {
 	struct netdevsim *ns = netdev_priv(dev);
-	struct nsim_bus_dev *nsim_bus_dev = ns->nsim_bus_dev;
+	struct nsim_dev *nsim_dev = ns->nsim_dev;
 
-	if (vf >= nsim_bus_dev->num_vfs)
+	if (vf >= nsim_dev_get_vfs(nsim_dev))
 		return -EINVAL;
 
 	ivi->vf = vf;
-	ivi->linkstate = nsim_bus_dev->vfconfigs[vf].link_state;
-	ivi->min_tx_rate = nsim_bus_dev->vfconfigs[vf].min_tx_rate;
-	ivi->max_tx_rate = nsim_bus_dev->vfconfigs[vf].max_tx_rate;
-	ivi->vlan = nsim_bus_dev->vfconfigs[vf].vlan;
-	ivi->vlan_proto = nsim_bus_dev->vfconfigs[vf].vlan_proto;
-	ivi->qos = nsim_bus_dev->vfconfigs[vf].qos;
-	memcpy(&ivi->mac, nsim_bus_dev->vfconfigs[vf].vf_mac, ETH_ALEN);
-	ivi->spoofchk = nsim_bus_dev->vfconfigs[vf].spoofchk_enabled;
-	ivi->trusted = nsim_bus_dev->vfconfigs[vf].trusted;
-	ivi->rss_query_en = nsim_bus_dev->vfconfigs[vf].rss_query_enabled;
+	ivi->linkstate = nsim_dev->vfconfigs[vf].link_state;
+	ivi->min_tx_rate = nsim_dev->vfconfigs[vf].min_tx_rate;
+	ivi->max_tx_rate = nsim_dev->vfconfigs[vf].max_tx_rate;
+	ivi->vlan = nsim_dev->vfconfigs[vf].vlan;
+	ivi->vlan_proto = nsim_dev->vfconfigs[vf].vlan_proto;
+	ivi->qos = nsim_dev->vfconfigs[vf].qos;
+	memcpy(&ivi->mac, nsim_dev->vfconfigs[vf].vf_mac, ETH_ALEN);
+	ivi->spoofchk = nsim_dev->vfconfigs[vf].spoofchk_enabled;
+	ivi->trusted = nsim_dev->vfconfigs[vf].trusted;
+	ivi->rss_query_en = nsim_dev->vfconfigs[vf].rss_query_enabled;
 
 	return 0;
 }
@@ -190,9 +190,9 @@ nsim_get_vf_config(struct net_device *dev, int vf, struct ifla_vf_info *ivi)
 static int nsim_set_vf_link_state(struct net_device *dev, int vf, int state)
 {
 	struct netdevsim *ns = netdev_priv(dev);
-	struct nsim_bus_dev *nsim_bus_dev = ns->nsim_bus_dev;
+	struct nsim_dev *nsim_dev = ns->nsim_dev;
 
-	if (vf >= nsim_bus_dev->num_vfs)
+	if (vf >= nsim_dev_get_vfs(nsim_dev))
 		return -EINVAL;
 
 	switch (state) {
@@ -204,7 +204,7 @@ static int nsim_set_vf_link_state(struct net_device *dev, int vf, int state)
 		return -EINVAL;
 	}
 
-	nsim_bus_dev->vfconfigs[vf].link_state = state;
+	nsim_dev->vfconfigs[vf].link_state = state;
 
 	return 0;
 }
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index ec9939fba534..b4b287cdfe77 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -217,6 +217,19 @@ struct nsim_dev_port {
 	struct netdevsim *ns;
 };
 
+struct nsim_vf_config {
+	int link_state;
+	u16 min_tx_rate;
+	u16 max_tx_rate;
+	u16 vlan;
+	__be16 vlan_proto;
+	u16 qos;
+	u8 vf_mac[ETH_ALEN];
+	bool spoofchk_enabled;
+	bool trusted;
+	bool rss_query_enabled;
+};
+
 struct nsim_dev {
 	struct nsim_bus_dev *nsim_bus_dev;
 	struct nsim_fib_data *fib_data;
@@ -225,6 +238,10 @@ struct nsim_dev {
 	struct dentry *ports_ddir;
 	struct dentry *take_snapshot;
 	struct dentry *nodes_ddir;
+
+	struct mutex vfs_lock;  /* Protects vfconfigs */
+	struct nsim_vf_config *vfconfigs;
+
 	struct bpf_offload_dev *bpf_dev;
 	bool bpf_bind_accept;
 	bool bpf_bind_verifier_accept;
@@ -293,6 +310,8 @@ int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
 		      enum nsim_dev_port_type type,
 		      unsigned int port_index);
 
+unsigned int nsim_dev_get_vfs(struct nsim_dev *nsim_dev);
+
 struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 				      struct netlink_ext_ack *extack);
 void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *fib_data);
@@ -335,19 +354,6 @@ static inline bool nsim_ipsec_tx(struct netdevsim *ns, struct sk_buff *skb)
 }
 #endif
 
-struct nsim_vf_config {
-	int link_state;
-	u16 min_tx_rate;
-	u16 max_tx_rate;
-	u16 vlan;
-	__be16 vlan_proto;
-	u16 qos;
-	u8 vf_mac[ETH_ALEN];
-	bool spoofchk_enabled;
-	bool trusted;
-	bool rss_query_enabled;
-};
-
 struct nsim_bus_dev {
 	struct device dev;
 	struct list_head list;
@@ -358,8 +364,6 @@ struct nsim_bus_dev {
 				  */
 	unsigned int max_vfs;
 	unsigned int num_vfs;
-	struct mutex vfs_lock;  /* Protects vfconfigs */
-	struct nsim_vf_config *vfconfigs;
 	/* Lock for devlink->reload_enabled in netdevsim module */
 	struct mutex nsim_bus_reload_lock;
 	bool in_reload;
-- 
2.31.1


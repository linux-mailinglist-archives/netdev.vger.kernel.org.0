Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6B3F3440
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389579AbfKGQJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:09:20 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53587 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389554AbfKGQJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:09:19 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:09:16 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4L007213;
        Thu, 7 Nov 2019 18:09:14 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 11/19] vfio/mdev: Improvise mdev life cycle and parent removal scheme
Date:   Thu,  7 Nov 2019 10:08:26 -0600
Message-Id: <20191107160834.21087-11-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191107160834.21087-1-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mdev creation and removal sequence synchronization with parent device
removal is improved in [1].

However such improvement using semaphore either limiting or leads to
complex locking scheme when used across multiple subsystem such as mdev
and devlink.

When mdev devices are used with devlink eswitch device, following
deadlock sequence can be witnessed.

mlx5_core 0000:06:00.0: E-Switch: Disable: mode(OFFLOADS), nvfs(4), active vports(5)
mlx5_core 0000:06:00.0: MDEV: Unregistering

WARNING: possible circular locking dependency detected
------------------------------------------------------
devlink/42094 is trying to acquire lock:
00000000eb6fb4c7 (&parent->unreg_sem){++++}, at: mdev_unregister_device+0xf1/0x160 [mdev]
012but task is already holding lock:
00000000efcd208e (devlink_mutex){+.+.}, at: devlink_nl_pre_doit+0x1d/0x170
012which lock already depends on the new lock.
012the existing dependency chain (in reverse order) is:
012-> #1 (devlink_mutex){+.+.}:
      lock_acquire+0xbd/0x1a0
      __mutex_lock+0x84/0x8b0
      devlink_unregister+0x17/0x60
      mlx5_sf_unload+0x21/0x60 [mlx5_core]
      mdev_remove+0x1e/0x40 [mdev]
      device_release_driver_internal+0xdc/0x1a0
      bus_remove_device+0xef/0x160
      device_del+0x163/0x360
      mdev_device_remove_common+0x1e/0xa0 [mdev]
      mdev_device_remove+0x8d/0xd0 [mdev]
      remove_store+0x71/0x90 [mdev]
      kernfs_fop_write+0x113/0x1a0
      vfs_write+0xad/0x1b0
      ksys_write+0x5c/0xd0
      do_syscall_64+0x5a/0x270
      entry_SYSCALL_64_after_hwframe+0x49/0xbe
012-> #0 (&parent->unreg_sem){++++}:
      check_prev_add+0xb0/0x810
      __lock_acquire+0xd4b/0x1090
      lock_acquire+0xbd/0x1a0
      down_write+0x33/0x70
      mdev_unregister_device+0xf1/0x160 [mdev]
      esw_offloads_disable+0xe/0x70 [mlx5_core]
      mlx5_eswitch_disable+0x149/0x190 [mlx5_core]
      mlx5_devlink_eswitch_mode_set+0xd0/0x180 [mlx5_core]
      devlink_nl_cmd_eswitch_set_doit+0x3e/0xb0
      genl_family_rcv_msg+0x3a2/0x420
      genl_rcv_msg+0x47/0x90
      netlink_rcv_skb+0xc9/0x100
      genl_rcv+0x24/0x40
      netlink_unicast+0x179/0x220
      netlink_sendmsg+0x2f6/0x3f0
      sock_sendmsg+0x30/0x40
      __sys_sendto+0xdc/0x160
      __x64_sys_sendto+0x24/0x30
      do_syscall_64+0x5a/0x270
      entry_SYSCALL_64_after_hwframe+0x49/0xbe
Possible unsafe locking scenario:
      CPU0                    CPU1
      ----                    ----
 lock(devlink_mutex);
                              lock(&parent->unreg_sem);
                              lock(devlink_mutex);
 lock(&parent->unreg_sem);
012 *** DEADLOCK ***
3 locks held by devlink/42094:
0: 0000000097a0c4aa (cb_lock){++++}, at: genl_rcv+0x15/0x40
1: 00000000baf61ad2 (genl_mutex){+.+.}, at: genl_rcv_msg+0x66/0x90
2: 00000000efcd208e (devlink_mutex){+.+.}, at: devlink_nl_pre_doit+0x1d/0x170

To summarize,
mdev_remove()
  read locks -> unreg_sem [ lock-A ]
  [..]
  devlink_unregister();
    mutex lock devlink_mutex [ lock-B ]

devlink eswitch->switchdev-legacy mode change.
 devlink_nl_cmd_eswitch_set_doit()
   mutex lock devlink_mutex [ lock-B ]
   mdev_unregister_device()
   write locks -> unreg_sem [ lock-A]

Hence, instead of using semaphore, such synchronization is achieved
using srcu which is more flexible that eliminates nested locking.

SRCU based solution is already proposed before at [2].

[1] commit 5715c4dd66a3 ("vfio/mdev: Synchronize device create/remove with parent removal")
[2] https://lore.kernel.org/patchwork/patch/1055254/

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/vfio/mdev/mdev_core.c    | 56 +++++++++++++++++++++++---------
 drivers/vfio/mdev/mdev_private.h |  3 +-
 2 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 9eec556fbdd4..41225e6ccc20 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -85,6 +85,7 @@ static void mdev_release_parent(struct kref *kref)
 						  ref);
 	struct device *dev = parent->dev;
 
+	cleanup_srcu_struct(&parent->unreg_srcu);
 	kfree(parent);
 	put_device(dev);
 }
@@ -114,7 +115,6 @@ static void mdev_device_remove_common(struct mdev_device *mdev)
 	mdev_remove_sysfs_files(&mdev->dev, type);
 	device_del(&mdev->dev);
 	parent = mdev->parent;
-	lockdep_assert_held(&parent->unreg_sem);
 	ret = parent->ops->remove(mdev);
 	if (ret)
 		dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
@@ -185,7 +185,7 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
 	}
 
 	kref_init(&parent->ref);
-	init_rwsem(&parent->unreg_sem);
+	init_srcu_struct(&parent->unreg_srcu);
 
 	parent->dev = dev;
 	parent->ops = ops;
@@ -207,6 +207,7 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
 		dev_warn(dev, "Failed to create compatibility class link\n");
 
 	list_add(&parent->next, &parent_list);
+	rcu_assign_pointer(parent->self, parent);
 	mutex_unlock(&parent_list_lock);
 
 	dev_info(dev, "MDEV: Registered\n");
@@ -250,14 +251,29 @@ void mdev_unregister_device(struct device *dev)
 	list_del(&parent->next);
 	mutex_unlock(&parent_list_lock);
 
-	down_write(&parent->unreg_sem);
+	/*
+	 * Publish that this mdev parent is unregistering. So any new
+	 * create/remove cannot start on this parent anymore by user.
+	 */
+	rcu_assign_pointer(parent->self, NULL);
+
+	/*
+	 * Wait for any active create() or remove() mdev ops on the parent
+	 * to complete.
+	 */
+	synchronize_srcu(&parent->unreg_srcu);
+
+	/*
+	 * At this point it is confirmed that any pending user initiated
+	 * create or remove callbacks accessing the parent are completed.
+	 * It is safe to remove the parent now.
+	 */
 
 	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
 
 	device_for_each_child(dev, NULL, mdev_device_remove_cb);
 
 	parent_remove_sysfs_files(parent);
-	up_write(&parent->unreg_sem);
 
 	mdev_put_parent(parent);
 
@@ -358,15 +374,25 @@ int mdev_device_create(struct kobject *kobj, struct device *dev,
 		       const char *uuid_str, const guid_t *uuid)
 {
 	int ret;
+	struct mdev_parent *valid_parent;
 	struct mdev_device *mdev, *tmp;
 	struct mdev_parent *parent;
 	struct mdev_type *type = to_mdev_type(kobj);
 	const char *alias = NULL;
+	int srcu_idx;
 
 	parent = mdev_get_parent(type->parent);
 	if (!parent)
 		return -EINVAL;
 
+	srcu_idx = srcu_read_lock(&parent->unreg_srcu);
+	valid_parent = srcu_dereference(parent->self, &parent->unreg_srcu);
+	if (!valid_parent) {
+		/* Parent is undergoing unregistration */
+		ret = -ENODEV;
+		goto alias_fail;
+	}
+
 	if (parent->ops->get_alias_length) {
 		unsigned int alias_len;
 
@@ -416,13 +442,6 @@ int mdev_device_create(struct kobject *kobj, struct device *dev,
 
 	mdev->parent = parent;
 
-	/* Check if parent unregistration has started */
-	if (!down_read_trylock(&parent->unreg_sem)) {
-		mdev_device_free(mdev);
-		ret = -ENODEV;
-		goto mdev_fail;
-	}
-
 	device_initialize(&mdev->dev);
 	mdev->dev.parent  = dev;
 	mdev->dev.bus     = &mdev_bus_type;
@@ -445,7 +464,7 @@ int mdev_device_create(struct kobject *kobj, struct device *dev,
 
 	mdev->active = true;
 	dev_dbg(&mdev->dev, "MDEV: created\n");
-	up_read(&parent->unreg_sem);
+	srcu_read_unlock(&parent->unreg_srcu, srcu_idx);
 
 	return 0;
 
@@ -454,19 +473,21 @@ int mdev_device_create(struct kobject *kobj, struct device *dev,
 add_fail:
 	parent->ops->remove(mdev);
 ops_create_fail:
-	up_read(&parent->unreg_sem);
 	put_device(&mdev->dev);
 mdev_fail:
 	kfree(alias);
 alias_fail:
+	srcu_read_unlock(&parent->unreg_srcu, srcu_idx);
 	mdev_put_parent(parent);
 	return ret;
 }
 
 int mdev_device_remove(struct device *dev)
 {
+	struct mdev_parent *valid_parent;
 	struct mdev_device *mdev, *tmp;
 	struct mdev_parent *parent;
+	int srcu_idx;
 
 	mdev = to_mdev_device(dev);
 
@@ -491,11 +512,16 @@ int mdev_device_remove(struct device *dev)
 
 	parent = mdev->parent;
 	/* Check if parent unregistration has started */
-	if (!down_read_trylock(&parent->unreg_sem))
+	srcu_idx = srcu_read_lock(&parent->unreg_srcu);
+	valid_parent = srcu_dereference(parent->self, &parent->unreg_srcu);
+	if (!valid_parent) {
+		srcu_read_unlock(&parent->unreg_srcu, srcu_idx);
+		/* Parent is undergoing unregistration */
 		return -ENODEV;
+	}
 
 	mdev_device_remove_common(mdev);
-	up_read(&parent->unreg_sem);
+	srcu_read_unlock(&parent->unreg_srcu, srcu_idx);
 	return 0;
 }
 
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 078fdaf7836e..730b1cb24cbc 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -21,7 +21,8 @@ struct mdev_parent {
 	struct kset *mdev_types_kset;
 	struct list_head type_list;
 	/* Synchronize device creation/removal with parent unregistration */
-	struct rw_semaphore unreg_sem;
+	struct srcu_struct unreg_srcu;
+	struct mdev_parent __rcu *self;
 };
 
 struct mdev_device {
-- 
2.19.2


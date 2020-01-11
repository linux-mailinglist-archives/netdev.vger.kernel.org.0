Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10869138276
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 17:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbgAKQhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 11:37:07 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44381 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729957AbgAKQhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 11:37:07 -0500
Received: by mail-pf1-f194.google.com with SMTP id 195so2673663pfw.11
        for <netdev@vger.kernel.org>; Sat, 11 Jan 2020 08:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Wl3J61ipERBRNCdazwxQf7hcB4cULT96jVvEY5NQo5A=;
        b=ZOFPU76bOwAFH2Iiso3LUT4r8sWChV4wV0H/soevINqyPLTpvMiIuWuxZuDUgRCS7D
         63CZAa+jekxSv6NmWQEVLLY/LNikYu3akG4aTPPbuu96HTXsLMhaWBpI3fYpTnWmJSYQ
         BxK0nxJFiWeVhN2gecVpus69DiDbqW5qbsAT+atbDKJEy7Mo1M8GtJpTUN9/V8XLWRcu
         cHxH12YdoBhTHuQZF/TkYZpSuPiZle1DA3ZbKv4r88yThdBQnG2K3O1C/QbbebpRPUu2
         n0leAdw8i0w1oVg3fQXA591Tm0mBBiWK5tCiEw5DhrCPv+tCdCPFLDzsqnSoXpOXS0oG
         8dPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Wl3J61ipERBRNCdazwxQf7hcB4cULT96jVvEY5NQo5A=;
        b=RuCtzyXyOEGSnybSVssW9JkZPdHMXONg7RSaf/mK1AWbL7/Jk/v6rh1xSHimZshdII
         4mbXIUIXvbQlxz0FRyhee/jbGbboifGvUDrvcfMuS9PGQ6r4xH9MtJ3Ns0Pws3lbXUbD
         qOLz9e/OFd+6fv/vLz9UQP6l1jGkcrg+sGqB6LXnCQ6upFaQ/I1auVDHaHvjnQcOylkl
         SCsEfxajfIj2dadTvw2ordSiWtej/b1MOhlb6rk809PMoMNi1m8W9WWfTH0JrBcGEPk6
         ine12573ADynNZa+TgF7DyrObHPPtvUsLAqoKpcvYSOcbmYfnXmHr2RmS7oN3h9ghmLj
         ZMUw==
X-Gm-Message-State: APjAAAWcR5mLXtCSpdd091s25d70WdII+QsUiKLs0AS1tPtIrdgCCdFB
        9F8pT+WJTybOrK4ukLiAyDnvUB4y
X-Google-Smtp-Source: APXvYqwRi2b1WEJVzRCSOVC7PcGOf1e2iDo4PzD6fSk/5gyhmHQ/wlqkgiR/5QFIBmJ3Rxc2/Pd+Yg==
X-Received: by 2002:aa7:95a9:: with SMTP id a9mr10976588pfk.15.1578760625698;
        Sat, 11 Jan 2020 08:37:05 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id i4sm7159505pgc.51.2020.01.11.08.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 08:37:04 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 1/5] netdevsim: fix a race condition in netdevsim operations
Date:   Sat, 11 Jan 2020 16:36:55 +0000
Message-Id: <20200111163655.4087-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdevsim basic operations are called with sysfs.

Create netdevsim device:
echo "1 1" > /sys/bus/netdevsim/new_device
Delete netdevsim device:
echo 1 > /sys/bus/netdevsim/del_device
Create netdevsim port:
echo 4 > /sys/devices/netdevsim1/new_port
Delete netdevsim port:
echo 4 > /sys/devices/netdevsim1/del_port
Set sriov number:
echo 4 > /sys/devices/netdevsim1/sriov_numvfs

These operations use the same resource so they should acquire a lock for
the whole resource not only for a list.

Test commands:
    #SHELL1
    modprobe netdevsim
    while :
    do
        echo "1 1" > /sys/bus/netdevsim/new_device
        echo "1 1" > /sys/bus/netdevsim/del_device
    done

    #SHELL2
    while :
    do
        echo 1 > /sys/devices/netdevsim1/new_port
        echo 1 > /sys/devices/netdevsim1/del_port
    done

Splat looks like:
[  151.623634][ T1165] kasan: CONFIG_KASAN_INLINE enabled
[  151.626503][ T1165] kasan: GPF could be caused by NULL-ptr deref or user memory access
[  151.627862][ T1165] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  151.630700][ T1165] CPU: 3 PID: 1165 Comm: bash Not tainted 5.5.0-rc5+ #270
[  151.633339][ T1165] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  151.635758][ T1165] RIP: 0010:__mutex_lock+0x10a/0x14b0
[  151.636713][ T1165] Code: 08 84 d2 0f 85 7f 12 00 00 44 8b 0d 20 66 67 02 45 85 c9 75 29 49 8d 7f 68 48 b8 00 f
[  151.641725][ T1165] RSP: 0018:ffff8880b17cfbb0 EFLAGS: 00010206
[  151.642547][ T1165] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  151.643636][ T1165] RDX: 0000000000000021 RSI: ffffffffbb922c00 RDI: 0000000000000108
[  151.645415][ T1165] RBP: ffff8880b17cfd30 R08: ffffffffc0392ad0 R09: 0000000000000000
[  151.646803][ T1165] R10: ffff8880b17cfd50 R11: ffff8880a9225440 R12: 0000000000000000
[  151.647846][ T1165] R13: dffffc0000000000 R14: ffffffffbd16e7c0 R15: 00000000000000a0
[  151.651979][ T1165] FS:  00007f9731c8e740(0000) GS:ffff8880da800000(0000) knlGS:0000000000000000
[  151.655905][ T1165] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  151.656828][ T1165] CR2: 000055be472e1140 CR3: 00000000b1e14005 CR4: 00000000000606e0
[  151.657906][ T1165] Call Trace:
[  151.658346][ T1165]  ? nsim_dev_port_add+0x50/0x150 [netdevsim]
[  151.659146][ T1165]  ? mutex_lock_io_nested+0x1380/0x1380
[  151.659902][ T1165]  ? _kstrtoull+0x76/0x160
[  151.660480][ T1165]  ? _parse_integer+0xf0/0xf0
[  151.661097][ T1165]  ? kernfs_fop_write+0x1cf/0x410
[  151.661751][ T1165]  ? sysfs_file_ops+0x160/0x160
[  151.662389][ T1165]  ? kstrtouint+0x86/0x110
[  151.662972][ T1165]  ? nsim_dev_port_add+0x50/0x150 [netdevsim]
[  151.663768][ T1165]  nsim_dev_port_add+0x50/0x150 [netdevsim]
[ ... ]

In this patch, __init and __exit function also acquire a lock.
operations could be called while __init and __exit functions are
processing. If so, uninitialized or freed resources could be used.
So, __init() and __exit function also need lock.

Fixes: 83c9e13aa39a ("netdevsim: add software driver for testing offloads")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/netdevsim/bus.c       | 64 ++++++++++++++++++++++++-------
 drivers/net/netdevsim/dev.c       | 20 +++++++++-
 drivers/net/netdevsim/netdevsim.h |  2 +
 3 files changed, 71 insertions(+), 15 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 6aeed0c600f8..b40e4e70995d 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -16,7 +16,8 @@
 
 static DEFINE_IDA(nsim_bus_dev_ids);
 static LIST_HEAD(nsim_bus_dev_list);
-static DEFINE_MUTEX(nsim_bus_dev_list_lock);
+/* mutex lock for netdevsim operations */
+DEFINE_MUTEX(nsim_bus_dev_ops_lock);
 
 static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
 {
@@ -51,9 +52,14 @@ nsim_bus_dev_numvfs_store(struct device *dev, struct device_attribute *attr,
 	unsigned int num_vfs;
 	int ret;
 
+	if (!mutex_trylock(&nsim_bus_dev_ops_lock))
+		return -EBUSY;
+
 	ret = kstrtouint(buf, 0, &num_vfs);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&nsim_bus_dev_ops_lock);
 		return ret;
+	}
 
 	rtnl_lock();
 	if (nsim_bus_dev->num_vfs == num_vfs)
@@ -74,6 +80,7 @@ nsim_bus_dev_numvfs_store(struct device *dev, struct device_attribute *attr,
 	ret = count;
 exit_unlock:
 	rtnl_unlock();
+	mutex_unlock(&nsim_bus_dev_ops_lock);
 
 	return ret;
 }
@@ -83,8 +90,13 @@ nsim_bus_dev_numvfs_show(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
 	struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
+	int ret;
 
-	return sprintf(buf, "%u\n", nsim_bus_dev->num_vfs);
+	if (!mutex_trylock(&nsim_bus_dev_ops_lock))
+		return -EBUSY;
+	ret = sprintf(buf, "%u\n", nsim_bus_dev->num_vfs);
+	mutex_unlock(&nsim_bus_dev_ops_lock);
+	return ret;
 }
 
 static struct device_attribute nsim_bus_dev_numvfs_attr =
@@ -99,10 +111,15 @@ new_port_store(struct device *dev, struct device_attribute *attr,
 	unsigned int port_index;
 	int ret;
 
+	if (!mutex_trylock(&nsim_bus_dev_ops_lock))
+		return -EBUSY;
 	ret = kstrtouint(buf, 0, &port_index);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&nsim_bus_dev_ops_lock);
 		return ret;
+	}
 	ret = nsim_dev_port_add(nsim_bus_dev, port_index);
+	mutex_unlock(&nsim_bus_dev_ops_lock);
 	return ret ? ret : count;
 }
 
@@ -116,10 +133,17 @@ del_port_store(struct device *dev, struct device_attribute *attr,
 	unsigned int port_index;
 	int ret;
 
+	if (!mutex_trylock(&nsim_bus_dev_ops_lock))
+		return -EBUSY;
+
 	ret = kstrtouint(buf, 0, &port_index);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&nsim_bus_dev_ops_lock);
 		return ret;
+	}
+
 	ret = nsim_dev_port_del(nsim_bus_dev, port_index);
+	mutex_unlock(&nsim_bus_dev_ops_lock);
 	return ret ? ret : count;
 }
 
@@ -179,13 +203,17 @@ new_device_store(struct bus_type *bus, const char *buf, size_t count)
 		pr_err("Format for adding new device is \"id port_count\" (uint uint).\n");
 		return -EINVAL;
 	}
+
+	if (!mutex_trylock(&nsim_bus_dev_ops_lock))
+		return -EBUSY;
 	nsim_bus_dev = nsim_bus_dev_new(id, port_count);
-	if (IS_ERR(nsim_bus_dev))
+	if (IS_ERR(nsim_bus_dev)) {
+		mutex_unlock(&nsim_bus_dev_ops_lock);
 		return PTR_ERR(nsim_bus_dev);
+	}
 
-	mutex_lock(&nsim_bus_dev_list_lock);
 	list_add_tail(&nsim_bus_dev->list, &nsim_bus_dev_list);
-	mutex_unlock(&nsim_bus_dev_list_lock);
+	mutex_unlock(&nsim_bus_dev_ops_lock);
 
 	return count;
 }
@@ -214,7 +242,8 @@ del_device_store(struct bus_type *bus, const char *buf, size_t count)
 	}
 
 	err = -ENOENT;
-	mutex_lock(&nsim_bus_dev_list_lock);
+	if (!mutex_trylock(&nsim_bus_dev_ops_lock))
+		return -EBUSY;
 	list_for_each_entry_safe(nsim_bus_dev, tmp, &nsim_bus_dev_list, list) {
 		if (nsim_bus_dev->dev.id != id)
 			continue;
@@ -223,7 +252,7 @@ del_device_store(struct bus_type *bus, const char *buf, size_t count)
 		err = 0;
 		break;
 	}
-	mutex_unlock(&nsim_bus_dev_list_lock);
+	mutex_unlock(&nsim_bus_dev_ops_lock);
 	return !err ? count : err;
 }
 static BUS_ATTR_WO(del_device);
@@ -314,12 +343,19 @@ int nsim_bus_init(void)
 {
 	int err;
 
+	mutex_lock(&nsim_bus_dev_ops_lock);
 	err = bus_register(&nsim_bus);
-	if (err)
+	if (err) {
+		mutex_unlock(&nsim_bus_dev_ops_lock);
 		return err;
+	}
 	err = driver_register(&nsim_driver);
-	if (err)
+	if (err) {
+		mutex_unlock(&nsim_bus_dev_ops_lock);
 		goto err_bus_unregister;
+	}
+
+	mutex_unlock(&nsim_bus_dev_ops_lock);
 	return 0;
 
 err_bus_unregister:
@@ -331,12 +367,12 @@ void nsim_bus_exit(void)
 {
 	struct nsim_bus_dev *nsim_bus_dev, *tmp;
 
-	mutex_lock(&nsim_bus_dev_list_lock);
+	mutex_lock(&nsim_bus_dev_ops_lock);
 	list_for_each_entry_safe(nsim_bus_dev, tmp, &nsim_bus_dev_list, list) {
 		list_del(&nsim_bus_dev->list);
 		nsim_bus_dev_del(nsim_bus_dev);
 	}
-	mutex_unlock(&nsim_bus_dev_list_lock);
 	driver_unregister(&nsim_driver);
 	bus_unregister(&nsim_bus);
+	mutex_unlock(&nsim_bus_dev_ops_lock);
 }
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 059711edfc61..634eb5cdcbbe 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -43,13 +43,24 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 					    size_t count, loff_t *ppos)
 {
 	struct nsim_dev *nsim_dev = file->private_data;
+	struct devlink *devlink;
 	void *dummy_data;
 	int err;
 	u32 id;
 
+	devlink = priv_to_devlink(nsim_dev);
+
+	if (!mutex_trylock(&nsim_bus_dev_ops_lock))
+		return -EBUSY;
+
+	devlink_reload_disable(devlink);
+
 	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
-	if (!dummy_data)
+	if (!dummy_data) {
+		devlink_reload_enable(devlink);
+		mutex_unlock(&nsim_bus_dev_ops_lock);
 		return -ENOMEM;
+	}
 
 	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
 
@@ -59,9 +70,13 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 	if (err) {
 		pr_err("Failed to create region snapshot\n");
 		kfree(dummy_data);
+		devlink_reload_enable(devlink);
+		mutex_unlock(&nsim_bus_dev_ops_lock);
 		return err;
 	}
 
+	devlink_reload_enable(devlink);
+	mutex_unlock(&nsim_bus_dev_ops_lock);
 	return count;
 }
 
@@ -909,9 +924,12 @@ int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
 		      unsigned int port_index)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
+	struct devlink *devlink = priv_to_devlink(nsim_dev);
 	struct nsim_dev_port *nsim_dev_port;
 	int err = 0;
 
+	devlink_reload_disable(devlink);
+
 	mutex_lock(&nsim_dev->port_list_lock);
 	nsim_dev_port = __nsim_dev_port_lookup(nsim_dev, port_index);
 	if (!nsim_dev_port)
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 94df795ef4d3..6a7cfd2319df 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -30,6 +30,8 @@
 #define NSIM_IPSEC_MAX_SA_COUNT		33
 #define NSIM_IPSEC_VALID		BIT(31)
 
+extern struct mutex nsim_bus_dev_ops_lock;
+
 struct nsim_sa {
 	struct xfrm_state *xs;
 	__be32 ipaddr[4];
-- 
2.17.1


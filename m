Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85AE314F8FC
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 17:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgBAQnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 11:43:04 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:53811 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgBAQnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 11:43:04 -0500
Received: by mail-pj1-f68.google.com with SMTP id n96so4332419pjc.3
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 08:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BJy5LHDWfNNObO1N5uMOENAx8xzi0RQXy8anhAlI5Qo=;
        b=qPITDH8bJaGgyfa1QzWObgajZmf7No22N713RtY2ABm2yBsOWYzWFMBMnKWn3ZNRZY
         vDuEOgtOJ5OTe9e1HPKBpXZW0FHOczfjYZ1fLuptOi9Be//EOG1Qhhaypjv2n/XmcELu
         0QsGuN27WgpivBBS2OMJd6S0RIhlqb3tM1Isqf3S0ts+HlnCbK2sLsavVlVNGLElM4kX
         PrEc6amwHwvxu1QrGinLavqN15u2R7hWWMMY3SC5chTosMmTurNvp581ZYsRxn+C1eJc
         ezG1YNClF1qsSKAaeL6+idzakMLZiDx6S6JiRmXgd+YTbfavZl/evpzheUNXvx1bQZkC
         wB4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BJy5LHDWfNNObO1N5uMOENAx8xzi0RQXy8anhAlI5Qo=;
        b=mY28iln0WssCKnt6jK0JLOI3aKHS8NsSYuf/6gh0BUmR+j29SmsbpnPc+IXiVmU8G/
         hx5litH4I+J9ZHFeLI3RomU0ew83yPAfkeMyHQnlrf9imI027ncoedc8dd+frPiJJtfP
         rYCI8ubi+amfGRs2/Zp0pNmYipQRTYqmBKs6v1gZOU1lrLNxGrnBQ53wi9n0+BqaDX7b
         Qz66vkHHVP7MxTRbVKgMRhOAKdr2aaaD35JefFogr79MGDFHyXEVyzpEatcBxV6wvjPq
         ZKT13S7l2frHAHzFiBv2ZRSYFyS7NtQ/l8tN+IGsDQ26XbU9RwjCKQhGF4QoCx2ZpYyk
         zMEA==
X-Gm-Message-State: APjAAAUC/DIyFXoh3tLgNk/Q3n4iHK1c/9dqoHRMDSJArV5q38bcTcoH
        d+dUXYlzpITLPFYvwI39HCQZIP6e
X-Google-Smtp-Source: APXvYqwjY/MMD/QFRbNqDGQK1Qdj+RVxgrCZk4PfWyB9GKwlSpKU3wB8OWkDn/MUfXbMcs+m/ZotfQ==
X-Received: by 2002:a17:90a:a88d:: with SMTP id h13mr19282723pjq.48.1580575382213;
        Sat, 01 Feb 2020 08:43:02 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id 76sm14886514pfx.97.2020.02.01.08.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 08:43:01 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 1/7] netdevsim: fix using uninitialized resources
Date:   Sat,  1 Feb 2020 16:42:54 +0000
Message-Id: <20200201164254.9828-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When module is being initialized, __init() calls bus_register() and
driver_register().
These functions internally create various resources and sysfs files.
The sysfs files are used for basic operations(add/del device).
/sys/bus/netdevsim/new_device
/sys/bus/netdevsim/del_device

These sysfs files use netdevsim resources, they are mostly allocated
and initialized in ->probe() function, which is nsim_dev_probe().
But, sysfs files could be executed before ->probe() is finished.
So, accessing uninitialized data would occur.

Another problem is very similar.
/sys/bus/netdevsim/new_device internally creates sysfs files.
/sys/devices/netdevsim<id>/new_port
/sys/devices/netdevsim<id>/del_port

These sysfs files also use netdevsim resources, they are mostly allocated
and initialized in creating device routine, which is nsim_bus_dev_new().
But they also could be executed before nsim_bus_dev_new() is finished.
So, accessing uninitialized data would occur.

To fix these problems, this patch adds flags, which means whether the
operation is finished or not.
The flag variable 'nsim_bus_enable' means whether netdevsim bus was
initialized or not.
This is protected by nsim_bus_dev_list_lock.
The flag variable 'nsim_bus_dev->init' means whether nsim_bus_dev was
initialized or not.
This could be used in {new/del}_port_store() with no lock.

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
[   47.508954][ T1008] general protection fault, probably for non-canonical address 0xdffffc0000000021: 0000 I
[   47.510793][ T1008] KASAN: null-ptr-deref in range [0x0000000000000108-0x000000000000010f]
[   47.511963][ T1008] CPU: 2 PID: 1008 Comm: bash Not tainted 5.5.0+ #322
[   47.512823][ T1008] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   47.514041][ T1008] RIP: 0010:__mutex_lock+0x10a/0x14b0
[   47.514699][ T1008] Code: 08 84 d2 0f 85 7f 12 00 00 44 8b 0d 10 23 65 02 45 85 c9 75 29 49 8d 7f 68 48 b8 00 00 00 0f
[   47.517163][ T1008] RSP: 0018:ffff888059b4fbb0 EFLAGS: 00010206
[   47.517802][ T1008] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   47.518941][ T1008] RDX: 0000000000000021 RSI: ffffffff85926440 RDI: 0000000000000108
[   47.519732][ T1008] RBP: ffff888059b4fd30 R08: ffffffffc073fad0 R09: 0000000000000000
[   47.520729][ T1008] R10: ffff888059b4fd50 R11: ffff88804bb38040 R12: 0000000000000000
[   47.521702][ T1008] R13: dffffc0000000000 R14: ffffffff871976c0 R15: 00000000000000a0
[   47.522760][ T1008] FS:  00007fd4be05a740(0000) GS:ffff88806c800000(0000) knlGS:0000000000000000
[   47.523877][ T1008] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   47.524627][ T1008] CR2: 0000561c82b69cf0 CR3: 0000000065dd6004 CR4: 00000000000606e0
[   47.527662][ T1008] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   47.528604][ T1008] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   47.529531][ T1008] Call Trace:
[   47.529874][ T1008]  ? nsim_dev_port_add+0x50/0x150 [netdevsim]
[   47.530470][ T1008]  ? mutex_lock_io_nested+0x1380/0x1380
[   47.531018][ T1008]  ? _kstrtoull+0x76/0x160
[   47.531449][ T1008]  ? _parse_integer+0xf0/0xf0
[   47.531874][ T1008]  ? kernfs_fop_write+0x1cf/0x410
[   47.532330][ T1008]  ? sysfs_file_ops+0x160/0x160
[   47.532773][ T1008]  ? kstrtouint+0x86/0x110
[   47.533168][ T1008]  ? nsim_dev_port_add+0x50/0x150 [netdevsim]
[   47.533721][ T1008]  nsim_dev_port_add+0x50/0x150 [netdevsim]
[   47.534336][ T1008]  ? sysfs_file_ops+0x160/0x160
[   47.534858][ T1008]  new_port_store+0x99/0xb0 [netdevsim]
[   47.535439][ T1008]  ? del_port_store+0xb0/0xb0 [netdevsim]
[   47.536035][ T1008]  ? sysfs_file_ops+0x112/0x160
[   47.536544][ T1008]  ? sysfs_kf_write+0x3b/0x180
[   47.537029][ T1008]  kernfs_fop_write+0x276/0x410
[   47.537548][ T1008]  ? __sb_start_write+0x215/0x2e0
[   47.538110][ T1008]  vfs_write+0x197/0x4a0
[ ... ]

Fixes: f9d9db47d3ba ("netdevsim: add bus attributes to add new and delete devices")
Fixes: 794b2c05ca1c ("netdevsim: extend device attrs to support port addition and deletion")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 -> v3:
 - Use smp_load_acquire() and smp_store_release() for flag variables
 - Change variable names

v1 -> v2:
 - Do not use trylock
 - Do not include code, which fixes devlink reload problem
 - Update Fixes tags
 - Update comments

 drivers/net/netdevsim/bus.c       | 43 ++++++++++++++++++++++++++++---
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 6aeed0c600f8..c086d1e522dc 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -17,6 +17,7 @@
 static DEFINE_IDA(nsim_bus_dev_ids);
 static LIST_HEAD(nsim_bus_dev_list);
 static DEFINE_MUTEX(nsim_bus_dev_list_lock);
+static bool nsim_bus_enable;
 
 static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
 {
@@ -99,6 +100,9 @@ new_port_store(struct device *dev, struct device_attribute *attr,
 	unsigned int port_index;
 	int ret;
 
+	/* Prevent to use nsim_bus_dev before initialization. */
+	if (!smp_load_acquire(&nsim_bus_dev->init))
+		return -EBUSY;
 	ret = kstrtouint(buf, 0, &port_index);
 	if (ret)
 		return ret;
@@ -116,6 +120,9 @@ del_port_store(struct device *dev, struct device_attribute *attr,
 	unsigned int port_index;
 	int ret;
 
+	/* Prevent to use nsim_bus_dev before initialization. */
+	if (!smp_load_acquire(&nsim_bus_dev->init))
+		return -EBUSY;
 	ret = kstrtouint(buf, 0, &port_index);
 	if (ret)
 		return ret;
@@ -179,15 +186,30 @@ new_device_store(struct bus_type *bus, const char *buf, size_t count)
 		pr_err("Format for adding new device is \"id port_count\" (uint uint).\n");
 		return -EINVAL;
 	}
-	nsim_bus_dev = nsim_bus_dev_new(id, port_count);
-	if (IS_ERR(nsim_bus_dev))
-		return PTR_ERR(nsim_bus_dev);
 
 	mutex_lock(&nsim_bus_dev_list_lock);
+	/* Prevent to use resource before initialization. */
+	if (!smp_load_acquire(&nsim_bus_enable)) {
+		err = -EBUSY;
+		goto err;
+	}
+
+	nsim_bus_dev = nsim_bus_dev_new(id, port_count);
+	if (IS_ERR(nsim_bus_dev)) {
+		err = PTR_ERR(nsim_bus_dev);
+		goto err;
+	}
+
+	/* Allow using nsim_bus_dev */
+	smp_store_release(&nsim_bus_dev->init, true);
+
 	list_add_tail(&nsim_bus_dev->list, &nsim_bus_dev_list);
 	mutex_unlock(&nsim_bus_dev_list_lock);
 
 	return count;
+err:
+	mutex_unlock(&nsim_bus_dev_list_lock);
+	return err;
 }
 static BUS_ATTR_WO(new_device);
 
@@ -215,6 +237,11 @@ del_device_store(struct bus_type *bus, const char *buf, size_t count)
 
 	err = -ENOENT;
 	mutex_lock(&nsim_bus_dev_list_lock);
+	/* Prevent to use resource before initialization. */
+	if (!smp_load_acquire(&nsim_bus_enable)) {
+		mutex_unlock(&nsim_bus_dev_list_lock);
+		return -EBUSY;
+	}
 	list_for_each_entry_safe(nsim_bus_dev, tmp, &nsim_bus_dev_list, list) {
 		if (nsim_bus_dev->dev.id != id)
 			continue;
@@ -284,6 +311,8 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count)
 	nsim_bus_dev->dev.type = &nsim_bus_dev_type;
 	nsim_bus_dev->port_count = port_count;
 	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
+	/* Disallow using nsim_bus_dev */
+	smp_store_release(&nsim_bus_dev->init, false);
 
 	err = device_register(&nsim_bus_dev->dev);
 	if (err)
@@ -299,6 +328,8 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count)
 
 static void nsim_bus_dev_del(struct nsim_bus_dev *nsim_bus_dev)
 {
+	/* Disallow using nsim_bus_dev */
+	smp_store_release(&nsim_bus_dev->init, false);
 	device_unregister(&nsim_bus_dev->dev);
 	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
 	kfree(nsim_bus_dev);
@@ -320,6 +351,8 @@ int nsim_bus_init(void)
 	err = driver_register(&nsim_driver);
 	if (err)
 		goto err_bus_unregister;
+	/* Allow using resources */
+	smp_store_release(&nsim_bus_enable, true);
 	return 0;
 
 err_bus_unregister:
@@ -331,12 +364,16 @@ void nsim_bus_exit(void)
 {
 	struct nsim_bus_dev *nsim_bus_dev, *tmp;
 
+	/* Disallow using resources */
+	smp_store_release(&nsim_bus_enable, false);
+
 	mutex_lock(&nsim_bus_dev_list_lock);
 	list_for_each_entry_safe(nsim_bus_dev, tmp, &nsim_bus_dev_list, list) {
 		list_del(&nsim_bus_dev->list);
 		nsim_bus_dev_del(nsim_bus_dev);
 	}
 	mutex_unlock(&nsim_bus_dev_list_lock);
+
 	driver_unregister(&nsim_driver);
 	bus_unregister(&nsim_bus);
 }
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 94df795ef4d3..ea3931391ce2 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -240,6 +240,7 @@ struct nsim_bus_dev {
 				  */
 	unsigned int num_vfs;
 	struct nsim_vf_config *vfconfigs;
+	bool init;
 };
 
 int nsim_bus_init(void);
-- 
2.17.1


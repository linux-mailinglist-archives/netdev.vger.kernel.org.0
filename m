Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0BD014A614
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgA0OaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:30:05 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38321 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0OaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 09:30:05 -0500
Received: by mail-pj1-f66.google.com with SMTP id m4so3179678pjv.3
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 06:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0enkGfSAgOHPXl4Cl6zsJTgJX8JHEVRJdjc5PBhqh5Y=;
        b=EZNmiVhgn1RJxt+fjGuuPlGLDCFW4L0qcg2KYPQjiT/QS7NvkLFYPdGZrdE6K4CeJc
         +OSj99hnsWjy30re2qry/hrGfdXy3/zGaLwskHzIUc0K4TO1Y4QVzsWlid6zYk1sWLgf
         l+K8iF+RCy0KzTBbwNrYrnVNsGPnIgR6RONLlq+2WfjeD+cY/20W+a2F/YqDdnHwopLq
         D/H1vwvA73dL8bcvCdxsIKpFxBlyzVJkLBfupbmA8sIBesAmGpvjziOivSsxOCW5UjGE
         ahE4RiUfdrAETZAKnygAAqn4K7jTOI/18ThSfH064lukDnIOqRVcGWaZWRG2AlP1+Lmz
         9iyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0enkGfSAgOHPXl4Cl6zsJTgJX8JHEVRJdjc5PBhqh5Y=;
        b=l1927fO86KmXVGK3U636Nr49enLV0USDoO95kToGNmqJq3//18nL7EVli4mcQLJxAY
         czE7R1rqzumJatqcVR+KFEGgoreWEicfu2LF3ZFbA7QRald3hear6hXL+Uh6YR1IHv+G
         7N6rOWDw+QgvJWfpGywcN/ThrjV7Ih3R3bjZHzXu4tz1LRXsZjskys/Z8y+fyX/G8LON
         y/frBWs+knjn2c9SscTEcY/14FvO6O2s8hjZ2znHull5cnUYiI/lXPr+s60Ck6RWLt58
         FUaqJYwDTj6ZrBQhu+nCt4KmXyK35q80hs7M5BlDWLsgUHyc5tVn4aF9ir6Ks6caarWD
         84zA==
X-Gm-Message-State: APjAAAUrij0phqdc03wtAD/kft9ivC4SkzN4d/gN3rLMQxGhU3kENE7i
        c3Ct7OuQy+2ju7KLPvORoGw=
X-Google-Smtp-Source: APXvYqyI/GpDUl74nalLWBl5Rafa0l7S7XWPn/V8oD3ywgHt8pz1R9wEVxJLBY3n0dQ/wAP4AEJ+8w==
X-Received: by 2002:a17:902:8c8b:: with SMTP id t11mr16693073plo.319.1580135404565;
        Mon, 27 Jan 2020 06:30:04 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id 70sm17095167pgf.90.2020.01.27.06.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 06:30:03 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 1/6] netdevsim: fix race conditions in netdevsim operations
Date:   Mon, 27 Jan 2020 14:29:57 +0000
Message-Id: <20200127142957.1177-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a several locking problem.

1. netdevsim basic operations(new_device, del_device, new_port,
and del_port) are called with sysfs.
These operations use the same resource so they should acquire a lock for
the whole resource not only for a list.
2. devices are managed by nsim_bus_dev_list. and all devices are deleted
in the __exit() routine. After delete routine, new_device() and
del_device() should be disallowed. So, the global flag variable 'enable'
is added.
3. new_port() and del_port() would be called before resources are
allocated or initialized. If so, panic will occur.
In order to avoid this scenario, variable 'nsim_bus_dev->init' is added.

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
[   66.648015][ T1095] kasan: CONFIG_KASAN_INLINE enabled
[   66.660685][ T1095] kasan: GPF could be caused by NULL-ptr deref or user memory access
[   66.662106][ T1095] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[   66.663151][ T1095] CPU: 0 PID: 1095 Comm: bash Not tainted 5.5.0-rc6+ #318
[   66.664046][ T1095] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   66.665308][ T1095] RIP: 0010:__mutex_lock+0x10a/0x14b0
[   66.666056][ T1095] Code: 08 84 d2 0f 85 7f 12 00 00 44 8b 0d 70 c4 66 02 45 85 c9 75 29 49 8d 7f 68 48 b8 00 f
[   66.670158][ T1095] RSP: 0018:ffff8880d36efbb0 EFLAGS: 00010206
[   66.672254][ T1095] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   66.673392][ T1095] RDX: 0000000000000021 RSI: ffffffffbb922ac0 RDI: 0000000000000108
[   66.674563][ T1095] RBP: ffff8880d36efd30 R08: ffffffffc033ead0 R09: 0000000000000000
[   66.675731][ T1095] R10: ffff8880d36efd50 R11: ffff8880ca1f8040 R12: 0000000000000000
[   66.676897][ T1095] R13: dffffc0000000000 R14: ffffffffbd17a7c0 R15: 00000000000000a0
[   66.678005][ T1095] FS:  00007fe4a170f740(0000) GS:ffff8880d9c00000(0000) knlGS:0000000000000000
[   66.679101][ T1095] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   66.679906][ T1095] CR2: 000055fa392f7ca0 CR3: 00000000b136a003 CR4: 00000000000606f0
[   66.681467][ T1095] Call Trace:
[   66.681899][ T1095]  ? nsim_dev_port_add+0x50/0x150 [netdevsim]
[   66.682681][ T1095]  ? mutex_lock_io_nested+0x1380/0x1380
[   66.683371][ T1095]  ? _kstrtoull+0x76/0x160
[   66.683819][ T1095]  ? _parse_integer+0xf0/0xf0
[   66.684324][ T1095]  ? kernfs_fop_write+0x1cf/0x410
[   66.684861][ T1095]  ? sysfs_file_ops+0x160/0x160
[   66.687441][ T1095]  ? kstrtouint+0x86/0x110
[   66.687961][ T1095]  ? nsim_dev_port_add+0x50/0x150 [netdevsim]
[   66.688646][ T1095]  nsim_dev_port_add+0x50/0x150 [netdevsim]
[   66.689269][ T1095]  ? sysfs_file_ops+0x160/0x160
[   66.690547][ T1095]  new_port_store+0x99/0xb0 [netdevsim]
[   66.691114][ T1095]  ? del_port_store+0xb0/0xb0 [netdevsim]
[   66.691699][ T1095]  ? sysfs_file_ops+0x112/0x160
[   66.692193][ T1095]  ? sysfs_kf_write+0x3b/0x180
[   66.692677][ T1095]  kernfs_fop_write+0x276/0x410
[   66.693176][ T1095]  ? __sb_start_write+0x215/0x2e0
[   66.693695][ T1095]  vfs_write+0x197/0x4a0
[   66.694136][ T1095]  ksys_write+0x141/0x1d0
[ ... ]

Fixes: f9d9db47d3ba ("netdevsim: add bus attributes to add new and delete devices")
Fixes: 794b2c05ca1c ("netdevsim: extend device attrs to support port addition and deletion")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2
 - Do not use trylock
 - Do not include code, which fixes devlink reload problem
 - Update Fixes tags
 - Update comments

 drivers/net/netdevsim/bus.c       | 35 ++++++++++++++++++++++++-------
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 6aeed0c600f8..a3205fd73c8f 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -16,7 +16,8 @@
 
 static DEFINE_IDA(nsim_bus_dev_ids);
 static LIST_HEAD(nsim_bus_dev_list);
-static DEFINE_MUTEX(nsim_bus_dev_list_lock);
+static DEFINE_MUTEX(nsim_bus_dev_ops_lock);
+static bool enable;
 
 static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
 {
@@ -99,6 +100,8 @@ new_port_store(struct device *dev, struct device_attribute *attr,
 	unsigned int port_index;
 	int ret;
 
+	if (!nsim_bus_dev->init)
+		return -EBUSY;
 	ret = kstrtouint(buf, 0, &port_index);
 	if (ret)
 		return ret;
@@ -116,6 +119,8 @@ del_port_store(struct device *dev, struct device_attribute *attr,
 	unsigned int port_index;
 	int ret;
 
+	if (!nsim_bus_dev->init)
+		return -EBUSY;
 	ret = kstrtouint(buf, 0, &port_index);
 	if (ret)
 		return ret;
@@ -179,13 +184,21 @@ new_device_store(struct bus_type *bus, const char *buf, size_t count)
 		pr_err("Format for adding new device is \"id port_count\" (uint uint).\n");
 		return -EINVAL;
 	}
+	mutex_lock(&nsim_bus_dev_ops_lock);
+	if (!enable) {
+		mutex_unlock(&nsim_bus_dev_ops_lock);
+		return -EBUSY;
+	}
 	nsim_bus_dev = nsim_bus_dev_new(id, port_count);
-	if (IS_ERR(nsim_bus_dev))
+	if (IS_ERR(nsim_bus_dev)) {
+		mutex_unlock(&nsim_bus_dev_ops_lock);
 		return PTR_ERR(nsim_bus_dev);
+	}
+
+	nsim_bus_dev->init = true;
 
-	mutex_lock(&nsim_bus_dev_list_lock);
 	list_add_tail(&nsim_bus_dev->list, &nsim_bus_dev_list);
-	mutex_unlock(&nsim_bus_dev_list_lock);
+	mutex_unlock(&nsim_bus_dev_ops_lock);
 
 	return count;
 }
@@ -214,7 +227,11 @@ del_device_store(struct bus_type *bus, const char *buf, size_t count)
 	}
 
 	err = -ENOENT;
-	mutex_lock(&nsim_bus_dev_list_lock);
+	mutex_lock(&nsim_bus_dev_ops_lock);
+	if (!enable) {
+		mutex_unlock(&nsim_bus_dev_ops_lock);
+		return -EBUSY;
+	}
 	list_for_each_entry_safe(nsim_bus_dev, tmp, &nsim_bus_dev_list, list) {
 		if (nsim_bus_dev->dev.id != id)
 			continue;
@@ -223,7 +240,7 @@ del_device_store(struct bus_type *bus, const char *buf, size_t count)
 		err = 0;
 		break;
 	}
-	mutex_unlock(&nsim_bus_dev_list_lock);
+	mutex_unlock(&nsim_bus_dev_ops_lock);
 	return !err ? count : err;
 }
 static BUS_ATTR_WO(del_device);
@@ -320,6 +337,7 @@ int nsim_bus_init(void)
 	err = driver_register(&nsim_driver);
 	if (err)
 		goto err_bus_unregister;
+	enable = true;
 	return 0;
 
 err_bus_unregister:
@@ -331,12 +349,13 @@ void nsim_bus_exit(void)
 {
 	struct nsim_bus_dev *nsim_bus_dev, *tmp;
 
-	mutex_lock(&nsim_bus_dev_list_lock);
+	mutex_lock(&nsim_bus_dev_ops_lock);
+	enable = false;
 	list_for_each_entry_safe(nsim_bus_dev, tmp, &nsim_bus_dev_list, list) {
 		list_del(&nsim_bus_dev->list);
 		nsim_bus_dev_del(nsim_bus_dev);
 	}
-	mutex_unlock(&nsim_bus_dev_list_lock);
+	mutex_unlock(&nsim_bus_dev_ops_lock);
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


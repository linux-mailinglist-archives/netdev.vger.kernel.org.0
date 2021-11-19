Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A06456CE7
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 11:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhKSKCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 05:02:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:24868 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233983AbhKSKCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 05:02:49 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="258181641"
X-IronPort-AV: E=Sophos;i="5.87,247,1631602800"; 
   d="scan'208";a="258181641"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 01:59:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,247,1631602800"; 
   d="scan'208";a="737335302"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by fmsmga005.fm.intel.com with ESMTP; 19 Nov 2021 01:59:44 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V2 net-next 1/2] net: wwan: common debugfs base dir for wwan device
Date:   Fri, 19 Nov 2021 15:37:19 +0530
Message-Id: <20211119100720.1112978-2-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119100720.1112978-1-m.chetan.kumar@linux.intel.com>
References: <20211119100720.1112978-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set brings in a common debugfs base directory
i.e. /sys/kernel/debugfs/wwan/ in WWAN Subsystem for a
WWAN device instance. So that it avoids driver polluting
debugfs root with unrelated directories & possible name
collusion.

Having a common debugfs base directory for WWAN drivers
eases user to match control devices with debugfs entries.

WWAN Subsystem creates dentry (/sys/kernel/debugfs/wwan)
on module load & removes dentry on module unload.

When driver registers a new wwan device, dentry (wwanX)
is created for WWAN device instance & on driver unregister
dentry is removed.

New API is introduced to return the wwan device instance
dentry so that driver can create debugfs entries under it.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/wwan_core.c | 35 +++++++++++++++++++++++++++++++++--
 include/linux/wwan.h         |  2 ++
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index d293ab688044..b8eeaea5c7d3 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -3,6 +3,7 @@
 
 #include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/debugfs.h>
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/idr.h>
@@ -25,6 +26,7 @@ static DEFINE_IDA(minors); /* minors for WWAN port chardevs */
 static DEFINE_IDA(wwan_dev_ids); /* for unique WWAN device IDs */
 static struct class *wwan_class;
 static int wwan_major;
+static struct dentry *wwan_debugfs_dir;
 
 #define to_wwan_dev(d) container_of(d, struct wwan_device, dev)
 #define to_wwan_port(d) container_of(d, struct wwan_port, dev)
@@ -40,6 +42,7 @@ static int wwan_major;
  * @port_id: Current available port ID to pick.
  * @ops: wwan device ops
  * @ops_ctxt: context to pass to ops
+ * @debugfs_dir:  WWAN device debugfs dir
  */
 struct wwan_device {
 	unsigned int id;
@@ -47,6 +50,7 @@ struct wwan_device {
 	atomic_t port_id;
 	const struct wwan_ops *ops;
 	void *ops_ctxt;
+	struct dentry *debugfs_dir;
 };
 
 /**
@@ -142,6 +146,22 @@ static struct wwan_device *wwan_dev_get_by_name(const char *name)
 	return to_wwan_dev(dev);
 }
 
+struct dentry *wwan_get_debugfs_dir(struct device *parent)
+{
+	struct wwan_device *wwandev;
+
+	if (WARN_ON(!parent))
+		return ERR_PTR(-EINVAL);
+
+	wwandev = wwan_dev_get_by_parent(parent);
+
+	if (IS_ERR(wwandev))
+		return ERR_CAST(wwandev);
+
+	return wwandev->debugfs_dir;
+}
+EXPORT_SYMBOL_GPL(wwan_get_debugfs_dir);
+
 /* This function allocates and registers a new WWAN device OR if a WWAN device
  * already exist for the given parent, it gets a reference and return it.
  * This function is not exported (for now), it is called indirectly via
@@ -150,6 +170,7 @@ static struct wwan_device *wwan_dev_get_by_name(const char *name)
 static struct wwan_device *wwan_create_dev(struct device *parent)
 {
 	struct wwan_device *wwandev;
+	const char *wwandev_name;
 	int err, id;
 
 	/* The 'find-alloc-register' operation must be protected against
@@ -189,6 +210,10 @@ static struct wwan_device *wwan_create_dev(struct device *parent)
 		goto done_unlock;
 	}
 
+	wwandev_name = kobject_name(&wwandev->dev.kobj);
+	wwandev->debugfs_dir = debugfs_create_dir(wwandev_name,
+						  wwan_debugfs_dir);
+
 done_unlock:
 	mutex_unlock(&wwan_register_lock);
 
@@ -218,10 +240,12 @@ static void wwan_remove_dev(struct wwan_device *wwandev)
 	else
 		ret = device_for_each_child(&wwandev->dev, NULL, is_wwan_child);
 
-	if (!ret)
+	if (!ret) {
+		debugfs_remove_recursive(wwandev->debugfs_dir);
 		device_unregister(&wwandev->dev);
-	else
+	} else {
 		put_device(&wwandev->dev);
+	}
 
 	mutex_unlock(&wwan_register_lock);
 }
@@ -1117,6 +1144,8 @@ static int __init wwan_init(void)
 		goto destroy;
 	}
 
+	wwan_debugfs_dir = debugfs_create_dir("wwan", NULL);
+
 	return 0;
 
 destroy:
@@ -1128,6 +1157,7 @@ static int __init wwan_init(void)
 
 static void __exit wwan_exit(void)
 {
+	debugfs_remove_recursive(wwan_debugfs_dir);
 	__unregister_chrdev(wwan_major, 0, WWAN_MAX_MINORS, "wwan_port");
 	rtnl_link_unregister(&wwan_rtnl_link_ops);
 	class_destroy(wwan_class);
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index 9fac819f92e3..1646aa3e6779 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -171,4 +171,6 @@ int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
 
 void wwan_unregister_ops(struct device *parent);
 
+struct dentry *wwan_get_debugfs_dir(struct device *parent);
+
 #endif /* __WWAN_H */
-- 
2.25.1


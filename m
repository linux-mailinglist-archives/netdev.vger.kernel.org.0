Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFF014E5C5
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgA3W72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:28 -0500
Received: from mga12.intel.com ([192.55.52.136]:51507 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727627AbgA3W7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187794"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:22 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 08/15] devlink: add devres managed devlinkm_alloc and devlinkm_free
Date:   Thu, 30 Jan 2020 14:59:03 -0800
Message-Id: <20200130225913.1671982-9-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devres managed allocation functions for allocating a devlink
instance. These can be used by device drivers based on the devres
framework which want to allocate a devlink instance.

For simplicity and to reduce churn in the devlink core code, the devres
management works by creating a node with a double-pointer. The devlink
instance is allocated using the normal devlink_alloc and released using
the normal devlink_free.

An alternative solution where the raw memory for devlink is allocated
directly via devres_alloc could be done. Such an implementation would
either significantly increase code duplication or code churn in order to
refactor the setup from the allocation.

The new devres managed allocation function will be used by the ice
driver in a following change to implement initial devlink support.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/net/devlink.h |  4 ++++
 lib/devres.c          |  1 +
 net/core/devlink.c    | 54 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 63e954241404..1c3540280396 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -858,11 +858,15 @@ struct ib_device;
 struct net *devlink_net(const struct devlink *devlink);
 void devlink_net_set(struct devlink *devlink, struct net *net);
 struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size);
+struct devlink *devlinkm_alloc(struct device * dev,
+			       const struct devlink_ops *ops,
+			       size_t priv_size);
 int devlink_register(struct devlink *devlink, struct device *dev);
 void devlink_unregister(struct devlink *devlink);
 void devlink_reload_enable(struct devlink *devlink);
 void devlink_reload_disable(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
+void devlinkm_free(struct device *dev, struct devlink *devlink);
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
 			  unsigned int port_index);
diff --git a/lib/devres.c b/lib/devres.c
index 6ef51f159c54..239c81d40612 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -5,6 +5,7 @@
 #include <linux/gfp.h>
 #include <linux/export.h>
 #include <linux/of_address.h>
+#include <net/devlink.h>
 
 enum devm_ioremap_type {
 	DEVM_IOREMAP = 0,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 574008c536fa..b2b855d12a11 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6531,6 +6531,60 @@ void devlink_free(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_free);
 
+static void devres_devlink_release(struct device *dev, void *res)
+{
+	devlink_free(*(struct devlink **)res);
+}
+
+static int devres_devlink_match(struct device *dev, void *res, void *data)
+{
+	return *(struct devlink **)res == data;
+}
+
+/**
+ * devlinkm_alloc - Allocate devlink instance managed by devres
+ * @dev: device to allocate devlink for
+ * @ops: devlink ops structure
+ * @priv_size: size of private data portion
+ *
+ * Allocate a devlink instance and manage its release via devres.
+ */
+struct devlink *devlinkm_alloc(struct device *dev,
+			       const struct devlink_ops *ops,
+			       size_t priv_size)
+{
+	struct devlink **ptr, *devlink = NULL;
+
+	ptr = devres_alloc(devres_devlink_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	devlink = devlink_alloc(ops, priv_size);
+	if (devlink) {
+		*ptr = devlink;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return devlink;
+}
+EXPORT_SYMBOL_GPL(devlinkm_alloc);
+
+/**
+ * devlinkm_free - Free devlink instance managed by devres
+ * @dev: device to remove the allocated devlink from
+ * @devlink: devlink instance to free
+ *
+ * Find and remove the devres node associated with the given devlink.
+ */
+void devlinkm_free(struct device *dev, struct devlink *devlink)
+{
+	WARN_ON(devres_release(dev, devres_devlink_release,
+			       devres_devlink_match, devlink));
+}
+EXPORT_SYMBOL_GPL(devlinkm_free);
+
 static void devlink_port_type_warn(struct work_struct *work)
 {
 	WARN(true, "Type was not set for devlink port.");
-- 
2.25.0.rc1


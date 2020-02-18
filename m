Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7ED162A84
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 17:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgBRQaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 11:30:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57224 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgBRQaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 11:30:11 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j45l9-0003h0-N6; Tue, 18 Feb 2020 16:30:07 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH net-next v3 5/9] device: add device_change_owner()
Date:   Tue, 18 Feb 2020 17:29:39 +0100
Message-Id: <20200218162943.2488012-6-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to change the owner of a device's sysfs entries. This
needs to happen when the ownership of a device is changed, e.g. when
moving network devices between network namespaces.
This function will be used to correctly account for ownership changes,
e.g. when moving network devices between network namespaces.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v2 */
unchanged

/* v3 */
-  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
   - Add explicit uid/gid parameters.
---
 drivers/base/core.c    | 80 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |  1 +
 2 files changed, 81 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 42a672456432..ec0d5e8cfd0f 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3458,6 +3458,86 @@ int device_move(struct device *dev, struct device *new_parent,
 }
 EXPORT_SYMBOL_GPL(device_move);
 
+static int device_attrs_change_owner(struct device *dev, kuid_t kuid,
+				     kgid_t kgid)
+{
+	struct kobject *kobj = &dev->kobj;
+	struct class *class = dev->class;
+	const struct device_type *type = dev->type;
+	int error;
+
+	if (class) {
+		error = sysfs_groups_change_owner(kobj, class->dev_groups, kuid,
+						  kgid);
+		if (error)
+			return error;
+	}
+
+	if (type) {
+		error = sysfs_groups_change_owner(kobj, type->groups, kuid,
+						  kgid);
+		if (error)
+			return error;
+	}
+
+	error = sysfs_groups_change_owner(kobj, dev->groups, kuid, kgid);
+	if (error)
+		return error;
+
+	if (device_supports_offline(dev) && !dev->offline_disabled) {
+		error = sysfs_file_change_owner_by_name(
+			kobj, dev_attr_online.attr.name, kuid, kgid);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/**
+ * device_change_owner - change the owner of an existing device.
+ * @dev: device.
+ * @kuid: new owner's kuid
+ * @kgid: new owner's kgid
+ */
+int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
+{
+	int error;
+	struct kobject *kobj = &dev->kobj;
+
+	dev = get_device(dev);
+	if (!dev)
+		return -EINVAL;
+
+	error = sysfs_change_owner(kobj, kuid, kgid);
+	if (error)
+		goto out;
+
+	error = sysfs_file_change_owner_by_name(kobj, dev_attr_uevent.attr.name,
+						kuid, kgid);
+	if (error)
+		goto out;
+
+	error = device_attrs_change_owner(dev, kuid, kgid);
+	if (error)
+		goto out;
+
+#ifdef CONFIG_BLOCK
+	if (sysfs_deprecated && dev->class == &block_class)
+		goto out;
+#endif
+
+	error = sysfs_link_change_owner(&dev->class->p->subsys.kobj, &dev->kobj,
+					dev_name(dev), kuid, kgid);
+	if (error)
+		goto out;
+
+out:
+	put_device(dev);
+	return error;
+}
+EXPORT_SYMBOL_GPL(device_change_owner);
+
 /**
  * device_shutdown - call ->shutdown() on each device to shutdown.
  */
diff --git a/include/linux/device.h b/include/linux/device.h
index 0cd7c647c16c..3e40533d2037 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -817,6 +817,7 @@ extern struct device *device_find_child_by_name(struct device *parent,
 extern int device_rename(struct device *dev, const char *new_name);
 extern int device_move(struct device *dev, struct device *new_parent,
 		       enum dpm_order dpm_order);
+extern int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid);
 extern const char *device_get_devnode(struct device *dev,
 				      umode_t *mode, kuid_t *uid, kgid_t *gid,
 				      const char **tmp);
-- 
2.25.0


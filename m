Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B9083688
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387904AbfHFQM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732203AbfHFQLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 12:11:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A95020679;
        Tue,  6 Aug 2019 16:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565107893;
        bh=Uwg6jTI3Q2h/Ki0hxAdwwkKvXhV5j2tYKTY18Fs09lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkTDyUgEy/IzxLmAMbE6/9ZgvF8Tz9eoG8DCvRnXq6M8T+VX1Fd5Uj9d7HFqAdlXG
         ndSW9jnPa02TVfIMc454ySViKBQHdRtQ7ukYN0rgjvdS1tSoEtXnHiCDfufjV4B+ll
         gbxtjq+EOUsjwvKYeOp3FOTrnWbDRaMoeou7OGAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com
Subject: [PATCH 01/17] wimax: no need to check return value of debugfs_create functions
Date:   Tue,  6 Aug 2019 18:11:12 +0200
Message-Id: <20190806161128.31232-2-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806161128.31232-1-gregkh@linuxfoundation.org>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

This cleans up a lot of unneeded code and logic around the debugfs wimax
files, making all of this much simpler and easier to understand.

Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: linux-wimax@intel.com
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wimax/i2400m/debugfs.c | 149 +++++------------------------
 drivers/net/wimax/i2400m/driver.c  |   7 +-
 drivers/net/wimax/i2400m/i2400m.h  |   7 +-
 drivers/net/wimax/i2400m/usb.c     |  61 +++---------
 include/linux/wimax/debug.h        |  20 +---
 net/wimax/debugfs.c                |  42 ++------
 net/wimax/stack.c                  |  11 +--
 net/wimax/wimax-internal.h         |   7 +-
 8 files changed, 51 insertions(+), 253 deletions(-)

diff --git a/drivers/net/wimax/i2400m/debugfs.c b/drivers/net/wimax/i2400m/debugfs.c
index 6544ac9df047..01492c1fa70b 100644
--- a/drivers/net/wimax/i2400m/debugfs.c
+++ b/drivers/net/wimax/i2400m/debugfs.c
@@ -30,15 +30,6 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_netdev_queue_stopped,
 			debugfs_netdev_queue_stopped_get,
 			NULL, "%llu\n");
 
-
-static
-struct dentry *debugfs_create_netdev_queue_stopped(
-	const char *name, struct dentry *parent, struct i2400m *i2400m)
-{
-	return debugfs_create_file(name, 0400, parent, i2400m,
-				   &fops_netdev_queue_stopped);
-}
-
 /*
  * We don't allow partial reads of this file, as then the reader would
  * get weirdly confused data as it is updated.
@@ -167,15 +158,6 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_i2400m_suspend,
 			NULL, debugfs_i2400m_suspend_set,
 			"%llu\n");
 
-static
-struct dentry *debugfs_create_i2400m_suspend(
-	const char *name, struct dentry *parent, struct i2400m *i2400m)
-{
-	return debugfs_create_file(name, 0200, parent, i2400m,
-				   &fops_i2400m_suspend);
-}
-
-
 /*
  * Reset the device
  *
@@ -205,73 +187,26 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_i2400m_reset,
 			NULL, debugfs_i2400m_reset_set,
 			"%llu\n");
 
-static
-struct dentry *debugfs_create_i2400m_reset(
-	const char *name, struct dentry *parent, struct i2400m *i2400m)
+void i2400m_debugfs_add(struct i2400m *i2400m)
 {
-	return debugfs_create_file(name, 0200, parent, i2400m,
-				   &fops_i2400m_reset);
-}
-
-
-#define __debugfs_register(prefix, name, parent)			\
-do {									\
-	result = d_level_register_debugfs(prefix, name, parent);	\
-	if (result < 0)							\
-		goto error;						\
-} while (0)
-
-
-int i2400m_debugfs_add(struct i2400m *i2400m)
-{
-	int result;
 	struct device *dev = i2400m_dev(i2400m);
 	struct dentry *dentry = i2400m->wimax_dev.debugfs_dentry;
-	struct dentry *fd;
 
 	dentry = debugfs_create_dir("i2400m", dentry);
-	result = PTR_ERR(dentry);
-	if (IS_ERR(dentry)) {
-		if (result == -ENODEV)
-			result = 0;	/* No debugfs support */
-		goto error;
-	}
 	i2400m->debugfs_dentry = dentry;
-	__debugfs_register("dl_", control, dentry);
-	__debugfs_register("dl_", driver, dentry);
-	__debugfs_register("dl_", debugfs, dentry);
-	__debugfs_register("dl_", fw, dentry);
-	__debugfs_register("dl_", netdev, dentry);
-	__debugfs_register("dl_", rfkill, dentry);
-	__debugfs_register("dl_", rx, dentry);
-	__debugfs_register("dl_", tx, dentry);
-
-	fd = debugfs_create_size_t("tx_in", 0400, dentry,
-				   &i2400m->tx_in);
-	result = PTR_ERR(fd);
-	if (IS_ERR(fd) && result != -ENODEV) {
-		dev_err(dev, "Can't create debugfs entry "
-			"tx_in: %d\n", result);
-		goto error;
-	}
 
-	fd = debugfs_create_size_t("tx_out", 0400, dentry,
-				   &i2400m->tx_out);
-	result = PTR_ERR(fd);
-	if (IS_ERR(fd) && result != -ENODEV) {
-		dev_err(dev, "Can't create debugfs entry "
-			"tx_out: %d\n", result);
-		goto error;
-	}
+	d_level_register_debugfs("dl_", control, dentry);
+	d_level_register_debugfs("dl_", driver, dentry);
+	d_level_register_debugfs("dl_", debugfs, dentry);
+	d_level_register_debugfs("dl_", fw, dentry);
+	d_level_register_debugfs("dl_", netdev, dentry);
+	d_level_register_debugfs("dl_", rfkill, dentry);
+	d_level_register_debugfs("dl_", rx, dentry);
+	d_level_register_debugfs("dl_", tx, dentry);
 
-	fd = debugfs_create_u32("state", 0600, dentry,
-				&i2400m->state);
-	result = PTR_ERR(fd);
-	if (IS_ERR(fd) && result != -ENODEV) {
-		dev_err(dev, "Can't create debugfs entry "
-			"state: %d\n", result);
-		goto error;
-	}
+	debugfs_create_size_t("tx_in", 0400, dentry, &i2400m->tx_in);
+	debugfs_create_size_t("tx_out", 0400, dentry, &i2400m->tx_out);
+	debugfs_create_u32("state", 0600, dentry, &i2400m->state);
 
 	/*
 	 * Trace received messages from user space
@@ -295,60 +230,22 @@ int i2400m_debugfs_add(struct i2400m *i2400m)
 	 * It is not really very atomic, but it is also not too
 	 * critical.
 	 */
-	fd = debugfs_create_u8("trace_msg_from_user", 0600, dentry,
-			       &i2400m->trace_msg_from_user);
-	result = PTR_ERR(fd);
-	if (IS_ERR(fd) && result != -ENODEV) {
-		dev_err(dev, "Can't create debugfs entry "
-			"trace_msg_from_user: %d\n", result);
-		goto error;
-	}
+	debugfs_create_u8("trace_msg_from_user", 0600, dentry,
+			  &i2400m->trace_msg_from_user);
 
-	fd = debugfs_create_netdev_queue_stopped("netdev_queue_stopped",
-						 dentry, i2400m);
-	result = PTR_ERR(fd);
-	if (IS_ERR(fd) && result != -ENODEV) {
-		dev_err(dev, "Can't create debugfs entry "
-			"netdev_queue_stopped: %d\n", result);
-		goto error;
-	}
+	debugfs_create_file("netdev_queue_stopped", 0400, dentry, i2400m,
+			    &fops_netdev_queue_stopped);
 
-	fd = debugfs_create_file("rx_stats", 0600, dentry, i2400m,
-				 &i2400m_rx_stats_fops);
-	result = PTR_ERR(fd);
-	if (IS_ERR(fd) && result != -ENODEV) {
-		dev_err(dev, "Can't create debugfs entry "
-			"rx_stats: %d\n", result);
-		goto error;
-	}
+	debugfs_create_file("rx_stats", 0600, dentry, i2400m,
+			    &i2400m_rx_stats_fops);
 
-	fd = debugfs_create_file("tx_stats", 0600, dentry, i2400m,
-				 &i2400m_tx_stats_fops);
-	result = PTR_ERR(fd);
-	if (IS_ERR(fd) && result != -ENODEV) {
-		dev_err(dev, "Can't create debugfs entry "
-			"tx_stats: %d\n", result);
-		goto error;
-	}
+	debugfs_create_file("tx_stats", 0600, dentry, i2400m,
+			    &i2400m_tx_stats_fops);
 
-	fd = debugfs_create_i2400m_suspend("suspend", dentry, i2400m);
-	result = PTR_ERR(fd);
-	if (IS_ERR(fd) && result != -ENODEV) {
-		dev_err(dev, "Can't create debugfs entry suspend: %d\n",
-			result);
-		goto error;
-	}
+	debugfs_create_file("suspend", 0200, dentry, i2400m,
+			    &fops_i2400m_suspend);
 
-	fd = debugfs_create_i2400m_reset("reset", dentry, i2400m);
-	result = PTR_ERR(fd);
-	if (IS_ERR(fd) && result != -ENODEV) {
-		dev_err(dev, "Can't create debugfs entry reset: %d\n", result);
-		goto error;
-	}
-
-	result = 0;
-error:
-	return result;
+	debugfs_create_file("reset", 0200, dentry, i2400m, &fops_i2400m_reset);
 }
 
 void i2400m_debugfs_rm(struct i2400m *i2400m)
diff --git a/drivers/net/wimax/i2400m/driver.c b/drivers/net/wimax/i2400m/driver.c
index 0a29222a1bf9..f66c0f8f6f4a 100644
--- a/drivers/net/wimax/i2400m/driver.c
+++ b/drivers/net/wimax/i2400m/driver.c
@@ -905,11 +905,7 @@ int i2400m_setup(struct i2400m *i2400m, enum i2400m_bri bm_flags)
 		goto error_sysfs_setup;
 	}
 
-	result = i2400m_debugfs_add(i2400m);
-	if (result < 0) {
-		dev_err(dev, "cannot setup i2400m's debugfs: %d\n", result);
-		goto error_debugfs_setup;
-	}
+	i2400m_debugfs_add(i2400m);
 
 	result = i2400m_dev_start(i2400m, bm_flags);
 	if (result < 0)
@@ -919,7 +915,6 @@ int i2400m_setup(struct i2400m *i2400m, enum i2400m_bri bm_flags)
 
 error_dev_start:
 	i2400m_debugfs_rm(i2400m);
-error_debugfs_setup:
 	sysfs_remove_group(&i2400m->wimax_dev.net_dev->dev.kobj,
 			   &i2400m_dev_attr_group);
 error_sysfs_setup:
diff --git a/drivers/net/wimax/i2400m/i2400m.h b/drivers/net/wimax/i2400m/i2400m.h
index 5a34e72bab9a..a3733a6d14f5 100644
--- a/drivers/net/wimax/i2400m/i2400m.h
+++ b/drivers/net/wimax/i2400m/i2400m.h
@@ -812,13 +812,10 @@ enum i2400m_pt;
 int i2400m_tx(struct i2400m *, const void *, size_t, enum i2400m_pt);
 
 #ifdef CONFIG_DEBUG_FS
-int i2400m_debugfs_add(struct i2400m *);
+void i2400m_debugfs_add(struct i2400m *);
 void i2400m_debugfs_rm(struct i2400m *);
 #else
-static inline int i2400m_debugfs_add(struct i2400m *i2400m)
-{
-	return 0;
-}
+static inline void i2400m_debugfs_add(struct i2400m *i2400m) {}
 static inline void i2400m_debugfs_rm(struct i2400m *i2400m) {}
 #endif
 
diff --git a/drivers/net/wimax/i2400m/usb.c b/drivers/net/wimax/i2400m/usb.c
index 2075e7b1fff6..5bc48100b52e 100644
--- a/drivers/net/wimax/i2400m/usb.c
+++ b/drivers/net/wimax/i2400m/usb.c
@@ -366,17 +366,8 @@ struct d_level D_LEVEL[] = {
 };
 size_t D_LEVEL_SIZE = ARRAY_SIZE(D_LEVEL);
 
-
-#define __debugfs_register(prefix, name, parent)			\
-do {									\
-	result = d_level_register_debugfs(prefix, name, parent);	\
-	if (result < 0)							\
-		goto error;						\
-} while (0)
-
-
 static
-int i2400mu_debugfs_add(struct i2400mu *i2400mu)
+void i2400mu_debugfs_add(struct i2400mu *i2400mu)
 {
 	int result;
 	struct device *dev = &i2400mu->usb_iface->dev;
@@ -384,43 +375,19 @@ int i2400mu_debugfs_add(struct i2400mu *i2400mu)
 	struct dentry *fd;
 
 	dentry = debugfs_create_dir("i2400m-usb", dentry);
-	result = PTR_ERR(dentry);
-	if (IS_ERR(dentry)) {
-		if (result == -ENODEV)
-			result = 0;	/* No debugfs support */
-		goto error;
-	}
 	i2400mu->debugfs_dentry = dentry;
-	__debugfs_register("dl_", usb, dentry);
-	__debugfs_register("dl_", fw, dentry);
-	__debugfs_register("dl_", notif, dentry);
-	__debugfs_register("dl_", rx, dentry);
-	__debugfs_register("dl_", tx, dentry);
 
-	/* Don't touch these if you don't know what you are doing */
-	fd = debugfs_create_u8("rx_size_auto_shrink", 0600, dentry,
-			       &i2400mu->rx_size_auto_shrink);
-	result = PTR_ERR(fd);
-	if (IS_ERR(fd) && result != -ENODEV) {
-		dev_err(dev, "Can't create debugfs entry "
-			"rx_size_auto_shrink: %d\n", result);
-		goto error;
-	}
-
-	fd = debugfs_create_size_t("rx_size", 0600, dentry,
-				   &i2400mu->rx_size);
-	result = PTR_ERR(fd);
-	if (IS_ERR(fd) && result != -ENODEV) {
-		dev_err(dev, "Can't create debugfs entry "
-			"rx_size: %d\n", result);
-		goto error;
-	}
+	d_level_register_debugfs("dl_", usb, dentry);
+	d_level_register_debugfs("dl_", fw, dentry);
+	d_level_register_debugfs("dl_", notif, dentry);
+	d_level_register_debugfs("dl_", rx, dentry);
+	d_level_register_debugfs("dl_", tx, dentry);
 
-	return 0;
+	/* Don't touch these if you don't know what you are doing */
+	debugfs_create_u8("rx_size_auto_shrink", 0600, dentry,
+			  &i2400mu->rx_size_auto_shrink);
 
-error:
-	debugfs_remove_recursive(i2400mu->debugfs_dentry);
-	return result;
+	debugfs_create_size_t("rx_size", 0600, dentry, &i2400mu->rx_size);
 }
 
 
@@ -534,15 +501,9 @@ int i2400mu_probe(struct usb_interface *iface,
 		dev_err(dev, "cannot setup device: %d\n", result);
 		goto error_setup;
 	}
-	result = i2400mu_debugfs_add(i2400mu);
-	if (result < 0) {
-		dev_err(dev, "Can't register i2400mu's debugfs: %d\n", result);
-		goto error_debugfs_add;
-	}
+	i2400mu_debugfs_add(i2400mu);
 	return 0;
 
-error_debugfs_add:
-	i2400m_release(i2400m);
 error_setup:
 	usb_set_intfdata(iface, NULL);
 	usb_put_dev(i2400mu->usb_dev);
diff --git a/include/linux/wimax/debug.h b/include/linux/wimax/debug.h
index 7cb63e4ec0ae..4dd2c1cea6a9 100644
--- a/include/linux/wimax/debug.h
+++ b/include/linux/wimax/debug.h
@@ -98,9 +98,7 @@
  * To manipulate from user space the levels, create a debugfs dentry
  * and then register each submodule with:
  *
- *     result = d_level_register_debugfs("PREFIX_", submodule_X, parent);
- *     if (result < 0)
- *            goto error;
+ *     d_level_register_debugfs("PREFIX_", submodule_X, parent);
  *
  * Where PREFIX_ is a name of your chosing. This will create debugfs
  * file with a single numeric value that can be use to tweak it. To
@@ -408,25 +406,13 @@ do {							\
  * @submodule: name of submodule (not a string, just the name)
  * @dentry: debugfs parent dentry
  *
- * Returns: 0 if ok, < 0 errno on error.
- *
  * For removing, just use debugfs_remove_recursive() on the parent.
  */
 #define d_level_register_debugfs(prefix, name, parent)			\
 ({									\
-	int rc;								\
-	struct dentry *fd;						\
-	struct dentry *verify_parent_type = parent;			\
-	fd = debugfs_create_u8(						\
-		prefix #name, 0600, verify_parent_type,			\
+	debugfs_create_u8(						\
+		prefix #name, 0600, parent,				\
 		&(D_LEVEL[__D_SUBMODULE_ ## name].level));		\
-	rc = PTR_ERR(fd);						\
-	if (IS_ERR(fd) && rc != -ENODEV)				\
-		printk(KERN_ERR "%s: Can't create debugfs entry %s: "	\
-		       "%d\n", __func__, prefix #name, rc);		\
-	else								\
-		rc = 0;							\
-	rc;								\
 })
 
 
diff --git a/net/wimax/debugfs.c b/net/wimax/debugfs.c
index 1af56df30276..3c54bb6b925a 100644
--- a/net/wimax/debugfs.c
+++ b/net/wimax/debugfs.c
@@ -13,49 +13,23 @@
 #define D_SUBMODULE debugfs
 #include "debug-levels.h"
 
-
-#define __debugfs_register(prefix, name, parent)			\
-do {									\
-	result = d_level_register_debugfs(prefix, name, parent);	\
-	if (result < 0)							\
-		goto error;						\
-} while (0)
-
-
-int wimax_debugfs_add(struct wimax_dev *wimax_dev)
+void wimax_debugfs_add(struct wimax_dev *wimax_dev)
 {
-	int result;
 	struct net_device *net_dev = wimax_dev->net_dev;
-	struct device *dev = net_dev->dev.parent;
 	struct dentry *dentry;
 	char buf[128];
 
 	snprintf(buf, sizeof(buf), "wimax:%s", net_dev->name);
 	dentry = debugfs_create_dir(buf, NULL);
-	result = PTR_ERR(dentry);
-	if (IS_ERR(dentry)) {
-		if (result == -ENODEV)
-			result = 0;	/* No debugfs support */
-		else
-			dev_err(dev, "Can't create debugfs dentry: %d\n",
-				result);
-		goto out;
-	}
 	wimax_dev->debugfs_dentry = dentry;
-	__debugfs_register("wimax_dl_", debugfs, dentry);
-	__debugfs_register("wimax_dl_", id_table, dentry);
-	__debugfs_register("wimax_dl_", op_msg, dentry);
-	__debugfs_register("wimax_dl_", op_reset, dentry);
-	__debugfs_register("wimax_dl_", op_rfkill, dentry);
-	__debugfs_register("wimax_dl_", op_state_get, dentry);
-	__debugfs_register("wimax_dl_", stack, dentry);
-	result = 0;
-out:
-	return result;
 
-error:
-	debugfs_remove_recursive(wimax_dev->debugfs_dentry);
-	return result;
+	d_level_register_debugfs("wimax_dl_", debugfs, dentry);
+	d_level_register_debugfs("wimax_dl_", id_table, dentry);
+	d_level_register_debugfs("wimax_dl_", op_msg, dentry);
+	d_level_register_debugfs("wimax_dl_", op_reset, dentry);
+	d_level_register_debugfs("wimax_dl_", op_rfkill, dentry);
+	d_level_register_debugfs("wimax_dl_", op_state_get, dentry);
+	d_level_register_debugfs("wimax_dl_", stack, dentry);
 }
 
 void wimax_debugfs_rm(struct wimax_dev *wimax_dev)
diff --git a/net/wimax/stack.c b/net/wimax/stack.c
index 1ba99d65feca..4b9b1c5e8f3a 100644
--- a/net/wimax/stack.c
+++ b/net/wimax/stack.c
@@ -481,12 +481,7 @@ int wimax_dev_add(struct wimax_dev *wimax_dev, struct net_device *net_dev)
 	/* Set up user-space interaction */
 	mutex_lock(&wimax_dev->mutex);
 	wimax_id_table_add(wimax_dev);
-	result = wimax_debugfs_add(wimax_dev);
-	if (result < 0) {
-		dev_err(dev, "cannot initialize debugfs: %d\n",
-			result);
-		goto error_debugfs_add;
-	}
+	wimax_debugfs_add(wimax_dev);
 
 	__wimax_state_set(wimax_dev, WIMAX_ST_DOWN);
 	mutex_unlock(&wimax_dev->mutex);
@@ -498,10 +493,6 @@ int wimax_dev_add(struct wimax_dev *wimax_dev, struct net_device *net_dev)
 	d_fnend(3, dev, "(wimax_dev %p net_dev %p) = 0\n", wimax_dev, net_dev);
 	return 0;
 
-error_debugfs_add:
-	wimax_id_table_rm(wimax_dev);
-	mutex_unlock(&wimax_dev->mutex);
-	wimax_rfkill_rm(wimax_dev);
 error_rfkill_add:
 	d_fnend(3, dev, "(wimax_dev %p net_dev %p) = %d\n",
 		wimax_dev, net_dev, result);
diff --git a/net/wimax/wimax-internal.h b/net/wimax/wimax-internal.h
index e819a09337ee..40751207296c 100644
--- a/net/wimax/wimax-internal.h
+++ b/net/wimax/wimax-internal.h
@@ -57,13 +57,10 @@ void __wimax_state_set(struct wimax_dev *wimax_dev, enum wimax_st state)
 void __wimax_state_change(struct wimax_dev *, enum wimax_st);
 
 #ifdef CONFIG_DEBUG_FS
-int wimax_debugfs_add(struct wimax_dev *);
+void wimax_debugfs_add(struct wimax_dev *);
 void wimax_debugfs_rm(struct wimax_dev *);
 #else
-static inline int wimax_debugfs_add(struct wimax_dev *wimax_dev)
-{
-	return 0;
-}
+static inline void wimax_debugfs_add(struct wimax_dev *wimax_dev) {}
 static inline void wimax_debugfs_rm(struct wimax_dev *wimax_dev) {}
 #endif
 
-- 
2.22.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 868EB161782
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 17:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgBQQOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 11:14:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49224 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729015AbgBQQOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 11:14:48 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j3j2k-0003Cp-33; Mon, 17 Feb 2020 16:14:46 +0000
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
Subject: [PATCH net-next v2 07/10] drivers/base/power: add dpm_sysfs_change_owner()
Date:   Mon, 17 Feb 2020 17:14:33 +0100
Message-Id: <20200217161436.1748598-8-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200217161436.1748598-1-christian.brauner@ubuntu.com>
References: <20200217161436.1748598-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to change the owner of a device's power entries. This
needs to happen when the ownership of a device is changed, e.g. when
moving network devices between network namespaces.
The ownership of a device's power entries is determined based on the
ownership of the corresponding kobject, i.e. only if the ownership of a
kobject is changed will this function change the ownership of the
corresponding sysfs entries.
This function will be used to correctly account for ownership changes,
e.g. when moving network devices between network namespaces.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v2 */
- "Rafael J. Wysocki" <rafael@kernel.org>:
  -  Fold if (dev->power.wakeup && dev->power.wakeup->dev) check into
     if (device_can_wakeup(dev)) check since the former can never be true if
     the latter is false.

- Christian Brauner <christian.brauner@ubuntu.com>:
  - Place (dev->power.wakeup && dev->power.wakeup->dev) check under
    CONFIG_PM_SLEEP ifdefine since it will wakeup_source will only be available
    when this config option is set.
---
 drivers/base/core.c        |  4 ++++
 drivers/base/power/power.h |  2 ++
 drivers/base/power/sysfs.c | 40 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 915766c20a47..74ca07f9eb2b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3515,6 +3515,10 @@ int device_change_owner(struct device *dev)
 	if (error)
 		goto out;
 
+	error = dpm_sysfs_change_owner(dev);
+	if (error)
+		goto out;
+
 #ifdef CONFIG_BLOCK
 	if (sysfs_deprecated && dev->class == &block_class)
 		goto out;
diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index 444f5c169a0b..f68490d0811b 100644
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -74,6 +74,7 @@ extern int pm_qos_sysfs_add_flags(struct device *dev);
 extern void pm_qos_sysfs_remove_flags(struct device *dev);
 extern int pm_qos_sysfs_add_latency_tolerance(struct device *dev);
 extern void pm_qos_sysfs_remove_latency_tolerance(struct device *dev);
+extern int dpm_sysfs_change_owner(struct device *dev);
 
 #else /* CONFIG_PM */
 
@@ -88,6 +89,7 @@ static inline void pm_runtime_remove(struct device *dev) {}
 
 static inline int dpm_sysfs_add(struct device *dev) { return 0; }
 static inline void dpm_sysfs_remove(struct device *dev) {}
+static inline int dpm_sysfs_change_owner(struct device *dev) { return 0; }
 
 #endif
 
diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
index d7d82db2e4bc..a18ceafd921e 100644
--- a/drivers/base/power/sysfs.c
+++ b/drivers/base/power/sysfs.c
@@ -684,6 +684,46 @@ int dpm_sysfs_add(struct device *dev)
 	return rc;
 }
 
+int dpm_sysfs_change_owner(struct device *dev)
+{
+	int rc;
+
+	if (device_pm_not_required(dev))
+		return 0;
+
+	rc = sysfs_group_change_owner(&dev->kobj, &pm_attr_group);
+	if (rc)
+		return rc;
+
+	if (pm_runtime_callbacks_present(dev)) {
+		rc = sysfs_group_change_owner(&dev->kobj,
+					      &pm_runtime_attr_group);
+		if (rc)
+			return rc;
+	}
+	if (device_can_wakeup(dev)) {
+		rc = sysfs_group_change_owner(&dev->kobj,
+					      &pm_wakeup_attr_group);
+		if (rc)
+			return rc;
+
+#ifdef CONFIG_PM_SLEEP
+		if (dev->power.wakeup && dev->power.wakeup->dev) {
+			rc = device_change_owner(dev->power.wakeup->dev);
+			if (rc)
+				return rc;
+		}
+#endif
+	}
+	if (dev->power.set_latency_tolerance) {
+		rc = sysfs_group_change_owner(&dev->kobj,
+				&pm_qos_latency_tolerance_attr_group);
+		if (rc)
+			return rc;
+	}
+	return 0;
+}
+
 int wakeup_sysfs_add(struct device *dev)
 {
 	return sysfs_merge_group(&dev->kobj, &pm_wakeup_attr_group);
-- 
2.25.0


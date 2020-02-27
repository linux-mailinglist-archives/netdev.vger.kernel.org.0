Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E855170F1B
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 04:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgB0DkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 22:40:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40168 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728252AbgB0Dj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 22:39:57 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j7A1j-00030x-0D; Thu, 27 Feb 2020 03:39:55 +0000
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
Subject: [PATCH v7 6/9] drivers/base/power: add dpm_sysfs_change_owner()
Date:   Thu, 27 Feb 2020 04:37:16 +0100
Message-Id: <20200227033719.1652190-7-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227033719.1652190-1-christian.brauner@ubuntu.com>
References: <20200227033719.1652190-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to change the owner of a device's power entries. This
needs to happen when the ownership of a device is changed, e.g. when
moving network devices between network namespaces.
This function will be used to correctly account for ownership changes,
e.g. when moving network devices between network namespaces.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: "Rafael J. Wysocki" <rafael@kernel.org>
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

/* v3 */
-  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
   - Add explicit uid/gid parameters.

/* v4 */
- "Rafael J. Wysocki" <rafael@kernel.org>:
   - Remove in-function #ifdef in favor of separate helper that is a nop
     whenver !CONFIG_PM_SLEEP.

/* v5 */
- "Rafael J. Wysocki" <rafael@kernel.org>:
   - Return directly if condition is true in dpm_sysfs_wakeup_change_owner()
     instead of using additional variable.

/* v6 */
- Christian Brauner <christian.brauner@ubuntu.com>:
  - Make dpm_sysfs_wakeup_change_owner() static inline.

/* v7 */
unchanged
---
 drivers/base/core.c        |  4 +++
 drivers/base/power/power.h |  3 +++
 drivers/base/power/sysfs.c | 55 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 988f34ce2eb0..fb8b7990f6fd 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3552,6 +3552,10 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
 	if (error)
 		goto out;
 
+	error = dpm_sysfs_change_owner(dev, kuid, kgid);
+	if (error)
+		goto out;
+
 #ifdef CONFIG_BLOCK
 	if (sysfs_deprecated && dev->class == &block_class)
 		goto out;
diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index 444f5c169a0b..54292cdd7808 100644
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -74,6 +74,7 @@ extern int pm_qos_sysfs_add_flags(struct device *dev);
 extern void pm_qos_sysfs_remove_flags(struct device *dev);
 extern int pm_qos_sysfs_add_latency_tolerance(struct device *dev);
 extern void pm_qos_sysfs_remove_latency_tolerance(struct device *dev);
+extern int dpm_sysfs_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid);
 
 #else /* CONFIG_PM */
 
@@ -88,6 +89,8 @@ static inline void pm_runtime_remove(struct device *dev) {}
 
 static inline int dpm_sysfs_add(struct device *dev) { return 0; }
 static inline void dpm_sysfs_remove(struct device *dev) {}
+static inline int dpm_sysfs_change_owner(struct device *dev, kuid_t kuid,
+					 kgid_t kgid) { return 0; }
 
 #endif
 
diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
index d7d82db2e4bc..2b99fe1eb207 100644
--- a/drivers/base/power/sysfs.c
+++ b/drivers/base/power/sysfs.c
@@ -480,6 +480,14 @@ static ssize_t wakeup_last_time_ms_show(struct device *dev,
 	return enabled ? sprintf(buf, "%lld\n", msec) : sprintf(buf, "\n");
 }
 
+static inline int dpm_sysfs_wakeup_change_owner(struct device *dev, kuid_t kuid,
+						kgid_t kgid)
+{
+	if (dev->power.wakeup && dev->power.wakeup->dev)
+		return device_change_owner(dev->power.wakeup->dev, kuid, kgid);
+	return 0;
+}
+
 static DEVICE_ATTR_RO(wakeup_last_time_ms);
 
 #ifdef CONFIG_PM_AUTOSLEEP
@@ -501,7 +509,13 @@ static ssize_t wakeup_prevent_sleep_time_ms_show(struct device *dev,
 
 static DEVICE_ATTR_RO(wakeup_prevent_sleep_time_ms);
 #endif /* CONFIG_PM_AUTOSLEEP */
-#endif /* CONFIG_PM_SLEEP */
+#else /* CONFIG_PM_SLEEP */
+static inline int dpm_sysfs_wakeup_change_owner(struct device *dev, kuid_t kuid,
+						kgid_t kgid)
+{
+	return 0;
+}
+#endif
 
 #ifdef CONFIG_PM_ADVANCED_DEBUG
 static ssize_t runtime_usage_show(struct device *dev,
@@ -684,6 +698,45 @@ int dpm_sysfs_add(struct device *dev)
 	return rc;
 }
 
+int dpm_sysfs_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
+{
+	int rc;
+
+	if (device_pm_not_required(dev))
+		return 0;
+
+	rc = sysfs_group_change_owner(&dev->kobj, &pm_attr_group, kuid, kgid);
+	if (rc)
+		return rc;
+
+	if (pm_runtime_callbacks_present(dev)) {
+		rc = sysfs_group_change_owner(
+			&dev->kobj, &pm_runtime_attr_group, kuid, kgid);
+		if (rc)
+			return rc;
+	}
+
+	if (device_can_wakeup(dev)) {
+		rc = sysfs_group_change_owner(&dev->kobj, &pm_wakeup_attr_group,
+					      kuid, kgid);
+		if (rc)
+			return rc;
+
+		rc = dpm_sysfs_wakeup_change_owner(dev, kuid, kgid);
+		if (rc)
+			return rc;
+	}
+
+	if (dev->power.set_latency_tolerance) {
+		rc = sysfs_group_change_owner(
+			&dev->kobj, &pm_qos_latency_tolerance_attr_group, kuid,
+			kgid);
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
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6DB6162A90
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 17:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgBRQam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 11:30:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57215 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgBRQaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 11:30:10 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j45lA-0003h0-Dl; Tue, 18 Feb 2020 16:30:08 +0000
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
Subject: [PATCH net-next v3 6/9] drivers/base/power: add dpm_sysfs_change_owner()
Date:   Tue, 18 Feb 2020 17:29:40 +0100
Message-Id: <20200218162943.2488012-7-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
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
---
 drivers/base/core.c        |  4 ++++
 drivers/base/power/power.h |  3 +++
 drivers/base/power/sysfs.c | 42 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index ec0d5e8cfd0f..efec2792f5d7 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3522,6 +3522,10 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
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
index d7d82db2e4bc..4e79afcd5ca8 100644
--- a/drivers/base/power/sysfs.c
+++ b/drivers/base/power/sysfs.c
@@ -684,6 +684,48 @@ int dpm_sysfs_add(struct device *dev)
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
+	if (device_can_wakeup(dev)) {
+		rc = sysfs_group_change_owner(&dev->kobj, &pm_wakeup_attr_group,
+					      kuid, kgid);
+		if (rc)
+			return rc;
+
+#ifdef CONFIG_PM_SLEEP
+		if (dev->power.wakeup && dev->power.wakeup->dev) {
+			rc = device_change_owner(dev->power.wakeup->dev, kuid,
+						 kgid);
+			if (rc)
+				return rc;
+		}
+#endif
+	}
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
2.25.0


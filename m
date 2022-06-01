Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5AE539DC7
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 09:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350148AbiFAHHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 03:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349993AbiFAHHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 03:07:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901708CB04
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 00:07:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n201-20020a2540d2000000b0065cbae85d67so715226yba.11
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 00:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0HXVJdCIsomGxp3WPSn+2YS1x/Q9SjPFbGK9Hb8FY3Q=;
        b=Jsx/IdjeTXR9MiQtdujJ0FlEiN2DLL3p1z/+sKrPzQ5PVUHP/npXBXYzqCNA1KWL0X
         z3oIUD2EKzfWwjtb9Rp9R7DWWWZTVuLSbHgj2j1SyWjMt0zOaH9Yzntys+ofnzk2dj/W
         f3u0Pu0UOiGibZ6P3V82NUN/7H7F60cOtPgOtUY6yJzIQULjU3s0zTX4zyZV36B4xh4X
         UlsMI7AImfk8W+elLBcnH2I63UaRpt0wpc2o1GxrV9VXFItxShjqOzLDTBF02tjKFhw5
         3cRWGoHuDz/LQWJPe0249jYTzWv1t308fA03c3f/rQb7eCTa7XL/8r8ZXPI4kigmDRGo
         96bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0HXVJdCIsomGxp3WPSn+2YS1x/Q9SjPFbGK9Hb8FY3Q=;
        b=ZKtb3hDlhnsK58cuxHR+PxqB2uLcMlDtHm0VwbO8Hyn8GHTOMGEh1LzEMVGR7r+8jn
         KFI0k+c3vc4azcAvR1WewuM8RoCYUj5OJmi5iqLcd5XnqmrOa3bWHHtGvJr+UjCX6yV9
         9+AUE+ReAJCjqtEVLLJTDc5lqEPEzauKH/VQ0vOvSdqlvx2U98GTHuL+VPoWZVbZhxHX
         K3KF09lWIamKkDd0/7E9y244MFeY2VaCuGnvt1pdVOXqWNVKmmfJ9cm2LBgvjUHPFG0w
         zvMxqfO51hOd1d2MNeUDyg1WrLAPTB1k0WYW4N45/oBks2+y1rDqhyXbbnZS42o85PhG
         XeZQ==
X-Gm-Message-State: AOAM532tOi4Ri6IBx/q19hIRfGCwpdGfd1t7dTvJD41kugnBvoj8lgha
        tRyEauVHCUr4yrHbxUMqe5kyDsJYnibQ9dk=
X-Google-Smtp-Source: ABdhPJwJjzxLgIuLlsumiwwcLunjHDDJmCACEgK5Oc+WJCGQpf48+C4ImTSOeUa5BoryRp796dUO+ICognLJoOA=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:f3aa:cafe:c20a:e136])
 (user=saravanak job=sendgmr) by 2002:a0d:db81:0:b0:30c:2ba5:9e1d with SMTP id
 d123-20020a0ddb81000000b0030c2ba59e1dmr19834254ywe.519.1654067243146; Wed, 01
 Jun 2022 00:07:23 -0700 (PDT)
Date:   Wed,  1 Jun 2022 00:07:00 -0700
In-Reply-To: <20220601070707.3946847-1-saravanak@google.com>
Message-Id: <20220601070707.3946847-5-saravanak@google.com>
Mime-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 4/9] driver core: Add wait_for_init_devices_probe helper function
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices might need to be probed and bound successfully before the
kernel boot sequence can finish and move on to init/userspace. For
example, a network interface might need to be bound to be able to mount
a NFS rootfs.

With fw_devlink=on by default, some of these devices might be blocked
from probing because they are waiting on a optional supplier that
doesn't have a driver. While fw_devlink will eventually identify such
devices and unblock the probing automatically, it might be too late by
the time it unblocks the probing of devices. For example, the IP4
autoconfig might timeout before fw_devlink unblocks probing of the
network interface.

This function is available to temporarily try and probe all devices that
have a driver even if some of their suppliers haven't been added or
don't have drivers.

The drivers can then decide which of the suppliers are optional vs
mandatory and probe the device if possible. By the time this function
returns, all such "best effort" probes are guaranteed to be completed.
If a device successfully probes in this mode, we delete all fw_devlink
discovered dependencies of that device where the supplier hasn't yet
probed successfully because they have to be optional dependencies.

This also means that some devices that aren't needed for init and could
have waited for their optional supplier to probe (when the supplier's
module is loaded later on) would end up probing prematurely with limited
functionality.  So call this function only when boot would fail without
it.

Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/base/base.h           |   1 +
 drivers/base/core.c           | 100 ++++++++++++++++++++++++++++++++--
 drivers/base/dd.c             |  19 +++++--
 include/linux/device/driver.h |   1 +
 4 files changed, 110 insertions(+), 11 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index ab71403d102f..b3a43a164dcd 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -160,6 +160,7 @@ extern int devres_release_all(struct device *dev);
 extern void device_block_probing(void);
 extern void device_unblock_probing(void);
 extern void deferred_probe_extend_timeout(void);
+extern void driver_deferred_probe_trigger(void);
 
 /* /sys/devices directory */
 extern struct kset *devices_kset;
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7cd789c4985d..61fdfe99b348 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -54,6 +54,7 @@ static unsigned int defer_sync_state_count = 1;
 static DEFINE_MUTEX(fwnode_link_lock);
 static bool fw_devlink_is_permissive(void);
 static bool fw_devlink_drv_reg_done;
+static bool fw_devlink_best_effort;
 
 /**
  * fwnode_link_add - Create a link between two fwnode_handles.
@@ -965,6 +966,11 @@ static void device_links_missing_supplier(struct device *dev)
 	}
 }
 
+static bool dev_is_best_effort(struct device *dev)
+{
+	return fw_devlink_best_effort && dev->can_match;
+}
+
 /**
  * device_links_check_suppliers - Check presence of supplier drivers.
  * @dev: Consumer device.
@@ -984,7 +990,7 @@ static void device_links_missing_supplier(struct device *dev)
 int device_links_check_suppliers(struct device *dev)
 {
 	struct device_link *link;
-	int ret = 0;
+	int ret = 0, fwnode_ret = 0;
 	struct fwnode_handle *sup_fw;
 
 	/*
@@ -997,12 +1003,17 @@ int device_links_check_suppliers(struct device *dev)
 		sup_fw = list_first_entry(&dev->fwnode->suppliers,
 					  struct fwnode_link,
 					  c_hook)->supplier;
-		dev_err_probe(dev, -EPROBE_DEFER, "wait for supplier %pfwP\n",
-			      sup_fw);
-		mutex_unlock(&fwnode_link_lock);
-		return -EPROBE_DEFER;
+		if (!dev_is_best_effort(dev)) {
+			fwnode_ret = -EPROBE_DEFER;
+			dev_err_probe(dev, -EPROBE_DEFER,
+				    "wait for supplier %pfwP\n", sup_fw);
+		} else {
+			fwnode_ret = -EAGAIN;
+		}
 	}
 	mutex_unlock(&fwnode_link_lock);
+	if (fwnode_ret == -EPROBE_DEFER)
+		return fwnode_ret;
 
 	device_links_write_lock();
 
@@ -1012,6 +1023,14 @@ int device_links_check_suppliers(struct device *dev)
 
 		if (link->status != DL_STATE_AVAILABLE &&
 		    !(link->flags & DL_FLAG_SYNC_STATE_ONLY)) {
+
+			if (dev_is_best_effort(dev) &&
+			    link->flags & DL_FLAG_INFERRED &&
+			    !link->supplier->can_match) {
+				ret = -EAGAIN;
+				continue;
+			}
+
 			device_links_missing_supplier(dev);
 			dev_err_probe(dev, -EPROBE_DEFER,
 				      "supplier %s not ready\n",
@@ -1024,7 +1043,8 @@ int device_links_check_suppliers(struct device *dev)
 	dev->links.status = DL_DEV_PROBING;
 
 	device_links_write_unlock();
-	return ret;
+
+	return ret ? ret : fwnode_ret;
 }
 
 /**
@@ -1289,6 +1309,18 @@ void device_links_driver_bound(struct device *dev)
 			 * save to drop the managed link completely.
 			 */
 			device_link_drop_managed(link);
+		} else if (dev_is_best_effort(dev) &&
+			   link->flags & DL_FLAG_INFERRED &&
+			   link->status != DL_STATE_CONSUMER_PROBE &&
+			   !link->supplier->can_match) {
+			/*
+			 * When dev_is_best_effort() is true, we ignore device
+			 * links to suppliers that don't have a driver.  If the
+			 * consumer device still managed to probe, there's no
+			 * point in maintaining a device link in a weird state
+			 * (consumer probed before supplier). So delete it.
+			 */
+			device_link_drop_managed(link);
 		} else {
 			WARN_ON(link->status != DL_STATE_CONSUMER_PROBE);
 			WRITE_ONCE(link->status, DL_STATE_ACTIVE);
@@ -1655,6 +1687,62 @@ void fw_devlink_drivers_done(void)
 	device_links_write_unlock();
 }
 
+/**
+ * wait_for_init_devices_probe - Try to probe any device needed for init
+ *
+ * Some devices might need to be probed and bound successfully before the kernel
+ * boot sequence can finish and move on to init/userspace. For example, a
+ * network interface might need to be bound to be able to mount a NFS rootfs.
+ *
+ * With fw_devlink=on by default, some of these devices might be blocked from
+ * probing because they are waiting on a optional supplier that doesn't have a
+ * driver. While fw_devlink will eventually identify such devices and unblock
+ * the probing automatically, it might be too late by the time it unblocks the
+ * probing of devices. For example, the IP4 autoconfig might timeout before
+ * fw_devlink unblocks probing of the network interface.
+ *
+ * This function is available to temporarily try and probe all devices that have
+ * a driver even if some of their suppliers haven't been added or don't have
+ * drivers.
+ *
+ * The drivers can then decide which of the suppliers are optional vs mandatory
+ * and probe the device if possible. By the time this function returns, all such
+ * "best effort" probes are guaranteed to be completed. If a device successfully
+ * probes in this mode, we delete all fw_devlink discovered dependencies of that
+ * device where the supplier hasn't yet probed successfully because they have to
+ * be optional dependencies.
+ *
+ * Any devices that didn't successfully probe go back to being treated as if
+ * this function was never called.
+ *
+ * This also means that some devices that aren't needed for init and could have
+ * waited for their optional supplier to probe (when the supplier's module is
+ * loaded later on) would end up probing prematurely with limited functionality.
+ * So call this function only when boot would fail without it.
+ */
+void __init wait_for_init_devices_probe(void)
+{
+	if (!fw_devlink_flags || fw_devlink_is_permissive())
+		return;
+
+	/*
+	 * Wait for all ongoing probes to finish so that the "best effort" is
+	 * only applied to devices that can't probe otherwise.
+	 */
+	wait_for_device_probe();
+
+	pr_info("Trying to probe devices needed for running init ...\n");
+	fw_devlink_best_effort = true;
+	driver_deferred_probe_trigger();
+
+	/*
+	 * Wait for all "best effort" probes to finish before going back to
+	 * normal enforcement.
+	 */
+	wait_for_device_probe();
+	fw_devlink_best_effort = false;
+}
+
 static void fw_devlink_unblock_consumers(struct device *dev)
 {
 	struct device_link *link;
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 11b0fb6414d3..4a55fbb7e0da 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -172,7 +172,7 @@ static bool driver_deferred_probe_enable;
  * changes in the midst of a probe, then deferred processing should be triggered
  * again.
  */
-static void driver_deferred_probe_trigger(void)
+void driver_deferred_probe_trigger(void)
 {
 	if (!driver_deferred_probe_enable)
 		return;
@@ -580,7 +580,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 {
 	bool test_remove = IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE) &&
 			   !drv->suppress_bind_attrs;
-	int ret;
+	int ret, link_ret;
 
 	if (defer_all_probes) {
 		/*
@@ -592,9 +592,9 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		return -EPROBE_DEFER;
 	}
 
-	ret = device_links_check_suppliers(dev);
-	if (ret)
-		return ret;
+	link_ret = device_links_check_suppliers(dev);
+	if (link_ret == -EPROBE_DEFER)
+		return link_ret;
 
 	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
 		 drv->bus->name, __func__, drv->name, dev_name(dev));
@@ -633,6 +633,15 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 
 	ret = call_driver_probe(dev, drv);
 	if (ret) {
+		/*
+		 * If fw_devlink_best_effort is active (denoted by -EAGAIN), the
+		 * device might actually probe properly once some of its missing
+		 * suppliers have probed. So, treat this as if the driver
+		 * returned -EPROBE_DEFER.
+		 */
+		if (link_ret == -EAGAIN)
+			ret = -EPROBE_DEFER;
+
 		/*
 		 * Return probe errors as positive values so that the callers
 		 * can distinguish them from other errors.
diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
index 700453017e1c..2114d65b862f 100644
--- a/include/linux/device/driver.h
+++ b/include/linux/device/driver.h
@@ -129,6 +129,7 @@ extern struct device_driver *driver_find(const char *name,
 					 struct bus_type *bus);
 extern int driver_probe_done(void);
 extern void wait_for_device_probe(void);
+void __init wait_for_init_devices_probe(void);
 
 /* sysfs interface for exporting driver attributes */
 
-- 
2.36.1.255.ge46751e96f-goog


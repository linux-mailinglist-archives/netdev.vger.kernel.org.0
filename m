Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487C81A8831
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503224AbgDNSBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503196AbgDNSBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:01:31 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C28C061A0E;
        Tue, 14 Apr 2020 11:01:31 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 252982A1BDE
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
To:     linux-pm@vger.kernel.org
Cc:     Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Subject: [RFC v2 6/9] thermal: Remove get_mode() method
Date:   Tue, 14 Apr 2020 20:01:02 +0200
Message-Id: <20200414180105.20042-7-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414180105.20042-1-andrzej.p@collabora.com>
References: <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
 <20200414180105.20042-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that mode of all thermal zone devices is stored in struct
thermal_zone_device the get_mode() method is not used nor necessary any
more. All its former users used it only to report the state of their
then-internal variable.

The sysfs "mode" attribute is always exposed from now on. It doesn't hurt
the drivers which don't provide their own set_mode(), because writing to
"mode" will result in -EPERM, as expected.

thermal_zone_device_get_mode() will always succeed, so let it return the
actual value rather than an always-zero return code.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/acpi/thermal.c                        | 12 ++--------
 drivers/thermal/imx_thermal.c                 |  6 +----
 .../intel/int340x_thermal/int3400_thermal.c   |  6 +----
 drivers/thermal/thermal_core.c                | 16 +-------------
 drivers/thermal/thermal_sysfs.c               | 22 +------------------
 include/linux/thermal.h                       | 16 ++++++++------
 6 files changed, 15 insertions(+), 63 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 755f12b76c20..bfe573076a3f 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -500,11 +500,7 @@ static void acpi_thermal_check(void *data)
 	struct acpi_thermal *tz = data;
 	enum thermal_device_mode mode;
 
-	/*
-	 * this driver does not provide ->get_mode(), so calling
-	 * thermal_zone_device_get_mode() always succeeds
-	 */
-	thermal_zone_device_get_mode(tz->thermal_zone, &mode);
+	mode = thermal_zone_device_get_mode(tz->thermal_zone);
 	if (mode != THERMAL_DEVICE_ENABLED)
 		return;
 
@@ -546,11 +542,7 @@ static int thermal_set_mode(struct thermal_zone_device *thermal,
 	if (mode == THERMAL_DEVICE_DISABLED)
 		pr_warn("thermal zone will be disabled\n");
 
-	/*
-	 * this driver does not provide ->get_mode(), so calling
-	 * thermal_zone_device_get_mode() always succeeds
-	 */
-	thermal_zone_device_get_mode(thermal, &old_mode);
+	old_mode = thermal_zone_device_get_mode(thermal);
 
 	if (mode != old_mode) {
 		thermal_zone_device_store_mode(thermal, mode);
diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index f3f602b4ece5..8b683c6585cf 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -256,11 +256,7 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
 	bool wait;
 	u32 val;
 
-	/*
-	 * this driver does not provide ->get_mode(), so calling
-	 * thermal_zone_device_get_mode() always succeeds
-	 */
-	thermal_zone_device_get_mode(tz, &mode);
+	mode = thermal_zone_device_get_mode(tz);
 	if (mode == THERMAL_DEVICE_ENABLED) {
 		/* Check if a measurement is currently in progress */
 		regmap_read(map, soc_data->temp_data, &val);
diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index a7d9b42c060d..20007fafc04b 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -240,11 +240,7 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
 	    mode != THERMAL_DEVICE_DISABLED)
 		return -EINVAL;
 
-	/*
-	 * this driver does not provide ->get_mode(), so calling
-	 * thermal_zone_device_get_mode() always succeeds
-	 */
-	thermal_zone_device_get_mode(thermal, &old_mode);
+	old_mode = thermal_zone_device_get_mode(thermal);
 	if (mode != old_mode) {
 		thermal_zone_device_store_mode(thermal, mode);
 		result = int3400_thermal_run_osc(priv->adev->handle,
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index cb0ff47f0dbe..a59c3411fb9c 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -469,18 +469,6 @@ static void thermal_zone_device_reset(struct thermal_zone_device *tz)
 	thermal_zone_device_init(tz);
 }
 
-int thermal_zone_device_get_mode(struct thermal_zone_device *tz,
-				 enum thermal_device_mode *mode)
-{
-	if (tz->ops->get_mode)
-		return tz->ops->get_mode(tz, mode);
-
-	*mode = tz->mode;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(thermal_zone_device_get_mode);
-
 int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
 				 enum thermal_device_mode mode)
 {
@@ -1507,9 +1495,7 @@ static int thermal_pm_notify(struct notifier_block *nb,
 	case PM_POST_SUSPEND:
 		atomic_set(&in_suspend, 0);
 		list_for_each_entry(tz, &thermal_tz_list, node) {
-			tz_mode = THERMAL_DEVICE_ENABLED;
-			if (tz->ops->get_mode)
-				tz->ops->get_mode(tz, &tz_mode);
+			tz_mode = thermal_zone_device_get_mode(tz);
 
 			if (tz_mode == THERMAL_DEVICE_DISABLED)
 				continue;
diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index 66d9691b8bd6..cbb27b3c96d2 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -50,11 +50,8 @@ mode_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct thermal_zone_device *tz = to_thermal_zone(dev);
 	enum thermal_device_mode mode;
-	int result;
 
-	result = thermal_zone_device_get_mode(tz, &mode);
-	if (result)
-		return result;
+	mode = thermal_zone_device_get_mode(tz);
 
 	return sprintf(buf, "%s\n", mode == THERMAL_DEVICE_ENABLED ? "enabled"
 		       : "disabled");
@@ -425,30 +422,13 @@ static struct attribute_group thermal_zone_attribute_group = {
 	.attrs = thermal_zone_dev_attrs,
 };
 
-/* We expose mode only if .get_mode is present */
 static struct attribute *thermal_zone_mode_attrs[] = {
 	&dev_attr_mode.attr,
 	NULL,
 };
 
-static umode_t thermal_zone_mode_is_visible(struct kobject *kobj,
-					    struct attribute *attr,
-					    int attrno)
-{
-	struct device *dev = container_of(kobj, struct device, kobj);
-	struct thermal_zone_device *tz;
-
-	tz = container_of(dev, struct thermal_zone_device, device);
-
-	if (tz->ops->get_mode)
-		return attr->mode;
-
-	return 0;
-}
-
 static struct attribute_group thermal_zone_mode_attribute_group = {
 	.attrs = thermal_zone_mode_attrs,
-	.is_visible = thermal_zone_mode_is_visible,
 };
 
 /* We expose passive only if passive trips are present */
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 9ff8542b7e7d..efb481088035 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -86,8 +86,6 @@ struct thermal_zone_device_ops {
 		       struct thermal_cooling_device *);
 	int (*get_temp) (struct thermal_zone_device *, int *);
 	int (*set_trips) (struct thermal_zone_device *, int, int);
-	int (*get_mode) (struct thermal_zone_device *,
-			 enum thermal_device_mode *);
 	int (*set_mode) (struct thermal_zone_device *,
 		enum thermal_device_mode);
 	int (*get_trip_type) (struct thermal_zone_device *, int,
@@ -440,8 +438,12 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *, int,
 int thermal_zone_unbind_cooling_device(struct thermal_zone_device *, int,
 				       struct thermal_cooling_device *);
 
-int thermal_zone_device_get_mode(struct thermal_zone_device *tz,
-				 enum thermal_device_mode *mode);
+static inline enum thermal_device_mode
+thermal_zone_device_get_mode(struct thermal_zone_device *tz)
+{
+	return tz->mode;
+}
+
 int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
 				 enum thermal_device_mode mode);
 
@@ -509,9 +511,9 @@ static inline int thermal_zone_unbind_cooling_device(
 	struct thermal_zone_device *tz, int trip,
 	struct thermal_cooling_device *cdev)
 { return -ENODEV; }
-static inline int thermal_zone_device_get_mode(struct thermal_zone_device *tz,
-					       enum thermal_device_mode *mode)
-{ return -ENODEV; }
+static inline enum thermal_device_mode
+thermal_zone_device_get_mode(struct thermal_zone_device *tz)
+{ return THERMAL_DEVICE_DISABLED; }
 static inline int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
 					       enum thermal_device_mode mode)
 { return -ENODEV; }
-- 
2.17.1


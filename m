Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144971A885E
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503301AbgDNSC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:02:58 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46710 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503186AbgDNSB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:01:27 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id F37A42A1BDC
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
Subject: [RFC v2 4/9] thermal: core: Let thermal zone device's mode be stored in its struct
Date:   Tue, 14 Apr 2020 20:01:00 +0200
Message-Id: <20200414180105.20042-5-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414180105.20042-1-andrzej.p@collabora.com>
References: <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
 <20200414180105.20042-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the drivers which provide ->get_mode()/->set_mode() methods store their
mode in a thermal_device_mode enum, so keep this information in struct
thermal_zone_device rather than scattered all over the place.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/thermal/thermal_core.c  | 28 +++++++++++++++++++
 drivers/thermal/thermal_sysfs.c |  9 +++----
 include/linux/thermal.h         | 48 +++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 9a321dc548c8..cb0ff47f0dbe 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -469,6 +469,34 @@ static void thermal_zone_device_reset(struct thermal_zone_device *tz)
 	thermal_zone_device_init(tz);
 }
 
+int thermal_zone_device_get_mode(struct thermal_zone_device *tz,
+				 enum thermal_device_mode *mode)
+{
+	if (tz->ops->get_mode)
+		return tz->ops->get_mode(tz, mode);
+
+	*mode = tz->mode;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(thermal_zone_device_get_mode);
+
+int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
+				 enum thermal_device_mode mode)
+{
+	if (mode != THERMAL_DEVICE_DISABLED &&
+	    mode != THERMAL_DEVICE_ENABLED)
+		return -EINVAL;
+
+	if (tz->ops->set_mode)
+		return tz->ops->set_mode(tz, mode);
+
+	tz->mode = mode;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(thermal_zone_device_set_mode);
+
 void thermal_zone_device_update(struct thermal_zone_device *tz,
 				enum thermal_notify_event event)
 {
diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index aa99edb4dff7..66d9691b8bd6 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -52,10 +52,7 @@ mode_show(struct device *dev, struct device_attribute *attr, char *buf)
 	enum thermal_device_mode mode;
 	int result;
 
-	if (!tz->ops->get_mode)
-		return -EPERM;
-
-	result = tz->ops->get_mode(tz, &mode);
+	result = thermal_zone_device_get_mode(tz, &mode);
 	if (result)
 		return result;
 
@@ -74,9 +71,9 @@ mode_store(struct device *dev, struct device_attribute *attr,
 		return -EPERM;
 
 	if (!strncmp(buf, "enabled", sizeof("enabled") - 1))
-		result = tz->ops->set_mode(tz, THERMAL_DEVICE_ENABLED);
+		result = thermal_zone_device_enable(tz);
 	else if (!strncmp(buf, "disabled", sizeof("disabled") - 1))
-		result = tz->ops->set_mode(tz, THERMAL_DEVICE_DISABLED);
+		result = thermal_zone_device_disable(tz);
 	else
 		result = -EINVAL;
 
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index c91b1e344d56..9ff8542b7e7d 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -143,6 +143,7 @@ struct thermal_attr {
  * @trip_temp_attrs:	attributes for trip points for sysfs: trip temperature
  * @trip_type_attrs:	attributes for trip points for sysfs: trip type
  * @trip_hyst_attrs:	attributes for trip points for sysfs: trip hysteresis
+ * @mode:		current mode of this thermal zone
  * @devdata:	private pointer for device private data
  * @trips:	number of trip points the thermal zone supports
  * @trips_disabled;	bitmap for disabled trips
@@ -185,6 +186,7 @@ struct thermal_zone_device {
 	struct thermal_attr *trip_temp_attrs;
 	struct thermal_attr *trip_type_attrs;
 	struct thermal_attr *trip_hyst_attrs;
+	enum thermal_device_mode mode;
 	void *devdata;
 	int trips;
 	unsigned long trips_disabled;	/* bitmap for disabled trips */
@@ -437,6 +439,19 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *, int,
 				     unsigned int);
 int thermal_zone_unbind_cooling_device(struct thermal_zone_device *, int,
 				       struct thermal_cooling_device *);
+
+int thermal_zone_device_get_mode(struct thermal_zone_device *tz,
+				 enum thermal_device_mode *mode);
+int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
+				 enum thermal_device_mode mode);
+
+static inline void
+thermal_zone_device_store_mode(struct thermal_zone_device *tz,
+			       enum thermal_device_mode mode)
+{
+	tz->mode = mode;
+}
+
 void thermal_zone_device_update(struct thermal_zone_device *,
 				enum thermal_notify_event);
 void thermal_zone_set_trips(struct thermal_zone_device *);
@@ -494,6 +509,17 @@ static inline int thermal_zone_unbind_cooling_device(
 	struct thermal_zone_device *tz, int trip,
 	struct thermal_cooling_device *cdev)
 { return -ENODEV; }
+static inline int thermal_zone_device_get_mode(struct thermal_zone_device *tz,
+					       enum thermal_device_mode *mode)
+{ return -ENODEV; }
+static inline int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
+					       enum thermal_device_mode mode)
+{ return -ENODEV; }
+static inline void
+thermal_zone_device_store_mode(struct thermal_zone_device *tz,
+			       enum thermal_device_mode mode)
+{ }
+
 static inline void thermal_zone_device_update(struct thermal_zone_device *tz,
 					      enum thermal_notify_event event)
 { }
@@ -543,4 +569,26 @@ static inline void thermal_notify_framework(struct thermal_zone_device *tz,
 { }
 #endif /* CONFIG_THERMAL */
 
+static inline int thermal_zone_device_enable(struct thermal_zone_device *tz)
+{
+	return thermal_zone_device_set_mode(tz, THERMAL_DEVICE_ENABLED);
+}
+
+static inline int thermal_zone_device_disable(struct thermal_zone_device *tz)
+{
+	return thermal_zone_device_set_mode(tz, THERMAL_DEVICE_DISABLED);
+}
+
+static inline void
+thermal_zone_device_store_enabled(struct thermal_zone_device *tz)
+{
+	thermal_zone_device_store_mode(tz, THERMAL_DEVICE_ENABLED);
+}
+
+static inline void
+thermal_zone_device_store_disabled(struct thermal_zone_device *tz)
+{
+	thermal_zone_device_store_mode(tz, THERMAL_DEVICE_DISABLED);
+}
+
 #endif /* __THERMAL_H__ */
-- 
2.17.1


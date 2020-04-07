Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97FF31A1309
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 19:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgDGRtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 13:49:50 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42992 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbgDGRtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 13:49:49 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 8C9132972AA
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
Subject: [RFC 5/8] thermal: core: Monitor thermal zone after mode change
Date:   Tue,  7 Apr 2020 19:49:23 +0200
Message-Id: <20200407174926.23971-6-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200407174926.23971-1-andrzej.p@collabora.com>
References: <20200407174926.23971-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mode changing might imply a need to stop/start polling the device.
monitor_thermal_zone() when mode changes or if previous mode is unknown.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/thermal/thermal_core.c  | 26 ++++++++++++++++++++++++++
 drivers/thermal/thermal_core.h  |  2 ++
 drivers/thermal/thermal_sysfs.c |  8 +++++---
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 9a321dc548c8..aae2b049d45c 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -469,6 +469,32 @@ static void thermal_zone_device_reset(struct thermal_zone_device *tz)
 	thermal_zone_device_init(tz);
 }
 
+int thermal_zone_set_mode(struct thermal_zone_device *tz,
+			  enum thermal_device_mode mode)
+{
+	enum thermal_device_mode old_mode;
+	int result;
+
+	if (!tz->ops->set_mode)
+		return -EPERM;
+
+	if (tz->ops->get_mode) {
+		result = tz->ops->get_mode(tz, &old_mode);
+		if (result)
+			return result;
+	}
+
+	result = tz->ops->set_mode(tz, mode);
+	if (result)
+		return result;
+
+	/* old mode unknown or mode changed */
+	if (!tz->ops->get_mode || mode != old_mode)
+		monitor_thermal_zone(tz);
+
+	return 0;
+}
+
 void thermal_zone_device_update(struct thermal_zone_device *tz,
 				enum thermal_notify_event event)
 {
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index a9bf00e91d64..1ed0bdb812d8 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -74,6 +74,8 @@ int thermal_zone_create_device_groups(struct thermal_zone_device *, int);
 void thermal_zone_destroy_device_groups(struct thermal_zone_device *);
 void thermal_cooling_device_setup_sysfs(struct thermal_cooling_device *);
 void thermal_cooling_device_destroy_sysfs(struct thermal_cooling_device *cdev);
+int thermal_zone_set_mode(struct thermal_zone_device *tz,
+			  enum thermal_device_mode mode);
 /* used only at binding time */
 ssize_t trip_point_show(struct device *, struct device_attribute *, char *);
 ssize_t weight_show(struct device *, struct device_attribute *, char *);
diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index 6bfef21abce4..cc1f808b48b3 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -68,18 +68,20 @@ mode_store(struct device *dev, struct device_attribute *attr,
 	   const char *buf, size_t count)
 {
 	struct thermal_zone_device *tz = to_thermal_zone(dev);
+	enum thermal_device_mode mode;
 	int result;
 
 	if (!tz->ops->set_mode)
 		return -EPERM;
 
 	if (!strncmp(buf, "enabled", sizeof("enabled") - 1))
-		result = tz->ops->set_mode(tz, THERMAL_DEVICE_ENABLED);
+		mode = THERMAL_DEVICE_ENABLED;
 	else if (!strncmp(buf, "disabled", sizeof("disabled") - 1))
-		result = tz->ops->set_mode(tz, THERMAL_DEVICE_DISABLED);
+		mode = THERMAL_DEVICE_DISABLED;
 	else
-		result = -EINVAL;
+		return -EINVAL;
 
+	result = thermal_zone_set_mode(tz, mode);
 	if (result)
 		return result;
 
-- 
2.17.1


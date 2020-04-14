Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E941A8834
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503231AbgDNSBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:01:47 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46864 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503198AbgDNSBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:01:35 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id A8CD92A1BE7
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
Subject: [RFC v2 7/9] thermal: core: Monitor thermal zone after mode change
Date:   Tue, 14 Apr 2020 20:01:03 +0200
Message-Id: <20200414180105.20042-8-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414180105.20042-1-andrzej.p@collabora.com>
References: <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
 <20200414180105.20042-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mode changing might imply a need to stop/start polling the device.
monitor_thermal_zone() when mode changes.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/thermal/thermal_core.c  | 2 +-
 drivers/thermal/thermal_core.h  | 2 ++
 drivers/thermal/thermal_sysfs.c | 7 +++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index a59c3411fb9c..7637ddb79813 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -305,7 +305,7 @@ static void thermal_zone_device_set_polling(struct thermal_zone_device *tz,
 		cancel_delayed_work(&tz->poll_queue);
 }
 
-static void monitor_thermal_zone(struct thermal_zone_device *tz)
+void monitor_thermal_zone(struct thermal_zone_device *tz)
 {
 	mutex_lock(&tz->lock);
 
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index a9bf00e91d64..469258778161 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -89,6 +89,8 @@ thermal_cooling_device_stats_update(struct thermal_cooling_device *cdev,
 				    unsigned long new_state) {}
 #endif /* CONFIG_THERMAL_STATISTICS */
 
+void monitor_thermal_zone(struct thermal_zone_device *tz);
+
 /* device tree support */
 #ifdef CONFIG_THERMAL_OF
 int of_parse_thermal_zones(void);
diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index cbb27b3c96d2..bc34d0f9768b 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -62,11 +62,14 @@ mode_store(struct device *dev, struct device_attribute *attr,
 	   const char *buf, size_t count)
 {
 	struct thermal_zone_device *tz = to_thermal_zone(dev);
+	enum thermal_device_mode old_mode, mode;
 	int result;
 
 	if (!tz->ops->set_mode)
 		return -EPERM;
 
+	old_mode = thermal_zone_device_get_mode(tz);
+
 	if (!strncmp(buf, "enabled", sizeof("enabled") - 1))
 		result = thermal_zone_device_enable(tz);
 	else if (!strncmp(buf, "disabled", sizeof("disabled") - 1))
@@ -77,6 +80,10 @@ mode_store(struct device *dev, struct device_attribute *attr,
 	if (result)
 		return result;
 
+	mode = thermal_zone_device_get_mode(tz);
+	if (mode != old_mode)
+		monitor_thermal_zone(tz);
+
 	return count;
 }
 
-- 
2.17.1


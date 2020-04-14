Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94521A8838
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503235AbgDNSBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:01:52 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46932 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503219AbgDNSBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:01:41 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 0C0432A1BE9
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
Subject: [RFC v2 9/9] thermal: core: Stop polling DISABLED thermal devices
Date:   Tue, 14 Apr 2020 20:01:05 +0200
Message-Id: <20200414180105.20042-10-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414180105.20042-1-andrzej.p@collabora.com>
References: <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
 <20200414180105.20042-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Polling DISABLED devices is not desired, as all such "disabled" devices
are meant to be handled by userspace.

Add a new mode: THERMAL_DEVICE_INITIAL. It is dedicated to handle devices
which must be initially DISABLED, but which are polled at startup
nonetheless. THERMAL_DEVICE_INITIAL shall be reported as "enabled" in
sysfs to keep the userspace interface intact.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/thermal/thermal_core.c  | 18 ++++++++++++++++--
 drivers/thermal/thermal_sysfs.c |  4 ++--
 include/linux/thermal.h         |  1 +
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 7637ddb79813..c3c966a5a50b 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -305,13 +305,22 @@ static void thermal_zone_device_set_polling(struct thermal_zone_device *tz,
 		cancel_delayed_work(&tz->poll_queue);
 }
 
+static inline bool should_stop_polling(struct thermal_zone_device *tz)
+{
+	return thermal_zone_device_get_mode(tz) == THERMAL_DEVICE_DISABLED;
+}
+
 void monitor_thermal_zone(struct thermal_zone_device *tz)
 {
+	bool stop;
+
+	stop = should_stop_polling(tz);
+
 	mutex_lock(&tz->lock);
 
-	if (tz->passive)
+	if (!stop && tz->passive)
 		thermal_zone_device_set_polling(tz, tz->passive_delay);
-	else if (tz->polling_delay)
+	else if (!stop && tz->polling_delay)
 		thermal_zone_device_set_polling(tz, tz->polling_delay);
 	else
 		thermal_zone_device_set_polling(tz, 0);
@@ -490,6 +499,9 @@ void thermal_zone_device_update(struct thermal_zone_device *tz,
 {
 	int count;
 
+	if (should_stop_polling(tz))
+		return;
+
 	if (atomic_read(&in_suspend))
 		return;
 
@@ -1356,6 +1368,8 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 	list_add_tail(&tz->node, &thermal_tz_list);
 	mutex_unlock(&thermal_list_lock);
 
+	tz->mode = THERMAL_DEVICE_INITIAL;
+
 	/* Bind cooling devices for this zone */
 	bind_tz(tz);
 
diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index bc34d0f9768b..9d26196735bd 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -53,8 +53,8 @@ mode_show(struct device *dev, struct device_attribute *attr, char *buf)
 
 	mode = thermal_zone_device_get_mode(tz);
 
-	return sprintf(buf, "%s\n", mode == THERMAL_DEVICE_ENABLED ? "enabled"
-		       : "disabled");
+	return sprintf(buf, "%s\n", mode == THERMAL_DEVICE_DISABLED ? "disabled"
+		       : "enabled");
 }
 
 static ssize_t
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index efb481088035..2f61f461da50 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -50,6 +50,7 @@ struct thermal_instance;
 enum thermal_device_mode {
 	THERMAL_DEVICE_DISABLED = 0,
 	THERMAL_DEVICE_ENABLED,
+	THERMAL_DEVICE_INITIAL,
 };
 
 enum thermal_trip_type {
-- 
2.17.1


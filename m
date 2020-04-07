Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 304451A1306
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 19:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgDGRtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 13:49:46 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42940 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgDGRtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 13:49:45 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id F094F2972AE
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
Subject: [RFC 3/8] thermal: Store thermal mode in a dedicated enum
Date:   Tue,  7 Apr 2020 19:49:21 +0200
Message-Id: <20200407174926.23971-4-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200407174926.23971-1-andrzej.p@collabora.com>
References: <20200407174926.23971-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for adding THERMAL_DEVICE_INITIAL mode.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/acpi/thermal.c                        | 27 +++++++++----------
 drivers/platform/x86/acerhdf.c                | 12 ++++++---
 .../intel/int340x_thermal/int3400_thermal.c   | 18 +++++--------
 3 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 19067a5e5293..a93b0412dd6b 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -172,7 +172,7 @@ struct acpi_thermal {
 	struct acpi_thermal_trips trips;
 	struct acpi_handle_list devices;
 	struct thermal_zone_device *thermal_zone;
-	int tz_enabled;
+	enum thermal_device_mode mode;
 	int kelvin_offset;	/* in millidegrees */
 	struct work_struct thermal_check_work;
 };
@@ -500,7 +500,7 @@ static void acpi_thermal_check(void *data)
 {
 	struct acpi_thermal *tz = data;
 
-	if (!tz->tz_enabled)
+	if (tz->mode != THERMAL_DEVICE_ENABLED)
 		return;
 
 	thermal_zone_device_update(tz->thermal_zone,
@@ -534,8 +534,7 @@ static int thermal_get_mode(struct thermal_zone_device *thermal,
 	if (!tz)
 		return -EINVAL;
 
-	*mode = tz->tz_enabled ? THERMAL_DEVICE_ENABLED :
-		THERMAL_DEVICE_DISABLED;
+	*mode = tz->mode;
 
 	return 0;
 }
@@ -544,27 +543,25 @@ static int thermal_set_mode(struct thermal_zone_device *thermal,
 				enum thermal_device_mode mode)
 {
 	struct acpi_thermal *tz = thermal->devdata;
-	int enable;
 
 	if (!tz)
 		return -EINVAL;
 
+	if (mode != THERMAL_DEVICE_DISABLED &&
+	    mode != THERMAL_DEVICE_ENABLED)
+		return -EINVAL;
 	/*
 	 * enable/disable thermal management from ACPI thermal driver
 	 */
-	if (mode == THERMAL_DEVICE_ENABLED)
-		enable = 1;
-	else if (mode == THERMAL_DEVICE_DISABLED) {
-		enable = 0;
+	if (mode == THERMAL_DEVICE_DISABLED)
 		pr_warn("thermal zone will be disabled\n");
-	} else
-		return -EINVAL;
 
-	if (enable != tz->tz_enabled) {
-		tz->tz_enabled = enable;
+	if (mode != tz->mode) {
+		tz->mode = mode;
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			"%s kernel ACPI thermal control\n",
-			tz->tz_enabled ? "Enable" : "Disable"));
+			tz->mode == THERMAL_DEVICE_ENABLED ?
+			"Enable" : "Disable"));
 		acpi_thermal_check(tz);
 	}
 	return 0;
@@ -913,7 +910,7 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-	tz->tz_enabled = 1;
+	tz->mode = THERMAL_DEVICE_ENABLED;
 
 	dev_info(&tz->device->dev, "registered as thermal_zone%d\n",
 		 tz->thermal_zone->id);
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index d5188c1d688b..87e357017d4a 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -65,8 +65,10 @@
 
 #ifdef START_IN_KERNEL_MODE
 static int kernelmode = 1;
+static enum thermal_device_mode thermal_mode = THERMAL_DEVICE_ENABLED;
 #else
 static int kernelmode;
+static enum thermal_device_mode thermal_mode = THERMAL_DEVICE_DISABLED;
 #endif
 
 static unsigned int interval = 10;
@@ -416,8 +418,7 @@ static int acerhdf_get_mode(struct thermal_zone_device *thermal,
 	if (verbose)
 		pr_notice("kernel mode fan control %d\n", kernelmode);
 
-	*mode = (kernelmode) ? THERMAL_DEVICE_ENABLED
-			     : THERMAL_DEVICE_DISABLED;
+	*mode = thermal_mode;
 
 	return 0;
 }
@@ -435,10 +436,13 @@ static int acerhdf_set_mode(struct thermal_zone_device *thermal,
 	    mode != THERMAL_DEVICE_ENABLED)
 		return -EINVAL;
 
-	if (mode == THERMAL_DEVICE_DISABLED && kernelmode)
+	if (mode == THERMAL_DEVICE_DISABLED && kernelmode) {
 		acerhdf_revert_to_bios_mode();
-	else if (mode == THERMAL_DEVICE_ENABLED && !kernelmode)
+		thermal_mode = THERMAL_DEVICE_DISABLED;
+	} else if (mode == THERMAL_DEVICE_ENABLED && !kernelmode) {
 		acerhdf_enable_kernelmode();
+		thermal_mode = THERMAL_DEVICE_ENABLED;
+	}
 
 	return 0;
 }
diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 634b943e9e3d..fcbd1b14fa74 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -44,7 +44,7 @@ static char *int3400_thermal_uuids[INT3400_THERMAL_MAXIMUM_UUID] = {
 struct int3400_thermal_priv {
 	struct acpi_device *adev;
 	struct thermal_zone_device *thermal;
-	int mode;
+	enum thermal_device_mode mode;
 	int art_count;
 	struct art *arts;
 	int trt_count;
@@ -247,24 +247,20 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
 				enum thermal_device_mode mode)
 {
 	struct int3400_thermal_priv *priv = thermal->devdata;
-	bool enable;
 	int result = 0;
 
 	if (!priv)
 		return -EINVAL;
 
-	if (mode == THERMAL_DEVICE_ENABLED)
-		enable = true;
-	else if (mode == THERMAL_DEVICE_DISABLED)
-		enable = false;
-	else
+	if (mode != THERMAL_DEVICE_ENABLED &&
+	    mode != THERMAL_DEVICE_DISABLED)
 		return -EINVAL;
 
-	if (enable != priv->mode) {
-		priv->mode = enable;
+	if (mode != priv->mode) {
+		priv->mode = mode;
 		result = int3400_thermal_run_osc(priv->adev->handle,
-						 priv->current_uuid_index,
-						 enable);
+						priv->current_uuid_index,
+						mode == THERMAL_DEVICE_ENABLED);
 	}
 	return result;
 }
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67AE31E6A5C
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406394AbgE1TVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:21:46 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57628 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406306AbgE1TVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 15:21:35 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id EDF002A41C4
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
To:     linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Sebastian Reichel <sre@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Heiko Stuebner <heiko@sntech.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        kernel@collabora.com
Subject: [PATCH v4 02/11] thermal: Store thermal mode in a dedicated enum
Date:   Thu, 28 May 2020 21:20:42 +0200
Message-Id: <20200528192051.28034-3-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528192051.28034-1-andrzej.p@collabora.com>
References: <Message-ID: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
 <20200528192051.28034-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for storing mode in struct thermal_zone_device.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/acpi/thermal.c                        | 27 +++++++++----------
 drivers/platform/x86/acerhdf.c                |  8 ++++--
 .../intel/int340x_thermal/int3400_thermal.c   | 18 +++++--------
 3 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 6de8066ca1e7..fb46070c66d8 100644
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
@@ -915,7 +912,7 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 		goto remove_dev_link;
 	}
 
-	tz->tz_enabled = 1;
+	tz->mode = THERMAL_DEVICE_ENABLED;
 
 	dev_info(&tz->device->dev, "registered as thermal_zone%d\n",
 		 tz->thermal_zone->id);
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 8cc86f4e3ac1..830a8b060e74 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -68,6 +68,7 @@ static int kernelmode = 1;
 #else
 static int kernelmode;
 #endif
+static enum thermal_device_mode thermal_mode;
 
 static unsigned int interval = 10;
 static unsigned int fanon = 60000;
@@ -397,6 +398,7 @@ static inline void acerhdf_revert_to_bios_mode(void)
 {
 	acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
 	kernelmode = 0;
+	thermal_mode = THERMAL_DEVICE_DISABLED;
 	if (thz_dev)
 		thz_dev->polling_delay = 0;
 	pr_notice("kernel mode fan control OFF\n");
@@ -404,6 +406,7 @@ static inline void acerhdf_revert_to_bios_mode(void)
 static inline void acerhdf_enable_kernelmode(void)
 {
 	kernelmode = 1;
+	thermal_mode = THERMAL_DEVICE_ENABLED;
 
 	thz_dev->polling_delay = interval*1000;
 	thermal_zone_device_update(thz_dev, THERMAL_EVENT_UNSPECIFIED);
@@ -416,8 +419,7 @@ static int acerhdf_get_mode(struct thermal_zone_device *thermal,
 	if (verbose)
 		pr_notice("kernel mode fan control %d\n", kernelmode);
 
-	*mode = (kernelmode) ? THERMAL_DEVICE_ENABLED
-			     : THERMAL_DEVICE_DISABLED;
+	*mode = thermal_mode;
 
 	return 0;
 }
@@ -739,6 +741,8 @@ static int __init acerhdf_register_thermal(void)
 	if (IS_ERR(cl_dev))
 		return -EINVAL;
 
+	thermal_mode = kernelmode ?
+		THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED;
 	thz_dev = thermal_zone_device_register("acerhdf", 2, 0, NULL,
 					      &acerhdf_dev_ops,
 					      &acerhdf_zone_params, 0,
diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 0b3a62655843..e84faaadff87 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -48,7 +48,7 @@ struct int3400_thermal_priv {
 	struct acpi_device *adev;
 	struct platform_device *pdev;
 	struct thermal_zone_device *thermal;
-	int mode;
+	enum thermal_device_mode mode;
 	int art_count;
 	struct art *arts;
 	int trt_count;
@@ -395,24 +395,20 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
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
 
 	evaluate_odvp(priv);
-- 
2.17.1


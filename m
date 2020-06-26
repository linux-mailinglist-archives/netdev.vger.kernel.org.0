Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4313120B741
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgFZRi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:38:28 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52748 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbgFZRiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:38:25 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id E19E22A5E39
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
Subject: [PATCH v5 10/11] thermal: Simplify or eliminate unnecessary set_mode() methods
Date:   Fri, 26 Jun 2020 19:37:54 +0200
Message-Id: <20200626173755.26379-11-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626173755.26379-1-andrzej.p@collabora.com>
References: <9cbffad6-69e4-0b33-4640-fde7c4f6a6e7@linaro.org>
 <20200626173755.26379-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting polling_delay is now done at thermal_core level (by not polling
DISABLED devices), so no need to repeat this code.

int340x: Checking for an impossible enum value is unnecessary.
acpi/thermal: It only prints debug messages.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
[for acerhdf]
Acked-by: Peter Kaestle <peter@piie.net>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/acpi/thermal.c                        | 26 ----------------
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 30 -------------------
 drivers/platform/x86/acerhdf.c                |  3 --
 drivers/thermal/imx_thermal.c                 |  6 ----
 .../intel/int340x_thermal/int3400_thermal.c   |  4 ---
 drivers/thermal/thermal_of.c                  | 18 -----------
 6 files changed, 87 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 52b6cda1bcc3..29a2b73fe035 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -525,31 +525,6 @@ static int thermal_get_temp(struct thermal_zone_device *thermal, int *temp)
 	return 0;
 }
 
-static int thermal_set_mode(struct thermal_zone_device *thermal,
-				enum thermal_device_mode mode)
-{
-	struct acpi_thermal *tz = thermal->devdata;
-
-	if (!tz)
-		return -EINVAL;
-
-	if (mode != THERMAL_DEVICE_DISABLED &&
-	    mode != THERMAL_DEVICE_ENABLED)
-		return -EINVAL;
-	/*
-	 * enable/disable thermal management from ACPI thermal driver
-	 */
-	if (mode == THERMAL_DEVICE_DISABLED)
-		pr_warn("thermal zone will be disabled\n");
-
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-		"%s kernel ACPI thermal control\n",
-		mode == THERMAL_DEVICE_ENABLED ?
-		"Enable" : "Disable"));
-
-	return 0;
-}
-
 static int thermal_get_trip_type(struct thermal_zone_device *thermal,
 				 int trip, enum thermal_trip_type *type)
 {
@@ -836,7 +811,6 @@ static struct thermal_zone_device_ops acpi_thermal_zone_ops = {
 	.bind = acpi_thermal_bind_cooling_device,
 	.unbind	= acpi_thermal_unbind_cooling_device,
 	.get_temp = thermal_get_temp,
-	.set_mode = thermal_set_mode,
 	.get_trip_type = thermal_get_trip_type,
 	.get_trip_temp = thermal_get_trip_temp,
 	.get_crit_temp = thermal_get_crit_temp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 4fb73d0fd167..8fa286ccdd6b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -275,19 +275,6 @@ static int mlxsw_thermal_unbind(struct thermal_zone_device *tzdev,
 	return 0;
 }
 
-static int mlxsw_thermal_set_mode(struct thermal_zone_device *tzdev,
-				  enum thermal_device_mode mode)
-{
-	struct mlxsw_thermal *thermal = tzdev->devdata;
-
-	if (mode == THERMAL_DEVICE_ENABLED)
-		tzdev->polling_delay = thermal->polling_delay;
-	else
-		tzdev->polling_delay = 0;
-
-	return 0;
-}
-
 static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
 				  int *p_temp)
 {
@@ -387,7 +374,6 @@ static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
 static struct thermal_zone_device_ops mlxsw_thermal_ops = {
 	.bind = mlxsw_thermal_bind,
 	.unbind = mlxsw_thermal_unbind,
-	.set_mode = mlxsw_thermal_set_mode,
 	.get_temp = mlxsw_thermal_get_temp,
 	.get_trip_type	= mlxsw_thermal_get_trip_type,
 	.get_trip_temp	= mlxsw_thermal_get_trip_temp,
@@ -445,20 +431,6 @@ static int mlxsw_thermal_module_unbind(struct thermal_zone_device *tzdev,
 	return err;
 }
 
-static int mlxsw_thermal_module_mode_set(struct thermal_zone_device *tzdev,
-					 enum thermal_device_mode mode)
-{
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
-	struct mlxsw_thermal *thermal = tz->parent;
-
-	if (mode == THERMAL_DEVICE_ENABLED)
-		tzdev->polling_delay = thermal->polling_delay;
-	else
-		tzdev->polling_delay = 0;
-
-	return 0;
-}
-
 static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 					 int *p_temp)
 {
@@ -574,7 +546,6 @@ static int mlxsw_thermal_module_trend_get(struct thermal_zone_device *tzdev,
 static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.bind		= mlxsw_thermal_module_bind,
 	.unbind		= mlxsw_thermal_module_unbind,
-	.set_mode	= mlxsw_thermal_module_mode_set,
 	.get_temp	= mlxsw_thermal_module_temp_get,
 	.get_trip_type	= mlxsw_thermal_module_trip_type_get,
 	.get_trip_temp	= mlxsw_thermal_module_trip_temp_get,
@@ -612,7 +583,6 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
 static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
 	.bind		= mlxsw_thermal_module_bind,
 	.unbind		= mlxsw_thermal_module_unbind,
-	.set_mode	= mlxsw_thermal_module_mode_set,
 	.get_temp	= mlxsw_thermal_gearbox_temp_get,
 	.get_trip_type	= mlxsw_thermal_module_trip_type_get,
 	.get_trip_temp	= mlxsw_thermal_module_trip_temp_get,
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 8fe0ecb6a626..76323855c80c 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -397,8 +397,6 @@ static inline void acerhdf_revert_to_bios_mode(void)
 {
 	acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
 	kernelmode = 0;
-	if (thz_dev)
-		thz_dev->polling_delay = 0;
 
 	pr_notice("kernel mode fan control OFF\n");
 }
@@ -406,7 +404,6 @@ static inline void acerhdf_enable_kernelmode(void)
 {
 	kernelmode = 1;
 
-	thz_dev->polling_delay = interval*1000;
 	pr_notice("kernel mode fan control ON\n");
 }
 
diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index 53abb1be1cba..a02398118d88 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -338,9 +338,6 @@ static int imx_set_mode(struct thermal_zone_device *tz,
 	const struct thermal_soc_data *soc_data = data->socdata;
 
 	if (mode == THERMAL_DEVICE_ENABLED) {
-		tz->polling_delay = IMX_POLLING_DELAY;
-		tz->passive_delay = IMX_PASSIVE_DELAY;
-
 		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
 			     soc_data->power_down_mask);
 		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
@@ -356,9 +353,6 @@ static int imx_set_mode(struct thermal_zone_device *tz,
 		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
 			     soc_data->power_down_mask);
 
-		tz->polling_delay = 0;
-		tz->passive_delay = 0;
-
 		if (data->irq_enabled) {
 			disable_irq(data->irq);
 			data->irq_enabled = false;
diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 3c0397a29b8c..ce49d3b100d5 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -386,10 +386,6 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
 	if (!priv)
 		return -EINVAL;
 
-	if (mode != THERMAL_DEVICE_ENABLED &&
-	    mode != THERMAL_DEVICE_DISABLED)
-		return -EINVAL;
-
 	if (mode != thermal->mode)
 		result = int3400_thermal_run_osc(priv->adev->handle,
 						priv->current_uuid_index,
diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 43a516a35d64..69ef12f852b7 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -267,22 +267,6 @@ static int of_thermal_unbind(struct thermal_zone_device *thermal,
 	return 0;
 }
 
-static int of_thermal_set_mode(struct thermal_zone_device *tz,
-			       enum thermal_device_mode mode)
-{
-	struct __thermal_zone *data = tz->devdata;
-
-	if (mode == THERMAL_DEVICE_ENABLED) {
-		tz->polling_delay = data->polling_delay;
-		tz->passive_delay = data->passive_delay;
-	} else {
-		tz->polling_delay = 0;
-		tz->passive_delay = 0;
-	}
-
-	return 0;
-}
-
 static int of_thermal_get_trip_type(struct thermal_zone_device *tz, int trip,
 				    enum thermal_trip_type *type)
 {
@@ -374,8 +358,6 @@ static int of_thermal_get_crit_temp(struct thermal_zone_device *tz,
 }
 
 static struct thermal_zone_device_ops of_thermal_ops = {
-	.set_mode = of_thermal_set_mode,
-
 	.get_trip_type = of_thermal_get_trip_type,
 	.get_trip_temp = of_thermal_get_trip_temp,
 	.set_trip_temp = of_thermal_set_trip_temp,
-- 
2.17.1


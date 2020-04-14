Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0571A8854
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503290AbgDNSCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503193AbgDNSBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:01:30 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473B2C061A0C;
        Tue, 14 Apr 2020 11:01:30 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id AA3002A1BDD
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
Subject: [RFC v2 5/9] thermal: Store mode in thermal_zone_device
Date:   Tue, 14 Apr 2020 20:01:01 +0200
Message-Id: <20200414180105.20042-6-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414180105.20042-1-andrzej.p@collabora.com>
References: <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
 <20200414180105.20042-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct thermal_zone_device has a "mode" member now, so use it.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/acpi/thermal.c                        | 48 +++++++++----------
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 35 ++------------
 drivers/platform/x86/acerhdf.c                | 24 ++++------
 drivers/thermal/da9062-thermal.c              | 12 +----
 drivers/thermal/imx_thermal.c                 | 30 +++++-------
 .../intel/int340x_thermal/int3400_thermal.c   | 34 +++++--------
 .../thermal/intel/intel_quark_dts_thermal.c   | 22 +++------
 drivers/thermal/of-thermal.c                  | 19 ++------
 8 files changed, 71 insertions(+), 153 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 328b479ce7f6..755f12b76c20 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -172,7 +172,6 @@ struct acpi_thermal {
 	struct acpi_thermal_trips trips;
 	struct acpi_handle_list devices;
 	struct thermal_zone_device *thermal_zone;
-	int tz_enabled;
 	int kelvin_offset;	/* in millidegrees */
 	struct work_struct thermal_check_work;
 };
@@ -499,8 +498,14 @@ static int acpi_thermal_get_trip_points(struct acpi_thermal *tz)
 static void acpi_thermal_check(void *data)
 {
 	struct acpi_thermal *tz = data;
+	enum thermal_device_mode mode;
 
-	if (!tz->tz_enabled)
+	/*
+	 * this driver does not provide ->get_mode(), so calling
+	 * thermal_zone_device_get_mode() always succeeds
+	 */
+	thermal_zone_device_get_mode(tz->thermal_zone, &mode);
+	if (mode != THERMAL_DEVICE_ENABLED)
 		return;
 
 	thermal_zone_device_update(tz->thermal_zone,
@@ -526,39 +531,33 @@ static int thermal_get_temp(struct thermal_zone_device *thermal, int *temp)
 	return 0;
 }
 
-static int thermal_get_mode(struct thermal_zone_device *thermal,
-				enum thermal_device_mode *mode)
-{
-	struct acpi_thermal *tz = thermal->devdata;
-
-	*mode = tz->tz_enabled ? THERMAL_DEVICE_ENABLED :
-		THERMAL_DEVICE_DISABLED;
-
-	return 0;
-}
-
 static int thermal_set_mode(struct thermal_zone_device *thermal,
 				enum thermal_device_mode mode)
 {
 	struct acpi_thermal *tz = thermal->devdata;
-	int enable;
+	enum thermal_device_mode old_mode;
 
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
+	/*
+	 * this driver does not provide ->get_mode(), so calling
+	 * thermal_zone_device_get_mode() always succeeds
+	 */
+	thermal_zone_device_get_mode(thermal, &old_mode);
+
+	if (mode != old_mode) {
+		thermal_zone_device_store_mode(thermal, mode);
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			"%s kernel ACPI thermal control\n",
-			tz->tz_enabled ? "Enable" : "Disable"));
+			mode == THERMAL_DEVICE_ENABLED ?
+			"Enable" : "Disable"));
 		acpi_thermal_check(tz);
 	}
 	return 0;
@@ -850,7 +849,6 @@ static struct thermal_zone_device_ops acpi_thermal_zone_ops = {
 	.bind = acpi_thermal_bind_cooling_device,
 	.unbind	= acpi_thermal_unbind_cooling_device,
 	.get_temp = thermal_get_temp,
-	.get_mode = thermal_get_mode,
 	.set_mode = thermal_set_mode,
 	.get_trip_type = thermal_get_trip_type,
 	.get_trip_temp = thermal_get_trip_temp,
@@ -907,7 +905,7 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-	tz->tz_enabled = 1;
+	thermal_zone_device_store_enabled(tz->thermal_zone);
 
 	dev_info(&tz->device->dev, "registered as thermal_zone%d\n",
 		 tz->thermal_zone->id);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index cd435ca7adbe..c4239b2ba16d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -98,7 +98,6 @@ struct mlxsw_thermal_module {
 	struct mlxsw_thermal *parent;
 	struct thermal_zone_device *tzdev;
 	struct mlxsw_thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
-	enum thermal_device_mode mode;
 	int module; /* Module or gearbox number */
 };
 
@@ -110,7 +109,6 @@ struct mlxsw_thermal {
 	struct thermal_cooling_device *cdevs[MLXSW_MFCR_PWMS_MAX];
 	u8 cooling_levels[MLXSW_THERMAL_MAX_STATE + 1];
 	struct mlxsw_thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
-	enum thermal_device_mode mode;
 	struct mlxsw_thermal_module *tz_module_arr;
 	u8 tz_module_num;
 	struct mlxsw_thermal_module *tz_gearbox_arr;
@@ -277,16 +275,6 @@ static int mlxsw_thermal_unbind(struct thermal_zone_device *tzdev,
 	return 0;
 }
 
-static int mlxsw_thermal_get_mode(struct thermal_zone_device *tzdev,
-				  enum thermal_device_mode *mode)
-{
-	struct mlxsw_thermal *thermal = tzdev->devdata;
-
-	*mode = thermal->mode;
-
-	return 0;
-}
-
 static int mlxsw_thermal_set_mode(struct thermal_zone_device *tzdev,
 				  enum thermal_device_mode mode)
 {
@@ -303,7 +291,7 @@ static int mlxsw_thermal_set_mode(struct thermal_zone_device *tzdev,
 
 	mutex_unlock(&tzdev->lock);
 
-	thermal->mode = mode;
+	thermal_zone_device_store_mode(tzdev, mode);
 	thermal_zone_device_update(tzdev, THERMAL_EVENT_UNSPECIFIED);
 
 	return 0;
@@ -409,7 +397,6 @@ static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
 static struct thermal_zone_device_ops mlxsw_thermal_ops = {
 	.bind = mlxsw_thermal_bind,
 	.unbind = mlxsw_thermal_unbind,
-	.get_mode = mlxsw_thermal_get_mode,
 	.set_mode = mlxsw_thermal_set_mode,
 	.get_temp = mlxsw_thermal_get_temp,
 	.get_trip_type	= mlxsw_thermal_get_trip_type,
@@ -468,16 +455,6 @@ static int mlxsw_thermal_module_unbind(struct thermal_zone_device *tzdev,
 	return err;
 }
 
-static int mlxsw_thermal_module_mode_get(struct thermal_zone_device *tzdev,
-					 enum thermal_device_mode *mode)
-{
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
-
-	*mode = tz->mode;
-
-	return 0;
-}
-
 static int mlxsw_thermal_module_mode_set(struct thermal_zone_device *tzdev,
 					 enum thermal_device_mode mode)
 {
@@ -495,7 +472,7 @@ static int mlxsw_thermal_module_mode_set(struct thermal_zone_device *tzdev,
 
 	mutex_unlock(&tzdev->lock);
 
-	tz->mode = mode;
+	thermal_zone_device_store_mode(tzdev, mode);
 	thermal_zone_device_update(tzdev, THERMAL_EVENT_UNSPECIFIED);
 
 	return 0;
@@ -600,7 +577,6 @@ mlxsw_thermal_module_trip_hyst_set(struct thermal_zone_device *tzdev, int trip,
 static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.bind		= mlxsw_thermal_module_bind,
 	.unbind		= mlxsw_thermal_module_unbind,
-	.get_mode	= mlxsw_thermal_module_mode_get,
 	.set_mode	= mlxsw_thermal_module_mode_set,
 	.get_temp	= mlxsw_thermal_module_temp_get,
 	.get_trip_type	= mlxsw_thermal_module_trip_type_get,
@@ -639,7 +615,6 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
 static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
 	.bind		= mlxsw_thermal_module_bind,
 	.unbind		= mlxsw_thermal_module_unbind,
-	.get_mode	= mlxsw_thermal_module_mode_get,
 	.set_mode	= mlxsw_thermal_module_mode_set,
 	.get_temp	= mlxsw_thermal_gearbox_temp_get,
 	.get_trip_type	= mlxsw_thermal_module_trip_type_get,
@@ -769,7 +744,7 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
 		return err;
 	}
 
-	module_tz->mode = THERMAL_DEVICE_ENABLED;
+	thermal_zone_device_store_enabled(module_tz->tzdev);
 	return 0;
 }
 
@@ -885,7 +860,7 @@ mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
 	if (IS_ERR(gearbox_tz->tzdev))
 		return PTR_ERR(gearbox_tz->tzdev);
 
-	gearbox_tz->mode = THERMAL_DEVICE_ENABLED;
+	thermal_zone_device_store_enabled(gearbox_tz->tzdev);
 	return 0;
 }
 
@@ -1054,7 +1029,7 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 	if (err)
 		goto err_unreg_modules_tzdev;
 
-	thermal->mode = THERMAL_DEVICE_ENABLED;
+	thermal_zone_device_store_enabled(thermal->tzdev);
 	*p_thermal = thermal;
 	return 0;
 
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index d5188c1d688b..e5a6abdf62ca 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -65,8 +65,10 @@
 
 #ifdef START_IN_KERNEL_MODE
 static int kernelmode = 1;
+#define ACERHDF_DEFAULT_MODE THERMAL_DEVICE_ENABLED
 #else
 static int kernelmode;
+#define ACERHDF_DEFAULT_MODE THERMAL_DEVICE_DISABLED
 #endif
 
 static unsigned int interval = 10;
@@ -410,18 +412,6 @@ static inline void acerhdf_enable_kernelmode(void)
 	pr_notice("kernel mode fan control ON\n");
 }
 
-static int acerhdf_get_mode(struct thermal_zone_device *thermal,
-			    enum thermal_device_mode *mode)
-{
-	if (verbose)
-		pr_notice("kernel mode fan control %d\n", kernelmode);
-
-	*mode = (kernelmode) ? THERMAL_DEVICE_ENABLED
-			     : THERMAL_DEVICE_DISABLED;
-
-	return 0;
-}
-
 /*
  * set operation mode;
  * enabled: the thermal layer of the kernel takes care about
@@ -435,10 +425,13 @@ static int acerhdf_set_mode(struct thermal_zone_device *thermal,
 	    mode != THERMAL_DEVICE_ENABLED)
 		return -EINVAL;
 
-	if (mode == THERMAL_DEVICE_DISABLED && kernelmode)
+	if (mode == THERMAL_DEVICE_DISABLED && kernelmode) {
 		acerhdf_revert_to_bios_mode();
-	else if (mode == THERMAL_DEVICE_ENABLED && !kernelmode)
+		thermal_zone_device_store_enabled(thermal);
+	} else if (mode == THERMAL_DEVICE_ENABLED && !kernelmode) {
 		acerhdf_enable_kernelmode();
+		thermal_zone_device_store_disabled(thermal);
+	}
 
 	return 0;
 }
@@ -492,7 +485,6 @@ static struct thermal_zone_device_ops acerhdf_dev_ops = {
 	.bind = acerhdf_bind,
 	.unbind = acerhdf_unbind,
 	.get_temp = acerhdf_get_ec_temp,
-	.get_mode = acerhdf_get_mode,
 	.set_mode = acerhdf_set_mode,
 	.get_trip_type = acerhdf_get_trip_type,
 	.get_trip_hyst = acerhdf_get_trip_hyst,
@@ -757,6 +749,8 @@ static int __init acerhdf_register_thermal(void)
 		return -EINVAL;
 	}
 
+	thermal_zone_device_store_mode(thz_dev, ACERHDF_DEFAULT_MODE);
+
 	return 0;
 }
 
diff --git a/drivers/thermal/da9062-thermal.c b/drivers/thermal/da9062-thermal.c
index c32709badeda..279d393bb048 100644
--- a/drivers/thermal/da9062-thermal.c
+++ b/drivers/thermal/da9062-thermal.c
@@ -49,7 +49,6 @@ struct da9062_thermal {
 	struct da9062 *hw;
 	struct delayed_work work;
 	struct thermal_zone_device *zone;
-	enum thermal_device_mode mode;
 	struct mutex lock; /* protection for da9062_thermal temperature */
 	int temperature;
 	int irq;
@@ -121,14 +120,6 @@ static irqreturn_t da9062_thermal_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int da9062_thermal_get_mode(struct thermal_zone_device *z,
-				   enum thermal_device_mode *mode)
-{
-	struct da9062_thermal *thermal = z->devdata;
-	*mode = thermal->mode;
-	return 0;
-}
-
 static int da9062_thermal_get_trip_type(struct thermal_zone_device *z,
 					int trip,
 					enum thermal_trip_type *type)
@@ -181,7 +172,6 @@ static int da9062_thermal_get_temp(struct thermal_zone_device *z,
 
 static struct thermal_zone_device_ops da9062_thermal_ops = {
 	.get_temp	= da9062_thermal_get_temp,
-	.get_mode	= da9062_thermal_get_mode,
 	.get_trip_type	= da9062_thermal_get_trip_type,
 	.get_trip_temp	= da9062_thermal_get_trip_temp,
 };
@@ -233,7 +223,6 @@ static int da9062_thermal_probe(struct platform_device *pdev)
 
 	thermal->config = match->data;
 	thermal->hw = chip;
-	thermal->mode = THERMAL_DEVICE_ENABLED;
 	thermal->dev = &pdev->dev;
 
 	INIT_DELAYED_WORK(&thermal->work, da9062_thermal_poll_on);
@@ -248,6 +237,7 @@ static int da9062_thermal_probe(struct platform_device *pdev)
 		ret = PTR_ERR(thermal->zone);
 		goto err;
 	}
+	thermal_zone_device_store_enabled(thermal->zone);
 
 	dev_dbg(&pdev->dev,
 		"TJUNC temperature polling period set at %d ms\n",
diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index 36b1924f1938..f3f602b4ece5 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -197,7 +197,6 @@ struct imx_thermal_data {
 	struct cpufreq_policy *policy;
 	struct thermal_zone_device *tz;
 	struct thermal_cooling_device *cdev;
-	enum thermal_device_mode mode;
 	struct regmap *tempmon;
 	u32 c1, c2; /* See formula in imx_init_calib() */
 	int temp_passive;
@@ -252,11 +251,17 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
 	struct imx_thermal_data *data = tz->devdata;
 	const struct thermal_soc_data *soc_data = data->socdata;
 	struct regmap *map = data->tempmon;
+	enum thermal_device_mode mode;
 	unsigned int n_meas;
 	bool wait;
 	u32 val;
 
-	if (data->mode == THERMAL_DEVICE_ENABLED) {
+	/*
+	 * this driver does not provide ->get_mode(), so calling
+	 * thermal_zone_device_get_mode() always succeeds
+	 */
+	thermal_zone_device_get_mode(tz, &mode);
+	if (mode == THERMAL_DEVICE_ENABLED) {
 		/* Check if a measurement is currently in progress */
 		regmap_read(map, soc_data->temp_data, &val);
 		wait = !(val & soc_data->temp_valid_mask);
@@ -283,7 +288,7 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
 
 	regmap_read(map, soc_data->temp_data, &val);
 
-	if (data->mode != THERMAL_DEVICE_ENABLED) {
+	if (mode != THERMAL_DEVICE_ENABLED) {
 		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
 			     soc_data->measure_temp_mask);
 		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
@@ -331,16 +336,6 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
 	return 0;
 }
 
-static int imx_get_mode(struct thermal_zone_device *tz,
-			enum thermal_device_mode *mode)
-{
-	struct imx_thermal_data *data = tz->devdata;
-
-	*mode = data->mode;
-
-	return 0;
-}
-
 static int imx_set_mode(struct thermal_zone_device *tz,
 			enum thermal_device_mode mode)
 {
@@ -378,7 +373,7 @@ static int imx_set_mode(struct thermal_zone_device *tz,
 		return -EINVAL;
 	}
 
-	data->mode = mode;
+	thermal_zone_device_store_mode(tz, mode);
 	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
 
 	return 0;
@@ -469,7 +464,6 @@ static struct thermal_zone_device_ops imx_tz_ops = {
 	.bind = imx_bind,
 	.unbind = imx_unbind,
 	.get_temp = imx_get_temp,
-	.get_mode = imx_get_mode,
 	.set_mode = imx_set_mode,
 	.get_trip_type = imx_get_trip_type,
 	.get_trip_temp = imx_get_trip_temp,
@@ -833,7 +827,7 @@ static int imx_thermal_probe(struct platform_device *pdev)
 		     data->socdata->measure_temp_mask);
 
 	data->irq_enabled = true;
-	data->mode = THERMAL_DEVICE_ENABLED;
+	thermal_zone_device_store_enabled(data->tz);
 
 	ret = devm_request_threaded_irq(&pdev->dev, data->irq,
 			imx_thermal_alarm_irq, imx_thermal_alarm_irq_thread,
@@ -887,7 +881,7 @@ static int __maybe_unused imx_thermal_suspend(struct device *dev)
 		     data->socdata->measure_temp_mask);
 	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
 		     data->socdata->power_down_mask);
-	data->mode = THERMAL_DEVICE_DISABLED;
+	thermal_zone_device_store_disabled(data->tz);
 	clk_disable_unprepare(data->thermal_clk);
 
 	return 0;
@@ -907,7 +901,7 @@ static int __maybe_unused imx_thermal_resume(struct device *dev)
 		     data->socdata->power_down_mask);
 	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
 		     data->socdata->measure_temp_mask);
-	data->mode = THERMAL_DEVICE_ENABLED;
+	thermal_zone_device_store_enabled(data->tz);
 
 	return 0;
 }
diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index fbb59dd09481..a7d9b42c060d 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -44,7 +44,6 @@ static char *int3400_thermal_uuids[INT3400_THERMAL_MAXIMUM_UUID] = {
 struct int3400_thermal_priv {
 	struct acpi_device *adev;
 	struct thermal_zone_device *thermal;
-	int mode;
 	int art_count;
 	struct art *arts;
 	int trt_count;
@@ -230,42 +229,33 @@ static int int3400_thermal_get_temp(struct thermal_zone_device *thermal,
 	return 0;
 }
 
-static int int3400_thermal_get_mode(struct thermal_zone_device *thermal,
-				enum thermal_device_mode *mode)
-{
-	struct int3400_thermal_priv *priv = thermal->devdata;
-
-	*mode = priv->mode;
-
-	return 0;
-}
-
 static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
 				enum thermal_device_mode mode)
 {
 	struct int3400_thermal_priv *priv = thermal->devdata;
-	bool enable;
+	enum thermal_device_mode old_mode;
 	int result = 0;
 
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
+	/*
+	 * this driver does not provide ->get_mode(), so calling
+	 * thermal_zone_device_get_mode() always succeeds
+	 */
+	thermal_zone_device_get_mode(thermal, &old_mode);
+	if (mode != old_mode) {
+		thermal_zone_device_store_mode(thermal, mode);
 		result = int3400_thermal_run_osc(priv->adev->handle,
-						 priv->current_uuid_index,
-						 enable);
+						priv->current_uuid_index,
+						mode == THERMAL_DEVICE_ENABLED);
 	}
 	return result;
 }
 
 static struct thermal_zone_device_ops int3400_thermal_ops = {
 	.get_temp = int3400_thermal_get_temp,
-	.get_mode = int3400_thermal_get_mode,
 	.set_mode = int3400_thermal_set_mode,
 };
 
diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
index 11d7db895125..6d440ef3055f 100644
--- a/drivers/thermal/intel/intel_quark_dts_thermal.c
+++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
@@ -103,7 +103,6 @@ struct soc_sensor_entry {
 	bool locked;
 	u32 store_ptps;
 	u32 store_dts_enable;
-	enum thermal_device_mode mode;
 	struct thermal_zone_device *tzone;
 };
 
@@ -128,7 +127,7 @@ static int soc_dts_enable(struct thermal_zone_device *tzd)
 		return ret;
 
 	if (out & QRK_DTS_ENABLE_BIT) {
-		aux_entry->mode = THERMAL_DEVICE_ENABLED;
+		thermal_zone_device_store_enabled(tzd);
 		return 0;
 	}
 
@@ -139,9 +138,9 @@ static int soc_dts_enable(struct thermal_zone_device *tzd)
 		if (ret)
 			return ret;
 
-		aux_entry->mode = THERMAL_DEVICE_ENABLED;
+		thermal_zone_device_store_enabled(tzd);
 	} else {
-		aux_entry->mode = THERMAL_DEVICE_DISABLED;
+		thermal_zone_device_store_disabled(tzd);
 		pr_info("DTS is locked. Cannot enable DTS\n");
 		ret = -EPERM;
 	}
@@ -161,7 +160,7 @@ static int soc_dts_disable(struct thermal_zone_device *tzd)
 		return ret;
 
 	if (!(out & QRK_DTS_ENABLE_BIT)) {
-		aux_entry->mode = THERMAL_DEVICE_DISABLED;
+		thermal_zone_device_store_disabled(tzd);
 		return 0;
 	}
 
@@ -173,9 +172,9 @@ static int soc_dts_disable(struct thermal_zone_device *tzd)
 		if (ret)
 			return ret;
 
-		aux_entry->mode = THERMAL_DEVICE_DISABLED;
+		thermal_zone_device_store_disabled(tzd);
 	} else {
-		aux_entry->mode = THERMAL_DEVICE_ENABLED;
+		thermal_zone_device_store_enabled(tzd);
 		pr_info("DTS is locked. Cannot disable DTS\n");
 		ret = -EPERM;
 	}
@@ -309,14 +308,6 @@ static int sys_get_curr_temp(struct thermal_zone_device *tzd,
 	return 0;
 }
 
-static int sys_get_mode(struct thermal_zone_device *tzd,
-				enum thermal_device_mode *mode)
-{
-	struct soc_sensor_entry *aux_entry = tzd->devdata;
-	*mode = aux_entry->mode;
-	return 0;
-}
-
 static int sys_set_mode(struct thermal_zone_device *tzd,
 				enum thermal_device_mode mode)
 {
@@ -341,7 +332,6 @@ static struct thermal_zone_device_ops tzone_ops = {
 	.get_trip_type = sys_get_trip_type,
 	.set_trip_temp = sys_set_trip_temp,
 	.get_crit_temp = sys_get_crit_temp,
-	.get_mode = sys_get_mode,
 	.set_mode = sys_set_mode,
 };
 
diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index 36bebf623980..0f1e134e90ea 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -51,7 +51,6 @@ struct __thermal_bind_params {
 
 /**
  * struct __thermal_zone - internal representation of a thermal zone
- * @mode: current thermal zone device mode (enabled/disabled)
  * @passive_delay: polling interval while passive cooling is activated
  * @polling_delay: zone polling interval
  * @slope: slope of the temperature adjustment curve
@@ -65,7 +64,6 @@ struct __thermal_bind_params {
  */
 
 struct __thermal_zone {
-	enum thermal_device_mode mode;
 	int passive_delay;
 	int polling_delay;
 	int slope;
@@ -269,16 +267,6 @@ static int of_thermal_unbind(struct thermal_zone_device *thermal,
 	return 0;
 }
 
-static int of_thermal_get_mode(struct thermal_zone_device *tz,
-			       enum thermal_device_mode *mode)
-{
-	struct __thermal_zone *data = tz->devdata;
-
-	*mode = data->mode;
-
-	return 0;
-}
-
 static int of_thermal_set_mode(struct thermal_zone_device *tz,
 			       enum thermal_device_mode mode)
 {
@@ -298,7 +286,7 @@ static int of_thermal_set_mode(struct thermal_zone_device *tz,
 
 	mutex_unlock(&tz->lock);
 
-	data->mode = mode;
+	thermal_zone_device_store_mode(tz, mode);
 	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
 
 	return 0;
@@ -395,7 +383,6 @@ static int of_thermal_get_crit_temp(struct thermal_zone_device *tz,
 }
 
 static struct thermal_zone_device_ops of_thermal_ops = {
-	.get_mode = of_thermal_get_mode,
 	.set_mode = of_thermal_set_mode,
 
 	.get_trip_type = of_thermal_get_trip_type,
@@ -556,7 +543,7 @@ thermal_zone_of_sensor_register(struct device *dev, int sensor_id, void *data,
 			tzd = thermal_zone_of_add_sensor(child, sensor_np,
 							 data, ops);
 			if (!IS_ERR(tzd))
-				tzd->ops->set_mode(tzd, THERMAL_DEVICE_ENABLED);
+				thermal_zone_device_enable(tzd);
 
 			of_node_put(child);
 			goto exit;
@@ -981,7 +968,6 @@ __init *thermal_of_build_thermal_zone(struct device_node *np)
 
 finish:
 	of_node_put(child);
-	tz->mode = THERMAL_DEVICE_DISABLED;
 
 	return tz;
 
@@ -1136,6 +1122,7 @@ int __init of_parse_thermal_zones(void)
 			of_thermal_free_zone(tz);
 			/* attempting to build remaining zones still */
 		}
+		thermal_zone_device_store_disabled(zone);
 	}
 	of_node_put(np);
 
-- 
2.17.1


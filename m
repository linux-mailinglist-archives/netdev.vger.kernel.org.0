Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6FA1E6A8B
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406251AbgE1TXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:23:19 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57902 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406428AbgE1TWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 15:22:10 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id C4FC62A41CF
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
Subject: [PATCH v4 07/11] thermal: Use mode helpers in drivers
Date:   Thu, 28 May 2020 21:20:47 +0200
Message-Id: <20200528192051.28034-8-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528192051.28034-1-andrzej.p@collabora.com>
References: <Message-ID: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
 <20200528192051.28034-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use thermal_zone_device_{en|dis}able() and thermal_zone_device_is_enabled().

Consequently, all set_mode() implementations in drivers:

- can stop modifying tzd's "mode" member,
- shall stop taking tzd's lock, as it is taken in the helpers
- shall stop calling thermal_zone_device_update() as it is called in the
helpers
- can assume they are called when the mode truly changes, so checks to
verify that can be dropped

Not providing set_mode() by a driver no longer prevents the core from
being able to set tzd's mode, so the relevant check in mode_store() is
removed.

Other comments:

- acpi/thermal.c: tz->thermal_zone->mode will be updated only after we
return from set_mode(), so use function parameter in thermal_set_mode()
instead, no need to call acpi_thermal_check() in set_mode()
- thermal/imx_thermal.c: regmap writes and mode assignment are done in
thermal_zone_device_{en|dis}able() and set_mode() callback
- thermal/intel/intel_quark_dts_thermal.c: soc_dts_{en|dis}able() are a
part of set_mode() callback, so they don't need to modify tzd->mode, and
don't need to fall back to the opposite mode if unsuccessful, as the return
value will be propagated to thermal_zone_device_{en|dis}able() and
ultimately tzd's member will not be changed in thermal_zone_device_set_mode().
- thermal/of-thermal.c: no need to set zone->mode to DISABLED in
of_parse_thermal_zones() as a tzd is kzalloc'ed so mode is DISABLED anyway

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/acpi/thermal.c                        | 21 ++++++-----
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 37 +++++++++----------
 drivers/platform/x86/acerhdf.c                | 17 +++++----
 drivers/thermal/da9062-thermal.c              |  6 ++-
 drivers/thermal/hisi_thermal.c                |  6 ++-
 drivers/thermal/imx_thermal.c                 | 33 +++++++----------
 .../intel/int340x_thermal/int3400_thermal.c   |  5 +--
 .../thermal/intel/intel_quark_dts_thermal.c   | 18 ++-------
 drivers/thermal/rockchip_thermal.c            |  6 ++-
 drivers/thermal/sprd_thermal.c                |  6 ++-
 drivers/thermal/thermal_core.c                |  2 +-
 drivers/thermal/thermal_of.c                  | 10 +----
 drivers/thermal/thermal_sysfs.c               | 11 ++----
 13 files changed, 80 insertions(+), 98 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 592be97c4456..52b6cda1bcc3 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -499,7 +499,7 @@ static void acpi_thermal_check(void *data)
 {
 	struct acpi_thermal *tz = data;
 
-	if (tz->thermal_zone->mode != THERMAL_DEVICE_ENABLED)
+	if (!thermal_zone_device_is_enabled(tz->thermal_zone))
 		return;
 
 	thermal_zone_device_update(tz->thermal_zone,
@@ -542,14 +542,11 @@ static int thermal_set_mode(struct thermal_zone_device *thermal,
 	if (mode == THERMAL_DEVICE_DISABLED)
 		pr_warn("thermal zone will be disabled\n");
 
-	if (mode != tz->thermal_zone->mode) {
-		tz->thermal_zone->mode = mode;
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-			"%s kernel ACPI thermal control\n",
-			tz->thermal_zone->mode == THERMAL_DEVICE_ENABLED ?
-			"Enable" : "Disable"));
-		acpi_thermal_check(tz);
-	}
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+		"%s kernel ACPI thermal control\n",
+		mode == THERMAL_DEVICE_ENABLED ?
+		"Enable" : "Disable"));
+
 	return 0;
 }
 
@@ -897,13 +894,17 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 		goto remove_dev_link;
 	}
 
-	tz->thermal_zone->mode = THERMAL_DEVICE_ENABLED;
+	result = thermal_zone_device_enable(tz->thermal_zone);
+	if (result)
+		goto acpi_bus_detach;
 
 	dev_info(&tz->device->dev, "registered as thermal_zone%d\n",
 		 tz->thermal_zone->id);
 
 	return 0;
 
+acpi_bus_detach:
+	acpi_bus_detach_private_data(tz->device->handle);
 remove_dev_link:
 	sysfs_remove_link(&tz->thermal_zone->device.kobj, "device");
 remove_tz_link:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 6e26678ac312..e1d800be8bb4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -280,18 +280,11 @@ static int mlxsw_thermal_set_mode(struct thermal_zone_device *tzdev,
 {
 	struct mlxsw_thermal *thermal = tzdev->devdata;
 
-	mutex_lock(&tzdev->lock);
-
 	if (mode == THERMAL_DEVICE_ENABLED)
 		tzdev->polling_delay = thermal->polling_delay;
 	else
 		tzdev->polling_delay = 0;
 
-	tzdev->mode = mode;
-	mutex_unlock(&tzdev->lock);
-
-	thermal_zone_device_update(tzdev, THERMAL_EVENT_UNSPECIFIED);
-
 	return 0;
 }
 
@@ -459,19 +452,11 @@ static int mlxsw_thermal_module_mode_set(struct thermal_zone_device *tzdev,
 	struct mlxsw_thermal_module *tz = tzdev->devdata;
 	struct mlxsw_thermal *thermal = tz->parent;
 
-	mutex_lock(&tzdev->lock);
-
 	if (mode == THERMAL_DEVICE_ENABLED)
 		tzdev->polling_delay = thermal->polling_delay;
 	else
 		tzdev->polling_delay = 0;
 
-	tzdev->mode = mode;
-
-	mutex_unlock(&tzdev->lock);
-
-	thermal_zone_device_update(tzdev, THERMAL_EVENT_UNSPECIFIED);
-
 	return 0;
 }
 
@@ -741,8 +726,11 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
 		return err;
 	}
 
-	module_tz->tzdev->mode = THERMAL_DEVICE_ENABLED;
-	return 0;
+	err = thermal_zone_device_enable(module_tz->tzdev);
+	if (err)
+		thermal_zone_device_unregister(module_tz->tzdev);
+
+	return err;
 }
 
 static void mlxsw_thermal_module_tz_fini(struct thermal_zone_device *tzdev)
@@ -845,6 +833,7 @@ static int
 mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
 {
 	char tz_name[MLXSW_THERMAL_ZONE_MAX_NAME];
+	int ret;
 
 	snprintf(tz_name, sizeof(tz_name), "mlxsw-gearbox%d",
 		 gearbox_tz->module + 1);
@@ -857,8 +846,11 @@ mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
 	if (IS_ERR(gearbox_tz->tzdev))
 		return PTR_ERR(gearbox_tz->tzdev);
 
-	gearbox_tz->tzdev->mode = THERMAL_DEVICE_ENABLED;
-	return 0;
+	ret = thermal_zone_device_enable(gearbox_tz->tzdev);
+	if (ret)
+		thermal_zone_device_unregister(gearbox_tz->tzdev);
+
+	return ret;
 }
 
 static void
@@ -1026,10 +1018,15 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 	if (err)
 		goto err_unreg_modules_tzdev;
 
-	thermal->tzdev->mode = THERMAL_DEVICE_ENABLED;
+	err = thermal_zone_device_enable(thermal->tzdev);
+	if (err)
+		goto err_unreg_gearboxes;
+
 	*p_thermal = thermal;
 	return 0;
 
+err_unreg_gearboxes:
+	mlxsw_thermal_gearboxes_fini(thermal);
 err_unreg_modules_tzdev:
 	mlxsw_thermal_modules_fini(thermal);
 err_unreg_tzdev:
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 32c5fe16b7f7..3efe749dc5a0 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -397,19 +397,16 @@ static inline void acerhdf_revert_to_bios_mode(void)
 {
 	acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
 	kernelmode = 0;
-	if (thz_dev) {
-		thz_dev->mode = THERMAL_DEVICE_DISABLED;
+	if (thz_dev)
 		thz_dev->polling_delay = 0;
-	}
+
 	pr_notice("kernel mode fan control OFF\n");
 }
 static inline void acerhdf_enable_kernelmode(void)
 {
 	kernelmode = 1;
-	thz_dev->mode = THERMAL_DEVICE_ENABLED;
 
 	thz_dev->polling_delay = interval*1000;
-	thermal_zone_device_update(thz_dev, THERMAL_EVENT_UNSPECIFIED);
 	pr_notice("kernel mode fan control ON\n");
 }
 
@@ -723,6 +720,8 @@ static void acerhdf_unregister_platform(void)
 
 static int __init acerhdf_register_thermal(void)
 {
+	int ret;
+
 	cl_dev = thermal_cooling_device_register("acerhdf-fan", NULL,
 						 &acerhdf_cooling_ops);
 
@@ -736,8 +735,12 @@ static int __init acerhdf_register_thermal(void)
 	if (IS_ERR(thz_dev))
 		return -EINVAL;
 
-	thz_dev->mode = kernelmode ?
-		THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED;
+	if (kernelmode)
+		ret = thermal_zone_device_enable(thz_dev);
+	else
+		ret = thermal_zone_device_disable(thz_dev);
+	if (ret)
+		return ret;
 
 	if (strcmp(thz_dev->governor->name,
 				acerhdf_zone_params.governor_name)) {
diff --git a/drivers/thermal/da9062-thermal.c b/drivers/thermal/da9062-thermal.c
index a7ac8afb063e..4d74994f160a 100644
--- a/drivers/thermal/da9062-thermal.c
+++ b/drivers/thermal/da9062-thermal.c
@@ -237,7 +237,11 @@ static int da9062_thermal_probe(struct platform_device *pdev)
 		ret = PTR_ERR(thermal->zone);
 		goto err;
 	}
-	thermal->zone->mode = THERMAL_DEVICE_ENABLED;
+	ret = thermal_zone_device_enable(thermal->zone);
+	if (ret) {
+		dev_err(&pdev->dev, "Cannot enable thermal zone device\n");
+		goto err_zone;
+	}
 
 	dev_dbg(&pdev->dev,
 		"TJUNC temperature polling period set at %d ms\n",
diff --git a/drivers/thermal/hisi_thermal.c b/drivers/thermal/hisi_thermal.c
index 2d26ae80e202..ee05950afd2f 100644
--- a/drivers/thermal/hisi_thermal.c
+++ b/drivers/thermal/hisi_thermal.c
@@ -549,8 +549,10 @@ static void hisi_thermal_toggle_sensor(struct hisi_thermal_sensor *sensor,
 {
 	struct thermal_zone_device *tzd = sensor->tzd;
 
-	tzd->ops->set_mode(tzd,
-		on ? THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED);
+	if (on)
+		thermal_zone_device_enable(tzd);
+	else
+		thermal_zone_device_disable(tzd);
 }
 
 static int hisi_thermal_probe(struct platform_device *pdev)
diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index 2c7ee5da608a..53abb1be1cba 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -255,7 +255,7 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
 	bool wait;
 	u32 val;
 
-	if (tz->mode == THERMAL_DEVICE_ENABLED) {
+	if (thermal_zone_device_is_enabled(tz)) {
 		/* Check if a measurement is currently in progress */
 		regmap_read(map, soc_data->temp_data, &val);
 		wait = !(val & soc_data->temp_valid_mask);
@@ -282,7 +282,7 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
 
 	regmap_read(map, soc_data->temp_data, &val);
 
-	if (tz->mode != THERMAL_DEVICE_ENABLED) {
+	if (!thermal_zone_device_is_enabled(tz)) {
 		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
 			     soc_data->measure_temp_mask);
 		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
@@ -365,9 +365,6 @@ static int imx_set_mode(struct thermal_zone_device *tz,
 		}
 	}
 
-	tz->mode = mode;
-	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
-
 	return 0;
 }
 
@@ -819,7 +816,9 @@ static int imx_thermal_probe(struct platform_device *pdev)
 		     data->socdata->measure_temp_mask);
 
 	data->irq_enabled = true;
-	data->tz->mode = THERMAL_DEVICE_ENABLED;
+	ret = thermal_zone_device_enable(data->tz);
+	if (ret)
+		goto thermal_zone_unregister;
 
 	ret = devm_request_threaded_irq(&pdev->dev, data->irq,
 			imx_thermal_alarm_irq, imx_thermal_alarm_irq_thread,
@@ -861,19 +860,18 @@ static int imx_thermal_remove(struct platform_device *pdev)
 static int __maybe_unused imx_thermal_suspend(struct device *dev)
 {
 	struct imx_thermal_data *data = dev_get_drvdata(dev);
-	struct regmap *map = data->tempmon;
+	int ret;
 
 	/*
 	 * Need to disable thermal sensor, otherwise, when thermal core
 	 * try to get temperature before thermal sensor resume, a wrong
 	 * temperature will be read as the thermal sensor is powered
-	 * down.
+	 * down. This is done in set_mode() operation called from
+	 * thermal_zone_device_disable()
 	 */
-	regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
-		     data->socdata->measure_temp_mask);
-	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
-		     data->socdata->power_down_mask);
-	data->tz->mode = THERMAL_DEVICE_DISABLED;
+	ret = thermal_zone_device_disable(data->tz);
+	if (ret)
+		return ret;
 	clk_disable_unprepare(data->thermal_clk);
 
 	return 0;
@@ -882,18 +880,15 @@ static int __maybe_unused imx_thermal_suspend(struct device *dev)
 static int __maybe_unused imx_thermal_resume(struct device *dev)
 {
 	struct imx_thermal_data *data = dev_get_drvdata(dev);
-	struct regmap *map = data->tempmon;
 	int ret;
 
 	ret = clk_prepare_enable(data->thermal_clk);
 	if (ret)
 		return ret;
 	/* Enabled thermal sensor after resume */
-	regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
-		     data->socdata->power_down_mask);
-	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
-		     data->socdata->measure_temp_mask);
-	data->tz->mode = THERMAL_DEVICE_ENABLED;
+	ret = thermal_zone_device_enable(data->tz);
+	if (ret)
+		return ret;
 
 	return 0;
 }
diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 9a622aaf29dd..3c0397a29b8c 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -390,12 +390,11 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
 	    mode != THERMAL_DEVICE_DISABLED)
 		return -EINVAL;
 
-	if (mode != thermal->mode) {
-		thermal->mode = mode;
+	if (mode != thermal->mode)
 		result = int3400_thermal_run_osc(priv->adev->handle,
 						priv->current_uuid_index,
 						mode == THERMAL_DEVICE_ENABLED);
-	}
+
 
 	evaluate_odvp(priv);
 
diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
index c4879b4bfbf1..e29c3e330b17 100644
--- a/drivers/thermal/intel/intel_quark_dts_thermal.c
+++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
@@ -126,10 +126,8 @@ static int soc_dts_enable(struct thermal_zone_device *tzd)
 	if (ret)
 		return ret;
 
-	if (out & QRK_DTS_ENABLE_BIT) {
-		tzd->mode = THERMAL_DEVICE_ENABLED;
+	if (out & QRK_DTS_ENABLE_BIT)
 		return 0;
-	}
 
 	if (!aux_entry->locked) {
 		out |= QRK_DTS_ENABLE_BIT;
@@ -137,10 +135,7 @@ static int soc_dts_enable(struct thermal_zone_device *tzd)
 				     QRK_DTS_REG_OFFSET_ENABLE, out);
 		if (ret)
 			return ret;
-
-		tzd->mode = THERMAL_DEVICE_ENABLED;
 	} else {
-		tzd->mode = THERMAL_DEVICE_DISABLED;
 		pr_info("DTS is locked. Cannot enable DTS\n");
 		ret = -EPERM;
 	}
@@ -159,10 +154,8 @@ static int soc_dts_disable(struct thermal_zone_device *tzd)
 	if (ret)
 		return ret;
 
-	if (!(out & QRK_DTS_ENABLE_BIT)) {
-		tzd->mode = THERMAL_DEVICE_DISABLED;
+	if (!(out & QRK_DTS_ENABLE_BIT))
 		return 0;
-	}
 
 	if (!aux_entry->locked) {
 		out &= ~QRK_DTS_ENABLE_BIT;
@@ -171,10 +164,7 @@ static int soc_dts_disable(struct thermal_zone_device *tzd)
 
 		if (ret)
 			return ret;
-
-		tzd->mode = THERMAL_DEVICE_DISABLED;
 	} else {
-		tzd->mode = THERMAL_DEVICE_ENABLED;
 		pr_info("DTS is locked. Cannot disable DTS\n");
 		ret = -EPERM;
 	}
@@ -404,9 +394,7 @@ static struct soc_sensor_entry *alloc_soc_dts(void)
 		goto err_ret;
 	}
 
-	mutex_lock(&dts_update_mutex);
-	err = soc_dts_enable(aux_entry->tzone);
-	mutex_unlock(&dts_update_mutex);
+	err = thermal_zone_device_enable(aux_entry->tzone);
 	if (err)
 		goto err_aux_status;
 
diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockchip_thermal.c
index 15a71ecc916c..aa9e0e31ef98 100644
--- a/drivers/thermal/rockchip_thermal.c
+++ b/drivers/thermal/rockchip_thermal.c
@@ -1068,8 +1068,10 @@ rockchip_thermal_toggle_sensor(struct rockchip_thermal_sensor *sensor, bool on)
 {
 	struct thermal_zone_device *tzd = sensor->tzd;
 
-	tzd->ops->set_mode(tzd,
-		on ? THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED);
+	if (on)
+		thermal_zone_device_enable(tzd);
+	else
+		thermal_zone_device_disable(tzd);
 }
 
 static irqreturn_t rockchip_thermal_alarm_irq_thread(int irq, void *dev)
diff --git a/drivers/thermal/sprd_thermal.c b/drivers/thermal/sprd_thermal.c
index a340374e8c51..58f995b0f804 100644
--- a/drivers/thermal/sprd_thermal.c
+++ b/drivers/thermal/sprd_thermal.c
@@ -322,8 +322,10 @@ static void sprd_thm_toggle_sensor(struct sprd_thermal_sensor *sen, bool on)
 {
 	struct thermal_zone_device *tzd = sen->tzd;
 
-	tzd->ops->set_mode(tzd,
-		on ? THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED);
+	if (on)
+		thermal_zone_device_enable(tzd);
+	else
+		thermal_zone_device_disable(tzd);
 }
 
 static int sprd_thm_probe(struct platform_device *pdev)
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index f2a5c5ee3455..14baf0288759 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1521,7 +1521,7 @@ static int thermal_pm_notify(struct notifier_block *nb,
 	case PM_POST_SUSPEND:
 		atomic_set(&in_suspend, 0);
 		list_for_each_entry(tz, &thermal_tz_list, node) {
-			if (tz->mode == THERMAL_DEVICE_DISABLED)
+			if (!thermal_zone_device_is_enabled(tz))
 				continue;
 
 			thermal_zone_device_init(tz);
diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index ba65d48a48cb..43a516a35d64 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -272,8 +272,6 @@ static int of_thermal_set_mode(struct thermal_zone_device *tz,
 {
 	struct __thermal_zone *data = tz->devdata;
 
-	mutex_lock(&tz->lock);
-
 	if (mode == THERMAL_DEVICE_ENABLED) {
 		tz->polling_delay = data->polling_delay;
 		tz->passive_delay = data->passive_delay;
@@ -282,11 +280,6 @@ static int of_thermal_set_mode(struct thermal_zone_device *tz,
 		tz->passive_delay = 0;
 	}
 
-	mutex_unlock(&tz->lock);
-
-	tz->mode = mode;
-	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
-
 	return 0;
 }
 
@@ -541,7 +534,7 @@ thermal_zone_of_sensor_register(struct device *dev, int sensor_id, void *data,
 			tzd = thermal_zone_of_add_sensor(child, sensor_np,
 							 data, ops);
 			if (!IS_ERR(tzd))
-				tzd->ops->set_mode(tzd, THERMAL_DEVICE_ENABLED);
+				thermal_zone_device_enable(tzd);
 
 			of_node_put(child);
 			goto exit;
@@ -1120,7 +1113,6 @@ int __init of_parse_thermal_zones(void)
 			of_thermal_free_zone(tz);
 			/* attempting to build remaining zones still */
 		}
-		zone->mode = THERMAL_DEVICE_DISABLED;
 	}
 	of_node_put(np);
 
diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index 096370977068..c23d67c4dc4e 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -49,9 +49,9 @@ static ssize_t
 mode_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct thermal_zone_device *tz = to_thermal_zone(dev);
+	int enabled = thermal_zone_device_is_enabled(tz);
 
-	return sprintf(buf, "%s\n", tz->mode == THERMAL_DEVICE_ENABLED ?
-		       "enabled" : "disabled");
+	return sprintf(buf, "%s\n", enabled ? "enabled" : "disabled");
 }
 
 static ssize_t
@@ -61,13 +61,10 @@ mode_store(struct device *dev, struct device_attribute *attr,
 	struct thermal_zone_device *tz = to_thermal_zone(dev);
 	int result;
 
-	if (!tz->ops->set_mode)
-		return -EPERM;
-
 	if (!strncmp(buf, "enabled", sizeof("enabled") - 1))
-		result = tz->ops->set_mode(tz, THERMAL_DEVICE_ENABLED);
+		result = thermal_zone_device_enable(tz);
 	else if (!strncmp(buf, "disabled", sizeof("disabled") - 1))
-		result = tz->ops->set_mode(tz, THERMAL_DEVICE_DISABLED);
+		result = thermal_zone_device_disable(tz);
 	else
 		result = -EINVAL;
 
-- 
2.17.1


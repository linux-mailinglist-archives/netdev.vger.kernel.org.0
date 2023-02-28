Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963C06A57D0
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 12:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjB1LXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 06:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjB1LXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 06:23:34 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1762412D
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 03:23:14 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id bx12so6177699wrb.11
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 03:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677583393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=msTNvGByW6wnSBM4h7Lzte8/9XtB6qDrvbyiJrlnYaU=;
        b=YKQQ0B6H86bZgv8j3DgnF2AtQJCvA145VIxwFfUEK7+OFSrQFhWn6Z+FO1FbzDXmc7
         tezTe8SjarJXiAh5GSoO/UHL3lIQQiy8OJG6+CawvM4xwhUNtx2JfY3j+BXjgpXKNgUq
         J1R7rvUcw6nh5bFI7jvRn7uQ+jg1picGCFM9kKYmjU6lc9FhNrrZnbgNQ1WOJm4NLADv
         8YXWAfgIq6fMhgj5pk91qyPgW+syl8emZPa8F+gi3vOP6+q/6m9Hxv9CREQlCwDq12KI
         je/vwDctD1L/a2PrLPlXQetXzCEMnbq7uyZMI390Yw7YRX6AUPulCVDwW0YaQrMCPz0V
         PjfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677583393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=msTNvGByW6wnSBM4h7Lzte8/9XtB6qDrvbyiJrlnYaU=;
        b=nxFqcO6nhXZn5NO1FkBMilC9obFv05078LeS76FrdMkhd50DZ7Bp/xjUZifsefUaWJ
         Lh9zWay2TdnT4WhOHd0+ju40Rwy3g9k91+sDcvVWaVm5SuT2lPaFu5cvwMfd9m0hLiyY
         TTEGNvNXi7rDteU2CrGr9CM9d3AT8YIMtZ8fWkSfF1+9opZeFNLAyIqSKgTMuO6ov+b1
         Lowge7bxjjMoNuzwh1bycprx3Sl+zecskBPjFoybqNU5LQZ0TRcqUM0SElkDlAVV2drs
         urE94IlBWXfMKJerJ2PGKU161wu8dnaf41SdKoe81PhpKXmt7CwiuM7H/xWrcVYVIALd
         yp+w==
X-Gm-Message-State: AO0yUKXPRRRE0wSpy8dxV2/e/N7IRQzhxIWirfi2ukibR3Y1Yyx4owIF
        9CxGPoZHDXM/GSLSAZ664lLraA==
X-Google-Smtp-Source: AK7set/quQ4rSyRAWBNWHoRXbLJjh2dHPq5POGlwp84dvXvVg6gzdt7cUZwnJ86M3Kgacy5F2OUPAw==
X-Received: by 2002:a5d:6d45:0:b0:2c7:851:c0bf with SMTP id k5-20020a5d6d45000000b002c70851c0bfmr1899592wri.0.1677583392984;
        Tue, 28 Feb 2023 03:23:12 -0800 (PST)
Received: from mai.box.freepro.com ([2a05:6e02:1041:c10:6830:6390:2815:b6a5])
        by smtp.gmail.com with ESMTPSA id z5-20020a5d6545000000b002c5501a5803sm9598130wrv.65.2023.02.28.03.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 03:23:12 -0800 (PST)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     rafael@kernel.org, daniel.lezcano@linaro.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@nvidia.com>, Kalle Valo <kvalo@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-acpi@vger.kernel.org (open list:ACPI THERMAL DRIVER),
        linux-ide@vger.kernel.org (open list:LIBATA SUBSYSTEM (Serial and
        Parallel ATA drivers)),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/FREESCALE IMX
        / MXC ARM ARCHITECTURE),
        linux-iio@vger.kernel.org (open list:IIO SUBSYSTEM AND DRIVERS),
        linux-sunxi@lists.linux.dev (open list:ARM/Allwinner sunXi SoC support),
        linux-input@vger.kernel.org (open list:INPUT (KEYBOARD, MOUSE, JOYSTICK
        , TOUCHSCREEN)...),
        netdev@vger.kernel.org (open list:CXGB4 ETHERNET DRIVER (CXGB4)),
        linux-wireless@vger.kernel.org (open list:INTEL WIRELESS WIFI LINK
        (iwlwifi))
Subject: [PATCH v4 04/19] thermal/core: Use the thermal zone 'devdata' accessor in remaining drivers
Date:   Tue, 28 Feb 2023 12:22:23 +0100
Message-Id: <20230228112238.2312273-5-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230228112238.2312273-1-daniel.lezcano@linaro.org>
References: <20230228112238.2312273-1-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The thermal zone device structure is exposed to the different drivers
and obviously they access the internals while that should be
restricted to the core thermal code.

In order to self-encapsulate the thermal core code, we need to prevent
the drivers accessing directly the thermal zone structure and provide
accessor functions to deal with.

Use the devdata accessor introduced in the previous patch.

No functional changes intended.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com> #mlxsw
Acked-by: Gregory Greenman <gregory.greenman@intel.com> #iwlwifi
Acked-by: Sebastian Reichel <sebastian.reichel@collabora.com> #power_supply
Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com> #ahci
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/thermal.c                           | 16 ++++++++--------
 drivers/ata/ahci_imx.c                           |  2 +-
 drivers/iio/adc/sun4i-gpadc-iio.c                |  2 +-
 drivers/input/touchscreen/sun4i-ts.c             |  2 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_thermal.c   |  2 +-
 .../net/ethernet/mellanox/mlxsw/core_thermal.c   | 14 +++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c      |  4 ++--
 drivers/power/supply/power_supply_core.c         |  2 +-
 drivers/regulator/max8973-regulator.c            |  2 +-
 9 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 0b4b844f9d4c..392b73b3e269 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -498,7 +498,7 @@ static int acpi_thermal_get_trip_points(struct acpi_thermal *tz)
 
 static int thermal_get_temp(struct thermal_zone_device *thermal, int *temp)
 {
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_priv(thermal);
 	int result;
 
 	if (!tz)
@@ -516,7 +516,7 @@ static int thermal_get_temp(struct thermal_zone_device *thermal, int *temp)
 static int thermal_get_trip_type(struct thermal_zone_device *thermal,
 				 int trip, enum thermal_trip_type *type)
 {
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_priv(thermal);
 	int i;
 
 	if (!tz || trip < 0)
@@ -560,7 +560,7 @@ static int thermal_get_trip_type(struct thermal_zone_device *thermal,
 static int thermal_get_trip_temp(struct thermal_zone_device *thermal,
 				 int trip, int *temp)
 {
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_priv(thermal);
 	int i;
 
 	if (!tz || trip < 0)
@@ -613,7 +613,7 @@ static int thermal_get_trip_temp(struct thermal_zone_device *thermal,
 static int thermal_get_crit_temp(struct thermal_zone_device *thermal,
 				int *temperature)
 {
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_priv(thermal);
 
 	if (tz->trips.critical.flags.valid) {
 		*temperature = deci_kelvin_to_millicelsius_with_offset(
@@ -628,7 +628,7 @@ static int thermal_get_crit_temp(struct thermal_zone_device *thermal,
 static int thermal_get_trend(struct thermal_zone_device *thermal,
 			     int trip, enum thermal_trend *trend)
 {
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_priv(thermal);
 	enum thermal_trip_type type;
 	int i;
 
@@ -670,7 +670,7 @@ static int thermal_get_trend(struct thermal_zone_device *thermal,
 
 static void acpi_thermal_zone_device_hot(struct thermal_zone_device *thermal)
 {
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_priv(thermal);
 
 	acpi_bus_generate_netlink_event(tz->device->pnp.device_class,
 					dev_name(&tz->device->dev),
@@ -679,7 +679,7 @@ static void acpi_thermal_zone_device_hot(struct thermal_zone_device *thermal)
 
 static void acpi_thermal_zone_device_critical(struct thermal_zone_device *thermal)
 {
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_priv(thermal);
 
 	acpi_bus_generate_netlink_event(tz->device->pnp.device_class,
 					dev_name(&tz->device->dev),
@@ -693,7 +693,7 @@ static int acpi_thermal_cooling_device_cb(struct thermal_zone_device *thermal,
 					  bool bind)
 {
 	struct acpi_device *device = cdev->devdata;
-	struct acpi_thermal *tz = thermal->devdata;
+	struct acpi_thermal *tz = thermal_zone_device_priv(thermal);
 	struct acpi_device *dev;
 	acpi_handle handle;
 	int i;
diff --git a/drivers/ata/ahci_imx.c b/drivers/ata/ahci_imx.c
index a950767f7948..e45e91f5e703 100644
--- a/drivers/ata/ahci_imx.c
+++ b/drivers/ata/ahci_imx.c
@@ -418,7 +418,7 @@ static int __sata_ahci_read_temperature(void *dev, int *temp)
 
 static int sata_ahci_read_temperature(struct thermal_zone_device *tz, int *temp)
 {
-	return __sata_ahci_read_temperature(tz->devdata, temp);
+	return __sata_ahci_read_temperature(thermal_zone_device_priv(tz), temp);
 }
 
 static ssize_t sata_ahci_show_temp(struct device *dev,
diff --git a/drivers/iio/adc/sun4i-gpadc-iio.c b/drivers/iio/adc/sun4i-gpadc-iio.c
index a6ade70dedf8..a5322550c422 100644
--- a/drivers/iio/adc/sun4i-gpadc-iio.c
+++ b/drivers/iio/adc/sun4i-gpadc-iio.c
@@ -414,7 +414,7 @@ static int sun4i_gpadc_runtime_resume(struct device *dev)
 
 static int sun4i_gpadc_get_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct sun4i_gpadc_iio *info = tz->devdata;
+	struct sun4i_gpadc_iio *info = thermal_zone_device_priv(tz);
 	int val, scale, offset;
 
 	if (sun4i_gpadc_temp_read(info->indio_dev, &val))
diff --git a/drivers/input/touchscreen/sun4i-ts.c b/drivers/input/touchscreen/sun4i-ts.c
index 73eb8f80be6e..1117fba30020 100644
--- a/drivers/input/touchscreen/sun4i-ts.c
+++ b/drivers/input/touchscreen/sun4i-ts.c
@@ -194,7 +194,7 @@ static int sun4i_get_temp(const struct sun4i_ts_data *ts, int *temp)
 
 static int sun4i_get_tz_temp(struct thermal_zone_device *tz, int *temp)
 {
-	return sun4i_get_temp(tz->devdata, temp);
+	return sun4i_get_temp(thermal_zone_device_priv(tz), temp);
 }
 
 static const struct thermal_zone_device_ops sun4i_ts_tz_ops = {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
index 95e1b415ba13..dea9d2907666 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
@@ -12,7 +12,7 @@
 static int cxgb4_thermal_get_temp(struct thermal_zone_device *tzdev,
 				  int *temp)
 {
-	struct adapter *adap = tzdev->devdata;
+	struct adapter *adap = thermal_zone_device_priv(tzdev);
 	u32 param, val;
 	int ret;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index c5240d38c9db..722e4a40afef 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -201,7 +201,7 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
 static int mlxsw_thermal_bind(struct thermal_zone_device *tzdev,
 			      struct thermal_cooling_device *cdev)
 {
-	struct mlxsw_thermal *thermal = tzdev->devdata;
+	struct mlxsw_thermal *thermal = thermal_zone_device_priv(tzdev);
 	struct device *dev = thermal->bus_info->dev;
 	int i, err;
 
@@ -227,7 +227,7 @@ static int mlxsw_thermal_bind(struct thermal_zone_device *tzdev,
 static int mlxsw_thermal_unbind(struct thermal_zone_device *tzdev,
 				struct thermal_cooling_device *cdev)
 {
-	struct mlxsw_thermal *thermal = tzdev->devdata;
+	struct mlxsw_thermal *thermal = thermal_zone_device_priv(tzdev);
 	struct device *dev = thermal->bus_info->dev;
 	int i;
 	int err;
@@ -249,7 +249,7 @@ static int mlxsw_thermal_unbind(struct thermal_zone_device *tzdev,
 static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
 				  int *p_temp)
 {
-	struct mlxsw_thermal *thermal = tzdev->devdata;
+	struct mlxsw_thermal *thermal = thermal_zone_device_priv(tzdev);
 	struct device *dev = thermal->bus_info->dev;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	int temp;
@@ -281,7 +281,7 @@ static struct thermal_zone_device_ops mlxsw_thermal_ops = {
 static int mlxsw_thermal_module_bind(struct thermal_zone_device *tzdev,
 				     struct thermal_cooling_device *cdev)
 {
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
+	struct mlxsw_thermal_module *tz = thermal_zone_device_priv(tzdev);
 	struct mlxsw_thermal *thermal = tz->parent;
 	int i, j, err;
 
@@ -310,7 +310,7 @@ static int mlxsw_thermal_module_bind(struct thermal_zone_device *tzdev,
 static int mlxsw_thermal_module_unbind(struct thermal_zone_device *tzdev,
 				       struct thermal_cooling_device *cdev)
 {
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
+	struct mlxsw_thermal_module *tz = thermal_zone_device_priv(tzdev);
 	struct mlxsw_thermal *thermal = tz->parent;
 	int i;
 	int err;
@@ -356,7 +356,7 @@ mlxsw_thermal_module_temp_and_thresholds_get(struct mlxsw_core *core,
 static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 					 int *p_temp)
 {
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
+	struct mlxsw_thermal_module *tz = thermal_zone_device_priv(tzdev);
 	struct mlxsw_thermal *thermal = tz->parent;
 	int temp, crit_temp, emerg_temp;
 	struct device *dev;
@@ -391,7 +391,7 @@ static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
 					  int *p_temp)
 {
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
+	struct mlxsw_thermal_module *tz = thermal_zone_device_priv(tzdev);
 	struct mlxsw_thermal *thermal = tz->parent;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	u16 index;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 232c200af38f..354d95222b1b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -615,7 +615,7 @@ int iwl_mvm_send_temp_report_ths_cmd(struct iwl_mvm *mvm)
 static int iwl_mvm_tzone_get_temp(struct thermal_zone_device *device,
 				  int *temperature)
 {
-	struct iwl_mvm *mvm = (struct iwl_mvm *)device->devdata;
+	struct iwl_mvm *mvm = thermal_zone_device_priv(device);
 	int ret;
 	int temp;
 
@@ -641,7 +641,7 @@ static int iwl_mvm_tzone_get_temp(struct thermal_zone_device *device,
 static int iwl_mvm_tzone_set_trip_temp(struct thermal_zone_device *device,
 				       int trip, int temp)
 {
-	struct iwl_mvm *mvm = (struct iwl_mvm *)device->devdata;
+	struct iwl_mvm *mvm = thermal_zone_device_priv(device);
 	struct iwl_mvm_thermal_device *tzone;
 	int ret;
 
diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 7c790c41e2fe..83fd19079d8b 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -1142,7 +1142,7 @@ static int power_supply_read_temp(struct thermal_zone_device *tzd,
 	int ret;
 
 	WARN_ON(tzd == NULL);
-	psy = tzd->devdata;
+	psy = thermal_zone_device_priv(tzd);
 	ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_TEMP, &val);
 	if (ret)
 		return ret;
diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index 7e00a45db26a..303426135276 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -436,7 +436,7 @@ static int max8973_init_dcdc(struct max8973_chip *max,
 
 static int max8973_thermal_read_temp(struct thermal_zone_device *tz, int *temp)
 {
-	struct max8973_chip *mchip = tz->devdata;
+	struct max8973_chip *mchip = thermal_zone_device_priv(tz);
 	unsigned int val;
 	int ret;
 
-- 
2.34.1


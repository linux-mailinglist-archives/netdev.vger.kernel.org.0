Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1E06A34F4
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 23:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjBZWzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 17:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjBZWzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 17:55:13 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23C51968A
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 14:54:50 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id p23-20020a05600c1d9700b003ead4835046so3371442wms.0
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 14:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIfl5ecpE8cMxQAnIWz+2/cYoWx8q+m0Q2auH1OfSio=;
        b=wKhGC5zK0RhMS7a2WDVuw7YBZuJZ6Axd7LEZEkJdJOlk6AHYhMZvqjNjVmMCzcKSKu
         1xZ3hb6UM7TVWpZfy2n9PRJIZeQYiGqQ/DsM0zZ4YnZe8XW/ypDwErLiC4G+kHl0z3QN
         eV7mXlJmp5XPPO0B7oSfi9tyzBKCHo89wrEQzcrA8i7XCnt3PkCHsJzshnUkCd6BJbgh
         yZK5Z45BzhLXwzUYrTnaATk9bIIf2rpjajI71GMTwkgVezA4QeO18jJk+3vlNIfxOZYS
         /+Y3rSxKSC+ZNc6DtLZ4bLkNgml7GZjHpgLpLCzp1C4ZNaWoV4e17WM9oUleVsgjjokW
         VdMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oIfl5ecpE8cMxQAnIWz+2/cYoWx8q+m0Q2auH1OfSio=;
        b=68Ymg451Slk+60+/rW0XWl5kseA9TDFDGFACBv5uLRwrvHFH/mACw11FbrsQlmIkF1
         5gnjSAvd2x3tCQ/J6OxOJoBHKkUws/xamtT9mLWmrz18lHR1X6akdJdUp2lFx7z4PnaP
         t6Lq7S5VtRl6wOUNUpcQCixscFp5l1M7FpswEbizhLe0WCr01r41rF9Reev8aAuyV5i8
         IqlxnUmGW3gZjD7FrDFgyPyisF0fQrTAshq0QB89E5t42Jd1u/9TtwWMeqn22jtk5iN6
         eFmN8CxtyHCt59aDljog3Wa9+U1wc/jikTcNbwKu4itwKVQTrSdVL7zkmY4T0iE3P/8z
         czhQ==
X-Gm-Message-State: AO0yUKV3BDmC3HQHZQQiPyVQqXU4t0GCxlJaGOhsobdHwLBaoarc47El
        QDwHEb+Pon685pD6K1fXMnCaXA==
X-Google-Smtp-Source: AK7set/7uS5YIla/4o52wxzjL4u2gjStDQ7r1PnKuznyLe4QtlalK1Q1QA9nidKqafWMjXOiJc3/ZQ==
X-Received: by 2002:a05:600c:331b:b0:3eb:2da4:f32d with SMTP id q27-20020a05600c331b00b003eb2da4f32dmr6406441wmp.26.1677452088585;
        Sun, 26 Feb 2023 14:54:48 -0800 (PST)
Received: from mai.box.freepro.com ([2a05:6e02:1041:c10:8baa:6b32:391b:62de])
        by smtp.gmail.com with ESMTPSA id d10-20020a05600c3aca00b003eb369abd92sm6138074wms.2.2023.02.26.14.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 14:54:48 -0800 (PST)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     rafael@kernel.org, daniel.lezcano@linaro.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
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
Subject: [PATCH v3 04/20] thermal/core: Use the thermal zone 'devdata' accessor in remaining drivers
Date:   Sun, 26 Feb 2023 23:53:50 +0100
Message-Id: <20230226225406.979703-5-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230226225406.979703-1-daniel.lezcano@linaro.org>
References: <20230226225406.979703-1-daniel.lezcano@linaro.org>
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


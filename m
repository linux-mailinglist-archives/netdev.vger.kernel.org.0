Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC531A1312
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 19:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgDGRt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 13:49:56 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43030 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgDGRtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 13:49:51 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id A39BC2972AE
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
Subject: [RFC 6/8] thermal: Set initial state to THERMAL_DEVICE_INITIAL
Date:   Tue,  7 Apr 2020 19:49:24 +0200
Message-Id: <20200407174926.23971-7-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200407174926.23971-1-andrzej.p@collabora.com>
References: <20200407174926.23971-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that THERMAL_DEVICE_INITIAL is available use it.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/acpi/thermal.c                                  | 1 +
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c      | 3 +++
 drivers/platform/x86/acerhdf.c                          | 1 +
 drivers/thermal/da9062-thermal.c                        | 2 +-
 drivers/thermal/imx_thermal.c                           | 1 +
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 1 +
 drivers/thermal/intel/intel_quark_dts_thermal.c         | 1 +
 7 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index a93b0412dd6b..0f352cef4898 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -881,6 +881,7 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE &&
 			tz->trips.active[i].flags.valid; i++, trips++);
 
+	tz->mode = THERMAL_DEVICE_INITIAL;
 	if (tz->trips.passive.flags.valid)
 		tz->thermal_zone =
 			thermal_zone_device_register("acpitz", trips, 0, tz,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index cd435ca7adbe..a58ab4d18331 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -758,6 +758,7 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
 
 	snprintf(tz_name, sizeof(tz_name), "mlxsw-module%d",
 		 module_tz->module + 1);
+	module_tz->mode = THERMAL_DEVICE_INITIAL;
 	module_tz->tzdev = thermal_zone_device_register(tz_name,
 							MLXSW_THERMAL_NUM_TRIPS,
 							MLXSW_THERMAL_TRIP_MASK,
@@ -876,6 +877,7 @@ mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
 
 	snprintf(tz_name, sizeof(tz_name), "mlxsw-gearbox%d",
 		 gearbox_tz->module + 1);
+	gearbox_tz->mode = THERMAL_DEVICE_INITIAL;
 	gearbox_tz->tzdev = thermal_zone_device_register(tz_name,
 						MLXSW_THERMAL_NUM_TRIPS,
 						MLXSW_THERMAL_TRIP_MASK,
@@ -1033,6 +1035,7 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 				 MLXSW_THERMAL_SLOW_POLL_INT :
 				 MLXSW_THERMAL_POLL_INT;
 
+	thermal->mode = THERMAL_DEVICE_INITIAL;
 	thermal->tzdev = thermal_zone_device_register("mlxsw",
 						      MLXSW_THERMAL_NUM_TRIPS,
 						      MLXSW_THERMAL_TRIP_MASK,
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 87e357017d4a..00751a0f5312 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -747,6 +747,7 @@ static int __init acerhdf_register_thermal(void)
 	if (IS_ERR(cl_dev))
 		return -EINVAL;
 
+	thermal_mode = THERMAL_DEVICE_INITIAL;
 	thz_dev = thermal_zone_device_register("acerhdf", 2, 0, NULL,
 					      &acerhdf_dev_ops,
 					      &acerhdf_zone_params, 0,
diff --git a/drivers/thermal/da9062-thermal.c b/drivers/thermal/da9062-thermal.c
index c32709badeda..2f876760d667 100644
--- a/drivers/thermal/da9062-thermal.c
+++ b/drivers/thermal/da9062-thermal.c
@@ -233,7 +233,7 @@ static int da9062_thermal_probe(struct platform_device *pdev)
 
 	thermal->config = match->data;
 	thermal->hw = chip;
-	thermal->mode = THERMAL_DEVICE_ENABLED;
+	thermal->mode = THERMAL_DEVICE_INITIAL;
 	thermal->dev = &pdev->dev;
 
 	INIT_DELAYED_WORK(&thermal->work, da9062_thermal_poll_on);
diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index 014512581918..1e8fd56c2568 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -805,6 +805,7 @@ static int imx_thermal_probe(struct platform_device *pdev)
 		goto legacy_cleanup;
 	}
 
+	data->mode = THERMAL_DEVICE_INITIAL;
 	data->tz = thermal_zone_device_register("imx_thermal_zone",
 						IMX_TRIP_NUM,
 						BIT(IMX_TRIP_PASSIVE), data,
diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index fcbd1b14fa74..9c8caa37ed13 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -307,6 +307,7 @@ static int int3400_thermal_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, priv);
 
+	priv->mode = THERMAL_DEVICE_INITIAL;
 	priv->thermal = thermal_zone_device_register("INT3400 Thermal", 0, 0,
 						priv, &int3400_thermal_ops,
 						&int3400_thermal_params, 0, 0);
diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
index 5f4bcc0e4fd3..af588ff9aa76 100644
--- a/drivers/thermal/intel/intel_quark_dts_thermal.c
+++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
@@ -411,6 +411,7 @@ static struct soc_sensor_entry *alloc_soc_dts(void)
 			goto err_ret;
 	}
 
+	aux_entry->mode = THERMAL_DEVICE_INITIAL;
 	aux_entry->tzone = thermal_zone_device_register("quark_dts",
 			QRK_MAX_DTS_TRIPS,
 			wr_mask,
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 261471A12FD
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 19:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDGRtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 13:49:43 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42884 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgDGRtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 13:49:42 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 202672972AA
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
Subject: [RFC 2/8] thermal: Properly handle mode values in .set_mode()
Date:   Tue,  7 Apr 2020 19:49:20 +0200
Message-Id: <20200407174926.23971-3-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200407174926.23971-1-andrzej.p@collabora.com>
References: <20200407174926.23971-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow only THERMAL_DEVICE_ENABLED and THERMAL_DEVICE_DISABLED as valid
states to transition to.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 8 ++++++--
 drivers/platform/x86/acerhdf.c                     | 4 ++++
 drivers/thermal/imx_thermal.c                      | 4 +++-
 drivers/thermal/intel/intel_quark_dts_thermal.c    | 5 ++++-
 drivers/thermal/of-thermal.c                       | 4 +++-
 5 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index ce0a6837daa3..cd435ca7adbe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -296,8 +296,10 @@ static int mlxsw_thermal_set_mode(struct thermal_zone_device *tzdev,
 
 	if (mode == THERMAL_DEVICE_ENABLED)
 		tzdev->polling_delay = thermal->polling_delay;
-	else
+	else if (mode == THERMAL_DEVICE_DISABLED)
 		tzdev->polling_delay = 0;
+	else
+		return -EINVAL;
 
 	mutex_unlock(&tzdev->lock);
 
@@ -486,8 +488,10 @@ static int mlxsw_thermal_module_mode_set(struct thermal_zone_device *tzdev,
 
 	if (mode == THERMAL_DEVICE_ENABLED)
 		tzdev->polling_delay = thermal->polling_delay;
-	else
+	else if (mode == THERMAL_DEVICE_DISABLED)
 		tzdev->polling_delay = 0;
+	else
+		return -EINVAL;
 
 	mutex_unlock(&tzdev->lock);
 
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 8cc86f4e3ac1..d5188c1d688b 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -431,6 +431,10 @@ static int acerhdf_get_mode(struct thermal_zone_device *thermal,
 static int acerhdf_set_mode(struct thermal_zone_device *thermal,
 			    enum thermal_device_mode mode)
 {
+	if (mode != THERMAL_DEVICE_DISABLED &&
+	    mode != THERMAL_DEVICE_ENABLED)
+		return -EINVAL;
+
 	if (mode == THERMAL_DEVICE_DISABLED && kernelmode)
 		acerhdf_revert_to_bios_mode();
 	else if (mode == THERMAL_DEVICE_ENABLED && !kernelmode)
diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index bb6754a5342c..014512581918 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -368,7 +368,7 @@ static int imx_set_mode(struct thermal_zone_device *tz,
 			data->irq_enabled = true;
 			enable_irq(data->irq);
 		}
-	} else {
+	} else if (mode == THERMAL_DEVICE_DISABLED) {
 		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
 			     soc_data->measure_temp_mask);
 		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
@@ -381,6 +381,8 @@ static int imx_set_mode(struct thermal_zone_device *tz,
 			disable_irq(data->irq);
 			data->irq_enabled = false;
 		}
+	} else {
+		return -EINVAL;
 	}
 
 	data->mode = mode;
diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
index 5d33b350da1c..5f4bcc0e4fd3 100644
--- a/drivers/thermal/intel/intel_quark_dts_thermal.c
+++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
@@ -328,8 +328,11 @@ static int sys_set_mode(struct thermal_zone_device *tzd,
 	mutex_lock(&dts_update_mutex);
 	if (mode == THERMAL_DEVICE_ENABLED)
 		ret = soc_dts_enable(tzd);
-	else
+	else if (mode == THERMAL_DEVICE_DISABLED)
 		ret = soc_dts_disable(tzd);
+	else
+		return -EINVAL;
+
 	mutex_unlock(&dts_update_mutex);
 
 	return ret;
diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index ef0baa954ff0..b7621dfab17c 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -289,9 +289,11 @@ static int of_thermal_set_mode(struct thermal_zone_device *tz,
 	if (mode == THERMAL_DEVICE_ENABLED) {
 		tz->polling_delay = data->polling_delay;
 		tz->passive_delay = data->passive_delay;
-	} else {
+	} else if (mode == THERMAL_DEVICE_DISABLED) {
 		tz->polling_delay = 0;
 		tz->passive_delay = 0;
+	} else {
+		return -EINVAL;
 	}
 
 	mutex_unlock(&tz->lock);
-- 
2.17.1


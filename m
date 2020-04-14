Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B811A8837
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503218AbgDNSBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:01:39 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46710 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503178AbgDNSBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:01:22 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id C384B2A1BDE
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
Subject: [RFC v2 2/9] thermal: Eliminate an always-false condition
Date:   Tue, 14 Apr 2020 20:00:58 +0200
Message-Id: <20200414180105.20042-3-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414180105.20042-1-andrzej.p@collabora.com>
References: <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
 <20200414180105.20042-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver provides a non-NULL "devdata" argument for
thermal_zone_device_register(). Thermal core never sets it to NULL
afterwards, so checking for its being NULL in this driver makes no sense.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/acpi/thermal.c                                  | 6 ------
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 6 ------
 2 files changed, 12 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 19067a5e5293..328b479ce7f6 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -531,9 +531,6 @@ static int thermal_get_mode(struct thermal_zone_device *thermal,
 {
 	struct acpi_thermal *tz = thermal->devdata;
 
-	if (!tz)
-		return -EINVAL;
-
 	*mode = tz->tz_enabled ? THERMAL_DEVICE_ENABLED :
 		THERMAL_DEVICE_DISABLED;
 
@@ -546,9 +543,6 @@ static int thermal_set_mode(struct thermal_zone_device *thermal,
 	struct acpi_thermal *tz = thermal->devdata;
 	int enable;
 
-	if (!tz)
-		return -EINVAL;
-
 	/*
 	 * enable/disable thermal management from ACPI thermal driver
 	 */
diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index e802922a13cf..fbb59dd09481 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -235,9 +235,6 @@ static int int3400_thermal_get_mode(struct thermal_zone_device *thermal,
 {
 	struct int3400_thermal_priv *priv = thermal->devdata;
 
-	if (!priv)
-		return -EINVAL;
-
 	*mode = priv->mode;
 
 	return 0;
@@ -250,9 +247,6 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
 	bool enable;
 	int result = 0;
 
-	if (!priv)
-		return -EINVAL;
-
 	if (mode == THERMAL_DEVICE_ENABLED)
 		enable = true;
 	else if (mode == THERMAL_DEVICE_DISABLED)
-- 
2.17.1


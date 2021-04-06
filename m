Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC7C3553D6
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242985AbhDFM2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:28:23 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57649 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242186AbhDFM2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:28:19 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 270025C00A7;
        Tue,  6 Apr 2021 08:28:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Apr 2021 08:28:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WMxkHsOkXPOUFEJO7
        Gh+L9IlE2Vkv/ILIFs+Nf72TO0=; b=lQatyIUZGtwmwQ46nThWUgCAvUuGTFRXO
        W6CWmqMIA44QzIDeTmm2aAzck1xVSJ9Rn8VR1gNAnm0Y2wmAzGYiGj7OuJblf4Sd
        HoCfvOvb8E2Z34yYIHAsS6EdwayGB+9UfUKHDuK5M7xHmO5LGqzfh78QUv7PVj6f
        7AeREOJWfQP3YjtZ+PtArtRAn8m7QlPOlqj5GS5CgdNvCw+3/BZu1brDD7X7GUMM
        oJuvTYXDKFirepRcmz3XZn08XV1nHjIohv1avYPMNNQvG9M6oF+mJltFM9SEFS2Z
        YmWvRtsO1qc3AsEFCrOfJ5PAJkfySikS6xTPx9/0qOpRjbW0r4jPQ==
X-ME-Sender: <xms:2lNsYL10-MflSd6R7-4un696MdvEgvYEVz1QRfo23y4Bf1DdSuhZ5g>
    <xme:2lNsYKGe3SnG3AGkhnr9OT9ofL3f03bveB859nrt3EBfypJjDmj7aqbt10sYub01B
    mPELSqbFw8mu9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejgedggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:2lNsYL6IrcFKzryB5folLxO7JicXPdjvEcoUR0eEmrqEmJdcc1mNIg>
    <xmx:2lNsYA1ZyXeyk_boDV6-S8f4Q9wwAyMUtMTl1PBK5KjYgOpTT1jdWw>
    <xmx:2lNsYOFc_IBvW67spbbLP17GuOz7Ga8EV0y1DJ8EQOxdaMPPeOV5pw>
    <xmx:21NsYKC46vUexb7oPJLzcS90f31KDTn_qc85GI3Ubch0-EkFW_97_g>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id CCED424005B;
        Tue,  6 Apr 2021 08:28:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] mlxsw: core: Remove critical trip points from thermal zones
Date:   Tue,  6 Apr 2021 15:27:33 +0300
Message-Id: <20210406122733.773304-1-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Disable software thermal protection by removing critical trip points
from all thermal zones.

The software thermal protection is redundant given there are two layers
of protection below it in firmware and hardware. The first layer is
performed by firmware, the second, in case firmware was not able to
perform protection, by hardware.
The temperature threshold set for hardware protection is always higher
than for firmware.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 27 +++++--------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index bf85ce9835d7..37fb2e1fb278 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -19,7 +19,6 @@
 #define MLXSW_THERMAL_ASIC_TEMP_NORM	75000	/* 75C */
 #define MLXSW_THERMAL_ASIC_TEMP_HIGH	85000	/* 85C */
 #define MLXSW_THERMAL_ASIC_TEMP_HOT	105000	/* 105C */
-#define MLXSW_THERMAL_ASIC_TEMP_CRIT	140000	/* 140C */
 #define MLXSW_THERMAL_HYSTERESIS_TEMP	5000	/* 5C */
 #define MLXSW_THERMAL_MODULE_TEMP_SHIFT	(MLXSW_THERMAL_HYSTERESIS_TEMP * 2)
 #define MLXSW_THERMAL_ZONE_MAX_NAME	16
@@ -45,7 +44,6 @@ enum mlxsw_thermal_trips {
 	MLXSW_THERMAL_TEMP_TRIP_NORM,
 	MLXSW_THERMAL_TEMP_TRIP_HIGH,
 	MLXSW_THERMAL_TEMP_TRIP_HOT,
-	MLXSW_THERMAL_TEMP_TRIP_CRIT,
 };
 
 struct mlxsw_thermal_trip {
@@ -75,16 +73,9 @@ static const struct mlxsw_thermal_trip default_thermal_trips[] = {
 	{	/* Warning */
 		.type		= THERMAL_TRIP_HOT,
 		.temp		= MLXSW_THERMAL_ASIC_TEMP_HOT,
-		.hyst		= MLXSW_THERMAL_HYSTERESIS_TEMP,
 		.min_state	= MLXSW_THERMAL_MAX_STATE,
 		.max_state	= MLXSW_THERMAL_MAX_STATE,
 	},
-	{	/* Critical - soft poweroff */
-		.type		= THERMAL_TRIP_CRITICAL,
-		.temp		= MLXSW_THERMAL_ASIC_TEMP_CRIT,
-		.min_state	= MLXSW_THERMAL_MAX_STATE,
-		.max_state	= MLXSW_THERMAL_MAX_STATE,
-	}
 };
 
 #define MLXSW_THERMAL_NUM_TRIPS	ARRAY_SIZE(default_thermal_trips)
@@ -154,7 +145,6 @@ mlxsw_thermal_module_trips_reset(struct mlxsw_thermal_module *tz)
 	tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temp = 0;
 	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HIGH].temp = 0;
 	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HOT].temp = 0;
-	tz->trips[MLXSW_THERMAL_TEMP_TRIP_CRIT].temp = 0;
 }
 
 static int
@@ -183,11 +173,10 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
 	}
 
 	/* According to the system thermal requirements, the thermal zones are
-	 * defined with four trip points. The critical and emergency
+	 * defined with three trip points. The critical and emergency
 	 * temperature thresholds, provided by QSFP module are set as "active"
-	 * and "hot" trip points, "normal" and "critical" trip points are
-	 * derived from "active" and "hot" by subtracting or adding double
-	 * hysteresis value.
+	 * and "hot" trip points, "normal" trip point is derived from "active"
+	 * by subtracting double hysteresis value.
 	 */
 	if (crit_temp >= MLXSW_THERMAL_MODULE_TEMP_SHIFT)
 		tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temp = crit_temp -
@@ -196,8 +185,6 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
 		tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temp = crit_temp;
 	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HIGH].temp = crit_temp;
 	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HOT].temp = emerg_temp;
-	tz->trips[MLXSW_THERMAL_TEMP_TRIP_CRIT].temp = emerg_temp +
-					MLXSW_THERMAL_MODULE_TEMP_SHIFT;
 
 	return 0;
 }
@@ -210,7 +197,7 @@ static void mlxsw_thermal_tz_score_update(struct mlxsw_thermal *thermal,
 	struct mlxsw_thermal_trip *trip = trips;
 	unsigned int score, delta, i, shift = 1;
 
-	/* Calculate thermal zone score, if temperature is above the critical
+	/* Calculate thermal zone score, if temperature is above the hot
 	 * threshold score is set to MLXSW_THERMAL_TEMP_SCORE_MAX.
 	 */
 	score = MLXSW_THERMAL_TEMP_SCORE_MAX;
@@ -333,8 +320,7 @@ static int mlxsw_thermal_set_trip_temp(struct thermal_zone_device *tzdev,
 {
 	struct mlxsw_thermal *thermal = tzdev->devdata;
 
-	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS ||
-	    temp > MLXSW_THERMAL_ASIC_TEMP_CRIT)
+	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
 		return -EINVAL;
 
 	thermal->trips[trip].temp = temp;
@@ -502,8 +488,7 @@ mlxsw_thermal_module_trip_temp_set(struct thermal_zone_device *tzdev,
 {
 	struct mlxsw_thermal_module *tz = tzdev->devdata;
 
-	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS ||
-	    temp > tz->trips[MLXSW_THERMAL_TEMP_TRIP_CRIT].temp)
+	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
 		return -EINVAL;
 
 	tz->trips[trip].temp = temp;
-- 
2.30.2


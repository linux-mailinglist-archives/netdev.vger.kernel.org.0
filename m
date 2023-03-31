Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5466D2237
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjCaOSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbjCaOSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:18:52 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4211B34E
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 07:18:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xi4NzS5K1gqxuw7mNggYosmnd7gfCMsfum+yjCw4fCGAEeAIAKPcDza92MeISbj/fSJrOeHC6DqNG6dzpry9F6irm5Fx74HOuviLU0YHwHEBAals1AjpClriw81CGqIpoE0Z//pS3ApFOgcy0NWoSk8AkBeg4e3JL3nU68GSSxTPJbSSMusvEsbJ07KcNMB5WfEqHKUOWhJ3uIMOSvSmlu1AmeWD/yWZJMMX76DLtrErPuyW8xgpAZOElEzvNYu+baD3+HYpwc5Yy+po2VoYr2f/Gl57i/P9iJfla0wLpZ9R0CoJ8vhazdtY25/JSECzFbYF29XnNtqclPXdD3WqpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rcbB6HyNob0yjFPSzRaytoI4lAdIIHUag66cWrJpzkM=;
 b=hM+0+zTrp0FCJ2/wzcA2udoQvXH0xCXn26c9g90IFo6v12dU5RgKq2/9lR97gfntTkPU/ks0hpiDqECYMsRdYDClxvJTsWlmKmK+d5nEGWopomDaoYAx1tuGQXUnNwQbt7wGMbI9qOgR9cRxtcCueswJKt7rz/rYceAXLS/L4Ysfutw8ONg66ac824hfbTn/P50u6oeutFDP0ICN5m3XE3fQFYdmJ7YH3rx8GQgUWTzRmE0iry27wGGFtD9W2LyfHH/YfuJxc58tk75weColuJKC2WJRwQNo9eXODvkqPsTXQVnpw1PPohBwEFmIbZD8Qfz5CyBLvB0PLjOqzWf92Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcbB6HyNob0yjFPSzRaytoI4lAdIIHUag66cWrJpzkM=;
 b=DOI9+j5UUxulrxa6ujL3bVRVubswERHnnsQsaOAaKePVpoumJaDgWmYThAa91urNarnhjgHY4f+mhVBKF8M78PY5UrUgBMs5hahNaZMjrStHsOrZK5zpDhDV9enqCgE/9SVo55Qti1ZJbnh9DjGS/3LItXAvLr2Xt8g9OEK8+ZEUmcHisAGDNj3XzfFivsJ9mMmEJNFBtPVwk/nof+1EV91G6so0RJaNt7wVs7p7nGKPhOc40cpQsS1noO5SlcSsNGyjYz4MYHA0VhuVzbx9o54Y+pyFJqy6qucCaB2gJWzc/xOwINJWkmc1WkUkATCu87SmHJqOoSS/lPxwi+pC3A==
Received: from BN7PR06CA0044.namprd06.prod.outlook.com (2603:10b6:408:34::21)
 by SA1PR12MB8162.namprd12.prod.outlook.com (2603:10b6:806:33a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Fri, 31 Mar
 2023 14:18:47 +0000
Received: from BL02EPF000108E9.namprd05.prod.outlook.com
 (2603:10b6:408:34:cafe::2b) by BN7PR06CA0044.outlook.office365.com
 (2603:10b6:408:34::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Fri, 31 Mar 2023 14:18:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000108E9.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Fri, 31 Mar 2023 14:18:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 31 Mar 2023
 07:18:35 -0700
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 31 Mar
 2023 07:18:32 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 1/3] mlxsw: core_thermal: Use static trip points for transceiver modules
Date:   Fri, 31 Mar 2023 16:17:30 +0200
Message-ID: <051bffde8a638410eea98ac51cb3a429e0130889.1680272119.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1680272119.git.petrm@nvidia.com>
References: <cover.1680272119.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E9:EE_|SA1PR12MB8162:EE_
X-MS-Office365-Filtering-Correlation-Id: 4983cd75-f566-4375-5592-08db31f2d788
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HAiXV5YO3htVmGxFCOBgBrCn499AdxTIxL0xIODD/nSWGF+WYmsmCeoSEys9Zdz+VZSm0349jS2NDfmCWi6NW3R2gswvcuKMVNCqBSboC3ZP7fbRmpG2oEE+YDHN4jsmwJWC24HIvD9qlRVOdWgsKLWbko7l2RRRPsX/9LojnpC6PyPOm/a+2A//e+cX8Cd1USMPdFt53xSvnyyW2PSxhFD+/ja88M1EcUpKEUsEgSKuhRDai9T+EVjGnRvGfY8jRrrVaKr068GuIpLCLaWdZRISsF1F8moQ9Y+MP9pX9KckpeU7JeU+Xe0ktjuj4hZ8qmw8L12NGktBjOtSzFTdKOheit2qVRbHPaD0/gxf03jOvX53E2jBaIuzicXrH+e3MBxwgL8gq2Ace0nXVs4p77hmCFPwt9MDlRTqfncDGF2xmGbRJrg+IDeWGXAflqwBOXfcdxSrRIANqK/Y0y6yjMvcZLkKxzFGhH/g/AtmJwHgibofWLJv2GRUN+CW/vZf2c1+gs0rpvNkBDk8yOG+6iIRG2CljvC/aG5Wz3NmuUIiBD4Yp77elgMd/v9hZdFeHGSB0ehVFQUegltbYlCXhNXZi8A7q1XoMDx/gRmouaplVd3euqfO32SI5oHyfvwGiTdH/rMZOksBrIxDmDWlAGMEAihYgga0cF1pMB7T0QITogu+KJtnL28STgPpuUG+xJFYOfHeDVIlv/0fe98fFh4Pv5CM6KMf2F/Ww+owUwX3T06RFTOUIF71o+sBWarW9ndQPA0AshqHCxHOCFLr6JeLDFmW6Nn79Zt4cD51nLmut1aIgBv2Hn8Rl+CHcL3bITSdp87lWhYJ0bcBzS2RkA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199021)(36840700001)(40470700004)(46966006)(54906003)(36860700001)(426003)(186003)(16526019)(966005)(478600001)(47076005)(336012)(70586007)(83380400001)(70206006)(8676002)(110136005)(316002)(4326008)(26005)(2616005)(107886003)(41300700001)(82740400003)(356005)(5660300002)(40460700003)(2906002)(8936002)(7636003)(40480700001)(82310400005)(36756003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 14:18:46.8752
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4983cd75-f566-4375-5592-08db31f2d788
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8162
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The driver registers a thermal zone for each transceiver module and
tries to set the trip point temperatures according to the thresholds
read from the transceiver. If a threshold cannot be read or if a
transceiver is unplugged, the trip point temperature is set to zero,
which means that it is disabled as far as the thermal subsystem is
concerned.

A recent change in the thermal core made it so that such trip points are
no longer marked as disabled, which lead the thermal subsystem to
incorrectly set the associated cooling devices to the their maximum
state [1]. A fix to restore this behavior was merged in commit
f1b80a3878b2 ("thermal: core: Restore behavior regarding invalid trip
points"). However, the thermal maintainer suggested to not rely on this
behavior and instead always register a valid array of trip points [2].

Therefore, create a static array of trip points with sane defaults
(suggested by Vadim) and register it with the thermal zone of each
transceiver module. User space can choose to override these defaults
using the thermal zone sysfs interface since these files are writeable.

Before:

 $ cat /sys/class/thermal/thermal_zone11/type
 mlxsw-module11
 $ cat /sys/class/thermal/thermal_zone11/trip_point_*_temp
 65000
 75000
 80000

After:

 $ cat /sys/class/thermal/thermal_zone11/type
 mlxsw-module11
 $ cat /sys/class/thermal/thermal_zone11/trip_point_*_temp
 55000
 65000
 80000

Also tested by reverting commit f1b80a3878b2 ("thermal: core: Restore
behavior regarding invalid trip points") and making sure that the
associated cooling devices are not set to their maximum state.

[1] https://lore.kernel.org/linux-pm/ZA3CFNhU4AbtsP4G@shredder/
[2] https://lore.kernel.org/linux-pm/f78e6b70-a963-c0ca-a4b2-0d4c6aeef1fb@linaro.org/

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 110 ++++--------------
 1 file changed, 25 insertions(+), 85 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 09ed6e5fa6c3..ece5075b7dbf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -19,6 +19,9 @@
 #define MLXSW_THERMAL_ASIC_TEMP_NORM	75000	/* 75C */
 #define MLXSW_THERMAL_ASIC_TEMP_HIGH	85000	/* 85C */
 #define MLXSW_THERMAL_ASIC_TEMP_HOT	105000	/* 105C */
+#define MLXSW_THERMAL_MODULE_TEMP_NORM	55000	/* 55C */
+#define MLXSW_THERMAL_MODULE_TEMP_HIGH	65000	/* 65C */
+#define MLXSW_THERMAL_MODULE_TEMP_HOT	80000	/* 80C */
 #define MLXSW_THERMAL_HYSTERESIS_TEMP	5000	/* 5C */
 #define MLXSW_THERMAL_MODULE_TEMP_SHIFT	(MLXSW_THERMAL_HYSTERESIS_TEMP * 2)
 #define MLXSW_THERMAL_MAX_STATE	10
@@ -30,12 +33,6 @@ static char * const mlxsw_thermal_external_allowed_cdev[] = {
 	"mlxreg_fan",
 };
 
-enum mlxsw_thermal_trips {
-	MLXSW_THERMAL_TEMP_TRIP_NORM,
-	MLXSW_THERMAL_TEMP_TRIP_HIGH,
-	MLXSW_THERMAL_TEMP_TRIP_HOT,
-};
-
 struct mlxsw_cooling_states {
 	int	min_state;
 	int	max_state;
@@ -59,6 +56,24 @@ static const struct thermal_trip default_thermal_trips[] = {
 	},
 };
 
+static const struct thermal_trip default_thermal_module_trips[] = {
+	{	/* In range - 0-40% PWM */
+		.type		= THERMAL_TRIP_ACTIVE,
+		.temperature	= MLXSW_THERMAL_MODULE_TEMP_NORM,
+		.hysteresis	= MLXSW_THERMAL_HYSTERESIS_TEMP,
+	},
+	{
+		/* In range - 40-100% PWM */
+		.type		= THERMAL_TRIP_ACTIVE,
+		.temperature	= MLXSW_THERMAL_MODULE_TEMP_HIGH,
+		.hysteresis	= MLXSW_THERMAL_HYSTERESIS_TEMP,
+	},
+	{	/* Warning */
+		.type		= THERMAL_TRIP_HOT,
+		.temperature	= MLXSW_THERMAL_MODULE_TEMP_HOT,
+	},
+};
+
 static const struct mlxsw_cooling_states default_cooling_states[] = {
 	{
 		.min_state	= 0,
@@ -140,63 +155,6 @@ static int mlxsw_get_cooling_device_idx(struct mlxsw_thermal *thermal,
 	return -ENODEV;
 }
 
-static void
-mlxsw_thermal_module_trips_reset(struct mlxsw_thermal_module *tz)
-{
-	tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temperature = 0;
-	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HIGH].temperature = 0;
-	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HOT].temperature = 0;
-}
-
-static int
-mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
-				  struct mlxsw_thermal_module *tz,
-				  int crit_temp, int emerg_temp)
-{
-	int err;
-
-	/* Do not try to query temperature thresholds directly from the module's
-	 * EEPROM if we got valid thresholds from MTMP.
-	 */
-	if (!emerg_temp || !crit_temp) {
-		err = mlxsw_env_module_temp_thresholds_get(core, tz->slot_index,
-							   tz->module,
-							   SFP_TEMP_HIGH_WARN,
-							   &crit_temp);
-		if (err)
-			return err;
-
-		err = mlxsw_env_module_temp_thresholds_get(core, tz->slot_index,
-							   tz->module,
-							   SFP_TEMP_HIGH_ALARM,
-							   &emerg_temp);
-		if (err)
-			return err;
-	}
-
-	if (crit_temp > emerg_temp) {
-		dev_warn(dev, "%s : Critical threshold %d is above emergency threshold %d\n",
-			 tz->tzdev->type, crit_temp, emerg_temp);
-		return 0;
-	}
-
-	/* According to the system thermal requirements, the thermal zones are
-	 * defined with three trip points. The critical and emergency
-	 * temperature thresholds, provided by QSFP module are set as "active"
-	 * and "hot" trip points, "normal" trip point is derived from "active"
-	 * by subtracting double hysteresis value.
-	 */
-	if (crit_temp >= MLXSW_THERMAL_MODULE_TEMP_SHIFT)
-		tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temperature = crit_temp -
-					MLXSW_THERMAL_MODULE_TEMP_SHIFT;
-	else
-		tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temperature = crit_temp;
-	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HIGH].temperature = crit_temp;
-	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HOT].temperature = emerg_temp;
-
-	return 0;
-}
-
 static int mlxsw_thermal_bind(struct thermal_zone_device *tzdev,
 			      struct thermal_cooling_device *cdev)
 {
@@ -358,10 +316,8 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 	struct mlxsw_thermal_module *tz = tzdev->devdata;
 	struct mlxsw_thermal *thermal = tz->parent;
 	int temp, crit_temp, emerg_temp;
-	struct device *dev;
 	u16 sensor_index;
 
-	dev = thermal->bus_info->dev;
 	sensor_index = MLXSW_REG_MTMP_MODULE_INDEX_MIN + tz->module;
 
 	/* Read module temperature and thresholds. */
@@ -371,13 +327,6 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 						     &crit_temp, &emerg_temp);
 	*p_temp = temp;
 
-	if (!temp)
-		return 0;
-
-	/* Update trip points. */
-	mlxsw_thermal_module_trips_update(dev, thermal->core, tz,
-					  crit_temp, emerg_temp);
-
 	return 0;
 }
 
@@ -527,10 +476,7 @@ mlxsw_thermal_module_init(struct device *dev, struct mlxsw_core *core,
 			  struct mlxsw_thermal_area *area, u8 module)
 {
 	struct mlxsw_thermal_module *module_tz;
-	int dummy_temp, crit_temp, emerg_temp;
-	u16 sensor_index;
 
-	sensor_index = MLXSW_REG_MTMP_MODULE_INDEX_MIN + module;
 	module_tz = &area->tz_module_arr[module];
 	/* Skip if parent is already set (case of port split). */
 	if (module_tz->parent)
@@ -538,19 +484,13 @@ mlxsw_thermal_module_init(struct device *dev, struct mlxsw_core *core,
 	module_tz->module = module;
 	module_tz->slot_index = area->slot_index;
 	module_tz->parent = thermal;
-	memcpy(module_tz->trips, default_thermal_trips,
+	BUILD_BUG_ON(ARRAY_SIZE(default_thermal_module_trips) !=
+		     MLXSW_THERMAL_NUM_TRIPS);
+	memcpy(module_tz->trips, default_thermal_module_trips,
 	       sizeof(thermal->trips));
 	memcpy(module_tz->cooling_states, default_cooling_states,
 	       sizeof(thermal->cooling_states));
-	/* Initialize all trip point. */
-	mlxsw_thermal_module_trips_reset(module_tz);
-	/* Read module temperature and thresholds. */
-	mlxsw_thermal_module_temp_and_thresholds_get(core, area->slot_index,
-						     sensor_index, &dummy_temp,
-						     &crit_temp, &emerg_temp);
-	/* Update trip point according to the module data. */
-	return mlxsw_thermal_module_trips_update(dev, core, module_tz,
-						 crit_temp, emerg_temp);
+	return 0;
 }
 
 static void mlxsw_thermal_module_fini(struct mlxsw_thermal_module *module_tz)
-- 
2.39.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3380B2DEF0
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 15:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfE2Nwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 09:52:40 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36745 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727151AbfE2Nwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 09:52:40 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from vadimp@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 29 May 2019 16:52:32 +0300
Received: from r-build-lowlevel.mtr.labs.mlnx. (r-build-lowlevel.mtr.labs.mlnx [10.209.0.190])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x4TDqW4s024369;
        Wed, 29 May 2019 16:52:32 +0300
From:   Vadim Pasternak <vadimp@mellanox.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux@roeck-us.net, rui.zhang@intel.com,
        edubezval@gmail.com, daniel.lezcano@linaro.org, jiri@resnulli.us,
        idosch@mellanox.com, Vadim Pasternak <vadimp@mellanox.com>
Subject: [patch net-next RFC v1] mlxsw: core: Add the hottest thermal zone detection
Date:   Wed, 29 May 2019 13:52:23 +0000
Message-Id: <20190529135223.5338-1-vadimp@mellanox.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When multiple sensors are mapped to the same cooling device, the
cooling device should be set according the worst sensor from the
sensors associated with this cooling device.

Provide the hottest thermal zone detection and enforce cooling device to
follow the temperature trends the hottest zone only.
Prevent competition for the cooling device control from others zones, by
"stable trend" indication. A cooling device will not perform any
actions associated with a zone with "stable trend".

When other thermal zone is detected as a hottest, a cooling device is to
be switched to following temperature trends of new hottest zone.

Thermal zone score is represented by 32 bits unsigned integer and
calculated according to the next formula:
For T < TZ<t><i>, where t from {normal trip = 0, high trip = 1, hot
trip = 2, critical = 3}:
TZ<i> score = (T + (TZ<t><i> - T) / 2) / (TZ<t><i> - T) * 256 ** j;
Highest thermal zone score s is set as MAX(TZ<i>score);
Following this formula, if TZ<i> is in trip point higher than TZ<k>,
the higher score is to be always assigned to TZ<i>.

For two thermal zones located at the same kind of trip point, the higher
score will be assigned to the zone, which closer to the next trip point.
Thus, the highest score will always be assigned objectively to the hottest
thermal zone.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 64 +++++++++++++++++++---
 1 file changed, 57 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index cfab0e330a47..2491ff62b783 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -23,6 +23,7 @@
 #define MLXSW_THERMAL_HYSTERESIS_TEMP	5000	/* 5C */
 #define MLXSW_THERMAL_MODULE_TEMP_SHIFT	(MLXSW_THERMAL_HYSTERESIS_TEMP * 2)
 #define MLXSW_THERMAL_ZONE_MAX_NAME	16
+#define MLXSW_THERMAL_TEMP_SCORE_MAX	0xffffffff
 #define MLXSW_THERMAL_MAX_STATE	10
 #define MLXSW_THERMAL_MAX_DUTY	255
 /* Minimum and maximum fan allowed speed in percent: from 20% to 100%. Values
@@ -111,6 +112,8 @@ struct mlxsw_thermal {
 	struct mlxsw_thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
 	enum thermal_device_mode mode;
 	struct mlxsw_thermal_module *tz_module_arr;
+	unsigned int tz_highest_score;
+	struct thermal_zone_device *tz_highest_dev;
 };
 
 static inline u8 mlxsw_state_to_duty(int state)
@@ -195,6 +198,34 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
 	return 0;
 }
 
+static void mlxsw_thermal_tz_score_update(struct mlxsw_thermal *thermal,
+					  struct thermal_zone_device *tzdev,
+					  struct mlxsw_thermal_trip *trips,
+					  int temp)
+{
+	struct mlxsw_thermal_trip *trip = trips;
+	unsigned int score, delta, i, shift = 1;
+
+	/* Calculate thermal zone score, if temperature is above the critical
+	 * threshold score is set to MLXSW_THERMAL_TEMP_SCORE_MAX.
+	 */
+	score = MLXSW_THERMAL_TEMP_SCORE_MAX;
+	for (i = MLXSW_THERMAL_TEMP_TRIP_NORM; i < MLXSW_THERMAL_NUM_TRIPS;
+	     i++, trip++) {
+		if (temp < trip->temp) {
+			delta = DIV_ROUND_CLOSEST(temp, trip->temp - temp);
+			score = delta * shift;
+			break;
+		}
+		shift *= 256;
+	}
+
+	if (score > thermal->tz_highest_score) {
+		thermal->tz_highest_score = score;
+		thermal->tz_highest_dev = tzdev;
+	}
+}
+
 static int mlxsw_thermal_bind(struct thermal_zone_device *tzdev,
 			      struct thermal_cooling_device *cdev)
 {
@@ -290,6 +321,9 @@ static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
 		return err;
 	}
 	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
+	if (temp)
+		mlxsw_thermal_tz_score_update(thermal, tzdev, thermal->trips,
+					      temp);
 
 	*p_temp = (int) temp;
 	return 0;
@@ -351,6 +385,22 @@ static int mlxsw_thermal_set_trip_hyst(struct thermal_zone_device *tzdev,
 	return 0;
 }
 
+static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
+				   int trip, enum thermal_trend *trend)
+{
+	struct mlxsw_thermal_module *tz = tzdev->devdata;
+	struct mlxsw_thermal *thermal = tz->parent;
+
+	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
+		return -EINVAL;
+
+	if (tzdev == thermal->tz_highest_dev)
+		return 1;
+
+	*trend = THERMAL_TREND_STABLE;
+	return 0;
+}
+
 static struct thermal_zone_device_ops mlxsw_thermal_ops = {
 	.bind = mlxsw_thermal_bind,
 	.unbind = mlxsw_thermal_unbind,
@@ -362,6 +412,7 @@ static struct thermal_zone_device_ops mlxsw_thermal_ops = {
 	.set_trip_temp	= mlxsw_thermal_set_trip_temp,
 	.get_trip_hyst	= mlxsw_thermal_get_trip_hyst,
 	.set_trip_hyst	= mlxsw_thermal_set_trip_hyst,
+	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_module_bind(struct thermal_zone_device *tzdev,
@@ -472,7 +523,9 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 		return 0;
 
 	/* Update trip points. */
-	mlxsw_thermal_module_trips_update(dev, thermal->core, tz);
+	err = mlxsw_thermal_module_trips_update(dev, thermal->core, tz);
+	if (!err)
+		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips, temp);
 
 	return 0;
 }
@@ -537,10 +590,6 @@ mlxsw_thermal_module_trip_hyst_set(struct thermal_zone_device *tzdev, int trip,
 	return 0;
 }
 
-static struct thermal_zone_params mlxsw_thermal_module_params = {
-	.governor_name = "user_space",
-};
-
 static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.bind		= mlxsw_thermal_module_bind,
 	.unbind		= mlxsw_thermal_module_unbind,
@@ -552,6 +601,7 @@ static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
+	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_get_max_state(struct thermal_cooling_device *cdev,
@@ -667,13 +717,13 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
 							MLXSW_THERMAL_TRIP_MASK,
 							module_tz,
 							&mlxsw_thermal_module_ops,
-							&mlxsw_thermal_module_params,
-							0, 0);
+							NULL, 0, 0);
 	if (IS_ERR(module_tz->tzdev)) {
 		err = PTR_ERR(module_tz->tzdev);
 		return err;
 	}
 
+	module_tz->mode = THERMAL_DEVICE_ENABLED;
 	return 0;
 }
 
-- 
2.11.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5CC14FBB0
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 14:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfFWM5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 08:57:25 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59777 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726546AbfFWM5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 08:57:24 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E862322087;
        Sun, 23 Jun 2019 08:57:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 23 Jun 2019 08:57:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=F9Me4m4BkC3e43D3jcjbJQwiv7V+63AD8YG4Don/GuI=; b=xFDp4Kkf
        h+rwBbZuL3NZ8YD8613yTzWsAHCal8hRD0UyyN5czhRGgclj929VOLeAfsVAduNN
        Y4MOhiOy9hk8prg1u0Hm9lcKCnaHNBvP9u149dh9j9eDZzr40I84snBm8VN4tKtG
        el+oe5g5Ao9BnLBWXj3Cw/SETScDaIhfwJFfJGj6/NJ+Gn+HORhTdvG1uk88+syY
        k1nSvTbPHyi9qIRhXCKtgSNOTPLuE4AWIqDq/sSFCxPc1P/CP+WggnE4yAMt/1Qw
        vRpQGqypvJoBKkk7xwm87f/UjMnmiivDC8KbGGGh5U6muHj3bce/X9wd4cY53BJU
        yCrleYlluIWU5Q==
X-ME-Sender: <xms:MncPXduVAsO98Xdn3x_uQ-FZQ2NqE9UcJHJFdd00LUM3K-rvwe2EIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppeduleefrd
    egjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehi
    ughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:MncPXfm92Mz6_pghXIzlV5XoZ6lNH-QAuGuiEjxqdv6D83buKFAPAg>
    <xmx:MncPXZoLp5bLgE7jfERORMa7cdOACKD1EdU1A2Q80HMxbV7TareZ0g>
    <xmx:MncPXW1AnwfG2P7B7UsX6iwjzQWs-tN33iWpOR4kfgDOJUmUPClMeA>
    <xmx:MncPXWg17iOtNwbpjnD2zmIO_pI0ZswXdJSDlproA2e-Pc2OC8yGyQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E6EAB380084;
        Sun, 23 Jun 2019 08:57:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Vadim Pasternak <vadimp@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/3] mlxsw: core: Add the hottest thermal zone detection
Date:   Sun, 23 Jun 2019 15:56:44 +0300
Message-Id: <20190623125645.2663-3-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190623125645.2663-1-idosch@idosch.org>
References: <20190623125645.2663-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

When multiple sensors are mapped to the same cooling device, the
cooling device should be set according the worst sensor from the
sensors associated with this cooling device.

Provide the hottest thermal zone detection and enforce cooling device
to follow the temperature trends of the hottest zone only.
Prevent competition for the cooling device control from others zones,
by "stable trend" indication. A cooling device will not perform any
actions associated with a zone with a "stable trend".

When other thermal zone is detected as a hottest, a cooling device is
to be switched to following temperature trends of new hottest zone.

Thermal zone score is represented by 32 bits unsigned integer and
calculated according to the next formula:
For T < TZ<t><i>, where t from {normal trip = 0, high trip = 1, hot
trip = 2, critical = 3}:
TZ<i> score = (T + (TZ<t><i> - T) / 2) / (TZ<t><i> - T) * 256 ** j;
Highest thermal zone score s is set as MAX(TZ<i>score);
Following this formula, if TZ<i> is in trip point higher than TZ<k>,
the higher score is to be always assigned to TZ<i>.

For two thermal zones located at the same kind of trip point, the higher
score will be assigned to the zone which is closer to the next trip
point. Thus, the highest score will always be assigned objectively to
the hottest thermal zone.

All the thermal zones initially are to be configured with mode
"enabled" with the "step_wise" governor.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 75 +++++++++++++++----
 1 file changed, 62 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 88f43ad2cc4f..504a34d240f7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -23,6 +23,7 @@
 #define MLXSW_THERMAL_HYSTERESIS_TEMP	5000	/* 5C */
 #define MLXSW_THERMAL_MODULE_TEMP_SHIFT	(MLXSW_THERMAL_HYSTERESIS_TEMP * 2)
 #define MLXSW_THERMAL_ZONE_MAX_NAME	16
+#define MLXSW_THERMAL_TEMP_SCORE_MAX	GENMASK(31, 0)
 #define MLXSW_THERMAL_MAX_STATE	10
 #define MLXSW_THERMAL_MAX_DUTY	255
 /* Minimum and maximum fan allowed speed in percent: from 20% to 100%. Values
@@ -113,6 +114,8 @@ struct mlxsw_thermal {
 	struct mlxsw_thermal_module *tz_module_arr;
 	struct mlxsw_thermal_module *tz_gearbox_arr;
 	u8 tz_gearbox_num;
+	unsigned int tz_highest_score;
+	struct thermal_zone_device *tz_highest_dev;
 };
 
 static inline u8 mlxsw_state_to_duty(int state)
@@ -197,6 +200,34 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
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
@@ -292,6 +323,9 @@ static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
 		return err;
 	}
 	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
+	if (temp > 0)
+		mlxsw_thermal_tz_score_update(thermal, tzdev, thermal->trips,
+					      temp);
 
 	*p_temp = (int) temp;
 	return 0;
@@ -353,6 +387,22 @@ static int mlxsw_thermal_set_trip_hyst(struct thermal_zone_device *tzdev,
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
@@ -364,6 +414,7 @@ static struct thermal_zone_device_ops mlxsw_thermal_ops = {
 	.set_trip_temp	= mlxsw_thermal_set_trip_temp,
 	.get_trip_hyst	= mlxsw_thermal_get_trip_hyst,
 	.set_trip_hyst	= mlxsw_thermal_set_trip_hyst,
+	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_module_bind(struct thermal_zone_device *tzdev,
@@ -474,7 +525,9 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 		return 0;
 
 	/* Update trip points. */
-	mlxsw_thermal_module_trips_update(dev, thermal->core, tz);
+	err = mlxsw_thermal_module_trips_update(dev, thermal->core, tz);
+	if (!err)
+		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips, temp);
 
 	return 0;
 }
@@ -539,10 +592,6 @@ mlxsw_thermal_module_trip_hyst_set(struct thermal_zone_device *tzdev, int trip,
 	return 0;
 }
 
-static struct thermal_zone_params mlxsw_thermal_module_params = {
-	.governor_name = "user_space",
-};
-
 static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.bind		= mlxsw_thermal_module_bind,
 	.unbind		= mlxsw_thermal_module_unbind,
@@ -554,6 +603,7 @@ static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
+	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
@@ -574,6 +624,8 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
 		return err;
 
 	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
+	if (temp > 0)
+		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips, temp);
 
 	*p_temp = (int) temp;
 	return 0;
@@ -590,10 +642,7 @@ static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-};
-
-static struct thermal_zone_params mlxsw_thermal_gearbox_params = {
-	.governor_name = "user_space",
+	.get_trend	= mlxsw_thermal_trend_get,
 };
 
 static int mlxsw_thermal_get_max_state(struct thermal_cooling_device *cdev,
@@ -709,13 +758,13 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
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
 
@@ -833,11 +882,11 @@ mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
 						MLXSW_THERMAL_TRIP_MASK,
 						gearbox_tz,
 						&mlxsw_thermal_gearbox_ops,
-						&mlxsw_thermal_gearbox_params,
-						0, 0);
+						NULL, 0, 0);
 	if (IS_ERR(gearbox_tz->tzdev))
 		return PTR_ERR(gearbox_tz->tzdev);
 
+	gearbox_tz->mode = THERMAL_DEVICE_ENABLED;
 	return 0;
 }
 
-- 
2.20.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897981F0A7B
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 10:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgFGILE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 04:11:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60097 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726192AbgFGILD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 04:11:03 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A635B5C00A6;
        Sun,  7 Jun 2020 04:11:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Jun 2020 04:11:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=sYGyYznbcrN4z7UaY
        jMqo6DcVvM8FzhkEKkiygHTpTM=; b=r28z0CeXrN73gKe07/rMV+3SJjKybJY4+
        v29mVf+yjEBnqCOmL5cgvpts5Dt8jyQbvwE/5Y0qx9qG8KIZwH61qnRw9cYD54XI
        DWC5OUIzz+aPwCzaWquL/XWQwDz3cIg32Bn2znDXUNtcABzQXV333SBMty8cbrfL
        0Gx2fNLogAeMNIz3+0rstlQiN+7Ot/5GtBtP5k1Qw96hjT7iHVc7ZDZgb9Bm2h3b
        pvF+BuR+CgxuzZc0oFXdVpR+/mseDvJiKYU0eibCM/2KIif9JvlbyQXCTOgBieWH
        l6lfXrqWCiy6mPiwBxhEl9FmTrbP7T8u02Cg6Rk+0EazXFnCXXpmA==
X-ME-Sender: <xms:FqHcXpcXTxTDsb1ezPk-8giAkwJ1LSY5EdbFI8cBql06CqVrw2AXJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudegledgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeejledrudejkedrgeehrddvvdefnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:FqHcXnPRCK6sbNFr1s8SfdSuT3f8Zg20hL9pbBckVRMSkiauJHVlHQ>
    <xmx:FqHcXijYUs1cyPkI8x3Dz-M1RiWfw_N1nQvudFkhBd3qlSOKZgR5vw>
    <xmx:FqHcXi9lPRRB6yOtS-llRAoOUs4chKpx4h7Ox0HpvDLvj0thdVTodw>
    <xmx:FqHcXu4QHpei5-Tj1f2T1bSCykFUf17_nL4NgjWu7JXKwK3eep7xbw>
Received: from splinter.mtl.com (bzq-79-178-45-223.red.bezeqint.net [79.178.45.223])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1EFB63280059;
        Sun,  7 Jun 2020 04:11:00 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] mlxsw: core: Use different get_trend() callbacks for different thermal zones
Date:   Sun,  7 Jun 2020 11:10:27 +0300
Message-Id: <20200607081027.2018361-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

The driver registers three different types of thermal zones: For the
ASIC itself, for port modules and for gearboxes.

Currently, all three types use the same get_trend() callback which does
not work correctly for the ASIC thermal zone. The callback assumes that
the device data is of type 'struct mlxsw_thermal_module', whereas for
the ASIC thermal zone 'struct mlxsw_thermal' is passed as device data.

Fix this by using one get_trend() callback for the ASIC thermal zone and
another for the other two types.

Fixes: 6f73862fabd9 ("mlxsw: core: Add the hottest thermal zone detection")
Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 23 +++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index ce0a6837daa3..05f8d5a92862 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -391,8 +391,7 @@ static int mlxsw_thermal_set_trip_hyst(struct thermal_zone_device *tzdev,
 static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
 				   int trip, enum thermal_trend *trend)
 {
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
-	struct mlxsw_thermal *thermal = tz->parent;
+	struct mlxsw_thermal *thermal = tzdev->devdata;
 
 	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
 		return -EINVAL;
@@ -593,6 +592,22 @@ mlxsw_thermal_module_trip_hyst_set(struct thermal_zone_device *tzdev, int trip,
 	return 0;
 }
 
+static int mlxsw_thermal_module_trend_get(struct thermal_zone_device *tzdev,
+					  int trip, enum thermal_trend *trend)
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
 static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.bind		= mlxsw_thermal_module_bind,
 	.unbind		= mlxsw_thermal_module_unbind,
@@ -604,7 +619,7 @@ static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_trend_get,
+	.get_trend	= mlxsw_thermal_module_trend_get,
 };
 
 static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
@@ -643,7 +658,7 @@ static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_trend_get,
+	.get_trend	= mlxsw_thermal_module_trend_get,
 };
 
 static int mlxsw_thermal_get_max_state(struct thermal_cooling_device *cdev,
-- 
2.26.2


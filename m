Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708A439F70C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 14:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhFHMqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 08:46:54 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54517 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232757AbhFHMqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 08:46:53 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 54AB35C0125;
        Tue,  8 Jun 2021 08:45:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 08 Jun 2021 08:45:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=UHlKhRBFIZ/qwfWfaSx0I2IIe5LGJqKrH0qqXQpGD94=; b=QtAM33K6
        mcUh+6sdH+8pKlFN4foSzepKxuFzyUaTskDEdkQDQyNA25pCNQSI9jKAydnCApJV
        AwqiQkQEGJJrj6YgLaJKQJn9yiYB2OCJMQf4ed3gJ0ETCe+4SfENz5wSx5857hmD
        1L2fagXIqUY6AmXTiI8i4rygdTlnbhELlpET3DlAbEGaqq0QSeU0KTni4tVP509G
        1dY/xVzXBXssPjcczB+UBEtEJJjUCa9DVFkUtL/xe4LLLnKBnNAqrkt8Ryd+GxwO
        1FV96D+pKatWBD5UtTY2aU49IFxrrPfVpm9XUO5U3HWV4WzuyGLluW05iWx+oxPS
        xQdBMDFp03bbtg==
X-ME-Sender: <xms:TGa_YGsD1jaAL_NkNWi0zOTfqdGcu7s5zTN43C8IRhJ0ddfiHMQvZw>
    <xme:TGa_YLeyy9hM4deKUahC7QzkVJlWn9jaZWQ-k5vJJgHHBz_ztvfzhEfBSvpjRtn9v
    1yvs5X2RvP5FEE>
X-ME-Received: <xmr:TGa_YBzaX7tQmUigv_M7_CB2dZ87XFujB0RJJIUHMoTmK7JNwRE0rAlw0fSdzTjP0hYzogm-gPkuZVaMTG8EPXlThjQRDkRVu5PpcRsCTJJzEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:TGa_YBNyeISJAwlQl_IWBKIbAYUVSt7aPERXeEHbVbN1Q4ofM9OJ1g>
    <xmx:TGa_YG9ojX3l7QOlHXXT60j187Guiuc6E7YP5dGosiw7OP0elQcADA>
    <xmx:TGa_YJXNQ4pijSSZ67oTEUw9Pf6ZOh-njiPM2J7KV21A8VulihM0RA>
    <xmx:TGa_YLNYczDWSaMrOo8_ZTrkZ5pZbMSD7VzYbTBgptwwxyIsIrGmjQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:44:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, vadimp@nvidia.com,
        c_mykolak@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/8] mlxsw: thermal: Read module temperature thresholds using MTMP register
Date:   Tue,  8 Jun 2021 15:44:14 +0300
Message-Id: <20210608124414.1664294-9-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608124414.1664294-1-idosch@idosch.org>
References: <20210608124414.1664294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mykola Kostenok <c_mykolak@nvidia.com>

mlxsw_thermal_module_trips_update() is used to update the trip points of
the module's thermal zone. Currently, this is done by querying the
thresholds from the module's EEPROM via MCIA register. This data does
not pass validation and in some cases can be unreliable. For example,
due to some problem with transceiver module.

Previous patch made it possible to read module's temperature and
thresholds via MTMP register. Therefore, extend
mlxsw_thermal_module_trips_update() to use the thresholds queried from
MTMP, if valid.

This is both more reliable and more efficient than current method, as
temperature and thresholds are queried in one transaction instead of
three. This is significant when working over a slow bus such as I2C.

Signed-off-by: Mykola Kostenok <c_mykolak@nvidia.com>
Acked-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 47 ++++++++++++-------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index e1ef913c81ef..d54b67d0bda7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -149,22 +149,27 @@ mlxsw_thermal_module_trips_reset(struct mlxsw_thermal_module *tz)
 
 static int
 mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
-				  struct mlxsw_thermal_module *tz)
+				  struct mlxsw_thermal_module *tz,
+				  int crit_temp, int emerg_temp)
 {
-	int crit_temp, emerg_temp;
 	int err;
 
-	err = mlxsw_env_module_temp_thresholds_get(core, tz->module,
-						   SFP_TEMP_HIGH_WARN,
-						   &crit_temp);
-	if (err)
-		return err;
+	/* Do not try to query temperature thresholds directly from the module's
+	 * EEPROM if we got valid thresholds from MTMP.
+	 */
+	if (!emerg_temp || !crit_temp) {
+		err = mlxsw_env_module_temp_thresholds_get(core, tz->module,
+							   SFP_TEMP_HIGH_WARN,
+							   &crit_temp);
+		if (err)
+			return err;
 
-	err = mlxsw_env_module_temp_thresholds_get(core, tz->module,
-						   SFP_TEMP_HIGH_ALARM,
-						   &emerg_temp);
-	if (err)
-		return err;
+		err = mlxsw_env_module_temp_thresholds_get(core, tz->module,
+							   SFP_TEMP_HIGH_ALARM,
+							   &emerg_temp);
+		if (err)
+			return err;
+	}
 
 	if (crit_temp > emerg_temp) {
 		dev_warn(dev, "%s : Critical threshold %d is above emergency threshold %d\n",
@@ -451,9 +456,9 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 {
 	struct mlxsw_thermal_module *tz = tzdev->devdata;
 	struct mlxsw_thermal *thermal = tz->parent;
+	int temp, crit_temp, emerg_temp;
 	struct device *dev;
 	u16 sensor_index;
-	int temp;
 	int err;
 
 	dev = thermal->bus_info->dev;
@@ -461,15 +466,16 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 
 	/* Read module temperature and thresholds. */
 	mlxsw_thermal_module_temp_and_thresholds_get(thermal->core,
-						     sensor_index, &temp, NULL,
-						     NULL);
+						     sensor_index, &temp,
+						     &crit_temp, &emerg_temp);
 	*p_temp = temp;
 
 	if (!temp)
 		return 0;
 
 	/* Update trip points. */
-	err = mlxsw_thermal_module_trips_update(dev, thermal->core, tz);
+	err = mlxsw_thermal_module_trips_update(dev, thermal->core, tz,
+						crit_temp, emerg_temp);
 	if (!err && temp > 0)
 		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips, temp);
 
@@ -737,7 +743,10 @@ mlxsw_thermal_module_init(struct device *dev, struct mlxsw_core *core,
 			  struct mlxsw_thermal *thermal, u8 module)
 {
 	struct mlxsw_thermal_module *module_tz;
+	int crit_temp, emerg_temp;
+	u16 sensor_index;
 
+	sensor_index = MLXSW_REG_MTMP_MODULE_INDEX_MIN + module;
 	module_tz = &thermal->tz_module_arr[module];
 	/* Skip if parent is already set (case of port split). */
 	if (module_tz->parent)
@@ -748,8 +757,12 @@ mlxsw_thermal_module_init(struct device *dev, struct mlxsw_core *core,
 	       sizeof(thermal->trips));
 	/* Initialize all trip point. */
 	mlxsw_thermal_module_trips_reset(module_tz);
+	/* Read module temperature and thresholds. */
+	mlxsw_thermal_module_temp_and_thresholds_get(core, sensor_index, NULL,
+						     &crit_temp, &emerg_temp);
 	/* Update trip point according to the module data. */
-	return mlxsw_thermal_module_trips_update(dev, core, module_tz);
+	return mlxsw_thermal_module_trips_update(dev, core, module_tz,
+						 crit_temp, emerg_temp);
 }
 
 static void mlxsw_thermal_module_fini(struct mlxsw_thermal_module *module_tz)
-- 
2.31.1


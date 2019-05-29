Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 995962D831
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfE2Ir4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:47:56 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42693 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbfE2Irv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:47:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6C8F5223E5;
        Wed, 29 May 2019 04:47:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 29 May 2019 04:47:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=SHF2GL+OFAW/jE4G2oPbxqHZ7Ibd/GTbEPfxEtomFPA=; b=eyWWpa3x
        pbFUMZJWBEELjxvkWgXsSaG0Zqy7EsfskTo9M5lXXoWs2AjMKUvb2ci5MOQjaEKP
        ELm4qJN4Zm4PyN5ifZ2tcM82uKmRy0AybupF5DxJ/hCzS3CWUTX+HAtGaAF0r6+n
        ijeO7r9rn7CTZpJ0pfPDFf5ClTlL2wgqp/foxyxOMh/dwF8htAz3lafyT3oHjtfV
        kOfFl79Qsv48t1XoWVhJXbk6ImF9wM+Say2mzJT7TruIdDWScJiAzUMF58WATy1u
        VmqHg0pQ04S/5GPAcsjY4/LuQ3mYnXnZFX4bw6D6GQRkua/4wzVUg26bBnibpElD
        SRUzH8GUmmSlUw==
X-ME-Sender: <xms:NkfuXPgl6hlvbMqzxX3GYA3xtb_x2QOSf3c1BA6g0JVRkd6y0X0fBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvjedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeej
X-ME-Proxy: <xmx:NkfuXNckv1gHTfK69UBbnUzsWPJ8MfdHzeeWEhVefz_TTZcqLaNWAA>
    <xmx:NkfuXKEgI7xIyIcwFgR3qlEASUiomGBHcQBUPC5Ur_3uU8QTP3rDAA>
    <xmx:NkfuXAzQXDC5kp_wCSOn9AcdcEEcLGiXqvpsAihrZLBsPWMdMvcIMQ>
    <xmx:NkfuXB7nn6PV0HZfhDy4DzBfZ1ZmUfI-Ps1n_1M6qaMYoQ5ys7yJfQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF5CD80061;
        Wed, 29 May 2019 04:47:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 8/8] mlxsw: core: Reduce buffer size in transactions for SFP modules temperature readout
Date:   Wed, 29 May 2019 11:47:22 +0300
Message-Id: <20190529084722.22719-9-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190529084722.22719-1-idosch@idosch.org>
References: <20190529084722.22719-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Obtain SFP modules temperatures through MTMP register instead of MTBR
register, because the first one utilizes shorter transaction buffer size
for request. It improves performance in case low frequency interface
(I2C) is used for communication with a chip.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 27 +++--------
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 34 +++-----------
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 46 ++++++++-----------
 3 files changed, 33 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 72539a9a3847..d2c7ce67c300 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -92,33 +92,20 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 		u16 temp;
 	} temp_thresh;
 	char mcia_pl[MLXSW_REG_MCIA_LEN] = {0};
-	char mtbr_pl[MLXSW_REG_MTBR_LEN] = {0};
-	u16 module_temp;
+	char mtmp_pl[MLXSW_REG_MTMP_LEN];
+	unsigned int module_temp;
 	bool qsfp;
 	int err;
 
-	mlxsw_reg_mtbr_pack(mtbr_pl, MLXSW_REG_MTBR_BASE_MODULE_INDEX + module,
-			    1);
-	err = mlxsw_reg_query(core, MLXSW_REG(mtbr), mtbr_pl);
+	mlxsw_reg_mtmp_pack(mtmp_pl, MLXSW_REG_MTMP_MODULE_INDEX_MIN + module,
+			    false, false);
+	err = mlxsw_reg_query(core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err)
 		return err;
-
-	/* Don't read temperature thresholds for module with no valid info. */
-	mlxsw_reg_mtbr_temp_unpack(mtbr_pl, 0, &module_temp, NULL);
-	switch (module_temp) {
-	case MLXSW_REG_MTBR_BAD_SENS_INFO: /* fall-through */
-	case MLXSW_REG_MTBR_NO_CONN: /* fall-through */
-	case MLXSW_REG_MTBR_NO_TEMP_SENS: /* fall-through */
-	case MLXSW_REG_MTBR_INDEX_NA:
+	mlxsw_reg_mtmp_unpack(mtmp_pl, &module_temp, NULL, NULL);
+	if (!module_temp) {
 		*temp = 0;
 		return 0;
-	default:
-		/* Do not consider thresholds for zero temperature. */
-		if (MLXSW_REG_MTMP_TEMP_TO_MC(module_temp) == 0) {
-			*temp = 0;
-			return 0;
-		}
-		break;
 	}
 
 	/* Read Free Side Device Temperature Thresholds from page 03h
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 8cd446856340..056e3f55ae6c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -214,38 +214,18 @@ static ssize_t mlxsw_hwmon_module_temp_show(struct device *dev,
 	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
 	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
-	char mtbr_pl[MLXSW_REG_MTBR_LEN] = {0};
-	u16 temp;
+	char mtmp_pl[MLXSW_REG_MTMP_LEN];
+	unsigned int temp;
 	u8 module;
 	int err;
 
 	module = mlwsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
-	mlxsw_reg_mtbr_pack(mtbr_pl, MLXSW_REG_MTBR_BASE_MODULE_INDEX + module,
-			    1);
-	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtbr), mtbr_pl);
-	if (err) {
-		dev_err(dev, "Failed to query module temperature sensor\n");
+	mlxsw_reg_mtmp_pack(mtmp_pl, MLXSW_REG_MTMP_MODULE_INDEX_MIN + module,
+			    false, false);
+	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
+	if (err)
 		return err;
-	}
-
-	mlxsw_reg_mtbr_temp_unpack(mtbr_pl, 0, &temp, NULL);
-	/* Update status and temperature cache. */
-	switch (temp) {
-	case MLXSW_REG_MTBR_NO_CONN: /* fall-through */
-	case MLXSW_REG_MTBR_NO_TEMP_SENS: /* fall-through */
-	case MLXSW_REG_MTBR_INDEX_NA:
-		temp = 0;
-		break;
-	case MLXSW_REG_MTBR_BAD_SENS_INFO:
-		/* Untrusted cable is connected. Reading temperature from its
-		 * sensor is faulty.
-		 */
-		temp = 0;
-		break;
-	default:
-		temp = MLXSW_REG_MTMP_TEMP_TO_MC(temp);
-		break;
-	}
+	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
 
 	return sprintf(buf, "%u\n", temp);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index d3e851e7ca72..cfab0e330a47 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -449,39 +449,31 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 	struct mlxsw_thermal_module *tz = tzdev->devdata;
 	struct mlxsw_thermal *thermal = tz->parent;
 	struct device *dev = thermal->bus_info->dev;
-	char mtbr_pl[MLXSW_REG_MTBR_LEN];
-	u16 temp;
+	char mtmp_pl[MLXSW_REG_MTMP_LEN];
+	unsigned int temp;
 	int err;
 
 	/* Read module temperature. */
-	mlxsw_reg_mtbr_pack(mtbr_pl, MLXSW_REG_MTBR_BASE_MODULE_INDEX +
-			    tz->module, 1);
-	err = mlxsw_reg_query(thermal->core, MLXSW_REG(mtbr), mtbr_pl);
-	if (err)
-		return err;
-
-	mlxsw_reg_mtbr_temp_unpack(mtbr_pl, 0, &temp, NULL);
-	/* Update temperature. */
-	switch (temp) {
-	case MLXSW_REG_MTBR_NO_CONN: /* fall-through */
-	case MLXSW_REG_MTBR_NO_TEMP_SENS: /* fall-through */
-	case MLXSW_REG_MTBR_INDEX_NA: /* fall-through */
-	case MLXSW_REG_MTBR_BAD_SENS_INFO:
+	mlxsw_reg_mtmp_pack(mtmp_pl, MLXSW_REG_MTMP_MODULE_INDEX_MIN +
+			    tz->module, false, false);
+	err = mlxsw_reg_query(thermal->core, MLXSW_REG(mtmp), mtmp_pl);
+	if (err) {
+		/* Do not return error - in case of broken module's sensor
+		 * it will cause error message flooding.
+		 */
 		temp = 0;
-		break;
-	default:
-		temp = MLXSW_REG_MTMP_TEMP_TO_MC(temp);
-		/* Reset all trip point. */
-		mlxsw_thermal_module_trips_reset(tz);
-		/* Update trip points. */
-		err = mlxsw_thermal_module_trips_update(dev, thermal->core,
-							tz);
-		if (err)
-			return err;
-		break;
+		*p_temp = (int) temp;
+		return 0;
 	}
-
+	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
 	*p_temp = (int) temp;
+
+	if (!temp)
+		return 0;
+
+	/* Update trip points. */
+	mlxsw_thermal_module_trips_update(dev, thermal->core, tz);
+
 	return 0;
 }
 
-- 
2.20.1


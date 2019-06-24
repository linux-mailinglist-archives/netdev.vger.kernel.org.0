Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF62508F9
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 12:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbfFXKc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 06:32:58 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52131 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729002AbfFXKc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 06:32:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0A1BB22400;
        Mon, 24 Jun 2019 06:32:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 24 Jun 2019 06:32:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=EhOlbg8nyhuXJV9RoOf5vXprz9B+wScFrLi2lz0FfB4=; b=UlacDNl3
        y4doPoYAuFJsVmiVmxY0fCiPpDpduoZqK4EBmVMrfzcWIHr0Jg4wPp0CGSGbwTeU
        6C2ggIG7R3ql0SDdNdCRVnkcDiWK1zLUjZRpqegXT0HDufGGgs5+pXmJgUDCZXOz
        7jG2MHiNUMsNtqbgWuQ38UnsTHlHpxOb50o5l8nBpRdZeqa503BRDObFAR8eWlKL
        2W36JusqmMSdazgr4QA2bUOVSy2zOMMrpyjJwsZquRTmRivMLGePv9JYNNjq/Ny5
        PSF5VCpV0oE9p4NZNZxkta0/hJ6P4pAbtAeKgTriSNL+M62yWlZ5fuZrYB6Rq7k7
        GAaiGTmAsjOxvQ==
X-ME-Sender: <xms:16YQXRxbfN3uAQrGFzolNYy7v0ER1Rczj06N4zL4uqRk9oBykAL4cQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvgdeftdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:16YQXao-BB8WLZ8XN-Fq3_3_QptNpX-ejpyu_FTPJHNVVTjQ2DA-cw>
    <xmx:16YQXT2o0gWVlR4Xp31MM297IFNtgydZHxsvQgW13EPHEqVJpIhAww>
    <xmx:16YQXTDuTPi4F5V-g1yQ9faAFVBkgMCgEIQpXhQ4OMn7kqEZqhw34A>
    <xmx:16YQXagMzci-DyDqTozxYYFBlpLGOfz4tVhs_URLvc1Ql0zJj7QGtA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1A3D80065;
        Mon, 24 Jun 2019 06:32:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        andrew@lunn.ch, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 3/3] mlxsw: core: Add support for negative temperature readout
Date:   Mon, 24 Jun 2019 13:32:03 +0300
Message-Id: <20190624103203.22090-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190624103203.22090-1-idosch@idosch.org>
References: <20190624103203.22090-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Extend macros MLXSW_REG_MTMP_TEMP_TO_MC() to allow support of negative
temperature readout, since chip and others thermal components are
capable of operating within the negative temperature.
With no such support negative temperature will be consider as very high
temperature and it will cause wrong readout and thermal shutdown.
For negative values 2`s complement is used.
Tested in chamber.
Example of chip ambient temperature readout with chamber temperature:
-10 Celsius:
temp1:             -6.0C  (highest =  -5.0C)
-5 Celsius:
temp1:             -1.0C  (highest =  -1.0C)

v2 (Andrew Lunn):
* Replace '%u' with '%d' in mlxsw_hwmon_module_temp_show()

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   | 14 ++++++--------
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 14 +++++++-------
 drivers/net/ethernet/mellanox/mlxsw/reg.h          | 12 +++++++-----
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 056e3f55ae6c..5b00726c4346 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -52,8 +52,7 @@ static ssize_t mlxsw_hwmon_temp_show(struct device *dev,
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
 	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
-	unsigned int temp;
-	int index;
+	int temp, index;
 	int err;
 
 	index = mlxsw_hwmon_get_attr_index(mlwsw_hwmon_attr->type_index,
@@ -65,7 +64,7 @@ static ssize_t mlxsw_hwmon_temp_show(struct device *dev,
 		return err;
 	}
 	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
-	return sprintf(buf, "%u\n", temp);
+	return sprintf(buf, "%d\n", temp);
 }
 
 static ssize_t mlxsw_hwmon_temp_max_show(struct device *dev,
@@ -76,8 +75,7 @@ static ssize_t mlxsw_hwmon_temp_max_show(struct device *dev,
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
 	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
-	unsigned int temp_max;
-	int index;
+	int temp_max, index;
 	int err;
 
 	index = mlxsw_hwmon_get_attr_index(mlwsw_hwmon_attr->type_index,
@@ -89,7 +87,7 @@ static ssize_t mlxsw_hwmon_temp_max_show(struct device *dev,
 		return err;
 	}
 	mlxsw_reg_mtmp_unpack(mtmp_pl, NULL, &temp_max, NULL);
-	return sprintf(buf, "%u\n", temp_max);
+	return sprintf(buf, "%d\n", temp_max);
 }
 
 static ssize_t mlxsw_hwmon_temp_rst_store(struct device *dev,
@@ -215,8 +213,8 @@ static ssize_t mlxsw_hwmon_module_temp_show(struct device *dev,
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
 	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
-	unsigned int temp;
 	u8 module;
+	int temp;
 	int err;
 
 	module = mlwsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
@@ -227,7 +225,7 @@ static ssize_t mlxsw_hwmon_module_temp_show(struct device *dev,
 		return err;
 	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
 
-	return sprintf(buf, "%u\n", temp);
+	return sprintf(buf, "%d\n", temp);
 }
 
 static ssize_t mlxsw_hwmon_module_temp_fault_show(struct device *dev,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 504a34d240f7..35a1dc89c28a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -312,7 +312,7 @@ static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
 	struct mlxsw_thermal *thermal = tzdev->devdata;
 	struct device *dev = thermal->bus_info->dev;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
-	unsigned int temp;
+	int temp;
 	int err;
 
 	mlxsw_reg_mtmp_pack(mtmp_pl, 0, false, false);
@@ -327,7 +327,7 @@ static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
 		mlxsw_thermal_tz_score_update(thermal, tzdev, thermal->trips,
 					      temp);
 
-	*p_temp = (int) temp;
+	*p_temp = temp;
 	return 0;
 }
 
@@ -503,7 +503,7 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 	struct mlxsw_thermal *thermal = tz->parent;
 	struct device *dev = thermal->bus_info->dev;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
-	unsigned int temp;
+	int temp;
 	int err;
 
 	/* Read module temperature. */
@@ -519,14 +519,14 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 		return 0;
 	}
 	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
-	*p_temp = (int) temp;
+	*p_temp = temp;
 
 	if (!temp)
 		return 0;
 
 	/* Update trip points. */
 	err = mlxsw_thermal_module_trips_update(dev, thermal->core, tz);
-	if (!err)
+	if (!err && temp > 0)
 		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips, temp);
 
 	return 0;
@@ -612,8 +612,8 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
 	struct mlxsw_thermal_module *tz = tzdev->devdata;
 	struct mlxsw_thermal *thermal = tz->parent;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
-	unsigned int temp;
 	u16 index;
+	int temp;
 	int err;
 
 	index = MLXSW_REG_MTMP_GBOX_INDEX_MIN + tz->module;
@@ -627,7 +627,7 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
 	if (temp > 0)
 		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips, temp);
 
-	*p_temp = (int) temp;
+	*p_temp = temp;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 452f645fa040..e5f6bfd8a35a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8050,7 +8050,10 @@ MLXSW_REG_DEFINE(mtmp, MLXSW_REG_MTMP_ID, MLXSW_REG_MTMP_LEN);
 MLXSW_ITEM32(reg, mtmp, sensor_index, 0x00, 0, 12);
 
 /* Convert to milli degrees Celsius */
-#define MLXSW_REG_MTMP_TEMP_TO_MC(val) (val * 125)
+#define MLXSW_REG_MTMP_TEMP_TO_MC(val) ({ typeof(val) v_ = (val); \
+					  ((v_) >= 0) ? ((v_) * 125) : \
+					  ((s16)((GENMASK(15, 0) + (v_) + 1) \
+					   * 125)); })
 
 /* reg_mtmp_temperature
  * Temperature reading from the sensor. Reading is in 0.125 Celsius
@@ -8121,11 +8124,10 @@ static inline void mlxsw_reg_mtmp_pack(char *payload, u16 sensor_index,
 						    MLXSW_REG_MTMP_THRESH_HI);
 }
 
-static inline void mlxsw_reg_mtmp_unpack(char *payload, unsigned int *p_temp,
-					 unsigned int *p_max_temp,
-					 char *sensor_name)
+static inline void mlxsw_reg_mtmp_unpack(char *payload, int *p_temp,
+					 int *p_max_temp, char *sensor_name)
 {
-	u16 temp;
+	s16 temp;
 
 	if (p_temp) {
 		temp = mlxsw_reg_mtmp_temperature_get(payload);
-- 
2.20.1


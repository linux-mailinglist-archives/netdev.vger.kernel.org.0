Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33984508F7
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 12:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbfFXKcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 06:32:54 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:32917 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728879AbfFXKcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 06:32:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 134D32240D;
        Mon, 24 Jun 2019 06:32:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 24 Jun 2019 06:32:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=jK1W/AZlBDTIU9odjD/r69tYQmjmf57uYktz9RjPY94=; b=dBNa8jHG
        vKghPgXOdbGnWtAYlGbhfEYJXiJ7y9M3v+lo54bSWqj+2Rfi3FZVgnkFHzTZpWW+
        Hs3JjHWoAMXxtFJcIxHV0+knLUqjuZ170q2wEbBWS90w9DgAiIPVrm/MXvbkX36m
        azZ6FcOP1++TMjC8cECR7R1GWZUUJQTrbtSsJdiK4QzAkbScrzNFOjiy2KChFU1q
        BmRB4ZZWnl+vmHlofnTFM1H5vMhfvxCmRtja1OmEYgvYyZ7uZtnHv5a351M9H3pc
        zww/3yECB82o3TZVZKbHpVYswLfCvfGsS1Xdb7EgAHbPcjnsFcwT7h/8G3HMSIYf
        E+Lo+nUp7oEXUw==
X-ME-Sender: <xms:06YQXaDMLEtDh-CZwCryDRyVKrqkjIcuvTBjB-7MAgK3Vb16Wu5dzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvgdeftdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:06YQXWN7xziajQ_bSE3KmQcUkXycLdgGnZKeWbBItXQGzLVAvJmv_Q>
    <xmx:06YQXRAsDfzrYT5no5-CEChONTJXj8YxhqCu925ydAss1cEuYBDa3w>
    <xmx:06YQXYkYYf-jt6GuyUDnAb6cUmSGEQkzA7sqxmTLnQBPjz7juuMe6w>
    <xmx:1KYQXXThJfgV-sXJ_GGHPA2TU0vOQbfvaDdo2c5CzCkXyVPft8oj_g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 27A7F8005C;
        Mon, 24 Jun 2019 06:32:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        andrew@lunn.ch, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 1/3] mlxsw: core: Extend thermal core with per inter-connect device thermal zones
Date:   Mon, 24 Jun 2019 13:32:01 +0300
Message-Id: <20190624103203.22090-2-idosch@idosch.org>
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

Add a dedicated thermal zone for each inter-connect device. The
current temperature is obtained from inter-connect temperature sensor
and the default trip points are set to the same values as default ASIC
trip points. These settings could be changed from the user space.
A cooling device (fan) is bound to all inter-connect devices.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 137 +++++++++++++++++-
 1 file changed, 136 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index cfab0e330a47..88f43ad2cc4f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -98,7 +98,7 @@ struct mlxsw_thermal_module {
 	struct thermal_zone_device *tzdev;
 	struct mlxsw_thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
 	enum thermal_device_mode mode;
-	int module;
+	int module; /* Module or gearbox number */
 };
 
 struct mlxsw_thermal {
@@ -111,6 +111,8 @@ struct mlxsw_thermal {
 	struct mlxsw_thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
 	enum thermal_device_mode mode;
 	struct mlxsw_thermal_module *tz_module_arr;
+	struct mlxsw_thermal_module *tz_gearbox_arr;
+	u8 tz_gearbox_num;
 };
 
 static inline u8 mlxsw_state_to_duty(int state)
@@ -554,6 +556,46 @@ static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
 };
 
+static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
+					  int *p_temp)
+{
+	struct mlxsw_thermal_module *tz = tzdev->devdata;
+	struct mlxsw_thermal *thermal = tz->parent;
+	char mtmp_pl[MLXSW_REG_MTMP_LEN];
+	unsigned int temp;
+	u16 index;
+	int err;
+
+	index = MLXSW_REG_MTMP_GBOX_INDEX_MIN + tz->module;
+	mlxsw_reg_mtmp_pack(mtmp_pl, index, false, false);
+
+	err = mlxsw_reg_query(thermal->core, MLXSW_REG(mtmp), mtmp_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
+
+	*p_temp = (int) temp;
+	return 0;
+}
+
+static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
+	.bind		= mlxsw_thermal_module_bind,
+	.unbind		= mlxsw_thermal_module_unbind,
+	.get_mode	= mlxsw_thermal_module_mode_get,
+	.set_mode	= mlxsw_thermal_module_mode_set,
+	.get_temp	= mlxsw_thermal_gearbox_temp_get,
+	.get_trip_type	= mlxsw_thermal_module_trip_type_get,
+	.get_trip_temp	= mlxsw_thermal_module_trip_temp_get,
+	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
+	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
+	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
+};
+
+static struct thermal_zone_params mlxsw_thermal_gearbox_params = {
+	.governor_name = "user_space",
+};
+
 static int mlxsw_thermal_get_max_state(struct thermal_cooling_device *cdev,
 				       unsigned long *p_state)
 {
@@ -779,6 +821,92 @@ mlxsw_thermal_modules_fini(struct mlxsw_thermal *thermal)
 	kfree(thermal->tz_module_arr);
 }
 
+static int
+mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
+{
+	char tz_name[MLXSW_THERMAL_ZONE_MAX_NAME];
+
+	snprintf(tz_name, sizeof(tz_name), "mlxsw-gearbox%d",
+		 gearbox_tz->module + 1);
+	gearbox_tz->tzdev = thermal_zone_device_register(tz_name,
+						MLXSW_THERMAL_NUM_TRIPS,
+						MLXSW_THERMAL_TRIP_MASK,
+						gearbox_tz,
+						&mlxsw_thermal_gearbox_ops,
+						&mlxsw_thermal_gearbox_params,
+						0, 0);
+	if (IS_ERR(gearbox_tz->tzdev))
+		return PTR_ERR(gearbox_tz->tzdev);
+
+	return 0;
+}
+
+static void
+mlxsw_thermal_gearbox_tz_fini(struct mlxsw_thermal_module *gearbox_tz)
+{
+	thermal_zone_device_unregister(gearbox_tz->tzdev);
+}
+
+static int
+mlxsw_thermal_gearboxes_init(struct device *dev, struct mlxsw_core *core,
+			     struct mlxsw_thermal *thermal)
+{
+	struct mlxsw_thermal_module *gearbox_tz;
+	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
+	int i;
+	int err;
+
+	if (!mlxsw_core_res_query_enabled(core))
+		return 0;
+
+	mlxsw_reg_mgpir_pack(mgpir_pl);
+	err = mlxsw_reg_query(core, MLXSW_REG(mgpir), mgpir_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mgpir_unpack(mgpir_pl, &thermal->tz_gearbox_num, NULL, NULL);
+	if (!thermal->tz_gearbox_num)
+		return 0;
+
+	thermal->tz_gearbox_arr = kcalloc(thermal->tz_gearbox_num,
+					  sizeof(*thermal->tz_gearbox_arr),
+					  GFP_KERNEL);
+	if (!thermal->tz_gearbox_arr)
+		return -ENOMEM;
+
+	for (i = 0; i < thermal->tz_gearbox_num; i++) {
+		gearbox_tz = &thermal->tz_gearbox_arr[i];
+		memcpy(gearbox_tz->trips, default_thermal_trips,
+		       sizeof(thermal->trips));
+		gearbox_tz->module = i;
+		gearbox_tz->parent = thermal;
+		err = mlxsw_thermal_gearbox_tz_init(gearbox_tz);
+		if (err)
+			goto err_unreg_tz_gearbox;
+	}
+
+	return 0;
+
+err_unreg_tz_gearbox:
+	for (i--; i >= 0; i--)
+		mlxsw_thermal_gearbox_tz_fini(&thermal->tz_gearbox_arr[i]);
+	kfree(thermal->tz_gearbox_arr);
+	return err;
+}
+
+static void
+mlxsw_thermal_gearboxes_fini(struct mlxsw_thermal *thermal)
+{
+	int i;
+
+	if (!mlxsw_core_res_query_enabled(thermal->core))
+		return;
+
+	for (i = thermal->tz_gearbox_num - 1; i >= 0; i--)
+		mlxsw_thermal_gearbox_tz_fini(&thermal->tz_gearbox_arr[i]);
+	kfree(thermal->tz_gearbox_arr);
+}
+
 int mlxsw_thermal_init(struct mlxsw_core *core,
 		       const struct mlxsw_bus_info *bus_info,
 		       struct mlxsw_thermal **p_thermal)
@@ -869,10 +997,16 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 	if (err)
 		goto err_unreg_tzdev;
 
+	err = mlxsw_thermal_gearboxes_init(dev, core, thermal);
+	if (err)
+		goto err_unreg_modules_tzdev;
+
 	thermal->mode = THERMAL_DEVICE_ENABLED;
 	*p_thermal = thermal;
 	return 0;
 
+err_unreg_modules_tzdev:
+	mlxsw_thermal_modules_fini(thermal);
 err_unreg_tzdev:
 	if (thermal->tzdev) {
 		thermal_zone_device_unregister(thermal->tzdev);
@@ -891,6 +1025,7 @@ void mlxsw_thermal_fini(struct mlxsw_thermal *thermal)
 {
 	int i;
 
+	mlxsw_thermal_gearboxes_fini(thermal);
 	mlxsw_thermal_modules_fini(thermal);
 	if (thermal->tzdev) {
 		thermal_zone_device_unregister(thermal->tzdev);
-- 
2.20.1


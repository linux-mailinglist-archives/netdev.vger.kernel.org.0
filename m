Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93DDFCCEFF
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 08:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfJFGfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 02:35:22 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41523 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726109AbfJFGfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 02:35:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9E4E120FE3;
        Sun,  6 Oct 2019 02:35:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 06 Oct 2019 02:35:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=e/TEVNxfwy5cwFgVZ8Wmu0H+alU6mlRFtEFktxw4FiY=; b=hYCgGwip
        LvDxQthDbH1h7/KUtMY6iG6MIhafjI6d9Jf7BEu3kph5zVwCQP3oMPTLDxxJAD/7
        mHk1vk1MZTCAILH6PT38P0bQ7YJu++1QO/vz3mgNojr+GooXMufstlUash5odoND
        xWHDiSrnD4t30UveCDs356bF6MX7eeM7lJcGs0J7m8f0d1utSojr1/7hknL8vBWr
        LdpnZLnS/E8yWxSkn0qnfo7QC9ivLLOjB8qChBFPBbDoDK8z/WI38UjsU2jWwCBB
        ZaT31ZGigaoaAXOTS1vd4joiy59AWUBtk22cXkbMKeVQ+LhPjaYh5+AkR/Yhx7Bc
        LEW+IrrQw7FdXg==
X-ME-Sender: <xms:KIuZXY3tQ0G96qfKGsjoab7cw-J7R_of66xQvBn0y4O-IWA4v8qGSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheeggdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:KIuZXcceu-ZmsBNmSnI1mmvNc27Obe2Lb0oosxsKKuw5XqZL_LRFXQ>
    <xmx:KIuZXZYixhxLMjqzW1hfNFAo7Q0ljTMZyRFDaVr4RmdjbM88fOJ55Q>
    <xmx:KIuZXRX873W3uLRVf6O7jKfVLwweV17-NwHDjQ__uxzx7RjgxM1h3w>
    <xmx:KIuZXU2OLyx0L-9faHk3mcJvkYjEVZXqgvM6G2-zw-1jodvS6RGYqA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 545E5D6005A;
        Sun,  6 Oct 2019 02:35:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/5] mlxsw: hwmon: Provide optimization for QSFP modules number detection
Date:   Sun,  6 Oct 2019 09:34:49 +0300
Message-Id: <20191006063452.7666-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191006063452.7666-1-idosch@idosch.org>
References: <20191006063452.7666-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Use new field "num_of_modules" of MGPIR register for "hwmon" interface
in order to get the number of modules supported by system directly from
the system configuration, instead of getting it from port to module
mapping info.

Reading this info through MGPIR register is faster and does not depend
on possible dynamic re-configuration of ports.
In case of port dynamic re-configuration some modules can logically
"disappear" as a result of port split and un-spilt operations, which
can cause missing of some modules, in case this info is taken from port
to module mapping info.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 64 +++++++++----------
 1 file changed, 29 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 69c192839bf9..9bf8da5f6daf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -41,7 +41,7 @@ struct mlxsw_hwmon {
 	struct mlxsw_hwmon_attr hwmon_attrs[MLXSW_HWMON_ATTR_COUNT];
 	unsigned int attrs_count;
 	u8 sensor_count;
-	u8 module_sensor_count;
+	u8 module_sensor_max;
 };
 
 static ssize_t mlxsw_hwmon_temp_show(struct device *dev,
@@ -56,7 +56,7 @@ static ssize_t mlxsw_hwmon_temp_show(struct device *dev,
 	int err;
 
 	index = mlxsw_hwmon_get_attr_index(mlwsw_hwmon_attr->type_index,
-					   mlxsw_hwmon->module_sensor_count);
+					   mlxsw_hwmon->module_sensor_max);
 	mlxsw_reg_mtmp_pack(mtmp_pl, index, false, false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
@@ -79,7 +79,7 @@ static ssize_t mlxsw_hwmon_temp_max_show(struct device *dev,
 	int err;
 
 	index = mlxsw_hwmon_get_attr_index(mlwsw_hwmon_attr->type_index,
-					   mlxsw_hwmon->module_sensor_count);
+					   mlxsw_hwmon->module_sensor_max);
 	mlxsw_reg_mtmp_pack(mtmp_pl, index, false, false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
@@ -109,7 +109,7 @@ static ssize_t mlxsw_hwmon_temp_rst_store(struct device *dev,
 		return -EINVAL;
 
 	index = mlxsw_hwmon_get_attr_index(mlwsw_hwmon_attr->type_index,
-					   mlxsw_hwmon->module_sensor_count);
+					   mlxsw_hwmon->module_sensor_max);
 	mlxsw_reg_mtmp_pack(mtmp_pl, index, true, true);
 	err = mlxsw_reg_write(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
@@ -336,7 +336,7 @@ mlxsw_hwmon_gbox_temp_label_show(struct device *dev,
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
 	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
 	int index = mlwsw_hwmon_attr->type_index -
-		    mlxsw_hwmon->module_sensor_count + 1;
+		    mlxsw_hwmon->module_sensor_max + 1;
 
 	return sprintf(buf, "gearbox %03u\n", index);
 }
@@ -528,51 +528,45 @@ static int mlxsw_hwmon_fans_init(struct mlxsw_hwmon *mlxsw_hwmon)
 
 static int mlxsw_hwmon_module_init(struct mlxsw_hwmon *mlxsw_hwmon)
 {
-	unsigned int module_count = mlxsw_core_max_ports(mlxsw_hwmon->core);
-	char pmlp_pl[MLXSW_REG_PMLP_LEN] = {0};
-	int i, index;
-	u8 width;
-	int err;
+	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
+	u8 module_sensor_max;
+	int i, err;
 
 	if (!mlxsw_core_res_query_enabled(mlxsw_hwmon->core))
 		return 0;
 
+	mlxsw_reg_mgpir_pack(mgpir_pl);
+	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mgpir), mgpir_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mgpir_unpack(mgpir_pl, NULL, NULL, NULL,
+			       &module_sensor_max);
+
 	/* Add extra attributes for module temperature. Sensor index is
 	 * assigned to sensor_count value, while all indexed before
 	 * sensor_count are already utilized by the sensors connected through
 	 * mtmp register by mlxsw_hwmon_temp_init().
 	 */
-	index = mlxsw_hwmon->sensor_count;
-	for (i = 1; i < module_count; i++) {
-		mlxsw_reg_pmlp_pack(pmlp_pl, i);
-		err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(pmlp),
-				      pmlp_pl);
-		if (err) {
-			dev_err(mlxsw_hwmon->bus_info->dev, "Failed to read module index %d\n",
-				i);
-			return err;
-		}
-		width = mlxsw_reg_pmlp_width_get(pmlp_pl);
-		if (!width)
-			continue;
+	mlxsw_hwmon->module_sensor_max = mlxsw_hwmon->sensor_count +
+					 module_sensor_max;
+	for (i = mlxsw_hwmon->sensor_count;
+	     i < mlxsw_hwmon->module_sensor_max; i++) {
 		mlxsw_hwmon_attr_add(mlxsw_hwmon,
-				     MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE, index,
-				     index);
+				     MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE, i, i);
 		mlxsw_hwmon_attr_add(mlxsw_hwmon,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE_FAULT,
-				     index, index);
+				     i, i);
 		mlxsw_hwmon_attr_add(mlxsw_hwmon,
-				     MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE_CRIT,
-				     index, index);
+				     MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE_CRIT, i,
+				     i);
 		mlxsw_hwmon_attr_add(mlxsw_hwmon,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE_EMERG,
-				     index, index);
+				     i, i);
 		mlxsw_hwmon_attr_add(mlxsw_hwmon,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE_LABEL,
-				     index, index);
-		index++;
+				     i, i);
 	}
-	mlxsw_hwmon->module_sensor_count = index;
 
 	return 0;
 }
@@ -594,10 +588,10 @@ static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon *mlxsw_hwmon)
 	if (!gbox_num)
 		return 0;
 
-	index = mlxsw_hwmon->module_sensor_count;
-	max_index = mlxsw_hwmon->module_sensor_count + gbox_num;
+	index = mlxsw_hwmon->module_sensor_max;
+	max_index = mlxsw_hwmon->module_sensor_max + gbox_num;
 	while (index < max_index) {
-		sensor_index = index % mlxsw_hwmon->module_sensor_count +
+		sensor_index = index % mlxsw_hwmon->module_sensor_max +
 			       MLXSW_REG_MTMP_GBOX_INDEX_MIN;
 		mlxsw_reg_mtmp_pack(mtmp_pl, sensor_index, true, true);
 		err = mlxsw_reg_write(mlxsw_hwmon->core,
-- 
2.21.0


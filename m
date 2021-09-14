Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9270340A695
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 08:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240141AbhINGP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 02:15:56 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33223 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240099AbhINGPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 02:15:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 945005C0174;
        Tue, 14 Sep 2021 02:14:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Sep 2021 02:14:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Uu/kRzyUQwYwLf59aPJ2OQFO0IcI2bmiPdWJcmVNE9k=; b=OPdqNqMD
        rOgLyHpfOGGNLiuG4NYZUENh8XBMWcRfsh1kETiGxfrqd2M0rkhX18inySrL7xys
        6W7RjXPElddko4S90Cjua5RQEyLZraQ8/t/o0oOHtLcHWyJaapI/sW1JPKeBqNNK
        4WIQyZHxmw9TXCaJAy7fbbj0nGfx+8mq0C4hX2j08mhKOy2BPznDnRSSnELcLgHN
        D+a4VvgEU5Sn910XlXbVq/UUZfpmw2Bg9qyCZLcW0O7ABRGY8AE06+iT0Ce1tX1u
        k6TWG9fhmlaYOqZKS9ld6kIK4b5ej2BjExwx3rP0RvrWrG+Z6/X6rHeWE6ufpSLs
        /Ih3O+FC3yubUA==
X-ME-Sender: <xms:yD1AYUhvNmDnn0OkWpViZKVYxWFSg_qr36HKrXcGlp5jxmXqoRMWvg>
    <xme:yD1AYdAtfi0lk-ReSw0nv_-87dhxa9VchUZ6TQ753nnVHOV4UJpJ9ZGQHqjqKTWWp
    98N3afaPTrTPk0>
X-ME-Received: <xmr:yD1AYcG5Ak9oQy4MsLxVlAah-Nk1JrqhWak9pEM_b4xJbh-_v4Kr-8ho7yhKkmUKurgtWj-9FEboA7gVcDltUkW5FN_UAIQEIg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpeefnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:yD1AYVTp2_e2Je41UC-mgcM9K9WttV-Z5_1bKczgHnmyps-AYImckA>
    <xmx:yD1AYRyV90nvLQuYGkGkH4iOYr_Yxw4-pIbndOT1FFU1RqQLXEgQcQ>
    <xmx:yD1AYT5BGC0_g3N5cwoy_CVutslQFzk_Ju4epTwQzNGLMGX7PBdVDQ>
    <xmx:yD1AYZ9QRLZ_6lK_vhFIzXWwe7HmO0vQFAI8Nx159yG2P9yutMy2bg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 02:14:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/8] mlxsw: spectrum: Use PMTDB register to obtain split info
Date:   Tue, 14 Sep 2021 09:13:29 +0300
Message-Id: <20210914061330.226000-8-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914061330.226000-1-idosch@idosch.org>
References: <20210914061330.226000-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Newly introduced PMTDB register is there to provide all needed info
about particular requested port split configuration. Use it instead of
figuring the info out manually in the driver.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  38 ----
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   1 -
 .../net/ethernet/mellanox/mlxsw/resources.h   |   6 -
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 186 +++++++-----------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   4 +-
 5 files changed, 76 insertions(+), 159 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index f080fab3de2b..98420db90ea1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2944,44 +2944,6 @@ bool mlxsw_core_is_initialized(const struct mlxsw_core *mlxsw_core)
 	return mlxsw_core->is_initialized;
 }
 
-int mlxsw_core_module_max_width(struct mlxsw_core *mlxsw_core, u8 module)
-{
-	enum mlxsw_reg_pmtm_module_type module_type;
-	char pmtm_pl[MLXSW_REG_PMTM_LEN];
-	int err;
-
-	mlxsw_reg_pmtm_pack(pmtm_pl, module);
-	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(pmtm), pmtm_pl);
-	if (err)
-		return err;
-	mlxsw_reg_pmtm_unpack(pmtm_pl, &module_type);
-
-	/* Here we need to get the module width according to the module type. */
-
-	switch (module_type) {
-	case MLXSW_REG_PMTM_MODULE_TYPE_C2C8X:
-	case MLXSW_REG_PMTM_MODULE_TYPE_QSFP_DD:
-	case MLXSW_REG_PMTM_MODULE_TYPE_OSFP:
-		return 8;
-	case MLXSW_REG_PMTM_MODULE_TYPE_C2C4X:
-	case MLXSW_REG_PMTM_MODULE_TYPE_BP_4X:
-	case MLXSW_REG_PMTM_MODULE_TYPE_QSFP:
-		return 4;
-	case MLXSW_REG_PMTM_MODULE_TYPE_C2C2X:
-	case MLXSW_REG_PMTM_MODULE_TYPE_BP_2X:
-	case MLXSW_REG_PMTM_MODULE_TYPE_SFP_DD:
-	case MLXSW_REG_PMTM_MODULE_TYPE_DSFP:
-		return 2;
-	case MLXSW_REG_PMTM_MODULE_TYPE_C2C1X:
-	case MLXSW_REG_PMTM_MODULE_TYPE_BP_1X:
-	case MLXSW_REG_PMTM_MODULE_TYPE_SFP:
-		return 1;
-	default:
-		return -EINVAL;
-	}
-}
-EXPORT_SYMBOL(mlxsw_core_module_max_width);
-
 static void mlxsw_core_buf_dump_dbg(struct mlxsw_core *mlxsw_core,
 				    const char *buf, size_t size)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 80712dc803d0..d21981cc04ca 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -250,7 +250,6 @@ mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 bool mlxsw_core_port_is_xm(const struct mlxsw_core *mlxsw_core, u8 local_port);
 struct mlxsw_env *mlxsw_core_env(const struct mlxsw_core *mlxsw_core);
 bool mlxsw_core_is_initialized(const struct mlxsw_core *mlxsw_core);
-int mlxsw_core_module_max_width(struct mlxsw_core *mlxsw_core, u8 module);
 
 int mlxsw_core_schedule_dw(struct delayed_work *dwork, unsigned long delay);
 bool mlxsw_core_schedule_work(struct work_struct *work);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/resources.h b/drivers/net/ethernet/mellanox/mlxsw/resources.h
index a56c9e19a390..a1512be77867 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/resources.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/resources.h
@@ -25,9 +25,6 @@ enum mlxsw_res_id {
 	MLXSW_RES_ID_MAX_SYSTEM_PORT,
 	MLXSW_RES_ID_MAX_LAG,
 	MLXSW_RES_ID_MAX_LAG_MEMBERS,
-	MLXSW_RES_ID_LOCAL_PORTS_IN_1X,
-	MLXSW_RES_ID_LOCAL_PORTS_IN_2X,
-	MLXSW_RES_ID_LOCAL_PORTS_IN_4X,
 	MLXSW_RES_ID_GUARANTEED_SHARED_BUFFER,
 	MLXSW_RES_ID_CELL_SIZE,
 	MLXSW_RES_ID_MAX_HEADROOM_SIZE,
@@ -84,9 +81,6 @@ static u16 mlxsw_res_ids[] = {
 	[MLXSW_RES_ID_MAX_SYSTEM_PORT] = 0x2502,
 	[MLXSW_RES_ID_MAX_LAG] = 0x2520,
 	[MLXSW_RES_ID_MAX_LAG_MEMBERS] = 0x2521,
-	[MLXSW_RES_ID_LOCAL_PORTS_IN_1X] = 0x2610,
-	[MLXSW_RES_ID_LOCAL_PORTS_IN_2X] = 0x2611,
-	[MLXSW_RES_ID_LOCAL_PORTS_IN_4X] = 0x2612,
 	[MLXSW_RES_ID_GUARANTEED_SHARED_BUFFER] = 0x2805,	/* Bytes */
 	[MLXSW_RES_ID_CELL_SIZE] = 0x2803,	/* Bytes */
 	[MLXSW_RES_ID_MAX_HEADROOM_SIZE] = 0x2811,	/* Bytes */
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c0e52afe1afd..9cbc893c2545 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -529,6 +529,7 @@ mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 
 	port_mapping->module = module;
 	port_mapping->width = width;
+	port_mapping->module_width = width;
 	port_mapping->lane = mlxsw_reg_pmlp_tx_lane_get(pmlp_pl, 0);
 	return 0;
 }
@@ -1459,11 +1460,10 @@ static int mlxsw_sp_port_label_info_get(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
-				u8 split_base_local_port,
+				bool split,
 				struct mlxsw_sp_port_mapping *port_mapping)
 {
 	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
-	bool split = !!split_base_local_port;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	u32 lanes = port_mapping->width;
 	u8 split_port_subnumber;
@@ -1519,7 +1519,6 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	mlxsw_sp_port->local_port = local_port;
 	mlxsw_sp_port->pvid = MLXSW_SP_DEFAULT_VID;
 	mlxsw_sp_port->split = split;
-	mlxsw_sp_port->split_base_local_port = split_base_local_port;
 	mlxsw_sp_port->mapping = *port_mapping;
 	mlxsw_sp_port->link.autoneg = 1;
 	INIT_LIST_HEAD(&mlxsw_sp_port->vlans_list);
@@ -1817,8 +1816,15 @@ static void mlxsw_sp_cpu_port_remove(struct mlxsw_sp *mlxsw_sp)
 	kfree(mlxsw_sp_port);
 }
 
+static bool mlxsw_sp_local_port_valid(u8 local_port)
+{
+	return local_port != MLXSW_PORT_CPU_PORT;
+}
+
 static bool mlxsw_sp_port_created(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 {
+	if (!mlxsw_sp_local_port_valid(local_port))
+		return false;
 	return mlxsw_sp->ports[local_port] != NULL;
 }
 
@@ -1855,7 +1861,7 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 		port_mapping = mlxsw_sp->port_mapping[i];
 		if (!port_mapping)
 			continue;
-		err = mlxsw_sp_port_create(mlxsw_sp, i, 0, port_mapping);
+		err = mlxsw_sp_port_create(mlxsw_sp, i, false, port_mapping);
 		if (err)
 			goto err_port_create;
 	}
@@ -1922,17 +1928,10 @@ static void mlxsw_sp_port_module_info_fini(struct mlxsw_sp *mlxsw_sp)
 	kfree(mlxsw_sp->port_mapping);
 }
 
-static u8 mlxsw_sp_cluster_base_port_get(u8 local_port, unsigned int max_width)
-{
-	u8 offset = (local_port - 1) % max_width;
-
-	return local_port - offset;
-}
-
 static int
-mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp, u8 base_port,
+mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp,
 			   struct mlxsw_sp_port_mapping *port_mapping,
-			   unsigned int count, u8 offset)
+			   unsigned int count, const char *pmtdb_pl)
 {
 	struct mlxsw_sp_port_mapping split_port_mapping;
 	int err, i;
@@ -1940,8 +1939,13 @@ mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp, u8 base_port,
 	split_port_mapping = *port_mapping;
 	split_port_mapping.width /= count;
 	for (i = 0; i < count; i++) {
-		err = mlxsw_sp_port_create(mlxsw_sp, base_port + i * offset,
-					   base_port, &split_port_mapping);
+		u8 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
+
+		if (!mlxsw_sp_local_port_valid(s_local_port))
+			continue;
+
+		err = mlxsw_sp_port_create(mlxsw_sp, s_local_port,
+					   true, &split_port_mapping);
 		if (err)
 			goto err_port_create;
 		split_port_mapping.lane += split_port_mapping.width;
@@ -1950,49 +1954,34 @@ mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp, u8 base_port,
 	return 0;
 
 err_port_create:
-	for (i--; i >= 0; i--)
-		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i * offset))
-			mlxsw_sp_port_remove(mlxsw_sp, base_port + i * offset);
+	for (i--; i >= 0; i--) {
+		u8 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
+
+		if (mlxsw_sp_port_created(mlxsw_sp, s_local_port))
+			mlxsw_sp_port_remove(mlxsw_sp, s_local_port);
+	}
 	return err;
 }
 
 static void mlxsw_sp_port_unsplit_create(struct mlxsw_sp *mlxsw_sp,
-					 u8 base_port,
-					 unsigned int count, u8 offset)
+					 unsigned int count,
+					 const char *pmtdb_pl)
 {
 	struct mlxsw_sp_port_mapping *port_mapping;
 	int i;
 
 	/* Go over original unsplit ports in the gap and recreate them. */
-	for (i = 0; i < count * offset; i++) {
-		port_mapping = mlxsw_sp->port_mapping[base_port + i];
-		if (!port_mapping)
+	for (i = 0; i < count; i++) {
+		u8 local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
+
+		port_mapping = mlxsw_sp->port_mapping[local_port];
+		if (!port_mapping || !mlxsw_sp_local_port_valid(local_port))
 			continue;
-		mlxsw_sp_port_create(mlxsw_sp, base_port + i, 0, port_mapping);
+		mlxsw_sp_port_create(mlxsw_sp, local_port,
+				     false, port_mapping);
 	}
 }
 
-static int mlxsw_sp_local_ports_offset(struct mlxsw_core *mlxsw_core,
-				       unsigned int count,
-				       unsigned int max_width)
-{
-	enum mlxsw_res_id local_ports_in_x_res_id;
-	int split_width = max_width / count;
-
-	if (split_width == 1)
-		local_ports_in_x_res_id = MLXSW_RES_ID_LOCAL_PORTS_IN_1X;
-	else if (split_width == 2)
-		local_ports_in_x_res_id = MLXSW_RES_ID_LOCAL_PORTS_IN_2X;
-	else if (split_width == 4)
-		local_ports_in_x_res_id = MLXSW_RES_ID_LOCAL_PORTS_IN_4X;
-	else
-		return -EINVAL;
-
-	if (!mlxsw_core_res_valid(mlxsw_core, local_ports_in_x_res_id))
-		return -EINVAL;
-	return mlxsw_core_res_get(mlxsw_core, local_ports_in_x_res_id);
-}
-
 static struct mlxsw_sp_port *
 mlxsw_sp_port_get_by_local_port(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 {
@@ -2008,9 +1997,8 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	struct mlxsw_sp_port_mapping port_mapping;
 	struct mlxsw_sp_port *mlxsw_sp_port;
-	int max_width;
-	u8 base_port;
-	int offset;
+	enum mlxsw_reg_pmtdb_status status;
+	char pmtdb_pl[MLXSW_REG_PMTDB_LEN];
 	int i;
 	int err;
 
@@ -2022,57 +2010,37 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 		return -EINVAL;
 	}
 
-	max_width = mlxsw_core_module_max_width(mlxsw_core,
-						mlxsw_sp_port->mapping.module);
-	if (max_width < 0) {
-		netdev_err(mlxsw_sp_port->dev, "Cannot get max width of port module\n");
-		NL_SET_ERR_MSG_MOD(extack, "Cannot get max width of port module");
-		return max_width;
+	if (mlxsw_sp_port->split) {
+		NL_SET_ERR_MSG_MOD(extack, "Port is already split");
+		return -EINVAL;
 	}
 
-	/* Split port with non-max cannot be split. */
-	if (mlxsw_sp_port->mapping.width != max_width) {
-		netdev_err(mlxsw_sp_port->dev, "Port cannot be split\n");
-		NL_SET_ERR_MSG_MOD(extack, "Port cannot be split");
-		return -EINVAL;
+	mlxsw_reg_pmtdb_pack(pmtdb_pl, 0, mlxsw_sp_port->mapping.module,
+			     mlxsw_sp_port->mapping.module_width / count,
+			     count);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(pmtdb), pmtdb_pl);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to query split info");
+		return err;
 	}
 
-	offset = mlxsw_sp_local_ports_offset(mlxsw_core, count, max_width);
-	if (offset < 0) {
-		netdev_err(mlxsw_sp_port->dev, "Cannot obtain local port offset\n");
-		NL_SET_ERR_MSG_MOD(extack, "Cannot obtain local port offset");
+	status = mlxsw_reg_pmtdb_status_get(pmtdb_pl);
+	if (status != MLXSW_REG_PMTDB_STATUS_SUCCESS) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported split configuration");
 		return -EINVAL;
 	}
 
-	/* Only in case max split is being done, the local port and
-	 * base port may differ.
-	 */
-	base_port = count == max_width ?
-		    mlxsw_sp_cluster_base_port_get(local_port, max_width) :
-		    local_port;
+	port_mapping = mlxsw_sp_port->mapping;
 
-	for (i = 0; i < count * offset; i++) {
-		/* Expect base port to exist and also the one in the middle in
-		 * case of maximal split count.
-		 */
-		if (i == 0 || (count == max_width && i == count / 2))
-			continue;
+	for (i = 0; i < count; i++) {
+		u8 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
 
-		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i)) {
-			netdev_err(mlxsw_sp_port->dev, "Invalid split configuration\n");
-			NL_SET_ERR_MSG_MOD(extack, "Invalid split configuration");
-			return -EINVAL;
-		}
+		if (mlxsw_sp_port_created(mlxsw_sp, s_local_port))
+			mlxsw_sp_port_remove(mlxsw_sp, s_local_port);
 	}
 
-	port_mapping = mlxsw_sp_port->mapping;
-
-	for (i = 0; i < count; i++)
-		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i * offset))
-			mlxsw_sp_port_remove(mlxsw_sp, base_port + i * offset);
-
-	err = mlxsw_sp_port_split_create(mlxsw_sp, base_port, &port_mapping,
-					 count, offset);
+	err = mlxsw_sp_port_split_create(mlxsw_sp, &port_mapping,
+					 count, pmtdb_pl);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to create split ports\n");
 		goto err_port_split_create;
@@ -2081,7 +2049,7 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 	return 0;
 
 err_port_split_create:
-	mlxsw_sp_port_unsplit_create(mlxsw_sp, base_port, count, offset);
+	mlxsw_sp_port_unsplit_create(mlxsw_sp, count, pmtdb_pl);
 	return err;
 }
 
@@ -2090,11 +2058,10 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	struct mlxsw_sp_port *mlxsw_sp_port;
+	char pmtdb_pl[MLXSW_REG_PMTDB_LEN];
 	unsigned int count;
-	int max_width;
-	u8 base_port;
-	int offset;
 	int i;
+	int err;
 
 	mlxsw_sp_port = mlxsw_sp_port_get_by_local_port(mlxsw_sp, local_port);
 	if (!mlxsw_sp_port) {
@@ -2105,35 +2072,30 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 	}
 
 	if (!mlxsw_sp_port->split) {
-		netdev_err(mlxsw_sp_port->dev, "Port was not split\n");
 		NL_SET_ERR_MSG_MOD(extack, "Port was not split");
 		return -EINVAL;
 	}
 
-	max_width = mlxsw_core_module_max_width(mlxsw_core,
-						mlxsw_sp_port->mapping.module);
-	if (max_width < 0) {
-		netdev_err(mlxsw_sp_port->dev, "Cannot get max width of port module\n");
-		NL_SET_ERR_MSG_MOD(extack, "Cannot get max width of port module");
-		return max_width;
-	}
-
-	count = max_width / mlxsw_sp_port->mapping.width;
+	count = mlxsw_sp_port->mapping.module_width /
+		mlxsw_sp_port->mapping.width;
 
-	offset = mlxsw_sp_local_ports_offset(mlxsw_core, count, max_width);
-	if (WARN_ON(offset < 0)) {
-		netdev_err(mlxsw_sp_port->dev, "Cannot obtain local port offset\n");
-		NL_SET_ERR_MSG_MOD(extack, "Cannot obtain local port offset");
-		return -EINVAL;
+	mlxsw_reg_pmtdb_pack(pmtdb_pl, 0, mlxsw_sp_port->mapping.module,
+			     mlxsw_sp_port->mapping.module_width / count,
+			     count);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(pmtdb), pmtdb_pl);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to query split info");
+		return err;
 	}
 
-	base_port = mlxsw_sp_port->split_base_local_port;
+	for (i = 0; i < count; i++) {
+		u8 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
 
-	for (i = 0; i < count; i++)
-		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i * offset))
-			mlxsw_sp_port_remove(mlxsw_sp, base_port + i * offset);
+		if (mlxsw_sp_port_created(mlxsw_sp, s_local_port))
+			mlxsw_sp_port_remove(mlxsw_sp, s_local_port);
+	}
 
-	mlxsw_sp_port_unsplit_create(mlxsw_sp, base_port, count, offset);
+	mlxsw_sp_port_unsplit_create(mlxsw_sp, count, pmtdb_pl);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 3a43cba6d23c..83ab1ea92d31 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -144,7 +144,8 @@ struct mlxsw_sp_mall_entry;
 
 struct mlxsw_sp_port_mapping {
 	u8 module;
-	u8 width;
+	u8 width; /* Number of lanes used by the port */
+	u8 module_width; /* Number of lanes in the module (static) */
 	u8 lane;
 };
 
@@ -345,7 +346,6 @@ struct mlxsw_sp_port {
 		u16 egr_types;
 		struct mlxsw_sp_ptp_port_stats stats;
 	} ptp;
-	u8 split_base_local_port;
 	int max_mtu;
 	u32 max_speed;
 	struct mlxsw_sp_hdroom *hdroom;
-- 
2.31.1


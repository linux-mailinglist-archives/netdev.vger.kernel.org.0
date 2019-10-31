Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84FE8EACB4
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfJaJmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:42:49 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34159 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726864AbfJaJmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:42:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C297D210DC;
        Thu, 31 Oct 2019 05:42:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:42:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=QZLsV4XtNPdAjPWMk24KEIl3Al5a6EJmke/88g05wl8=; b=jxPwu1sn
        fEJBRCDNdBunf+TapSDEDzM0lPgFhjZaDr+Jh1FdfLQdZc1wVX1pmWOwz0hxwMV/
        +Y+TUM+eVpDNMXRDEm3LhQq+DDltLp5Q5UujqHfFH5NuJ2VCPhAHwXzVOwmhaAxo
        oUsuvWYLB48HX2wGq9lqEplDk0qMzV5FgDlsBm5qYKSzNA0OJRAMqNJ7/o4yoSiV
        2pK21oN5w6YS10LcYOMDn5kmegO/VsSkk/822NImAbD6rkZKtbieExmYxXa/mG1z
        4P7pggRFdHs4THpS7kDJlUwY47kfOIupJ46ta9NE59QpQ8SVgXKemNaSJHZ6sKyV
        Mc2BActCkA0srA==
X-ME-Sender: <xms:l6y6XXp1mh_px6LyG54f2HqBy7L9DnGdIu0xf3nG07TNG7YYAFCZUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:l6y6XV6W7PM-E_Frfg9H-kTFpz71CZ-BNk5ChHo440D9k6VvW9yqGA>
    <xmx:l6y6XfNmJ08KaqV9D02GeP552xiTLHJJ-SJs--56b5q6sZZH7vMl6w>
    <xmx:l6y6XfMwSMtucu9wqEwHsK6QWzDtVnZCCUUsfEbbzO_aYhV74HdR1g>
    <xmx:l6y6XQ5kzAKXvzMRDLqfUGb6zJbTThv9lDWHL6zEPua1ZJz4dsCZ6Q>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1798D8006A;
        Thu, 31 Oct 2019 05:42:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/16] mlxsw: spectrum: Use PMTM register to get max module width
Date:   Thu, 31 Oct 2019 11:42:08 +0200
Message-Id: <20191031094221.17526-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031094221.17526-1-idosch@idosch.org>
References: <20191031094221.17526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently the max module width is hard-coded according to ASIC type.
That is not entirely correct, as the max module width might differ
per-board. Use PMTM register to query FW for maximal width of a module.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 29 ++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  1 +
 drivers/net/ethernet/mellanox/mlxsw/port.h    |  2 -
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 54 +++++++++++++------
 4 files changed, 67 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 2b59f84b14f9..235d1990c127 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2017,6 +2017,35 @@ mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_core_port_devlink_port_get);
 
+int mlxsw_core_module_max_width(struct mlxsw_core *mlxsw_core, u8 module)
+{
+	enum mlxsw_reg_pmtm_module_type module_type;
+	char pmtm_pl[MLXSW_REG_PMTM_LEN];
+	int err;
+
+	mlxsw_reg_pmtm_pack(pmtm_pl, module);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(pmtm), pmtm_pl);
+	if (err)
+		return err;
+	mlxsw_reg_pmtm_unpack(pmtm_pl, &module_type);
+
+	/* Here we need to get the module width according to the module type. */
+
+	switch (module_type) {
+	case MLXSW_REG_PMTM_MODULE_TYPE_BP_4X: /* fall through */
+	case MLXSW_REG_PMTM_MODULE_TYPE_BP_QSFP:
+		return 4;
+	case MLXSW_REG_PMTM_MODULE_TYPE_BP_2X:
+		return 2;
+	case MLXSW_REG_PMTM_MODULE_TYPE_BP_SFP: /* fall through */
+	case MLXSW_REG_PMTM_MODULE_TYPE_BP_1X:
+		return 1;
+	default:
+		return -EINVAL;
+	}
+}
+EXPORT_SYMBOL(mlxsw_core_module_max_width);
+
 static void mlxsw_core_buf_dump_dbg(struct mlxsw_core *mlxsw_core,
 				    const char *buf, size_t size)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index f25037074e2d..0d18bee6d140 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -200,6 +200,7 @@ enum devlink_port_type mlxsw_core_port_type_get(struct mlxsw_core *mlxsw_core,
 struct devlink_port *
 mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 				 u8 local_port);
+int mlxsw_core_module_max_width(struct mlxsw_core *mlxsw_core, u8 module);
 
 int mlxsw_core_schedule_dw(struct delayed_work *dwork, unsigned long delay);
 bool mlxsw_core_schedule_work(struct work_struct *work);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/port.h b/drivers/net/ethernet/mellanox/mlxsw/port.h
index a33eeef0b00c..741fd2989d12 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/port.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/port.h
@@ -24,8 +24,6 @@
 
 #define MLXSW_PORT_DONT_CARE		0xFF
 
-#define MLXSW_PORT_MODULE_MAX_WIDTH	4
-
 enum mlxsw_port_admin_status {
 	MLXSW_PORT_ADMIN_STATUS_UP = 1,
 	MLXSW_PORT_ADMIN_STATUS_DOWN = 2,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 97be4bc9a02f..149b2cc2b4fd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4038,17 +4038,18 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 	return err;
 }
 
-static u8 mlxsw_sp_cluster_base_port_get(u8 local_port)
+static u8 mlxsw_sp_cluster_base_port_get(u8 local_port, unsigned int max_width)
 {
-	u8 offset = (local_port - 1) % MLXSW_SP_PORTS_PER_CLUSTER_MAX;
+	u8 offset = (local_port - 1) % max_width;
 
 	return local_port - offset;
 }
 
 static int mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp, u8 base_port,
-				      u8 module, unsigned int count, u8 offset)
+				      u8 module, unsigned int count, u8 offset,
+				      unsigned int max_width)
 {
-	u8 width = MLXSW_PORT_MODULE_MAX_WIDTH / count;
+	u8 width = max_width / count;
 	int err, i;
 
 	for (i = 0; i < count; i++) {
@@ -4068,9 +4069,10 @@ static int mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp, u8 base_port,
 }
 
 static void mlxsw_sp_port_unsplit_create(struct mlxsw_sp *mlxsw_sp,
-					 u8 base_port, unsigned int count)
+					 u8 base_port, unsigned int count,
+					 unsigned int max_width)
 {
-	u8 local_port, module, width = MLXSW_PORT_MODULE_MAX_WIDTH;
+	u8 local_port, module, width = max_width;
 	int i;
 
 	/* Split by four means we need to re-create two ports, otherwise
@@ -4096,7 +4098,8 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	u8 local_ports_in_1x, local_ports_in_2x, offset;
 	struct mlxsw_sp_port *mlxsw_sp_port;
-	u8 module, cur_width, base_port;
+	u8 module, base_port;
+	int max_width;
 	int i;
 	int err;
 
@@ -4116,7 +4119,14 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 	}
 
 	module = mlxsw_sp_port->mapping.module;
-	cur_width = mlxsw_sp_port->mapping.width;
+
+	max_width = mlxsw_core_module_max_width(mlxsw_core,
+						mlxsw_sp_port->mapping.module);
+	if (max_width < 0) {
+		netdev_err(mlxsw_sp_port->dev, "Cannot get max width of port module\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot get max width of port module");
+		return max_width;
+	}
 
 	if (count != 2 && count != 4) {
 		netdev_err(mlxsw_sp_port->dev, "Port can only be split into 2 or 4 ports\n");
@@ -4124,7 +4134,8 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 		return -EINVAL;
 	}
 
-	if (cur_width != MLXSW_PORT_MODULE_MAX_WIDTH) {
+	/* Split port with non-max module width cannot be split. */
+	if (mlxsw_sp_port->mapping.width != max_width) {
 		netdev_err(mlxsw_sp_port->dev, "Port cannot be split further\n");
 		NL_SET_ERR_MSG_MOD(extack, "Port cannot be split further");
 		return -EINVAL;
@@ -4141,7 +4152,8 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 		}
 	} else {
 		offset = local_ports_in_1x;
-		base_port = mlxsw_sp_cluster_base_port_get(local_port);
+		base_port = mlxsw_sp_cluster_base_port_get(local_port,
+							   max_width);
 		if (mlxsw_sp->ports[base_port + 1] ||
 		    mlxsw_sp->ports[base_port + 3]) {
 			netdev_err(mlxsw_sp_port->dev, "Invalid split configuration\n");
@@ -4155,7 +4167,7 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 			mlxsw_sp_port_remove(mlxsw_sp, base_port + i * offset);
 
 	err = mlxsw_sp_port_split_create(mlxsw_sp, base_port, module, count,
-					 offset);
+					 offset, max_width);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to create split ports\n");
 		goto err_port_split_create;
@@ -4164,7 +4176,7 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 	return 0;
 
 err_port_split_create:
-	mlxsw_sp_port_unsplit_create(mlxsw_sp, base_port, count);
+	mlxsw_sp_port_unsplit_create(mlxsw_sp, base_port, count, max_width);
 	return err;
 }
 
@@ -4174,8 +4186,9 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	u8 local_ports_in_1x, local_ports_in_2x, offset;
 	struct mlxsw_sp_port *mlxsw_sp_port;
-	u8 cur_width, base_port;
 	unsigned int count;
+	int max_width;
+	u8 base_port;
 	int i;
 
 	if (!MLXSW_CORE_RES_VALID(mlxsw_core, LOCAL_PORTS_IN_1X) ||
@@ -4199,15 +4212,22 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 		return -EINVAL;
 	}
 
-	cur_width = mlxsw_sp_port->mapping.width;
-	count = cur_width == 1 ? 4 : 2;
+	max_width = mlxsw_core_module_max_width(mlxsw_core,
+						mlxsw_sp_port->mapping.module);
+	if (max_width < 0) {
+		netdev_err(mlxsw_sp_port->dev, "Cannot get max width of port module\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot get max width of port module");
+		return max_width;
+	}
+
+	count = max_width / mlxsw_sp_port->mapping.width;
 
 	if (count == 2)
 		offset = local_ports_in_2x;
 	else
 		offset = local_ports_in_1x;
 
-	base_port = mlxsw_sp_cluster_base_port_get(local_port);
+	base_port = mlxsw_sp_cluster_base_port_get(local_port, max_width);
 
 	/* Determine which ports to remove. */
 	if (count == 2 && local_port >= base_port + 2)
@@ -4217,7 +4237,7 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i * offset))
 			mlxsw_sp_port_remove(mlxsw_sp, base_port + i * offset);
 
-	mlxsw_sp_port_unsplit_create(mlxsw_sp, base_port, count);
+	mlxsw_sp_port_unsplit_create(mlxsw_sp, base_port, count, max_width);
 
 	return 0;
 }
-- 
2.21.0


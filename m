Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261481DCCA1
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 14:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgEUMMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 08:12:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51391 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727956AbgEUML7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 08:11:59 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EF5B25C007F;
        Thu, 21 May 2020 08:11:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 21 May 2020 08:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=moj7K6lbaYs+DmA0fTJYh5LbIo2P/m2+aHQuOYAIlKY=; b=YXXaMqyk
        YK9I4LgjPVIzD1GQCDw+v7Cqxs3jxxbyMbWo6EJoU8DLawLaR37C5/+8z0ZdcGI/
        vJfcaz7XCvDRXWEjhh9llFsiFsRkMqNXHmSiKirpa0bFWPIqj0SZGufWgC1SuAiS
        q0eGVEANMx5vDveoo0+SVnf45FTs54nQunERh0ChnR+IBUjZ9DKWt/K/Vxk0aput
        m+F/qCG0L+Q9FK+srGs+OOjBDCioG2OmRQWlu0POIAzPEy2k3I25juQtTbIBja8z
        seIXx2I93D11CFg4NAXLSm2j47qXRcngn09LGP5AybV+mn1HOVAViTgoeH3HEzTD
        Xf4AFdDSjY9q6w==
X-ME-Sender: <xms:DnDGXvhHcCwenTTlRlKHAmt9R63gg5geFWdVz7rOfv4SizRsvi322A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduuddggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:DnDGXsCQDX3ABkG0CeUXVL_9CzDoNrdJnQ2khilXJhY1YyqhNEvAtQ>
    <xmx:DnDGXvF5M1dfJDHzqY0s_bC18B_P6K3Rdo9Ss0_iAwMz8HY7v1OENA>
    <xmx:DnDGXsTdiA3hFeYUiOnzNuByIsmFCaZE_Vcgisl_mdIcgjOySVQFUg>
    <xmx:DnDGXppdDKXDbdMCRZp0FhfaE-CpRxRWPCFd1CO2-dBl1PuXwzxeeQ>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A68453066482;
        Thu, 21 May 2020 08:11:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 1/2] mlxsw: spectrum: Fix use-after-free of split/unsplit/type_set in case reload fails
Date:   Thu, 21 May 2020 15:11:44 +0300
Message-Id: <20200521121145.1076075-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521121145.1076075-1-idosch@idosch.org>
References: <20200521121145.1076075-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

In case of reload fail, the mlxsw_sp->ports contains a pointer to a
freed memory (either by reload_down() or reload_up() error path).
Fix this by initializing the pointer to NULL and checking it before
dereferencing in split/unsplit/type_set callpaths.

Fixes: 24cc68ad6c46 ("mlxsw: core: Add support for reload")
Reported-by: Danielle Ratson <danieller@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 14 ++++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c |  8 ++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 24ca8d5bc564..6b39978acd07 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3986,6 +3986,7 @@ static void mlxsw_sp_ports_remove(struct mlxsw_sp *mlxsw_sp)
 			mlxsw_sp_port_remove(mlxsw_sp, i);
 	mlxsw_sp_cpu_port_remove(mlxsw_sp);
 	kfree(mlxsw_sp->ports);
+	mlxsw_sp->ports = NULL;
 }
 
 static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
@@ -4022,6 +4023,7 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp_cpu_port_remove(mlxsw_sp);
 err_cpu_port_create:
 	kfree(mlxsw_sp->ports);
+	mlxsw_sp->ports = NULL;
 	return err;
 }
 
@@ -4143,6 +4145,14 @@ static int mlxsw_sp_local_ports_offset(struct mlxsw_core *mlxsw_core,
 	return mlxsw_core_res_get(mlxsw_core, local_ports_in_x_res_id);
 }
 
+static struct mlxsw_sp_port *
+mlxsw_sp_port_get_by_local_port(struct mlxsw_sp *mlxsw_sp, u8 local_port)
+{
+	if (mlxsw_sp->ports && mlxsw_sp->ports[local_port])
+		return mlxsw_sp->ports[local_port];
+	return NULL;
+}
+
 static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 			       unsigned int count,
 			       struct netlink_ext_ack *extack)
@@ -4156,7 +4166,7 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 	int i;
 	int err;
 
-	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	mlxsw_sp_port = mlxsw_sp_port_get_by_local_port(mlxsw_sp, local_port);
 	if (!mlxsw_sp_port) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port number \"%d\" does not exist\n",
 			local_port);
@@ -4251,7 +4261,7 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 	int offset;
 	int i;
 
-	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	mlxsw_sp_port = mlxsw_sp_port_get_by_local_port(mlxsw_sp, local_port);
 	if (!mlxsw_sp_port) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port number \"%d\" does not exist\n",
 			local_port);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index 90535820b559..2503f61db5fb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -1259,6 +1259,7 @@ static void mlxsw_sx_ports_remove(struct mlxsw_sx *mlxsw_sx)
 		if (mlxsw_sx_port_created(mlxsw_sx, i))
 			mlxsw_sx_port_remove(mlxsw_sx, i);
 	kfree(mlxsw_sx->ports);
+	mlxsw_sx->ports = NULL;
 }
 
 static int mlxsw_sx_ports_create(struct mlxsw_sx *mlxsw_sx)
@@ -1293,6 +1294,7 @@ static int mlxsw_sx_ports_create(struct mlxsw_sx *mlxsw_sx)
 		if (mlxsw_sx_port_created(mlxsw_sx, i))
 			mlxsw_sx_port_remove(mlxsw_sx, i);
 	kfree(mlxsw_sx->ports);
+	mlxsw_sx->ports = NULL;
 	return err;
 }
 
@@ -1376,6 +1378,12 @@ static int mlxsw_sx_port_type_set(struct mlxsw_core *mlxsw_core, u8 local_port,
 	u8 module, width;
 	int err;
 
+	if (!mlxsw_sx->ports || !mlxsw_sx->ports[local_port]) {
+		dev_err(mlxsw_sx->bus_info->dev, "Port number \"%d\" does not exist\n",
+			local_port);
+		return -EINVAL;
+	}
+
 	if (new_type == DEVLINK_PORT_TYPE_AUTO)
 		return -EOPNOTSUPP;
 
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F481E602C
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388896AbgE1MIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:08:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388755AbgE1L4h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:56:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4845721532;
        Thu, 28 May 2020 11:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666997;
        bh=t3/DUnZ7Va7LfUYt2PknXD6yTzNvyjCApmOw95O2kAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsGlU3An/C895GRREflbRkXT1/0mwHYwqESDHife5OKSe9aPosK+5jqc/v9LvW2XP
         Ji1IZGtCOpC/ghrBZem2VAjhD4535EAkZCpnjhkrgoYC0hi8mIw6DjkilOKbkumTZ7
         G98yCWqQc2Ow9rRefgNt0tAal7HcVmLlmRbla5ls=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 32/47] mlxsw: spectrum: Fix use-after-free of split/unsplit/type_set in case reload fails
Date:   Thu, 28 May 2020 07:55:45 -0400
Message-Id: <20200528115600.1405808-32-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

[ Upstream commit 4340f42f207eacb81e7a6b6bb1e3b6afad9a2e26 ]

In case of reload fail, the mlxsw_sp->ports contains a pointer to a
freed memory (either by reload_down() or reload_up() error path).
Fix this by initializing the pointer to NULL and checking it before
dereferencing in split/unsplit/type_set callpaths.

Fixes: 24cc68ad6c46 ("mlxsw: core: Add support for reload")
Reported-by: Danielle Ratson <danieller@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 14 ++++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c |  8 ++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 7358b5bc7eb6..58ebabe99876 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4043,6 +4043,7 @@ static void mlxsw_sp_ports_remove(struct mlxsw_sp *mlxsw_sp)
 			mlxsw_sp_port_remove(mlxsw_sp, i);
 	mlxsw_sp_cpu_port_remove(mlxsw_sp);
 	kfree(mlxsw_sp->ports);
+	mlxsw_sp->ports = NULL;
 }
 
 static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
@@ -4079,6 +4080,7 @@ err_port_create:
 	mlxsw_sp_cpu_port_remove(mlxsw_sp);
 err_cpu_port_create:
 	kfree(mlxsw_sp->ports);
+	mlxsw_sp->ports = NULL;
 	return err;
 }
 
@@ -4200,6 +4202,14 @@ static int mlxsw_sp_local_ports_offset(struct mlxsw_core *mlxsw_core,
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
@@ -4213,7 +4223,7 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 	int i;
 	int err;
 
-	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	mlxsw_sp_port = mlxsw_sp_port_get_by_local_port(mlxsw_sp, local_port);
 	if (!mlxsw_sp_port) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port number \"%d\" does not exist\n",
 			local_port);
@@ -4308,7 +4318,7 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 	int offset;
 	int i;
 
-	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	mlxsw_sp_port = mlxsw_sp_port_get_by_local_port(mlxsw_sp, local_port);
 	if (!mlxsw_sp_port) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port number \"%d\" does not exist\n",
 			local_port);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index f0e98ec8f1ee..c69232445ab7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -1259,6 +1259,7 @@ static void mlxsw_sx_ports_remove(struct mlxsw_sx *mlxsw_sx)
 		if (mlxsw_sx_port_created(mlxsw_sx, i))
 			mlxsw_sx_port_remove(mlxsw_sx, i);
 	kfree(mlxsw_sx->ports);
+	mlxsw_sx->ports = NULL;
 }
 
 static int mlxsw_sx_ports_create(struct mlxsw_sx *mlxsw_sx)
@@ -1293,6 +1294,7 @@ err_port_module_info_get:
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
2.25.1


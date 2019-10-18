Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB6DADD33D
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 00:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392857AbfJRWQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 18:16:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387677AbfJRWIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 18:08:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E5202245A;
        Fri, 18 Oct 2019 22:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436500;
        bh=a4hWbx/OJTFq6/zncSC4Cw+aLZpikdZTGHzDZjdvTL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKGVEraRE6vT0B81xsEsu4LaqbA43qI8jUM4s2W5t+jdhf257r1FU/opjOdRhZ5et
         mcuXUuhyctEmcdR3X9ZaVMjKTl6CuIrlckPwq+ManHFN+UWHj1CURqJwxca9XXuGgR
         kEN1pIx3Vjcxo2WKfFL8E1qui7SuFRxHl8vZs8EM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nir Dotan <nird@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/56] mlxsw: spectrum: Set LAG port collector only when active
Date:   Fri, 18 Oct 2019 18:07:10 -0400
Message-Id: <20191018220753.10002-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220753.10002-1-sashal@kernel.org>
References: <20191018220753.10002-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nir Dotan <nird@mellanox.com>

[ Upstream commit 48ebab31d424fbdb8ede8914923bec671a933246 ]

The LAG port collecting (receive) function was mistakenly set when the
port was registered as a LAG member, while it should be set only when
the port collection state is set to true. Set LAG port to collecting
when it is set to distributing, as described in the IEEE link
aggregation standard coupled control mux machine state diagram.

Signed-off-by: Nir Dotan <nird@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 62 ++++++++++++++-----
 1 file changed, 45 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5c74787f903b7..a909aa315a92a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4077,9 +4077,6 @@ static int mlxsw_sp_port_lag_join(struct mlxsw_sp_port *mlxsw_sp_port,
 	err = mlxsw_sp_lag_col_port_add(mlxsw_sp_port, lag_id, port_index);
 	if (err)
 		goto err_col_port_add;
-	err = mlxsw_sp_lag_col_port_enable(mlxsw_sp_port, lag_id);
-	if (err)
-		goto err_col_port_enable;
 
 	mlxsw_core_lag_mapping_set(mlxsw_sp->core, lag_id, port_index,
 				   mlxsw_sp_port->local_port);
@@ -4094,8 +4091,6 @@ static int mlxsw_sp_port_lag_join(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	return 0;
 
-err_col_port_enable:
-	mlxsw_sp_lag_col_port_remove(mlxsw_sp_port, lag_id);
 err_col_port_add:
 	if (!lag->ref_count)
 		mlxsw_sp_lag_destroy(mlxsw_sp, lag_id);
@@ -4114,7 +4109,6 @@ static void mlxsw_sp_port_lag_leave(struct mlxsw_sp_port *mlxsw_sp_port,
 	lag = mlxsw_sp_lag_get(mlxsw_sp, lag_id);
 	WARN_ON(lag->ref_count == 0);
 
-	mlxsw_sp_lag_col_port_disable(mlxsw_sp_port, lag_id);
 	mlxsw_sp_lag_col_port_remove(mlxsw_sp_port, lag_id);
 
 	/* Any VLANs configured on the port are no longer valid */
@@ -4159,21 +4153,56 @@ static int mlxsw_sp_lag_dist_port_remove(struct mlxsw_sp_port *mlxsw_sp_port,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sldr), sldr_pl);
 }
 
-static int mlxsw_sp_port_lag_tx_en_set(struct mlxsw_sp_port *mlxsw_sp_port,
-				       bool lag_tx_enabled)
+static int
+mlxsw_sp_port_lag_col_dist_enable(struct mlxsw_sp_port *mlxsw_sp_port)
 {
-	if (lag_tx_enabled)
-		return mlxsw_sp_lag_dist_port_add(mlxsw_sp_port,
-						  mlxsw_sp_port->lag_id);
-	else
-		return mlxsw_sp_lag_dist_port_remove(mlxsw_sp_port,
-						     mlxsw_sp_port->lag_id);
+	int err;
+
+	err = mlxsw_sp_lag_col_port_enable(mlxsw_sp_port,
+					   mlxsw_sp_port->lag_id);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_lag_dist_port_add(mlxsw_sp_port, mlxsw_sp_port->lag_id);
+	if (err)
+		goto err_dist_port_add;
+
+	return 0;
+
+err_dist_port_add:
+	mlxsw_sp_lag_col_port_disable(mlxsw_sp_port, mlxsw_sp_port->lag_id);
+	return err;
+}
+
+static int
+mlxsw_sp_port_lag_col_dist_disable(struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	int err;
+
+	err = mlxsw_sp_lag_dist_port_remove(mlxsw_sp_port,
+					    mlxsw_sp_port->lag_id);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_lag_col_port_disable(mlxsw_sp_port,
+					    mlxsw_sp_port->lag_id);
+	if (err)
+		goto err_col_port_disable;
+
+	return 0;
+
+err_col_port_disable:
+	mlxsw_sp_lag_dist_port_add(mlxsw_sp_port, mlxsw_sp_port->lag_id);
+	return err;
 }
 
 static int mlxsw_sp_port_lag_changed(struct mlxsw_sp_port *mlxsw_sp_port,
 				     struct netdev_lag_lower_state_info *info)
 {
-	return mlxsw_sp_port_lag_tx_en_set(mlxsw_sp_port, info->tx_enabled);
+	if (info->tx_enabled)
+		return mlxsw_sp_port_lag_col_dist_enable(mlxsw_sp_port);
+	else
+		return mlxsw_sp_port_lag_col_dist_disable(mlxsw_sp_port);
 }
 
 static int mlxsw_sp_port_stp_set(struct mlxsw_sp_port *mlxsw_sp_port,
@@ -4309,8 +4338,7 @@ static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 				err = mlxsw_sp_port_lag_join(mlxsw_sp_port,
 							     upper_dev);
 			} else {
-				mlxsw_sp_port_lag_tx_en_set(mlxsw_sp_port,
-							    false);
+				mlxsw_sp_port_lag_col_dist_disable(mlxsw_sp_port);
 				mlxsw_sp_port_lag_leave(mlxsw_sp_port,
 							upper_dev);
 			}
-- 
2.20.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA27446F30
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 18:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbhKFRK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 13:10:57 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:56587 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbhKFRK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 13:10:56 -0400
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id jPAqmPRE42lVYjPArmWDoG; Sat, 06 Nov 2021 18:08:14 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 06 Nov 2021 18:08:14 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org, roid@nvidia.com, vladbu@nvidia.com,
        paulb@nvidia.com, lariel@nvidia.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net/mlx5: Fix some error handling paths in 'mlx5e_tc_add_fdb_flow()'
Date:   Sat,  6 Nov 2021 18:08:11 +0100
Message-Id: <3055988affc39dff4d2a5c00a8d18474b0d63e26.1636218396.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the error handling paths of 'mlx5e_tc_add_fdb_flow()' end to 'err_out'
where 'flow_flag_set(flow, FAILED);' is called.

All but the new error handling paths added by the commits given in the
Fixes tag below.

Fix these error handling paths and branch to 'err_out'.

Fixes: 166f431ec6be ("net/mlx5e: Add indirect tc offload of ovs internal port")
Fixes: b16eb3c81fe2 ("net/mlx5: Support internal port as decap route device")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is speculative, review with care.
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 835caa1c7b74..ff881307c744 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1445,7 +1445,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 							MLX5_FLOW_NAMESPACE_FDB, VPORT_TO_REG,
 							metadata);
 			if (err)
-				return err;
+				goto err_out;
 		}
 	}
 
@@ -1461,13 +1461,15 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		if (attr->chain) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Internal port rule is only supported on chain 0");
-			return -EOPNOTSUPP;
+			err = -EOPNOTSUPP;
+			goto err_out;
 		}
 
 		if (attr->dest_chain) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Internal port rule offload doesn't support goto action");
-			return -EOPNOTSUPP;
+			err = -EOPNOTSUPP;
+			goto err_out;
 		}
 
 		int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
@@ -1475,8 +1477,10 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 						 flow_flag_test(flow, EGRESS) ?
 						 MLX5E_TC_INT_PORT_EGRESS :
 						 MLX5E_TC_INT_PORT_INGRESS);
-		if (IS_ERR(int_port))
-			return PTR_ERR(int_port);
+		if (IS_ERR(int_port)) {
+			err = PTR_ERR(int_port);
+			goto err_out;
+		}
 
 		esw_attr->int_port = int_port;
 	}
-- 
2.30.2


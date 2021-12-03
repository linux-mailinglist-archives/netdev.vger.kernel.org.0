Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF19466ED6
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244580AbhLCA7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:59:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60608 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244093AbhLCA7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:59:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BE9062922
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D92C53FD4;
        Fri,  3 Dec 2021 00:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638492986;
        bh=9wAaXeUBgWMkjDMTBHLq6OPxSmJLAfDf4SDT3sUO8QI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHQSJXaPUGomLx5fH9m1FPjU5Yz2BN381aX1OoqeJxTQdAHZQZKKPO1KdFoEK1Ur2
         mufwqV5AHxBcpt30qmvIt77xmNuOjWdP+j33uI5V4nNpwa5CKrVEUMjXvyi98yT+k9
         rQowcgfnM+2Del6ye+9YnYHV3smnleXhdtESPCNrmfksG/PWwCB5ithwJG+m2TxkkW
         mQsb10/QbifhvymOguNDoRg/j+PG7EUSNEJ8a7TSzJwMavz2aolyLGj5SaCexn0Lks
         fDRFdjUb3/W5boDaZ9sMpa9V5iqC7wg6jHEJS9ypqB+zl9aiXIFv2hY5MaeERjAABq
         efQE2Yc/uAdOQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 04/14] net/mlx5: Fix some error handling paths in 'mlx5e_tc_add_fdb_flow()'
Date:   Thu,  2 Dec 2021 16:56:12 -0800
Message-Id: <20211203005622.183325-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203005622.183325-1-saeed@kernel.org>
References: <20211203005622.183325-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

All the error handling paths of 'mlx5e_tc_add_fdb_flow()' end to 'err_out'
where 'flow_flag_set(flow, FAILED);' is called.

All but the new error handling paths added by the commits given in the
Fixes tag below.

Fix these error handling paths and branch to 'err_out'.

Fixes: 166f431ec6be ("net/mlx5e: Add indirect tc offload of ovs internal port")
Fixes: b16eb3c81fe2 ("net/mlx5: Support internal port as decap route device")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index cb66c08783c2..ca74ed616382 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1441,7 +1441,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 							MLX5_FLOW_NAMESPACE_FDB, VPORT_TO_REG,
 							metadata);
 			if (err)
-				return err;
+				goto err_out;
 		}
 	}
 
@@ -1457,13 +1457,15 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
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
@@ -1471,8 +1473,10 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
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
2.31.1


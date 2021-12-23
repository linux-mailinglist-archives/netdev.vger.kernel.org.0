Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B900947E7E8
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 20:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244882AbhLWTE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 14:04:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37722 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349931AbhLWTEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 14:04:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AA9F61F6F
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839EBC36AE5;
        Thu, 23 Dec 2021 19:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640286292;
        bh=jRJxwwuXuYqoTWlk95f6q2XsYNwYXS9EgJ8jN8f9GjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r8TzpsbVZl8BMf4QxgQ2fAKUhFVGROJ+TSXO78nTxhYM5KVpaaDk/OoWidBq2vf6H
         MtylHRfZWSzHduVpG1GOX+bOg+F/3e2Ond+ALClLi4vhGpicZv54jvST4cahA/W3k0
         K1jFGfJ7RZ4njfb4/HQ5cyeyyP2PGmC56z/KsHK6VqT7kcpKaM7G1iLsFqZz9qTvWR
         yQ8YSldOOFnsp+ioJXjHdJ786dwGZlNvubFyJV8R3weCnpg7ETagX0GAEII5oCvt4e
         VaR2SakoQAG3KFLjMGh3uS2JEFr6Y/YsFOOM/BSTa/KYJkU38Rv8D2SVPozjKSYBFM
         nRS1kYpzK59iA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 12/12] net/mlx5: Fix some error handling paths in 'mlx5e_tc_add_fdb_flow()'
Date:   Thu, 23 Dec 2021 11:04:41 -0800
Message-Id: <20211223190441.153012-13-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211223190441.153012-1-saeed@kernel.org>
References: <20211223190441.153012-1-saeed@kernel.org>
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
(cherry picked from commit 31108d142f3632970f6f3e0224bd1c6781c9f87d)
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f633448c3cc7..a60c7680fd2b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1440,7 +1440,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 							MLX5_FLOW_NAMESPACE_FDB, VPORT_TO_REG,
 							metadata);
 			if (err)
-				return err;
+				goto err_out;
 		}
 	}
 
@@ -1456,13 +1456,15 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
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
@@ -1470,8 +1472,10 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
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
2.33.1


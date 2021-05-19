Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C92388746
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240890AbhESGHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238122AbhESGH0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1498613B0;
        Wed, 19 May 2021 06:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404367;
        bh=+uJTqi8ZT6Zi/Nukx0qKE2ARBOCEExsvt5UUr9wmYN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VnRPM01EYqjyg1+hCS75ff2X1qkh4NOBwsr2bj0Wwr1OHNEOq5w1j1DrqgK0x/7r+
         3ECP+L+dk9s95woOAkru08/tYvzJK3ZdJWDPm7srGktKXsPMg6JcX9x1HWmpIHiZnS
         ceelTYTiKzvI1PnBEzzx2aBxVZPBDSka7zJDi69xKnKWZ1iye8lPJm49gu8SVuwi6W
         14JSLSvxQwd0YrPDE+MKgbP7NX0w8e4NArY5FdNi+MB5kXzNEJhAOxwwFN8quYo2uO
         FPjvvu2HljAaG8fapyWorGyQ8IH6GFgzYUNXAp+xzA5g0Q3Qd1c/Q4z1ixbWQ7AVBq
         +pr0aFsczc6jg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/16] net/mlx5: Fix err prints and return when creating termination table
Date:   Tue, 18 May 2021 23:05:11 -0700
Message-Id: <20210519060523.17875-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Fix print to print correct error code and not using IS_ERR() which
will just result in always printing 1.
Also return real err instead of always -EOPNOTSUPP.

Fixes: 10caabdaad5a ("net/mlx5e: Use termination table for VLAN push actions")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mlx5/core/eswitch_offloads_termtbl.c      | 23 +++++++++----------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index e3e7fdd396ad..d61bee2d35fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -65,7 +65,7 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 {
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_namespace *root_ns;
-	int err;
+	int err, err2;
 
 	root_ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_FDB);
 	if (!root_ns) {
@@ -83,26 +83,26 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 	ft_attr.autogroup.max_num_groups = 1;
 	tt->termtbl = mlx5_create_auto_grouped_flow_table(root_ns, &ft_attr);
 	if (IS_ERR(tt->termtbl)) {
-		esw_warn(dev, "Failed to create termination table (error %d)\n",
-			 IS_ERR(tt->termtbl));
-		return -EOPNOTSUPP;
+		err = PTR_ERR(tt->termtbl);
+		esw_warn(dev, "Failed to create termination table, err %pe\n", tt->termtbl);
+		return err;
 	}
 
 	tt->rule = mlx5_add_flow_rules(tt->termtbl, NULL, flow_act,
 				       &tt->dest, 1);
 	if (IS_ERR(tt->rule)) {
-		esw_warn(dev, "Failed to create termination table rule (error %d)\n",
-			 IS_ERR(tt->rule));
+		err = PTR_ERR(tt->rule);
+		esw_warn(dev, "Failed to create termination table rule, err %pe\n", tt->rule);
 		goto add_flow_err;
 	}
 	return 0;
 
 add_flow_err:
-	err = mlx5_destroy_flow_table(tt->termtbl);
-	if (err)
-		esw_warn(dev, "Failed to destroy termination table\n");
+	err2 = mlx5_destroy_flow_table(tt->termtbl);
+	if (err2)
+		esw_warn(dev, "Failed to destroy termination table, err %d\n", err2);
 
-	return -EOPNOTSUPP;
+	return err;
 }
 
 static struct mlx5_termtbl_handle *
@@ -270,8 +270,7 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 		tt = mlx5_eswitch_termtbl_get_create(esw, &term_tbl_act,
 						     &dest[i], attr);
 		if (IS_ERR(tt)) {
-			esw_warn(esw->dev, "Failed to get termination table (error %d)\n",
-				 IS_ERR(tt));
+			esw_warn(esw->dev, "Failed to get termination table, err %pe\n", tt);
 			goto revert_changes;
 		}
 		attr->dests[num_vport_dests].termtbl = tt;
-- 
2.31.1


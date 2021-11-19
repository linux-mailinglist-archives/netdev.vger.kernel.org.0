Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA27457778
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 20:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbhKSUBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:01:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234495AbhKSUB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:01:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1703A61B62;
        Fri, 19 Nov 2021 19:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637351901;
        bh=Bok9KkenqvsafCpkZcq9UC8vbfgTDpDWTgF7EfXOaaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2P+IsZoTMzzc1Edsh/xTnkZY/X3h7llfsb9dEAcr1hfwAnM7J5KGCAXEAp8Fpfow
         jZNFIC/+wmp7nTx9L0c92C1Y+UgpqTX9gddc3bjD6D6KJnTgOWxQWo0HDIB5+g/HDH
         tHLG23rk8QLELv0QcDjys0hJ7JF1VUA+pwoaIT8Zt/2fZlrU7xuG9jRKCjx2zwX418
         a2/F8YEUljzZ3/eZiwe5/MXcPWlUAw/WevJe/Hmem3GPStfyQbwjkzGl56ACcooo9R
         1Fhu/XTfB/N3YiQ3d98YQLNB7OdRiprGjvkAYAmZAZvDwo3JH+/E1b2YbRvdOB9jQo
         PlAlWfx1mUzIA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/10] net/mlx5: E-Switch, fix single FDB creation on BlueField
Date:   Fri, 19 Nov 2021 11:58:09 -0800
Message-Id: <20211119195813.739586-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119195813.739586-1-saeed@kernel.org>
References: <20211119195813.739586-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Always use MLX5_FLOW_TABLE_OTHER_VPORT flag when creating egress ACL
table for single FDB. Not doing so on BlueField will make firmware fail
the command. On BlueField the E-Switch manager is the ECPF (vport 0xFFFE)
which is filled in the flow table creation command but as the
other_vport field wasn't set the firmware complains about a bad parameter.

This is different from a regular HCA where the E-Switch manager vport is
the PF (vport 0x0). Passing MLX5_FLOW_TABLE_OTHER_VPORT will make the
firmware happy both on BlueField and on regular HCAs without special
condition for each.

This fixes the bellow firmware syndrome:
mlx5_cmd_check:819:(pid 571): CREATE_FLOW_TABLE(0x930) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x754a4)

Fixes: db202995f503 ("net/mlx5: E-Switch, add logic to enable shared FDB")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index a46455694f7a..275af1d2b4d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2512,6 +2512,7 @@ static int esw_set_master_egress_rule(struct mlx5_core_dev *master,
 	struct mlx5_eswitch *esw = master->priv.eswitch;
 	struct mlx5_flow_table_attr ft_attr = {
 		.max_fte = 1, .prio = 0, .level = 0,
+		.flags = MLX5_FLOW_TABLE_OTHER_VPORT,
 	};
 	struct mlx5_flow_namespace *egress_ns;
 	struct mlx5_flow_table *acl;
-- 
2.31.1


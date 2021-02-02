Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E3F30B864
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhBBHIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 02:08:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231509AbhBBHHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 02:07:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 545ED64EE5;
        Tue,  2 Feb 2021 07:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612249632;
        bh=QUH8SUTpfgcF7e/+AMqZO4NpD0O/qomD8Siyr0KTosg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+KYAliWdMxTtGD4GtigcTsfa+B6F64pp48684hlXdu7UJrdyxwsLXwTqyXMxMtWx
         OgZymm//bGKHRIrdPnfwXbh1vFhl6MEEMxV4Pws9xOShnRcDuXjOfHSODUTfvYJYxL
         ZbeNa5YLIczP/WOR2VE0XSDnUBdfn3eCuBo16gLAxDMj7D3D4mZ42+nISVeszcfH78
         ixA8s5zrjWZ88Llq7CTnlUHWk9dHn3QsNTCIfFcngpZqK0GkjDdYs06UQsmcg7PT3e
         I7Nax7ceZIftOZxUxwGj5UnF+VIKfmkYEEDp86RAwB92JIvDL2azSckX7/BMfjY4fk
         m2aWnMw/EbWfw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/4] net/mlx5: Fix leak upon failure of rule creation
Date:   Mon,  1 Feb 2021 23:07:01 -0800
Message-Id: <20210202070703.617251-3-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202070703.617251-1-saeed@kernel.org>
References: <20210202070703.617251-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

When creation of a new rule that requires allocation of an FTE fails,
need to call to tree_put_node on the FTE in order to release its'
resource.

Fixes: cefc23554fc2 ("net/mlx5: Fix FTE cleanup")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Alaa Hleihel <alaa@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 0fcee702b808..ee4d86c1f436 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1760,6 +1760,7 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 		if (!fte_tmp)
 			continue;
 		rule = add_rule_fg(g, spec, flow_act, dest, dest_num, fte_tmp);
+		/* No error check needed here, because insert_fte() is not called */
 		up_write_ref_node(&fte_tmp->node, false);
 		tree_put_node(&fte_tmp->node, false);
 		kmem_cache_free(steering->ftes_cache, fte);
@@ -1812,6 +1813,8 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 		up_write_ref_node(&g->node, false);
 		rule = add_rule_fg(g, spec, flow_act, dest, dest_num, fte);
 		up_write_ref_node(&fte->node, false);
+		if (IS_ERR(rule))
+			tree_put_node(&fte->node, false);
 		return rule;
 	}
 	rule = ERR_PTR(-ENOENT);
@@ -1910,6 +1913,8 @@ _mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 	up_write_ref_node(&g->node, false);
 	rule = add_rule_fg(g, spec, flow_act, dest, dest_num, fte);
 	up_write_ref_node(&fte->node, false);
+	if (IS_ERR(rule))
+		tree_put_node(&fte->node, false);
 	tree_put_node(&g->node, false);
 	return rule;
 
-- 
2.29.2


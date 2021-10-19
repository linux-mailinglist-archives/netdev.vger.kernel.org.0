Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A0A432C36
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbhJSDXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232140AbhJSDXH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 23:23:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C80D36134F;
        Tue, 19 Oct 2021 03:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634613655;
        bh=wtrE49n/HXDmJFE9rbYsYD/U9GSXdVi8ylgskbSWoTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yows2tNgcOIw/WdvzVRBuqv/VHfmqi0hWSNvlKAI47se4LVVdrsutH3efKznQZTce
         X9S/udEn2+WI6lMsRFLYD3AUqRON6W6u8qQw4hQQQ76YJAm2h5qyzzte46oksk3toC
         Blqfhf2VmNpObybPYchAIVfXYgU+3CiiDtJ+ZXiudWYDOdGVpJBZuJCoAb7Vz9KlwW
         E1GfndfCWZIofl7akB0PekpQFighkWQ+s75tLetdOZ1E88FfrCpR2tBEVSuLObVOpM
         C8jArYZ27l7xwoWuQHvkvKpGMrzFIPO49vg4e3imk9Cns/DAsIhL33XrhqjYCF0Qso
         fccJEs4NVXRzQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/13] net/mlx5: E-Switch, Use dynamic alloc for dest array
Date:   Mon, 18 Oct 2021 20:20:46 -0700
Message-Id: <20211019032047.55660-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019032047.55660-1-saeed@kernel.org>
References: <20211019032047.55660-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Use dynamic allocation for the dest array in preparation for
the next patch which increase MLX5_MAX_FLOW_FWD_VPORTS and
will cause stack allocation to be bigger than 1024 bytes.

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c        | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3e5a7d74020b..0ef126fd6a8e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -482,12 +482,12 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 				struct mlx5_flow_spec *spec,
 				struct mlx5_flow_attr *attr)
 {
-	struct mlx5_flow_destination dest[MLX5_MAX_FLOW_FWD_VPORTS + 1] = {};
 	struct mlx5_flow_act flow_act = { .flags = FLOW_ACT_NO_APPEND, };
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	struct mlx5_fs_chains *chains = esw_chains(esw);
 	bool split = !!(esw_attr->split_count);
 	struct mlx5_vport_tbl_attr fwd_attr;
+	struct mlx5_flow_destination *dest;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_table *fdb;
 	int i = 0;
@@ -495,6 +495,10 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
 		return ERR_PTR(-EOPNOTSUPP);
 
+	dest = kcalloc(MLX5_MAX_FLOW_FWD_VPORTS + 1, sizeof(*dest), GFP_KERNEL);
+	if (!dest)
+		return ERR_PTR(-ENOMEM);
+
 	flow_act.action = attr->action;
 	/* if per flow vlan pop/push is emulated, don't set that into the firmware */
 	if (!mlx5_eswitch_vlan_actions_supported(esw->dev, 1))
@@ -574,6 +578,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	else
 		atomic64_inc(&esw->offloads.num_flows);
 
+	kfree(dest);
 	return rule;
 
 err_add_rule:
@@ -584,6 +589,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 err_esw_get:
 	esw_cleanup_dests(esw, attr);
 err_create_goto_table:
+	kfree(dest);
 	return rule;
 }
 
@@ -592,16 +598,20 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 			  struct mlx5_flow_spec *spec,
 			  struct mlx5_flow_attr *attr)
 {
-	struct mlx5_flow_destination dest[MLX5_MAX_FLOW_FWD_VPORTS + 1] = {};
 	struct mlx5_flow_act flow_act = { .flags = FLOW_ACT_NO_APPEND, };
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	struct mlx5_fs_chains *chains = esw_chains(esw);
 	struct mlx5_vport_tbl_attr fwd_attr;
+	struct mlx5_flow_destination *dest;
 	struct mlx5_flow_table *fast_fdb;
 	struct mlx5_flow_table *fwd_fdb;
 	struct mlx5_flow_handle *rule;
 	int i, err = 0;
 
+	dest = kcalloc(MLX5_MAX_FLOW_FWD_VPORTS + 1, sizeof(*dest), GFP_KERNEL);
+	if (!dest)
+		return ERR_PTR(-ENOMEM);
+
 	fast_fdb = mlx5_chains_get_table(chains, attr->chain, attr->prio, 0);
 	if (IS_ERR(fast_fdb)) {
 		rule = ERR_CAST(fast_fdb);
@@ -654,6 +664,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 
 	atomic64_inc(&esw->offloads.num_flows);
 
+	kfree(dest);
 	return rule;
 err_chain_src_rewrite:
 	esw_put_dest_tables_loop(esw, attr, 0, i);
@@ -661,6 +672,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 err_get_fwd:
 	mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
 err_get_fast:
+	kfree(dest);
 	return rule;
 }
 
-- 
2.31.1


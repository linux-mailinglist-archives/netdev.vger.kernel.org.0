Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8832421B9A
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhJEBQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231169AbhJEBQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:16:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52B156152B;
        Tue,  5 Oct 2021 01:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396487;
        bh=CybF17G5NB0fNrdx3LemgYbIPuuB8lCcyYOIHGnYjEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGP2SJgZiXQaF3BnACk7DIYbwYHs0nFWreWk8xHb9YLF0iSx4KRuQHfxKwpkMfp3G
         uVlnS4UKCShG9p927QLL8xbOSpw4IBUhIrgTQjp9DkgSyZESS7qbZGZk9Sff3Agg8p
         eb6LBa2GTlIq21i8tH24/4N5AN1hG2nM4QjCXGGIqcB3tTE3wG7Kne/UmzgwKXAPv8
         t7W0ls0n0RNddnrEJIMPyc/I5gUmSCMHs39MaTmRwzfnj75KxDa55+HZR3A7hBXuDL
         5ORhGC4nAvfqbO6FzyWGxs9SSbVJ0qV2TIit2xd88QjNGwSOMDCwiahbXBWGqQSh6T
         aMJpakZQSa2Gw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5: Bridge, refactor eswitch instance usage
Date:   Mon,  4 Oct 2021 18:12:57 -0700
Message-Id: <20211005011302.41793-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005011302.41793-1-saeed@kernel.org>
References: <20211005011302.41793-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Several functions in bridge.c excessively obtain pointer to parent eswitch
instance by dereferencing br_offloads->esw on every usage and following
patches in this series add even more usages of eswitch. Introduce local
variable 'esw' and use it instead.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 25 +++++++++++--------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 7e221038df8d..6a36c5aef74c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -292,38 +292,39 @@ mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
 {
 	struct mlx5_flow_group *mac_fg, *filter_fg, *vlan_fg;
 	struct mlx5_flow_table *ingress_ft, *skip_ft;
+	struct mlx5_eswitch *esw = br_offloads->esw;
 	int err;
 
-	if (!mlx5_eswitch_vport_match_metadata_enabled(br_offloads->esw))
+	if (!mlx5_eswitch_vport_match_metadata_enabled(esw))
 		return -EOPNOTSUPP;
 
 	ingress_ft = mlx5_esw_bridge_table_create(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE,
 						  MLX5_ESW_BRIDGE_LEVEL_INGRESS_TABLE,
-						  br_offloads->esw);
+						  esw);
 	if (IS_ERR(ingress_ft))
 		return PTR_ERR(ingress_ft);
 
 	skip_ft = mlx5_esw_bridge_table_create(MLX5_ESW_BRIDGE_SKIP_TABLE_SIZE,
 					       MLX5_ESW_BRIDGE_LEVEL_SKIP_TABLE,
-					       br_offloads->esw);
+					       esw);
 	if (IS_ERR(skip_ft)) {
 		err = PTR_ERR(skip_ft);
 		goto err_skip_tbl;
 	}
 
-	vlan_fg = mlx5_esw_bridge_ingress_vlan_fg_create(br_offloads->esw, ingress_ft);
+	vlan_fg = mlx5_esw_bridge_ingress_vlan_fg_create(esw, ingress_ft);
 	if (IS_ERR(vlan_fg)) {
 		err = PTR_ERR(vlan_fg);
 		goto err_vlan_fg;
 	}
 
-	filter_fg = mlx5_esw_bridge_ingress_filter_fg_create(br_offloads->esw, ingress_ft);
+	filter_fg = mlx5_esw_bridge_ingress_filter_fg_create(esw, ingress_ft);
 	if (IS_ERR(filter_fg)) {
 		err = PTR_ERR(filter_fg);
 		goto err_filter_fg;
 	}
 
-	mac_fg = mlx5_esw_bridge_ingress_mac_fg_create(br_offloads->esw, ingress_ft);
+	mac_fg = mlx5_esw_bridge_ingress_mac_fg_create(esw, ingress_ft);
 	if (IS_ERR(mac_fg)) {
 		err = PTR_ERR(mac_fg);
 		goto err_mac_fg;
@@ -366,23 +367,24 @@ static int
 mlx5_esw_bridge_egress_table_init(struct mlx5_esw_bridge_offloads *br_offloads,
 				  struct mlx5_esw_bridge *bridge)
 {
+	struct mlx5_eswitch *esw = br_offloads->esw;
 	struct mlx5_flow_group *mac_fg, *vlan_fg;
 	struct mlx5_flow_table *egress_ft;
 	int err;
 
 	egress_ft = mlx5_esw_bridge_table_create(MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE,
 						 MLX5_ESW_BRIDGE_LEVEL_EGRESS_TABLE,
-						 br_offloads->esw);
+						 esw);
 	if (IS_ERR(egress_ft))
 		return PTR_ERR(egress_ft);
 
-	vlan_fg = mlx5_esw_bridge_egress_vlan_fg_create(br_offloads->esw, egress_ft);
+	vlan_fg = mlx5_esw_bridge_egress_vlan_fg_create(esw, egress_ft);
 	if (IS_ERR(vlan_fg)) {
 		err = PTR_ERR(vlan_fg);
 		goto err_vlan_fg;
 	}
 
-	mac_fg = mlx5_esw_bridge_egress_mac_fg_create(br_offloads->esw, egress_ft);
+	mac_fg = mlx5_esw_bridge_egress_mac_fg_create(esw, egress_ft);
 	if (IS_ERR(mac_fg)) {
 		err = PTR_ERR(mac_fg);
 		goto err_mac_fg;
@@ -886,6 +888,7 @@ static void mlx5_esw_bridge_vlan_erase(struct mlx5_esw_bridge_port *port,
 static void mlx5_esw_bridge_vlan_flush(struct mlx5_esw_bridge_vlan *vlan,
 				       struct mlx5_esw_bridge *bridge)
 {
+	struct mlx5_eswitch *esw = bridge->br_offloads->esw;
 	struct mlx5_esw_bridge_fdb_entry *entry, *tmp;
 
 	list_for_each_entry_safe(entry, tmp, &vlan->fdb_list, vlan_list) {
@@ -894,9 +897,9 @@ static void mlx5_esw_bridge_vlan_flush(struct mlx5_esw_bridge_vlan *vlan,
 	}
 
 	if (vlan->pkt_reformat_pop)
-		mlx5_esw_bridge_vlan_pop_cleanup(vlan, bridge->br_offloads->esw);
+		mlx5_esw_bridge_vlan_pop_cleanup(vlan, esw);
 	if (vlan->pkt_reformat_push)
-		mlx5_esw_bridge_vlan_push_cleanup(vlan, bridge->br_offloads->esw);
+		mlx5_esw_bridge_vlan_push_cleanup(vlan, esw);
 }
 
 static void mlx5_esw_bridge_vlan_cleanup(struct mlx5_esw_bridge_port *port,
-- 
2.31.1


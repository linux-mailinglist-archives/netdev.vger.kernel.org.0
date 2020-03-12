Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DF6182D5F
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 11:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgCLKXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 06:23:39 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:56643 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726917AbgCLKXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 06:23:36 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Mar 2020 12:23:29 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02CANSTi017875;
        Thu, 12 Mar 2020 12:23:29 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload v4 10/15] net/mlx5: E-Switch, Support getting chain mapping
Date:   Thu, 12 Mar 2020 12:23:12 +0200
Message-Id: <1584008597-15875-11-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
References: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we write chain register mapping on miss from the the last
prio of a chain. It is used to restore the chain in software.

To support re-using the chain register mapping from global tables (such
as CT tuple table) misses, export the chain mapping.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c   | 13 +++++++++++++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h   |  7 +++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index 84e3313..0702c21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -900,6 +900,19 @@ struct mlx5_flow_table *
 	mlx5_esw_chains_cleanup(esw);
 }
 
+int
+mlx5_esw_chains_get_chain_mapping(struct mlx5_eswitch *esw, u32 chain,
+				  u32 *chain_mapping)
+{
+	return mapping_add(esw_chains_mapping(esw), &chain, chain_mapping);
+}
+
+int
+mlx5_esw_chains_put_chain_mapping(struct mlx5_eswitch *esw, u32 chain_mapping)
+{
+	return mapping_remove(esw_chains_mapping(esw), chain_mapping);
+}
+
 int mlx5_eswitch_get_chain_for_tag(struct mlx5_eswitch *esw, u32 tag,
 				   u32 *chain)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
index c7bc609..f3b9ae6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
@@ -31,6 +31,13 @@ struct mlx5_flow_table *
 mlx5_esw_chains_destroy_global_table(struct mlx5_eswitch *esw,
 				     struct mlx5_flow_table *ft);
 
+int
+mlx5_esw_chains_get_chain_mapping(struct mlx5_eswitch *esw, u32 chain,
+				  u32 *chain_mapping);
+int
+mlx5_esw_chains_put_chain_mapping(struct mlx5_eswitch *esw,
+				  u32 chain_mapping);
+
 int mlx5_esw_chains_create(struct mlx5_eswitch *esw);
 void mlx5_esw_chains_destroy(struct mlx5_eswitch *esw);
 
-- 
1.8.3.1


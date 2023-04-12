Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79FBF6DEA26
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjDLEIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjDLEIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A79F19AF
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B36362DA9
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7F3C433D2;
        Wed, 12 Apr 2023 04:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272483;
        bh=SktG9vHsYhoTIUbVmN4ctV3EVSZu/ni/tjSV0i0OHQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YReSVJtWZu/ACI+//0ZJJrJaqdJdvjoTXS8AfFxcTcVwM/eQawBC8GeI3BAY8Yy4m
         9pKI5ixqcAJvs4iqxv1+WNDNJWNq7zgfI6dABkIJV9Bmm1DyQ+CsozUVg9iYpzWdw2
         gHeE1QlDzq1xtzNshuNQiB/Rh1KsTQnPDNtTXultDEZqbYoxBn+OgqlyBD1OCxfIOk
         8tbuTgBi/sz6kNaGSGd501o2MpoNVbQzGD78hyC0+7qH0avKyemc9A1qOVHjSm5nE8
         Ike0QR2Ct15DwgPYw/wGClOxfcW5S/331xic1nnCzA0dLn9NXAdtLu+0cxpwo0KZr+
         b+PkymaqpmjSg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 04/15] net/mlx5: Bridge, extract code to lookup parent bridge of port
Date:   Tue, 11 Apr 2023 21:07:41 -0700
Message-Id: <20230412040752.14220-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412040752.14220-1-saeed@kernel.org>
References: <20230412040752.14220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

The pattern when function looks up a port by vport_num+vhca_id tuple in
order to just obtain its parent bridge is repeated multiple times in
bridge.c file. Further commits in this series use the pattern even more.
Extract the pattern to standalone mlx5_esw_bridge_from_port_lookup()
function to improve code readability.

This commits doesn't change functionality.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 47 ++++++++++---------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index ec052fff7712..bbbf982bbbc0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -933,6 +933,19 @@ static void mlx5_esw_bridge_port_erase(struct mlx5_esw_bridge_port *port,
 	xa_erase(&br_offloads->ports, mlx5_esw_bridge_port_key(port));
 }
 
+static struct mlx5_esw_bridge *
+mlx5_esw_bridge_from_port_lookup(u16 vport_num, u16 esw_owner_vhca_id,
+				 struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	struct mlx5_esw_bridge_port *port;
+
+	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
+	if (!port)
+		return NULL;
+
+	return port->bridge;
+}
+
 static void mlx5_esw_bridge_fdb_entry_refresh(struct mlx5_esw_bridge_fdb_entry *entry)
 {
 	trace_mlx5_esw_bridge_fdb_entry_refresh(entry);
@@ -1388,28 +1401,26 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, u16 esw_ow
 int mlx5_esw_bridge_ageing_time_set(u16 vport_num, u16 esw_owner_vhca_id, unsigned long ageing_time,
 				    struct mlx5_esw_bridge_offloads *br_offloads)
 {
-	struct mlx5_esw_bridge_port *port;
+	struct mlx5_esw_bridge *bridge;
 
-	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
-	if (!port)
+	bridge = mlx5_esw_bridge_from_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
+	if (!bridge)
 		return -EINVAL;
 
-	port->bridge->ageing_time = clock_t_to_jiffies(ageing_time);
+	bridge->ageing_time = clock_t_to_jiffies(ageing_time);
 	return 0;
 }
 
 int mlx5_esw_bridge_vlan_filtering_set(u16 vport_num, u16 esw_owner_vhca_id, bool enable,
 				       struct mlx5_esw_bridge_offloads *br_offloads)
 {
-	struct mlx5_esw_bridge_port *port;
 	struct mlx5_esw_bridge *bridge;
 	bool filtering;
 
-	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
-	if (!port)
+	bridge = mlx5_esw_bridge_from_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
+	if (!bridge)
 		return -EINVAL;
 
-	bridge = port->bridge;
 	filtering = bridge->flags & MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG;
 	if (filtering == enable)
 		return 0;
@@ -1426,15 +1437,13 @@ int mlx5_esw_bridge_vlan_filtering_set(u16 vport_num, u16 esw_owner_vhca_id, boo
 int mlx5_esw_bridge_vlan_proto_set(u16 vport_num, u16 esw_owner_vhca_id, u16 proto,
 				   struct mlx5_esw_bridge_offloads *br_offloads)
 {
-	struct mlx5_esw_bridge_port *port;
 	struct mlx5_esw_bridge *bridge;
 
-	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id,
-					   br_offloads);
-	if (!port)
+	bridge = mlx5_esw_bridge_from_port_lookup(vport_num, esw_owner_vhca_id,
+						  br_offloads);
+	if (!bridge)
 		return -EINVAL;
 
-	bridge = port->bridge;
 	if (bridge->vlan_proto == proto)
 		return 0;
 	if (proto != ETH_P_8021Q && proto != ETH_P_8021AD) {
@@ -1626,14 +1635,12 @@ void mlx5_esw_bridge_fdb_update_used(struct net_device *dev, u16 vport_num, u16
 				     struct switchdev_notifier_fdb_info *fdb_info)
 {
 	struct mlx5_esw_bridge_fdb_entry *entry;
-	struct mlx5_esw_bridge_port *port;
 	struct mlx5_esw_bridge *bridge;
 
-	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
-	if (!port)
+	bridge = mlx5_esw_bridge_from_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
+	if (!bridge)
 		return;
 
-	bridge = port->bridge;
 	entry = mlx5_esw_bridge_fdb_lookup(bridge, fdb_info->addr, fdb_info->vid);
 	if (!entry) {
 		esw_debug(br_offloads->esw->dev,
@@ -1680,14 +1687,12 @@ void mlx5_esw_bridge_fdb_remove(struct net_device *dev, u16 vport_num, u16 esw_o
 {
 	struct mlx5_eswitch *esw = br_offloads->esw;
 	struct mlx5_esw_bridge_fdb_entry *entry;
-	struct mlx5_esw_bridge_port *port;
 	struct mlx5_esw_bridge *bridge;
 
-	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
-	if (!port)
+	bridge = mlx5_esw_bridge_from_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
+	if (!bridge)
 		return;
 
-	bridge = port->bridge;
 	entry = mlx5_esw_bridge_fdb_lookup(bridge, fdb_info->addr, fdb_info->vid);
 	if (!entry) {
 		esw_debug(esw->dev,
-- 
2.39.2


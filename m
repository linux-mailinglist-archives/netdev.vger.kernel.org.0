Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 176F11685A8
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgBURyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:54:55 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39641 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729169AbgBURyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:54:51 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 40179217DD;
        Fri, 21 Feb 2020 12:54:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 21 Feb 2020 12:54:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=yLKT9ovlHC72CCnR3qvF8kvWXEEbPZ63VVWXDNMvcIg=; b=l6hV4R6F
        kbDMMFslpKuqYnz0yWgSVOqxwgjBxQZlF4Ojm/n4NN1x2M97q10EQ1D72noj0dXI
        fwMcvIKo3LZo+mowMUTLRzRdrnQOMxJ3CyxT/l+key1DvK0m6mjsawz1zZ+PobJm
        LPhoPrhys5loJXccgSp5q2BtTM6vymw0JHlGXbZua+o3C4DE66o7MstEFpQDXMSp
        ZiIjy3SnbfEIS1wnFkrKm7SwAcvTcytzx+J/jh/Xe1tcKENyNnDVabdzcAgRbcVb
        Fp3SRBb07n9o+J95TAnHjJ5gzinPfCxpLLvLQyCBhTyi5ctR3c1qosFIJjhpD+hD
        I0IH1zeJpP9ZNA==
X-ME-Sender: <xms:ahlQXi1wEqMZDCwqSNoam_XR_kPgcSUEWMCfQMyA5LvGNN-1Hm8JzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeeggddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedruddvrdehvdenucevlhhushhtvghruf
    hiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:ahlQXtTtzUkRVGHbqn-ecncFSKXXvB2PY4MeCW6SzQgsorDmQrHXVg>
    <xmx:ahlQXgyqap0Crc-VtbO5urdZ3zmHB72AdjyqXUBR0bg9I7ViFts7IQ>
    <xmx:ahlQXs4tE6n-Lo-vpC0wFsq6EXpjSVDCVFcro_0v4QKeN-2T_6DSpQ>
    <xmx:ahlQXhWEDHojIFYU8WCAHWjkLSinjAs0PUDcnYSJPy73VcuapVscIg>
Received: from localhost.localdomain (bzq-109-66-12-52.red.bezeqint.net [109.66.12.52])
        by mail.messagingengine.com (Postfix) with ESMTPA id AF0083060F09;
        Fri, 21 Feb 2020 12:54:48 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/12] mlxsw: spectrum_router: Store NVE decapsulation configuration in router
Date:   Fri, 21 Feb 2020 19:54:08 +0200
Message-Id: <20200221175415.390884-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221175415.390884-1-idosch@idosch.org>
References: <20200221175415.390884-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When a host route is added, the driver checks if the route needs to be
promoted to perform NVE decapsulation based on the current NVE
configuration. If so, the index of the decapsulation entry is retrieved
and associated with the route.

Currently, this information is stored in the NVE module which the router
module consults. Since the information is protected under RTNL and since
route insertion happens with RTNL held, there is no problem to retrieve
the information from the NVE module.

However, this is going to change and route insertion will no longer
happen under RTNL. Instead, a dedicated lock will be introduced for the
router module.

Therefore, store this information in the router module and change the
router module to consult this copy.

The validity of the information is set / cleared whenever an NVE tunnel
is initialized / de-initialized. When this happens the NVE module calls
into the router module to promote / demote the relevant host route.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 --
 .../ethernet/mellanox/mlxsw/spectrum_nve.c    | 21 ----------
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 42 ++++++++++++++++---
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  9 ++++
 4 files changed, 46 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index bed86f4825a8..66cfe27e1f9b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -966,9 +966,6 @@ void mlxsw_sp_nve_flood_ip_del(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp_fid *fid,
 			       enum mlxsw_sp_l3proto proto,
 			       union mlxsw_sp_l3addr *addr);
-u32 mlxsw_sp_nve_decap_tunnel_index_get(const struct mlxsw_sp *mlxsw_sp);
-bool mlxsw_sp_nve_ipv4_route_is_decap(const struct mlxsw_sp *mlxsw_sp,
-				      u32 tb_id, __be32 addr);
 int mlxsw_sp_nve_fid_enable(struct mlxsw_sp *mlxsw_sp, struct mlxsw_sp_fid *fid,
 			    struct mlxsw_sp_nve_params *params,
 			    struct netlink_ext_ack *extack);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
index eced553fd4ef..54d3e7dcd303 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
@@ -713,27 +713,6 @@ static void mlxsw_sp_nve_flood_ip_flush(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_nve_mc_list_put(mlxsw_sp, mc_list);
 }
 
-u32 mlxsw_sp_nve_decap_tunnel_index_get(const struct mlxsw_sp *mlxsw_sp)
-{
-	WARN_ON(mlxsw_sp->nve->num_nve_tunnels == 0);
-
-	return mlxsw_sp->nve->tunnel_index;
-}
-
-bool mlxsw_sp_nve_ipv4_route_is_decap(const struct mlxsw_sp *mlxsw_sp,
-				      u32 tb_id, __be32 addr)
-{
-	struct mlxsw_sp_nve *nve = mlxsw_sp->nve;
-	struct mlxsw_sp_nve_config *config = &nve->config;
-
-	if (nve->num_nve_tunnels &&
-	    config->ul_proto == MLXSW_SP_L3_PROTO_IPV4 &&
-	    config->ul_sip.addr4 == addr && config->ul_tb_id == tb_id)
-		return true;
-
-	return false;
-}
-
 static int mlxsw_sp_nve_tunnel_init(struct mlxsw_sp *mlxsw_sp,
 				    struct mlxsw_sp_nve_config *config)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 991095f66fc2..fe8c1f386651 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1833,9 +1833,19 @@ int mlxsw_sp_router_nve_promote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
 				      u32 tunnel_index)
 {
 	enum mlxsw_sp_fib_entry_type type = MLXSW_SP_FIB_ENTRY_TYPE_TRAP;
+	struct mlxsw_sp_router *router = mlxsw_sp->router;
 	struct mlxsw_sp_fib_entry *fib_entry;
 	int err;
 
+	if (WARN_ON_ONCE(router->nve_decap_config.valid))
+		return -EINVAL;
+
+	router->nve_decap_config.ul_tb_id = ul_tb_id;
+	router->nve_decap_config.tunnel_index = tunnel_index;
+	router->nve_decap_config.ul_proto = ul_proto;
+	router->nve_decap_config.ul_sip = *ul_sip;
+	router->nve_decap_config.valid = true;
+
 	/* It is valid to create a tunnel with a local IP and only later
 	 * assign this IP address to a local interface
 	 */
@@ -1865,8 +1875,14 @@ void mlxsw_sp_router_nve_demote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
 				      const union mlxsw_sp_l3addr *ul_sip)
 {
 	enum mlxsw_sp_fib_entry_type type = MLXSW_SP_FIB_ENTRY_TYPE_NVE_DECAP;
+	struct mlxsw_sp_router *router = mlxsw_sp->router;
 	struct mlxsw_sp_fib_entry *fib_entry;
 
+	if (WARN_ON_ONCE(!router->nve_decap_config.valid))
+		return;
+
+	router->nve_decap_config.valid = false;
+
 	fib_entry = mlxsw_sp_router_ip2me_fib_entry_find(mlxsw_sp, ul_tb_id,
 							 ul_proto, ul_sip,
 							 type);
@@ -1877,6 +1893,20 @@ void mlxsw_sp_router_nve_demote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
 	mlxsw_sp_fib_entry_update(mlxsw_sp, fib_entry);
 }
 
+static bool mlxsw_sp_router_nve_is_decap(struct mlxsw_sp *mlxsw_sp,
+					 u32 ul_tb_id,
+					 enum mlxsw_sp_l3proto ul_proto,
+					 const union mlxsw_sp_l3addr *ul_sip)
+{
+	struct mlxsw_sp_router *router = mlxsw_sp->router;
+
+	return router->nve_decap_config.valid &&
+	       router->nve_decap_config.ul_tb_id == ul_tb_id &&
+	       router->nve_decap_config.ul_proto == ul_proto &&
+	       !memcmp(&router->nve_decap_config.ul_sip, ul_sip,
+		       sizeof(*ul_sip));
+}
+
 struct mlxsw_sp_neigh_key {
 	struct neighbour *n;
 };
@@ -4466,6 +4496,7 @@ mlxsw_sp_fib4_entry_type_set(struct mlxsw_sp *mlxsw_sp,
 {
 	struct net_device *dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
 	union mlxsw_sp_l3addr dip = { .addr4 = htonl(fen_info->dst) };
+	struct mlxsw_sp_router *router = mlxsw_sp->router;
 	u32 tb_id = mlxsw_sp_fix_tb_id(fen_info->tb_id);
 	struct mlxsw_sp_ipip_entry *ipip_entry;
 	struct fib_info *fi = fen_info->fi;
@@ -4480,12 +4511,13 @@ mlxsw_sp_fib4_entry_type_set(struct mlxsw_sp *mlxsw_sp,
 							     fib_entry,
 							     ipip_entry);
 		}
-		if (mlxsw_sp_nve_ipv4_route_is_decap(mlxsw_sp, tb_id,
-						     dip.addr4)) {
-			u32 t_index;
+		if (mlxsw_sp_router_nve_is_decap(mlxsw_sp, tb_id,
+						 MLXSW_SP_L3_PROTO_IPV4,
+						 &dip)) {
+			u32 tunnel_index;
 
-			t_index = mlxsw_sp_nve_decap_tunnel_index_get(mlxsw_sp);
-			fib_entry->decap.tunnel_index = t_index;
+			tunnel_index = router->nve_decap_config.tunnel_index;
+			fib_entry->decap.tunnel_index = tunnel_index;
 			fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_NVE_DECAP;
 			return 0;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index b2554727d8ee..3c99db1f434b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -7,6 +7,14 @@
 #include "spectrum.h"
 #include "reg.h"
 
+struct mlxsw_sp_router_nve_decap {
+	u32 ul_tb_id;
+	u32 tunnel_index;
+	enum mlxsw_sp_l3proto ul_proto;
+	union mlxsw_sp_l3addr ul_sip;
+	u8 valid:1;
+};
+
 struct mlxsw_sp_router {
 	struct mlxsw_sp *mlxsw_sp;
 	struct mlxsw_sp_rif **rifs;
@@ -38,6 +46,7 @@ struct mlxsw_sp_router {
 	const struct mlxsw_sp_ipip_ops **ipip_ops_arr;
 	u32 adj_discard_index;
 	bool adj_discard_index_valid;
+	struct mlxsw_sp_router_nve_decap nve_decap_config;
 };
 
 struct mlxsw_sp_rif_ipip_lb;
-- 
2.24.1


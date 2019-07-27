Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03DBC77ACA
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 19:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387999AbfG0RgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 13:36:09 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41133 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387665AbfG0RgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 13:36:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B20F9210A8;
        Sat, 27 Jul 2019 13:36:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 27 Jul 2019 13:36:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=m+64/mtZDsTXHj+Kh
        8RNwAlUUkWZCknSe54m+P0rsqY=; b=n7lo3Sw3aXpQEFvOcbRdPEtSZmeh8fzaa
        q2ItyX+tkJ6AuXnHx08Gm1V0rcosdkTNHpAi/BPiFLK6gNBHfZ91QxQfa5oGpQEV
        nbjqMg67Zjq9mOs4PofiL2o6e8VNYH+I/Xl238v9H4jbmsbc5ofRUJaf/JvUA5Er
        e192VL5c9PCyxKLiUxQ68nfFnUoOT6AemgI+hO2i5qcnsBKr4n+mmfc5ory3MOX+
        K5r9KvloUukFrF6qkf21jA3o2l5PSFLBlH8rG5/GMbCXeDoa+MGl6ZRzqh/Setw6
        vbSJYlbPcKeqxipG47P0Uk5ga1vjcM76SUNq55aBQl8j8iGxAJj1g==
X-ME-Sender: <xms:h4s8XYCeyxnazb18XQNMIm_9YaR-dFtHFFXLXKalFKoQSWxSMQanxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeeigdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejjedrudefkedrvdegledrvddtleenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:h4s8XbEwyhynsWt_TUNR1-HdCMOuWgVGFwJ2ySHH1g4qzx1Wqg_dbw>
    <xmx:h4s8XW_UE7Yyx8B9kL7Vkm6gCI4AeHuN709-1GEQ7Apv4FW8-gE0jA>
    <xmx:h4s8XRY6O7C5meNMiTLmaYOQ1IETjkFJVyyh9EKe7cCD7gvaFLE9Ug>
    <xmx:h4s8XbHqSUv4ugxFqQvGiOjSMRiGaxgzLCQg2iDlCA44coQ5ouenzw>
Received: from splinter.mtl.com (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9620F80060;
        Sat, 27 Jul 2019 13:36:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] mlxsw: spectrum_ptp: Increase parsing depth when PTP is enabled
Date:   Sat, 27 Jul 2019 20:35:32 +0300
Message-Id: <20190727173532.7231-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Spectrum systems have a configurable limit on how far into the packet they
parse. By default, the limit is 96 bytes.

An IPv6 PTP packet is layered as Ethernet/IPv6/UDP (14+40+8 bytes), and
sequence ID of a PTP event is only available 32 bytes into payload, for a
total of 94 bytes. When an additional 802.1q header is present as
well (such as when ptp4l is running on a VLAN port), the parsing limit is
exceeded. Such packets are not recognized as PTP, and are not timestamped.

Therefore generalize the current VXLAN-specific parsing depth setting to
allow reference-counted requests from other modules as well. Keep it in the
VXLAN module, because the MPRS register also configures UDP destination
port number used for VXLAN, and is thus closely tied to the VXLAN code
anyway.

Then invoke the new interfaces from both VXLAN (in obvious places), as well
as from PTP code, when the (global) timestamping configuration changes from
disabled to enabled or vice versa.

Fixes: 8748642751ed ("mlxsw: spectrum: PTP: Support SIOCGHWTSTAMP, SIOCSHWTSTAMP ioctls")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  4 +
 .../ethernet/mellanox/mlxsw/spectrum_nve.c    |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_nve.h    |  1 +
 .../mellanox/mlxsw/spectrum_nve_vxlan.c       | 76 ++++++++++++++-----
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 17 +++++
 5 files changed, 82 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 131f62ce9297..6664119fb0c8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -951,4 +951,8 @@ void mlxsw_sp_port_nve_fini(struct mlxsw_sp_port *mlxsw_sp_port);
 int mlxsw_sp_nve_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_nve_fini(struct mlxsw_sp *mlxsw_sp);
 
+/* spectrum_nve_vxlan.c */
+int mlxsw_sp_nve_inc_parsing_depth_get(struct mlxsw_sp *mlxsw_sp);
+void mlxsw_sp_nve_inc_parsing_depth_put(struct mlxsw_sp *mlxsw_sp);
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
index 1df164a4b06d..17f334b46c40 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
@@ -775,6 +775,7 @@ static void mlxsw_sp_nve_tunnel_fini(struct mlxsw_sp *mlxsw_sp)
 		ops->fini(nve);
 		mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
 				   nve->tunnel_index);
+		memset(&nve->config, 0, sizeof(nve->config));
 	}
 	nve->num_nve_tunnels--;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
index 0035640156a1..12f664f42f21 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
@@ -29,6 +29,7 @@ struct mlxsw_sp_nve {
 	unsigned int num_max_mc_entries[MLXSW_SP_L3_PROTO_MAX];
 	u32 tunnel_index;
 	u16 ul_rif_index;	/* Reserved for Spectrum */
+	unsigned int inc_parsing_depth_refs;
 };
 
 struct mlxsw_sp_nve_ops {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
index 93ccd9fc2266..05517c7feaa5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
@@ -103,9 +103,9 @@ static void mlxsw_sp_nve_vxlan_config(const struct mlxsw_sp_nve *nve,
 	config->udp_dport = cfg->dst_port;
 }
 
-static int mlxsw_sp_nve_parsing_set(struct mlxsw_sp *mlxsw_sp,
-				    unsigned int parsing_depth,
-				    __be16 udp_dport)
+static int __mlxsw_sp_nve_parsing_set(struct mlxsw_sp *mlxsw_sp,
+				      unsigned int parsing_depth,
+				      __be16 udp_dport)
 {
 	char mprs_pl[MLXSW_REG_MPRS_LEN];
 
@@ -113,6 +113,56 @@ static int mlxsw_sp_nve_parsing_set(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mprs), mprs_pl);
 }
 
+static int mlxsw_sp_nve_parsing_set(struct mlxsw_sp *mlxsw_sp,
+				    __be16 udp_dport)
+{
+	int parsing_depth = mlxsw_sp->nve->inc_parsing_depth_refs ?
+				MLXSW_SP_NVE_VXLAN_PARSING_DEPTH :
+				MLXSW_SP_NVE_DEFAULT_PARSING_DEPTH;
+
+	return __mlxsw_sp_nve_parsing_set(mlxsw_sp, parsing_depth, udp_dport);
+}
+
+static int
+__mlxsw_sp_nve_inc_parsing_depth_get(struct mlxsw_sp *mlxsw_sp,
+				     __be16 udp_dport)
+{
+	int err;
+
+	mlxsw_sp->nve->inc_parsing_depth_refs++;
+
+	err = mlxsw_sp_nve_parsing_set(mlxsw_sp, udp_dport);
+	if (err)
+		goto err_nve_parsing_set;
+	return 0;
+
+err_nve_parsing_set:
+	mlxsw_sp->nve->inc_parsing_depth_refs--;
+	return err;
+}
+
+static void
+__mlxsw_sp_nve_inc_parsing_depth_put(struct mlxsw_sp *mlxsw_sp,
+				     __be16 udp_dport)
+{
+	mlxsw_sp->nve->inc_parsing_depth_refs--;
+	mlxsw_sp_nve_parsing_set(mlxsw_sp, udp_dport);
+}
+
+int mlxsw_sp_nve_inc_parsing_depth_get(struct mlxsw_sp *mlxsw_sp)
+{
+	__be16 udp_dport = mlxsw_sp->nve->config.udp_dport;
+
+	return __mlxsw_sp_nve_inc_parsing_depth_get(mlxsw_sp, udp_dport);
+}
+
+void mlxsw_sp_nve_inc_parsing_depth_put(struct mlxsw_sp *mlxsw_sp)
+{
+	__be16 udp_dport = mlxsw_sp->nve->config.udp_dport;
+
+	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, udp_dport);
+}
+
 static void
 mlxsw_sp_nve_vxlan_config_prepare(char *tngcr_pl,
 				  const struct mlxsw_sp_nve_config *config)
@@ -176,9 +226,7 @@ static int mlxsw_sp1_nve_vxlan_init(struct mlxsw_sp_nve *nve,
 	struct mlxsw_sp *mlxsw_sp = nve->mlxsw_sp;
 	int err;
 
-	err = mlxsw_sp_nve_parsing_set(mlxsw_sp,
-				       MLXSW_SP_NVE_VXLAN_PARSING_DEPTH,
-				       config->udp_dport);
+	err = __mlxsw_sp_nve_inc_parsing_depth_get(mlxsw_sp, config->udp_dport);
 	if (err)
 		return err;
 
@@ -203,8 +251,7 @@ static int mlxsw_sp1_nve_vxlan_init(struct mlxsw_sp_nve *nve,
 err_rtdp_set:
 	mlxsw_sp1_nve_vxlan_config_clear(mlxsw_sp);
 err_config_set:
-	mlxsw_sp_nve_parsing_set(mlxsw_sp, MLXSW_SP_NVE_DEFAULT_PARSING_DEPTH,
-				 config->udp_dport);
+	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, 0);
 	return err;
 }
 
@@ -216,8 +263,7 @@ static void mlxsw_sp1_nve_vxlan_fini(struct mlxsw_sp_nve *nve)
 	mlxsw_sp_router_nve_demote_decap(mlxsw_sp, config->ul_tb_id,
 					 config->ul_proto, &config->ul_sip);
 	mlxsw_sp1_nve_vxlan_config_clear(mlxsw_sp);
-	mlxsw_sp_nve_parsing_set(mlxsw_sp, MLXSW_SP_NVE_DEFAULT_PARSING_DEPTH,
-				 config->udp_dport);
+	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, 0);
 }
 
 static int
@@ -320,9 +366,7 @@ static int mlxsw_sp2_nve_vxlan_init(struct mlxsw_sp_nve *nve,
 	struct mlxsw_sp *mlxsw_sp = nve->mlxsw_sp;
 	int err;
 
-	err = mlxsw_sp_nve_parsing_set(mlxsw_sp,
-				       MLXSW_SP_NVE_VXLAN_PARSING_DEPTH,
-				       config->udp_dport);
+	err = __mlxsw_sp_nve_inc_parsing_depth_get(mlxsw_sp, config->udp_dport);
 	if (err)
 		return err;
 
@@ -348,8 +392,7 @@ static int mlxsw_sp2_nve_vxlan_init(struct mlxsw_sp_nve *nve,
 err_rtdp_set:
 	mlxsw_sp2_nve_vxlan_config_clear(mlxsw_sp);
 err_config_set:
-	mlxsw_sp_nve_parsing_set(mlxsw_sp, MLXSW_SP_NVE_DEFAULT_PARSING_DEPTH,
-				 config->udp_dport);
+	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, 0);
 	return err;
 }
 
@@ -361,8 +404,7 @@ static void mlxsw_sp2_nve_vxlan_fini(struct mlxsw_sp_nve *nve)
 	mlxsw_sp_router_nve_demote_decap(mlxsw_sp, config->ul_tb_id,
 					 config->ul_proto, &config->ul_sip);
 	mlxsw_sp2_nve_vxlan_config_clear(mlxsw_sp);
-	mlxsw_sp_nve_parsing_set(mlxsw_sp, MLXSW_SP_NVE_DEFAULT_PARSING_DEPTH,
-				 config->udp_dport);
+	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, 0);
 }
 
 const struct mlxsw_sp_nve_ops mlxsw_sp2_nve_vxlan_ops = {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index bd9c2bc2d5d6..4b352a71f76e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -979,19 +979,36 @@ static int mlxsw_sp1_ptp_mtpppc_update(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_port *tmp;
+	u16 orig_ing_types = 0;
+	u16 orig_egr_types = 0;
 	int i;
+	int err;
 
 	/* MTPPPC configures timestamping globally, not per port. Find the
 	 * configuration that contains all configured timestamping requests.
 	 */
 	for (i = 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++) {
 		tmp = mlxsw_sp->ports[i];
+		if (tmp) {
+			orig_ing_types |= tmp->ptp.ing_types;
+			orig_egr_types |= tmp->ptp.egr_types;
+		}
 		if (tmp && tmp != mlxsw_sp_port) {
 			ing_types |= tmp->ptp.ing_types;
 			egr_types |= tmp->ptp.egr_types;
 		}
 	}
 
+	if ((ing_types || egr_types) && !(orig_egr_types || orig_egr_types)) {
+		err = mlxsw_sp_nve_inc_parsing_depth_get(mlxsw_sp);
+		if (err) {
+			netdev_err(mlxsw_sp_port->dev, "Failed to increase parsing depth");
+			return err;
+		}
+	}
+	if (!(ing_types || egr_types) && (orig_egr_types || orig_egr_types))
+		mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp);
+
 	return mlxsw_sp1_ptp_mtpppc_set(mlxsw_sp_port->mlxsw_sp,
 				       ing_types, egr_types);
 }
-- 
2.21.0


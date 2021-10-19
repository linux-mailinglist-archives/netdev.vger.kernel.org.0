Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D479432C2E
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhJSDXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhJSDXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 23:23:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F1EA6135A;
        Tue, 19 Oct 2021 03:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634613651;
        bh=qGjDJFy2mBPZkw0yd6WlCJ2BViGL7Dvg/V6yLpoZlKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OfqIKNqQ6emVuUB0wEcXPw088XmtnSYc4LP/mdzyzX6S80knwtib+szFjmh85z2v8
         7ohRAf8w1QSy8wfhOTgkGdi0qha0WgPHquXBST3E3mXlV+7bsCv4eFtEU1CiDk92wq
         H3FXNp3pbQ09qMcunlj1+cDso4EAXxJi6VzRVyLH25eb4TEo5orqYBwscDthYjhPOU
         luzOocBhFXIMqNL3kEzpaw4kNjIogbpgnudDmO6JCGPpte9IJqi13nOHYH6bJutX5+
         mFDWQNcav8LLgfpwY0XGg19GyMsVBjTYhjt6ctWuhmbDdCMeOJLrHtuN8XRJmemUhZ
         3gKwTcAs//zFQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/13] net/mlx5: Add support to create match definer
Date:   Mon, 18 Oct 2021 20:20:37 -0700
Message-Id: <20211019032047.55660-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019032047.55660-1-saeed@kernel.org>
References: <20211019032047.55660-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Introduce new APIs to create and destroy flow matcher
for given format id.

Flow match definer object is used for defining the fields and
mask used for the hash calculation. User should mask the desired
fields like done in the match criteria.

This object is assigned to flow group of type hash. In this flow
group type, packets lookup is done based on the hash result.

This patch also adds the required bits to create such flow group.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  57 ++++
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.h  |   4 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  46 +++
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |   5 +
 .../mellanox/mlx5/core/steering/fs_dr.c       |  15 +
 include/linux/mlx5/fs.h                       |   8 +
 include/linux/mlx5/mlx5_ifc.h                 | 272 ++++++++++++++++--
 7 files changed, 380 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index caefdb7dfefe..2c82dc118460 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -185,6 +185,20 @@ static int mlx5_cmd_set_slave_root_fdb(struct mlx5_core_dev *master,
 	return mlx5_cmd_exec(slave, in, sizeof(in), out, sizeof(out));
 }
 
+static int
+mlx5_cmd_stub_destroy_match_definer(struct mlx5_flow_root_namespace *ns,
+				    int definer_id)
+{
+	return 0;
+}
+
+static int
+mlx5_cmd_stub_create_match_definer(struct mlx5_flow_root_namespace *ns,
+				   u16 format_id, u32 *match_mask)
+{
+	return 0;
+}
+
 static int mlx5_cmd_update_root_ft(struct mlx5_flow_root_namespace *ns,
 				   struct mlx5_flow_table *ft, u32 underlay_qpn,
 				   bool disconnect)
@@ -909,6 +923,45 @@ static void mlx5_cmd_modify_header_dealloc(struct mlx5_flow_root_namespace *ns,
 	mlx5_cmd_exec_in(dev, dealloc_modify_header_context, in);
 }
 
+static int mlx5_cmd_destroy_match_definer(struct mlx5_flow_root_namespace *ns,
+					  int definer_id)
+{
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_OBJ_TYPE_MATCH_DEFINER);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, definer_id);
+
+	return mlx5_cmd_exec(ns->dev, in, sizeof(in), out, sizeof(out));
+}
+
+static int mlx5_cmd_create_match_definer(struct mlx5_flow_root_namespace *ns,
+					 u16 format_id, u32 *match_mask)
+{
+	u32 out[MLX5_ST_SZ_DW(create_match_definer_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(create_match_definer_in)] = {};
+	struct mlx5_core_dev *dev = ns->dev;
+	void *ptr;
+	int err;
+
+	MLX5_SET(create_match_definer_in, in, general_obj_in_cmd_hdr.opcode,
+		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(create_match_definer_in, in, general_obj_in_cmd_hdr.obj_type,
+		 MLX5_OBJ_TYPE_MATCH_DEFINER);
+
+	ptr = MLX5_ADDR_OF(create_match_definer_in, in, obj_context);
+	MLX5_SET(match_definer, ptr, format_id, format_id);
+
+	ptr = MLX5_ADDR_OF(match_definer, ptr, match_mask);
+	memcpy(ptr, match_mask, MLX5_FLD_SZ_BYTES(match_definer, match_mask));
+
+	err = mlx5_cmd_exec_inout(dev, create_match_definer, in, out);
+	return err ? err : MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+}
+
 static const struct mlx5_flow_cmds mlx5_flow_cmds = {
 	.create_flow_table = mlx5_cmd_create_flow_table,
 	.destroy_flow_table = mlx5_cmd_destroy_flow_table,
@@ -923,6 +976,8 @@ static const struct mlx5_flow_cmds mlx5_flow_cmds = {
 	.packet_reformat_dealloc = mlx5_cmd_packet_reformat_dealloc,
 	.modify_header_alloc = mlx5_cmd_modify_header_alloc,
 	.modify_header_dealloc = mlx5_cmd_modify_header_dealloc,
+	.create_match_definer = mlx5_cmd_create_match_definer,
+	.destroy_match_definer = mlx5_cmd_destroy_match_definer,
 	.set_peer = mlx5_cmd_stub_set_peer,
 	.create_ns = mlx5_cmd_stub_create_ns,
 	.destroy_ns = mlx5_cmd_stub_destroy_ns,
@@ -942,6 +997,8 @@ static const struct mlx5_flow_cmds mlx5_flow_cmd_stubs = {
 	.packet_reformat_dealloc = mlx5_cmd_stub_packet_reformat_dealloc,
 	.modify_header_alloc = mlx5_cmd_stub_modify_header_alloc,
 	.modify_header_dealloc = mlx5_cmd_stub_modify_header_dealloc,
+	.create_match_definer = mlx5_cmd_stub_create_match_definer,
+	.destroy_match_definer = mlx5_cmd_stub_destroy_match_definer,
 	.set_peer = mlx5_cmd_stub_set_peer,
 	.create_ns = mlx5_cmd_stub_create_ns,
 	.destroy_ns = mlx5_cmd_stub_destroy_ns,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
index 5ecd33cdc087..220ec632d35a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
@@ -97,6 +97,10 @@ struct mlx5_flow_cmds {
 
 	int (*create_ns)(struct mlx5_flow_root_namespace *ns);
 	int (*destroy_ns)(struct mlx5_flow_root_namespace *ns);
+	int (*create_match_definer)(struct mlx5_flow_root_namespace *ns,
+				    u16 format_id, u32 *match_mask);
+	int (*destroy_match_definer)(struct mlx5_flow_root_namespace *ns,
+				     int definer_id);
 };
 
 int mlx5_cmd_fc_alloc(struct mlx5_core_dev *dev, u32 *id);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 8d8696f7c3f5..873efde0d458 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -3250,6 +3250,52 @@ void mlx5_packet_reformat_dealloc(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL(mlx5_packet_reformat_dealloc);
 
+int mlx5_get_match_definer_id(struct mlx5_flow_definer *definer)
+{
+	return definer->id;
+}
+
+struct mlx5_flow_definer *
+mlx5_create_match_definer(struct mlx5_core_dev *dev,
+			  enum mlx5_flow_namespace_type ns_type, u16 format_id,
+			  u32 *match_mask)
+{
+	struct mlx5_flow_root_namespace *root;
+	struct mlx5_flow_definer *definer;
+	int id;
+
+	root = get_root_namespace(dev, ns_type);
+	if (!root)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	definer = kzalloc(sizeof(*definer), GFP_KERNEL);
+	if (!definer)
+		return ERR_PTR(-ENOMEM);
+
+	definer->ns_type = ns_type;
+	id = root->cmds->create_match_definer(root, format_id, match_mask);
+	if (id < 0) {
+		mlx5_core_warn(root->dev, "Failed to create match definer (%d)\n", id);
+		kfree(definer);
+		return ERR_PTR(id);
+	}
+	definer->id = id;
+	return definer;
+}
+
+void mlx5_destroy_match_definer(struct mlx5_core_dev *dev,
+				struct mlx5_flow_definer *definer)
+{
+	struct mlx5_flow_root_namespace *root;
+
+	root = get_root_namespace(dev, definer->ns_type);
+	if (WARN_ON(!root))
+		return;
+
+	root->cmds->destroy_match_definer(root, definer->id);
+	kfree(definer);
+}
+
 int mlx5_flow_namespace_set_peer(struct mlx5_flow_root_namespace *ns,
 				 struct mlx5_flow_root_namespace *peer_ns)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index 79d37530afb3..7711db245c63 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -49,6 +49,11 @@
 #define FDB_TC_MAX_PRIO 16
 #define FDB_TC_LEVELS_PER_PRIO 2
 
+struct mlx5_flow_definer {
+	enum mlx5_flow_namespace_type ns_type;
+	u32 id;
+};
+
 struct mlx5_modify_hdr {
 	enum mlx5_flow_namespace_type ns_type;
 	union {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 230e920e3845..2632d5ae9bc0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -625,6 +625,19 @@ static void mlx5_cmd_dr_modify_header_dealloc(struct mlx5_flow_root_namespace *n
 	mlx5dr_action_destroy(modify_hdr->action.dr_action);
 }
 
+static int
+mlx5_cmd_dr_destroy_match_definer(struct mlx5_flow_root_namespace *ns,
+				  int definer_id)
+{
+	return -EOPNOTSUPP;
+}
+
+static int mlx5_cmd_dr_create_match_definer(struct mlx5_flow_root_namespace *ns,
+					    u16 format_id, u32 *match_mask)
+{
+	return -EOPNOTSUPP;
+}
+
 static int mlx5_cmd_dr_delete_fte(struct mlx5_flow_root_namespace *ns,
 				  struct mlx5_flow_table *ft,
 				  struct fs_fte *fte)
@@ -727,6 +740,8 @@ static const struct mlx5_flow_cmds mlx5_flow_cmds_dr = {
 	.packet_reformat_dealloc = mlx5_cmd_dr_packet_reformat_dealloc,
 	.modify_header_alloc = mlx5_cmd_dr_modify_header_alloc,
 	.modify_header_dealloc = mlx5_cmd_dr_modify_header_dealloc,
+	.create_match_definer = mlx5_cmd_dr_create_match_definer,
+	.destroy_match_definer = mlx5_cmd_dr_destroy_match_definer,
 	.set_peer = mlx5_cmd_dr_set_peer,
 	.create_ns = mlx5_cmd_dr_create_ns,
 	.destroy_ns = mlx5_cmd_dr_destroy_ns,
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 259fcc168340..7a43fec63a35 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -98,6 +98,7 @@ enum {
 
 struct mlx5_pkt_reformat;
 struct mlx5_modify_hdr;
+struct mlx5_flow_definer;
 struct mlx5_flow_table;
 struct mlx5_flow_group;
 struct mlx5_flow_namespace;
@@ -258,6 +259,13 @@ struct mlx5_modify_hdr *mlx5_modify_header_alloc(struct mlx5_core_dev *dev,
 						 void *modify_actions);
 void mlx5_modify_header_dealloc(struct mlx5_core_dev *dev,
 				struct mlx5_modify_hdr *modify_hdr);
+struct mlx5_flow_definer *
+mlx5_create_match_definer(struct mlx5_core_dev *dev,
+			  enum mlx5_flow_namespace_type ns_type, u16 format_id,
+			  u32 *match_mask);
+void mlx5_destroy_match_definer(struct mlx5_core_dev *dev,
+				struct mlx5_flow_definer *definer);
+int mlx5_get_match_definer_id(struct mlx5_flow_definer *definer);
 
 struct mlx5_pkt_reformat_params {
 	int type;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index db1d9c69c1fa..8f41145bc6ef 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -94,6 +94,7 @@ enum {
 enum {
 	MLX5_OBJ_TYPE_GENEVE_TLV_OPT = 0x000b,
 	MLX5_OBJ_TYPE_VIRTIO_NET_Q = 0x000d,
+	MLX5_OBJ_TYPE_MATCH_DEFINER = 0x0018,
 	MLX5_OBJ_TYPE_MKEY = 0xff01,
 	MLX5_OBJ_TYPE_QP = 0xff02,
 	MLX5_OBJ_TYPE_PSV = 0xff03,
@@ -1731,7 +1732,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         flex_parser_id_outer_first_mpls_over_gre[0x4];
 	u8         flex_parser_id_outer_first_mpls_over_udp_label[0x4];
 
-	u8	   reserved_at_6e0[0x10];
+	u8         max_num_match_definer[0x10];
 	u8	   sf_base_id[0x10];
 
 	u8         flex_parser_id_gtpu_dw_2[0x4];
@@ -1746,7 +1747,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8	   reserved_at_760[0x20];
 	u8	   vhca_tunnel_commands[0x40];
-	u8	   reserved_at_7c0[0x40];
+	u8         match_definer_format_supported[0x40];
 };
 
 struct mlx5_ifc_cmd_hca_cap_2_bits {
@@ -5666,6 +5667,236 @@ struct mlx5_ifc_query_fte_in_bits {
 	u8         reserved_at_120[0xe0];
 };
 
+struct mlx5_ifc_match_definer_format_0_bits {
+	u8         reserved_at_0[0x100];
+
+	u8         metadata_reg_c_0[0x20];
+
+	u8         metadata_reg_c_1[0x20];
+
+	u8         outer_dmac_47_16[0x20];
+
+	u8         outer_dmac_15_0[0x10];
+	u8         outer_ethertype[0x10];
+
+	u8         reserved_at_180[0x1];
+	u8         sx_sniffer[0x1];
+	u8         functional_lb[0x1];
+	u8         outer_ip_frag[0x1];
+	u8         outer_qp_type[0x2];
+	u8         outer_encap_type[0x2];
+	u8         port_number[0x2];
+	u8         outer_l3_type[0x2];
+	u8         outer_l4_type[0x2];
+	u8         outer_first_vlan_type[0x2];
+	u8         outer_first_vlan_prio[0x3];
+	u8         outer_first_vlan_cfi[0x1];
+	u8         outer_first_vlan_vid[0xc];
+
+	u8         outer_l4_type_ext[0x4];
+	u8         reserved_at_1a4[0x2];
+	u8         outer_ipsec_layer[0x2];
+	u8         outer_l2_type[0x2];
+	u8         force_lb[0x1];
+	u8         outer_l2_ok[0x1];
+	u8         outer_l3_ok[0x1];
+	u8         outer_l4_ok[0x1];
+	u8         outer_second_vlan_type[0x2];
+	u8         outer_second_vlan_prio[0x3];
+	u8         outer_second_vlan_cfi[0x1];
+	u8         outer_second_vlan_vid[0xc];
+
+	u8         outer_smac_47_16[0x20];
+
+	u8         outer_smac_15_0[0x10];
+	u8         inner_ipv4_checksum_ok[0x1];
+	u8         inner_l4_checksum_ok[0x1];
+	u8         outer_ipv4_checksum_ok[0x1];
+	u8         outer_l4_checksum_ok[0x1];
+	u8         inner_l3_ok[0x1];
+	u8         inner_l4_ok[0x1];
+	u8         outer_l3_ok_duplicate[0x1];
+	u8         outer_l4_ok_duplicate[0x1];
+	u8         outer_tcp_cwr[0x1];
+	u8         outer_tcp_ece[0x1];
+	u8         outer_tcp_urg[0x1];
+	u8         outer_tcp_ack[0x1];
+	u8         outer_tcp_psh[0x1];
+	u8         outer_tcp_rst[0x1];
+	u8         outer_tcp_syn[0x1];
+	u8         outer_tcp_fin[0x1];
+};
+
+struct mlx5_ifc_match_definer_format_22_bits {
+	u8         reserved_at_0[0x100];
+
+	u8         outer_ip_src_addr[0x20];
+
+	u8         outer_ip_dest_addr[0x20];
+
+	u8         outer_l4_sport[0x10];
+	u8         outer_l4_dport[0x10];
+
+	u8         reserved_at_160[0x1];
+	u8         sx_sniffer[0x1];
+	u8         functional_lb[0x1];
+	u8         outer_ip_frag[0x1];
+	u8         outer_qp_type[0x2];
+	u8         outer_encap_type[0x2];
+	u8         port_number[0x2];
+	u8         outer_l3_type[0x2];
+	u8         outer_l4_type[0x2];
+	u8         outer_first_vlan_type[0x2];
+	u8         outer_first_vlan_prio[0x3];
+	u8         outer_first_vlan_cfi[0x1];
+	u8         outer_first_vlan_vid[0xc];
+
+	u8         metadata_reg_c_0[0x20];
+
+	u8         outer_dmac_47_16[0x20];
+
+	u8         outer_smac_47_16[0x20];
+
+	u8         outer_smac_15_0[0x10];
+	u8         outer_dmac_15_0[0x10];
+};
+
+struct mlx5_ifc_match_definer_format_23_bits {
+	u8         reserved_at_0[0x100];
+
+	u8         inner_ip_src_addr[0x20];
+
+	u8         inner_ip_dest_addr[0x20];
+
+	u8         inner_l4_sport[0x10];
+	u8         inner_l4_dport[0x10];
+
+	u8         reserved_at_160[0x1];
+	u8         sx_sniffer[0x1];
+	u8         functional_lb[0x1];
+	u8         inner_ip_frag[0x1];
+	u8         inner_qp_type[0x2];
+	u8         inner_encap_type[0x2];
+	u8         port_number[0x2];
+	u8         inner_l3_type[0x2];
+	u8         inner_l4_type[0x2];
+	u8         inner_first_vlan_type[0x2];
+	u8         inner_first_vlan_prio[0x3];
+	u8         inner_first_vlan_cfi[0x1];
+	u8         inner_first_vlan_vid[0xc];
+
+	u8         tunnel_header_0[0x20];
+
+	u8         inner_dmac_47_16[0x20];
+
+	u8         inner_smac_47_16[0x20];
+
+	u8         inner_smac_15_0[0x10];
+	u8         inner_dmac_15_0[0x10];
+};
+
+struct mlx5_ifc_match_definer_format_29_bits {
+	u8         reserved_at_0[0xc0];
+
+	u8         outer_ip_dest_addr[0x80];
+
+	u8         outer_ip_src_addr[0x80];
+
+	u8         outer_l4_sport[0x10];
+	u8         outer_l4_dport[0x10];
+
+	u8         reserved_at_1e0[0x20];
+};
+
+struct mlx5_ifc_match_definer_format_30_bits {
+	u8         reserved_at_0[0xa0];
+
+	u8         outer_ip_dest_addr[0x80];
+
+	u8         outer_ip_src_addr[0x80];
+
+	u8         outer_dmac_47_16[0x20];
+
+	u8         outer_smac_47_16[0x20];
+
+	u8         outer_smac_15_0[0x10];
+	u8         outer_dmac_15_0[0x10];
+};
+
+struct mlx5_ifc_match_definer_format_31_bits {
+	u8         reserved_at_0[0xc0];
+
+	u8         inner_ip_dest_addr[0x80];
+
+	u8         inner_ip_src_addr[0x80];
+
+	u8         inner_l4_sport[0x10];
+	u8         inner_l4_dport[0x10];
+
+	u8         reserved_at_1e0[0x20];
+};
+
+struct mlx5_ifc_match_definer_format_32_bits {
+	u8         reserved_at_0[0xa0];
+
+	u8         inner_ip_dest_addr[0x80];
+
+	u8         inner_ip_src_addr[0x80];
+
+	u8         inner_dmac_47_16[0x20];
+
+	u8         inner_smac_47_16[0x20];
+
+	u8         inner_smac_15_0[0x10];
+	u8         inner_dmac_15_0[0x10];
+};
+
+struct mlx5_ifc_match_definer_bits {
+	u8         modify_field_select[0x40];
+
+	u8         reserved_at_40[0x40];
+
+	u8         reserved_at_80[0x10];
+	u8         format_id[0x10];
+
+	u8         reserved_at_a0[0x160];
+
+	u8         match_mask[16][0x20];
+};
+
+struct mlx5_ifc_general_obj_in_cmd_hdr_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         vhca_tunnel_id[0x10];
+	u8         obj_type[0x10];
+
+	u8         obj_id[0x20];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_general_obj_out_cmd_hdr_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         obj_id[0x20];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_create_match_definer_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+
+	struct mlx5_ifc_match_definer_bits obj_context;
+};
+
+struct mlx5_ifc_create_match_definer_out_bits {
+	struct mlx5_ifc_general_obj_out_cmd_hdr_bits general_obj_out_cmd_hdr;
+};
+
 enum {
 	MLX5_QUERY_FLOW_GROUP_OUT_MATCH_CRITERIA_ENABLE_OUTER_HEADERS    = 0x0,
 	MLX5_QUERY_FLOW_GROUP_OUT_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS  = 0x1,
@@ -8139,6 +8370,11 @@ struct mlx5_ifc_create_flow_group_out_bits {
 	u8         reserved_at_60[0x20];
 };
 
+enum {
+	MLX5_CREATE_FLOW_GROUP_IN_GROUP_TYPE_TCAM_SUBTABLE  = 0x0,
+	MLX5_CREATE_FLOW_GROUP_IN_GROUP_TYPE_HASH_SPLIT     = 0x1,
+};
+
 enum {
 	MLX5_CREATE_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_OUTER_HEADERS     = 0x0,
 	MLX5_CREATE_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS   = 0x1,
@@ -8160,7 +8396,9 @@ struct mlx5_ifc_create_flow_group_in_bits {
 	u8         reserved_at_60[0x20];
 
 	u8         table_type[0x8];
-	u8         reserved_at_88[0x18];
+	u8         reserved_at_88[0x4];
+	u8         group_type[0x4];
+	u8         reserved_at_90[0x10];
 
 	u8         reserved_at_a0[0x8];
 	u8         table_id[0x18];
@@ -8175,7 +8413,10 @@ struct mlx5_ifc_create_flow_group_in_bits {
 
 	u8         end_flow_index[0x20];
 
-	u8         reserved_at_140[0xa0];
+	u8         reserved_at_140[0x10];
+	u8         match_definer_id[0x10];
+
+	u8         reserved_at_160[0x80];
 
 	u8         reserved_at_1e0[0x18];
 	u8         match_criteria_enable[0x8];
@@ -10671,29 +10912,6 @@ struct mlx5_ifc_dealloc_memic_out_bits {
 	u8         reserved_at_40[0x40];
 };
 
-struct mlx5_ifc_general_obj_in_cmd_hdr_bits {
-	u8         opcode[0x10];
-	u8         uid[0x10];
-
-	u8         vhca_tunnel_id[0x10];
-	u8         obj_type[0x10];
-
-	u8         obj_id[0x20];
-
-	u8         reserved_at_60[0x20];
-};
-
-struct mlx5_ifc_general_obj_out_cmd_hdr_bits {
-	u8         status[0x8];
-	u8         reserved_at_8[0x18];
-
-	u8         syndrome[0x20];
-
-	u8         obj_id[0x20];
-
-	u8         reserved_at_60[0x20];
-};
-
 struct mlx5_ifc_umem_bits {
 	u8         reserved_at_0[0x80];
 
-- 
2.31.1


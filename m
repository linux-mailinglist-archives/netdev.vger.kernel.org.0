Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE843093A6
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhA3Jqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:46:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233360AbhA3DIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:08:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACDB464E0C;
        Sat, 30 Jan 2021 02:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973592;
        bh=3nlk6qnjKzLfL18O2D8BmfgJgjn0XCse3stnCHILeNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kv18/5YqOOL/3EiDZ/vcAdq/oND5fspT9HBxFjJ9BJvKuaDXRnREdAV2n8K/0GzIM
         7RMQ5xDyhCuRZnqZ/9NSguQ1qL9MavTn9Ci2dUZOw3dblo84Vnjybz2V+TRov9Jc1Q
         PA1VsEFiDwMyOxXdmZwrIhaX0Ry3ZdAtFfxFKPLEy6wyedveS2uWIp/8bDQEQ49WYO
         HoELxgjsfrV7ETVlpm5Fzb1ONmAdajnPMJZ50J7ehOPAEd3uZ3mFJqZbnQCmUD7SJh
         AuAgb2QLeWcOrKDvR8On/PU72jZkwk0gasesMnZFg1FBjw1apfijTqlrZuiMKN945o
         EjkUG963u4OMw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/11] net/mlx5: DR, Add STEv1 modify header logic
Date:   Fri, 29 Jan 2021 18:26:14 -0800
Message-Id: <20210130022618.317351-8-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210130022618.317351-1-saeed@kernel.org>
References: <20210130022618.317351-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add HW specific modify header fields and logic to STEv1 file.
Since STEv0 and STEv1 modify actions values are different, each
version has its own implementation.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 269 ++++++++++++++++++
 .../mlx5/core/steering/mlx5_ifc_dr_ste_v1.h   |   4 +
 2 files changed, 273 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 02bb3a28cfa1..42b853fa3465 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -95,6 +95,159 @@ enum dr_ste_v1_action_id {
 	DR_STE_V1_ACTION_ID_SPECIAL_ENCAP_L3		= 0x22,
 };
 
+enum {
+	DR_STE_V1_ACTION_MDFY_FLD_L2_OUT_0		= 0x00,
+	DR_STE_V1_ACTION_MDFY_FLD_L2_OUT_1		= 0x01,
+	DR_STE_V1_ACTION_MDFY_FLD_L2_OUT_2		= 0x02,
+	DR_STE_V1_ACTION_MDFY_FLD_SRC_L2_OUT_0		= 0x08,
+	DR_STE_V1_ACTION_MDFY_FLD_SRC_L2_OUT_1		= 0x09,
+	DR_STE_V1_ACTION_MDFY_FLD_L3_OUT_0		= 0x0e,
+	DR_STE_V1_ACTION_MDFY_FLD_L4_OUT_0		= 0x18,
+	DR_STE_V1_ACTION_MDFY_FLD_L4_OUT_1		= 0x19,
+	DR_STE_V1_ACTION_MDFY_FLD_IPV4_OUT_0		= 0x40,
+	DR_STE_V1_ACTION_MDFY_FLD_IPV4_OUT_1		= 0x41,
+	DR_STE_V1_ACTION_MDFY_FLD_IPV6_DST_OUT_0	= 0x44,
+	DR_STE_V1_ACTION_MDFY_FLD_IPV6_DST_OUT_1	= 0x45,
+	DR_STE_V1_ACTION_MDFY_FLD_IPV6_DST_OUT_2	= 0x46,
+	DR_STE_V1_ACTION_MDFY_FLD_IPV6_DST_OUT_3	= 0x47,
+	DR_STE_V1_ACTION_MDFY_FLD_IPV6_SRC_OUT_0	= 0x4c,
+	DR_STE_V1_ACTION_MDFY_FLD_IPV6_SRC_OUT_1	= 0x4d,
+	DR_STE_V1_ACTION_MDFY_FLD_IPV6_SRC_OUT_2	= 0x4e,
+	DR_STE_V1_ACTION_MDFY_FLD_IPV6_SRC_OUT_3	= 0x4f,
+	DR_STE_V1_ACTION_MDFY_FLD_TCP_MISC_0		= 0x5e,
+	DR_STE_V1_ACTION_MDFY_FLD_TCP_MISC_1		= 0x5f,
+	DR_STE_V1_ACTION_MDFY_FLD_METADATA_2_CQE	= 0x7b,
+	DR_STE_V1_ACTION_MDFY_FLD_GNRL_PURPOSE		= 0x7c,
+	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_2		= 0x8c,
+	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_3		= 0x8d,
+	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_4		= 0x8e,
+	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_5		= 0x8f,
+	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_6		= 0x90,
+	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_7		= 0x91,
+};
+
+static const struct mlx5dr_ste_action_modify_field dr_ste_v1_action_modify_field_arr[] = {
+	[MLX5_ACTION_IN_FIELD_OUT_SMAC_47_16] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_SRC_L2_OUT_0, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SMAC_15_0] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_SRC_L2_OUT_1, .start = 16, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_ETHERTYPE] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_L2_OUT_1, .start = 0, .end = 15,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DMAC_47_16] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_L2_OUT_0, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DMAC_15_0] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_L2_OUT_1, .start = 16, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_IP_DSCP] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_L3_OUT_0, .start = 18, .end = 23,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_TCP_FLAGS] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_L4_OUT_1, .start = 16, .end = 24,
+		.l4_type = DR_STE_ACTION_MDFY_TYPE_L4_TCP,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_TCP_SPORT] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_L4_OUT_0, .start = 16, .end = 31,
+		.l4_type = DR_STE_ACTION_MDFY_TYPE_L4_TCP,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_TCP_DPORT] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_L4_OUT_0, .start = 0, .end = 15,
+		.l4_type = DR_STE_ACTION_MDFY_TYPE_L4_TCP,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_IP_TTL] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_L3_OUT_0, .start = 8, .end = 15,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV4,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_IPV6_HOPLIMIT] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_L3_OUT_0, .start = 8, .end = 15,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_UDP_SPORT] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_L4_OUT_0, .start = 16, .end = 31,
+		.l4_type = DR_STE_ACTION_MDFY_TYPE_L4_UDP,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_UDP_DPORT] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_L4_OUT_0, .start = 0, .end = 15,
+		.l4_type = DR_STE_ACTION_MDFY_TYPE_L4_UDP,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_127_96] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_IPV6_SRC_OUT_0, .start = 0, .end = 31,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_95_64] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_IPV6_SRC_OUT_1, .start = 0, .end = 31,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_63_32] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_IPV6_SRC_OUT_2, .start = 0, .end = 31,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_31_0] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_IPV6_SRC_OUT_3, .start = 0, .end = 31,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_127_96] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_IPV6_DST_OUT_0, .start = 0, .end = 31,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_95_64] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_IPV6_DST_OUT_1, .start = 0, .end = 31,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_63_32] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_IPV6_DST_OUT_2, .start = 0, .end = 31,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_31_0] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_IPV6_DST_OUT_3, .start = 0, .end = 31,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SIPV4] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_IPV4_OUT_0, .start = 0, .end = 31,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV4,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DIPV4] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_IPV4_OUT_1, .start = 0, .end = 31,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV4,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_A] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_GNRL_PURPOSE, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_B] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_METADATA_2_CQE, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_0] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_6, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_1] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_7, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_2] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_4, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_3] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_5, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_4] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_2, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_5] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_REGISTER_3, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_TCP_SEQ_NUM] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_TCP_MISC_0, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_TCP_ACK_NUM] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_TCP_MISC_1, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_FIRST_VID] = {
+		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_L2_OUT_2, .start = 0, .end = 15,
+	},
+};
+
 static void dr_ste_v1_set_entry_type(u8 *hw_ste_p, u8 entry_type)
 {
 	MLX5_SET(ste_match_bwc_v1, hw_ste_p, entry_format, entry_type);
@@ -476,6 +629,116 @@ static void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 	dr_ste_v1_set_hit_addr(last_ste, attr->final_icm_addr, 1);
 }
 
+static void dr_ste_v1_set_action_set(u8 *d_action,
+				     u8 hw_field,
+				     u8 shifter,
+				     u8 length,
+				     u32 data)
+{
+	shifter += MLX5_MODIFY_HEADER_V1_QW_OFFSET;
+	MLX5_SET(ste_double_action_set_v1, d_action, action_id, DR_STE_V1_ACTION_ID_SET);
+	MLX5_SET(ste_double_action_set_v1, d_action, destination_dw_offset, hw_field);
+	MLX5_SET(ste_double_action_set_v1, d_action, destination_left_shifter, shifter);
+	MLX5_SET(ste_double_action_set_v1, d_action, destination_length, length);
+	MLX5_SET(ste_double_action_set_v1, d_action, inline_data, data);
+}
+
+static void dr_ste_v1_set_action_add(u8 *d_action,
+				     u8 hw_field,
+				     u8 shifter,
+				     u8 length,
+				     u32 data)
+{
+	shifter += MLX5_MODIFY_HEADER_V1_QW_OFFSET;
+	MLX5_SET(ste_double_action_add_v1, d_action, action_id, DR_STE_V1_ACTION_ID_ADD);
+	MLX5_SET(ste_double_action_add_v1, d_action, destination_dw_offset, hw_field);
+	MLX5_SET(ste_double_action_add_v1, d_action, destination_left_shifter, shifter);
+	MLX5_SET(ste_double_action_add_v1, d_action, destination_length, length);
+	MLX5_SET(ste_double_action_add_v1, d_action, add_value, data);
+}
+
+static void dr_ste_v1_set_action_copy(u8 *d_action,
+				      u8 dst_hw_field,
+				      u8 dst_shifter,
+				      u8 dst_len,
+				      u8 src_hw_field,
+				      u8 src_shifter)
+{
+	dst_shifter += MLX5_MODIFY_HEADER_V1_QW_OFFSET;
+	src_shifter += MLX5_MODIFY_HEADER_V1_QW_OFFSET;
+	MLX5_SET(ste_double_action_copy_v1, d_action, action_id, DR_STE_V1_ACTION_ID_COPY);
+	MLX5_SET(ste_double_action_copy_v1, d_action, destination_dw_offset, dst_hw_field);
+	MLX5_SET(ste_double_action_copy_v1, d_action, destination_left_shifter, dst_shifter);
+	MLX5_SET(ste_double_action_copy_v1, d_action, destination_length, dst_len);
+	MLX5_SET(ste_double_action_copy_v1, d_action, source_dw_offset, src_hw_field);
+	MLX5_SET(ste_double_action_copy_v1, d_action, source_right_shifter, src_shifter);
+}
+
+#define DR_STE_DECAP_L3_ACTION_NUM	8
+#define DR_STE_L2_HDR_MAX_SZ		20
+
+static int dr_ste_v1_set_action_decap_l3_list(void *data,
+					      u32 data_sz,
+					      u8 *hw_action,
+					      u32 hw_action_sz,
+					      u16 *used_hw_action_num)
+{
+	u8 padded_data[DR_STE_L2_HDR_MAX_SZ] = {};
+	void *data_ptr = padded_data;
+	u16 used_actions = 0;
+	u32 inline_data_sz;
+	u32 i;
+
+	if (hw_action_sz / DR_STE_ACTION_DOUBLE_SZ < DR_STE_DECAP_L3_ACTION_NUM)
+		return -EINVAL;
+
+	memcpy(padded_data, data, data_sz);
+
+	/* Remove L2L3 outer headers */
+	MLX5_SET(ste_single_action_remove_header_v1, hw_action, action_id,
+		 DR_STE_V1_ACTION_ID_REMOVE_HEADER_TO_HEADER);
+	MLX5_SET(ste_single_action_remove_header_v1, hw_action, decap, 1);
+	MLX5_SET(ste_single_action_remove_header_v1, hw_action, vni_to_cqe, 1);
+	MLX5_SET(ste_single_action_remove_header_v1, hw_action, end_anchor,
+		 DR_STE_HEADER_ANCHOR_INNER_IPV6_IPV4);
+	hw_action += DR_STE_ACTION_DOUBLE_SZ;
+	used_actions++; /* Remove and NOP are a single double action */
+
+	inline_data_sz =
+		MLX5_FLD_SZ_BYTES(ste_double_action_insert_with_inline_v1, inline_data);
+
+	/* Add the new header inline + 2 extra bytes */
+	for (i = 0; i < data_sz / inline_data_sz + 1; i++) {
+		void *addr_inline;
+
+		MLX5_SET(ste_double_action_insert_with_inline_v1, hw_action, action_id,
+			 DR_STE_V1_ACTION_ID_INSERT_INLINE);
+		/* The hardware expects here offset to words (2 bytes) */
+		MLX5_SET(ste_double_action_insert_with_inline_v1, hw_action, start_offset,
+			 i * 2);
+
+		/* Copy bytes one by one to avoid endianness problem */
+		addr_inline = MLX5_ADDR_OF(ste_double_action_insert_with_inline_v1,
+					   hw_action, inline_data);
+		memcpy(addr_inline, data_ptr, inline_data_sz);
+		hw_action += DR_STE_ACTION_DOUBLE_SZ;
+		data_ptr += inline_data_sz;
+		used_actions++;
+	}
+
+	/* Remove 2 extra bytes */
+	MLX5_SET(ste_single_action_remove_header_size_v1, hw_action, action_id,
+		 DR_STE_V1_ACTION_ID_REMOVE_BY_SIZE);
+	MLX5_SET(ste_single_action_remove_header_size_v1, hw_action, start_offset, data_sz / 2);
+	/* The hardware expects here size in words (2 bytes) */
+	MLX5_SET(ste_single_action_remove_header_size_v1, hw_action, remove_size, 1);
+	used_actions++;
+
+	*used_hw_action_num = used_actions;
+
+	return 0;
+}
+
 static void dr_ste_v1_build_eth_l2_src_dst_bit_mask(struct mlx5dr_match_param *value,
 						    bool inner, u8 *bit_mask)
 {
@@ -1339,4 +1602,10 @@ struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	/* Actions */
 	.set_actions_rx			= &dr_ste_v1_set_actions_rx,
 	.set_actions_tx			= &dr_ste_v1_set_actions_tx,
+	.modify_field_arr_sz		= ARRAY_SIZE(dr_ste_v1_action_modify_field_arr),
+	.modify_field_arr		= dr_ste_v1_action_modify_field_arr,
+	.set_action_set			= &dr_ste_v1_set_action_set,
+	.set_action_add			= &dr_ste_v1_set_action_add,
+	.set_action_copy		= &dr_ste_v1_set_action_copy,
+	.set_action_decap_l3_list	= &dr_ste_v1_set_action_decap_l3_list,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
index 31ecdb673625..34c2bd17a8b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
@@ -4,6 +4,10 @@
 #ifndef MLX5_IFC_DR_STE_V1_H
 #define MLX5_IFC_DR_STE_V1_H
 
+enum mlx5_ifc_ste_v1_modify_hdr_offset {
+	MLX5_MODIFY_HEADER_V1_QW_OFFSET = 0x20,
+};
+
 struct mlx5_ifc_ste_single_action_flow_tag_v1_bits {
 	u8         action_id[0x8];
 	u8         flow_tag[0x18];
-- 
2.29.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDD73092DE
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbhA3E0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 23:26:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233621AbhA3DyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:54:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CC5564E0F;
        Sat, 30 Jan 2021 02:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973591;
        bh=MAuAPMgcc3tJ5ZgNxIXGOb15at4Q+dtObAuDUjilqDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RnFafKoJIdZUt83aZi8qH48HY8YwRNqUNoRbONYa4cxl8UxuCcCSDTWR7bVHoJJdI
         gKbSXlDQkD5l/tV6zGADD/rRJ5Tcz4qwMo7KfBT73KL6IxU0PU0aELy9H06XvLt8n8
         9bFJ7WP/rbEtZR5WT2RILqHYmS0mbkJneNFi7mT0BumKgX0Rxy3DnJFpY0orniB26E
         +hrTLQUFbGrs+UqQ6Xo0W3gPpaawAdtEpJmxtmaNDeRlHrN7IwrYfk9IhCGulXLyNJ
         ISm5FBGsuMjKfGMal86+wNGIWsm+4JJOZp5vFEUNpK4Rwg6KjTQHR5prEbxYBAgBCo
         OSNIYZPJOE4GQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/11] net/mlx5: DR, Add STEv1 action apply logic
Date:   Fri, 29 Jan 2021 18:26:13 -0800
Message-Id: <20210130022618.317351-7-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210130022618.317351-1-saeed@kernel.org>
References: <20210130022618.317351-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add HW specific action apply logic to STEv1.
Since STEv0 and STEv1 actions format is different, each
version has its implementation.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 358 ++++++++++++++++++
 .../mlx5/core/steering/mlx5_ifc_dr_ste_v1.h   | 100 +++++
 2 files changed, 458 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 522909f1cab6..02bb3a28cfa1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -55,6 +55,51 @@ enum {
 	DR_STE_V1_LU_TYPE_DONT_CARE			= MLX5DR_STE_LU_TYPE_DONT_CARE,
 };
 
+enum dr_ste_v1_header_anchors {
+	DR_STE_HEADER_ANCHOR_START_OUTER		= 0x00,
+	DR_STE_HEADER_ANCHOR_1ST_VLAN			= 0x02,
+	DR_STE_HEADER_ANCHOR_IPV6_IPV4			= 0x07,
+	DR_STE_HEADER_ANCHOR_INNER_MAC			= 0x13,
+	DR_STE_HEADER_ANCHOR_INNER_IPV6_IPV4		= 0x19,
+};
+
+enum dr_ste_v1_action_size {
+	DR_STE_ACTION_SINGLE_SZ = 4,
+	DR_STE_ACTION_DOUBLE_SZ = 8,
+	DR_STE_ACTION_TRIPLE_SZ = 12,
+};
+
+enum dr_ste_v1_action_insert_ptr_attr {
+	DR_STE_V1_ACTION_INSERT_PTR_ATTR_NONE = 0,  /* Regular push header (e.g. push vlan) */
+	DR_STE_V1_ACTION_INSERT_PTR_ATTR_ENCAP = 1, /* Encapsulation / Tunneling */
+	DR_STE_V1_ACTION_INSERT_PTR_ATTR_ESP = 2,   /* IPsec */
+};
+
+enum dr_ste_v1_action_id {
+	DR_STE_V1_ACTION_ID_NOP				= 0x00,
+	DR_STE_V1_ACTION_ID_COPY			= 0x05,
+	DR_STE_V1_ACTION_ID_SET				= 0x06,
+	DR_STE_V1_ACTION_ID_ADD				= 0x07,
+	DR_STE_V1_ACTION_ID_REMOVE_BY_SIZE		= 0x08,
+	DR_STE_V1_ACTION_ID_REMOVE_HEADER_TO_HEADER	= 0x09,
+	DR_STE_V1_ACTION_ID_INSERT_INLINE		= 0x0a,
+	DR_STE_V1_ACTION_ID_INSERT_POINTER		= 0x0b,
+	DR_STE_V1_ACTION_ID_FLOW_TAG			= 0x0c,
+	DR_STE_V1_ACTION_ID_QUEUE_ID_SEL		= 0x0d,
+	DR_STE_V1_ACTION_ID_ACCELERATED_LIST		= 0x0e,
+	DR_STE_V1_ACTION_ID_MODIFY_LIST			= 0x0f,
+	DR_STE_V1_ACTION_ID_TRAILER			= 0x13,
+	DR_STE_V1_ACTION_ID_COUNTER_ID			= 0x14,
+	DR_STE_V1_ACTION_ID_MAX				= 0x21,
+	/* use for special cases */
+	DR_STE_V1_ACTION_ID_SPECIAL_ENCAP_L3		= 0x22,
+};
+
+static void dr_ste_v1_set_entry_type(u8 *hw_ste_p, u8 entry_type)
+{
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, entry_format, entry_type);
+}
+
 static void dr_ste_v1_set_miss_addr(u8 *hw_ste_p, u64 miss_addr)
 {
 	u64 index = miss_addr >> 6;
@@ -102,6 +147,11 @@ static u16 dr_ste_v1_get_next_lu_type(u8 *hw_ste_p)
 	return (mode << 8 | index);
 }
 
+static void dr_ste_v1_set_hit_gvmi(u8 *hw_ste_p, u16 gvmi)
+{
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, next_table_base_63_48, gvmi);
+}
+
 static void dr_ste_v1_set_hit_addr(u8 *hw_ste_p, u64 icm_addr, u32 ht_size)
 {
 	u64 index = (icm_addr >> 5) | ht_size;
@@ -121,6 +171,311 @@ static void dr_ste_v1_init(u8 *hw_ste_p, u16 lu_type,
 	MLX5_SET(ste_match_bwc_v1, hw_ste_p, miss_address_63_48, gvmi);
 }
 
+static void dr_ste_v1_set_rx_flow_tag(u8 *s_action, u32 flow_tag)
+{
+	MLX5_SET(ste_single_action_flow_tag_v1, s_action, action_id,
+		 DR_STE_V1_ACTION_ID_FLOW_TAG);
+	MLX5_SET(ste_single_action_flow_tag_v1, s_action, flow_tag, flow_tag);
+}
+
+static void dr_ste_v1_set_counter_id(u8 *hw_ste_p, u32 ctr_id)
+{
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, counter_id, ctr_id);
+}
+
+static void dr_ste_v1_set_reparse(u8 *hw_ste_p)
+{
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, reparse, 1);
+}
+
+static void dr_ste_v1_set_tx_encap(u8 *hw_ste_p, u8 *d_action,
+				   u32 reformat_id, int size)
+{
+	MLX5_SET(ste_double_action_insert_with_ptr_v1, d_action, action_id,
+		 DR_STE_V1_ACTION_ID_INSERT_POINTER);
+	/* The hardware expects here size in words (2 byte) */
+	MLX5_SET(ste_double_action_insert_with_ptr_v1, d_action, size, size / 2);
+	MLX5_SET(ste_double_action_insert_with_ptr_v1, d_action, pointer, reformat_id);
+	MLX5_SET(ste_double_action_insert_with_ptr_v1, d_action, attributes,
+		 DR_STE_V1_ACTION_INSERT_PTR_ATTR_ENCAP);
+	dr_ste_v1_set_reparse(hw_ste_p);
+}
+
+static void dr_ste_v1_set_tx_push_vlan(u8 *hw_ste_p, u8 *d_action,
+				       u32 vlan_hdr)
+{
+	MLX5_SET(ste_double_action_insert_with_inline_v1, d_action,
+		 action_id, DR_STE_V1_ACTION_ID_INSERT_INLINE);
+	/* The hardware expects offset to vlan header in words (2 byte) */
+	MLX5_SET(ste_double_action_insert_with_inline_v1, d_action,
+		 start_offset, HDR_LEN_L2_MACS >> 1);
+	MLX5_SET(ste_double_action_insert_with_inline_v1, d_action,
+		 inline_data, vlan_hdr);
+
+	dr_ste_v1_set_reparse(hw_ste_p);
+}
+
+static void dr_ste_v1_set_rx_pop_vlan(u8 *hw_ste_p, u8 *s_action, u8 vlans_num)
+{
+	MLX5_SET(ste_single_action_remove_header_size_v1, s_action,
+		 action_id, DR_STE_V1_ACTION_ID_REMOVE_BY_SIZE);
+	MLX5_SET(ste_single_action_remove_header_size_v1, s_action,
+		 start_anchor, DR_STE_HEADER_ANCHOR_1ST_VLAN);
+	/* The hardware expects here size in words (2 byte) */
+	MLX5_SET(ste_single_action_remove_header_size_v1, s_action,
+		 remove_size, (HDR_LEN_L2_VLAN >> 1) * vlans_num);
+
+	dr_ste_v1_set_reparse(hw_ste_p);
+}
+
+static void dr_ste_v1_set_tx_encap_l3(u8 *hw_ste_p,
+				      u8 *frst_s_action,
+				      u8 *scnd_d_action,
+				      u32 reformat_id,
+				      int size)
+{
+	/* Remove L2 headers */
+	MLX5_SET(ste_single_action_remove_header_v1, frst_s_action, action_id,
+		 DR_STE_V1_ACTION_ID_REMOVE_HEADER_TO_HEADER);
+	MLX5_SET(ste_single_action_remove_header_v1, frst_s_action, end_anchor,
+		 DR_STE_HEADER_ANCHOR_IPV6_IPV4);
+
+	/* Encapsulate with given reformat ID */
+	MLX5_SET(ste_double_action_insert_with_ptr_v1, scnd_d_action, action_id,
+		 DR_STE_V1_ACTION_ID_INSERT_POINTER);
+	/* The hardware expects here size in words (2 byte) */
+	MLX5_SET(ste_double_action_insert_with_ptr_v1, scnd_d_action, size, size / 2);
+	MLX5_SET(ste_double_action_insert_with_ptr_v1, scnd_d_action, pointer, reformat_id);
+	MLX5_SET(ste_double_action_insert_with_ptr_v1, scnd_d_action, attributes,
+		 DR_STE_V1_ACTION_INSERT_PTR_ATTR_ENCAP);
+
+	dr_ste_v1_set_reparse(hw_ste_p);
+}
+
+static void dr_ste_v1_set_rx_decap(u8 *hw_ste_p, u8 *s_action)
+{
+	MLX5_SET(ste_single_action_remove_header_v1, s_action, action_id,
+		 DR_STE_V1_ACTION_ID_REMOVE_HEADER_TO_HEADER);
+	MLX5_SET(ste_single_action_remove_header_v1, s_action, decap, 1);
+	MLX5_SET(ste_single_action_remove_header_v1, s_action, vni_to_cqe, 1);
+	MLX5_SET(ste_single_action_remove_header_v1, s_action, end_anchor,
+		 DR_STE_HEADER_ANCHOR_INNER_MAC);
+
+	dr_ste_v1_set_reparse(hw_ste_p);
+}
+
+static void dr_ste_v1_set_rx_decap_l3(u8 *hw_ste_p,
+				      u8 *s_action,
+				      u16 decap_actions,
+				      u32 decap_index)
+{
+	MLX5_SET(ste_single_action_modify_list_v1, s_action, action_id,
+		 DR_STE_V1_ACTION_ID_MODIFY_LIST);
+	MLX5_SET(ste_single_action_modify_list_v1, s_action, num_of_modify_actions,
+		 decap_actions);
+	MLX5_SET(ste_single_action_modify_list_v1, s_action, modify_actions_ptr,
+		 decap_index);
+
+	dr_ste_v1_set_reparse(hw_ste_p);
+}
+
+static void dr_ste_v1_set_rewrite_actions(u8 *hw_ste_p,
+					  u8 *s_action,
+					  u16 num_of_actions,
+					  u32 re_write_index)
+{
+	MLX5_SET(ste_single_action_modify_list_v1, s_action, action_id,
+		 DR_STE_V1_ACTION_ID_MODIFY_LIST);
+	MLX5_SET(ste_single_action_modify_list_v1, s_action, num_of_modify_actions,
+		 num_of_actions);
+	MLX5_SET(ste_single_action_modify_list_v1, s_action, modify_actions_ptr,
+		 re_write_index);
+
+	dr_ste_v1_set_reparse(hw_ste_p);
+}
+
+static void dr_ste_v1_arr_init_next_match(u8 **last_ste,
+					  u32 *added_stes,
+					  u16 gvmi)
+{
+	u8 *action;
+
+	(*added_stes)++;
+	*last_ste += DR_STE_SIZE;
+	dr_ste_v1_init(*last_ste, MLX5DR_STE_LU_TYPE_DONT_CARE, 0, gvmi);
+	dr_ste_v1_set_entry_type(*last_ste, DR_STE_V1_TYPE_MATCH);
+
+	action = MLX5_ADDR_OF(ste_mask_and_match_v1, *last_ste, action);
+	memset(action, 0, MLX5_FLD_SZ_BYTES(ste_mask_and_match_v1, action));
+}
+
+static void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
+				     u8 *action_type_set,
+				     u8 *last_ste,
+				     struct mlx5dr_ste_actions_attr *attr,
+				     u32 *added_stes)
+{
+	u8 *action = MLX5_ADDR_OF(ste_match_bwc_v1, last_ste, action);
+	u8 action_sz = DR_STE_ACTION_DOUBLE_SZ;
+	bool allow_encap = true;
+
+	if (action_type_set[DR_ACTION_TYP_CTR])
+		dr_ste_v1_set_counter_id(last_ste, attr->ctr_id);
+
+	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
+		if (action_sz < DR_STE_ACTION_DOUBLE_SZ) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes,
+						      attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1,
+					      last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+		}
+		dr_ste_v1_set_rewrite_actions(last_ste, action,
+					      attr->modify_actions,
+					      attr->modify_index);
+		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
+		action += DR_STE_ACTION_DOUBLE_SZ;
+		allow_encap = false;
+	}
+
+	if (action_type_set[DR_ACTION_TYP_PUSH_VLAN]) {
+		int i;
+
+		for (i = 0; i < attr->vlans.count; i++) {
+			if (action_sz < DR_STE_ACTION_DOUBLE_SZ || !allow_encap) {
+				dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+				action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+				action_sz = DR_STE_ACTION_TRIPLE_SZ;
+				allow_encap = true;
+			}
+			dr_ste_v1_set_tx_push_vlan(last_ste, action, attr->vlans.headers[i]);
+			action_sz -= DR_STE_ACTION_DOUBLE_SZ;
+			action += DR_STE_ACTION_DOUBLE_SZ;
+		}
+	}
+
+	if (action_type_set[DR_ACTION_TYP_L2_TO_TNL_L2]) {
+		if (!allow_encap || action_sz < DR_STE_ACTION_DOUBLE_SZ) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+			allow_encap = true;
+		}
+		dr_ste_v1_set_tx_encap(last_ste, action,
+				       attr->reformat_id,
+				       attr->reformat_size);
+		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
+		action += DR_STE_ACTION_DOUBLE_SZ;
+	} else if (action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3]) {
+		u8 *d_action;
+
+		dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+		action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+		action_sz = DR_STE_ACTION_TRIPLE_SZ;
+		d_action = action + DR_STE_ACTION_SINGLE_SZ;
+
+		dr_ste_v1_set_tx_encap_l3(last_ste,
+					  action, d_action,
+					  attr->reformat_id,
+					  attr->reformat_size);
+		action_sz -= DR_STE_ACTION_TRIPLE_SZ;
+		action += DR_STE_ACTION_TRIPLE_SZ;
+	}
+
+	dr_ste_v1_set_hit_gvmi(last_ste, attr->hit_gvmi);
+	dr_ste_v1_set_hit_addr(last_ste, attr->final_icm_addr, 1);
+}
+
+static void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
+				     u8 *action_type_set,
+				     u8 *last_ste,
+				     struct mlx5dr_ste_actions_attr *attr,
+				     u32 *added_stes)
+{
+	u8 *action = MLX5_ADDR_OF(ste_match_bwc_v1, last_ste, action);
+	u8 action_sz = DR_STE_ACTION_DOUBLE_SZ;
+	bool allow_modify_hdr = true;
+	bool allow_ctr = true;
+
+	if (action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2]) {
+		dr_ste_v1_set_rx_decap_l3(last_ste, action,
+					  attr->decap_actions,
+					  attr->decap_index);
+		dr_ste_v1_set_rewrite_actions(last_ste, action,
+					      attr->decap_actions,
+					      attr->decap_index);
+		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
+		action += DR_STE_ACTION_DOUBLE_SZ;
+		allow_modify_hdr = false;
+		allow_ctr = false;
+	} else if (action_type_set[DR_ACTION_TYP_TNL_L2_TO_L2]) {
+		dr_ste_v1_set_rx_decap(last_ste, action);
+		action_sz -= DR_STE_ACTION_SINGLE_SZ;
+		action += DR_STE_ACTION_SINGLE_SZ;
+		allow_modify_hdr = false;
+		allow_ctr = false;
+	}
+
+	if (action_type_set[DR_ACTION_TYP_TAG]) {
+		if (action_sz < DR_STE_ACTION_SINGLE_SZ) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+			allow_modify_hdr = true;
+			allow_ctr = true;
+		}
+		dr_ste_v1_set_rx_flow_tag(action, attr->flow_tag);
+		action_sz -= DR_STE_ACTION_SINGLE_SZ;
+		action += DR_STE_ACTION_SINGLE_SZ;
+	}
+
+	if (action_type_set[DR_ACTION_TYP_POP_VLAN]) {
+		if (action_sz < DR_STE_ACTION_SINGLE_SZ ||
+		    !allow_modify_hdr) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+			allow_modify_hdr = false;
+			allow_ctr = false;
+		}
+
+		dr_ste_v1_set_rx_pop_vlan(last_ste, action, attr->vlans.count);
+		action_sz -= DR_STE_ACTION_SINGLE_SZ;
+		action += DR_STE_ACTION_SINGLE_SZ;
+	}
+
+	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
+		/* Modify header and decapsulation must use different STEs */
+		if (!allow_modify_hdr || action_sz < DR_STE_ACTION_DOUBLE_SZ) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+			allow_modify_hdr = true;
+			allow_ctr = true;
+		}
+		dr_ste_v1_set_rewrite_actions(last_ste, action,
+					      attr->modify_actions,
+					      attr->modify_index);
+		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
+		action += DR_STE_ACTION_DOUBLE_SZ;
+	}
+
+	if (action_type_set[DR_ACTION_TYP_CTR]) {
+		/* Counter action set after decap to exclude decaped header */
+		if (!allow_ctr) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+			allow_modify_hdr = true;
+			allow_ctr = false;
+		}
+		dr_ste_v1_set_counter_id(last_ste, attr->ctr_id);
+	}
+
+	dr_ste_v1_set_hit_gvmi(last_ste, attr->hit_gvmi);
+	dr_ste_v1_set_hit_addr(last_ste, attr->final_icm_addr, 1);
+}
+
 static void dr_ste_v1_build_eth_l2_src_dst_bit_mask(struct mlx5dr_match_param *value,
 						    bool inner, u8 *bit_mask)
 {
@@ -981,4 +1336,7 @@ struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	.set_hit_addr			= &dr_ste_v1_set_hit_addr,
 	.set_byte_mask			= &dr_ste_v1_set_byte_mask,
 	.get_byte_mask			= &dr_ste_v1_get_byte_mask,
+	/* Actions */
+	.set_actions_rx			= &dr_ste_v1_set_actions_rx,
+	.set_actions_tx			= &dr_ste_v1_set_actions_tx,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
index 678b048e7022..31ecdb673625 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
@@ -4,6 +4,106 @@
 #ifndef MLX5_IFC_DR_STE_V1_H
 #define MLX5_IFC_DR_STE_V1_H
 
+struct mlx5_ifc_ste_single_action_flow_tag_v1_bits {
+	u8         action_id[0x8];
+	u8         flow_tag[0x18];
+};
+
+struct mlx5_ifc_ste_single_action_modify_list_v1_bits {
+	u8         action_id[0x8];
+	u8         num_of_modify_actions[0x8];
+	u8         modify_actions_ptr[0x10];
+};
+
+struct mlx5_ifc_ste_single_action_remove_header_v1_bits {
+	u8         action_id[0x8];
+	u8         reserved_at_8[0x2];
+	u8         start_anchor[0x6];
+	u8         reserved_at_10[0x2];
+	u8         end_anchor[0x6];
+	u8         reserved_at_18[0x4];
+	u8         decap[0x1];
+	u8         vni_to_cqe[0x1];
+	u8         qos_profile[0x2];
+};
+
+struct mlx5_ifc_ste_single_action_remove_header_size_v1_bits {
+	u8         action_id[0x8];
+	u8         reserved_at_8[0x2];
+	u8         start_anchor[0x6];
+	u8         outer_l4_remove[0x1];
+	u8         reserved_at_11[0x1];
+	u8         start_offset[0x7];
+	u8         reserved_at_18[0x1];
+	u8         remove_size[0x6];
+};
+
+struct mlx5_ifc_ste_double_action_copy_v1_bits {
+	u8         action_id[0x8];
+	u8         destination_dw_offset[0x8];
+	u8         reserved_at_10[0x2];
+	u8         destination_left_shifter[0x6];
+	u8         reserved_at_17[0x2];
+	u8         destination_length[0x6];
+
+	u8         reserved_at_20[0x8];
+	u8         source_dw_offset[0x8];
+	u8         reserved_at_30[0x2];
+	u8         source_right_shifter[0x6];
+	u8         reserved_at_38[0x8];
+};
+
+struct mlx5_ifc_ste_double_action_set_v1_bits {
+	u8         action_id[0x8];
+	u8         destination_dw_offset[0x8];
+	u8         reserved_at_10[0x2];
+	u8         destination_left_shifter[0x6];
+	u8         reserved_at_18[0x2];
+	u8         destination_length[0x6];
+
+	u8         inline_data[0x20];
+};
+
+struct mlx5_ifc_ste_double_action_add_v1_bits {
+	u8         action_id[0x8];
+	u8         destination_dw_offset[0x8];
+	u8         reserved_at_10[0x2];
+	u8         destination_left_shifter[0x6];
+	u8         reserved_at_18[0x2];
+	u8         destination_length[0x6];
+
+	u8         add_value[0x20];
+};
+
+struct mlx5_ifc_ste_double_action_insert_with_inline_v1_bits {
+	u8         action_id[0x8];
+	u8         reserved_at_8[0x2];
+	u8         start_anchor[0x6];
+	u8         start_offset[0x7];
+	u8         reserved_at_17[0x9];
+
+	u8         inline_data[0x20];
+};
+
+struct mlx5_ifc_ste_double_action_insert_with_ptr_v1_bits {
+	u8         action_id[0x8];
+	u8         reserved_at_8[0x2];
+	u8         start_anchor[0x6];
+	u8         start_offset[0x7];
+	u8         size[0x6];
+	u8         attributes[0x3];
+
+	u8         pointer[0x20];
+};
+
+struct mlx5_ifc_ste_double_action_modify_action_list_v1_bits {
+	u8         action_id[0x8];
+	u8         modify_actions_pattern_pointer[0x18];
+
+	u8         number_of_modify_actions[0x8];
+	u8         modify_actions_argument_pointer[0x18];
+};
+
 struct mlx5_ifc_ste_match_bwc_v1_bits {
 	u8         entry_format[0x8];
 	u8         counter_id[0x18];
-- 
2.29.2


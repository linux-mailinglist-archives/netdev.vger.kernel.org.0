Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B0F1C9A07
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 20:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgEGSzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 14:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgEGSzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 14:55:10 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BBF520575;
        Thu,  7 May 2020 18:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588877709;
        bh=WD+mKH75WVmomMan20IQTLVrT2j50ndwiS9moo5Kw/8=;
        h=Date:From:To:Cc:Subject:From;
        b=R35Sr5GYmkjS86HqRYoRakM5o3LeRslh2lMRiFYRnFPD58D+ZwSR2jhSc0GVFGbk9
         8jn8nGJb+2UbtqlM9ClsT0lQn0uPMKll5IoZrTORcy4vo79FBfVAIHHaQR/ybpmQnJ
         ytm8S2x5gyH8L0FOp+6RwINmlvuPahT3ZY0NYYjY=
Date:   Thu, 7 May 2020 13:59:35 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: Replace zero-length array with flexible-array
Message-ID: <20200507185935.GA15169@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

sizeof(flexible-array-member) triggers a warning because flexible array
members have incomplete type[1]. There are some instances of code in
which the sizeof operator is being incorrectly/erroneously applied to
zero-length arrays and the result is zero. Such instances may be hiding
some bugs. So, this work (flexible-array member conversions) will also
help to get completely rid of those sorts of issues.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 include/linux/mlx5/driver.h   |    2 -
 include/linux/mlx5/mlx5_ifc.h |   66 +++++++++++++++++++++---------------------
 include/linux/mlx5/qp.h       |    2 -
 3 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 6f8f79ef829b..1a4ba36275de 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -200,7 +200,7 @@ struct mlx5_rsc_debug {
 	void		       *object;
 	enum dbg_rsc_type	type;
 	struct dentry	       *root;
-	struct mlx5_field_desc	fields[0];
+	struct mlx5_field_desc	fields[];
 };
 
 enum mlx5_dev_event {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 69b27c7dfc3e..c55686ff6504 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1677,7 +1677,7 @@ struct mlx5_ifc_wq_bits {
 
 	u8         reserved_at_140[0x4c0];
 
-	struct mlx5_ifc_cmd_pas_bits pas[0];
+	struct mlx5_ifc_cmd_pas_bits pas[];
 };
 
 struct mlx5_ifc_rq_num_bits {
@@ -1895,7 +1895,7 @@ struct mlx5_ifc_resource_dump_menu_segment_bits {
 	u8         reserved_at_20[0x10];
 	u8         num_of_records[0x10];
 
-	struct mlx5_ifc_resource_dump_menu_record_bits record[0];
+	struct mlx5_ifc_resource_dump_menu_record_bits record[];
 };
 
 struct mlx5_ifc_resource_dump_resource_segment_bits {
@@ -1907,7 +1907,7 @@ struct mlx5_ifc_resource_dump_resource_segment_bits {
 
 	u8         index2[0x20];
 
-	u8         payload[0][0x20];
+	u8         payload[][0x20];
 };
 
 struct mlx5_ifc_resource_dump_terminate_segment_bits {
@@ -2984,7 +2984,7 @@ struct mlx5_ifc_flow_context_bits {
 
 	u8         reserved_at_1200[0x600];
 
-	union mlx5_ifc_dest_format_struct_flow_counter_list_auto_bits destination[0];
+	union mlx5_ifc_dest_format_struct_flow_counter_list_auto_bits destination[];
 };
 
 enum {
@@ -3276,7 +3276,7 @@ struct mlx5_ifc_rqtc_bits {
 
 	u8         reserved_at_e0[0x6a0];
 
-	struct mlx5_ifc_rq_num_bits rq_num[0];
+	struct mlx5_ifc_rq_num_bits rq_num[];
 };
 
 enum {
@@ -3388,7 +3388,7 @@ struct mlx5_ifc_nic_vport_context_bits {
 
 	u8         reserved_at_7e0[0x20];
 
-	u8         current_uc_mac_address[0][0x40];
+	u8         current_uc_mac_address[][0x40];
 };
 
 enum {
@@ -4310,7 +4310,7 @@ struct mlx5_ifc_query_xrc_srq_out_bits {
 
 	u8         reserved_at_280[0x600];
 
-	u8         pas[0][0x40];
+	u8         pas[][0x40];
 };
 
 struct mlx5_ifc_query_xrc_srq_in_bits {
@@ -4588,7 +4588,7 @@ struct mlx5_ifc_query_srq_out_bits {
 
 	u8         reserved_at_280[0x600];
 
-	u8         pas[0][0x40];
+	u8         pas[][0x40];
 };
 
 struct mlx5_ifc_query_srq_in_bits {
@@ -4799,7 +4799,7 @@ struct mlx5_ifc_query_qp_out_bits {
 
 	u8         reserved_at_800[0x80];
 
-	u8         pas[0][0x40];
+	u8         pas[][0x40];
 };
 
 struct mlx5_ifc_query_qp_in_bits {
@@ -5132,7 +5132,7 @@ struct mlx5_ifc_query_hca_vport_pkey_out_bits {
 
 	u8         reserved_at_40[0x40];
 
-	struct mlx5_ifc_pkey_bits pkey[0];
+	struct mlx5_ifc_pkey_bits pkey[];
 };
 
 struct mlx5_ifc_query_hca_vport_pkey_in_bits {
@@ -5168,7 +5168,7 @@ struct mlx5_ifc_query_hca_vport_gid_out_bits {
 	u8         gids_num[0x10];
 	u8         reserved_at_70[0x10];
 
-	struct mlx5_ifc_array128_auto_bits gid[0];
+	struct mlx5_ifc_array128_auto_bits gid[];
 };
 
 struct mlx5_ifc_query_hca_vport_gid_in_bits {
@@ -5436,7 +5436,7 @@ struct mlx5_ifc_query_flow_counter_out_bits {
 
 	u8         reserved_at_40[0x40];
 
-	struct mlx5_ifc_traffic_counter_bits flow_statistics[0];
+	struct mlx5_ifc_traffic_counter_bits flow_statistics[];
 };
 
 struct mlx5_ifc_query_flow_counter_in_bits {
@@ -5530,7 +5530,7 @@ struct mlx5_ifc_query_eq_out_bits {
 
 	u8         reserved_at_300[0x580];
 
-	u8         pas[0][0x40];
+	u8         pas[][0x40];
 };
 
 struct mlx5_ifc_query_eq_in_bits {
@@ -5555,7 +5555,7 @@ struct mlx5_ifc_packet_reformat_context_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         reformat_data[2][0x8];
 
-	u8         more_reformat_data[0][0x8];
+	u8         more_reformat_data[][0x8];
 };
 
 struct mlx5_ifc_query_packet_reformat_context_out_bits {
@@ -5566,7 +5566,7 @@ struct mlx5_ifc_query_packet_reformat_context_out_bits {
 
 	u8         reserved_at_40[0xa0];
 
-	struct mlx5_ifc_packet_reformat_context_in_bits packet_reformat_context[0];
+	struct mlx5_ifc_packet_reformat_context_in_bits packet_reformat_context[];
 };
 
 struct mlx5_ifc_query_packet_reformat_context_in_bits {
@@ -5805,7 +5805,7 @@ struct mlx5_ifc_query_cq_out_bits {
 
 	u8         reserved_at_280[0x600];
 
-	u8         pas[0][0x40];
+	u8         pas[][0x40];
 };
 
 struct mlx5_ifc_query_cq_in_bits {
@@ -6412,7 +6412,7 @@ struct mlx5_ifc_modify_cq_in_bits {
 
 	u8         reserved_at_300[0x580];
 
-	u8         pas[0][0x40];
+	u8         pas[][0x40];
 };
 
 struct mlx5_ifc_modify_cong_status_out_bits {
@@ -6476,7 +6476,7 @@ struct mlx5_ifc_manage_pages_out_bits {
 
 	u8         reserved_at_60[0x20];
 
-	u8         pas[0][0x40];
+	u8         pas[][0x40];
 };
 
 enum {
@@ -6498,7 +6498,7 @@ struct mlx5_ifc_manage_pages_in_bits {
 
 	u8         input_num_entries[0x20];
 
-	u8         pas[0][0x40];
+	u8         pas[][0x40];
 };
 
 struct mlx5_ifc_mad_ifc_out_bits {
@@ -7453,7 +7453,7 @@ struct mlx5_ifc_create_xrc_srq_in_bits {
 
 	u8         reserved_at_300[0x580];
 
-	u8         pas[0][0x40];
+	u8         pas[][0x40];
 };
 
 struct mlx5_ifc_create_tis_out_bits {
@@ -7529,7 +7529,7 @@ struct mlx5_ifc_create_srq_in_bits {
 
 	u8         reserved_at_280[0x600];
 
-	u8         pas[0][0x40];
+	u8         pas[][0x40];
 };
 
 struct mlx5_ifc_create_sq_out_bits {
@@ -7690,7 +7690,7 @@ struct mlx5_ifc_create_qp_in_bits {
 	u8         wq_umem_valid[0x1];
 	u8         reserved_at_861[0x1f];
 
-	u8         pas[0][0x40];
+	u8         pas[][0x40];
 };
 
 struct mlx5_ifc_create_psv_out_bits {
@@ -7761,7 +7761,7 @@ struct mlx5_ifc_create_mkey_in_bits {
 
 	u8         reserved_at_320[0x560];
 
-	u8         klm_pas_mtt[0][0x20];
+	u8         klm_pas_mtt[][0x20];
 };
 
 enum {
@@ -7894,7 +7894,7 @@ struct mlx5_ifc_create_eq_in_bits {
 
 	u8         reserved_at_3c0[0x4c0];
 
-	u8         pas[0][0x40];
+	u8         pas[][0x40];
 };
 
 struct mlx5_ifc_create_dct_out_bits {
@@ -7951,7 +7951,7 @@ struct mlx5_ifc_create_cq_in_bits {
 	u8         cq_umem_valid[0x1];
 	u8         reserved_at_2e1[0x59f];
 
-	u8         pas[0][0x40];
+	u8         pas[][0x40];
 };
 
 struct mlx5_ifc_config_int_moderation_out_bits {
@@ -8307,7 +8307,7 @@ struct mlx5_ifc_access_register_out_bits {
 
 	u8         reserved_at_40[0x40];
 
-	u8         register_data[0][0x20];
+	u8         register_data[][0x20];
 };
 
 enum {
@@ -8327,7 +8327,7 @@ struct mlx5_ifc_access_register_in_bits {
 
 	u8         argument[0x20];
 
-	u8         register_data[0][0x20];
+	u8         register_data[][0x20];
 };
 
 struct mlx5_ifc_sltp_reg_bits {
@@ -9344,7 +9344,7 @@ struct mlx5_ifc_cmd_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         command[0][0x20];
+	u8         command[][0x20];
 };
 
 struct mlx5_ifc_cmd_if_box_bits {
@@ -9638,7 +9638,7 @@ struct mlx5_ifc_mcqi_reg_bits {
 	u8         reserved_at_a0[0x10];
 	u8         data_size[0x10];
 
-	union mlx5_ifc_mcqi_reg_data_bits data[0];
+	union mlx5_ifc_mcqi_reg_data_bits data[];
 };
 
 struct mlx5_ifc_mcc_reg_bits {
@@ -10200,7 +10200,7 @@ struct mlx5_ifc_umem_bits {
 
 	u8         num_of_mtt[0x40];
 
-	struct mlx5_ifc_mtt_bits  mtt[0];
+	struct mlx5_ifc_mtt_bits  mtt[];
 };
 
 struct mlx5_ifc_uctx_bits {
@@ -10325,7 +10325,7 @@ struct mlx5_ifc_mtrc_stdb_bits {
 	u8         reserved_at_4[0x4];
 	u8         read_size[0x18];
 	u8         start_offset[0x20];
-	u8         string_db_data[0];
+	u8         string_db_data[];
 };
 
 struct mlx5_ifc_mtrc_ctrl_bits {
@@ -10379,7 +10379,7 @@ struct mlx5_ifc_query_esw_functions_out_bits {
 	struct mlx5_ifc_host_params_context_bits host_params_context;
 
 	u8         reserved_at_280[0x180];
-	u8         host_sf_enable[0][0x40];
+	u8         host_sf_enable[][0x40];
 };
 
 struct mlx5_ifc_sf_partition_bits {
@@ -10399,7 +10399,7 @@ struct mlx5_ifc_query_sf_partitions_out_bits {
 
 	u8         reserved_at_60[0x20];
 
-	struct mlx5_ifc_sf_partition_bits sf_partition[0];
+	struct mlx5_ifc_sf_partition_bits sf_partition[];
 };
 
 struct mlx5_ifc_query_sf_partitions_in_bits {
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index ae63b1ae9004..4e684298d1de 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -402,7 +402,7 @@ struct mlx5_wqe_signature_seg {
 
 struct mlx5_wqe_inline_seg {
 	__be32	byte_count;
-	__be32	data[0];
+	__be32	data[];
 };
 
 enum mlx5_sig_type {


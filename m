Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3545543D4F
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 22:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbiFHUFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 16:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbiFHUF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 16:05:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C66427D7;
        Wed,  8 Jun 2022 13:05:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A3AF61C83;
        Wed,  8 Jun 2022 20:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E660DC34116;
        Wed,  8 Jun 2022 20:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654718726;
        bh=TwH4Lb8w6uD28tQcmV/MNWC03dk3ro1IAF1d1rTPEHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJ65R+ULec87yTNuyPYVMAiyenOM+QNB/NKj3QRPjjFgxYyEGGRpNDDyTwkk1y/td
         e54qjJxLMYRO/eaZamww4nehksdsIetCmcEI4hsgJVk1pcuBMiZVYNkEul5nX4hZT8
         aqedu/6r7LVcLivhDOPlyFO8kRRq3olwdEURCY3X1Qge1HWur6jVHQZPzUV65S0Ap+
         5oFuDI9himiTKgBlIwFzC99Z27iB0aYGVpY5ghii42nbvrJdD8Bt64DG3oou9aXnFe
         z8HRB7ZyDpF6oqlgLgIGNF8zUiWFLfskkSQuN4qrF5UgzrZdvKAvid1TTcNeUETy1g
         6FMytS52L42sw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Jianbo Liu <jianbol@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [PATCH mlx5-next 1/6] net/mlx5: Add IFC bits and enums for flow meter
Date:   Wed,  8 Jun 2022 13:04:47 -0700
Message-Id: <20220608200452.43880-2-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220608200452.43880-1-saeed@kernel.org>
References: <20220608200452.43880-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

Add/extend structure layouts and defines for flow meter.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/device.h   |   1 +
 include/linux/mlx5/mlx5_ifc.h | 114 ++++++++++++++++++++++++++++++++--
 2 files changed, 111 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 604b85dd770a..15ac02eeed4f 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -455,6 +455,7 @@ enum {
 
 	MLX5_OPCODE_UMR			= 0x25,
 
+	MLX5_OPCODE_ACCESS_ASO		= 0x2d,
 };
 
 enum {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index fd7d083a34d3..a81f86620a10 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -442,7 +442,9 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         max_modify_header_actions[0x8];
 	u8         max_ft_level[0x8];
 
-	u8         reserved_at_40[0x20];
+	u8         reserved_at_40[0x6];
+	u8         execute_aso[0x1];
+	u8         reserved_at_47[0x19];
 
 	u8         reserved_at_60[0x2];
 	u8         reformat_insert[0x1];
@@ -940,7 +942,17 @@ struct mlx5_ifc_qos_cap_bits {
 
 	u8         max_tsar_bw_share[0x20];
 
-	u8         reserved_at_100[0x700];
+	u8         reserved_at_100[0x20];
+
+	u8         reserved_at_120[0x3];
+	u8         log_meter_aso_granularity[0x5];
+	u8         reserved_at_128[0x3];
+	u8         log_meter_aso_max_alloc[0x5];
+	u8         reserved_at_130[0x3];
+	u8         log_max_num_meter_aso[0x5];
+	u8         reserved_at_138[0x8];
+
+	u8         reserved_at_140[0x6c0];
 };
 
 struct mlx5_ifc_debug_cap_bits {
@@ -3277,6 +3289,7 @@ enum {
 	MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2 = 0x800,
 	MLX5_FLOW_CONTEXT_ACTION_IPSEC_DECRYPT = 0x1000,
 	MLX5_FLOW_CONTEXT_ACTION_IPSEC_ENCRYPT = 0x2000,
+	MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO = 0x4000,
 };
 
 enum {
@@ -3292,6 +3305,38 @@ struct mlx5_ifc_vlan_bits {
 	u8         vid[0xc];
 };
 
+enum {
+	MLX5_FLOW_METER_COLOR_RED	= 0x0,
+	MLX5_FLOW_METER_COLOR_YELLOW	= 0x1,
+	MLX5_FLOW_METER_COLOR_GREEN	= 0x2,
+	MLX5_FLOW_METER_COLOR_UNDEFINED	= 0x3,
+};
+
+enum {
+	MLX5_EXE_ASO_FLOW_METER		= 0x2,
+};
+
+struct mlx5_ifc_exe_aso_ctrl_flow_meter_bits {
+	u8        return_reg_id[0x4];
+	u8        aso_type[0x4];
+	u8        reserved_at_8[0x14];
+	u8        action[0x1];
+	u8        init_color[0x2];
+	u8        meter_id[0x1];
+};
+
+union mlx5_ifc_exe_aso_ctrl {
+	struct mlx5_ifc_exe_aso_ctrl_flow_meter_bits exe_aso_ctrl_flow_meter;
+};
+
+struct mlx5_ifc_execute_aso_bits {
+	u8        valid[0x1];
+	u8        reserved_at_1[0x7];
+	u8        aso_object_id[0x18];
+
+	union mlx5_ifc_exe_aso_ctrl exe_aso_ctrl;
+};
+
 struct mlx5_ifc_flow_context_bits {
 	struct mlx5_ifc_vlan_bits push_vlan;
 
@@ -3323,7 +3368,9 @@ struct mlx5_ifc_flow_context_bits {
 
 	struct mlx5_ifc_fte_match_param_bits match_value;
 
-	u8         reserved_at_1200[0x600];
+	struct mlx5_ifc_execute_aso_bits execute_aso[4];
+
+	u8         reserved_at_1300[0x500];
 
 	union mlx5_ifc_dest_format_struct_flow_counter_list_auto_bits destination[];
 };
@@ -5970,7 +6017,9 @@ struct mlx5_ifc_general_obj_in_cmd_hdr_bits {
 
 	u8         obj_id[0x20];
 
-	u8         reserved_at_60[0x20];
+	u8         reserved_at_60[0x3];
+	u8         log_obj_range[0x5];
+	u8         reserved_at_68[0x18];
 };
 
 struct mlx5_ifc_general_obj_out_cmd_hdr_bits {
@@ -11370,12 +11419,14 @@ enum {
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT_ULL(0xc),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT_ULL(0x13),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT_ULL(0x20),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = BIT_ULL(0x24),
 };
 
 enum {
 	MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = 0xc,
 	MLX5_GENERAL_OBJECT_TYPES_IPSEC = 0x13,
 	MLX5_GENERAL_OBJECT_TYPES_SAMPLER = 0x20,
+	MLX5_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = 0x24,
 };
 
 enum {
@@ -11448,6 +11499,61 @@ struct mlx5_ifc_create_encryption_key_in_bits {
 	struct mlx5_ifc_encryption_key_obj_bits encryption_key_object;
 };
 
+enum {
+	MLX5_FLOW_METER_MODE_BYTES_IP_LENGTH		= 0x0,
+	MLX5_FLOW_METER_MODE_BYTES_CALC_WITH_L2		= 0x1,
+	MLX5_FLOW_METER_MODE_BYTES_CALC_WITH_L2_IPG	= 0x2,
+	MLX5_FLOW_METER_MODE_NUM_PACKETS		= 0x3,
+};
+
+struct mlx5_ifc_flow_meter_parameters_bits {
+	u8         valid[0x1];
+	u8         bucket_overflow[0x1];
+	u8         start_color[0x2];
+	u8         both_buckets_on_green[0x1];
+	u8         reserved_at_5[0x1];
+	u8         meter_mode[0x2];
+	u8         reserved_at_8[0x18];
+
+	u8         reserved_at_20[0x20];
+
+	u8         reserved_at_40[0x3];
+	u8         cbs_exponent[0x5];
+	u8         cbs_mantissa[0x8];
+	u8         reserved_at_50[0x3];
+	u8         cir_exponent[0x5];
+	u8         cir_mantissa[0x8];
+
+	u8         reserved_at_60[0x20];
+
+	u8         reserved_at_80[0x3];
+	u8         ebs_exponent[0x5];
+	u8         ebs_mantissa[0x8];
+	u8         reserved_at_90[0x3];
+	u8         eir_exponent[0x5];
+	u8         eir_mantissa[0x8];
+
+	u8         reserved_at_a0[0x60];
+};
+
+struct mlx5_ifc_flow_meter_aso_obj_bits {
+	u8         modify_field_select[0x40];
+
+	u8         reserved_at_40[0x40];
+
+	u8         reserved_at_80[0x8];
+	u8         meter_aso_access_pd[0x18];
+
+	u8         reserved_at_a0[0x160];
+
+	struct mlx5_ifc_flow_meter_parameters_bits flow_meter_parameters[2];
+};
+
+struct mlx5_ifc_create_flow_meter_aso_obj_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits hdr;
+	struct mlx5_ifc_flow_meter_aso_obj_bits flow_meter_aso_obj;
+};
+
 struct mlx5_ifc_sampler_obj_bits {
 	u8         modify_field_select[0x40];
 
-- 
2.36.1


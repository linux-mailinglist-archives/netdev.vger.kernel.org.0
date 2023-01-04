Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D39265CFDC
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 10:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbjADJoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 04:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbjADJoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 04:44:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B571A383;
        Wed,  4 Jan 2023 01:43:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4F5BCE173F;
        Wed,  4 Jan 2023 09:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D92EC433D2;
        Wed,  4 Jan 2023 09:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672825435;
        bh=qTvxaTW4Eh/+rBC9vu7KrbVyItlTPpX7ZP8h6nQ8iwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPxTuYmarbxSJ+RKqj+lbCSw6PMoZB1LQiDOOFJEUpCH1Y04OysoZ2xK9W6Lfe176
         Q7XIlRp8bmaN5chrNTeVPdleIfRXsR59J9xsCQkhNsWyRTL2rW8QRMhx9RIQ0p9kJE
         amWhh5lwEKfMMTvclqfL7NUR2xaohNOmNYYD7u6b9/qGW+aPMeKvu5+kest4l0UYy1
         Vi7PV+CNXCigLxEebefRBYIfdt/wDjs7DKhiDyTj2YAKtnrYMGUei6CmPez/Ct6tsR
         bjcG67e2Prk5E6BcWkdqa7MQprEq6LzKO2XZQqxmdH4LEnbDKEcouqYdHFHO72kwda
         TvVvrCXHtzcXg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Mark Zhang <markzhang@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH mlx5-next v1 2/3] net/mlx5: Introduce CQE error syndrome
Date:   Wed,  4 Jan 2023 11:43:35 +0200
Message-Id: <f8359315f8130f6d2abe4b94409ac7802f54bce3.1672821186.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672821186.git.leonro@nvidia.com>
References: <cover.1672821186.git.leonro@nvidia.com>
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

From: Patrisious Haddad <phaddad@nvidia.com>

Introduces CQE error syndrome bits which are inside qp_context_extension
and are used to report the reason the QP was moved to error state.
Useful for cases in which a CQE isn't generated, such as remote write
rkey violation.

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 47 +++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a2ed927c8f9f..77e092d6fae6 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1497,7 +1497,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         null_mkey[0x1];
 	u8         log_max_klm_list_size[0x6];
 
-	u8         reserved_at_120[0xa];
+	u8         reserved_at_120[0x2];
+	u8	   qpc_extension[0x1];
+	u8	   reserved_at_123[0x7];
 	u8         log_max_ra_req_dc[0x6];
 	u8         reserved_at_130[0x2];
 	u8         eth_wqe_too_small[0x1];
@@ -1663,7 +1665,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         log_bf_reg_size[0x5];
 
-	u8         reserved_at_270[0x6];
+	u8         reserved_at_270[0x3];
+	u8	   qp_error_syndrome[0x1];
+	u8	   reserved_at_274[0x2];
 	u8         lag_dct[0x2];
 	u8         lag_tx_port_affinity[0x1];
 	u8         lag_native_fdb_selection[0x1];
@@ -5347,6 +5351,37 @@ struct mlx5_ifc_query_rmp_in_bits {
 	u8         reserved_at_60[0x20];
 };
 
+struct mlx5_ifc_cqe_error_syndrome_bits {
+	u8         hw_error_syndrome[0x8];
+	u8         hw_syndrome_type[0x4];
+	u8         reserved_at_c[0x4];
+	u8         vendor_error_syndrome[0x8];
+	u8         syndrome[0x8];
+};
+
+struct mlx5_ifc_qp_context_extension_bits {
+	u8         reserved_at_0[0x60];
+
+	struct mlx5_ifc_cqe_error_syndrome_bits error_syndrome;
+
+	u8         reserved_at_80[0x580];
+};
+
+struct mlx5_ifc_qpc_extension_and_pas_list_in_bits {
+	struct mlx5_ifc_qp_context_extension_bits qpc_data_extension;
+
+	u8         pas[0][0x40];
+};
+
+struct mlx5_ifc_qp_pas_list_in_bits {
+	struct mlx5_ifc_cmd_pas_bits pas[0];
+};
+
+union mlx5_ifc_qp_pas_or_qpc_ext_and_pas_bits {
+	struct mlx5_ifc_qp_pas_list_in_bits qp_pas_list;
+	struct mlx5_ifc_qpc_extension_and_pas_list_in_bits qpc_ext_and_pas_list;
+};
+
 struct mlx5_ifc_query_qp_out_bits {
 	u8         status[0x8];
 	u8         reserved_at_8[0x18];
@@ -5363,7 +5398,7 @@ struct mlx5_ifc_query_qp_out_bits {
 
 	u8         reserved_at_800[0x80];
 
-	u8         pas[][0x40];
+	union mlx5_ifc_qp_pas_or_qpc_ext_and_pas_bits qp_pas_or_qpc_ext_and_pas;
 };
 
 struct mlx5_ifc_query_qp_in_bits {
@@ -5373,7 +5408,8 @@ struct mlx5_ifc_query_qp_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x8];
+	u8         qpc_ext[0x1];
+	u8         reserved_at_41[0x7];
 	u8         qpn[0x18];
 
 	u8         reserved_at_60[0x20];
@@ -8576,7 +8612,8 @@ struct mlx5_ifc_create_qp_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x8];
+	u8         qpc_ext[0x1];
+	u8         reserved_at_41[0x7];
 	u8         input_qpn[0x18];
 
 	u8         reserved_at_60[0x20];
-- 
2.38.1


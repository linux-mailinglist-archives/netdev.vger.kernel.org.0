Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C9B65E498
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjAEES4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbjAEESd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:18:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C7A3D9FC;
        Wed,  4 Jan 2023 20:18:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 024CE60C95;
        Thu,  5 Jan 2023 04:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535EDC433D2;
        Thu,  5 Jan 2023 04:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672892297;
        bh=AIirfS1vImvtqQlLodmY703eyIiwOKQhZSMT/1LqE6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8ckrz1pYkFqp9+Bi2IUzs0NUESHwHnbBkRWRYiIusrdJKs6Rh02JAJxDuqnZMMUf
         VzZ0c/vdeMI2xnhjcPA0ghX9oFj1vjMvc1DPhV44j4LWECtiQhyUhYb/YEQIS1giSz
         NEP/1AJBfnzhr+wgnL298UKzPtqWiw+5k378MPQXEOg4fCJCR7GgIcva+BLkEQZxSE
         lpC/1wq3hb8O0ylKnmK24z4lrCzgc3NTpDHKqYAYjl9pFDEuf4zQHFCne1W2Y99PyE
         KUR3xkhe9OxqdUS0vrQD0uPHF1LmQFxtl4kq0DC20RzGg7GgWxzWPQUc4T3fpooZQf
         6e1MzZ9TW7s5g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Patrisious Haddad <phaddad@nvidia.com>
Subject: [PATCH mlx5-next 4/8] net/mlx5: Introduce new destination type TABLE_TYPE
Date:   Wed,  4 Jan 2023 20:17:52 -0800
Message-Id: <20230105041756.677120-5-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230105041756.677120-1-saeed@kernel.org>
References: <20230105041756.677120-1-saeed@kernel.org>
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

This new destination type supports flow transition between different
table types, e.g. from NIC_RX to RDMA_RX or from RDMA_TX to NIC_TX.

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index f3d1c62c98dd..77f0d0f25bf0 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -315,6 +315,11 @@ enum {
 	MLX5_CMD_OP_GENERAL_END = 0xd00,
 };
 
+enum {
+	MLX5_FT_NIC_RX_2_NIC_RX_RDMA = BIT(0),
+	MLX5_FT_NIC_TX_RDMA_2_NIC_TX = BIT(1),
+};
+
 struct mlx5_ifc_flow_table_fields_supported_bits {
 	u8         outer_dmac[0x1];
 	u8         outer_smac[0x1];
@@ -1898,7 +1903,8 @@ struct mlx5_ifc_cmd_hca_cap_2_bits {
 
 	u8	   reserved_at_e0[0xc0];
 
-	u8	   reserved_at_1a0[0xb];
+	u8	   flow_table_type_2_type[0x8];
+	u8	   reserved_at_1a8[0x3];
 	u8	   log_min_mkey_entity_size[0x5];
 	u8	   reserved_at_1b0[0x10];
 
@@ -1922,6 +1928,7 @@ enum mlx5_ifc_flow_destination_type {
 	MLX5_IFC_FLOW_DESTINATION_TYPE_TIR          = 0x2,
 	MLX5_IFC_FLOW_DESTINATION_TYPE_FLOW_SAMPLER = 0x6,
 	MLX5_IFC_FLOW_DESTINATION_TYPE_UPLINK       = 0x8,
+	MLX5_IFC_FLOW_DESTINATION_TYPE_TABLE_TYPE   = 0xA,
 };
 
 enum mlx5_flow_table_miss_action {
@@ -1936,7 +1943,8 @@ struct mlx5_ifc_dest_format_struct_bits {
 
 	u8         destination_eswitch_owner_vhca_id_valid[0x1];
 	u8         packet_reformat[0x1];
-	u8         reserved_at_22[0xe];
+	u8         reserved_at_22[0x6];
+	u8         destination_table_type[0x8];
 	u8         destination_eswitch_owner_vhca_id[0x10];
 };
 
-- 
2.38.1


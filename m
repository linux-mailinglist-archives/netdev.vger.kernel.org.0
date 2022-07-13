Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD0C573FDB
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiGMW7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiGMW7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:59:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418172A73B
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:59:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6D36ECE238C
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950E0C341C0;
        Wed, 13 Jul 2022 22:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657753153;
        bh=omgBUkwkDBJo8RQAOLVn93wWGab88yoBEH+kmS6q1zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXWch6ODtbba8dMJISLtSnDTTlZqN/EigkREN1xQz5Bep1O49Pm2VhPQRuyPQRwam
         PVi4WZiMSrq9S/ZLvDOsoLPvVgYQFH83oHmn9OW1w4+FdKNvrVKubWmMMC8UN0kyux
         2PxtQx+xlCxUjNIHialRsJi6Ek+ncrMG9rpvZpO+pBscgzFJmJnRWJjZeWt2mYN1eZ
         EB3idLfKyTqve604nmkGIy7wK7FkZPDM5rhzQc9Qvbz0ZSiG6/iI5q/YoXiwY/x+T7
         QjVWaBfuJvux3/gdt6ZKvT3O/E3RloYHnHxO/Vp44K8StObzdylaknpHJpLEO4k7pZ
         mSDJtLLNTJbDQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Yishai Hadas <yishaih@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 02/15] net/mlx5: Introduce ifc bits for using software vhca id
Date:   Wed, 13 Jul 2022 15:58:46 -0700
Message-Id: <20220713225859.401241-3-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713225859.401241-1-saeed@kernel.org>
References: <20220713225859.401241-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

Introduce ifc related stuff to enable using software vhca id
functionality.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 8e87eb47f9dc..254cc22f5eec 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1826,7 +1826,14 @@ struct mlx5_ifc_cmd_hca_cap_2_bits {
 	u8	   max_reformat_remove_size[0x8];
 	u8	   max_reformat_remove_offset[0x8];
 
-	u8	   reserved_at_c0[0x740];
+	u8	   reserved_at_c0[0x160];
+
+	u8	   reserved_at_220[0x1];
+	u8	   sw_vhca_id_valid[0x1];
+	u8	   sw_vhca_id[0xe];
+	u8	   reserved_at_230[0x10];
+
+	u8	   reserved_at_240[0x5c0];
 };
 
 enum mlx5_ifc_flow_destination_type {
@@ -3782,6 +3789,11 @@ struct mlx5_ifc_rmpc_bits {
 	struct mlx5_ifc_wq_bits wq;
 };
 
+enum {
+	VHCA_ID_TYPE_HW = 0,
+	VHCA_ID_TYPE_SW = 1,
+};
+
 struct mlx5_ifc_nic_vport_context_bits {
 	u8         reserved_at_0[0x5];
 	u8         min_wqe_inline_mode[0x3];
@@ -3798,8 +3810,8 @@ struct mlx5_ifc_nic_vport_context_bits {
 	u8         event_on_mc_address_change[0x1];
 	u8         event_on_uc_address_change[0x1];
 
-	u8         reserved_at_40[0xc];
-
+	u8         vhca_id_type[0x1];
+	u8         reserved_at_41[0xb];
 	u8	   affiliation_criteria[0x4];
 	u8	   affiliated_vhca_id[0x10];
 
@@ -7259,7 +7271,12 @@ struct mlx5_ifc_init_hca_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x40];
+	u8         reserved_at_40[0x20];
+
+	u8         reserved_at_60[0x2];
+	u8         sw_vhca_id[0xe];
+	u8         reserved_at_70[0x10];
+
 	u8	   sw_owner_id[4][0x20];
 };
 
-- 
2.36.1


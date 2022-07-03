Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFFBE5649D0
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 22:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbiGCUy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 16:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiGCUy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 16:54:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731DF38B8;
        Sun,  3 Jul 2022 13:54:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30572B803F5;
        Sun,  3 Jul 2022 20:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7328C341C6;
        Sun,  3 Jul 2022 20:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656881662;
        bh=qUoDcuRP5vkIgGERNRI+Z7Y6twPYrygl3Z+F74ezNC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNryQ8YncimG7JBi+2Peue2iYicMejHBeuIFpnAPuj+5kR4+fM6iXk6uOYNQEt1jx
         cLJntOMmGsn//hAEbNdsy+S5lfF+T1wIWFcZ3EpqK7KkiZewFFLCiSOnGUV6P6Lnj+
         cI1+hhJdXe447d9EMhGeH96dXJCEbe5eKVo+T6XtM/XbeXDR9sRxjYyKPcNNKmTyjH
         dovCNCyOGN/nfbblGFG/iq+GKFzFQaKwcspV1FkNdw7oWiJTxjVLcmjS7Cwhqsb1/L
         Bqo+knSS+TwI8s0wdq+Yr6nEaKhqDhu65gph7YpglPkafKwKlYDdQdCFDMz45MfomT
         bEPg2nn7MYxDA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: [PATCH mlx5-next 1/5] net/mlx5: Expose the ability to point to any UID from shared UID
Date:   Sun,  3 Jul 2022 13:54:03 -0700
Message-Id: <20220703205407.110890-2-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220703205407.110890-1-saeed@kernel.org>
References: <20220703205407.110890-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Expose shared_object_to_user_object_allowed, this capability
means an object created with shared UID can point to any UID.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 8e87eb47f9dc..9321d774e2d8 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1371,7 +1371,9 @@ enum {
 };
 
 struct mlx5_ifc_cmd_hca_cap_bits {
-	u8         reserved_at_0[0x1f];
+	u8         reserved_at_0[0x10];
+	u8         shared_object_to_user_object_allowed[0x1];
+	u8         reserved_at_13[0xe];
 	u8         vhca_resource_manager[0x1];
 
 	u8         hca_cap_2[0x1];
@@ -8507,7 +8509,7 @@ struct mlx5_ifc_create_flow_table_out_bits {
 
 struct mlx5_ifc_create_flow_table_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
-- 
2.36.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384774C2019
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244998AbiBWXkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244978AbiBWXkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:40:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869FF5C674;
        Wed, 23 Feb 2022 15:39:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DFB561A47;
        Wed, 23 Feb 2022 23:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5B3C340F1;
        Wed, 23 Feb 2022 23:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645659587;
        bh=I0wyQ8UGKX01fBc9ppmeyGzVpEcUj8PVqp1FEHBRPhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nx0LfcZFw5IJbAWfEECddTa5XhYPreuDaiiYzk/8ea99m5KC3wNcdyVlyWuKBgWwE
         04QYAKUD6DB0YSUJMn/kVfMWbNWfRqqEeEiaPYtlu6xUgTLHosoUFaS+T6OIvPefDK
         2B/wyPBhWbWMsVlXDFVcsnKXE3q4iuyo9CnyCFaiIrodo48UpMhYMvFB3X12UEgmHN
         YnHNX1xxQVm8UDMB5USBgkDgz7mOjGxaiLXY2iX7xQ8mam75rRFpOqgnjWXE0b4u6J
         5K6BoJQsdWE6nBeHBroL5go7lDn2g4p+hap9mb8Sl42QJ6N6nFqBxORNl31FkMyrdD
         QGZokbgLnZeFg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [for-next v2 16/17] net/mlx5: Add reset_state field to MFRL register
Date:   Wed, 23 Feb 2022 15:39:29 -0800
Message-Id: <20220223233930.319301-17-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223233930.319301-1-saeed@kernel.org>
References: <20220223233930.319301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

Add new field reset_state to MFRL register. This field expose current
state of sync reset for fw update. This field enables sharing with the
user more details on why fw activate failed in case it failed the sync
reset stage.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 598ac3bcc901..8ca2d65ff789 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9694,7 +9694,8 @@ struct mlx5_ifc_pcam_reg_bits {
 };
 
 struct mlx5_ifc_mcam_enhanced_features_bits {
-	u8         reserved_at_0[0x6b];
+	u8         reserved_at_0[0x6a];
+	u8         reset_state[0x1];
 	u8         ptpcyc2realtime_modify[0x1];
 	u8         reserved_at_6c[0x2];
 	u8         pci_status_and_power[0x1];
@@ -10375,6 +10376,14 @@ struct mlx5_ifc_mcda_reg_bits {
 	u8         data[][0x20];
 };
 
+enum {
+	MLX5_MFRL_REG_RESET_STATE_IDLE = 0,
+	MLX5_MFRL_REG_RESET_STATE_IN_NEGOTIATION = 1,
+	MLX5_MFRL_REG_RESET_STATE_RESET_IN_PROGRESS = 2,
+	MLX5_MFRL_REG_RESET_STATE_TIMEOUT = 3,
+	MLX5_MFRL_REG_RESET_STATE_NACK = 4,
+};
+
 enum {
 	MLX5_MFRL_REG_RESET_TYPE_FULL_CHIP = BIT(0),
 	MLX5_MFRL_REG_RESET_TYPE_NET_PORT_ALIVE = BIT(1),
@@ -10393,7 +10402,8 @@ struct mlx5_ifc_mfrl_reg_bits {
 	u8         pci_sync_for_fw_update_start[0x1];
 	u8         pci_sync_for_fw_update_resp[0x2];
 	u8         rst_type_sel[0x3];
-	u8         reserved_at_28[0x8];
+	u8         reserved_at_28[0x4];
+	u8         reset_state[0x4];
 	u8         reset_type[0x8];
 	u8         reset_level[0x8];
 };
-- 
2.35.1


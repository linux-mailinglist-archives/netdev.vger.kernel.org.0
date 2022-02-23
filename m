Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472364C0B8B
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 06:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbiBWFLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 00:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238089AbiBWFKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 00:10:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E89692A9;
        Tue, 22 Feb 2022 21:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70B0560C55;
        Wed, 23 Feb 2022 05:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0256C340F1;
        Wed, 23 Feb 2022 05:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645593020;
        bh=I0wyQ8UGKX01fBc9ppmeyGzVpEcUj8PVqp1FEHBRPhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jA2fsYSwcwktdJHa93NJuLOGFaI0TGJ4UVL6us6Qi0kpmDQvy8BNhC9RZ4ktdbc/Y
         EAkM9tCkIi6YluhgJmtA1LdWiZk0+6SH78gx0aUkMLuKCTv9pqi6qZuOtq0BWQ+KF4
         aSaExt9xh0f/6NtdQYbguDq2H6derCniugIdfRqj/JJbnAZ4ZaFcUs0uVp18yWxo7R
         Pp373vOEIEmOs11a9PT/dIqd4Xgo8Fhm8/o+N8CjVXDvtr25eyX8FVW+bMLaJeqY1o
         i8P+jDaHaiuGMM4WrKUj0+EpMnSxYJ4JMmt86EjHGXUnu+tsEccpBXS2d1ty8lEbA1
         Y0RJnmaEVXeJQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [mlx5-next 16/17] net/mlx5: Add reset_state field to MFRL register
Date:   Tue, 22 Feb 2022 21:09:31 -0800
Message-Id: <20220223050932.244668-17-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223050932.244668-1-saeed@kernel.org>
References: <20220223050932.244668-1-saeed@kernel.org>
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


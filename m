Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EBC60951F
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 19:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiJWRXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 13:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiJWRXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 13:23:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E83D74E3E
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 10:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEA7E60A48
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 17:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE3FC433C1;
        Sun, 23 Oct 2022 17:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666545792;
        bh=pP9hlLMujiVLzkBS4BAe+6oUuA9UHzDEnbtXDhe6idM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azjHJhW7KeWhBDUFla88IeApkjy2NEd7V39RfSVUEu89hDfjinS+XJCcP4Uml3Tyt
         ef7WBFhY2fphU4rYLxIS+qVPCGb4I/ur4S/adLzD/S0xLRKhqI2X+halFE+UHOo/AH
         7RFzYxBzvTQY5wuUWhtDK3O0UD+gTlAv0oGmXiz47Wj+5SNsh97nLqdgK0J9fRPb3f
         +IfcUaibFh+BzJYLi4BR5EvSelp15y0d4+SD5vyC6AEGDC6KIhikkopqTQtlx+o3cY
         Rq0QiUQydRO6xh04xi3aSyLhy38OE53yKHgCMhhOTrU9bj0VxyWa9eXHmlZnel1zrT
         T3DHQSDEqr5dA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 2/6] net/mlx5: Return ready to use ASO WQE
Date:   Sun, 23 Oct 2022 20:22:54 +0300
Message-Id: <081372b10853d727085470e1f389dd29ca29479f.1666545480.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666545480.git.leonro@nvidia.com>
References: <cover.1666545480.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

There is no need in hiding returned ASO WQE type by providing void*,
use the real type instead. Do it together with zeroing that memory,
so ASO WQE will be ready to use immediately.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c     | 7 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h     | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index be74e1403328..25cd449e8aad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -162,7 +162,6 @@ mlx5e_tc_meter_modify(struct mlx5_core_dev *mdev,
 			   MLX5_ACCESS_ASO_OPC_MOD_FLOW_METER);
 
 	aso_ctrl = &aso_wqe->aso_ctrl;
-	memset(aso_ctrl, 0, sizeof(*aso_ctrl));
 	aso_ctrl->data_mask_mode = MLX5_ASO_DATA_MASK_MODE_BYTEWISE_64BYTE << 6;
 	aso_ctrl->condition_1_0_operand = MLX5_ASO_ALWAYS_TRUE |
 					  MLX5_ASO_ALWAYS_TRUE << 4;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
index baa8092f335e..88655d5746d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
@@ -349,12 +349,15 @@ void mlx5_aso_build_wqe(struct mlx5_aso *aso, u8 ds_cnt,
 	cseg->general_id = cpu_to_be32(obj_id);
 }
 
-void *mlx5_aso_get_wqe(struct mlx5_aso *aso)
+struct mlx5_aso_wqe *mlx5_aso_get_wqe(struct mlx5_aso *aso)
 {
+	struct mlx5_aso_wqe *wqe;
 	u16 pi;
 
 	pi = mlx5_wq_cyc_ctr2ix(&aso->wq, aso->pc);
-	return mlx5_wq_cyc_get_wqe(&aso->wq, pi);
+	wqe = mlx5_wq_cyc_get_wqe(&aso->wq, pi);
+	memset(wqe, 0, sizeof(*wqe));
+	return wqe;
 }
 
 void mlx5_aso_post_wqe(struct mlx5_aso *aso, bool with_data,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
index 2d40dcf9d42e..4312614bf3bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
@@ -77,7 +77,7 @@ enum {
 
 struct mlx5_aso;
 
-void *mlx5_aso_get_wqe(struct mlx5_aso *aso);
+struct mlx5_aso_wqe *mlx5_aso_get_wqe(struct mlx5_aso *aso);
 void mlx5_aso_build_wqe(struct mlx5_aso *aso, u8 ds_cnt,
 			struct mlx5_aso_wqe *aso_wqe,
 			u32 obj_id, u32 opc_mode);
-- 
2.37.3


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F20D640EE7
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbiLBULF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbiLBULB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:11:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918C0F37FC
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:10:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 442BAB82277
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72137C433C1;
        Fri,  2 Dec 2022 20:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670011856;
        bh=wlrwo+8/RwiRmKkYEGja0Hs8rQmUkIOyHb6eMOY6LwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7u52RSDR/uo2pw/Jrn32zI7FoWEzpf7O+eBxCpykg2BtDDw+rCLs1Pn69SHMtcq+
         eQD3+p4wVpTfhyRgHBr5861gNiewzt5f0sfS08S2WOR9KPJaJ1MeEylq93t8vOPqoD
         nddZ1OBrp63efv/mHBLtKwysHHrORFbT24Ed1IYJCwDeUt1VIItk9ZSrYUHWZaQ13F
         nZtAgdYveVVI84muBXW0MVZxi1lLzLhyohWmJRm0zGa5PAlpW3jv6fTxRD5vdWJQl2
         b5V2kTJRkAbOAeRecMF+LxbHg3PZ+hWSP8SXMEHTRW7rlerEp6iIkAWIy/1SsRynOm
         ficAXEulBWBjA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 01/16] net/mlx5: Return ready to use ASO WQE
Date:   Fri,  2 Dec 2022 22:10:22 +0200
Message-Id: <5bbd3960d71aa6c63398393561dfffd67ce43f14.1670011671.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011671.git.leonro@nvidia.com>
References: <cover.1670011671.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

There is no need in hiding returned ASO WQE type by providing void*,
use the real type instead. Do it together with zeroing that memory,
so ASO WQE will be ready to use immediately.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
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
index 0f9e4f01c85a..5a80fb7dbbca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
@@ -353,12 +353,15 @@ void mlx5_aso_build_wqe(struct mlx5_aso *aso, u8 ds_cnt,
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
2.38.1


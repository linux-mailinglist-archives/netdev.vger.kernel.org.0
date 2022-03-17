Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9957F4DCE29
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237727AbiCQSz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237718AbiCQSzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9AC163E3B
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D90DB81F9C
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4A4C340F2;
        Thu, 17 Mar 2022 18:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543268;
        bh=W205W1UQ6hwi4k7FHWP2MrqI8HX34gfSa7dq9uaoULY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWztsx8sD3RBxF70QDUauzBuD6o1avKtFZ0P6kKdeU88dZ2z91qFQVMdZR86jtIML
         8A2HzvecnjgPdhNFPXgBlnTrW/gmAh9i0s8d368r8+XnOrwdBAWba628ax7oFYP48r
         bjI0bXjl5559vcJomOHAbnpgOTQ6UIO3aedPWCFJj8aE9GYpItX3AdrMzwYzkMOtn3
         ON791ACbPEWpTgjjLx6KiIP4laRp/+SKxE4QxK0GnHTIFD3Upq2FsVJzmXoN/9CNwQ
         M2bET4yETaTYPiwoeWkP+y5/N02D3BuVXSO2C7jQlViwtqasUaVmNWgH7adAcZEJtd
         nT+zb6JtdiV+w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5e: Validate MTU when building non-linear legacy RQ fragments info
Date:   Thu, 17 Mar 2022 11:54:10 -0700
Message-Id: <20220317185424.287982-2-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317185424.287982-1-saeed@kernel.org>
References: <20220317185424.287982-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

mlx5e_build_rq_frags_info() assumes that MTU is not bigger than
PAGE_SIZE * MLX5E_MAX_RX_FRAGS, which is 16K for 4K pages. Currently,
the firmware limits MTU to 10K, so the assumption doesn't lead to a bug.

This commits adds an additional driver check for reliability, since the
firmware boundary might be changed.

The calculation is taken to a separate function with a comment
explaining it. It's a preparation for the following patches that
introcuce XDP multi buffer support.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   | 34 +++++++++++++++----
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 0bd8698f7226..0f258e7a65e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -392,16 +392,23 @@ void mlx5e_build_create_cq_param(struct mlx5e_create_cq_param *ccp, struct mlx5e
 	};
 }
 
+static int mlx5e_max_nonlinear_mtu(int frag_size)
+{
+	/* Optimization for small packets: the last fragment is bigger than the others. */
+	return (MLX5E_MAX_RX_FRAGS - 1) * frag_size + PAGE_SIZE;
+}
+
 #define DEFAULT_FRAG_SIZE (2048)
 
-static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
-				      struct mlx5e_params *params,
-				      struct mlx5e_xsk_param *xsk,
-				      struct mlx5e_rq_frags_info *info)
+static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
+				     struct mlx5e_params *params,
+				     struct mlx5e_xsk_param *xsk,
+				     struct mlx5e_rq_frags_info *info)
 {
 	u32 byte_count = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	int frag_size_max = DEFAULT_FRAG_SIZE;
 	u32 buf_size = 0;
+	int max_mtu;
 	int i;
 
 	if (mlx5_fpga_is_ipsec_device(mdev))
@@ -420,10 +427,18 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 		goto out;
 	}
 
-	if (byte_count > PAGE_SIZE +
-	    (MLX5E_MAX_RX_FRAGS - 1) * frag_size_max)
+	max_mtu = mlx5e_max_nonlinear_mtu(frag_size_max);
+	if (byte_count > max_mtu) {
 		frag_size_max = PAGE_SIZE;
 
+		max_mtu = mlx5e_max_nonlinear_mtu(frag_size_max);
+		if (byte_count > max_mtu) {
+			mlx5_core_err(mdev, "MTU %u is too big for non-linear legacy RQ (max %d)\n",
+				      params->sw_mtu, max_mtu);
+			return -EINVAL;
+		}
+	}
+
 	i = 0;
 	while (buf_size < byte_count) {
 		int frag_size = byte_count - buf_size;
@@ -444,6 +459,8 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 out:
 	info->wqe_bulk = max_t(u8, info->wqe_bulk, 8);
 	info->log_num_frags = order_base_2(info->num_frags);
+
+	return 0;
 }
 
 static u8 mlx5e_get_rqwq_log_stride(u8 wq_type, int ndsegs)
@@ -540,6 +557,7 @@ int mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
 	void *rqc = param->rqc;
 	void *wq = MLX5_ADDR_OF(rqc, rqc, wq);
 	int ndsegs = 1;
+	int err;
 
 	switch (params->rq_wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ: {
@@ -579,7 +597,9 @@ int mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
 	}
 	default: /* MLX5_WQ_TYPE_CYCLIC */
 		MLX5_SET(wq, wq, log_wq_sz, params->log_rq_mtu_frames);
-		mlx5e_build_rq_frags_info(mdev, params, xsk, &param->frags_info);
+		err = mlx5e_build_rq_frags_info(mdev, params, xsk, &param->frags_info);
+		if (err)
+			return err;
 		ndsegs = param->frags_info.num_frags;
 	}
 
-- 
2.35.1


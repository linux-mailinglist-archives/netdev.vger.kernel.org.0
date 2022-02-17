Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B3B4B9A40
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbiBQH44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:56:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236751AbiBQH4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:56:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D88765E
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:56:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCF7961B50
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4142DC340F4;
        Thu, 17 Feb 2022 07:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645084596;
        bh=Ipu4LprKcKhN05p5rGox1S9qEnzOjZIk+TCL+kvCxak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdvsNMBmyuZDOxMxSYytA8Mrg8bGVfZqep6cIgdbLo9MrH0vb6AlJ07rTMr17kd3b
         3xyHXLWyeJStos3+5q0jr3DmHKIMC/1W6S5r04cM0e0mVwuVI+YN+9/iOu+uQzgvOb
         lvRDy52LU9f1nAahLFLsybmlC6hLuWdZ/0p0tdh7eujwzsX2ran6GM4S8cdLN0JkG0
         5zbrJFYWjGoNhIHvnsbFyxzRonbnmuZfmH9GT3rUfS/wVxt11jzTAM2qZeuT4jEmpI
         6RF4WujAxI6NXvOvw2xPNE9le1NoveFg22dNcQ6hv8Q7t1KMroqQbCTLJ0eDMCzrQG
         vUr9e6kBUUyMA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: Default to Striding RQ when not conflicting with CQE compression
Date:   Wed, 16 Feb 2022 23:56:21 -0800
Message-Id: <20220217075632.831542-5-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217075632.831542-1-saeed@kernel.org>
References: <20220217075632.831542-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

CQE compression is turned on by default on slow pci systems to help
reduce the load on pci.
In this case, Striding RQ was turned off as CQEs of packets that span
several strides were not compressed, significantly reducing the compression
effectiveness.
This issue does not exist when using the newer mini_cqe format "stride_index".
Hence, allow defaulting to Striding RQ in this case.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index d41936d65483..2d9707c024b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -359,12 +359,13 @@ void mlx5e_build_rq_params(struct mlx5_core_dev *mdev,
 {
 	/* Prefer Striding RQ, unless any of the following holds:
 	 * - Striding RQ configuration is not possible/supported.
-	 * - Slow PCI heuristic.
+	 * - CQE compression is ON, and stride_index mini_cqe layout is not supported.
 	 * - Legacy RQ would use linear SKB while Striding RQ would use non-linear.
 	 *
 	 * No XSK params: checking the availability of striding RQ in general.
 	 */
-	if (!slow_pci_heuristic(mdev) &&
+	if ((!MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS) ||
+	     MLX5_CAP_GEN(mdev, mini_cqe_resp_stride_index)) &&
 	    mlx5e_striding_rq_possible(mdev, params) &&
 	    (mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL) ||
 	     !mlx5e_rx_is_linear_skb(params, NULL)))
-- 
2.34.1


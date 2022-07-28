Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853AF584737
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbiG1UrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiG1Uq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:46:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7C06BD64
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:46:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB974617B7
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2147EC433C1;
        Thu, 28 Jul 2022 20:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041215;
        bh=VNUtvnY3L0444Wj8MWyQ0pAcW4wbqEp+4Jz+u8C57/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUbx/mJgV330emRtIbWxeYVCk7GelO3Bgd6+PAUnfWv3ZiqD4sBYvZU8pW+r9nDLq
         Pde8L0zDYfpmlybTbQRKwi6TkeHeyu4W7UieQ0a9FzS+ro8FbKo8yMY5a7TkNX4ndf
         qLRpWEvk6Eo7XMK++MbjuInKzBqzP31sJF8bHgrZyWDluvt9yKw7ilfcjp+2UzcoLj
         MZ39rip5JjTLYljoDiN8MtPgY0mhWamJyQLV3zJpBQ/OgIGGfjVyfuSPgDKNXPmqQm
         BRrMpoIbfFDOPMKk249LUMcOCl6VB3CapbCKXOT70zTGfp4tF8ctAU9T1KUTGR91Rw
         DJA9LqOrsxkJg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net 4/9] net/mlx5e: xsk: Account for XSK RQ UMRs when calculating ICOSQ size
Date:   Thu, 28 Jul 2022 13:46:35 -0700
Message-Id: <20220728204640.139990-5-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728204640.139990-1-saeed@kernel.org>
References: <20220728204640.139990-1-saeed@kernel.org>
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

From: Maxim Mikityanskiy <maximmi@nvidia.com>

ICOSQ is used to post UMR WQEs for both regular RQ and XSK RQ. However,
space in ICOSQ is reserved only for the regular RQ, which may cause
ICOSQ overflows when using XSK (the most risk is on activating
channels).

This commit fixes the issue by reserving space for XSK UMR WQEs as well.
As XSK may be enabled without restarting the channel and recreating the
ICOSQ, this space is reserved unconditionally.

Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 3c1edfa33aa7..e025040350ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -790,8 +790,20 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5_core_dev *mdev,
 		return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
 
 	wqebbs = MLX5E_UMR_WQEBBS * BIT(mlx5e_get_rq_log_wq_sz(rqp->rqc));
+
+	/* If XDP program is attached, XSK may be turned on at any time without
+	 * restarting the channel. ICOSQ must be big enough to fit UMR WQEs of
+	 * both regular RQ and XSK RQ.
+	 * Although mlx5e_mpwqe_get_log_rq_size accepts mlx5e_xsk_param, it
+	 * doesn't affect its return value, as long as params->xdp_prog != NULL,
+	 * so we can just multiply by 2.
+	 */
+	if (params->xdp_prog)
+		wqebbs *= 2;
+
 	if (params->packet_merge.type == MLX5E_PACKET_MERGE_SHAMPO)
 		wqebbs += mlx5e_shampo_icosq_sz(mdev, params, rqp);
+
 	return max_t(u8, MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE, order_base_2(wqebbs));
 }
 
-- 
2.37.1


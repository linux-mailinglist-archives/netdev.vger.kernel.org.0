Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B15C5EEED8
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbiI2HXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235197AbiI2HWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:22:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878C81166C4
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A665F6205C
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B10C433D6;
        Thu, 29 Sep 2022 07:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664436166;
        bh=7F3AXLGhiZgt4ss5nRFHzMhjEPZ29acwYGw186U+ezo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKc1bWYeVSx2cvmSjccmX5G7qFB8F0sFcB2J7CzexVIpZnWMP22ZCQQWFp/umXZ1r
         eGcG2L9NWFEsQ75UqxbdoiTsCGIAvB98PqTekS1uYdBHaugeDvG6OeRu7XI+orTLoK
         astlwD3ZW8Ts9f2wOEEWunS1CcHpWfwyGxs/GYX2s8QgwExlxBZEeJIUG7eF27dLtd
         azPUzm5tQZgYF0aei4BbbaR9gLCIufC4nvZe1X/maGsR0JjqulK/cDneaBcCxEI8fk
         xz96uSV/FBBE605/Q4+Uw3a7y9mMsqQlXTEj6DOnPFZjnSOMMkBR9qtLX44CknTjNX
         Eftpf02SUdN5A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 08/16] net/mlx5e: Fix calculations for ICOSQ size
Date:   Thu, 29 Sep 2022 00:21:48 -0700
Message-Id: <20220929072156.93299-9-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220929072156.93299-1-saeed@kernel.org>
References: <20220929072156.93299-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

WQEs must not cross page boundaries, they are padded with NOPs if they
don't fit the page. mlx5e_mpwrq_total_umr_wqebbs doesn't take into
account this padding, risking reserving not enough space.

The padding is not straightforward to add to this calculation, because
WQEs of different sizes may be mixed together in the queue. If each page
ends with a big WQE that doesn't fit and requires at most its size minus
1 WQEBB of padding, the total space can be much bigger than in case when
smaller WQEs take advantage of this padding.

Replace the wrong exact calculation by the following estimation. Each
padding can be at most the size of the maximum WQE used in the queue
minus one WQEBB. Let's call the rest of the page "useful space". If we
divide the total size of all needed WQEs by this useful space, rounding
up, we'll get the number of pages, which is enough to contain all these
WQEs. It's correct, because every WQE that appeared on the boundary
between two blocks of useful space would start in the useful space of
one page and end in the padding of the same page, while our estimation
reserved space for its tail in the next space, making the estimation not
smaller than the real space occupied in the queue.

The code actually uses a looser estimation: instead of taking the
maximum size of all used WQE types minus 1 WQEBB, it takes the maximum
hardware size of a WQE. It's made for simplicity and extensibility.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/params.c    | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 0f18031a871a..68bc66cbd8a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -951,7 +951,7 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5_core_dev *mdev,
 				      struct mlx5e_params *params,
 				      struct mlx5e_rq_param *rqp)
 {
-	u32 wqebbs;
+	u32 wqebbs, total_pages, useful_space;
 
 	/* MLX5_WQ_TYPE_CYCLIC */
 	if (params->rq_wq_type != MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ)
@@ -998,6 +998,18 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5_core_dev *mdev,
 	if (params->packet_merge.type == MLX5E_PACKET_MERGE_SHAMPO)
 		wqebbs += mlx5e_shampo_icosq_sz(mdev, params, rqp);
 
+	/* UMR WQEs don't cross the page boundary, they are padded with NOPs.
+	 * This padding is always smaller than the max WQE size. That gives us
+	 * at least (PAGE_SIZE - (max WQE size - MLX5_SEND_WQE_BB)) useful bytes
+	 * per page. The number of pages is estimated as the total size of WQEs
+	 * divided by the useful space in page, rounding up. If some WQEs don't
+	 * fully fit into the useful space, they can occupy part of the padding,
+	 * which proves this estimation to be correct (reserve enough space).
+	 */
+	useful_space = PAGE_SIZE - mlx5e_get_max_sq_wqebbs(mdev) + MLX5_SEND_WQE_BB;
+	total_pages = DIV_ROUND_UP(wqebbs * MLX5_SEND_WQE_BB, useful_space);
+	wqebbs = total_pages * (PAGE_SIZE / MLX5_SEND_WQE_BB);
+
 	return max_t(u8, MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE, order_base_2(wqebbs));
 }
 
-- 
2.37.3


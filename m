Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A5A4B9A39
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236805AbiBQH5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:57:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236771AbiBQH4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:56:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CA265C7
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:56:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AEC4B82160
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C61C340EC;
        Thu, 17 Feb 2022 07:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645084597;
        bh=3N53/NsZYl5JctVnz2lbIBJGejwR119AmXmXLfvVF28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlWtY4/nzYMPAbkjx3M9iFmD9ts+Dh9+xY9871LH53kDZ3Bc9RxaaUchLYv40Ggan
         VaY5+OkK5+XGDkN4Slc0JxoQ0H35bXIvrUFaKHTRryvzR+RZi068tt/09gAyg65E6A
         57+VUxeT70YCgbuwV+f8ScZJSVdRVmawpEwN1cPeiVZjxm5oFaQE+A0eA1G8XKAHEB
         NpNNSt5cbxZ5OU9PH589m2USIxKG1P+rC9cB4Olty2sOEzfVsEBLyl37E3ReAXAvWV
         Zh667nGQj/3zL1F4b1FJC6gZpGVvM+B2IJOh2HXmJ/7Cta8aHzM/CT+D7/WonBny7J
         19i7do/dyMpVQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: RX, Restrict bulk size for small Striding RQs
Date:   Wed, 16 Feb 2022 23:56:22 -0800
Message-Id: <20220217075632.831542-6-saeed@kernel.org>
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

In RQs of type multi-packet WQE (Striding RQ), each WQE is relatively
large (typically 256KB) but their number is relatively small (8 in
default).

Re-mapping the descriptors' buffers before re-posting them is done via
UMR (User-Mode Memory Registration) operations.

On the one hand, posting UMR WQEs in bulks reduces communication overhead
with the HW and better utilizes its processing units.
On the other hand, delaying the WQE repost operations for a small RQ
(say, of 4 WQEs) might drastically hit its performance, causing packet
drops due to no receive buffer, for high or bursty incoming packets rate.

Here we restrict the bulk size for too small RQs. Effectively, with the current
constants, RQ of size 4 (minimum allowed) would have no bulking, while larger
RQs will continue working with bulks of 2.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h        | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 3 +--
 5 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index e29ac77e9bec..2704c7537481 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -714,6 +714,7 @@ struct mlx5e_rq {
 			u8                     umr_in_progress;
 			u8                     umr_last_bulk;
 			u8                     umr_completed;
+			u8                     min_wqe_bulk;
 			struct mlx5e_shampo_hd *shampo;
 		} mpwqe;
 	};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 2d9707c024b0..0bd8698f7226 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -178,6 +178,12 @@ u8 mlx5e_mpwqe_get_log_num_strides(struct mlx5_core_dev *mdev,
 		mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk);
 }
 
+u8 mlx5e_mpwqe_get_min_wqe_bulk(unsigned int wq_sz)
+{
+#define UMR_WQE_BULK (2)
+	return min_t(unsigned int, UMR_WQE_BULK, wq_sz / 2 - 1);
+}
+
 u16 mlx5e_get_rq_headroom(struct mlx5_core_dev *mdev,
 			  struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 433e6967692d..47a368112e31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -129,6 +129,7 @@ u8 mlx5e_mpwqe_get_log_stride_size(struct mlx5_core_dev *mdev,
 u8 mlx5e_mpwqe_get_log_num_strides(struct mlx5_core_dev *mdev,
 				   struct mlx5e_params *params,
 				   struct mlx5e_xsk_param *xsk);
+u8 mlx5e_mpwqe_get_min_wqe_bulk(unsigned int wq_sz);
 u16 mlx5e_get_rq_headroom(struct mlx5_core_dev *mdev,
 			  struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b157c7aac4ca..b2ed2f6d4a92 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -595,6 +595,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		rq->mpwqe.log_stride_sz = mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk);
 		rq->mpwqe.num_strides =
 			BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk));
+		rq->mpwqe.min_wqe_bulk = mlx5e_mpwqe_get_min_wqe_bulk(wq_sz);
 
 		rq->buff.frame0_sz = (1 << rq->mpwqe.log_stride_sz);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 3fe4f06f3e71..4cb7c7135b6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -960,8 +960,7 @@ INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
 	if (unlikely(rq->mpwqe.umr_in_progress > rq->mpwqe.umr_last_bulk))
 		rq->stats->congst_umr++;
 
-#define UMR_WQE_BULK (2)
-	if (likely(missing < UMR_WQE_BULK))
+	if (likely(missing < rq->mpwqe.min_wqe_bulk))
 		return false;
 
 	if (rq->page_pool)
-- 
2.34.1


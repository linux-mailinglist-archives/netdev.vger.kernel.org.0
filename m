Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F56F63CE95
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbiK3FMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbiK3FME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3651F69338
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:12:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2A1861A0D
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C97AC433C1;
        Wed, 30 Nov 2022 05:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785122;
        bh=nNJLZEtb28IWE5NXJazUTRhA4a7Xn6DIhlBcwO4BhrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuAbtHm1rPo1ed5VfADbA4svD0ubBsUOCp8pNsdPXSOfuiRq8+aNr5vMMvo5/YC5o
         rLZptumefcEK0AEIbS+JqjvGPPh7aHJKFwWmBRwMa3ru/NWgwc+iHi7E9rPjw8gIxY
         lbwiIR0ptelilFAmxuGGu0pPD99ZZcRh+oGWiVLOPAi90cbsQ5riYk44lBW0hgZRmX
         dSCK+eHOrz5SkLnrleyN7bdReQlT31/iNeP1Kp+ixtUqYD2RUmNJ+dhFRK0qhYGTAu
         RRI1JtdZQ2nvAzHw2wkxr0aQgTTlRxYfd/feE/bYz2WyY+bSDMRDvkAGMf03angwAc
         WSFirxVLNXL/Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: Add padding when needed in UMR WQEs
Date:   Tue, 29 Nov 2022 21:11:41 -0800
Message-Id: <20221130051152.479480-5-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130051152.479480-1-saeed@kernel.org>
References: <20221130051152.479480-1-saeed@kernel.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

Per the device spec, MTTs/KLMs list in a UMR WQE must be aligned to 64B.
Per our SW design, the MTT/KLMs list would need alignment only if it's
too small, for example on PPC when PAGE_SIZE is 64KB, and only 4 pages
are needed to cover a MPWQE of size 256KB.

Padding, if needed, is taken into account when calculating the UMR WQE
fields (ds_cnt and xlt_octowords), however no entries are provided,
instead garbage is passed.

No real harm though, as these parts act as gaps between the RX MPWQEs
and not used by any of them. Hence, in practice, device does not try to
write any incoming packet to them. Still, prefer providing clean padding
marking the end of the list, and do not map garbage into the RQ memory
region.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 11 +++++++++++
 include/linux/mlx5/device.h                     |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index b1ea0b995d9c..8d71736116e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -727,6 +727,17 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		};
 	}
 
+	/* Pad if needed, in case the value set to ucseg->xlt_octowords
+	 * in mlx5e_build_umr_wqe() needed alignment.
+	 */
+	if (rq->mpwqe.pages_per_wqe & (MLX5_UMR_MTT_NUM_ENTRIES_ALIGNMENT - 1)) {
+		int pad = ALIGN(rq->mpwqe.pages_per_wqe, MLX5_UMR_MTT_NUM_ENTRIES_ALIGNMENT) -
+			rq->mpwqe.pages_per_wqe;
+
+		memset(&umr_wqe->inline_mtts[rq->mpwqe.pages_per_wqe], 0,
+		       sizeof(*umr_wqe->inline_mtts) * pad);
+	}
+
 	bitmap_zero(wi->xdp_xmit_bitmap, rq->mpwqe.pages_per_wqe);
 	wi->consumed_strides = 0;
 
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index eb3fac30488b..97275965f156 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -294,6 +294,7 @@ enum {
 #define MLX5_UMR_MTT_ALIGNMENT 0x40
 #define MLX5_UMR_MTT_MASK      (MLX5_UMR_MTT_ALIGNMENT - 1)
 #define MLX5_UMR_MTT_MIN_CHUNK_SIZE MLX5_UMR_MTT_ALIGNMENT
+#define MLX5_UMR_MTT_NUM_ENTRIES_ALIGNMENT (MLX5_UMR_MTT_ALIGNMENT / sizeof(struct mlx5_mtt))
 
 #define MLX5_USER_INDEX_LEN (MLX5_FLD_SZ_BYTES(qpc, user_index) * 8)
 
-- 
2.38.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5BE5EEED7
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbiI2HXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbiI2HW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:22:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9261C118DEB
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81E6BB8232C
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298F8C433B5;
        Thu, 29 Sep 2022 07:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664436171;
        bh=z5YzZ4/IyOI4Anay2tpK29Z8CEYk90vNjlu9drhFRLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvC17If/oBKikrHwISY10MX66asVF+NlEs9ogoxuBryNBS2i7XWTf5KCovc7OhcLP
         vTaCpwg17zIrrGArOOE+eCkQAssB9du221Pbeh6AIIJAnpuoOE0n4ycOHABplNZsIq
         4RgJ/fiEmcyB8vsBG1J8JMOikWUcmY71EzSsLW9JCDpENc3KLZEEBAjtfhkOwAdtqY
         HPkGWHtKP7TaMwQXcvhGlrhDKzViqGZz5poeKl/ymMM6j57RhCMo2cXifmOBe0KcPh
         iAEPP904NZX8i8h9QG7/wY3+1jSIxdSQ7nvSg5NBECE5QblL3kuYcjf2o2be5n+YTW
         Q3kl4t48sJsjQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 13/16] net/mlx5e: xsk: Remove mlx5e_xsk_page_alloc_pool
Date:   Thu, 29 Sep 2022 00:21:53 -0700
Message-Id: <20220929072156.93299-14-saeed@kernel.org>
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

mlx5e_xsk_page_alloc_pool became a thin wrapper around xsk_buff_alloc.
Drop it and call xsk_buff_alloc directly.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h | 10 ----------
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     |  8 +++++---
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index 53a833c9b09e..e702cb790476 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -18,16 +18,6 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      struct mlx5e_wqe_frag_info *wi,
 					      u32 cqe_bcnt);
 
-static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
-					    union mlx5e_alloc_unit *au)
-{
-	au->xsk = xsk_buff_alloc(rq->xsk_pool);
-	if (!au->xsk)
-		return -ENOMEM;
-
-	return 0;
-}
-
 static inline bool mlx5e_xsk_update_rx_wakeup(struct mlx5e_rq *rq, bool alloc_err)
 {
 	if (!xsk_uses_need_wakeup(rq->xsk_pool))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 0d0064d66c09..72d74de3ee99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -302,10 +302,12 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq, union mlx5e_alloc_u
 
 static inline int mlx5e_page_alloc(struct mlx5e_rq *rq, union mlx5e_alloc_unit *au)
 {
-	if (rq->xsk_pool)
-		return mlx5e_xsk_page_alloc_pool(rq, au);
-	else
+	if (rq->xsk_pool) {
+		au->xsk = xsk_buff_alloc(rq->xsk_pool);
+		return likely(au->xsk) ? 0 : -ENOMEM;
+	} else {
 		return mlx5e_page_alloc_pool(rq, au);
+	}
 }
 
 void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct page *page)
-- 
2.37.3


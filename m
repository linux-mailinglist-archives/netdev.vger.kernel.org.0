Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40515F215E
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 07:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiJBFOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 01:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJBFN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 01:13:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A78B5072C
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:13:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCA6B60DEA
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 05:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAFDC433C1;
        Sun,  2 Oct 2022 05:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664687638;
        bh=8inOEseV7Nsqquh8WSRGMWBNVrQN8jX7wnVpYag5Vbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iedIarlA4ReIkR3rVzR6n/I1vaNQSeuwSSrUI/ZASIV1o3SbgrNdf+hVgAKDRs/sS
         2V1cI58sipFmw4GlhDJAYk1nUZJHxl39ztAi0pfLJZeKoQaB9qmcAr6+UidcGzekRA
         IkSk36RQQikrRFNhxA5UCYIU53IZZ4jRAUtWOuAA9k7YwantTrQJyMPBTHKa+bFE2t
         C3VtFqBlUltODRg71tMk8obIwW/mfeeTYh7UCf4dYDrHngwdP0HEQNRepWZkJoN7t9
         /E/qV9SzvKYbvaz+17bAA9WvgvyuYWYMre/2PmCIUb7JSw5mZrgEuxdAUSdotvhN9z
         b9bTV2yXZJYmg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 03/15] net/mlx5e: xsk: Include XSK skb_from_cqe callbacks in INDIRECT_CALL
Date:   Sat,  1 Oct 2022 21:56:20 -0700
Message-Id: <20221002045632.291612-4-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221002045632.291612-1-saeed@kernel.org>
References: <20221002045632.291612-1-saeed@kernel.org>
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

XSK is a performance-critical data path. To avoid an indirect function
call with a retpoline, include XSK callbacks in the INDIRECT_CALL macro,
so that they are called directly in XSK flows.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 36eda4c958a0..5835d86be8d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1709,9 +1709,10 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 		goto free_wqe;
 	}
 
-	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
+	skb = INDIRECT_CALL_3(rq->wqe.skb_from_cqe,
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
+			      mlx5e_xsk_skb_from_cqe_linear,
 			      rq, wi, cqe_bcnt);
 	if (!skb) {
 		/* probably for XDP */
@@ -2180,9 +2181,10 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 
 	cqe_bcnt = mpwrq_get_cqe_byte_cnt(cqe);
 
-	skb = INDIRECT_CALL_2(rq->mpwqe.skb_from_cqe_mpwrq,
+	skb = INDIRECT_CALL_3(rq->mpwqe.skb_from_cqe_mpwrq,
 			      mlx5e_skb_from_cqe_mpwrq_linear,
 			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
+			      mlx5e_xsk_skb_from_cqe_mpwrq_linear,
 			      rq, wi, cqe_bcnt, head_offset, page_idx);
 	if (!skb)
 		goto mpwrq_cqe_out;
-- 
2.37.3


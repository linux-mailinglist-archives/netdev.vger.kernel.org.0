Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F7E698922
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 01:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjBPAJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 19:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjBPAJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 19:09:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D01238EBA
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 16:09:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FF03B824B1
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE660C433A7;
        Thu, 16 Feb 2023 00:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676506168;
        bh=hONCsEQWl8uhkhv5qqWz+USaUYnohHGfg2m+YVl/lTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kADafHoeapHdCBxFrMmj0FWgNdfRfsHipxVrZelv61zHr7C26T1T0ZzhD4vyG6HMQ
         e03MyCVcIA7SLJYyVQ2p2jaRaYqV4e9hXBLmaCIJM+lq7Hi7vivBF7bDuWddvtb8WH
         Ia+apHWiPH4Mj3+pXan5aaW97cgHV0DIOYKILcrprvXpM4jiPADVtrRYQZEDugOQXI
         aiZseLQeLavmeL70qBUhQXe/Tnn/oPyHtVBezx0I+UpYzY5oQ9vOQBAlmAMjxx5uwC
         h/4FxcTytCGI1IbB+KRjP+QGDMzzkGrRG0L6QXo4KWbrDF28GgVfwRYSqzTD3oUYRk
         wdxB+/GQmB8+g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 9/9] net/mlx5e: RX, Remove doubtful unlikely call
Date:   Wed, 15 Feb 2023 16:09:18 -0800
Message-Id: <20230216000918.235103-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216000918.235103-1-saeed@kernel.org>
References: <20230216000918.235103-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

When building an skb in non-linear mode, it is not likely nor unlikely
that the xdp buff has fragments, it depends on the size of the packet
received.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index ac570945d5d2..e79dcc2a6007 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1718,7 +1718,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 
 	page_ref_inc(head_wi->au->page);
 
-	if (unlikely(xdp_buff_has_frags(&mxbuf.xdp))) {
+	if (xdp_buff_has_frags(&mxbuf.xdp)) {
 		int i;
 
 		/* sinfo->nr_frags is reset by build_skb, calculate again. */
-- 
2.39.1


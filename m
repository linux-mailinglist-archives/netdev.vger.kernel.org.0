Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39232698919
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 01:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjBPAJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 19:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBPAJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 19:09:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF023866F
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 16:09:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0EDC61E12
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA094C433A8;
        Thu, 16 Feb 2023 00:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676506161;
        bh=1d0r2+LMJ8NCuxYA1bRRhTNLV9OozhLp3nSOLoLCm1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROFv9tqmOxJDcm/fXHLzyR8wR1FnuYB+clvBFrmZUKzAh+OnTo9br9RRBB1toE+5u
         No57g7edYzDNv3AYa+ENr95muT8QXNhkjUEQgCX1iI7XcsDjVr/QKtTv/Ni765IMTx
         SKYW7CrIvlG8DPDRSSDsxVTiTIqbMAXpjo2ThMH88PtsMo4/LrsiRh9ItodLy5Lehf
         nEXb2q4C2ihCn12zvhTWa/0D4o/ngWiBxukNolmjz5bVGR6LYL0NruP4yJolO8Vgmq
         sFNIBRL8KDu38k60FuG2WqnKTCqw5jJnfAwpyN0eLf3rlj7XItigigWG+ES+GHMgg2
         E2eq3pC+fBI+w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 1/9] net/mlx5e: Switch to using napi_build_skb()
Date:   Wed, 15 Feb 2023 16:09:10 -0800
Message-Id: <20230216000918.235103-2-saeed@kernel.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

Use napi_build_skb() which uses NAPI percpu caches to obtain
skbuff_head instead of inplace allocation.

napi_build_skb() calls napi_skb_cache_get(), which returns a cached
skb, or allocates a bulk of NAPI_SKB_CACHE_BULK (16) if cache is empty.

Performance test:
TCP single stream, single ring, single core, default MTU (1500B).

Before: 26.5 Gbits/sec
After:  30.1 Gbits/sec (+13.6%)

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index a9473a51edc1..9ac2c7778b5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1556,7 +1556,7 @@ struct sk_buff *mlx5e_build_linear_skb(struct mlx5e_rq *rq, void *va,
 				       u32 frag_size, u16 headroom,
 				       u32 cqe_bcnt, u32 metasize)
 {
-	struct sk_buff *skb = build_skb(va, frag_size);
+	struct sk_buff *skb = napi_build_skb(va, frag_size);
 
 	if (unlikely(!skb)) {
 		rq->stats->buff_alloc_err++;
-- 
2.39.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9889869B8E2
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 10:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjBRJF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 04:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBRJF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 04:05:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CE6457D0
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 01:05:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1218B821FE
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 09:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E96C4339B;
        Sat, 18 Feb 2023 09:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676711122;
        bh=Gfz1O1WEzmodm5qiwMMv6Jg/WCjo5ea2ii8rpcbr5lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCoYPLSXrAO5dSrFmA1tfi76AImJXyFAg9gXAMHwNZqVa51tvyrh8jgbT6cFV1tCz
         cu0Otnj/I+54baA3Ts7sHuC8cV+EOKbNmwCmwij4NDI8Uh2jUBYJ4ESMWy8dQ1adVs
         Cu0xg0ennUdsN8R3+LPk5sDiJLC5zHEjhjr2bOvRGyPjJUa9Wt3cwWASJRmLVrFyAt
         KNiHIAFZqJnzLZd/okH+vPds8WbxMsj6vmGbA3Iosek3hFefVZb3PKEd0pnkH5/526
         RoS6ipxj+vjJViGI3aRe9knXgjoI+bfdoqnXl7QJ+eUF8vSlLlUoLqMIlcN4/rqgvP
         aghEhhTnBrJBw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: [net-next V2 1/9] net/mlx5e: Switch to using napi_build_skb()
Date:   Sat, 18 Feb 2023 01:05:05 -0800
Message-Id: <20230218090513.284718-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230218090513.284718-1-saeed@kernel.org>
References: <20230218090513.284718-1-saeed@kernel.org>
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
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index b2c7ec4692f0..0af02cc0d5ad 100644
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F9C6EA120
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjDUBkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbjDUBj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:39:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40B14C24
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:39:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 067B26440A
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC13CC433D2;
        Fri, 21 Apr 2023 01:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041185;
        bh=2eH+jmStZQxN8mXFB2MS42hJDSNhM1bkawyavqSioDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIK4nWAPldiCaiEOsWD3euOLcx2Pi84Uv5WTNOI+DUDnELTF1WfXopKiHPGIa6mPx
         8zET1Fdab/osp+re+IuSmFqXkyckyWG70ZUF0ilP+dbYcun4iYQhopMAMsw7FjzIVG
         WximU4A9cQDgnsY0lvBppQcYBI4BmOlYl5jnjZg9Aj/hGFKvSdg4UGEaV3gfihsYog
         AbrL0iYPaToF2xHTriD7wfDtxYoMhSR8EtH+CA2Il1vPPto3X0rJnudzQN8IhlfSEN
         vlifkCcqG9EJUtTQSwGp3nylrvxC6Z0MlZ2SlKzm4s0Hec5tAWfIsWdZV3ykdigF1R
         INU0IVm/uhTUw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: RX, Hook NAPIs to page pools
Date:   Thu, 20 Apr 2023 18:38:46 -0700
Message-Id: <20230421013850.349646-12-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421013850.349646-1-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

Linking the NAPI to the rq page_pool to improve page_pool cache
usage during skb recycling.

Here are the observed improvements for a iperf single stream
test case:

- For 1500 MTU and legacy rq, seeing a 20% improvement of cache usage.

- For 9K MTU, seeing 33-40 % page_pool cache usage improvements for
both striding and legacy rq (depending if the application is running on
the same core as the rq or not).

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7eb1eeb115ca..f5504b699fcf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -857,6 +857,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		pp_params.pool_size = pool_size;
 		pp_params.nid       = node;
 		pp_params.dev       = rq->pdev;
+		pp_params.napi      = rq->cq.napi;
 		pp_params.dma_dir   = rq->buff.map_dir;
 		pp_params.max_len   = PAGE_SIZE;
 
-- 
2.39.2


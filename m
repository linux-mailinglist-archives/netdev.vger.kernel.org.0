Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6D059C971
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbiHVUAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238490AbiHVT7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:59:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0256EBE
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:59:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DA95B81257
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 19:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A620C433D6;
        Mon, 22 Aug 2022 19:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661198375;
        bh=u3Ck3zbKJTUuBB1EcKRu2IC/4FOYG+qrvXAHLaYhxcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kr0JgVIFWP5EYRiWyhkcKgcP6ppBg3ozbnpGsfb5rpynmhTY1ztl1LTE5onvKRix4
         +EtLQV57/9Ec05JrSuVRCQQCMg/Kq+D3hZzvVjGTZAJjuDMQrHsFDWcTDWZeh2ovPo
         Od0vHNGO+Jt8xTbW7KQXqXnNQ7ymvME4hIQXBD9xuyLIqL3uJWVPh9uBmbjHyYRg0P
         zX051w+ARPQpcCN5RAZjLtttRXfCMVYtKw6ZbvNAKViRpugVL581J1AbojxLxFHLhl
         0SnF37EWMTMuC00IR2E8G5EO5Stibzs5OS45GBFIiFYQoTzrG2ilmIZtkadSs+JpbD
         cRPFKgJpNE2kQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Aya Levin <ayal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net 07/13] net/mlx5e: Fix wrong application of the LRO state
Date:   Mon, 22 Aug 2022 12:59:11 -0700
Message-Id: <20220822195917.216025-8-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220822195917.216025-1-saeed@kernel.org>
References: <20220822195917.216025-1-saeed@kernel.org>
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

From: Aya Levin <ayal@nvidia.com>

Driver caches packet merge type in mlx5e_params instance which must be
in perfect sync with the netdev_feature's bit.
Prior to this patch, in certain conditions (*) LRO state was set in
mlx5e_params, while netdev_feature's bit was off. Causing the LRO to
be applied on the RQs (HW level).

(*) This can happen only on profile init (mlx5e_build_nic_params()),
when RQ expect non-linear SKB and PCI is fast enough in comparison to
link width.

Solution: remove setting of packet merge type from
mlx5e_build_nic_params() as netdev features are not updated.

Fixes: 619a8f2a42f1 ("net/mlx5e: Use linear SKB in Striding RQ")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d858667736a3..c65b6a2883d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4769,14 +4769,6 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 	/* RQ */
 	mlx5e_build_rq_params(mdev, params);
 
-	/* HW LRO */
-	if (MLX5_CAP_ETH(mdev, lro_cap) &&
-	    params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
-		/* No XSK params: checking the availability of striding RQ in general. */
-		if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL))
-			params->packet_merge.type = slow_pci_heuristic(mdev) ?
-				MLX5E_PACKET_MERGE_NONE : MLX5E_PACKET_MERGE_LRO;
-	}
 	params->packet_merge.timeout = mlx5e_choose_lro_timeout(mdev, MLX5E_DEFAULT_LRO_TIMEOUT);
 
 	/* CQ moderation params */
-- 
2.37.1


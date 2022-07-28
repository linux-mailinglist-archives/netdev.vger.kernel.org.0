Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EC2584763
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiG1U6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbiG1U5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:57:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB0578219
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:57:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE42EB82593
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64286C433B5;
        Thu, 28 Jul 2022 20:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041851;
        bh=kKHy/xwj6ISQGBV/kAhcXX4wVuq+fK5Fo82fyAk6EQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZClSxyGV7M0Pa9p/c0YtEB+kt3NxsDsOgSHdGi+fGO+sMar399qlnt6ppV3tj7ate
         e0eS9P3IJlERTQAnYZAs0FJE2cqdjpEjZRitUlr8uFMbm7ypiupubeQD8zPjMVnOXG
         MSDRUq1p+2WyAzOXe2PEnu0nkUwNvwXaDE40Vat4ZDlUjUrH9UJ2rDGYyXvvsYs7Ly
         Day6x5aWiScoXftv9BriPKSKSU+tY8R+H6EKxKmUNFELGgVwWs4BYCG/SSc15kpd2d
         zdiDaqWONWnllF33HGIN/gVuVRb27+o5BAccyw8QlWdf2k86h8bl+oLM1vDksfGNXm
         PAZ1L5xZxXX5A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 01/15] net/mlx5e: Fix wrong use of skb_tcp_all_headers() with encapsulation
Date:   Thu, 28 Jul 2022 13:57:14 -0700
Message-Id: <20220728205728.143074-2-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728205728.143074-1-saeed@kernel.org>
References: <20220728205728.143074-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

Use skb_inner_tcp_all_headers() instead of skb_tcp_all_headers() when
transmitting an encapsulated packet in mlx5e_tx_get_gso_ihs().

Fixes: 504148fedb85 ("net: add skb_[inner_]tcp_all_headers helpers")
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index dc1e01e93d5a..27f791feb517 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -152,7 +152,7 @@ mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb, int *hopbyhop)
 
 	*hopbyhop = 0;
 	if (skb->encapsulation) {
-		ihs = skb_tcp_all_headers(skb);
+		ihs = skb_inner_tcp_all_headers(skb);
 		stats->tso_inner_packets++;
 		stats->tso_inner_bytes += skb->len - ihs;
 	} else {
-- 
2.37.1


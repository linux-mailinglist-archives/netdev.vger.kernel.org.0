Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F899457775
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 20:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbhKSUBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:01:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234569AbhKSUBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:01:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D7EB61B42;
        Fri, 19 Nov 2021 19:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637351899;
        bh=QScL5s5MHzMYLU1RGAFqbk+FxQW56obRkIJlB9ZKcog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQV7nwIlajqvaH47W7fjMfohSpfUYXwInpuy6hH1ul0ITqhs9pEDJFB9aqxQeHWVk
         ZDN9vE7HijF6JhHOvtiRhj9kbOZInzk8BvjA6rh4eoxBn6eBk+ZhgCR986HOBNEuAP
         +ChPmZBE1rkfRyDbrLWIIZa97Nu8BtziDsaiK5HujTXdF+Yu3Q3sRJ+ok+BNjLI3KQ
         tJIKz/c/ukHJqrA3bNr87DVq2mRwGBcpVL3HS7EjT1OaF8+u84DPjT0CIJzt0pGySY
         vzf37hdVOpfsHSkhcFjSRPJhAcAMo7ObaUJDr9ci/GXKUWw+8dkle/NYk8cLspk+xh
         2rGtK9Whq8ANg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/10] net/mlx5e: IPsec: Fix Software parser inner l3 type setting in case of encapsulation
Date:   Fri, 19 Nov 2021 11:58:05 -0800
Message-Id: <20211119195813.739586-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119195813.739586-1-saeed@kernel.org>
References: <20211119195813.739586-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

Current code wrongly uses the skb->protocol field which reflects the
outer l3 protocol to set the inner l3 type in Software Parser (SWP)
fields settings in the ethernet segment (eseg) in flows where inner
l3 exists like in Vxlan over ESP flow, the above method wrongly use
the outer protocol type instead of the inner one. thus breaking cases
where inner and outer headers have different protocols.

Fix by setting the inner l3 type in SWP according to the inner l3 ip
header version.

Fixes: 2ac9cfe78223 ("net/mlx5e: IPSec, Add Innova IPSec offload TX data path")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index fb5397324aa4..2db9573a3fe6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -191,7 +191,7 @@ static void mlx5e_ipsec_set_swp(struct sk_buff *skb,
 			eseg->swp_inner_l3_offset = skb_inner_network_offset(skb) / 2;
 			eseg->swp_inner_l4_offset =
 				(skb->csum_start + skb->head - skb->data) / 2;
-			if (skb->protocol == htons(ETH_P_IPV6))
+			if (inner_ip_hdr(skb)->version == 6)
 				eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
 			break;
 		default:
-- 
2.31.1


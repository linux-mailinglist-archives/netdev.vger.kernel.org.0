Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0DF746473B
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346965AbhLAGku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:40:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36040 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbhLAGkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:40:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEE0FB81DDD
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 06:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D40C53FD0;
        Wed,  1 Dec 2021 06:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638340641;
        bh=QScL5s5MHzMYLU1RGAFqbk+FxQW56obRkIJlB9ZKcog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGNGlKwXbVhP+mZ+zbI7qUU/p1UnKGFNcboXZ7M9xnYmTorz7I+S60TfpKI7cCG8h
         1GFR14QeIsDIf2CIWzxn55jgrcKiTYSW4msgvls6tIq0RJP/culfJqeaF1SQmxr+RE
         8JZ5eH98Vl0P7dx8erZ8cdHxS+VI/1F2W3khqDSiO725l0uvzNveEUG3QsnGiEkwIM
         Iu7LACVMeTxVnEEtSY9R6cAL5XldzYQlUamFhn2Kiz0yAKvHR0hQZCFA+4dW1ZJ2ei
         tF+lRbU52XDfsnfrytqo73CNC05rEMQcNX0kcrEXDvmzh7OMTVmXxLjg+aUtINLYRr
         MOw7yKlxmjdNA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/13] net/mlx5e: IPsec: Fix Software parser inner l3 type setting in case of encapsulation
Date:   Tue, 30 Nov 2021 22:36:57 -0800
Message-Id: <20211201063709.229103-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201063709.229103-1-saeed@kernel.org>
References: <20211201063709.229103-1-saeed@kernel.org>
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


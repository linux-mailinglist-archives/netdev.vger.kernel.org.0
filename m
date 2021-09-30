Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2573E41E49F
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350040AbhI3XQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346146AbhI3XQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76F7E61A6E;
        Thu, 30 Sep 2021 23:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633043703;
        bh=3bM9ntNDOsoCwfgK4BhUHZQdm+lmKVr1aZKLzO6ga1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABF5mGle5HVb0krGs3kxF/EztXgtyqbpL/uLRKwYWdJgULurhMRdIRwok513BRh8b
         tb7hdyY/aow/iS5Hczr2janMPZ8HhbkkQ5YzeT/uFvmraoEnBMiJ0mCXvltG2Uyab3
         2KGA2IuhOzIDNsBekWtVue3HglN12hpnaqfTxwNd0cuNeMcCdguzivcBG2PYvwzIqc
         Xu4Lz5LDT1tjqDJIaY37cx3LYuwjoF/o/VMQOvGNJR/r6ZAgKTQl8rxsSPrmPOc85z
         O1g31s3s0qTwXVhnI2NQVB9SbCwLrhwGvdXjZ6ScwIjvq4PbQBPJShoRcuxgMgBMrT
         jIENxJdovQggQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/10] net/mlx5e: IPSEC RX, enable checksum complete
Date:   Thu, 30 Sep 2021 16:14:52 -0700
Message-Id: <20210930231501.39062-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930231501.39062-1-saeed@kernel.org>
References: <20210930231501.39062-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

Currently in Rx data path IPsec crypto offloaded packets uses
csum_none flag, so checksum is handled by the stack, this naturally
have some performance/cpu utilization impact on such flows. As Nvidia
NIC starting from ConnectX6DX provides checksum complete value out of
the box also for such flows there is no sense in taking csum_none path,
furthermore the stack (xfrm) have the method to handle checksum complete
corrections for such flows i.e. IPsec trailer removal and consequently
checksum value adjustment.

Because of the above and in addition the ConnectX6DX is the first HW
which supports IPsec crypto offload then it is safe to report csum
complete for IPsec offloaded traffic.

Fixes: b2ac7541e377 ("net/mlx5e: IPsec: Add Connect-X IPsec Rx data path offload")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 3c65fd0bcf31..29a6586ef28d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1001,14 +1001,9 @@ static inline void mlx5e_handle_csum(struct net_device *netdev,
 		goto csum_unnecessary;
 
 	if (likely(is_last_ethertype_ip(skb, &network_depth, &proto))) {
-		u8 ipproto = get_ip_proto(skb, network_depth, proto);
-
-		if (unlikely(ipproto == IPPROTO_SCTP))
+		if (unlikely(get_ip_proto(skb, network_depth, proto) == IPPROTO_SCTP))
 			goto csum_unnecessary;
 
-		if (unlikely(mlx5_ipsec_is_rx_flow(cqe)))
-			goto csum_none;
-
 		stats->csum_complete++;
 		skb->ip_summed = CHECKSUM_COMPLETE;
 		skb->csum = csum_unfold((__force __sum16)cqe->check_sum);
-- 
2.31.1


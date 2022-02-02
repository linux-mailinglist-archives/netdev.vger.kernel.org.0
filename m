Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A581E4A6B38
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244725AbiBBFGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbiBBFGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F552C061753
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 21:06:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29710B83009
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B27C340EF;
        Wed,  2 Feb 2022 05:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778400;
        bh=7ZqIg76LZ6fU+ZABXT4DpOXX+kM7dQI9ub1zUCTK3JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4Lb3reyEXx4tR+KYtKNcBFfI8aLncsYCg8i5viWScRW4hU3SX5wZ+z+zS5mFemXz
         9VqYZAhjX7921ISAh5dJsxKqSZezH7QAnhi0eLt2R7B/LaN/ONJjUVR9RPmGWyYDWo
         T3pFgvG6vxvxNJkT86K4N4NwGcUS2hrJItoK9Wngs0POt84hFsJSjxnrDlvaPr2OEt
         WarjrBBv2+U1/1C1MOTFUNCGqf4DnwdApjxP/Z9vGzcN4J+oz8XTL5/OSDGEujc0SU
         okSTsSv5H3+GfTlPj/jcQvPL3LXmqxd7Mi2yxm76t/Pmmc2O6RVg7YAssjmgvBP9MD
         E1lhbFUflNz/g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 14/18] net/mlx5e: IPsec: Fix crypto offload for non TCP/UDP encapsulated traffic
Date:   Tue,  1 Feb 2022 21:04:00 -0800
Message-Id: <20220202050404.100122-15-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202050404.100122-1-saeed@kernel.org>
References: <20220202050404.100122-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

IPsec crypto offload always set the ethernet segment checksum flags with
the inner L4 header checksum flag enabled for encapsulated IPsec offloaded
packet regardless of the encapsulated L4 header type, and even if it
doesn't exists in the first place, this breaks non TCP/UDP traffic as
such.

Set the inner L4 checksum flag only when the encapsulated L4 header
protocol is TCP/UDP using software parser swp_inner_l4_offset field as
indication.

Fixes: 5cfb540ef27b ("net/mlx5e: Set IPsec WAs only in IP's non checksum partial case.")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h    | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index b98db50c3418..428881e0adcb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -131,14 +131,17 @@ static inline bool
 mlx5e_ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 				  struct mlx5_wqe_eth_seg *eseg)
 {
-	struct xfrm_offload *xo = xfrm_offload(skb);
+	u8 inner_ipproto;
 
 	if (!mlx5e_ipsec_eseg_meta(eseg))
 		return false;
 
 	eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM;
-	if (xo->inner_ipproto) {
-		eseg->cs_flags |= MLX5_ETH_WQE_L4_INNER_CSUM | MLX5_ETH_WQE_L3_INNER_CSUM;
+	inner_ipproto = xfrm_offload(skb)->inner_ipproto;
+	if (inner_ipproto) {
+		eseg->cs_flags |= MLX5_ETH_WQE_L3_INNER_CSUM;
+		if (inner_ipproto == IPPROTO_TCP || inner_ipproto == IPPROTO_UDP)
+			eseg->cs_flags |= MLX5_ETH_WQE_L4_INNER_CSUM;
 	} else if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
 		eseg->cs_flags |= MLX5_ETH_WQE_L4_CSUM;
 		sq->stats->csum_partial_inner++;
-- 
2.34.1


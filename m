Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A10235FE69
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237553AbhDNX0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:26:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235170AbhDNX0P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:26:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B49061249;
        Wed, 14 Apr 2021 23:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618442753;
        bh=g+M/PEb505lordpqQPP58tMBzdQCbn8CsRda9wF54GY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJr7bqvPgA40Q1uI4pjyvZ12PDXCRGFdSBtfQWbhj933XlWcoAueopSVBPlw8FMcl
         xfiHcjxq1w9QIgAaMbengZAcJPupJa0fu9acRodgcnqQy86eH8ITauQCnLg1MKmpIK
         0cXX85Bn7Q8DsGmEYmmV8mYpF9EBG6RRmoM3xEwFzXpsX5HOgTRvG5qwb8ppV2izXg
         z1RBjeA9+aWsv7GBySbLmUw5SZCR1siRw3SFG5NxkNkbb/j3TUvlWIDZB7EjER/zDg
         SLNHgpFc8A5J2hMRaa6x6M9U2rUgpVRvNVhdHSnggt0sCCKPfk8XneS1dnbTwW4OYX
         FvGpzd+6lPOrg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        "Cc : Steffen Klassert" <steffen.klassert@secunet.com>,
        Huy Nguyen <huyn@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net 3/3] net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload
Date:   Wed, 14 Apr 2021 16:25:40 -0700
Message-Id: <20210414232540.138232-4-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414232540.138232-1-saeed@kernel.org>
References: <20210414232540.138232-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@nvidia.com>

The packet is VXLAN packet over IPsec transport mode tunnel
which has the following format: [IP1 | ESP | UDP | VXLAN | IP2 | TCP]
NVIDIA ConnectX card cannot do checksum offload for two L4 headers.
The solution is using the checksum partial offload similar to
VXLAN | TCP packet. Hardware calculates IP1, IP2 and TCP checksums and
software calculates UDP checksum. However, unlike VXLAN | TCP case,
IPsec's mlx5 driver cannot access the inner plaintext IP protocol type.
Therefore, inner_ipproto is added in the sec_path structure
to provide this information. Also, utilize the skb's csum_start to
program L4 inner checksum offset.

While at it, remove the call to mlx5e_set_eseg_swp and setup software parser
fields directly in mlx5e_ipsec_set_swp. mlx5e_set_eseg_swp is not
needed as the two features (GENEVE and IPsec) are different and adding
this sharing layer creates unnecessary complexity and affect
performance.

For the case VXLAN packet over IPsec tunnel mode tunnel, checksum offload
is disabled because the hardware does not support checksum offload for
three L3 (IP) headers.

Fixes: 2ac9cfe78223 ("net/mlx5e: IPSec, Add Innova IPSec offload TX data path")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  | 65 ++++++++++++++-----
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  | 21 +++++-
 2 files changed, 69 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index a97e8d205094..6d2b809988b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -136,7 +136,7 @@ static void mlx5e_ipsec_set_swp(struct sk_buff *skb,
 				struct mlx5_wqe_eth_seg *eseg, u8 mode,
 				struct xfrm_offload *xo)
 {
-	struct mlx5e_swp_spec swp_spec = {};
+	struct sec_path *sp = skb_sec_path(skb);
 
 	/* Tunnel Mode:
 	 * SWP:      OutL3       InL3  InL4
@@ -146,23 +146,58 @@ static void mlx5e_ipsec_set_swp(struct sk_buff *skb,
 	 * SWP:      OutL3       InL4
 	 *           InL3
 	 * Pkt: MAC  IP     ESP  L4
+	 *
+	 * Tunnel(VXLAN TCP/UDP) over Transport Mode
+	 * SWP:      OutL3                   InL3  InL4
+	 * Pkt: MAC  IP     ESP  UDP  VXLAN  IP    L4
 	 */
-	swp_spec.l3_proto = skb->protocol;
-	swp_spec.is_tun = mode == XFRM_MODE_TUNNEL;
-	if (swp_spec.is_tun) {
-		if (xo->proto == IPPROTO_IPV6) {
-			swp_spec.tun_l3_proto = htons(ETH_P_IPV6);
-			swp_spec.tun_l4_proto = inner_ipv6_hdr(skb)->nexthdr;
-		} else {
-			swp_spec.tun_l3_proto = htons(ETH_P_IP);
-			swp_spec.tun_l4_proto = inner_ip_hdr(skb)->protocol;
-		}
-	} else {
-		swp_spec.tun_l3_proto = skb->protocol;
-		swp_spec.tun_l4_proto = xo->proto;
+
+	/* Shared settings */
+	eseg->swp_outer_l3_offset = skb_network_offset(skb) / 2;
+	if (skb->protocol == htons(ETH_P_IPV6))
+		eseg->swp_flags |= MLX5_ETH_WQE_SWP_OUTER_L3_IPV6;
+
+	/* Tunnel mode */
+	if (mode == XFRM_MODE_TUNNEL) {
+		eseg->swp_inner_l3_offset = skb_inner_network_offset(skb) / 2;
+		eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
+		if (xo->proto == IPPROTO_IPV6)
+			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
+		if (inner_ip_hdr(skb)->protocol == IPPROTO_UDP)
+			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
+		return;
+	}
+
+	/* Transport mode */
+	if (mode != XFRM_MODE_TRANSPORT)
+		return;
+
+	if (!sp->inner_ipproto) {
+		eseg->swp_inner_l3_offset = skb_network_offset(skb) / 2;
+		eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
+		if (skb->protocol == htons(ETH_P_IPV6))
+			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
+		if (xo->proto == IPPROTO_UDP)
+			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
+		return;
+	}
+
+	/* Tunnel(VXLAN TCP/UDP) over Transport Mode */
+	switch (sp->inner_ipproto) {
+	case IPPROTO_UDP:
+		eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
+		fallthrough;
+	case IPPROTO_TCP:
+		eseg->swp_inner_l3_offset = skb_inner_network_offset(skb) / 2;
+		eseg->swp_inner_l4_offset = (skb->csum_start + skb->head - skb->data) / 2;
+		if (skb->protocol == htons(ETH_P_IPV6))
+			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
+		break;
+	default:
+		break;
 	}
 
-	mlx5e_set_eseg_swp(skb, eseg, &swp_spec);
+	return;
 }
 
 void mlx5e_ipsec_set_iv_esn(struct sk_buff *skb, struct xfrm_state *x,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index cfa98272e4a9..de242cf1510a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -101,11 +101,28 @@ mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 	if (sp && sp->len) {
 		struct xfrm_state *x = sp->xvec[0];
 
-		if (x && x->xso.offload_handle)
-			return features;
+		if (!x || !x->xso.offload_handle)
+			goto out_disable;
+
+		if (sp->inner_ipproto) {
+			/* Cannot support tunnel packet over IPsec tunnel mode
+			 * because we cannot offload three IP header csum
+			 */
+			if (x->props.mode == XFRM_MODE_TUNNEL)
+				goto out_disable;
+
+			/* Only support UDP or TCP L4 checksum */
+			if (sp->inner_ipproto != IPPROTO_UDP &&
+			    sp->inner_ipproto != IPPROTO_TCP)
+				goto out_disable;
+		}
+
+		return features;
+
 	}
 
 	/* Disable CSUM and GSO for software IPsec */
+out_disable:
 	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955594A6B35
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiBBFGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:06:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbiBBFGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218CAC061755
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 21:06:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBB48B83015
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259D0C340F1;
        Wed,  2 Feb 2022 05:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778400;
        bh=hnPoKjr0AO6z5W+y8xUTMTfOZ9TQFT7+hmIolmahztM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M9hiWIu/nKzL7Unm9D5pZKZfmJ0+4nj00OhLy8fknwccnIH22uoOKWrn22kIOSfOb
         7rOcVYTZB9WkamSerth9NgEPDOqH+TudPjJQoBMMbdQ5Zz8iPROuYv90VMaUQIweRa
         YjoRDi6oEywLuTzlMmu5N0HyekSvmL9xLz0PH5L8u8ZYmEtrVPaD3+5FW/cQXsT3MV
         GcN2dgJD4PV/lqBGsktdN2qruoCFNTIlDG21815ckIkm/3CpXtZvVevNuP2qo+PxW0
         QLyLvN4joPC8oL+7DbMoJQSiAyycxSmGkufPIZv+3jmGmB2tF3Nqk6jQpQc1XEXR1C
         RTmlNFFDD84/g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 15/18] net/mlx5e: IPsec: Fix tunnel mode crypto offload for non TCP/UDP traffic
Date:   Tue,  1 Feb 2022 21:04:01 -0800
Message-Id: <20220202050404.100122-16-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202050404.100122-1-saeed@kernel.org>
References: <20220202050404.100122-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

IPsec Tunnel mode crypto offload software parser (SWP) setting in data
path currently always set the inner L4 offset regardless of the
encapsulated L4 header type and whether it exists in the first place,
this breaks non TCP/UDP traffic as such.

Set the SWP inner L4 offset only when the IPsec tunnel encapsulated L4
header protocol is TCP/UDP.

While at it fix inner ip protocol read for setting MLX5_ETH_WQE_SWP_INNER_L4_UDP
flag to address the case where the ip header protocol is IPv6.

Fixes: f1267798c980 ("net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c        | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 2db9573a3fe6..b56fea142c24 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -157,11 +157,20 @@ static void mlx5e_ipsec_set_swp(struct sk_buff *skb,
 	/* Tunnel mode */
 	if (mode == XFRM_MODE_TUNNEL) {
 		eseg->swp_inner_l3_offset = skb_inner_network_offset(skb) / 2;
-		eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
 		if (xo->proto == IPPROTO_IPV6)
 			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
-		if (inner_ip_hdr(skb)->protocol == IPPROTO_UDP)
+
+		switch (xo->inner_ipproto) {
+		case IPPROTO_UDP:
 			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
+			fallthrough;
+		case IPPROTO_TCP:
+			/* IP | ESP | IP | [TCP | UDP] */
+			eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
+			break;
+		default:
+			break;
+		}
 		return;
 	}
 
-- 
2.34.1


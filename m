Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03EB44A7D94
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348900AbiBCBw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348905AbiBCBwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:52:25 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C18C061755
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:52:22 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id x3so888603pll.3
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FvXKu1Uh+qJqTdWIkfDeiOqalxPYyigSWabWQAE5W2Y=;
        b=jpmjmCUZx5kE0ZD6593JBTX41Vh9D9oxQvB/UmpAwwjyAiJTTOzTfuyhvjJVEktpNu
         nPsNkD/MEDHDVFIvDDBtuw/+o3aaobXIMWwu7mVlB4ubGHJBCEUvanEFlQTBKIXtfyVn
         NuKiwpP6Srzmy6WuBX4eZ7fi0dDejHsmapdrSQnWcZEtGei0OOgojmSvhlIUWqiQFwqv
         XzjjhcgVGs3x1n+6H5R2fOa0IYhPP95roB5Sg5JFtwshgAa3aCJZFasujdJcE6K0Xz+l
         YHIY4s5K+YuMXjjTmqFpztc3GaFucobIaJdbafouCP2uCL+0+NiSXeIH0ubdue8Ck8LC
         ToIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FvXKu1Uh+qJqTdWIkfDeiOqalxPYyigSWabWQAE5W2Y=;
        b=N0Zw0f4Dt55BbkxSyHdQcDcPAMPPKocY5mpD2Uk+i1W7l5deruL2HOoSI4IGPx4Mi4
         BwwnSuhlBRQa/ijqdzV08MMOKeL5pnJAozl2oKzAYiDf0MpBEOdTsM1+2ljMHVUHaNwn
         01w3jz5LCXAnnTmf+kTnp4muvGMgl3BydZHCfs4Bc/UNmjzcN8BvecJSkNGPD/y3SWUf
         Q+T0411TQzG3Ow9kN/1FnGS5PSyG3CD3A8AthutvkWYhCXuC0vi2OIC67xkNDoaxmK9N
         0ODPS1R2FVyjP6vUU0/ZPO7RDx2qznufRWmqmAqQm3OgHn+YVpJ+fwv3P2M4awC3Pmvf
         z/gg==
X-Gm-Message-State: AOAM532IpKpIcM/q4PqfIeO7KsIaP6Yjw+lpAdTA8Mb8SY3/tiHDtCK7
        qDnNmNgvJHo9EXx54IaJrII=
X-Google-Smtp-Source: ABdhPJwn2eAzE7XJk9XyKJ2og0N0WrORIybUO8dcoHFFDArMvPhwC/LwA71lv9XjkvR39pwHPsnYUA==
X-Received: by 2002:a17:90b:1d06:: with SMTP id on6mr11388238pjb.6.1643853141845;
        Wed, 02 Feb 2022 17:52:21 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:52:21 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next 15/15] mlx5: support BIG TCP packets
Date:   Wed,  2 Feb 2022 17:51:40 -0800
Message-Id: <20220203015140.3022854-16-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220203015140.3022854-1-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Coco Li <lixiaoyan@google.com>

mlx5 supports LSOv2.

IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
with JUMBO TLV for big packets.

We need to ignore/skip this HBH header when populating TX descriptor.

Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 81 +++++++++++++++----
 2 files changed, 65 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bf80fb6124499fc4e6a0310ab92c91159b4ccbbb..1c4ce90e5d0f5186c402137b744258ff4ce6a348 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4888,6 +4888,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	netdev->priv_flags       |= IFF_UNICAST_FLT;
 
+	netif_set_tso_ipv6_max_size(netdev, 512 * 1024);
 	mlx5e_set_netdev_dev_addr(netdev);
 	mlx5e_ipsec_build_netdev(priv);
 	mlx5e_tls_build_netdev(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 7fd33b356cc8d191413e8259acd0b26b3ebd6ba9..fc945bd8219dcb69950b1840bb492649c8749976 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -40,6 +40,7 @@
 #include "en_accel/en_accel.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en/ptp.h"
+#include <net/ipv6.h>
 
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
 {
@@ -241,8 +242,11 @@ mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		sq->stats->csum_none++;
 }
 
+/* Returns the number of header bytes that we plan
+ * to inline later in the transmit descriptor
+ */
 static inline u16
-mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb)
+mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb, int *hopbyhop)
 {
 	struct mlx5e_sq_stats *stats = sq->stats;
 	u16 ihs;
@@ -252,15 +256,18 @@ mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb)
 		stats->tso_inner_packets++;
 		stats->tso_inner_bytes += skb->len - ihs;
 	} else {
-		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
 			ihs = skb_transport_offset(skb) + sizeof(struct udphdr);
-		else
+		} else {
+			if (ipv6_has_hopopt_jumbo(skb))
+				*hopbyhop = sizeof(struct hop_jumbo_hdr);
 			ihs = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		}
 		stats->tso_packets++;
-		stats->tso_bytes += skb->len - ihs;
+		stats->tso_bytes += skb->len - ihs - *hopbyhop;
 	}
 
-	return ihs;
+	return ihs - *hopbyhop;
 }
 
 static inline int
@@ -319,6 +326,7 @@ struct mlx5e_tx_attr {
 	__be16 mss;
 	u16 insz;
 	u8 opcode;
+	u8 hopbyhop;
 };
 
 struct mlx5e_tx_wqe_attr {
@@ -355,14 +363,16 @@ static void mlx5e_sq_xmit_prepare(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	struct mlx5e_sq_stats *stats = sq->stats;
 
 	if (skb_is_gso(skb)) {
-		u16 ihs = mlx5e_tx_get_gso_ihs(sq, skb);
+		int hopbyhop;
+		u16 ihs = mlx5e_tx_get_gso_ihs(sq, skb, &hopbyhop);
 
 		*attr = (struct mlx5e_tx_attr) {
 			.opcode    = MLX5_OPCODE_LSO,
 			.mss       = cpu_to_be16(skb_shinfo(skb)->gso_size),
 			.ihs       = ihs,
 			.num_bytes = skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs,
-			.headlen   = skb_headlen(skb) - ihs,
+			.headlen   = skb_headlen(skb) - ihs - hopbyhop,
+			.hopbyhop  = hopbyhop,
 		};
 
 		stats->packets += skb_shinfo(skb)->gso_segs;
@@ -476,7 +486,8 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	struct mlx5_wqe_eth_seg  *eseg;
 	struct mlx5_wqe_data_seg *dseg;
 	struct mlx5e_tx_wqe_info *wi;
-
+	u16 ihs = attr->ihs;
+	struct ipv6hdr *h6;
 	struct mlx5e_sq_stats *stats = sq->stats;
 	int num_dma;
 
@@ -490,15 +501,36 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
 	eseg->mss = attr->mss;
 
-	if (attr->ihs) {
-		if (skb_vlan_tag_present(skb)) {
-			eseg->inline_hdr.sz |= cpu_to_be16(attr->ihs + VLAN_HLEN);
-			mlx5e_insert_vlan(eseg->inline_hdr.start, skb, attr->ihs);
+	if (ihs) {
+		u8 *start = eseg->inline_hdr.start;
+
+		if (unlikely(attr->hopbyhop)) {
+			/* remove the HBH header.
+			 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
+			 */
+			if (skb_vlan_tag_present(skb)) {
+				mlx5e_insert_vlan(start, skb, ETH_HLEN + sizeof(*h6));
+				ihs += VLAN_HLEN;
+				h6 = (struct ipv6hdr *)(start + sizeof(struct vlan_ethhdr));
+			} else {
+				memcpy(start, skb->data, ETH_HLEN + sizeof(*h6));
+				h6 = (struct ipv6hdr *)(start + ETH_HLEN);
+			}
+			h6->nexthdr = IPPROTO_TCP;
+			/* Copy the TCP header after the IPv6 one */
+			memcpy(h6 + 1,
+			       skb->data + ETH_HLEN + sizeof(*h6) +
+					sizeof(struct hop_jumbo_hdr),
+			       tcp_hdrlen(skb));
+			/* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */
+		} else if (skb_vlan_tag_present(skb)) {
+			mlx5e_insert_vlan(start, skb, ihs);
+			ihs += VLAN_HLEN;
 			stats->added_vlan_packets++;
 		} else {
-			eseg->inline_hdr.sz |= cpu_to_be16(attr->ihs);
-			memcpy(eseg->inline_hdr.start, skb->data, attr->ihs);
+			memcpy(start, skb->data, ihs);
 		}
+		eseg->inline_hdr.sz |= cpu_to_be16(ihs);
 		dseg += wqe_attr->ds_cnt_inl;
 	} else if (skb_vlan_tag_present(skb)) {
 		eseg->insert.type = cpu_to_be16(MLX5_ETH_WQE_INSERT_VLAN);
@@ -509,7 +541,7 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	}
 
 	dseg += wqe_attr->ds_cnt_ids;
-	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr->ihs,
+	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr->ihs + attr->hopbyhop,
 					  attr->headlen, dseg);
 	if (unlikely(num_dma < 0))
 		goto err_drop;
@@ -1016,12 +1048,27 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	eseg->mss = attr.mss;
 
 	if (attr.ihs) {
-		memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
+		if (unlikely(attr.hopbyhop)) {
+			/* remove the HBH header.
+			 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
+			 */
+			memcpy(eseg->inline_hdr.start, skb->data, ETH_HLEN + sizeof(*h6));
+			h6 = (struct ipv6hdr *)((char *)eseg->inline_hdr.start + ETH_HLEN);
+			h6->nexthdr = IPPROTO_TCP;
+			/* Copy the TCP header after the IPv6 one */
+			memcpy(h6 + 1,
+			       skb->data + ETH_HLEN + sizeof(*h6) +
+					sizeof(struct hop_jumbo_hdr),
+			       tcp_hdrlen(skb));
+			/* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */
+		} else {
+			memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
+		}
 		eseg->inline_hdr.sz = cpu_to_be16(attr.ihs);
 		dseg += wqe_attr.ds_cnt_inl;
 	}
 
-	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr.ihs,
+	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr.ihs + attr.hopbyhop,
 					  attr.headlen, dseg);
 	if (unlikely(num_dma < 0))
 		goto err_drop;
-- 
2.35.0.rc2.247.g8bbb082509-goog


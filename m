Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A38520786
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiEIW0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbiEIW0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:26:12 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08F415E601
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 15:22:16 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id j14so15164829plx.3
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 15:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=okmO0o4zFF9RG3+3SPFXl3A+UQViu/6B/8NuQ9OH0bc=;
        b=p7AGptwAfc0skiomIuKWfq8d4GDBhr8js4H3YQEk19jAsfy+ixgHGDNqmmLU7K99Vf
         bRyw91BzYI/zDgzVL9QuA/01yhPaZ4fE9RxkU2QmYWJ5LE5eXgN/z608+0FvprR7QifX
         hjYQdLYBTz/UEW+4wt/SHAPY9cUdX8Izxr3EZOyBv5tAdn6a1eK++bC8XCop8+C4ENV4
         d8VI21qFUE0vwu1ZKGLw129HwMz29IBZxXsyrjxU4CK99TJXCyTWfFTsm2b4pUXp0nWf
         LOB6XLwT1lyHcdlZ3FQMZtVCaTTZUeuO6i0fj8z6YrQVXhh2l4sjdeN7UBH8kglO89VS
         XFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=okmO0o4zFF9RG3+3SPFXl3A+UQViu/6B/8NuQ9OH0bc=;
        b=QK+qVBPaEm79up55mIlNFtoDaURs2jyh27JhbrLNfHl9vmrgJwXZS//7GlPRu2fyLF
         7er0bRMGy3wPh2oV/sXvhZDpsNUXv3G9wYLok0vBg1XPPUYCJJSB+cFaTQZkI2isz44F
         FZE1Cv7TttQUmAeKI7TK8oBvgfG0Y7sxDt9U4ZwKZx3f6JyhuPXZDV2asde+KrV3O50X
         S2iuoXMg+BKCRdatgghh771FLi4muYfY5PbjGU/bBhqMT2WW+tQ4ObxZEQUK3Wdzma12
         lo90Rtb7c6Yd8deLngNVQIDkrwcg6ezrvOVKW1WB6JutZnDXt71RiD2hCuqIicEcaXmv
         iY/A==
X-Gm-Message-State: AOAM531pV9ftPNpTIZ5+VH+ujKCLPBA55JsiBhfiVdExDyZG/1qIvXgi
        5ShgT7gO8bXZAbhbUBzFvT8=
X-Google-Smtp-Source: ABdhPJyPwyY9hu41hd+1zna8zTMrxmPMlT1UPt90q4e4AYUAA1zXR/gk/3ob7eVFL643XuNmugGBJw==
X-Received: by 2002:a17:90b:4f4c:b0:1dc:acba:9f3 with SMTP id pj12-20020a17090b4f4c00b001dcacba09f3mr20324113pjb.159.1652134936249;
        Mon, 09 May 2022 15:22:16 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902f0cb00b0015e8d4eb1efsm395823pla.57.2022.05.09.15.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:22:15 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH v5 net-next 13/13] mlx5: support BIG TCP packets
Date:   Mon,  9 May 2022 15:21:49 -0700
Message-Id: <20220509222149.1763877-14-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220509222149.1763877-1-eric.dumazet@gmail.com>
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Coco Li <lixiaoyan@google.com>

mlx5 supports LSOv2.

IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
with JUMBO TLV for big packets.

We need to ignore/skip this HBH header when populating TX descriptor.

Note that ipv6_has_hopopt_jumbo() only recognizes very specific packet
layout, thus mlx5e_sq_xmit_wqe() is taking care of this layout only.

v2: clear hopbyhop in mlx5e_tx_get_gso_ihs()
v4: fix compile error for CONFIG_MLX5_CORE_IPOIB=y

Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 84 +++++++++++++++----
 2 files changed, 69 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d27986869b8ba070d1a4f8bcdc7e14ab54ae984e..226825410a1aa55b5b7941a7389a78abdb800521 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4920,6 +4920,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	netdev->priv_flags       |= IFF_UNICAST_FLT;
 
+	netif_set_tso_max_size(netdev, 512 * 1024);
 	mlx5e_set_netdev_dev_addr(netdev);
 	mlx5e_ipsec_build_netdev(priv);
 	mlx5e_ktls_build_netdev(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 2dc48406cd08d21ff94f665cd61ab9227f351215..b4fc45ba1b347fb9ad0f46b9c091cc45e4d3d84f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -40,6 +40,7 @@
 #include "en_accel/en_accel.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en/ptp.h"
+#include <net/ipv6.h>
 
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
 {
@@ -130,23 +131,32 @@ mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
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
 
+	*hopbyhop = 0;
 	if (skb->encapsulation) {
 		ihs = skb_inner_transport_offset(skb) + inner_tcp_hdrlen(skb);
 		stats->tso_inner_packets++;
 		stats->tso_inner_bytes += skb->len - ihs;
 	} else {
-		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
 			ihs = skb_transport_offset(skb) + sizeof(struct udphdr);
-		else
+		} else {
 			ihs = skb_transport_offset(skb) + tcp_hdrlen(skb);
+			if (ipv6_has_hopopt_jumbo(skb)) {
+				*hopbyhop = sizeof(struct hop_jumbo_hdr);
+				ihs -= sizeof(struct hop_jumbo_hdr);
+			}
+		}
 		stats->tso_packets++;
-		stats->tso_bytes += skb->len - ihs;
+		stats->tso_bytes += skb->len - ihs - *hopbyhop;
 	}
 
 	return ihs;
@@ -208,6 +218,7 @@ struct mlx5e_tx_attr {
 	__be16 mss;
 	u16 insz;
 	u8 opcode;
+	u8 hopbyhop;
 };
 
 struct mlx5e_tx_wqe_attr {
@@ -244,14 +255,16 @@ static void mlx5e_sq_xmit_prepare(struct mlx5e_txqsq *sq, struct sk_buff *skb,
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
@@ -365,7 +378,8 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	struct mlx5_wqe_eth_seg  *eseg;
 	struct mlx5_wqe_data_seg *dseg;
 	struct mlx5e_tx_wqe_info *wi;
-
+	u16 ihs = attr->ihs;
+	struct ipv6hdr *h6;
 	struct mlx5e_sq_stats *stats = sq->stats;
 	int num_dma;
 
@@ -379,15 +393,36 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
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
@@ -398,7 +433,7 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	}
 
 	dseg += wqe_attr->ds_cnt_ids;
-	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr->ihs,
+	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr->ihs + attr->hopbyhop,
 					  attr->headlen, dseg);
 	if (unlikely(num_dma < 0))
 		goto err_drop;
@@ -918,12 +953,29 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	eseg->mss = attr.mss;
 
 	if (attr.ihs) {
-		memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
+		if (unlikely(attr.hopbyhop)) {
+			struct ipv6hdr *h6;
+
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
2.36.0.512.ge40c2bad7a-goog


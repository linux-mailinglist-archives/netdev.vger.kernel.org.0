Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF29C45A3D4
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 14:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhKWNfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 08:35:17 -0500
Received: from relmlor2.renesas.com ([210.160.252.172]:50482 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229599AbhKWNfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 08:35:17 -0500
X-IronPort-AV: E=Sophos;i="5.87,257,1631545200"; 
   d="scan'208";a="101513529"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 23 Nov 2021 22:32:08 +0900
Received: from localhost.localdomain (unknown [10.226.93.159])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 7D45F4298F4C;
        Tue, 23 Nov 2021 22:32:06 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [RFC 2/2] ravb: Add Rx checksum offload support
Date:   Tue, 23 Nov 2021 13:31:57 +0000
Message-Id: <20211123133157.21829-3-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211123133157.21829-1-biju.das.jz@bp.renesas.com>
References: <20211123133157.21829-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TOE has hw support for calculating IP header checkum for IPV4 and
TCP/UDP/ICMP checksum for both IPV4 and IPV6.

This patch adds Rx checksum offload supported by TOE.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  4 +++
 drivers/net/ethernet/renesas/ravb_main.c | 31 ++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index a96552348e2d..d0e5eec0636e 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -44,6 +44,10 @@
 #define RAVB_RXTSTAMP_TYPE_ALL	0x00000006
 #define RAVB_RXTSTAMP_ENABLED	0x00000010	/* Enable RX timestamping */
 
+/* GbEthernet TOE hardware checksum values */
+#define TOE_RX_CSUM_OK		0x0000
+#define TOE_RX_CSUM_UNSUPPORTED	0xFFFF
+
 enum ravb_reg {
 	/* AVB-DMAC registers */
 	CCC	= 0x0000,
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index c2b92c6a6cd2..2533e3401593 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -720,6 +720,33 @@ static void ravb_get_tx_tstamp(struct net_device *ndev)
 	}
 }
 
+static void ravb_rx_csum_gbeth(struct sk_buff *skb)
+{
+	u32 csum_ip_hdr, csum_proto;
+	u8 *hw_csum;
+
+	/* The hardware checksum is contained in sizeof(__sum16) * 2 = 4 bytes
+	 * appended to packet data. First 2 bytes is ip header csum and last
+	 * 2 bytes is protocol csum.
+	 */
+	if (unlikely(skb->len < sizeof(__sum16) * 2))
+		return;
+	hw_csum = skb_tail_pointer(skb) - sizeof(__sum16);
+	csum_proto = csum_unfold((__force __sum16)get_unaligned_le16(hw_csum));
+
+	hw_csum = skb_tail_pointer(skb) - 2 * sizeof(__sum16);
+	csum_ip_hdr = csum_unfold((__force __sum16)get_unaligned_le16(hw_csum));
+
+	skb->ip_summed = CHECKSUM_NONE;
+	if (csum_proto == TOE_RX_CSUM_OK) {
+		if (skb->protocol == htons(ETH_P_IP) && csum_ip_hdr == TOE_RX_CSUM_OK)
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+		else if (skb->protocol == htons(ETH_P_IPV6) &&
+			 csum_ip_hdr == TOE_RX_CSUM_UNSUPPORTED)
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+	}
+}
+
 static void ravb_rx_csum(struct sk_buff *skb)
 {
 	u8 *hw_csum;
@@ -805,6 +832,8 @@ static bool ravb_rx_gbeth(struct net_device *ndev, int *quota, int q)
 				skb = ravb_get_skb_gbeth(ndev, entry, desc);
 				skb_put(skb, pkt_len);
 				skb->protocol = eth_type_trans(skb, ndev);
+				if (ndev->features & NETIF_F_RXCSUM)
+					ravb_rx_csum_gbeth(skb);
 				napi_gro_receive(&priv->napi[q], skb);
 				stats->rx_packets++;
 				stats->rx_bytes += pkt_len;
@@ -832,6 +861,8 @@ static bool ravb_rx_gbeth(struct net_device *ndev, int *quota, int q)
 				dev_kfree_skb(skb);
 				priv->rx_1st_skb->protocol =
 					eth_type_trans(priv->rx_1st_skb, ndev);
+				if (ndev->features & NETIF_F_RXCSUM)
+					ravb_rx_csum_gbeth(skb);
 				napi_gro_receive(&priv->napi[q],
 						 priv->rx_1st_skb);
 				stats->rx_packets++;
-- 
2.17.1


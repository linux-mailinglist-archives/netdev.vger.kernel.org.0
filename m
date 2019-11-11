Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9FCF76B6
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfKKOnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:43:06 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:55184 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726877AbfKKOnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 09:43:05 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8422FC08BA;
        Mon, 11 Nov 2019 14:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573483383; bh=EoTBZOC0Je6korS7Ma+EpCD7GT0gwifStY63b9qn/QM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=hbn0NJ+mb/rTGEomSAZ4/TiBwfPh7NpN2ndEFXioU0VRtifnVv8mwXrzxpss9syqz
         WLXHnVtHFcyNNOjIVG7AlWNOxaxt/F89Zls9BDrBRDh28+iTQoyshwXY4mReHFODlK
         RCXQ/t+/EL8Dal16GUPwVvtiOoI1JxZwaRcbkhWtUKUIwVe3xsLxzCvF4ZxKon8gBL
         mWkJRDObUtMdvSxAaucvEdN5/15WxIEtkcy5WyJiU3gAWw3mb+MiULcriweMFPHpVW
         7uK7Q3kZpV0jGxJhIr5sP8M+CugVf4UdVTGN82pW/IMWwOKcdbwrJud+A4YRGkIuCX
         gn1rDEw3/ckEw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 3E315A025B;
        Mon, 11 Nov 2019 14:42:57 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: stmmac: Implement UDP Segmentation Offload
Date:   Mon, 11 Nov 2019 15:42:39 +0100
Message-Id: <7a62a0532edaec95312308d7a4ced7eae331bc6d.1573482992.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573482991.git.Jose.Abreu@synopsys.com>
References: <cover.1573482991.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573482991.git.Jose.Abreu@synopsys.com>
References: <cover.1573482991.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the UDP Segmentation Offload feature in stmmac. This is only
available in GMAC4+ cores.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 32 ++++++++++++++++-------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a2fac7772666..39b4efd521f9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -36,6 +36,7 @@
 #endif /* CONFIG_DEBUG_FS */
 #include <linux/net_tstamp.h>
 #include <linux/phylink.h>
+#include <linux/udp.h>
 #include <net/pkt_cls.h>
 #include "stmmac_ptp.h"
 #include "stmmac.h"
@@ -2916,9 +2917,9 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	u32 queue = skb_get_queue_mapping(skb);
 	struct stmmac_tx_queue *tx_q;
 	unsigned int first_entry;
+	u8 proto_hdr_len, hdr;
 	int tmp_pay_len = 0;
 	u32 pay_len, mss;
-	u8 proto_hdr_len;
 	dma_addr_t des;
 	bool has_vlan;
 	int i;
@@ -2926,7 +2927,13 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_q = &priv->tx_queue[queue];
 
 	/* Compute header lengths */
-	proto_hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
+		proto_hdr_len = skb_transport_offset(skb) + sizeof(struct udphdr);
+		hdr = sizeof(struct udphdr);
+	} else {
+		proto_hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdr = tcp_hdrlen(skb);
+	}
 
 	/* Desc availability based on threshold should be enough safe */
 	if (unlikely(stmmac_tx_avail(priv, queue) <
@@ -2956,8 +2963,8 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	if (netif_msg_tx_queued(priv)) {
-		pr_info("%s: tcphdrlen %d, hdr_len %d, pay_len %d, mss %d\n",
-			__func__, tcp_hdrlen(skb), proto_hdr_len, pay_len, mss);
+		pr_info("%s: hdrlen %d, hdr_len %d, pay_len %d, mss %d\n",
+			__func__, hdr, proto_hdr_len, pay_len, mss);
 		pr_info("\tskb->len %d, skb->data_len %d\n", skb->len,
 			skb->data_len);
 	}
@@ -3071,7 +3078,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 			proto_hdr_len,
 			pay_len,
 			1, tx_q->tx_skbuff_dma[first_entry].last_segment,
-			tcp_hdrlen(skb) / 4, (skb->len - proto_hdr_len));
+			hdr / 4, (skb->len - proto_hdr_len));
 
 	/* If context desc is used to change MSS */
 	if (mss_desc) {
@@ -3130,6 +3137,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	int i, csum_insertion = 0, is_jumbo = 0;
 	u32 queue = skb_get_queue_mapping(skb);
 	int nfrags = skb_shinfo(skb)->nr_frags;
+	int gso = skb_shinfo(skb)->gso_type;
 	struct dma_desc *desc, *first;
 	struct stmmac_tx_queue *tx_q;
 	unsigned int first_entry;
@@ -3145,7 +3153,9 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* Manage oversized TCP frames for GMAC4 device */
 	if (skb_is_gso(skb) && priv->tso) {
-		if (skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))
+		if (gso & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))
+			return stmmac_tso_xmit(skb, dev);
+		if (priv->plat->has_gmac4 && (gso & SKB_GSO_UDP_L4))
 			return stmmac_tso_xmit(skb, dev);
 	}
 
@@ -4036,11 +4046,13 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 static u16 stmmac_select_queue(struct net_device *dev, struct sk_buff *skb,
 			       struct net_device *sb_dev)
 {
-	if (skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)) {
+	int gso = skb_shinfo(skb)->gso_type;
+
+	if (gso & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6 | SKB_GSO_UDP_L4)) {
 		/*
-		 * There is no way to determine the number of TSO
+		 * There is no way to determine the number of TSO/USO
 		 * capable Queues. Let's use always the Queue 0
-		 * because if TSO is supported then at least this
+		 * because if TSO/USO is supported then at least this
 		 * one will be capable.
 		 */
 		return 0;
@@ -4555,6 +4567,8 @@ int stmmac_dvr_probe(struct device *device,
 
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
 		ndev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
+		if (priv->plat->has_gmac4)
+			ndev->hw_features |= NETIF_F_GSO_UDP_L4;
 		priv->tso = true;
 		dev_info(priv->device, "TSO feature enabled\n");
 	}
-- 
2.7.4


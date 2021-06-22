Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3A63B0B4B
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhFVRVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230182AbhFVRVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1D2A60FF4;
        Tue, 22 Jun 2021 17:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624382333;
        bh=5im6szb6N9xgk3+yE4kC5did68+DtFeQ9vkZ0Trzlcw=;
        h=From:To:Cc:Subject:Date:From;
        b=c+r6QRyd4f2G4PVVbxuzAim/x5iaXZa6yqUlg4NWpDlfxh2PWo2H6yzcZao7UiKsC
         weI2VwdO9214JXv16qWsGnS4fKhoSo1fQyquVdUOFJGqf7hZ1T6uH/RLqjloVYjMv5
         82u9s9a8SBeKmVo6HEOiVzOOGylWpUF/V9g5Nc3NMdRVrT4QPx4xgqviAfNiYIYXPF
         n+YPMHoBF4gAxHhflVNvIx68KOy8IL9jCzXpfl5c/HdOIwKX9KbLDDgsroQr4A53J1
         A5HiHYokdJfqIcrOift9qlLAZVlFMtILcee27KRHzJ/vOuF2Y6Mv6p+fMOxwbZIIkU
         H2Ez85hBL14dQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     mcroce@linux.microsoft.com, davem@davemloft.net, kuba@kernel.org,
        sgoutham@marvell.com, sbhatta@marvell.com, stefanc@marvell.com,
        brouer@redhat.com, thomas.petazzoni@bootlin.com,
        linux@armlinux.org.uk, mw@semihalf.com, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next] net: marvell: return csum computation result from mvneta_rx_csum/mvpp2_rx_csum
Date:   Tue, 22 Jun 2021 19:18:31 +0200
Message-Id: <18fb6f42dac5a2ab7b121c83659e0109043b9f8c.1624381975.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preliminary patch to add hw csum hint support to
mvneta/mvpp2 xdp implementation

Tested-by: Matteo Croce <mcroce@linux.microsoft.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- rebase on top of net-next
---
 drivers/net/ethernet/marvell/mvneta.c         | 19 +++++++------------
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 14 +++++---------
 2 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c15ce06427d0..88a755034c39 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1805,18 +1805,14 @@ static void mvneta_rx_error(struct mvneta_port *pp,
 }
 
 /* Handle RX checksum offload based on the descriptor's status */
-static void mvneta_rx_csum(struct mvneta_port *pp, u32 status,
-			   struct sk_buff *skb)
+static int mvneta_rx_csum(struct mvneta_port *pp, u32 status)
 {
 	if ((pp->dev->features & NETIF_F_RXCSUM) &&
 	    (status & MVNETA_RXD_L3_IP4) &&
-	    (status & MVNETA_RXD_L4_CSUM_OK)) {
-		skb->csum = 0;
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-		return;
-	}
+	    (status & MVNETA_RXD_L4_CSUM_OK))
+		return CHECKSUM_UNNECESSARY;
 
-	skb->ip_summed = CHECKSUM_NONE;
+	return CHECKSUM_NONE;
 }
 
 /* Return tx queue pointer (find last set bit) according to <cause> returned
@@ -2335,7 +2331,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, xdp->data_end - xdp->data);
-	mvneta_rx_csum(pp, desc_status, skb);
+	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
 
 	for (i = 0; i < num_frags; i++) {
 		skb_frag_t *frag = &sinfo->frags[i];
@@ -2535,7 +2531,7 @@ static int mvneta_rx_hwbm(struct napi_struct *napi,
 				     rx_bytes);
 
 			skb->protocol = eth_type_trans(skb, dev);
-			mvneta_rx_csum(pp, rx_status, skb);
+			skb->ip_summed = mvneta_rx_csum(pp, rx_status);
 			napi_gro_receive(napi, skb);
 
 			rcvd_pkts++;
@@ -2584,8 +2580,7 @@ static int mvneta_rx_hwbm(struct napi_struct *napi,
 		skb_put(skb, rx_bytes);
 
 		skb->protocol = eth_type_trans(skb, dev);
-
-		mvneta_rx_csum(pp, rx_status, skb);
+		skb->ip_summed = mvneta_rx_csum(pp, rx_status);
 
 		napi_gro_receive(napi, skb);
 	}
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 9bca8c8f9f8d..01f6078bc859 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3543,21 +3543,17 @@ static void mvpp2_rx_error(struct mvpp2_port *port,
 }
 
 /* Handle RX checksum offload */
-static void mvpp2_rx_csum(struct mvpp2_port *port, u32 status,
-			  struct sk_buff *skb)
+static int mvpp2_rx_csum(struct mvpp2_port *port, u32 status)
 {
 	if (((status & MVPP2_RXD_L3_IP4) &&
 	     !(status & MVPP2_RXD_IP4_HEADER_ERR)) ||
 	    (status & MVPP2_RXD_L3_IP6))
 		if (((status & MVPP2_RXD_L4_UDP) ||
 		     (status & MVPP2_RXD_L4_TCP)) &&
-		     (status & MVPP2_RXD_L4_CSUM_OK)) {
-			skb->csum = 0;
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
-			return;
-		}
+		     (status & MVPP2_RXD_L4_CSUM_OK))
+			return CHECKSUM_UNNECESSARY;
 
-	skb->ip_summed = CHECKSUM_NONE;
+	return CHECKSUM_NONE;
 }
 
 /* Allocate a new skb and add it to BM pool */
@@ -4012,7 +4008,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 
 		skb_reserve(skb, MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM);
 		skb_put(skb, rx_bytes);
-		mvpp2_rx_csum(port, rx_status, skb);
+		skb->ip_summed = mvpp2_rx_csum(port, rx_status);
 		skb->protocol = eth_type_trans(skb, dev);
 
 		napi_gro_receive(napi, skb);
-- 
2.31.1


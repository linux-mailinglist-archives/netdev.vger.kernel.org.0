Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F62F17F8D5
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 13:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgCJMv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 08:51:29 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54876 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728905AbgCJMv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 08:51:28 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3F6281A0509;
        Tue, 10 Mar 2020 13:51:26 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 335021A0568;
        Tue, 10 Mar 2020 13:51:26 +0100 (CET)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id EF97B2036B;
        Tue, 10 Mar 2020 13:51:25 +0100 (CET)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Y . b . Lu" <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next 3/4] enetc: Clean up Rx BD iteration
Date:   Tue, 10 Mar 2020 14:51:23 +0200
Message-Id: <1583844684-28202-4-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583844684-28202-1-git-send-email-claudiu.manoil@nxp.com>
References: <1583844684-28202-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve maintainability of the code iterating the Rx buffer
descriptors to prepare it to support iterating extended Rx BD
descriptors as well.
Don't increment by one the h/w descriptor pointers explicitly,
provide an iterator that takes care of the h/w details.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 31 ++++++++------------
 drivers/net/ethernet/freescale/enetc/enetc.h | 17 ++++++++++-
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 1f79e36116a3..f1bbaef428c0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -451,7 +451,7 @@ static int enetc_refill_rx_ring(struct enetc_bdr *rx_ring, const int buff_cnt)
 
 	i = rx_ring->next_to_use;
 	rx_swbd = &rx_ring->rx_swbd[i];
-	rxbd = ENETC_RXBD(*rx_ring, i);
+	rxbd = enetc_rxbd(rx_ring, i);
 
 	for (j = 0; j < buff_cnt; j++) {
 		/* try reuse page */
@@ -468,13 +468,12 @@ static int enetc_refill_rx_ring(struct enetc_bdr *rx_ring, const int buff_cnt)
 		/* clear 'R" as well */
 		rxbd->r.lstatus = 0;
 
+		rxbd = enetc_rxbd_next(rx_ring, rxbd, i);
 		rx_swbd++;
-		rxbd++;
 		i++;
 		if (unlikely(i == rx_ring->bd_count)) {
 			i = 0;
 			rx_swbd = rx_ring->rx_swbd;
-			rxbd = ENETC_RXBD(*rx_ring, 0);
 		}
 	}
 
@@ -655,7 +654,7 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 			cleaned_cnt -= count;
 		}
 
-		rxbd = ENETC_RXBD(*rx_ring, i);
+		rxbd = enetc_rxbd(rx_ring, i);
 		bd_status = le32_to_cpu(rxbd->r.lstatus);
 		if (!bd_status)
 			break;
@@ -670,12 +669,10 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 		enetc_get_offloads(rx_ring, rxbd, skb);
 
 		cleaned_cnt++;
-		rxbd++;
-		i++;
-		if (unlikely(i == rx_ring->bd_count)) {
+
+		rxbd = enetc_rxbd_next(rx_ring, rxbd, i);
+		if (unlikely(++i == rx_ring->bd_count))
 			i = 0;
-			rxbd = ENETC_RXBD(*rx_ring, 0);
-		}
 
 		if (unlikely(bd_status &
 			     ENETC_RXBD_LSTATUS(ENETC_RXBD_ERR_MASK))) {
@@ -683,12 +680,10 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 			while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
 				dma_rmb();
 				bd_status = le32_to_cpu(rxbd->r.lstatus);
-				rxbd++;
-				i++;
-				if (unlikely(i == rx_ring->bd_count)) {
+
+				rxbd = enetc_rxbd_next(rx_ring, rxbd, i);
+				if (unlikely(++i == rx_ring->bd_count))
 					i = 0;
-					rxbd = ENETC_RXBD(*rx_ring, 0);
-				}
 			}
 
 			rx_ring->ndev->stats.rx_dropped++;
@@ -710,12 +705,10 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 			enetc_add_rx_buff_to_skb(rx_ring, i, size, skb);
 
 			cleaned_cnt++;
-			rxbd++;
-			i++;
-			if (unlikely(i == rx_ring->bd_count)) {
+
+			rxbd = enetc_rxbd_next(rx_ring, rxbd, i);
+			if (unlikely(++i == rx_ring->bd_count))
 				i = 0;
-				rxbd = ENETC_RXBD(*rx_ring, 0);
-			}
 		}
 
 		rx_byte_cnt += skb->len;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 9938f7a5fc0a..1cd4cddd5c58 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -104,7 +104,22 @@ struct enetc_cbdr {
 };
 
 #define ENETC_TXBD(BDR, i) (&(((union enetc_tx_bd *)((BDR).bd_base))[i]))
-#define ENETC_RXBD(BDR, i) (&(((union enetc_rx_bd *)((BDR).bd_base))[i]))
+
+static inline union enetc_rx_bd *enetc_rxbd(struct enetc_bdr *rx_ring, int i)
+{
+	return &(((union enetc_rx_bd *)rx_ring->bd_base)[i]);
+}
+
+static inline union enetc_rx_bd *enetc_rxbd_next(struct enetc_bdr *rx_ring,
+						 union enetc_rx_bd *rxbd,
+						 int i)
+{
+	rxbd++;
+	if (unlikely(++i == rx_ring->bd_count))
+		rxbd = rx_ring->bd_base;
+
+	return rxbd;
+}
 
 struct enetc_msg_swbd {
 	void *vaddr;
-- 
2.17.1


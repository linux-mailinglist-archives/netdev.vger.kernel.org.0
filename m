Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1B43AB791
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 17:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhFQPgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 11:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231661AbhFQPgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 11:36:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D90A613E2;
        Thu, 17 Jun 2021 15:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623944052;
        bh=fID2dZi70tRGqL7aN4L2p5zaR3M6/uWbQdFE9XOMCN8=;
        h=From:To:Cc:Subject:Date:From;
        b=mTvM5MVAZhkFrBJxo3fn/3mHnDZyGTypKXuKydyu6eIxAjexA1iS2Zgu5b6qLEAOu
         Yx7qgNfR17kMdFABwwErch5c5KKHpghap3hH0BCaCSVy5fK5fzP1iKET1p9851/Wl7
         x/MLaMPdPfF6Een5D2tNdnk+92kDnBU3qtgxzLf+ZTPd7M/k1v1T0IXNzuh8E6SsAA
         4LWbAuJWhLuFrMrv/PTT8c2q1apNNX/OA/cKG5APMe8nrJ7LnWzuOOf8/1NrFkFkcq
         5k3OmDwZDNkhYvHU4rCv346cg8Fh75TbzkdBmbsgsxJIhplzDyKba1k9odTg0l2ODe
         bJ3SnneUTOpNQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, mcroce@linux.microsoft.com,
        davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        sbhatta@marvell.com, stefanc@marvell.com, brouer@redhat.com
Subject: [PATCH net-next] net: marvell: return csum computation result from mvneta_rx_csum/mvpp2_rx_csum
Date:   Thu, 17 Jun 2021 17:34:07 +0200
Message-Id: <73619ca7d64b1dee91ed8ed2dcf0ddbbc57b4b0a.1623943981.git.lorenzo@kernel.org>
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


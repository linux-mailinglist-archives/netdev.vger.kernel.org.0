Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8507F3946A3
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 19:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhE1Rpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 13:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhE1Rpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 13:45:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62D4E613B5;
        Fri, 28 May 2021 17:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622223851;
        bh=vpPbdfyPwSKrlEO/cazA/OQmRGsWg3i09s50a/Ckt6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aci4mmdJOg2dAy1/JIhMQaxp8p6nPeZDJBDrp990uDMNu2bFzPLnBS5FzSEgzHjki
         eM6R+U8qMPugwxDqRC16GmWSMCk0hZDrlgCW0Cs/B32eR4XdEbWjmo+T09aUXQWQ38
         iWdJK1uOPCx2hcgIZ8AYiQVoBrXFYNBSPqhpL3JRxG+/xhGN5mSarA7FuCoOW0lv4S
         ABMCTYF66ixBFGyu/EerkaJxjofVh3Z9urMOkeNDgxT9EZXLxmWi1NFh9DZMNiPba6
         wRpASag++YVrAFbhFP0BCGLOvxbrDGYt339sO3B7ht6kDrn3ZqjLu1dAQXsvTaI6fO
         JzbFmIBu/qjKA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, echaudro@redhat.com,
        dsahern@gmail.com, magnus.karlsson@intel.com, toke@redhat.com,
        brouer@redhat.com, bjorn@kernel.org, maciej.fijalkowski@intel.com,
        john.fastabend@gmail.com
Subject: [RFC bpf-next 2/4] mvneta: return csum computation result from mvneta_rx_csum
Date:   Fri, 28 May 2021 19:43:42 +0200
Message-Id: <3d89a6af46b4b381256e050f2a02f87db06ceabb.1622222367.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622222367.git.lorenzo@kernel.org>
References: <cover.1622222367.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preliminary patch to add hw csum hint support to mvneta xdp
implementation

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 7d5cd9bc6c99..4a7c153a2666 100644
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
@@ -2335,7 +2331,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, xdp->data_end - xdp->data);
-	mvneta_rx_csum(pp, desc_status, skb);
+	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
 
 	for (i = 0; i < num_frags; i++) {
 		skb_frag_t *frag = &sinfo->frags[i];
@@ -2532,7 +2528,7 @@ static int mvneta_rx_hwbm(struct napi_struct *napi,
 				     rx_bytes);
 
 			skb->protocol = eth_type_trans(skb, dev);
-			mvneta_rx_csum(pp, rx_status, skb);
+			skb->ip_summed = mvneta_rx_csum(pp, rx_status);
 			napi_gro_receive(napi, skb);
 
 			rcvd_pkts++;
@@ -2581,8 +2577,7 @@ static int mvneta_rx_hwbm(struct napi_struct *napi,
 		skb_put(skb, rx_bytes);
 
 		skb->protocol = eth_type_trans(skb, dev);
-
-		mvneta_rx_csum(pp, rx_status, skb);
+		skb->ip_summed = mvneta_rx_csum(pp, rx_status);
 
 		napi_gro_receive(napi, skb);
 	}
-- 
2.31.1


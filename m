Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8073D1201
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbhGUOa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237799AbhGUOa3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 10:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1C796121E;
        Wed, 21 Jul 2021 15:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626880265;
        bh=dm4G1VBvcKC3skExsS0+2OpoNhySkpTyIrpRFNBmE8E=;
        h=From:To:Cc:Subject:Date:From;
        b=FLdIp/gJ/ZjlIRQ5Jy7SuCqBwbFLbvv6xKnA12Uxu9peSwVqqZzCt9vouMCvnJzEs
         lMJHvMdhe88Qj6DAbGD4mf48ZxHlwps4sq84TZbHywATDGYbVdrpDXnJPOpQLuLcBX
         tGEsaMOdU2i4VoYO0pNAcSXDKWJRQCZsJdjBM6N5TBRzFqqNX++UivVrosX/N6/hdB
         GN+V/5tKN6m44RN83SocgjjlwRfizz5sg+Mcs+ClhGTv4Sg7REgiDdvCMQgNYSBJ8b
         sCt7FpwZiju4WC/KnUsS7opeBywXCS+VEq2CVya6dn8kb7aNKR9iZ2cNcG2MOmWWa4
         fpKEJ+6YRE87w==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Catherine Sullivan <csully@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Bailey Forrest <bcf@google.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gve: DQO: avoid unused variable warnings
Date:   Wed, 21 Jul 2021 17:10:51 +0200
Message-Id: <20210721151100.2042139-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The use of dma_unmap_addr()/dma_unmap_len() in the driver causes
multiple warnings when these macros are defined as empty:

drivers/net/ethernet/google/gve/gve_tx_dqo.c: In function 'gve_tx_add_skb_no_copy_dqo':
drivers/net/ethernet/google/gve/gve_tx_dqo.c:494:40: error: unused variable 'buf' [-Werror=unused-variable]
  494 |                 struct gve_tx_dma_buf *buf =

As it turns out, there are three copies of the same loop,
and one of them is already split out into a separate function.

Fix the warning in this one place, and change the other two
to call it instead of open-coding the same loop.

Fixes: a57e5de476be ("gve: DQO: Add TX path")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
The warning is present in both 5.14-rc2 and net-next as of today
---
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 92 ++++++++------------
 1 file changed, 35 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index 05ddb6a75c38..fffa882db493 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -73,6 +73,26 @@ gve_free_pending_packet(struct gve_tx_ring *tx,
 	}
 }
 
+static void gve_unmap_packet(struct device *dev,
+			     struct gve_tx_pending_packet_dqo *pending_packet)
+{
+	dma_addr_t addr;
+	size_t len;
+	int i;
+
+	/* SKB linear portion is guaranteed to be mapped */
+	addr = dma_unmap_addr(&pending_packet->bufs[0], dma);
+	len = dma_unmap_len(&pending_packet->bufs[0], len);
+	dma_unmap_single(dev, addr, len, DMA_TO_DEVICE);
+
+	for (i = 1; i < pending_packet->num_bufs; i++) {
+		addr = dma_unmap_addr(&pending_packet->bufs[i], dma);
+		len = dma_unmap_len(&pending_packet->bufs[i], len);
+		dma_unmap_page(dev, addr, len, DMA_TO_DEVICE);
+	}
+	pending_packet->num_bufs = 0;
+}
+
 /* gve_tx_free_desc - Cleans up all pending tx requests and buffers.
  */
 static void gve_tx_clean_pending_packets(struct gve_tx_ring *tx)
@@ -82,23 +102,8 @@ static void gve_tx_clean_pending_packets(struct gve_tx_ring *tx)
 	for (i = 0; i < tx->dqo.num_pending_packets; i++) {
 		struct gve_tx_pending_packet_dqo *cur_state =
 			&tx->dqo.pending_packets[i];
-		int j;
-
-		for (j = 0; j < cur_state->num_bufs; j++) {
-			struct gve_tx_dma_buf *buf = &cur_state->bufs[j];
-
-			if (j == 0) {
-				dma_unmap_single(tx->dev,
-						 dma_unmap_addr(buf, dma),
-						 dma_unmap_len(buf, len),
-						 DMA_TO_DEVICE);
-			} else {
-				dma_unmap_page(tx->dev,
-					       dma_unmap_addr(buf, dma),
-					       dma_unmap_len(buf, len),
-					       DMA_TO_DEVICE);
-			}
-		}
+
+		gve_unmap_packet(tx->dev, cur_state);
 		if (cur_state->skb) {
 			dev_consume_skb_any(cur_state->skb);
 			cur_state->skb = NULL;
@@ -445,6 +450,13 @@ gve_tx_fill_general_ctx_desc(struct gve_tx_general_context_desc_dqo *desc,
 	};
 }
 
+static inline void gve_tx_dma_buf_set(struct gve_tx_dma_buf *buf,
+				      dma_addr_t addr, size_t len)
+{
+	dma_unmap_len_set(buf, len, len);
+	dma_unmap_addr_set(buf, dma, addr);
+}
+
 /* Returns 0 on success, or < 0 on error.
  *
  * Before this function is called, the caller must ensure
@@ -459,6 +471,7 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 
 	struct gve_tx_pending_packet_dqo *pending_packet;
 	struct gve_tx_metadata_dqo metadata;
+	struct gve_tx_dma_buf *buf;
 	s16 completion_tag;
 	int i;
 
@@ -493,8 +506,6 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 
 	/* Map the linear portion of skb */
 	{
-		struct gve_tx_dma_buf *buf =
-			&pending_packet->bufs[pending_packet->num_bufs];
 		u32 len = skb_headlen(skb);
 		dma_addr_t addr;
 
@@ -502,8 +513,8 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 		if (unlikely(dma_mapping_error(tx->dev, addr)))
 			goto err;
 
-		dma_unmap_len_set(buf, len, len);
-		dma_unmap_addr_set(buf, dma, addr);
+		buf = &pending_packet->bufs[pending_packet->num_bufs];
+		gve_tx_dma_buf_set(buf, addr, len);
 		++pending_packet->num_bufs;
 
 		gve_tx_fill_pkt_desc_dqo(tx, &desc_idx, skb, len, addr,
@@ -512,8 +523,6 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 	}
 
 	for (i = 0; i < shinfo->nr_frags; i++) {
-		struct gve_tx_dma_buf *buf =
-			&pending_packet->bufs[pending_packet->num_bufs];
 		const skb_frag_t *frag = &shinfo->frags[i];
 		bool is_eop = i == (shinfo->nr_frags - 1);
 		u32 len = skb_frag_size(frag);
@@ -523,8 +532,8 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 		if (unlikely(dma_mapping_error(tx->dev, addr)))
 			goto err;
 
-		dma_unmap_len_set(buf, len, len);
-		dma_unmap_addr_set(buf, dma, addr);
+		buf = &pending_packet->bufs[pending_packet->num_bufs];
+		gve_tx_dma_buf_set(buf, addr, len);
 		++pending_packet->num_bufs;
 
 		gve_tx_fill_pkt_desc_dqo(tx, &desc_idx, skb, len, addr,
@@ -552,21 +561,8 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 	return 0;
 
 err:
-	for (i = 0; i < pending_packet->num_bufs; i++) {
-		struct gve_tx_dma_buf *buf = &pending_packet->bufs[i];
-
-		if (i == 0) {
-			dma_unmap_single(tx->dev, dma_unmap_addr(buf, dma),
-					 dma_unmap_len(buf, len),
-					 DMA_TO_DEVICE);
-		} else {
-			dma_unmap_page(tx->dev, dma_unmap_addr(buf, dma),
-				       dma_unmap_len(buf, len), DMA_TO_DEVICE);
-		}
-	}
-
+	gve_unmap_packet(tx->dev, pending_packet);
 	pending_packet->skb = NULL;
-	pending_packet->num_bufs = 0;
 	gve_free_pending_packet(tx, pending_packet);
 
 	return -1;
@@ -746,24 +742,6 @@ static void remove_from_list(struct gve_tx_ring *tx,
 	}
 }
 
-static void gve_unmap_packet(struct device *dev,
-			     struct gve_tx_pending_packet_dqo *pending_packet)
-{
-	struct gve_tx_dma_buf *buf;
-	int i;
-
-	/* SKB linear portion is guaranteed to be mapped */
-	buf = &pending_packet->bufs[0];
-	dma_unmap_single(dev, dma_unmap_addr(buf, dma),
-			 dma_unmap_len(buf, len), DMA_TO_DEVICE);
-	for (i = 1; i < pending_packet->num_bufs; i++) {
-		buf = &pending_packet->bufs[i];
-		dma_unmap_page(dev, dma_unmap_addr(buf, dma),
-			       dma_unmap_len(buf, len), DMA_TO_DEVICE);
-	}
-	pending_packet->num_bufs = 0;
-}
-
 /* Completion types and expected behavior:
  * No Miss compl + Packet compl = Packet completed normally.
  * Miss compl + Re-inject compl = Packet completed normally.
-- 
2.29.2


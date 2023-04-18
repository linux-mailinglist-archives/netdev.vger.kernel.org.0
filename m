Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B3B6E6C9B
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 21:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjDRTFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 15:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjDRTFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 15:05:10 -0400
Received: from mx25lb.world4you.com (mx25lb.world4you.com [81.19.149.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E449619A2;
        Tue, 18 Apr 2023 12:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=khtgD2dlqys33XlLzQIKFbAd+FNZ0CBOijYymTYFaRE=; b=cCDS/cM56dMtlnMQcXqVKSv8PW
        iQL5oMnxGVubZ4R+bjwMSUGS8aHhBSC5xHMpfbOfmxjPzPH0ja+tYSvhCS4cwecNgUL6HooYKjy5B
        yyhYu7rbMWlIGtPBeq3hEkb5/BoPAYADm0UUBtEiPQzSZkL8wG1aSXkQ8xGRldkfMPd4=;
Received: from 88-117-57-231.adsl.highway.telekom.at ([88.117.57.231] helo=hornet.engleder.at)
        by mx25lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1poqdW-0002eV-70; Tue, 18 Apr 2023 21:05:06 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 1/6] tsnep: Replace modulo operation with mask
Date:   Tue, 18 Apr 2023 21:04:54 +0200
Message-Id: <20230418190459.19326-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230418190459.19326-1-gerhard@engleder-embedded.com>
References: <20230418190459.19326-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-ACL-Warn: X-W4Y-Internal
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TX/RX ring size is static and power of 2 to enable compiler to optimize
modulo operation to mask operation. Make this optimization already in
the code and don't rely on the compiler.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      |  1 +
 drivers/net/ethernet/engleder/tsnep_main.c | 28 +++++++++++-----------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 058c2bcf31a7..1de26aec78d3 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -18,6 +18,7 @@
 #define TSNEP "tsnep"
 
 #define TSNEP_RING_SIZE 256
+#define TSNEP_RING_MASK (TSNEP_RING_SIZE - 1)
 #define TSNEP_RING_RX_REFILL 16
 #define TSNEP_RING_RX_REUSE (TSNEP_RING_SIZE - TSNEP_RING_SIZE / 4)
 #define TSNEP_RING_ENTRIES_PER_PAGE (PAGE_SIZE / TSNEP_DESC_SIZE)
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index ed1b6102cfeb..3d15e673894a 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -292,7 +292,7 @@ static int tsnep_tx_ring_init(struct tsnep_tx *tx)
 	}
 	for (i = 0; i < TSNEP_RING_SIZE; i++) {
 		entry = &tx->entry[i];
-		next_entry = &tx->entry[(i + 1) % TSNEP_RING_SIZE];
+		next_entry = &tx->entry[(i + 1) & TSNEP_RING_MASK];
 		entry->desc->next = __cpu_to_le64(next_entry->desc_dma);
 	}
 
@@ -381,7 +381,7 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
 	int i;
 
 	for (i = 0; i < count; i++) {
-		entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
+		entry = &tx->entry[(tx->write + i) & TSNEP_RING_MASK];
 
 		if (!i) {
 			len = skb_headlen(skb);
@@ -419,7 +419,7 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
 	int i;
 
 	for (i = 0; i < count; i++) {
-		entry = &tx->entry[(index + i) % TSNEP_RING_SIZE];
+		entry = &tx->entry[(index + i) & TSNEP_RING_MASK];
 
 		if (entry->len) {
 			if (entry->type & TSNEP_TX_TYPE_SKB)
@@ -481,9 +481,9 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
 	for (i = 0; i < count; i++)
-		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE, length,
+		tsnep_tx_activate(tx, (tx->write + i) & TSNEP_RING_MASK, length,
 				  i == count - 1);
-	tx->write = (tx->write + count) % TSNEP_RING_SIZE;
+	tx->write = (tx->write + count) & TSNEP_RING_MASK;
 
 	skb_tx_timestamp(skb);
 
@@ -516,7 +516,7 @@ static int tsnep_xdp_tx_map(struct xdp_frame *xdpf, struct tsnep_tx *tx,
 	frag = NULL;
 	len = xdpf->len;
 	for (i = 0; i < count; i++) {
-		entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
+		entry = &tx->entry[(tx->write + i) & TSNEP_RING_MASK];
 		if (type & TSNEP_TX_TYPE_XDP_NDO) {
 			data = unlikely(frag) ? skb_frag_address(frag) :
 						xdpf->data;
@@ -589,9 +589,9 @@ static bool tsnep_xdp_xmit_frame_ring(struct xdp_frame *xdpf,
 	length = retval;
 
 	for (i = 0; i < count; i++)
-		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE, length,
+		tsnep_tx_activate(tx, (tx->write + i) & TSNEP_RING_MASK, length,
 				  i == count - 1);
-	tx->write = (tx->write + count) % TSNEP_RING_SIZE;
+	tx->write = (tx->write + count) & TSNEP_RING_MASK;
 
 	/* descriptor properties shall be valid before hardware is notified */
 	dma_wmb();
@@ -691,7 +691,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 		/* xdpf is union with skb */
 		entry->skb = NULL;
 
-		tx->read = (tx->read + count) % TSNEP_RING_SIZE;
+		tx->read = (tx->read + count) & TSNEP_RING_MASK;
 
 		tx->packets++;
 		tx->bytes += length + ETH_FCS_LEN;
@@ -839,7 +839,7 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
 
 	for (i = 0; i < TSNEP_RING_SIZE; i++) {
 		entry = &rx->entry[i];
-		next_entry = &rx->entry[(i + 1) % TSNEP_RING_SIZE];
+		next_entry = &rx->entry[(i + 1) & TSNEP_RING_MASK];
 		entry->desc->next = __cpu_to_le64(next_entry->desc_dma);
 	}
 
@@ -925,7 +925,7 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
 	int retval;
 
 	for (i = 0; i < count && !alloc_failed; i++) {
-		index = (rx->write + i) % TSNEP_RING_SIZE;
+		index = (rx->write + i) & TSNEP_RING_MASK;
 
 		retval = tsnep_rx_alloc_buffer(rx, index);
 		if (unlikely(retval)) {
@@ -945,7 +945,7 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
 	}
 
 	if (enable) {
-		rx->write = (rx->write + i) % TSNEP_RING_SIZE;
+		rx->write = (rx->write + i) & TSNEP_RING_MASK;
 
 		/* descriptor properties shall be valid before hardware is
 		 * notified
@@ -1090,7 +1090,7 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 				 * empty RX ring, thus buffer cannot be used for
 				 * RX processing
 				 */
-				rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
+				rx->read = (rx->read + 1) & TSNEP_RING_MASK;
 				desc_available++;
 
 				rx->dropped++;
@@ -1117,7 +1117,7 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 		 */
 		length -= TSNEP_RX_INLINE_METADATA_SIZE;
 
-		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
+		rx->read = (rx->read + 1) & TSNEP_RING_MASK;
 		desc_available++;
 
 		if (prog) {
-- 
2.30.2


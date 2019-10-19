Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52F5DD756
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 10:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfJSIOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 04:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfJSIOE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Oct 2019 04:14:04 -0400
Received: from localhost.localdomain (unknown [151.66.3.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7040B21D80;
        Sat, 19 Oct 2019 08:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571472842;
        bh=c2bIxoSLrWGUQfG7A42YtweDCuZuALMMWi+6pM/Jg7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkRcSoqoLiYxcFCDi9xpH5rE5KbVafkAX6DZ2Usu8qohliKMTe82J95uPzraThnx6
         s32mr619KPb2Q7+Q/GzwZyPyvMqfefpJCD0QP+3n1nh7W59jsvozpYYwATmZevxYWZ
         05TKaSzurwQ73xGP7TEPx/y9yr+jX694DfdAZwzs=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com, jakub.kicinski@netronome.com
Subject: [PATCH v5 net-next 6/7] net: mvneta: make tx buffer array agnostic
Date:   Sat, 19 Oct 2019 10:13:26 +0200
Message-Id: <935641e63cf776f836bb4b1d67bd39e9a12e9afb.1571472169.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571472169.git.lorenzo@kernel.org>
References: <cover.1571472169.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow tx buffer array to contain both skb and xdp buffers in order to
enable xdp frame recycling adding XDP_TX verdict support

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 66 +++++++++++++++++----------
 1 file changed, 43 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 64f59baa2a3c..e83d5e069b4f 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -561,6 +561,20 @@ struct mvneta_rx_desc {
 };
 #endif
 
+enum mvneta_tx_buf_type {
+	MVNETA_TYPE_SKB,
+	MVNETA_TYPE_XDP_TX,
+	MVNETA_TYPE_XDP_NDO,
+};
+
+struct mvneta_tx_buf {
+	enum mvneta_tx_buf_type type;
+	union {
+		struct xdp_frame *xdpf;
+		struct sk_buff *skb;
+	};
+};
+
 struct mvneta_tx_queue {
 	/* Number of this TX queue, in the range 0-7 */
 	u8 id;
@@ -576,8 +590,8 @@ struct mvneta_tx_queue {
 	int tx_stop_threshold;
 	int tx_wake_threshold;
 
-	/* Array of transmitted skb */
-	struct sk_buff **tx_skb;
+	/* Array of transmitted buffers */
+	struct mvneta_tx_buf *buf;
 
 	/* Index of last TX DMA descriptor that was inserted */
 	int txq_put_index;
@@ -1780,14 +1794,9 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 	int i;
 
 	for (i = 0; i < num; i++) {
+		struct mvneta_tx_buf *buf = &txq->buf[txq->txq_get_index];
 		struct mvneta_tx_desc *tx_desc = txq->descs +
 			txq->txq_get_index;
-		struct sk_buff *skb = txq->tx_skb[txq->txq_get_index];
-
-		if (skb) {
-			bytes_compl += skb->len;
-			pkts_compl++;
-		}
 
 		mvneta_txq_inc_get(txq);
 
@@ -1795,9 +1804,12 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 			dma_unmap_single(pp->dev->dev.parent,
 					 tx_desc->buf_phys_addr,
 					 tx_desc->data_size, DMA_TO_DEVICE);
-		if (!skb)
+		if (!buf->skb)
 			continue;
-		dev_kfree_skb_any(skb);
+
+		bytes_compl += buf->skb->len;
+		pkts_compl++;
+		dev_kfree_skb_any(buf->skb);
 	}
 
 	netdev_tx_completed_queue(nq, pkts_compl, bytes_compl);
@@ -2324,16 +2336,19 @@ static inline void
 mvneta_tso_put_hdr(struct sk_buff *skb,
 		   struct mvneta_port *pp, struct mvneta_tx_queue *txq)
 {
-	struct mvneta_tx_desc *tx_desc;
 	int hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
+	struct mvneta_tx_desc *tx_desc;
 
-	txq->tx_skb[txq->txq_put_index] = NULL;
 	tx_desc = mvneta_txq_next_desc_get(txq);
 	tx_desc->data_size = hdr_len;
 	tx_desc->command = mvneta_skb_tx_csum(pp, skb);
 	tx_desc->command |= MVNETA_TXD_F_DESC;
 	tx_desc->buf_phys_addr = txq->tso_hdrs_phys +
 				 txq->txq_put_index * TSO_HEADER_SIZE;
+	buf->type = MVNETA_TYPE_SKB;
+	buf->skb = NULL;
+
 	mvneta_txq_inc_put(txq);
 }
 
@@ -2342,6 +2357,7 @@ mvneta_tso_put_data(struct net_device *dev, struct mvneta_tx_queue *txq,
 		    struct sk_buff *skb, char *data, int size,
 		    bool last_tcp, bool is_last)
 {
+	struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
 	struct mvneta_tx_desc *tx_desc;
 
 	tx_desc = mvneta_txq_next_desc_get(txq);
@@ -2355,7 +2371,8 @@ mvneta_tso_put_data(struct net_device *dev, struct mvneta_tx_queue *txq,
 	}
 
 	tx_desc->command = 0;
-	txq->tx_skb[txq->txq_put_index] = NULL;
+	buf->type = MVNETA_TYPE_SKB;
+	buf->skb = NULL;
 
 	if (last_tcp) {
 		/* last descriptor in the TCP packet */
@@ -2363,7 +2380,7 @@ mvneta_tso_put_data(struct net_device *dev, struct mvneta_tx_queue *txq,
 
 		/* last descriptor in SKB */
 		if (is_last)
-			txq->tx_skb[txq->txq_put_index] = skb;
+			buf->skb = skb;
 	}
 	mvneta_txq_inc_put(txq);
 	return 0;
@@ -2448,6 +2465,7 @@ static int mvneta_tx_frag_process(struct mvneta_port *pp, struct sk_buff *skb,
 	int i, nr_frags = skb_shinfo(skb)->nr_frags;
 
 	for (i = 0; i < nr_frags; i++) {
+		struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		void *addr = skb_frag_address(frag);
 
@@ -2467,12 +2485,13 @@ static int mvneta_tx_frag_process(struct mvneta_port *pp, struct sk_buff *skb,
 		if (i == nr_frags - 1) {
 			/* Last descriptor */
 			tx_desc->command = MVNETA_TXD_L_DESC | MVNETA_TXD_Z_PAD;
-			txq->tx_skb[txq->txq_put_index] = skb;
+			buf->skb = skb;
 		} else {
 			/* Descriptor in the middle: Not First, Not Last */
 			tx_desc->command = 0;
-			txq->tx_skb[txq->txq_put_index] = NULL;
+			buf->skb = NULL;
 		}
+		buf->type = MVNETA_TYPE_SKB;
 		mvneta_txq_inc_put(txq);
 	}
 
@@ -2500,6 +2519,7 @@ static netdev_tx_t mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 	struct mvneta_port *pp = netdev_priv(dev);
 	u16 txq_id = skb_get_queue_mapping(skb);
 	struct mvneta_tx_queue *txq = &pp->txqs[txq_id];
+	struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
 	struct mvneta_tx_desc *tx_desc;
 	int len = skb->len;
 	int frags = 0;
@@ -2532,16 +2552,17 @@ static netdev_tx_t mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 		goto out;
 	}
 
+	buf->type = MVNETA_TYPE_SKB;
 	if (frags == 1) {
 		/* First and Last descriptor */
 		tx_cmd |= MVNETA_TXD_FLZ_DESC;
 		tx_desc->command = tx_cmd;
-		txq->tx_skb[txq->txq_put_index] = skb;
+		buf->skb = skb;
 		mvneta_txq_inc_put(txq);
 	} else {
 		/* First but not Last */
 		tx_cmd |= MVNETA_TXD_F_DESC;
-		txq->tx_skb[txq->txq_put_index] = NULL;
+		buf->skb = NULL;
 		mvneta_txq_inc_put(txq);
 		tx_desc->command = tx_cmd;
 		/* Continue with other skb fragments */
@@ -3128,9 +3149,8 @@ static int mvneta_txq_sw_init(struct mvneta_port *pp,
 
 	txq->last_desc = txq->size - 1;
 
-	txq->tx_skb = kmalloc_array(txq->size, sizeof(*txq->tx_skb),
-				    GFP_KERNEL);
-	if (!txq->tx_skb) {
+	txq->buf = kmalloc_array(txq->size, sizeof(*txq->buf), GFP_KERNEL);
+	if (!txq->buf) {
 		dma_free_coherent(pp->dev->dev.parent,
 				  txq->size * MVNETA_DESC_ALIGNED_SIZE,
 				  txq->descs, txq->descs_phys);
@@ -3142,7 +3162,7 @@ static int mvneta_txq_sw_init(struct mvneta_port *pp,
 					   txq->size * TSO_HEADER_SIZE,
 					   &txq->tso_hdrs_phys, GFP_KERNEL);
 	if (!txq->tso_hdrs) {
-		kfree(txq->tx_skb);
+		kfree(txq->buf);
 		dma_free_coherent(pp->dev->dev.parent,
 				  txq->size * MVNETA_DESC_ALIGNED_SIZE,
 				  txq->descs, txq->descs_phys);
@@ -3195,7 +3215,7 @@ static void mvneta_txq_sw_deinit(struct mvneta_port *pp,
 {
 	struct netdev_queue *nq = netdev_get_tx_queue(pp->dev, txq->id);
 
-	kfree(txq->tx_skb);
+	kfree(txq->buf);
 
 	if (txq->tso_hdrs)
 		dma_free_coherent(pp->dev->dev.parent,
-- 
2.21.0


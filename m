Return-Path: <netdev+bounces-1416-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91A1C6FDB70
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:15:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEEFF280FBA
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 036FE6FD4;
	Wed, 10 May 2023 10:15:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3E420B41
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 10:15:48 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089791FC1
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+iAMCD4K4oIWGjfXVaFoRx4d73EsLfvjs0XcJkdxeK0=; b=eUHRv6ndMzQ5DLrWdz5TKhLQFC
	dnEm80Or9OglsGfGCcDT+QPUA6Q0O91LAej49AQbcny0uoT8yAtz311yAp2AujT2KbKTsa7awrWQB
	0gGQVYnfIkvBNElhPa6AuAHtpQgUF2BeN1IA2s3rY0Y/92g5vwMBbP6i9jCV7Pq0WUqgNDs7YmwrT
	XyQojnykd+m4ljfHejF+Qlgr9XA4kcqqw0mOqQKoG3m0PiCm136r0+gBfvylA0229XoKFx1mDnRD5
	E3gGJHWI+97v+2wJGXizn2n0jMdPt5E4fvClyjaXlpSn0B7qnq6GzTDsXsQdN3zz9yBb1XjDbDSPd
	o9z5nHug==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34616 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pwgrH-0004jX-Jj; Wed, 10 May 2023 11:15:43 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pwgrG-001XDm-VF; Wed, 10 May 2023 11:15:43 +0100
In-Reply-To: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk>
References: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	 Eric Dumazet <edumazet@google.com>,
	 Jakub Kicinski <kuba@kernel.org>,
	 netdev@vger.kernel.org,
	 Paolo Abeni <pabeni@redhat.com>,
	 Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH net-next 1/5] net: mvneta: fix transmit path dma-unmapping on
 error
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pwgrG-001XDm-VF@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 10 May 2023 11:15:42 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The transmit code assumes that the transmit descriptors that are used
begin with the first descriptor in the ring, but this may not be the
case. Fix this by providing a new function that dma-unmaps a range of
numbered descriptor entries, and use that to do the unmapping.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 53 +++++++++++++++++----------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 2cad76d0a50e..62400ff61e34 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2714,14 +2714,40 @@ mvneta_tso_put_data(struct net_device *dev, struct mvneta_tx_queue *txq,
 	return 0;
 }
 
+static void mvneta_release_descs(struct mvneta_port *pp,
+				 struct mvneta_tx_queue *txq,
+				 int first, int num)
+{
+	int desc_idx, i;
+
+	desc_idx = first + num;
+	if (desc_idx >= txq->size)
+		desc_idx -= txq->size;
+
+	for (i = num; i >= 0; i--) {
+		struct mvneta_tx_desc *tx_desc = txq->descs + desc_idx;
+
+		if (!IS_TSO_HEADER(txq, tx_desc->buf_phys_addr))
+			dma_unmap_single(pp->dev->dev.parent,
+					 tx_desc->buf_phys_addr,
+					 tx_desc->data_size,
+					 DMA_TO_DEVICE);
+
+		mvneta_txq_desc_put(txq);
+
+		if (desc_idx == 0)
+			desc_idx = txq->size;
+		desc_idx -= 1;
+	}
+}
+
 static int mvneta_tx_tso(struct sk_buff *skb, struct net_device *dev,
 			 struct mvneta_tx_queue *txq)
 {
 	int hdr_len, total_len, data_left;
-	int desc_count = 0;
+	int first_desc, desc_count = 0;
 	struct mvneta_port *pp = netdev_priv(dev);
 	struct tso_t tso;
-	int i;
 
 	/* Count needed descriptors */
 	if ((txq->count + tso_count_descs(skb)) >= txq->size)
@@ -2732,6 +2758,8 @@ static int mvneta_tx_tso(struct sk_buff *skb, struct net_device *dev,
 		return 0;
 	}
 
+	first_desc = txq->txq_put_index;
+
 	/* Initialize the TSO handler, and prepare the first payload */
 	hdr_len = tso_start(skb, &tso);
 
@@ -2772,15 +2800,7 @@ static int mvneta_tx_tso(struct sk_buff *skb, struct net_device *dev,
 	/* Release all used data descriptors; header descriptors must not
 	 * be DMA-unmapped.
 	 */
-	for (i = desc_count - 1; i >= 0; i--) {
-		struct mvneta_tx_desc *tx_desc = txq->descs + i;
-		if (!IS_TSO_HEADER(txq, tx_desc->buf_phys_addr))
-			dma_unmap_single(pp->dev->dev.parent,
-					 tx_desc->buf_phys_addr,
-					 tx_desc->data_size,
-					 DMA_TO_DEVICE);
-		mvneta_txq_desc_put(txq);
-	}
+	mvneta_release_descs(pp, txq, first_desc, desc_count - 1);
 	return 0;
 }
 
@@ -2790,6 +2810,7 @@ static int mvneta_tx_frag_process(struct mvneta_port *pp, struct sk_buff *skb,
 {
 	struct mvneta_tx_desc *tx_desc;
 	int i, nr_frags = skb_shinfo(skb)->nr_frags;
+	int first_desc = txq->txq_put_index;
 
 	for (i = 0; i < nr_frags; i++) {
 		struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
@@ -2828,15 +2849,7 @@ static int mvneta_tx_frag_process(struct mvneta_port *pp, struct sk_buff *skb,
 	/* Release all descriptors that were used to map fragments of
 	 * this packet, as well as the corresponding DMA mappings
 	 */
-	for (i = i - 1; i >= 0; i--) {
-		tx_desc = txq->descs + i;
-		dma_unmap_single(pp->dev->dev.parent,
-				 tx_desc->buf_phys_addr,
-				 tx_desc->data_size,
-				 DMA_TO_DEVICE);
-		mvneta_txq_desc_put(txq);
-	}
-
+	mvneta_release_descs(pp, txq, first_desc, i - 1);
 	return -ENOMEM;
 }
 
-- 
2.30.2



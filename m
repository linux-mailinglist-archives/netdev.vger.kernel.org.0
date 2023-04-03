Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3426E6D5063
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjDCSai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbjDCSad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:30:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665EE93
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 11:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+iAMCD4K4oIWGjfXVaFoRx4d73EsLfvjs0XcJkdxeK0=; b=k4ioIav/0hI1mNk/Mgi/ZRWF/r
        2c5w4Z0pptO8F5OqgJl1XCdNLUCvmT7VnrV/ZU6YpzvvXLTIbMWaT5V0hOZwGhXpiFQf94SWA7LfU
        UCrvUPVRBgjA84JSG0POhGbAKZE2swJOPxE2r+lXjSHj4diw5qkFhDsInJJkl0XnNmYa+o7MKIViY
        EI0moBaYvpTD0Gw7I7+WK7q4AfswDQ9P/C9hvbWZx9f2/m7p41okGvnVSMIGspJ2m6DLgCOfSmHOd
        GNKnJmxpDt8cLEH+e5MiOz/E0YTCJbxynqV1CYGIR9CQNuLaVO2Wof+/TmOw26D84qNc/UA8aRgy8
        1poHEqwQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:59100 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pjOwe-00037T-Rr; Mon, 03 Apr 2023 19:30:20 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pjOwe-00Fmki-6p; Mon, 03 Apr 2023 19:30:20 +0100
In-Reply-To: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
References: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Marek Beh__n <kabel@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 1/5] net: mvneta: fix transmit path dma-unmapping
 on error
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pjOwe-00Fmki-6p@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 03 Apr 2023 19:30:20 +0100
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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


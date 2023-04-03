Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7226D5066
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbjDCSax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbjDCSak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:30:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC33830E1
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 11:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3neK9KLueYQQg1ADiQjAOBvrtgWH+eq2gSP7XNzc7oY=; b=Y8BAfpj76R+MDT/6foepOxgvzt
        IPptDrXgT03jFg338YE/YMoqkpchzNp5UbvfQyaWoGUOyLmXEbgUzC11At2DoBtmJLkEcxybyAaiF
        ZmfsGNZCKALYNd6hO/cwj4ZKffSqVBp0tIeehTYCNUwek9hU3Y4ATTg3H7k43fCSI4bEZdDJ5hHjX
        vQYCJb+9okM1ADybbgoCsp7eJz30ItK9StRHfaqFdR2xS4kidlAPPj6BtSxSA2l5Q7qLWzwnOg7dS
        gX4yskhyoPFXkdpvJiOitQTmegIIGUfKgibhSX2prjVrl77alne65DxYuiGzYXn8Gs4ALCELK6Kb8
        Cpb9IFMA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39200 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pjOwp-00037r-1M; Mon, 03 Apr 2023 19:30:31 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pjOwo-00Fmku-Ef; Mon, 03 Apr 2023 19:30:30 +0100
In-Reply-To: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
References: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Marek Beh__n <kabel@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 3/5] net: mvneta: use buf->type to determine
 whether to dma-unmap
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pjOwo-00Fmku-Ef@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 03 Apr 2023 19:30:30 +0100
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we use a different buffer type for TSO headers, we can use
buf->type to determine whether the original buffer was DMA-mapped or
not. The rules are:

	MVNETA_TYPE_XDP_TX - from a DMA pool, no unmap is required
	MVNETA_TYPE_XDP_NDO - dma_map_single()'d
	MVNETA_TYPE_SKB - normal skbuff, dma_map_single()'d
	MVNETA_TYPE_TSO - from the TSO buffer area

This means we only need to call dma_unmap_single() on the XDP_NDO and
SKB types of buffer, and we no longer need the private IS_TSO_HEADER()
which relies on the TSO region being contiguously allocated.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c05649f33d18..c23d75af65ee 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -364,10 +364,6 @@
 			 MVNETA_SKB_HEADROOM))
 #define MVNETA_MAX_RX_BUF_SIZE	(PAGE_SIZE - MVNETA_SKB_PAD)
 
-#define IS_TSO_HEADER(txq, addr) \
-	((addr >= txq->tso_hdrs_phys) && \
-	 (addr < txq->tso_hdrs_phys + txq->size * TSO_HEADER_SIZE))
-
 #define MVNETA_RX_GET_BM_POOL_ID(rxd) \
 	(((rxd)->status & MVNETA_RXD_BM_POOL_MASK) >> MVNETA_RXD_BM_POOL_SHIFT)
 
@@ -1879,8 +1875,8 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 
 		mvneta_txq_inc_get(txq);
 
-		if (!IS_TSO_HEADER(txq, tx_desc->buf_phys_addr) &&
-		    buf->type != MVNETA_TYPE_XDP_TX)
+		if (buf->type == MVNETA_TYPE_XDP_NDO ||
+		    buf->type == MVNETA_TYPE_SKB)
 			dma_unmap_single(pp->dev->dev.parent,
 					 tx_desc->buf_phys_addr,
 					 tx_desc->data_size, DMA_TO_DEVICE);
@@ -2728,8 +2724,9 @@ static void mvneta_release_descs(struct mvneta_port *pp,
 
 	for (i = num; i >= 0; i--) {
 		struct mvneta_tx_desc *tx_desc = txq->descs + desc_idx;
+		struct mvneta_tx_buf *buf = &txq->buf[desc_idx];
 
-		if (!IS_TSO_HEADER(txq, tx_desc->buf_phys_addr))
+		if (buf->type == MVNETA_TYPE_SKB)
 			dma_unmap_single(pp->dev->dev.parent,
 					 tx_desc->buf_phys_addr,
 					 tx_desc->data_size,
-- 
2.30.2


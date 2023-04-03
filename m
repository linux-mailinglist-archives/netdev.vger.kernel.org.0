Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798C56D5065
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbjDCSaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbjDCSah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:30:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C8B2726
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 11:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EefD5qwU3UPbG/EwSXuG3ZZgfmAHJ7ledgibEg6garQ=; b=dTIzmDynMk58njH7wq1NgvHvtm
        2tYhfEr7jGcIfhuZ/6IAd5OZ/OzH4ixVygOg+LHu3Qg52X8hj/pg94M0qVlcYsZ2CJCjc8zAEMGRd
        Bou20zVQtb3qgdFWQh1TdjArqWAGwo5J4BbHYXnzJrmOck5F+tw3GLN0ijNdd9v9yXILMuSQasTlM
        77Rvf8LJGsbY2ehVZREdbrii56eWSUH1Sd9KkDudoFhxLog2LeDBq5DEtdBptXnLSt52HXVxuPI2O
        Rkz5irj1Jgo7plZ5pm3XuOxpi6N01goS+TuBXtoAGMkpLCTiEBC9zVhsBiTEEE4CN0d1Qj1vsUPrl
        T1vB6Qqw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39194 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pjOwj-00037f-UZ; Mon, 03 Apr 2023 19:30:25 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pjOwj-00Fmko-Aw; Mon, 03 Apr 2023 19:30:25 +0100
In-Reply-To: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
References: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Marek Beh__n <kabel@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 2/5] net: mvneta: mark mapped and tso buffers
 separately
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pjOwj-00Fmko-Aw@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 03 Apr 2023 19:30:25 +0100
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark dma-mapped skbs and TSO buffers separately, so we can use
buf->type to identify their differences.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 62400ff61e34..c05649f33d18 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -638,6 +638,7 @@ struct mvneta_rx_desc {
 #endif
 
 enum mvneta_tx_buf_type {
+	MVNETA_TYPE_TSO,
 	MVNETA_TYPE_SKB,
 	MVNETA_TYPE_XDP_TX,
 	MVNETA_TYPE_XDP_NDO,
@@ -1883,7 +1884,8 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 			dma_unmap_single(pp->dev->dev.parent,
 					 tx_desc->buf_phys_addr,
 					 tx_desc->data_size, DMA_TO_DEVICE);
-		if (buf->type == MVNETA_TYPE_SKB && buf->skb) {
+		if ((buf->type == MVNETA_TYPE_TSO ||
+		     buf->type == MVNETA_TYPE_SKB) && buf->skb) {
 			bytes_compl += buf->skb->len;
 			pkts_compl++;
 			dev_kfree_skb_any(buf->skb);
@@ -2674,7 +2676,7 @@ mvneta_tso_put_hdr(struct sk_buff *skb, struct mvneta_tx_queue *txq)
 	tx_desc->command |= MVNETA_TXD_F_DESC;
 	tx_desc->buf_phys_addr = txq->tso_hdrs_phys +
 				 txq->txq_put_index * TSO_HEADER_SIZE;
-	buf->type = MVNETA_TYPE_SKB;
+	buf->type = MVNETA_TYPE_TSO;
 	buf->skb = NULL;
 
 	mvneta_txq_inc_put(txq);
-- 
2.30.2


Return-Path: <netdev+bounces-1417-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79C366FDB71
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:16:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BE89281397
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3CD36FD4;
	Wed, 10 May 2023 10:15:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ACA747B
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 10:15:52 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2151BCA
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EefD5qwU3UPbG/EwSXuG3ZZgfmAHJ7ledgibEg6garQ=; b=gCvyRNxCMxMtXnAEgn6923vjw6
	bVabOcv3fLHkXCyGIOHRO2DOqJW1hSLqc9yXUCHk5Q9K63Stt+F4wcdeDEWpqVJwW4mziTb0hxfN9
	sNBBx6DuTcXNu1OZF6AQow7cXpgNBfcVpyqLGi15dbESeysDoPIgN/iMXj4LdlZ3MvunEG0810ca0
	a8eRyHV9dvnNfQ8teGNlCxydGw9cUuuHx+6CpmTZtKoHeQOF9r1T65taAixQQEFR0dNMoc08FgsCk
	eTJdfqLCN+caLgdEZNzqdLE0ev2V894gOVEVZbBkD4wTgbzk6xkMEB5gjty49t1jj4Wt5rO/Pn8IN
	+iOKyMnw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42492 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pwgrM-0004ji-P3; Wed, 10 May 2023 11:15:48 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pwgrM-001XDs-3b; Wed, 10 May 2023 11:15:48 +0100
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
Subject: [PATCH net-next 2/5] net: mvneta: mark mapped and tso buffers
 separately
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pwgrM-001XDs-3b@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 10 May 2023 11:15:48 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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



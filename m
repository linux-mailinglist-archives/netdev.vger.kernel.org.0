Return-Path: <netdev+bounces-1419-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E5F6FDB77
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:16:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D396281285
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC7DD7471;
	Wed, 10 May 2023 10:16:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18416AB7
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 10:16:02 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606FB1BCA
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Sjr4ySQNhN1pEbw8FT1Hl/jwt1TU2CnCDIC2AL16IRA=; b=KWicZGEskJ7aDhfbIDaAFBRC36
	gMAI+2nr2Ab8ZCQ/DYUYZn0lNI5t3b5nykZ8mv2BGp3pjlzIhGfncPbcsUALUCVH5i4u8BDpYIxHa
	9cCz5uG0mVVqkENbYb4bWyx5dDSH8Zpn2cua8ErgFXH1fFtrulb5Ly6bq2C0ue+XqhdXpnrLsgw+e
	KbPW7S3AcRUpnpklxNMPsQ0zgPSejg48ciUVxNlcHNnD+FktoKbwF+9JrXKQMciznTjV1mIAC4Dw5
	6zRsbtrPqvwqLa+MITebDLr6wTmnQQshiirHCMFhqYlCDgX5jJW3BNbS2dKMr73Houu7X8Dddm9TR
	6R8sgG5w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44680 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pwgrX-0004k9-1j; Wed, 10 May 2023 11:15:59 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pwgrW-001XE4-DB; Wed, 10 May 2023 11:15:58 +0100
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
Subject: [PATCH net-next 4/5] net: mvneta: move tso_build_hdr() into
 mvneta_tso_put_hdr()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pwgrW-001XE4-DB@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 10 May 2023 11:15:58 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Move tso_build_hdr() into mvneta_tso_put_hdr() so that all the TSO
header building code is in one place.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c23d75af65ee..bea84e86cf99 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2659,19 +2659,24 @@ static int mvneta_rx_hwbm(struct napi_struct *napi,
 	return rx_done;
 }
 
-static inline void
-mvneta_tso_put_hdr(struct sk_buff *skb, struct mvneta_tx_queue *txq)
+static void mvneta_tso_put_hdr(struct sk_buff *skb, struct mvneta_tx_queue *txq,
+			       struct tso_t *tso, int size, bool is_last)
 {
 	struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
-	int hdr_len = skb_tcp_all_headers(skb);
+	int tso_offset, hdr_len = skb_tcp_all_headers(skb);
 	struct mvneta_tx_desc *tx_desc;
+	char *hdr;
+
+	tso_offset = txq->txq_put_index * TSO_HEADER_SIZE;
+
+	hdr = txq->tso_hdrs + tso_offset;
+	tso_build_hdr(skb, hdr, tso, size, is_last);
 
 	tx_desc = mvneta_txq_next_desc_get(txq);
 	tx_desc->data_size = hdr_len;
 	tx_desc->command = mvneta_skb_tx_csum(skb);
 	tx_desc->command |= MVNETA_TXD_F_DESC;
-	tx_desc->buf_phys_addr = txq->tso_hdrs_phys +
-				 txq->txq_put_index * TSO_HEADER_SIZE;
+	tx_desc->buf_phys_addr = txq->tso_hdrs_phys + tso_offset;
 	buf->type = MVNETA_TYPE_TSO;
 	buf->skb = NULL;
 
@@ -2764,17 +2769,12 @@ static int mvneta_tx_tso(struct sk_buff *skb, struct net_device *dev,
 
 	total_len = skb->len - hdr_len;
 	while (total_len > 0) {
-		char *hdr;
-
 		data_left = min_t(int, skb_shinfo(skb)->gso_size, total_len);
 		total_len -= data_left;
 		desc_count++;
 
 		/* prepare packet headers: MAC + IP + TCP */
-		hdr = txq->tso_hdrs + txq->txq_put_index * TSO_HEADER_SIZE;
-		tso_build_hdr(skb, hdr, &tso, data_left, total_len == 0);
-
-		mvneta_tso_put_hdr(skb, txq);
+		mvneta_tso_put_hdr(skb, txq, &tso, data_left, total_len == 0);
 
 		while (data_left > 0) {
 			int size;
-- 
2.30.2



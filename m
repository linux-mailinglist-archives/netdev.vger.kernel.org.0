Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B5F6D5068
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbjDCSbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233227AbjDCSar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:30:47 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC632D4C
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 11:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Sjr4ySQNhN1pEbw8FT1Hl/jwt1TU2CnCDIC2AL16IRA=; b=2BtQwicPhDkyX5xiYoCryazAsh
        flNyXdzu7m5tpAPc0P//pBwvKJCh0fbSHI3srQACDAd2AAZ3WxZE7tTaI7H4Vm5vhcyaAoaezs0D6
        LBEk14NkvgIl6Yqlnl3ahXGnVEKeF5BW270hQqmuE18dQtq0Mdj5CT6tXG8GUZfCKAh079QTU1mG6
        Q+2SLGpYbt+ryerB7j20Dou9CYxWEBXsyqpcFvm3dldnWH2EVj+gVu3sGszFw8cXBFbfPt+T0FdgB
        vdrEJqUIY+Q7zz3igPbtvPV9O418tb8Ky3VAvnDj9kW54iyVnz4WqOhCgy5AZjL2YeOmIi9LHfulV
        /5xiSSkw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45828 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pjOwu-000383-5R; Mon, 03 Apr 2023 19:30:36 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pjOwt-00Fml0-IJ; Mon, 03 Apr 2023 19:30:35 +0100
In-Reply-To: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
References: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Marek Beh__n <kabel@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 4/5] net: mvneta: move tso_build_hdr() into
 mvneta_tso_put_hdr()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pjOwt-00Fml0-IJ@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 03 Apr 2023 19:30:35 +0100
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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


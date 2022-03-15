Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84DC4DA643
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 00:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352575AbiCOX2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 19:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352540AbiCOX2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 19:28:54 -0400
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AED55779
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 16:27:39 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 22402 invoked from network); 16 Mar 2022 00:27:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1647386855; bh=hJ+qdh3Bw1sIbKkDYuKS6Akrf10RAxifL7o5WrQxLQA=;
          h=From:To:Subject;
          b=LAJXvPpV3Q3gqZWq/RTWWiswTbL/23EoUx2u5590LDo2e59bjxkyVic4WYc1IENUu
           Sq9IAMAg1v56dS8HNKeMu0YRGWfrPPHJ7/8r1X0FDDw+NAxWZGR94QOPbwss/5JkmB
           ZpRskcQvOurOwVGuA1Xrf+XFxDktvZPa4It1bIbc=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <davem@davemloft.net>; 16 Mar 2022 00:27:35 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     davem@davemloft.net, kuba@kernel.org, olek2@wp.pl, jgg@ziepe.ca,
        yangyingliang@huawei.com, arnd@arndb.de, rdunlap@infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: lantiq_etop: add stats support
Date:   Wed, 16 Mar 2022 00:27:33 +0100
Message-Id: <20220315232733.134340-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: e283813718b3eadf1b032ce0390b3a3c
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [IeME]                               
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for software packet and byte counters.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_etop.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 9b6fa27b7daf..9841551796f2 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -145,6 +145,8 @@ ltq_etop_hw_receive(struct ltq_etop_chan *ch)
 	skb_put(skb, len);
 	skb->protocol = eth_type_trans(skb, ch->netdev);
 	netif_receive_skb(skb);
+	ch->netdev->stats.rx_packets++;
+	ch->netdev->stats.rx_bytes += len;
 }
 
 static int
@@ -182,6 +184,8 @@ ltq_etop_poll_tx(struct napi_struct *napi, int budget)
 	spin_lock_irqsave(&priv->lock, flags);
 	while ((ch->dma.desc_base[ch->tx_free].ctl &
 			(LTQ_DMA_OWN | LTQ_DMA_C)) == LTQ_DMA_C) {
+		ch->netdev->stats.tx_packets++;
+		ch->netdev->stats.tx_bytes += ch->skb[ch->tx_free]->len;
 		dev_kfree_skb_any(ch->skb[ch->tx_free]);
 		ch->skb[ch->tx_free] = NULL;
 		memset(&ch->dma.desc_base[ch->tx_free], 0,
-- 
2.30.2


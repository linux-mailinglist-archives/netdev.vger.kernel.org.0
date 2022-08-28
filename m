Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDEC5A3F43
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 21:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiH1TTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 15:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiH1TTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 15:19:43 -0400
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA74022535
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 12:19:41 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 13860 invoked from network); 28 Aug 2022 21:19:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1661714377; bh=ZrQoiF4PtZktmbqwFxVDzhu9JLV8pEzlZx8BlStapHo=;
          h=From:To:Cc:Subject;
          b=SAKf0mUfp/S35tT3eONuCn/2D0SLs8+O09j84qpLkam57Te7fEoLw9Nja6QqH9lXc
           q8Q1et8DC7LpnU+W1RG4CquKDyBMKB9PmjB0b8stlTyS5VmNHRpyuNyAkRsFG/3oai
           vH+JEAVg0AbCSagi22MN6tkD64giSmWzvmiBjbrg=
Received: from ip-137-21.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.21])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 28 Aug 2022 21:19:37 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH net-next v2 1/1] net: lantiq_xrx200: use skb cache
Date:   Sun, 28 Aug 2022 21:19:31 +0200
Message-Id: <20220828191931.4923-2-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220828191931.4923-1-olek2@wp.pl>
References: <20220828191931.4923-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: 638b8202584d0bbbc06835093f283534
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [EaNE]                               
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

napi_build_skb() reuses NAPI skbuff_head cache in order to save some
cycles on freeing/allocating skbuff_heads on every new Rx or completed
Tx.
Use napi_consume_skb() to feed the cache with skbuff_heads of completed
Tx. The budget parameter is added to indicate NAPI context, as a value
of zero can be passed in the case of netpoll.

NAT performance results on BT Home Hub 5A (kernel 5.15.45, mtu 1500):

Fast path (Software Flow Offload):
	Up	Down
Before	702.4	719.3
After	707.3	739.9

Slow path:
	Up	Down
Before	91.8	184.1
After	92.0	185.7

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/ethernet/lantiq_xrx200.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 57f27cc7724e..13899720423f 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -239,7 +239,7 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 		return ret;
 	}
 
-	skb = build_skb(buf, priv->rx_skb_size);
+	skb = napi_build_skb(buf, priv->rx_skb_size);
 	if (!skb) {
 		skb_free_frag(buf);
 		net_dev->stats.rx_dropped++;
@@ -328,7 +328,7 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
 			pkts++;
 			bytes += skb->len;
 			ch->skb[ch->tx_free] = NULL;
-			consume_skb(skb);
+			napi_consume_skb(skb, budget);
 			memset(&ch->dma.desc_base[ch->tx_free], 0,
 			       sizeof(struct ltq_dma_desc));
 			ch->tx_free++;
-- 
2.30.2


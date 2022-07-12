Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7810572276
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 20:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiGLSVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 14:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiGLSVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 14:21:50 -0400
X-Greylist: delayed 399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Jul 2022 11:21:48 PDT
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4610D087C
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 11:21:48 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 27443 invoked from network); 12 Jul 2022 20:15:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1657649702; bh=zGkagB45h+s+I2oFUucK24FU3BjdVGg3GYTCxnIGezE=;
          h=From:To:Cc:Subject;
          b=o1bet5Hjnn0aqq3Wf0z/ZH3HXfE2Xj+pzqtyjG//4/exfms6yV4A/mFZeVOizex9r
           RBT8l+GrjExUMdUclzFxj73DxMrOfT55ho8/8RN4qQbwBZhmpwRL/jiLH53QFuRUq6
           B00mNhoVkFxJ7u83uqz5EO0+DtmtDA2oH75jYcFs=
Received: from ip-137-21.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.21])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 12 Jul 2022 20:15:02 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH net-next] net: lantiq_xrx200: use skb cache
Date:   Tue, 12 Jul 2022 20:14:56 +0200
Message-Id: <20220712181456.3398-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: b2a8cc528473dba19639df9c4c0d0321
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [YZP0]                               
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
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
---
 drivers/net/ethernet/lantiq_xrx200.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 5edb68a8aab1..83e07404803f 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -238,7 +238,7 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 		return ret;
 	}
 
-	skb = build_skb(buf, priv->rx_skb_size);
+	skb = napi_build_skb(buf, priv->rx_skb_size);
 	skb_reserve(skb, NET_SKB_PAD);
 	skb_put(skb, len);
 
@@ -321,7 +321,7 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
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


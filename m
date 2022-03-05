Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D404CE4A0
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 12:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbiCEL2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 06:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbiCEL2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 06:28:20 -0500
X-Greylist: delayed 399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 05 Mar 2022 03:27:27 PST
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F50457BB
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 03:27:26 -0800 (PST)
Received: (wp-smtpd smtp.wp.pl 14111 invoked from network); 5 Mar 2022 12:20:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1646479242; bh=6AbNWZDZCiF9jH5VR5VSePUPgG0zk15w1zGXl48ihEA=;
          h=From:To:Cc:Subject;
          b=puyzONj/lzworgWrJ+9XQb6eehA+uMpq3bf/dGBBOInrxXDQga09PndMyGOCxuy4a
           4GcJUfWRQypytZTXLmh3BsGslZNXr24zD4TzEI/UmvCV4jQ7/zMvlwTx8mblT94Cd2
           LTc1ftUat/D8/Svzfo5yZeivO9N1/elDKjBkHB2I=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 5 Mar 2022 12:20:42 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        olek2@wp.pl, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] net: lantiq_xrx200: fix use after free bug
Date:   Sat,  5 Mar 2022 12:20:39 +0100
Message-Id: <20220305112039.3989-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 1b6ae7147e494104fbc28afc62fdc88d
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [0aME]                               
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb->len field is read after the packet is sent to the network
stack. In the meantime, skb can be freed. This patch fixes this bug.

Fixes: c3e6b2c35b34 ("net: lantiq_xrx200: add ingress SG DMA support")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_xrx200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 41d11137cde0..5712c3e94be8 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -260,9 +260,9 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 
 	if (ctl & LTQ_DMA_EOP) {
 		ch->skb_head->protocol = eth_type_trans(ch->skb_head, net_dev);
-		netif_receive_skb(ch->skb_head);
 		net_dev->stats.rx_packets++;
 		net_dev->stats.rx_bytes += ch->skb_head->len;
+		netif_receive_skb(ch->skb_head);
 		ch->skb_head = NULL;
 		ch->skb_tail = NULL;
 		ret = XRX200_DMA_PACKET_COMPLETE;
-- 
2.30.2


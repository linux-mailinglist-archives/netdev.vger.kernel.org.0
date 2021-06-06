Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE3D39D12C
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 22:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhFFUIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 16:08:31 -0400
Received: from mx3.wp.pl ([212.77.101.10]:42238 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhFFUIa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Jun 2021 16:08:30 -0400
Received: (wp-smtpd smtp.wp.pl 19935 invoked from network); 6 Jun 2021 22:06:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1623009998; bh=hQhPaaBVb++b0UTU9Rraa6ZhDCCVr/iAER3n3txOb2w=;
          h=From:To:Cc:Subject;
          b=bc32+VPrlLz28hAoAr/gDwfWa4O+1iRtdkAtsLo9EyCqbQcEiNlE4wvHNC2SbCtdy
           hFFRhn14TlwEdgw3uKokTspXfJiVr3laIEunnvCcpbBpJ7Y8Uch6dZpWjKWCj1byBl
           czWq7tJsJ/7ZK7CFT2W6H/pPGoSXJ7udqmJV5Dwc=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 6 Jun 2021 22:06:38 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH net] lantiq: net: fix duplicated skb in rx descriptor ring
Date:   Sun,  6 Jun 2021 22:05:51 +0200
Message-Id: <20210606200551.1609521-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: 8a3beb05101d63dc280b56f4a59e28da
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [QYOk]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit didn't fix the bug properly. By mistake, it replaces
the pointer of the next skb in the descriptor ring instead of the current
one. As a result, the two descriptors are assigned the same SKB. The error
is seen during the iperf test when skb_put tries to insert a second packet
and exceeds the available buffer.

Fixes: c7718ee96dbc ("net: lantiq: fix memory corruption in RX ring ")

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_xrx200.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 36dc3e5f6218..e710f83b3700 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -193,17 +193,18 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 	int ret;
 
 	ret = xrx200_alloc_skb(ch);
-
-	ch->dma.desc++;
-	ch->dma.desc %= LTQ_DESC_NUM;
-
 	if (ret) {
 		ch->skb[ch->dma.desc] = skb;
 		net_dev->stats.rx_dropped++;
+		ch->dma.desc++;
+		ch->dma.desc %= LTQ_DESC_NUM;
 		netdev_err(net_dev, "failed to allocate new rx buffer\n");
 		return ret;
 	}
 
+	ch->dma.desc++;
+	ch->dma.desc %= LTQ_DESC_NUM;
+
 	skb_put(skb, len);
 	skb->protocol = eth_type_trans(skb, net_dev);
 	netif_receive_skb(skb);
-- 
2.30.2


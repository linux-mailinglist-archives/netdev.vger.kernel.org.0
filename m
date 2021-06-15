Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2583A8A64
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 22:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhFOUpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 16:45:47 -0400
Received: from mx3.wp.pl ([212.77.101.10]:41825 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhFOUpr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 16:45:47 -0400
Received: (wp-smtpd smtp.wp.pl 21092 invoked from network); 15 Jun 2021 22:43:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1623789819; bh=7qxB1UC+JQHGmbdNCvRzyTdJ8RbUSHAbMAaj0X1ty0Q=;
          h=From:To:Subject;
          b=pjdNE1yZtMjOl0wTHpt3T1Qm/7TmTlI28yNLoAlxvSUbbEViTmmWeUNfF94sSFYbN
           5VmHtnxYIRl9MKJWPQ0kU/A2+UAoq8jBvn4y2uw1iFtMzAzdPHHgbIW/kUn9JiZaZ0
           eJIgBR7if8UJD+lOSw2XngRQcXvtGv1LuCrXWI1g=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 15 Jun 2021 22:43:39 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        olek2@wp.pl, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] lantiq: net: fix duplicated skb in rx descriptor ring
Date:   Tue, 15 Jun 2021 22:42:57 +0200
Message-Id: <20210615204257.217653-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: a41809a775b9d5322760c2a0deb1c589
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [wQNk]                               
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
 drivers/net/ethernet/lantiq_xrx200.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 36dc3e5f6218..f92046dff227 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -154,6 +154,7 @@ static int xrx200_close(struct net_device *net_dev)
 
 static int xrx200_alloc_skb(struct xrx200_chan *ch)
 {
+	struct sk_buff *skb = ch->skb[ch->dma.desc];
 	dma_addr_t mapping;
 	int ret = 0;
 
@@ -168,6 +169,7 @@ static int xrx200_alloc_skb(struct xrx200_chan *ch)
 				 XRX200_DMA_DATA_LEN, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(ch->priv->dev, mapping))) {
 		dev_kfree_skb_any(ch->skb[ch->dma.desc]);
+		ch->skb[ch->dma.desc] = skb;
 		ret = -ENOMEM;
 		goto skip;
 	}
@@ -198,7 +200,6 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 	ch->dma.desc %= LTQ_DESC_NUM;
 
 	if (ret) {
-		ch->skb[ch->dma.desc] = skb;
 		net_dev->stats.rx_dropped++;
 		netdev_err(net_dev, "failed to allocate new rx buffer\n");
 		return ret;
-- 
2.30.2


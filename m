Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5F848018E
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 17:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhL0QWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 11:22:23 -0500
Received: from mx4.wp.pl ([212.77.101.12]:38973 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhL0QWW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 11:22:22 -0500
Received: (wp-smtpd smtp.wp.pl 7641 invoked from network); 27 Dec 2021 17:22:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1640622137; bh=5NuwZcnvSPWI2DMukdv3htJgjFsVJtdgRHVOPS0OXvs=;
          h=From:To:Cc:Subject;
          b=DnqfchjM5ziZqTxnJPg2/y4Cv4jN24PmMN6tXZlLUkd/P/6AO+qC3LUv87wUB7YpP
           leQtQJv4ZRFyu+mkrJLYDotD3Zk34+UZx4cPlvG+xV8rdTAfNMSAxpoY7Ev4SPBGz7
           jjUJEUKqeI1QZrnwrNppUhY6L5uW9cjnsJVkvgoo=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 27 Dec 2021 17:22:17 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH net] net: lantiq_xrx200: fix statistics of received bytes
Date:   Mon, 27 Dec 2021 17:22:03 +0100
Message-Id: <20211227162203.5378-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: 4fd73e0ec542d1bfd5039fe03b4f7b1f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [geN0]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Received frames have FCS truncated. There is no need
to subtract FCS length from the statistics.

Fixes: fe1a56420cf2 ("net: lantiq: Add Lantiq / Intel VRX200 Ethernet driver")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_xrx200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 96bd6f2b21ed..80bfaf2fec92 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -224,7 +224,7 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 	skb->protocol = eth_type_trans(skb, net_dev);
 	netif_receive_skb(skb);
 	net_dev->stats.rx_packets++;
-	net_dev->stats.rx_bytes += len - ETH_FCS_LEN;
+	net_dev->stats.rx_bytes += len;
 
 	return 0;
 }
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42FF1D2368
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 02:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732982AbgENAI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 20:08:27 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:45154 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732943AbgENAIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 20:08:20 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49MsM50cqpz1rqfr;
        Thu, 14 May 2020 02:08:17 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49MsM50Nmvz1qql9;
        Thu, 14 May 2020 02:08:17 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id DVECI9z0TOCr; Thu, 14 May 2020 02:08:16 +0200 (CEST)
X-Auth-Info: 131G/r5MZP4UB6HVD4W532WdCWEtSRFr8bOrSKomjes=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 14 May 2020 02:08:16 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V5 11/19] net: ks8851: Factor out SKB receive function
Date:   Thu, 14 May 2020 02:07:39 +0200
Message-Id: <20200514000747.159320-12-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200514000747.159320-1-marex@denx.de>
References: <20200514000747.159320-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out this netif_rx_ni(), so it could be overridden by the parallel
bus variant of the KS8851 driver.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V3: New patch
V4: No change
V5: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index b05cb9e0c5cd..01b00c81a928 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -465,6 +465,15 @@ static void ks8851_dbg_dumpkkt(struct ks8851_net *ks, u8 *rxpkt)
 		   rxpkt[12], rxpkt[13], rxpkt[14], rxpkt[15]);
 }
 
+/**
+ * ks8851_rx_skb - receive skbuff
+ * @skb: The skbuff
+ */
+static void ks8851_rx_skb(struct sk_buff *skb)
+{
+	netif_rx_ni(skb);
+}
+
 /**
  * ks8851_rx_pkts - receive packets from the host
  * @ks: The device information.
@@ -533,7 +542,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 					ks8851_dbg_dumpkkt(ks, rxpkt);
 
 				skb->protocol = eth_type_trans(skb, ks->netdev);
-				netif_rx_ni(skb);
+				ks8851_rx_skb(skb);
 
 				ks->netdev->stats.rx_packets++;
 				ks->netdev->stats.rx_bytes += rxlen;
-- 
2.25.1


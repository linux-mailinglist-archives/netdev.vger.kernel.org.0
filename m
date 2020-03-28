Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9218D196278
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 01:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgC1AcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 20:32:21 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:48256 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbgC1AcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 20:32:18 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48q06T5fwpz1qrGL;
        Sat, 28 Mar 2020 01:32:17 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48q06T5Vcwz1qv4G;
        Sat, 28 Mar 2020 01:32:17 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id nCKKHT2z9Bla; Sat, 28 Mar 2020 01:32:16 +0100 (CET)
X-Auth-Info: ZWwTWbbjPL52C5ZVOgtsPrZliYD1EuAPZ+hqFjTtgco=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 28 Mar 2020 01:32:16 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V3 11/18] net: ks8851: Factor out SKB receive function
Date:   Sat, 28 Mar 2020 01:31:41 +0100
Message-Id: <20200328003148.498021-12-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200328003148.498021-1-marex@denx.de>
References: <20200328003148.498021-1-marex@denx.de>
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
---
 drivers/net/ethernet/micrel/ks8851.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 7a91d30472f2..fe09795265b9 100644
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


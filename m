Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCDC1E6EA8
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437069AbgE1WXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:23:08 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:55249 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437006AbgE1WWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:22:22 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49Y2Ht1gHFz1qrfx;
        Fri, 29 May 2020 00:22:18 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49Y2Ht1RDjz1qsqF;
        Fri, 29 May 2020 00:22:18 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id nfgzdNiaCe4B; Fri, 29 May 2020 00:22:17 +0200 (CEST)
X-Auth-Info: ex35VYAQOST0/hq+n2R3YKYHrCT9pxKVQfZhSDG8BHw=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 29 May 2020 00:22:17 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V7 11/19] net: ks8851: Factor out SKB receive function
Date:   Fri, 29 May 2020 00:21:38 +0200
Message-Id: <20200528222146.348805-12-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528222146.348805-1-marex@denx.de>
References: <20200528222146.348805-1-marex@denx.de>
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
V6: No change
V7: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 053d6d085539..087d2a39cdce 100644
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


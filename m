Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1003664A6
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 06:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbhDUExl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 00:53:41 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:2198 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230516AbhDUExh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 00:53:37 -0400
X-IronPort-AV: E=Sophos;i="5.82,238,1613401200"; 
   d="scan'208";a="78738707"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 21 Apr 2021 13:53:04 +0900
Received: from localhost.localdomain (unknown [10.166.14.185])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 2C5CC4006191;
        Wed, 21 Apr 2021 13:53:04 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     sergei.shtylyov@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH] net: renesas: ravb: Fix a stuck issue when a lot of frames are received
Date:   Wed, 21 Apr 2021 13:52:46 +0900
Message-Id: <20210421045246.215779-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a lot of frames were received in the short term, the driver
caused a stuck of receiving until a new frame was received. For example,
the following command from other device could cause this issue.

    $ sudo ping -f -l 1000 -c 1000 <this driver's ipaddress>

The previous code always cleared the interrupt flag of RX but checks
the interrupt flags in ravb_poll(). So, ravb_poll() could not call
ravb_rx() in the next time until a new RX frame was received if
ravb_rx() returned true. To fix the issue, always calls ravb_rx()
regardless the interrupt flags condition.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 35 ++++++++----------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index eb0c03bdb12d..cad57d58d764 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -911,31 +911,20 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	int q = napi - priv->napi;
 	int mask = BIT(q);
 	int quota = budget;
-	u32 ris0, tis;
 
-	for (;;) {
-		tis = ravb_read(ndev, TIS);
-		ris0 = ravb_read(ndev, RIS0);
-		if (!((ris0 & mask) || (tis & mask)))
-			break;
+	/* Processing RX Descriptor Ring */
+	/* Clear RX interrupt */
+	ravb_write(ndev, ~(mask | RIS0_RESERVED), RIS0);
+	if (ravb_rx(ndev, &quota, q))
+		goto out;
 
-		/* Processing RX Descriptor Ring */
-		if (ris0 & mask) {
-			/* Clear RX interrupt */
-			ravb_write(ndev, ~(mask | RIS0_RESERVED), RIS0);
-			if (ravb_rx(ndev, &quota, q))
-				goto out;
-		}
-		/* Processing TX Descriptor Ring */
-		if (tis & mask) {
-			spin_lock_irqsave(&priv->lock, flags);
-			/* Clear TX interrupt */
-			ravb_write(ndev, ~(mask | TIS_RESERVED), TIS);
-			ravb_tx_free(ndev, q, true);
-			netif_wake_subqueue(ndev, q);
-			spin_unlock_irqrestore(&priv->lock, flags);
-		}
-	}
+	/* Processing RX Descriptor Ring */
+	spin_lock_irqsave(&priv->lock, flags);
+	/* Clear TX interrupt */
+	ravb_write(ndev, ~(mask | TIS_RESERVED), TIS);
+	ravb_tx_free(ndev, q, true);
+	netif_wake_subqueue(ndev, q);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	napi_complete(napi);
 
-- 
2.25.1


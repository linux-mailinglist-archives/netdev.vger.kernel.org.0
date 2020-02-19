Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9821642AA
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 11:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgBSKxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 05:53:51 -0500
Received: from first.geanix.com ([116.203.34.67]:57102 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgBSKxv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 05:53:51 -0500
Received: from localhost (_gateway [172.20.0.1])
        by first.geanix.com (Postfix) with ESMTPSA id 1C78BC002E;
        Wed, 19 Feb 2020 10:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582109629; bh=KvmUZ7RpfqddUx8uLthfjCMTy9g+ZYpZDHIMYzR1KoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=QDWUVQDTAquUov6+PXtSzsOfsH4R3+bYJ3ZFFOC28FYbLNwgyFlsz7nSieXIiZObI
         6RS5Cq28tPzIwWfbHZgOkd/XyTSlCRafR7TkPqfGeqwDLdmzmY3nyS3CqkX3Q9PJhU
         41iR4DuU8ZKbDxt5N1tCKXPCncY6kOy4RZGxwdCWezT2xTMbB9JFcf58WjgZZVSiu0
         PhJW2zacPec6lzoZSjXu+5GzHFR4kDgIjvxC8bUA1n3K5gZSROG0Ay/8sJ1WvKJn2u
         kFX78mjFRB31JsHAvVbmiSBDVwE5dJFSitJCWTyiKjyr3uggxs94cQnuO3kc8Bb+E4
         oHuj6tj7RiLWw==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH net 1/4] net: ll_temac: Fix race condition causing TX hang
Date:   Wed, 19 Feb 2020 11:53:48 +0100
Message-Id: <c93e0f5ef92d2b17c04e256e32460e9dee1107e8.1582108989.git.esben@geanix.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <cover.1582108989.git.esben@geanix.com>
References: <cover.1582108989.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=4.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=disabled
        version=3.4.3
X-Spam-Checker-Version: SpamAssassin 3.4.3 (2019-12-06) on eb9da72b0f73
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible that the interrupt handler fires and frees up space in
the TX ring in between checking for sufficient TX ring space and
stopping the TX queue in temac_start_xmit. If this happens, the
queue wake from the interrupt handler will occur before the queue is
stopped, causing a lost wakeup and the adapter's transmit hanging.

To avoid this, after stopping the queue, check again whether there is
sufficient space in the TX ring. If so, wake up the queue again.

This is a port of the similar fix in axienet driver,
commit 7de44285c1f6 ("net: axienet: Fix race condition causing TX hang").

Fixes: 23ecc4bde21f ("net: ll_temac: fix checksum offload logic")
Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 6f11f52c9a9e..996004ef8bd4 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -788,6 +788,9 @@ static void temac_start_xmit_done(struct net_device *ndev)
 		stat = be32_to_cpu(cur_p->app0);
 	}
 
+	/* Matches barrier in temac_start_xmit */
+	smp_mb();
+
 	netif_wake_queue(ndev);
 }
 
@@ -830,9 +833,19 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 
 	if (temac_check_tx_bd_space(lp, num_frag + 1)) {
-		if (!netif_queue_stopped(ndev))
-			netif_stop_queue(ndev);
-		return NETDEV_TX_BUSY;
+		if (netif_queue_stopped(ndev))
+			return NETDEV_TX_BUSY;
+
+		netif_stop_queue(ndev);
+
+		/* Matches barrier in temac_start_xmit_done */
+		smp_mb();
+
+		/* Space might have just been freed - check again */
+		if (temac_check_tx_bd_space(lp, num_frag))
+			return NETDEV_TX_BUSY;
+
+		netif_wake_queue(ndev);
 	}
 
 	cur_p->app0 = 0;
-- 
2.25.0


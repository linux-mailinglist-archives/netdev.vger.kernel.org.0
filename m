Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3264A3AC933
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhFRKzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:55:17 -0400
Received: from first.geanix.com ([116.203.34.67]:53910 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232723AbhFRKyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 06:54:47 -0400
Received: from localhost (80-62-117-165-mobile.dk.customer.tdc.net [80.62.117.165])
        by first.geanix.com (Postfix) with ESMTPSA id D0211C7E;
        Fri, 18 Jun 2021 10:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1624013555; bh=WHjjMsx6IxEstOT3uD0IXWYEPbXsz31jeGej/RXoWTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=QTkZesMk+VQJ/TaLOlvwsOqRex89lIIwouZEMP09F7AHOMUGQhl4C0mzkW3pLpUtt
         q2IMxe5iILEwaD6XxAJQ+1n3wbelxPfnbVWjXjXVhaCAR7kpgRm4t2RqOtVC9OiJmH
         nR8vDtMYb7kmibBFvJ45o96LGzb+edzEleyi5hfCJABUQPriAKp8B8BdFx1ezQOOxx
         G9U3S7ZFcp+C7/kyyhwGcD2P5qwap31fb2dvQmLHFgan16OhlbUjZ0aqSd8mSBIY7n
         zDYpRSthHu7NF8QIWO0I3zurTKJXBWQfpOsqICettfTCdu3+FGj1L6lBHEIuL/45jB
         Hs08rC0+4lWIA==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Lunn <andrew@lunn.ch>, Wang Hai <wanghai38@huawei.com>,
        Michael Walle <michael@walle.cc>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] net: ll_temac: Fix TX BD buffer overwrite
Date:   Fri, 18 Jun 2021 12:52:33 +0200
Message-Id: <af756a6fda027c300f38f73cad133450f7dd1636.1624013456.git.esben@geanix.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <d9200a5023973fbe372a2d51dc4e500400450ecd.1624013456.git.esben@geanix.com>
References: <d9200a5023973fbe372a2d51dc4e500400450ecd.1624013456.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 93bd6fdb21b5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just as the initial check, we need to ensure num_frag+1 buffers available,
as that is the number of buffers we are going to use.

This fixes a buffer overflow, which might be seen during heavy network
load. Complete lockup of TEMAC was reproducible within about 10 minutes of
a particular load.

Fixes: 84823ff80f74 ("net: ll_temac: Fix race condition causing TX hang")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 9797aa3221d1..cc482ee36501 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -861,7 +861,7 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		smp_mb();
 
 		/* Space might have just been freed - check again */
-		if (temac_check_tx_bd_space(lp, num_frag))
+		if (temac_check_tx_bd_space(lp, num_frag + 1))
 			return NETDEV_TX_BUSY;
 
 		netif_wake_queue(ndev);
-- 
2.32.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D93A33DB
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 11:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbfH3J0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 05:26:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:41818 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728255AbfH3JZ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 05:25:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 748DCB0F2;
        Fri, 30 Aug 2019 09:25:58 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 net-next 15/15] net: sgi: ioc3-eth: no need to stop queue set_multicast_list
Date:   Fri, 30 Aug 2019 11:25:38 +0200
Message-Id: <20190830092539.24550-16-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190830092539.24550-1-tbogendoerfer@suse.de>
References: <20190830092539.24550-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netif_stop_queue()/netif_wake_qeue() aren't needed for changing
multicast filters.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 963ed0f9787c..deb636d653f3 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -1627,8 +1627,6 @@ static void ioc3_set_multicast_list(struct net_device *dev)
 	struct netdev_hw_addr *ha;
 	u64 ehar = 0;
 
-	netif_stop_queue(dev);				/* Lock out others. */
-
 	spin_lock_irq(&ip->ioc3_lock);
 
 	if (dev->flags & IFF_PROMISC) {			/* Set promiscuous.  */
@@ -1660,8 +1658,6 @@ static void ioc3_set_multicast_list(struct net_device *dev)
 	}
 
 	spin_unlock_irq(&ip->ioc3_lock);
-
-	netif_wake_queue(dev);			/* Let us get going again. */
 }
 
 module_pci_driver(ioc3_driver);
-- 
2.13.7


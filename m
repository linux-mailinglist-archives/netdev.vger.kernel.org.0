Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E1EA0425
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfH1OEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:04:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:39688 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726738AbfH1ODc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:03:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4B755B64D;
        Wed, 28 Aug 2019 14:03:31 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 07/15] net: sgi: ioc3-eth: separate tx and rx ring handling
Date:   Wed, 28 Aug 2019 16:03:06 +0200
Message-Id: <20190828140315.17048-8-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190828140315.17048-1-tbogendoerfer@suse.de>
References: <20190828140315.17048-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After allocation of descriptor memory is now done once in probe
handling of tx ring is completely done by ioc3_clean_tx_ring. So
we remove the remaining tx ring actions out of ioc3_alloc_rings
and ioc3_free_rings and rename it to ioc3_[alloc|free]_rx_bufs
to better describe what they are doing.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 39631e067b71..6c79be3098c3 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -778,13 +778,11 @@ static inline void ioc3_clean_tx_ring(struct ioc3_private *ip)
 	ip->tx_ci = 0;
 }
 
-static void ioc3_free_rings(struct ioc3_private *ip)
+static void ioc3_free_rx_bufs(struct ioc3_private *ip)
 {
 	struct sk_buff *skb;
 	int rx_entry, n_entry;
 
-	ioc3_clean_tx_ring(ip);
-
 	n_entry = ip->rx_ci;
 	rx_entry = ip->rx_pi;
 
@@ -797,7 +795,7 @@ static void ioc3_free_rings(struct ioc3_private *ip)
 	}
 }
 
-static void ioc3_alloc_rings(struct net_device *dev)
+static void ioc3_alloc_rx_bufs(struct net_device *dev)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
 	struct ioc3_erxbuf *rxb;
@@ -826,9 +824,6 @@ static void ioc3_alloc_rings(struct net_device *dev)
 	}
 	ip->rx_ci = 0;
 	ip->rx_pi = RX_BUFFS;
-
-	ip->tx_pi = 0;
-	ip->tx_ci = 0;
 }
 
 static void ioc3_init_rings(struct net_device *dev)
@@ -837,8 +832,8 @@ static void ioc3_init_rings(struct net_device *dev)
 	struct ioc3_ethregs *regs = ip->regs;
 	unsigned long ring;
 
-	ioc3_free_rings(ip);
-	ioc3_alloc_rings(dev);
+	ioc3_free_rx_bufs(ip);
+	ioc3_alloc_rx_bufs(dev);
 
 	ioc3_clean_tx_ring(ip);
 
@@ -964,7 +959,9 @@ static int ioc3_close(struct net_device *dev)
 	ioc3_stop(ip);
 	free_irq(dev->irq, dev);
 
-	ioc3_free_rings(ip);
+	ioc3_free_rx_bufs(ip);
+	ioc3_clean_tx_ring(ip);
+
 	return 0;
 }
 
@@ -1265,7 +1262,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_stop:
 	ioc3_stop(ip);
 	del_timer_sync(&ip->ioc3_timer);
-	ioc3_free_rings(ip);
+	ioc3_free_rx_bufs(ip);
 	kfree(ip->rxr);
 	kfree(ip->txr);
 out_res:
-- 
2.13.7


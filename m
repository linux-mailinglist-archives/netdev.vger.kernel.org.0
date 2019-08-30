Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B47A2A33ED
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 11:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbfH3J1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 05:27:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:41806 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728153AbfH3JZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 05:25:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4C633AF98;
        Fri, 30 Aug 2019 09:25:55 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 net-next 07/15] net: sgi: ioc3-eth: separate tx and rx ring handling
Date:   Fri, 30 Aug 2019 11:25:30 +0200
Message-Id: <20190830092539.24550-8-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190830092539.24550-1-tbogendoerfer@suse.de>
References: <20190830092539.24550-1-tbogendoerfer@suse.de>
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
 drivers/net/ethernet/sgi/ioc3-eth.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index fe77e4d7732f..29b9e5098052 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -778,12 +778,10 @@ static inline void ioc3_clean_tx_ring(struct ioc3_private *ip)
 	ip->tx_ci = 0;
 }
 
-static void ioc3_free_rings(struct ioc3_private *ip)
+static void ioc3_free_rx_bufs(struct ioc3_private *ip)
 {
 	int rx_entry, n_entry;
 
-	ioc3_clean_tx_ring(ip);
-
 	n_entry = ip->rx_ci;
 	rx_entry = ip->rx_pi;
 
@@ -794,7 +792,7 @@ static void ioc3_free_rings(struct ioc3_private *ip)
 	}
 }
 
-static void ioc3_alloc_rings(struct net_device *dev)
+static void ioc3_alloc_rx_bufs(struct net_device *dev)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
 	struct ioc3_erxbuf *rxb;
@@ -824,9 +822,6 @@ static void ioc3_alloc_rings(struct net_device *dev)
 	}
 	ip->rx_ci = 0;
 	ip->rx_pi = RX_BUFFS;
-
-	ip->tx_pi = 0;
-	ip->tx_ci = 0;
 }
 
 static void ioc3_init_rings(struct net_device *dev)
@@ -835,8 +830,8 @@ static void ioc3_init_rings(struct net_device *dev)
 	struct ioc3_ethregs *regs = ip->regs;
 	unsigned long ring;
 
-	ioc3_free_rings(ip);
-	ioc3_alloc_rings(dev);
+	ioc3_free_rx_bufs(ip);
+	ioc3_alloc_rx_bufs(dev);
 
 	ioc3_clean_tx_ring(ip);
 
@@ -962,7 +957,9 @@ static int ioc3_close(struct net_device *dev)
 	ioc3_stop(ip);
 	free_irq(dev->irq, dev);
 
-	ioc3_free_rings(ip);
+	ioc3_free_rx_bufs(ip);
+	ioc3_clean_tx_ring(ip);
+
 	return 0;
 }
 
@@ -1263,12 +1260,11 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_stop:
 	ioc3_stop(ip);
 	del_timer_sync(&ip->ioc3_timer);
-	ioc3_free_rings(ip);
+	ioc3_free_rx_bufs(ip);
 	if (ip->rxr)
 		free_page((unsigned long)ip->rxr);
 	if (ip->txr)
 		free_pages((unsigned long)ip->txr, 2);
-	kfree(ip->txr);
 out_res:
 	pci_release_regions(pdev);
 out_free:
-- 
2.13.7


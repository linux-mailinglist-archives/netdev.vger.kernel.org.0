Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 818C4A1FF7
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 17:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbfH2PwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 11:52:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:32826 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728249AbfH2Pug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 11:50:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0BBDEB6A0;
        Thu, 29 Aug 2019 15:50:35 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 07/15] net: sgi: ioc3-eth: separate tx and rx ring handling
Date:   Thu, 29 Aug 2019 17:50:05 +0200
Message-Id: <20190829155014.9229-8-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190829155014.9229-1-tbogendoerfer@suse.de>
References: <20190829155014.9229-1-tbogendoerfer@suse.de>
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
index e3867ea9abb7..de20f644e07d 100644
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
@@ -827,9 +825,6 @@ static void ioc3_alloc_rings(struct net_device *dev)
 	}
 	ip->rx_ci = 0;
 	ip->rx_pi = RX_BUFFS;
-
-	ip->tx_pi = 0;
-	ip->tx_ci = 0;
 }
 
 static void ioc3_init_rings(struct net_device *dev)
@@ -838,8 +833,8 @@ static void ioc3_init_rings(struct net_device *dev)
 	struct ioc3_ethregs *regs = ip->regs;
 	unsigned long ring;
 
-	ioc3_free_rings(ip);
-	ioc3_alloc_rings(dev);
+	ioc3_free_rx_bufs(ip);
+	ioc3_alloc_rx_bufs(dev);
 
 	ioc3_clean_tx_ring(ip);
 
@@ -965,7 +960,9 @@ static int ioc3_close(struct net_device *dev)
 	ioc3_stop(ip);
 	free_irq(dev->irq, dev);
 
-	ioc3_free_rings(ip);
+	ioc3_free_rx_bufs(ip);
+	ioc3_clean_tx_ring(ip);
+
 	return 0;
 }
 
@@ -1266,7 +1263,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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


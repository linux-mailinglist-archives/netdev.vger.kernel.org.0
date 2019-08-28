Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDEFA041E
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfH1OE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:04:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:39672 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726709AbfH1ODd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:03:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C2068B64A;
        Wed, 28 Aug 2019 14:03:30 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 05/15] net: sgi: ioc3-eth: allocate space for desc rings only once
Date:   Wed, 28 Aug 2019 16:03:04 +0200
Message-Id: <20190828140315.17048-6-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190828140315.17048-1-tbogendoerfer@suse.de>
References: <20190828140315.17048-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Memory for descriptor rings are allocated/freed, when interface is
brought up/down. Since the size of the rings is not changeable by
hardware, we now allocate rings now during probe and free it, when
device is removed.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 103 ++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index c875640926d6..6ca560d4ab79 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -803,25 +803,17 @@ static void ioc3_free_rings(struct ioc3_private *ip)
 	struct sk_buff *skb;
 	int rx_entry, n_entry;
 
-	if (ip->txr) {
-		ioc3_clean_tx_ring(ip);
-		free_pages((unsigned long)ip->txr, 2);
-		ip->txr = NULL;
-	}
+	ioc3_clean_tx_ring(ip);
 
-	if (ip->rxr) {
-		n_entry = ip->rx_ci;
-		rx_entry = ip->rx_pi;
+	n_entry = ip->rx_ci;
+	rx_entry = ip->rx_pi;
 
-		while (n_entry != rx_entry) {
-			skb = ip->rx_skbs[n_entry];
-			if (skb)
-				dev_kfree_skb_any(skb);
+	while (n_entry != rx_entry) {
+		skb = ip->rx_skbs[n_entry];
+		if (skb)
+			dev_kfree_skb_any(skb);
 
-			n_entry = (n_entry + 1) & RX_RING_MASK;
-		}
-		free_page((unsigned long)ip->rxr);
-		ip->rxr = NULL;
+		n_entry = (n_entry + 1) & RX_RING_MASK;
 	}
 }
 
@@ -829,49 +821,34 @@ static void ioc3_alloc_rings(struct net_device *dev)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
 	struct ioc3_erxbuf *rxb;
-	unsigned long *rxr;
 	int i;
 
-	if (!ip->rxr) {
-		/* Allocate and initialize rx ring.  4kb = 512 entries  */
-		ip->rxr = (unsigned long *)get_zeroed_page(GFP_ATOMIC);
-		rxr = ip->rxr;
-		if (!rxr)
-			pr_err("%s: get_zeroed_page() failed!\n", __func__);
-
-		/* Now the rx buffers.  The RX ring may be larger but
-		 * we only allocate 16 buffers for now.  Need to tune
-		 * this for performance and memory later.
-		 */
-		for (i = 0; i < RX_BUFFS; i++) {
-			struct sk_buff *skb;
+	/* Now the rx buffers.  The RX ring may be larger but
+	 * we only allocate 16 buffers for now.  Need to tune
+	 * this for performance and memory later.
+	 */
+	for (i = 0; i < RX_BUFFS; i++) {
+		struct sk_buff *skb;
 
-			skb = ioc3_alloc_skb(RX_BUF_ALLOC_SIZE, GFP_ATOMIC);
-			if (!skb) {
-				show_free_areas(0, NULL);
-				continue;
-			}
+		skb = ioc3_alloc_skb(RX_BUF_ALLOC_SIZE, GFP_ATOMIC);
+		if (!skb) {
+			show_free_areas(0, NULL);
+			continue;
+		}
 
-			ip->rx_skbs[i] = skb;
+		ip->rx_skbs[i] = skb;
 
-			/* Because we reserve afterwards. */
-			skb_put(skb, (1664 + RX_OFFSET));
-			rxb = (struct ioc3_erxbuf *)skb->data;
-			rxr[i] = cpu_to_be64(ioc3_map(rxb, 1));
-			skb_reserve(skb, RX_OFFSET);
-		}
-		ip->rx_ci = 0;
-		ip->rx_pi = RX_BUFFS;
+		/* Because we reserve afterwards. */
+		skb_put(skb, (1664 + RX_OFFSET));
+		rxb = (struct ioc3_erxbuf *)skb->data;
+		ip->rxr[i] = cpu_to_be64(ioc3_map(rxb, 1));
+		skb_reserve(skb, RX_OFFSET);
 	}
+	ip->rx_ci = 0;
+	ip->rx_pi = RX_BUFFS;
 
-	if (!ip->txr) {
-		/* Allocate and initialize tx rings.  16kb = 128 bufs.  */
-		ip->txr = (struct ioc3_etxd *)__get_free_pages(GFP_KERNEL, 2);
-		if (!ip->txr)
-			pr_err("%s: __get_free_pages() failed!\n", __func__);
-		ip->tx_pi = 0;
-		ip->tx_ci = 0;
-	}
+	ip->tx_pi = 0;
+	ip->tx_ci = 0;
 }
 
 static void ioc3_init_rings(struct net_device *dev)
@@ -1239,6 +1216,23 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	timer_setup(&ip->ioc3_timer, ioc3_timer, 0);
 
 	ioc3_stop(ip);
+
+	/* Allocate and rx ring.  4kb = 512 entries  */
+	ip->rxr = (unsigned long *)get_zeroed_page(GFP_ATOMIC);
+	if (!ip->rxr) {
+		pr_err("ioc3-eth: rx ring allocation failed\n");
+		err = -ENOMEM;
+		goto out_stop;
+	}
+
+	/* Allocate tx rings.  16kb = 128 bufs.  */
+	ip->txr = (struct ioc3_etxd *)__get_free_pages(GFP_KERNEL, 2);
+	if (!ip->txr) {
+		pr_err("ioc3-eth: tx ring allocation failed\n");
+		err = -ENOMEM;
+		goto out_stop;
+	}
+
 	ioc3_init(dev);
 
 	ip->pdev = pdev;
@@ -1293,6 +1287,8 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ioc3_stop(ip);
 	del_timer_sync(&ip->ioc3_timer);
 	ioc3_free_rings(ip);
+	kfree(ip->rxr);
+	kfree(ip->txr);
 out_res:
 	pci_release_regions(pdev);
 out_free:
@@ -1310,6 +1306,9 @@ static void ioc3_remove_one(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct ioc3_private *ip = netdev_priv(dev);
 
+	kfree(ip->rxr);
+	kfree(ip->txr);
+
 	unregister_netdev(dev);
 	del_timer_sync(&ip->ioc3_timer);
 
-- 
2.13.7


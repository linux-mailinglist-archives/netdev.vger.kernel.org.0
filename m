Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFB55EDCCB
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 11:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbfKDKpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 05:45:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:45102 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727663AbfKDKpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 05:45:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E6E61B1D8;
        Mon,  4 Nov 2019 10:45:22 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net v3 5/5] net: sgi: ioc3-eth: ensure tx ring is 16k aligned.
Date:   Mon,  4 Nov 2019 11:45:15 +0100
Message-Id: <20191104104515.7066-5-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104104515.7066-1-tbogendoerfer@suse.de>
References: <20191104104515.7066-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IOC3 hardware needs a 16k aligned TX ring.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 1af68826810a..d242906ae233 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -89,6 +89,7 @@ struct ioc3_private {
 	struct device *dma_dev;
 	u32 *ssram;
 	unsigned long *rxr;		/* pointer to receiver ring */
+	void *tx_ring;
 	struct ioc3_etxd *txr;
 	dma_addr_t rxr_dma;
 	dma_addr_t txr_dma;
@@ -1236,13 +1237,16 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Allocate tx rings.  16kb = 128 bufs, must be 16kb aligned  */
-	ip->txr = dma_alloc_coherent(ip->dma_dev, TX_RING_SIZE, &ip->txr_dma,
-				     GFP_KERNEL);
-	if (!ip->txr) {
+	ip->tx_ring = dma_alloc_coherent(ip->dma_dev, TX_RING_SIZE + SZ_16K - 1,
+					 &ip->txr_dma, GFP_KERNEL);
+	if (!ip->tx_ring) {
 		pr_err("ioc3-eth: tx ring allocation failed\n");
 		err = -ENOMEM;
 		goto out_stop;
 	}
+	/* Align TX ring */
+	ip->txr = PTR_ALIGN(ip->tx_ring, SZ_16K);
+	ip->txr_dma = ALIGN(ip->txr_dma, SZ_16K);
 
 	ioc3_init(dev);
 
@@ -1299,8 +1303,8 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ip->rxr)
 		dma_free_coherent(ip->dma_dev, RX_RING_SIZE, ip->rxr,
 				  ip->rxr_dma);
-	if (ip->txr)
-		dma_free_coherent(ip->dma_dev, TX_RING_SIZE, ip->txr,
+	if (ip->tx_ring)
+		dma_free_coherent(ip->dma_dev, TX_RING_SIZE, ip->tx_ring,
 				  ip->txr_dma);
 out_res:
 	pci_release_regions(pdev);
@@ -1320,7 +1324,7 @@ static void ioc3_remove_one(struct pci_dev *pdev)
 	struct ioc3_private *ip = netdev_priv(dev);
 
 	dma_free_coherent(ip->dma_dev, RX_RING_SIZE, ip->rxr, ip->rxr_dma);
-	dma_free_coherent(ip->dma_dev, TX_RING_SIZE, ip->txr, ip->txr_dma);
+	dma_free_coherent(ip->dma_dev, TX_RING_SIZE, ip->tx_ring, ip->txr_dma);
 
 	unregister_netdev(dev);
 	del_timer_sync(&ip->ioc3_timer);
-- 
2.16.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21DB2EDCCE
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 11:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbfKDKpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 05:45:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:45078 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727236AbfKDKpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 05:45:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8EEEAB1C3;
        Mon,  4 Nov 2019 10:45:22 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>
Subject: [net v3 2/5] net: sgi: ioc3-eth: fix usage of GFP_* flags
Date:   Mon,  4 Nov 2019 11:45:12 +0100
Message-Id: <20191104104515.7066-2-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104104515.7066-1-tbogendoerfer@suse.de>
References: <20191104104515.7066-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

dma_alloc_coherent always zeroes memory, there is no need for
__GFP_ZERO.  Also doing a GFP_ATOMIC allocation just before a GFP_KERNEL
one is clearly bogus.

Fixes: ed870f6a7aa2 ("net: sgi: ioc3-eth: use dma-direct for dma allocations")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 477af82bf8a9..8a684d882e63 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -1243,7 +1243,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Allocate rx ring.  4kb = 512 entries, must be 4kb aligned */
 	ip->rxr = dma_alloc_coherent(ip->dma_dev, RX_RING_SIZE, &ip->rxr_dma,
-				     GFP_ATOMIC);
+				     GFP_KERNEL);
 	if (!ip->rxr) {
 		pr_err("ioc3-eth: rx ring allocation failed\n");
 		err = -ENOMEM;
@@ -1252,7 +1252,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Allocate tx rings.  16kb = 128 bufs, must be 16kb aligned  */
 	ip->txr = dma_alloc_coherent(ip->dma_dev, TX_RING_SIZE, &ip->txr_dma,
-				     GFP_KERNEL | __GFP_ZERO);
+				     GFP_KERNEL);
 	if (!ip->txr) {
 		pr_err("ioc3-eth: tx ring allocation failed\n");
 		err = -ENOMEM;
-- 
2.16.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 116E1ED2E7
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 11:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbfKCKfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 05:35:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:56882 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727380AbfKCKfG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Nov 2019 05:35:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9708CB183;
        Sun,  3 Nov 2019 10:35:04 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>
Subject: [net v2 4/4] net: sgi: ioc3-eth: fix setting NETIF_F_HIGHDMA
Date:   Sun,  3 Nov 2019 11:34:33 +0100
Message-Id: <20191103103433.26826-4-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191103103433.26826-1-tbogendoerfer@suse.de>
References: <20191103103433.26826-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Set NETIF_F_HIGHDMA together with the NETIF_F_IP_CSUM flag insted of
letting the second assignment overwrite it.  Probably doesn't matter
in practice as none of the systems a IOC3 is usually found in has
highmem to start with.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 83abc8a13508..d242906ae233 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -1193,8 +1193,6 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_disable;
 	}
 
-	dev->features |= NETIF_F_HIGHDMA;
-
 	err = pci_request_regions(pdev, "ioc3");
 	if (err)
 		goto out_free;
@@ -1278,7 +1276,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->netdev_ops		= &ioc3_netdev_ops;
 	dev->ethtool_ops	= &ioc3_ethtool_ops;
 	dev->hw_features	= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
-	dev->features		= NETIF_F_IP_CSUM;
+	dev->features		= NETIF_F_IP_CSUM | NETIF_F_HIGHDMA;
 
 	sw_physid1 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID1);
 	sw_physid2 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID2);
-- 
2.16.4


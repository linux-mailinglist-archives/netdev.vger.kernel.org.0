Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD6A2E899E
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 01:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbhACAcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 19:32:13 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:48486 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbhACAcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jan 2021 19:32:12 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 6401229A96; Sat,  2 Jan 2021 19:31:29 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>,
        "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
        "Chris Zankel" <chris@zankel.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <529006a7dcd2cd345c2261d4beae0960880f4828.1609633586.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 net RESEND] net/sonic: Fix some resource leaks in error handling paths
Date:   Sun, 03 Jan 2021 11:26:26 +1100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

A call to dma_alloc_coherent() is wrapped by sonic_alloc_descriptors().

This is correctly freed in the remove function, but not in the error
handling path of the probe function. Fix this by adding the missing
dma_free_coherent() call.

While at it, rename a label in order to be slightly more informative.

Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Chris Zankel <chris@zankel.net>
References: commit 10e3cc180e64 ("net/sonic: Fix a resource leak in an error handling path in 'jazz_sonic_probe()'")
Fixes: 74f2a5f0ef64 ("xtensa: Add support for the Sonic Ethernet device for the XT2000 board.")
Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
Changed since v3:
 - Update commit log.
Changed since v2:
 - Dropped whitespace change.
---
 drivers/net/ethernet/natsemi/macsonic.c | 12 ++++++++++--
 drivers/net/ethernet/natsemi/xtsonic.c  |  7 +++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/macsonic.c b/drivers/net/ethernet/natsemi/macsonic.c
index 776b7d264dc3..2289e1fe3741 100644
--- a/drivers/net/ethernet/natsemi/macsonic.c
+++ b/drivers/net/ethernet/natsemi/macsonic.c
@@ -506,10 +506,14 @@ static int mac_sonic_platform_probe(struct platform_device *pdev)
 
 	err = register_netdev(dev);
 	if (err)
-		goto out;
+		goto undo_probe;
 
 	return 0;
 
+undo_probe:
+	dma_free_coherent(lp->device,
+			  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
+			  lp->descriptors, lp->descriptors_laddr);
 out:
 	free_netdev(dev);
 
@@ -584,12 +588,16 @@ static int mac_sonic_nubus_probe(struct nubus_board *board)
 
 	err = register_netdev(ndev);
 	if (err)
-		goto out;
+		goto undo_probe;
 
 	nubus_set_drvdata(board, ndev);
 
 	return 0;
 
+undo_probe:
+	dma_free_coherent(lp->device,
+			  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
+			  lp->descriptors, lp->descriptors_laddr);
 out:
 	free_netdev(ndev);
 	return err;
diff --git a/drivers/net/ethernet/natsemi/xtsonic.c b/drivers/net/ethernet/natsemi/xtsonic.c
index afa166ff7aef..28d9e98db81a 100644
--- a/drivers/net/ethernet/natsemi/xtsonic.c
+++ b/drivers/net/ethernet/natsemi/xtsonic.c
@@ -229,11 +229,14 @@ int xtsonic_probe(struct platform_device *pdev)
 	sonic_msg_init(dev);
 
 	if ((err = register_netdev(dev)))
-		goto out1;
+		goto undo_probe1;
 
 	return 0;
 
-out1:
+undo_probe1:
+	dma_free_coherent(lp->device,
+			  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
+			  lp->descriptors, lp->descriptors_laddr);
 	release_region(dev->base_addr, SONIC_MEM_SIZE);
 out:
 	free_netdev(dev);
-- 
2.26.2


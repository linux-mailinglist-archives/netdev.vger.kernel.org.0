Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA751CB5E0
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 19:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgEHR0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 13:26:02 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:24221 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbgEHR0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 13:26:02 -0400
Received: from localhost.localdomain ([93.23.14.114])
        by mwinf5d27 with ME
        id cHRy2200M2Tev1p03HRzku; Fri, 08 May 2020 19:26:00 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 08 May 2020 19:26:00 +0200
X-ME-IP: 93.23.14.114
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, fthain@telegraphics.com.au
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net/sonic: Fix some resource leaks in error handling paths
Date:   Fri,  8 May 2020 19:25:57 +0200
Message-Id: <20200508172557.218132-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A call to 'dma_alloc_coherent()' is hidden in 'sonic_alloc_descriptors()'.

This is correctly freed in the remove function, but not in the error
handling path of the probe function.
Fix it and add the missing 'dma_free_coherent()' call.

While at it, rename a label in order to be slightly more informative and
split some too long lines.

This patch is similar to commit 10e3cc180e64 ("net/sonic: Fix a resource leak in an error handling path in 'jazz_sonic_probe()'")
which was for 'jazzsonic.c'.

Suggested-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Only macsonic has been compile tested. I don't have the needed setup to
compile xtsonic
---
 drivers/net/ethernet/natsemi/macsonic.c | 17 +++++++++++++----
 drivers/net/ethernet/natsemi/xtsonic.c  |  7 +++++--
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/macsonic.c b/drivers/net/ethernet/natsemi/macsonic.c
index 1b5559aacb38..38d86c712bbc 100644
--- a/drivers/net/ethernet/natsemi/macsonic.c
+++ b/drivers/net/ethernet/natsemi/macsonic.c
@@ -506,10 +506,14 @@ static int mac_sonic_platform_probe(struct platform_device *pdev)
 
 	err = register_netdev(dev);
 	if (err)
-		goto out;
+		goto undo_probe1;
 
 	return 0;
 
+undo_probe1:
+	dma_free_coherent(lp->device,
+			  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
+			  lp->descriptors, lp->descriptors_laddr);
 out:
 	free_netdev(dev);
 
@@ -527,8 +531,9 @@ static int mac_sonic_platform_remove(struct platform_device *pdev)
 	struct sonic_local* lp = netdev_priv(dev);
 
 	unregister_netdev(dev);
-	dma_free_coherent(lp->device, SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
-	                  lp->descriptors, lp->descriptors_laddr);
+	dma_free_coherent(lp->device,
+			  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
+			  lp->descriptors, lp->descriptors_laddr);
 	free_netdev(dev);
 
 	return 0;
@@ -584,12 +589,16 @@ static int mac_sonic_nubus_probe(struct nubus_board *board)
 
 	err = register_netdev(ndev);
 	if (err)
-		goto out;
+		goto undo_probe1;
 
 	nubus_set_drvdata(board, ndev);
 
 	return 0;
 
+undo_probe1:
+	dma_free_coherent(lp->device,
+			  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
+			  lp->descriptors, lp->descriptors_laddr);
 out:
 	free_netdev(ndev);
 	return err;
diff --git a/drivers/net/ethernet/natsemi/xtsonic.c b/drivers/net/ethernet/natsemi/xtsonic.c
index dda9ec7d9cee..a917f1a830fc 100644
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
2.25.1


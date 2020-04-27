Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A3D1B9739
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 08:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgD0GSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 02:18:15 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:37829 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgD0GSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 02:18:10 -0400
Received: from localhost.localdomain ([92.148.159.11])
        by mwinf5d65 with ME
        id XiJ52200R0F2omL03iJ6FL; Mon, 27 Apr 2020 08:18:08 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 27 Apr 2020 08:18:08 +0200
X-ME-IP: 92.148.159.11
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, fthain@telegraphics.com.au,
        tsbogend@alpha.franken.de, jgarzik@pobox.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net/sonic: Fix a resource leak in an error handling path in 'jazz_sonic_probe()'
Date:   Mon, 27 Apr 2020 08:18:03 +0200
Message-Id: <20200427061803.53857-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A call to 'dma_alloc_coherent()' is hidden in 'sonic_alloc_descriptors()',
called from 'sonic_probe1()'.

This is correctly freed in the remove function, but not in the error
handling path of the probe function.
Fix it and add the missing 'dma_free_coherent()' call.

While at it, rename a label in order to be slightly more informative.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/natsemi/jazzsonic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/jazzsonic.c b/drivers/net/ethernet/natsemi/jazzsonic.c
index bfa0c0d39600..8b018ed37b1b 100644
--- a/drivers/net/ethernet/natsemi/jazzsonic.c
+++ b/drivers/net/ethernet/natsemi/jazzsonic.c
@@ -208,11 +208,13 @@ static int jazz_sonic_probe(struct platform_device *pdev)
 
 	err = register_netdev(dev);
 	if (err)
-		goto out1;
+		goto undo_probe1;
 
 	return 0;
 
-out1:
+undo_probe1:
+	dma_free_coherent(lp->device, SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
+			  lp->descriptors, lp->descriptors_laddr);
 	release_mem_region(dev->base_addr, SONIC_MEM_SIZE);
 out:
 	free_netdev(dev);
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 395F7A4306
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 09:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfHaHSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 03:18:01 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:23491 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfHaHSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 03:18:01 -0400
Received: from localhost.localdomain ([90.126.97.183])
        by mwinf5d55 with ME
        id vjHt200053xPcdm03jHtj6; Sat, 31 Aug 2019 09:17:58 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 31 Aug 2019 09:17:58 +0200
X-ME-IP: 90.126.97.183
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, yuehaibing@huawei.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, tbogendoerfer@suse.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: seeq: Fix the function used to release some memory in an error handling path
Date:   Sat, 31 Aug 2019 09:17:51 +0200
Message-Id: <20190831071751.1479-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 99cd149efe82 ("sgiseeq: replace use of dma_cache_wback_inv"),
a call to 'get_zeroed_page()' has been turned into a call to
'dma_alloc_coherent()'. Only the remove function has been updated to turn
the corresponding 'free_page()' into 'dma_free_attrs()'.
The error hndling path of the probe function has not been updated.

Fix it now.

Rename the corresponding label to something more in line.

Fixes: 99cd149efe82 ("sgiseeq: replace use of dma_cache_wback_inv")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
If 'dma_alloc_coherent()' fails, maybe the message in printk could be
improved. The comment above may also not be relevant.
---
 drivers/net/ethernet/seeq/sgiseeq.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/seeq/sgiseeq.c
index 7a5e6c5abb57..276c7cae7cee 100644
--- a/drivers/net/ethernet/seeq/sgiseeq.c
+++ b/drivers/net/ethernet/seeq/sgiseeq.c
@@ -794,15 +794,16 @@ static int sgiseeq_probe(struct platform_device *pdev)
 		printk(KERN_ERR "Sgiseeq: Cannot register net device, "
 		       "aborting.\n");
 		err = -ENODEV;
-		goto err_out_free_page;
+		goto err_out_free_attrs;
 	}
 
 	printk(KERN_INFO "%s: %s %pM\n", dev->name, sgiseeqstr, dev->dev_addr);
 
 	return 0;
 
-err_out_free_page:
-	free_page((unsigned long) sp->srings);
+err_out_free_attrs:
+	dma_free_attrs(&pdev->dev, sizeof(*sp->srings), sp->srings,
+		       sp->srings_dma, DMA_ATTR_NON_CONSISTENT);
 err_out_free_dev:
 	free_netdev(dev);
 
-- 
2.20.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1BB14CEC43
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 17:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbiCFQkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 11:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiCFQkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 11:40:07 -0500
Received: from smtp.smtpout.orange.fr (smtp06.smtpout.orange.fr [80.12.242.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72E63ED1C
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 08:39:14 -0800 (PST)
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id QtuZnKV3iuCn2QtuZniRqp; Sun, 06 Mar 2022 17:39:12 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 06 Mar 2022 17:39:12 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] ethernet: sun: Fix an error handling path in happy_meal_pci_probe()
Date:   Sun,  6 Mar 2022 17:39:10 +0100
Message-Id: <242ebc5e7dedc6b0d7f47cbf7768326c127f955b.1646584729.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A dma_free_coherent() call is missing in the error handling path of the
probe, as already done in the remove function.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
dma_alloc_coherent() uses '&pdev->dev' and the remove function
'hp->dma_dev'.
This change is a copy&paste from the remove function, so I've left the
latter. It is not important because on line 3017 we have
"hp->dma_dev = &pdev->dev;" so both expression are the same.


I've not been able to find a Fixes tag because of the renaming of
function and files.
However, it looks old (before 2008)
---
 drivers/net/ethernet/sun/sunhme.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index ad9029ae6848..348ed5412544 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -3146,7 +3146,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	if (err) {
 		printk(KERN_ERR "happymeal(PCI): Cannot register net device, "
 		       "aborting.\n");
-		goto err_out_iounmap;
+		goto err_out_free_dma;
 	}
 
 	pci_set_drvdata(pdev, hp);
@@ -3179,6 +3179,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 
+err_out_free_dma:
+	dma_free_coherent(hp->dma_dev, PAGE_SIZE,
+			  hp->happy_block, hp->hblock_dvma);
+
 err_out_iounmap:
 	iounmap(hp->gregs);
 
-- 
2.32.0


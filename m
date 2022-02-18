Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0094BBE9D
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 18:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbiBRRrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 12:47:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbiBRRrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 12:47:12 -0500
Received: from smtp.smtpout.orange.fr (smtp01.smtpout.orange.fr [80.12.242.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B1827CD4
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 09:46:55 -0800 (PST)
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id L7LJnWEKdFTgbL7LKniDHC; Fri, 18 Feb 2022 18:46:54 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Fri, 18 Feb 2022 18:46:54 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Chas Williams <3chas3@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH] atm: nicstar: Use kcalloc() to simplify code
Date:   Fri, 18 Feb 2022 18:46:51 +0100
Message-Id: <68ec8438f31b1034b37b21a6c1b6c3de195b8adf.1645206403.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kcalloc() instead of kmalloc_array() and a loop to set all the values
of the array to NULL.

While at it, remove a duplicated assignment to 'scq->num_entries'.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/atm/nicstar.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index bc5a6ab6fa4b..1a50de39f5b5 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -861,7 +861,6 @@ static void ns_init_card_error(ns_dev *card, int error)
 static scq_info *get_scq(ns_dev *card, int size, u32 scd)
 {
 	scq_info *scq;
-	int i;
 
 	if (size != VBR_SCQSIZE && size != CBR_SCQSIZE)
 		return NULL;
@@ -875,9 +874,8 @@ static scq_info *get_scq(ns_dev *card, int size, u32 scd)
 		kfree(scq);
 		return NULL;
 	}
-	scq->skb = kmalloc_array(size / NS_SCQE_SIZE,
-				 sizeof(*scq->skb),
-				 GFP_KERNEL);
+	scq->skb = kcalloc(size / NS_SCQE_SIZE, sizeof(*scq->skb),
+			   GFP_KERNEL);
 	if (!scq->skb) {
 		dma_free_coherent(&card->pcidev->dev,
 				  2 * size, scq->org, scq->dma);
@@ -890,15 +888,11 @@ static scq_info *get_scq(ns_dev *card, int size, u32 scd)
 	scq->last = scq->base + (scq->num_entries - 1);
 	scq->tail = scq->last;
 	scq->scd = scd;
-	scq->num_entries = size / NS_SCQE_SIZE;
 	scq->tbd_count = 0;
 	init_waitqueue_head(&scq->scqfull_waitq);
 	scq->full = 0;
 	spin_lock_init(&scq->lock);
 
-	for (i = 0; i < scq->num_entries; i++)
-		scq->skb[i] = NULL;
-
 	return scq;
 }
 
-- 
2.32.0


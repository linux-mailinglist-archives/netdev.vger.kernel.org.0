Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD5256CA3F
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 17:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiGIPFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 11:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGIPFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 11:05:49 -0400
Received: from smtp.smtpout.orange.fr (smtp02.smtpout.orange.fr [80.12.242.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB8243307
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 08:05:48 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id AC1ioAmdXZfs8AC1io6k8z; Sat, 09 Jul 2022 17:05:47 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 09 Jul 2022 17:05:47 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Chas Williams <3chas3@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH] atm: he: Use the bitmap API to allocate bitmaps
Date:   Sat,  9 Jul 2022 17:05:45 +0200
Message-Id: <7f795bd6d5b2a00f581175b7069b229c2e5a4192.1657379127.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.

It is less verbose and it improves the semantic.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/atm/he.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index 17f44abc9418..ad91cc6a34fc 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -780,14 +780,11 @@ static int he_init_group(struct he_dev *he_dev, int group)
 		  G0_RBPS_BS + (group * 32));
 
 	/* bitmap table */
-	he_dev->rbpl_table = kmalloc_array(BITS_TO_LONGS(RBPL_TABLE_SIZE),
-					   sizeof(*he_dev->rbpl_table),
-					   GFP_KERNEL);
+	he_dev->rbpl_table = bitmap_zalloc(RBPL_TABLE_SIZE, GFP_KERNEL);
 	if (!he_dev->rbpl_table) {
 		hprintk("unable to allocate rbpl bitmap table\n");
 		return -ENOMEM;
 	}
-	bitmap_zero(he_dev->rbpl_table, RBPL_TABLE_SIZE);
 
 	/* rbpl_virt 64-bit pointers */
 	he_dev->rbpl_virt = kmalloc_array(RBPL_TABLE_SIZE,
@@ -902,7 +899,7 @@ static int he_init_group(struct he_dev *he_dev, int group)
 out_free_rbpl_virt:
 	kfree(he_dev->rbpl_virt);
 out_free_rbpl_table:
-	kfree(he_dev->rbpl_table);
+	bitmap_free(he_dev->rbpl_table);
 
 	return -ENOMEM;
 }
@@ -1578,7 +1575,7 @@ he_stop(struct he_dev *he_dev)
 	}
 
 	kfree(he_dev->rbpl_virt);
-	kfree(he_dev->rbpl_table);
+	bitmap_free(he_dev->rbpl_table);
 	dma_pool_destroy(he_dev->rbpl_pool);
 
 	if (he_dev->rbrq_base)
-- 
2.34.1


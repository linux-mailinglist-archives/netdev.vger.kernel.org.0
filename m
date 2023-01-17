Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E373366D9C9
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbjAQJYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236767AbjAQJYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:24:05 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F404830E81;
        Tue, 17 Jan 2023 01:21:28 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4Nx3Kz3cmRz501Sq;
        Tue, 17 Jan 2023 17:21:27 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
        by mse-fl2.zte.com.cn with SMTP id 30H9L5EC054983;
        Tue, 17 Jan 2023 17:21:05 +0800 (+08)
        (envelope-from ye.xingchen@zte.com.cn)
Received: from mapi (xaxapp01[null])
        by mapi (Zmail) with MAPI id mid31;
        Tue, 17 Jan 2023 17:21:07 +0800 (CST)
Date:   Tue, 17 Jan 2023 17:21:07 +0800 (CST)
X-Zmail-TransId: 2af963c668836dc062e9
X-Mailer: Zmail v1.0
Message-ID: <202301171721076625091@zte.com.cn>
Mime-Version: 1.0
From:   <ye.xingchen@zte.com.cn>
To:     <3chas3@gmail.com>
Cc:     <linux-atm-general@lists.sourceforge.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHRdIGF0bTogbGFuYWk6IFVzZSBkbWFfemFsbG9jX2NvaGVyZW50KCk=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 30H9L5EC054983
X-Fangmail-Gw-Spam-Type: 0
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63C66897.000/4Nx3Kz3cmRz501Sq
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SPF_PERMERROR,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

Instead of using dma_alloc_coherent() and memset() directly use
dma_zalloc_coherent().

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 drivers/atm/lanai.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index 32d7aa141d96..b7e0199ce642 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -342,8 +342,8 @@ static void lanai_buf_allocate(struct lanai_buffer *buf,
 		 * everything, but the way the lanai uses DMA memory would
 		 * make that a terrific pain.  This is much simpler.
 		 */
-		buf->start = dma_alloc_coherent(&pci->dev,
-						size, &buf->dmaaddr, GFP_KERNEL);
+		buf->start = dma_zalloc_coherent(&pci->dev,
+						 size, &buf->dmaaddr, GFP_KERNEL);
 		if (buf->start != NULL) {	/* Success */
 			/* Lanai requires 256-byte alignment of DMA bufs */
 			APRINTK((buf->dmaaddr & ~0xFFFFFF00) == 0,
@@ -352,7 +352,6 @@ static void lanai_buf_allocate(struct lanai_buffer *buf,
 			buf->ptr = buf->start;
 			buf->end = (u32 *)
 			    (&((unsigned char *) buf->start)[size]);
-			memset(buf->start, 0, size);
 			break;
 		}
 		size /= 2;
-- 
2.25.1

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D6656CA23
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 16:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiGIOiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 10:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiGIOh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 10:37:59 -0400
Received: from smtp.smtpout.orange.fr (smtp08.smtpout.orange.fr [80.12.242.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407A41EEE8
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 07:37:58 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id ABakozMByNUm1ABako10pc; Sat, 09 Jul 2022 16:37:56 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 09 Jul 2022 16:37:56 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH v2] net/fq_impl: Use the bitmap API to allocate bitmaps
Date:   Sat,  9 Jul 2022 16:37:53 +0200
Message-Id: <c7bf099af07eb497b02d195906ee8c11fea3b3bd.1657377335.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.

It is less verbose and it improves the semantic.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v1 --> v2: Fix commit message. devm_bitmap_zalloc() is not used here
---
 include/net/fq_impl.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/fq_impl.h b/include/net/fq_impl.h
index a5f67a2c0c73..524b510f1c68 100644
--- a/include/net/fq_impl.h
+++ b/include/net/fq_impl.h
@@ -358,8 +358,7 @@ static int fq_init(struct fq *fq, int flows_cnt)
 	if (!fq->flows)
 		return -ENOMEM;
 
-	fq->flows_bitmap = kcalloc(BITS_TO_LONGS(fq->flows_cnt), sizeof(long),
-				   GFP_KERNEL);
+	fq->flows_bitmap = bitmap_zalloc(fq->flows_cnt, GFP_KERNEL);
 	if (!fq->flows_bitmap) {
 		kvfree(fq->flows);
 		fq->flows = NULL;
@@ -383,7 +382,7 @@ static void fq_reset(struct fq *fq,
 	kvfree(fq->flows);
 	fq->flows = NULL;
 
-	kfree(fq->flows_bitmap);
+	bitmap_free(fq->flows_bitmap);
 	fq->flows_bitmap = NULL;
 }
 
-- 
2.34.1


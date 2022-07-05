Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0488567846
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 22:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiGEUXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 16:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiGEUXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 16:23:06 -0400
Received: from smtp.smtpout.orange.fr (smtp02.smtpout.orange.fr [80.12.242.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BA71581C
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 13:23:04 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id 8p4XoztESgoLG8p4XoHrFO; Tue, 05 Jul 2022 22:23:03 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Tue, 05 Jul 2022 22:23:03 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] bnxt: Use the bitmap API to allocate bitmaps
Date:   Tue,  5 Jul 2022 22:22:59 +0200
Message-Id: <d508f3adf7e2804f4d3793271b82b196a2ccb940.1657052562.git.christophe.jaillet@wanadoo.fr>
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
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 11d35da61921..c74b2e4250ad 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4477,7 +4477,7 @@ static void bnxt_free_ntp_fltrs(struct bnxt *bp, bool irq_reinit)
 		}
 	}
 	if (irq_reinit) {
-		kfree(bp->ntp_fltr_bmap);
+		bitmap_free(bp->ntp_fltr_bmap);
 		bp->ntp_fltr_bmap = NULL;
 	}
 	bp->ntp_fltr_count = 0;
@@ -4496,9 +4496,7 @@ static int bnxt_alloc_ntp_fltrs(struct bnxt *bp)
 		INIT_HLIST_HEAD(&bp->ntp_fltr_hash_tbl[i]);
 
 	bp->ntp_fltr_count = 0;
-	bp->ntp_fltr_bmap = kcalloc(BITS_TO_LONGS(BNXT_NTP_FLTR_MAX_FLTR),
-				    sizeof(long),
-				    GFP_KERNEL);
+	bp->ntp_fltr_bmap = bitmap_zalloc(BNXT_NTP_FLTR_MAX_FLTR, GFP_KERNEL);
 
 	if (!bp->ntp_fltr_bmap)
 		rc = -ENOMEM;
-- 
2.34.1


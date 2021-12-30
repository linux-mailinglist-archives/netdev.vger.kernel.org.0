Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB6A481B73
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 11:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238514AbhL3Kkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 05:40:45 -0500
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:60314 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238645AbhL3Kko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 05:40:44 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id 2srRnciv1MxZu2srRnOuEK; Thu, 30 Dec 2021 11:40:43 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 30 Dec 2021 11:40:43 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net/smc: Use the bitmap API when applicable
Date:   Thu, 30 Dec 2021 11:40:40 +0100
Message-Id: <2fe6e0424bed3ebd4098d3b881946ddf55342d1f.1640860762.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using the bitmap API is less verbose than hand writing them.
It also improves the semantic.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/smc/smc_wr.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 600ab5889227..1b09012d637a 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -54,11 +54,7 @@ struct smc_wr_tx_pend {	/* control data for a pending send request */
 /* returns true if at least one tx work request is pending on the given link */
 static inline bool smc_wr_is_tx_pend(struct smc_link *link)
 {
-	if (find_first_bit(link->wr_tx_mask, link->wr_tx_cnt) !=
-							link->wr_tx_cnt) {
-		return true;
-	}
-	return false;
+	return !bitmap_empty(link->wr_tx_mask, link->wr_tx_cnt);
 }
 
 /* wait till all pending tx work requests on the given link are completed */
@@ -674,9 +670,7 @@ void smc_wr_free_link(struct smc_link *lnk)
 	smc_wr_wakeup_tx_wait(lnk);
 
 	if (smc_wr_tx_wait_no_pending_sends(lnk))
-		memset(lnk->wr_tx_mask, 0,
-		       BITS_TO_LONGS(SMC_WR_BUF_CNT) *
-						sizeof(*lnk->wr_tx_mask));
+		bitmap_zero(lnk->wr_tx_mask, SMC_WR_BUF_CNT);
 	wait_event(lnk->wr_reg_wait, (!atomic_read(&lnk->wr_reg_refcnt)));
 	wait_event(lnk->wr_tx_wait, (!atomic_read(&lnk->wr_tx_refcnt)));
 
@@ -729,7 +723,7 @@ void smc_wr_free_link_mem(struct smc_link *lnk)
 	lnk->wr_tx_compl = NULL;
 	kfree(lnk->wr_tx_pends);
 	lnk->wr_tx_pends = NULL;
-	kfree(lnk->wr_tx_mask);
+	bitmap_free(lnk->wr_tx_mask);
 	lnk->wr_tx_mask = NULL;
 	kfree(lnk->wr_tx_sges);
 	lnk->wr_tx_sges = NULL;
@@ -805,9 +799,7 @@ int smc_wr_alloc_link_mem(struct smc_link *link)
 				   GFP_KERNEL);
 	if (!link->wr_rx_sges)
 		goto no_mem_wr_tx_sges;
-	link->wr_tx_mask = kcalloc(BITS_TO_LONGS(SMC_WR_BUF_CNT),
-				   sizeof(*link->wr_tx_mask),
-				   GFP_KERNEL);
+	link->wr_tx_mask = bitmap_zalloc(SMC_WR_BUF_CNT, GFP_KERNEL);
 	if (!link->wr_tx_mask)
 		goto no_mem_wr_rx_sges;
 	link->wr_tx_pends = kcalloc(SMC_WR_BUF_CNT,
@@ -920,8 +912,7 @@ int smc_wr_create_link(struct smc_link *lnk)
 		goto dma_unmap;
 	}
 	smc_wr_init_sge(lnk);
-	memset(lnk->wr_tx_mask, 0,
-	       BITS_TO_LONGS(SMC_WR_BUF_CNT) * sizeof(*lnk->wr_tx_mask));
+	bitmap_zero(lnk->wr_tx_mask, SMC_WR_BUF_CNT);
 	init_waitqueue_head(&lnk->wr_tx_wait);
 	atomic_set(&lnk->wr_tx_refcnt, 0);
 	init_waitqueue_head(&lnk->wr_reg_wait);
-- 
2.32.0


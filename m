Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1287B17D6DB
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 23:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgCHWqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 18:46:14 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32837 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgCHWqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 18:46:13 -0400
Received: by mail-pg1-f193.google.com with SMTP id m5so3846112pgg.0
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 15:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a1VIuOcE2zPGBsUhFsZ6s3lMMsGSnpI8RoJUaMMeLO0=;
        b=KBh0urzvujpmrbh/Hca1B16XxXt2b8j9e86tsQksJvq++eNPmLw1ulGn2Lz7QVFaxt
         OBXpWf1tiRdyQIaaKZ6C2S1l/NLL7Zu0RFfcGfpNVFG/VB4sfPQEZ16f/KC4fnxT0/xg
         nB5cNIxHuBp6AuPrF6CQqIq5CP0Zh7mKeDT74=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a1VIuOcE2zPGBsUhFsZ6s3lMMsGSnpI8RoJUaMMeLO0=;
        b=JKRNgp6IS6rZ7SsGkfjPz7DJHDJzL2sgO64K/2CJCjiZ3XSh/DY/B4/4DaViorM9cH
         EF3DlDEyOWvneXAwITEv2RGJ8PFf1Q+UsmzJp88XESW3V5P9GbOEIw6pLHYyWsftsNKb
         yMxDC9fpgH2BeTi+RUZE2zWLv8M0Az4ZntUrTyTLNZHWAhCVvefS61WcU1iG5ih6j6KN
         yNntprsDm93VM2wI8bSKqW8Tj2XWAOWtTIxuwN99ogk+a9t2vF6Ni1YiJ8cEKOQh/8RJ
         u+bdB069hIcO9xPEJ3vrWbgtUG9UftAWoHuNVuCvX0V4Gq9W1M4/qR4VvMBwKDMU0ztj
         BwHA==
X-Gm-Message-State: ANhLgQ1Yb9e+YSK45dFqzpFLePrPbJVBkhlexJIHz/UOLCiUtEcmgeBY
        U5XbP2NNHeZTh/ngUPvON9DkhQ==
X-Google-Smtp-Source: ADFU+vuUng19IZI9LiE3w4eCzcFMOgI0uKUjnaeX/CyVGrcP0G71GhF7m7TzpswdonNu5DqUVkhB1Q==
X-Received: by 2002:a65:420b:: with SMTP id c11mr12935802pgq.297.1583707572374;
        Sun, 08 Mar 2020 15:46:12 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x66sm31241397pgb.9.2020.03.08.15.46.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Mar 2020 15:46:11 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 2/8] bnxt_en: Simplify __bnxt_poll_cqs_done().
Date:   Sun,  8 Mar 2020 18:45:48 -0400
Message-Id: <1583707554-1163-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
References: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the function by removing tha 'all' parameter.  In the current
code, the caller has to specify whether to update/arm both completion
rings with the 'all' parameter.

Instead of this, we can just update/arm all the completion rings
that have been polled.  By setting cpr->had_work_done earlier in
__bnxt_poll_work(), we know which completion ring has been polled
and can just update/arm all the completion rings with
cpr->had_work_done set.

This simplifies the function with one less parameter and works just
as well.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0b1af02..6b4f8d8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2162,6 +2162,7 @@ static int __bnxt_poll_work(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	struct tx_cmp *txcmp;
 
 	cpr->has_more_work = 0;
+	cpr->had_work_done = 1;
 	while (1) {
 		int rc;
 
@@ -2175,7 +2176,6 @@ static int __bnxt_poll_work(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		 * reading any further.
 		 */
 		dma_rmb();
-		cpr->had_work_done = 1;
 		if (TX_CMP_TYPE(txcmp) == CMP_TYPE_TX_L2_CMP) {
 			tx_pkts++;
 			/* return full budget so NAPI will complete. */
@@ -2392,7 +2392,7 @@ static int __bnxt_poll_cqs(struct bnxt *bp, struct bnxt_napi *bnapi, int budget)
 }
 
 static void __bnxt_poll_cqs_done(struct bnxt *bp, struct bnxt_napi *bnapi,
-				 u64 dbr_type, bool all)
+				 u64 dbr_type)
 {
 	struct bnxt_cp_ring_info *cpr = &bnapi->cp_ring;
 	int i;
@@ -2401,7 +2401,7 @@ static void __bnxt_poll_cqs_done(struct bnxt *bp, struct bnxt_napi *bnapi,
 		struct bnxt_cp_ring_info *cpr2 = cpr->cp_ring_arr[i];
 		struct bnxt_db_info *db;
 
-		if (cpr2 && (all || cpr2->had_work_done)) {
+		if (cpr2 && cpr2->had_work_done) {
 			db = &cpr2->cp_db;
 			writeq(db->db_key64 | dbr_type |
 			       RING_CMP(cpr2->cp_raw_cons), db->doorbell);
@@ -2425,10 +2425,10 @@ static int bnxt_poll_p5(struct napi_struct *napi, int budget)
 		cpr->has_more_work = 0;
 		work_done = __bnxt_poll_cqs(bp, bnapi, budget);
 		if (cpr->has_more_work) {
-			__bnxt_poll_cqs_done(bp, bnapi, DBR_TYPE_CQ, false);
+			__bnxt_poll_cqs_done(bp, bnapi, DBR_TYPE_CQ);
 			return work_done;
 		}
-		__bnxt_poll_cqs_done(bp, bnapi, DBR_TYPE_CQ_ARMALL, true);
+		__bnxt_poll_cqs_done(bp, bnapi, DBR_TYPE_CQ_ARMALL);
 		if (napi_complete_done(napi, work_done))
 			BNXT_DB_NQ_ARM_P5(&cpr->cp_db, cpr->cp_raw_cons);
 		return work_done;
@@ -2441,8 +2441,7 @@ static int bnxt_poll_p5(struct napi_struct *napi, int budget)
 			if (cpr->has_more_work)
 				break;
 
-			__bnxt_poll_cqs_done(bp, bnapi, DBR_TYPE_CQ_ARMALL,
-					     false);
+			__bnxt_poll_cqs_done(bp, bnapi, DBR_TYPE_CQ_ARMALL);
 			cpr->cp_raw_cons = raw_cons;
 			if (napi_complete_done(napi, work_done))
 				BNXT_DB_NQ_ARM_P5(&cpr->cp_db,
@@ -2468,7 +2467,7 @@ static int bnxt_poll_p5(struct napi_struct *napi, int budget)
 		}
 		raw_cons = NEXT_RAW_CMP(raw_cons);
 	}
-	__bnxt_poll_cqs_done(bp, bnapi, DBR_TYPE_CQ, true);
+	__bnxt_poll_cqs_done(bp, bnapi, DBR_TYPE_CQ);
 	cpr->cp_raw_cons = raw_cons;
 	return work_done;
 }
-- 
2.5.1


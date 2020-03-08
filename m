Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2E017D6DC
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 23:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgCHWqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 18:46:17 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36147 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgCHWqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 18:46:15 -0400
Received: by mail-pl1-f195.google.com with SMTP id g12so3206766plo.3
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 15:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ht+lVLqR0JOtpVmFVtttxBGVwdaxPMmwnMVgjM8Tyqc=;
        b=S7pFsA72S99m98/dBbQTn0LdqasXZ8dpdBXOAeYp9YuYo3v4ptWdHvsu/qE5bv4g0b
         4p+du4Eb9ulmCD+rusi8k59UgsbmXADvThBeeiSbIZHaOHxYvI9a9IzzB70VG0tbx3Re
         d2aHUYjhrul7ht19E+/cApGL4w43zsgjFrZQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ht+lVLqR0JOtpVmFVtttxBGVwdaxPMmwnMVgjM8Tyqc=;
        b=pHCbO5KHuO7gvI6NgHtVQby1LUVg2+z2P/E6VVzHLqgHHQ7NgWZz9XXjav2NO+Si8F
         V95QOMyfecetvyIb7iXehLoctr2LeElhFIMn4cZu+Z4w85thRnMZG7GCMTLrbigrDQdu
         FExazj+v+DGABUMcIMPVTzPL5X2CULZ/6qTza06t85HwQw0xvmC+ln3aTMQi3efx5ZGt
         CJY6TdImUOoaYEcVWvmdg6NC+9HTotsimHNU0NqTUPEjPWaDo0YsoQ6OOdNyBBJythRu
         eWRnm5kVA6OA5C4dASHKWPuvAyfWuroFT/Bv+0b/lGjaB+fiCvV40eCRIhdFkyBIN7y+
         ZdVA==
X-Gm-Message-State: ANhLgQ1K0028FfWnsNHQCNeAl0fCKGtfSiJCs04xKJ6S4pVmUle+t6pL
        hsuXo7yJa7+8zJ7HfAqzi5Rr+LwC9yI=
X-Google-Smtp-Source: ADFU+vtlvV1WhW+PV+3VXSyNyYYFSXsLFeaUXDvrNV5HqAZq9fzAkRoCrMP01GlYoqQPF2k4frkD4g==
X-Received: by 2002:a17:90a:5218:: with SMTP id v24mr15066449pjh.90.1583707574395;
        Sun, 08 Mar 2020 15:46:14 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x66sm31241397pgb.9.2020.03.08.15.46.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Mar 2020 15:46:13 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 3/8] bnxt_en: Process the NQ under NAPI continuous polling.
Date:   Sun,  8 Mar 2020 18:45:49 -0400
Message-Id: <1583707554-1163-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
References: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we are in continuous NAPI polling mode, the current code in
bnxt_poll_p5() will only process the completion rings and will not
process the NQ until interrupt is re-enabled.  Tis logic works and
will not cause RX or TX starvation, but async events in the NQ may
be delayed for the duration of continuous NAPI polling.  These
async events may be firmware or VF events.

Continue to handle the NQ after we are done polling the completion
rings.  This actually simplies the code in bnxt_poll_p5().

Acknowledge the NQ so these async events will not overflow.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6b4f8d8..634b1bd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2424,14 +2424,6 @@ static int bnxt_poll_p5(struct napi_struct *napi, int budget)
 	if (cpr->has_more_work) {
 		cpr->has_more_work = 0;
 		work_done = __bnxt_poll_cqs(bp, bnapi, budget);
-		if (cpr->has_more_work) {
-			__bnxt_poll_cqs_done(bp, bnapi, DBR_TYPE_CQ);
-			return work_done;
-		}
-		__bnxt_poll_cqs_done(bp, bnapi, DBR_TYPE_CQ_ARMALL);
-		if (napi_complete_done(napi, work_done))
-			BNXT_DB_NQ_ARM_P5(&cpr->cp_db, cpr->cp_raw_cons);
-		return work_done;
 	}
 	while (1) {
 		cons = RING_CMP(raw_cons);
@@ -2468,7 +2460,10 @@ static int bnxt_poll_p5(struct napi_struct *napi, int budget)
 		raw_cons = NEXT_RAW_CMP(raw_cons);
 	}
 	__bnxt_poll_cqs_done(bp, bnapi, DBR_TYPE_CQ);
-	cpr->cp_raw_cons = raw_cons;
+	if (raw_cons != cpr->cp_raw_cons) {
+		cpr->cp_raw_cons = raw_cons;
+		BNXT_DB_NQ_P5(&cpr->cp_db, raw_cons);
+	}
 	return work_done;
 }
 
-- 
2.5.1


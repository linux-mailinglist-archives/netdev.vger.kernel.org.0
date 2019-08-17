Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2DE3912ED
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 23:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfHQVFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 17:05:30 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35610 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbfHQVFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 17:05:30 -0400
Received: by mail-pf1-f193.google.com with SMTP id d85so4926326pfd.2
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 14:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ld2zvTsgyGkUhDtaBE5EUoFc0PKaDmy65nqinL919wk=;
        b=fm2JJI/6/0+qKpBOIdtkIOvbqLgRz4mWhCFVrAGLvWLLwNiv+KWK1h2p6B8EI8cO1E
         sz2z2soUCDtDXSEdU7cMrvvy/qiGfq4KwMTzff1bX7Vg/eq2cGAjYRvo9e3MaRIeRrDH
         NBOG70mkxg+RBUoxlHZVihfeOIDEggnQrMNfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ld2zvTsgyGkUhDtaBE5EUoFc0PKaDmy65nqinL919wk=;
        b=O7cm/FBScuukBAXEe91qOi41AJE7qj2YGKzRfa1z91WR2Zaa6dp2fFfSlkuyUCr1ql
         j64Q6YLBF4wzFu2muoJZ5qUrBHcWHSqLd6Ks5A71wrND3eLZ+FjmkC4DfcnR6tkjUzP8
         m4QotFdhM9C8CnBpmcySuf8AJfBEjGECLTKbigjrwIjUQcR81i0SUPzOTkcTpkoHqb6t
         hoMF85CaTmfHKe7MQSidFR61BiRfStz8TtFGQ9p03UcPxwE7l3oel3WjA+1lEDECIHQT
         k5smFBnA580Cd9KRZqkjgojuEZx3V+7P/FMkUN/vPCBbW4AR+N1ERcySfZK96CwdLOY7
         9vDw==
X-Gm-Message-State: APjAAAUduFt+kqx1XWL7wJ4oju8UMQzz4jI1gqyNcfHjTn3BKLhMI/y4
        N8R8+2ZJmoM70LRYySG/7aOSVd8LVkA=
X-Google-Smtp-Source: APXvYqyH5fNgGh5krB+fQGqsEcLD2Lj5Iw9UBRurJxEFHwMfqfuncZ4EC9xTpylzGiFklUc9g2RN0g==
X-Received: by 2002:aa7:8a0a:: with SMTP id m10mr17571398pfa.100.1566075929388;
        Sat, 17 Aug 2019 14:05:29 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e189sm9099295pgc.15.2019.08.17.14.05.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 14:05:29 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net v2 2/6] bnxt_en: Improve RX doorbell sequence.
Date:   Sat, 17 Aug 2019 17:04:48 -0400
Message-Id: <1566075892-30064-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566075892-30064-1-git-send-email-michael.chan@broadcom.com>
References: <1566075892-30064-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When both RX buffers and RX aggregation buffers have to be
replenished at the end of NAPI, post the RX aggregation buffers first
before RX buffers.  Otherwise, we may run into a situation where
there are only RX buffers without RX aggregation buffers for a split
second.  This will cause the hardware to abort the RX packet and
report buffer errors, which will cause unnecessary cleanup by the
driver.

Ringing the Aggregation ring doorbell first before the RX ring doorbell
will prevent some of these buffer errors.  Use the same sequence during
ring initialization as well.

Fixes: 697197e5a173 ("bnxt_en: Re-structure doorbells.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1ef224f..8dce406 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2021,9 +2021,9 @@ static void __bnxt_poll_work_done(struct bnxt *bp, struct bnxt_napi *bnapi)
 	if (bnapi->events & BNXT_RX_EVENT) {
 		struct bnxt_rx_ring_info *rxr = bnapi->rx_ring;
 
-		bnxt_db_write(bp, &rxr->rx_db, rxr->rx_prod);
 		if (bnapi->events & BNXT_AGG_EVENT)
 			bnxt_db_write(bp, &rxr->rx_agg_db, rxr->rx_agg_prod);
+		bnxt_db_write(bp, &rxr->rx_db, rxr->rx_prod);
 	}
 	bnapi->events = 0;
 }
@@ -5064,6 +5064,7 @@ static void bnxt_set_db(struct bnxt *bp, struct bnxt_db_info *db, u32 ring_type,
 
 static int bnxt_hwrm_ring_alloc(struct bnxt *bp)
 {
+	bool agg_rings = !!(bp->flags & BNXT_FLAG_AGG_RINGS);
 	int i, rc = 0;
 	u32 type;
 
@@ -5139,7 +5140,9 @@ static int bnxt_hwrm_ring_alloc(struct bnxt *bp)
 		if (rc)
 			goto err_out;
 		bnxt_set_db(bp, &rxr->rx_db, type, map_idx, ring->fw_ring_id);
-		bnxt_db_write(bp, &rxr->rx_db, rxr->rx_prod);
+		/* If we have agg rings, post agg buffers first. */
+		if (!agg_rings)
+			bnxt_db_write(bp, &rxr->rx_db, rxr->rx_prod);
 		bp->grp_info[map_idx].rx_fw_ring_id = ring->fw_ring_id;
 		if (bp->flags & BNXT_FLAG_CHIP_P5) {
 			struct bnxt_cp_ring_info *cpr = &bnapi->cp_ring;
@@ -5158,7 +5161,7 @@ static int bnxt_hwrm_ring_alloc(struct bnxt *bp)
 		}
 	}
 
-	if (bp->flags & BNXT_FLAG_AGG_RINGS) {
+	if (agg_rings) {
 		type = HWRM_RING_ALLOC_AGG;
 		for (i = 0; i < bp->rx_nr_rings; i++) {
 			struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
@@ -5174,6 +5177,7 @@ static int bnxt_hwrm_ring_alloc(struct bnxt *bp)
 			bnxt_set_db(bp, &rxr->rx_agg_db, type, map_idx,
 				    ring->fw_ring_id);
 			bnxt_db_write(bp, &rxr->rx_agg_db, rxr->rx_agg_prod);
+			bnxt_db_write(bp, &rxr->rx_db, rxr->rx_prod);
 			bp->grp_info[grp_idx].agg_fw_ring_id = ring->fw_ring_id;
 		}
 	}
-- 
2.5.1


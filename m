Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D21E90B05
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfHPWdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:33:52 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34836 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727761AbfHPWdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:33:51 -0400
Received: by mail-pg1-f195.google.com with SMTP id n4so3627276pgv.2
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 15:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ld2zvTsgyGkUhDtaBE5EUoFc0PKaDmy65nqinL919wk=;
        b=I4OrLixntTQU21RB5T6i0aRTKmTK/JatLUnx3lDObVZpOmGX3fDlteP6/Mh7F4yHnE
         oBmhwtWbqTOu/oKXp81woOeAN2MX6bDV8dGTK3YPHimKi9uMGyJMzyVZLsATWt3gM7cF
         35vWruYoXh3HTWpXi0x8gfORi/VttBnTGZpOY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ld2zvTsgyGkUhDtaBE5EUoFc0PKaDmy65nqinL919wk=;
        b=N68H1BKRCl2n4bR2HlVGz3v1DQ3NOmAIl6yHmSAi5X3CBXhgSv1LFO/wks2pa4bpjc
         Gxp5D7BqGw/McthkFO3kDOuJIxxe6JppkkBt1/AqBANcjocsaLev9gWPQKuA8X3uwOUs
         OFGU4ChlYJ2OPptWytWYRcvyRsccDA1Cry68gof0whOfiGJ28QswDkIGPZquDgt9qo/X
         6kPzyByeiMyuR4QGZWshGQUzfmyKtus6ztRJg1sYTwRCwQLQL7IBmsoXTHm4FKpxV4i1
         7V5UOso7c+xKroRDUChC+dLVdWLBZEXjPGFqfOtAAm8dZPdi7Xfa7c2vR9me9QV/7NI7
         JPRw==
X-Gm-Message-State: APjAAAVqRs5fnGSFmz64TYKiuEmgmqjyzNYMK/73gZtjeKg8OvtVr89j
        YkmHLU8Cxe2h13KUEIRYTxi6iQPv9AU=
X-Google-Smtp-Source: APXvYqyTZLwgYYikIIaNsUjrInwjbJjaYatGYE69SMPppLXG3IsTDk4HZyBgiO59e6E4Nw/wlx1i0Q==
X-Received: by 2002:a63:69c1:: with SMTP id e184mr9215030pgc.198.1565994830529;
        Fri, 16 Aug 2019 15:33:50 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o35sm5728404pgm.29.2019.08.16.15.33.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 15:33:49 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 2/6] bnxt_en: Improve RX doorbell sequence.
Date:   Fri, 16 Aug 2019 18:33:33 -0400
Message-Id: <1565994817-6328-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1565994817-6328-1-git-send-email-michael.chan@broadcom.com>
References: <1565994817-6328-1-git-send-email-michael.chan@broadcom.com>
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


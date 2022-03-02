Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C7D4CB160
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 22:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244306AbiCBVf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 16:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245307AbiCBVfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 16:35:50 -0500
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4884B40A
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 13:35:05 -0800 (PST)
Received: (qmail 50817 invoked by uid 89); 2 Mar 2022 21:35:04 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 2 Mar 2022 21:35:04 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel-team@fb.com
Subject: [PATCH net-next 4/5] ptp: ocp: adjust utc_tai_offset to TOD info
Date:   Wed,  2 Mar 2022 13:34:58 -0800
Message-Id: <20220302213459.6565-5-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220302213459.6565-1-jonathan.lemon@gmail.com>
References: <20220302213459.6565-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

utc_tai_offset is used to correct IRIG, DCF and NMEA outputs and is
set during initialisation but is not corrected during leap second
announce event.  Add watchdog code to control this correction.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 51 ++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 2a3384c9e3b8..608d1a0eb141 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -762,12 +762,31 @@ __ptp_ocp_clear_drift_locked(struct ptp_ocp *bp)
 	iowrite32(select >> 16, &bp->reg->select);
 }
 
+static void
+ptp_ocp_utc_distribute(struct ptp_ocp *bp, u32 val)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&bp->lock, flags);
+
+	bp->utc_tai_offset = val;
+
+	if (bp->irig_out)
+		iowrite32(val, &bp->irig_out->adj_sec);
+	if (bp->dcf_out)
+		iowrite32(val, &bp->dcf_out->adj_sec);
+	if (bp->nmea_out)
+		iowrite32(val, &bp->nmea_out->adj_sec);
+
+	spin_unlock_irqrestore(&bp->lock, flags);
+}
+
 static void
 ptp_ocp_watchdog(struct timer_list *t)
 {
 	struct ptp_ocp *bp = from_timer(bp, t, watchdog);
 	unsigned long flags;
-	u32 status;
+	u32 status, utc_offset;
 
 	status = ioread32(&bp->pps_to_clk->status);
 
@@ -784,6 +803,17 @@ ptp_ocp_watchdog(struct timer_list *t)
 		bp->gnss_lost = 0;
 	}
 
+	/* if GNSS provides correct data we can rely on
+	 * it to get leap second information
+	 */
+	if (bp->tod) {
+		status = ioread32(&bp->tod->utc_status);
+		utc_offset = status & TOD_STATUS_UTC_MASK;
+		if (status & TOD_STATUS_UTC_VALID &&
+		    utc_offset != bp->utc_tai_offset)
+			ptp_ocp_utc_distribute(bp, utc_offset);
+	}
+
 	mod_timer(&bp->watchdog, jiffies + HZ);
 }
 
@@ -852,25 +882,6 @@ ptp_ocp_init_clock(struct ptp_ocp *bp)
 	return 0;
 }
 
-static void
-ptp_ocp_utc_distribute(struct ptp_ocp *bp, u32 val)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&bp->lock, flags);
-
-	bp->utc_tai_offset = val;
-
-	if (bp->irig_out)
-		iowrite32(val, &bp->irig_out->adj_sec);
-	if (bp->dcf_out)
-		iowrite32(val, &bp->dcf_out->adj_sec);
-	if (bp->nmea_out)
-		iowrite32(val, &bp->nmea_out->adj_sec);
-
-	spin_unlock_irqrestore(&bp->lock, flags);
-}
-
 static void
 ptp_ocp_tod_init(struct ptp_ocp *bp)
 {
-- 
2.31.1


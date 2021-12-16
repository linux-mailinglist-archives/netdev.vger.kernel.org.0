Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF3C477D16
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241228AbhLPUHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:07:50 -0500
Received: from smtp4.emailarray.com ([65.39.216.22]:42990 "EHLO
        smtp4.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241099AbhLPUHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:07:49 -0500
Received: (qmail 25499 invoked by uid 89); 16 Dec 2021 20:01:08 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 16 Dec 2021 20:01:08 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     kernel-team@fb.com
Subject: [PATCH 4/5] ptp: ocp: adjust utc_tai_offset to TOD info
Date:   Thu, 16 Dec 2021 12:01:03 -0800
Message-Id: <20211216200104.266433-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216200104.266433-1-jonathan.lemon@gmail.com>
References: <20211216200104.266433-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

utc_tai_offset is used to correct IRIG, DCF and NMEA outputs and is
set during initialisation but is not corrected during leap second
announce event. Add watchdog code to control this correction.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 51 ++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 2383d1024f0f..dc4d07b04320 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -761,12 +761,31 @@ __ptp_ocp_clear_drift_locked(struct ptp_ocp *bp)
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
 
@@ -783,6 +802,17 @@ ptp_ocp_watchdog(struct timer_list *t)
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
 
@@ -851,25 +881,6 @@ ptp_ocp_init_clock(struct ptp_ocp *bp)
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


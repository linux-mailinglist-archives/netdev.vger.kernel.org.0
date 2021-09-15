Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9611640BDA6
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236295AbhIOCS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:26 -0400
Received: from smtp6.emailarray.com ([65.39.216.46]:34565 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235899AbhIOCSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:18:15 -0400
Received: (qmail 28574 invoked by uid 89); 15 Sep 2021 02:16:56 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 15 Sep 2021 02:16:56 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 16/18] ptp: ocp: Have FPGA fold in ns adjustment for adjtime.
Date:   Tue, 14 Sep 2021 19:16:34 -0700
Message-Id: <20210915021636.153754-17-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current implementation of adjtime uses gettime/settime to
perform nanosecond adjustments.  This introduces addtional phase
errors due to delays.

Instead, use the FPGA's ability to just apply the nanosecond
adjustment to the clock directly.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index be8ab727a4ef..e6779a712bbb 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -594,9 +594,6 @@ ptp_ocp_settime(struct ptp_clock_info *ptp_info, const struct timespec64 *ts)
 	struct ptp_ocp *bp = container_of(ptp_info, struct ptp_ocp, ptp_info);
 	unsigned long flags;
 
-	if (ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC)
-		return 0;
-
 	spin_lock_irqsave(&bp->lock, flags);
 	__ptp_ocp_settime_locked(bp, ts);
 	spin_unlock_irqrestore(&bp->lock, flags);
@@ -604,26 +601,39 @@ ptp_ocp_settime(struct ptp_clock_info *ptp_info, const struct timespec64 *ts)
 	return 0;
 }
 
+static void
+__ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u64 adj_val)
+{
+	u32 select, ctrl;
+
+	select = ioread32(&bp->reg->select);
+	iowrite32(OCP_SELECT_CLK_REG, &bp->reg->select);
+
+	iowrite32(adj_val, &bp->reg->offset_ns);
+	iowrite32(adj_val & 0x7f, &bp->reg->offset_window_ns);
+
+	ctrl = OCP_CTRL_ADJUST_OFFSET | OCP_CTRL_ENABLE;
+	iowrite32(ctrl, &bp->reg->ctrl);
+
+	/* restore clock selection */
+	iowrite32(select >> 16, &bp->reg->select);
+}
+
 static int
 ptp_ocp_adjtime(struct ptp_clock_info *ptp_info, s64 delta_ns)
 {
 	struct ptp_ocp *bp = container_of(ptp_info, struct ptp_ocp, ptp_info);
-	struct timespec64 ts;
 	unsigned long flags;
-	int err;
+	u32 adj_ns, sign;
 
-	if (ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC)
-		return 0;
+	sign = delta_ns < 0 ? BIT(31) : 0;
+	adj_ns = sign ? -delta_ns : delta_ns;
 
 	spin_lock_irqsave(&bp->lock, flags);
-	err = __ptp_ocp_gettime_locked(bp, &ts, NULL);
-	if (likely(!err)) {
-		timespec64_add_ns(&ts, delta_ns);
-		__ptp_ocp_settime_locked(bp, &ts);
-	}
+	__ptp_ocp_adjtime_locked(bp, sign | adj_ns);
 	spin_unlock_irqrestore(&bp->lock, flags);
 
-	return err;
+	return 0;
 }
 
 static int
@@ -636,7 +646,7 @@ ptp_ocp_null_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
 }
 
 static int
-ptp_ocp_adjphase(struct ptp_clock_info *ptp_info, s32 phase_ns)
+ptp_ocp_null_adjphase(struct ptp_clock_info *ptp_info, s32 phase_ns)
 {
 	return -EOPNOTSUPP;
 }
@@ -699,7 +709,7 @@ static const struct ptp_clock_info ptp_ocp_clock_info = {
 	.settime64	= ptp_ocp_settime,
 	.adjtime	= ptp_ocp_adjtime,
 	.adjfine	= ptp_ocp_null_adjfine,
-	.adjphase	= ptp_ocp_adjphase,
+	.adjphase	= ptp_ocp_null_adjphase,
 	.enable		= ptp_ocp_enable,
 	.pps		= true,
 	.n_ext_ts	= 4,
-- 
2.31.1


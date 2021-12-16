Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D45D477D13
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238729AbhLPUHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:07:46 -0500
Received: from smtp8.emailarray.com ([65.39.216.67]:57063 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233367AbhLPUHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:07:46 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Dec 2021 15:07:45 EST
Received: (qmail 80993 invoked by uid 89); 16 Dec 2021 20:01:05 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 16 Dec 2021 20:01:05 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     kernel-team@fb.com
Subject: [PATCH 1/5] ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments
Date:   Thu, 16 Dec 2021 12:01:00 -0800
Message-Id: <20211216200104.266433-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ("ptp: ocp: Have FPGA fold in ns adjustment for adjtime."), the
ns adjustment was written to the FPGA register, so the clock could
accurately perform adjustments.

However, the adjtime() call passes in a s64, while the clock adjustment
registers use a s32.  When trying to perform adjustments with a large
value (37 sec), things fail.

Examine the incoming delta, and if larger than 1 sec, use the original
(coarse) adjustment method.  If smaller than 1 sec, then allow the
FPGA to fold in the changes over a 1 second window.

Fixes: 2d97ed56f671 ("ptp: ocp: Have FPGA fold in ns adjustment for adjtime.")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 0f1b5a7d2a89..17ad5f0d13b2 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -607,7 +607,7 @@ ptp_ocp_settime(struct ptp_clock_info *ptp_info, const struct timespec64 *ts)
 }
 
 static void
-__ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u64 adj_val)
+__ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u32 adj_val)
 {
 	u32 select, ctrl;
 
@@ -615,7 +615,7 @@ __ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u64 adj_val)
 	iowrite32(OCP_SELECT_CLK_REG, &bp->reg->select);
 
 	iowrite32(adj_val, &bp->reg->offset_ns);
-	iowrite32(adj_val & 0x7f, &bp->reg->offset_window_ns);
+	iowrite32(NSEC_PER_SEC, &bp->reg->offset_window_ns);
 
 	ctrl = OCP_CTRL_ADJUST_OFFSET | OCP_CTRL_ENABLE;
 	iowrite32(ctrl, &bp->reg->ctrl);
@@ -624,6 +624,22 @@ __ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u64 adj_val)
 	iowrite32(select >> 16, &bp->reg->select);
 }
 
+static void
+ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, u64 delta_ns)
+{
+	struct timespec64 ts;
+	unsigned long flags;
+	int err;
+
+	spin_lock_irqsave(&bp->lock, flags);
+	err = __ptp_ocp_gettime_locked(bp, &ts, NULL);
+	if (likely(!err)) {
+		timespec64_add_ns(&ts, delta_ns);
+		__ptp_ocp_settime_locked(bp, &ts);
+	}
+	spin_unlock_irqrestore(&bp->lock, flags);
+}
+
 static int
 ptp_ocp_adjtime(struct ptp_clock_info *ptp_info, s64 delta_ns)
 {
@@ -631,6 +647,11 @@ ptp_ocp_adjtime(struct ptp_clock_info *ptp_info, s64 delta_ns)
 	unsigned long flags;
 	u32 adj_ns, sign;
 
+	if (delta_ns > NSEC_PER_SEC || -delta_ns > NSEC_PER_SEC) {
+		ptp_ocp_adjtime_coarse(bp, delta_ns);
+		return 0;
+	}
+
 	sign = delta_ns < 0 ? BIT(31) : 0;
 	adj_ns = sign ? -delta_ns : delta_ns;
 
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D164C7ADE
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 21:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiB1UrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 15:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiB1UrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 15:47:20 -0500
X-Greylist: delayed 398 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Feb 2022 12:46:39 PST
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD74F5F92
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 12:46:38 -0800 (PST)
Received: (qmail 9617 invoked by uid 89); 28 Feb 2022 20:39:58 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 28 Feb 2022 20:39:58 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next] ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments
Date:   Mon, 28 Feb 2022 12:39:57 -0800
Message-Id: <20220228203957.367371-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

Fixes: 6d59d4fa1789 ("ptp: ocp: Have FPGA fold in ns adjustment for adjtime.")
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


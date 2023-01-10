Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3568663F40
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjAJLbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbjAJLaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 06:30:35 -0500
Received: from inva021.nxp.com (inva021.nxp.com [92.121.34.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE65C48CE2;
        Tue, 10 Jan 2023 03:30:28 -0800 (PST)
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 56AB2200230;
        Tue, 10 Jan 2023 12:30:27 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1F6FD2001EE;
        Tue, 10 Jan 2023 12:30:27 +0100 (CET)
Received: from lsv03267.swis.in-blr01.nxp.com (lsv03267.swis.in-blr01.nxp.com [92.120.147.107])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 23BCB180031E;
        Tue, 10 Jan 2023 19:30:26 +0800 (+08)
From:   nikhil.gupta@nxp.com
To:     linux-arm-kernel@lists.infradead.org,
        Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vakul.garg@nxp.com, rajan.gupta@nxp.com,
        Nikhil Gupta <nikhil.gupta@nxp.com>
Subject: [PATCH] ptp_qoriq: fix latency in ptp_qoriq_adjtime() operation.
Date:   Tue, 10 Jan 2023 17:00:24 +0530
Message-Id: <20230110113024.7558-1-nikhil.gupta@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikhil Gupta <nikhil.gupta@nxp.com>

1588 driver loses about 1us in adjtime operation at PTP slave.
This is because adjtime operation uses a slow non-atomic tmr_cnt_read()
followed by tmr_cnt_write() operation.
In the above sequence, since the timer counter operation loses about 1us.
Instead, tmr_offset register should be programmed with the delta
nanoseconds This won't lead to timer counter stopping and losing time
while tmr_cnt_write() is being done.
This Patch adds api for tmr_offset_read/write to program the
delta nanoseconds in the Timer offset Register.

Signed-off-by: Nikhil Gupta <nikhil.gupta@nxp.com>
Reviewed-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/ptp/ptp_qoriq.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index 08f4cf0ad9e3..5b6ea6d590be 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -48,6 +48,29 @@ static void tmr_cnt_write(struct ptp_qoriq *ptp_qoriq, u64 ns)
 	ptp_qoriq->write(&regs->ctrl_regs->tmr_cnt_h, hi);
 }
 
+static void tmr_offset_write(struct ptp_qoriq *ptp_qoriq, u64 delta_ns)
+{
+	struct ptp_qoriq_registers *regs = &ptp_qoriq->regs;
+	u32 hi = delta_ns >> 32;
+	u32 lo = delta_ns & 0xffffffff;
+
+	ptp_qoriq->write(&regs->ctrl_regs->tmroff_l, lo);
+	ptp_qoriq->write(&regs->ctrl_regs->tmroff_h, hi);
+}
+
+static u64 tmr_offset_read(struct ptp_qoriq *ptp_qoriq)
+{
+	struct ptp_qoriq_registers *regs = &ptp_qoriq->regs;
+	u64 ns;
+	u32 lo, hi;
+
+	lo = ptp_qoriq->read(&regs->ctrl_regs->tmroff_l);
+	hi = ptp_qoriq->read(&regs->ctrl_regs->tmroff_h);
+	ns = ((u64) hi) << 32;
+	ns |= lo;
+	return ns;
+}
+
 /* Caller must hold ptp_qoriq->lock. */
 static void set_alarm(struct ptp_qoriq *ptp_qoriq)
 {
@@ -55,7 +78,9 @@ static void set_alarm(struct ptp_qoriq *ptp_qoriq)
 	u64 ns;
 	u32 lo, hi;
 
-	ns = tmr_cnt_read(ptp_qoriq) + 1500000000ULL;
+	ns = tmr_cnt_read(ptp_qoriq) + tmr_offset_read(ptp_qoriq)
+				     + 1500000000ULL;
+
 	ns = div_u64(ns, 1000000000UL) * 1000000000ULL;
 	ns -= ptp_qoriq->tclk_period;
 	hi = ns >> 32;
@@ -207,15 +232,12 @@ EXPORT_SYMBOL_GPL(ptp_qoriq_adjfine);
 
 int ptp_qoriq_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
-	s64 now;
 	unsigned long flags;
 	struct ptp_qoriq *ptp_qoriq = container_of(ptp, struct ptp_qoriq, caps);
 
 	spin_lock_irqsave(&ptp_qoriq->lock, flags);
 
-	now = tmr_cnt_read(ptp_qoriq);
-	now += delta;
-	tmr_cnt_write(ptp_qoriq, now);
+	tmr_offset_write(ptp_qoriq, delta);
 	set_fipers(ptp_qoriq);
 
 	spin_unlock_irqrestore(&ptp_qoriq->lock, flags);
@@ -232,7 +254,7 @@ int ptp_qoriq_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 
 	spin_lock_irqsave(&ptp_qoriq->lock, flags);
 
-	ns = tmr_cnt_read(ptp_qoriq);
+	ns = tmr_cnt_read(ptp_qoriq) + tmr_offset_read(ptp_qoriq);
 
 	spin_unlock_irqrestore(&ptp_qoriq->lock, flags);
 
@@ -251,6 +273,8 @@ int ptp_qoriq_settime(struct ptp_clock_info *ptp,
 
 	ns = timespec64_to_ns(ts);
 
+	tmr_offset_write(ptp_qoriq, 0);
+
 	spin_lock_irqsave(&ptp_qoriq->lock, flags);
 
 	tmr_cnt_write(ptp_qoriq, ns);
-- 
2.17.1


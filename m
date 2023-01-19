Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0F167439A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 21:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjASUlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 15:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjASUkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 15:40:55 -0500
Received: from inva021.nxp.com (inva021.nxp.com [92.121.34.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC34190845;
        Thu, 19 Jan 2023 12:40:38 -0800 (PST)
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 6A365201829;
        Thu, 19 Jan 2023 21:40:37 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 081172017ED;
        Thu, 19 Jan 2023 21:40:37 +0100 (CET)
Received: from lsv03267.swis.in-blr01.nxp.com (lsv03267.swis.in-blr01.nxp.com [92.120.147.107])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id EBCB6180327D;
        Fri, 20 Jan 2023 04:40:35 +0800 (+08)
From:   nikhil.gupta@nxp.com
To:     linux-arm-kernel@lists.infradead.org,
        Yangbo Lu <yangbo.lu@nxp.com>, vladimir.oltean@nxp.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vakul.garg@nxp.com, rajan.gupta@nxp.com,
        Nikhil Gupta <nikhil.gupta@nxp.com>
Subject: [PATCH v2] ptp_qoriq: fix latency in ptp_qoriq_adjtime() operation
Date:   Fri, 20 Jan 2023 02:10:34 +0530
Message-Id: <20230119204034.7969-1-nikhil.gupta@nxp.com>
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

1588 driver loses about 1us in adjtime operation at PTP slave
This is because adjtime operation uses a slow non-atomic tmr_cnt_read()
followed by tmr_cnt_write() operation.

In the above sequence, since the timer counter operation keeps
incrementing, it leads to latency. The tmr_offset register
(which is added to TMR_CNT_H/L register giving the current time)
must be programmed with the delta nanoseconds.

Signed-off-by: Nikhil Gupta <nikhil.gupta@nxp.com>
---
v1->v2: prevent TMR_OFF adjustment in case of eTSEC

 drivers/ptp/ptp_qoriq.c       | 50 ++++++++++++++++++++++++++++++-----
 include/linux/fsl/ptp_qoriq.h |  1 +
 2 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index 08f4cf0ad9e3..61530167efe4 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -48,6 +48,29 @@ static void tmr_cnt_write(struct ptp_qoriq *ptp_qoriq, u64 ns)
 	ptp_qoriq->write(&regs->ctrl_regs->tmr_cnt_h, hi);
 }
 
+static u64 tmr_offset_read(struct ptp_qoriq *ptp_qoriq)
+{
+	struct ptp_qoriq_registers *regs = &ptp_qoriq->regs;
+	u32 lo, hi;
+	u64 ns;
+
+	lo = ptp_qoriq->read(&regs->ctrl_regs->tmroff_l);
+	hi = ptp_qoriq->read(&regs->ctrl_regs->tmroff_h);
+	ns = ((u64) hi) << 32;
+	ns |= lo;
+	return ns;
+}
+
+static void tmr_offset_write(struct ptp_qoriq *ptp_qoriq, u64 delta_ns)
+{
+	struct ptp_qoriq_registers *regs = &ptp_qoriq->regs;
+	u32 lo = delta_ns & 0xffffffff;
+	u32 hi = delta_ns >> 32;
+
+	ptp_qoriq->write(&regs->ctrl_regs->tmroff_l, lo);
+	ptp_qoriq->write(&regs->ctrl_regs->tmroff_h, hi);
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
@@ -207,15 +232,24 @@ EXPORT_SYMBOL_GPL(ptp_qoriq_adjfine);
 
 int ptp_qoriq_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
-	s64 now;
-	unsigned long flags;
 	struct ptp_qoriq *ptp_qoriq = container_of(ptp, struct ptp_qoriq, caps);
+	s64 now, curr_delta;
+	unsigned long flags;
 
 	spin_lock_irqsave(&ptp_qoriq->lock, flags);
 
-	now = tmr_cnt_read(ptp_qoriq);
-	now += delta;
-	tmr_cnt_write(ptp_qoriq, now);
+	/* On LS1021A, eTSEC2 and eTSEC3 do not take into account the TMR_OFF
+	 * adjustment
+	 */
+	if (ptp_qoriq->etsec) {
+		now = tmr_cnt_read(ptp_qoriq);
+		now += delta;
+		tmr_cnt_write(ptp_qoriq, now);
+	} else {
+		curr_delta = tmr_offset_read(ptp_qoriq);
+		curr_delta += delta;
+		tmr_offset_write(ptp_qoriq, curr_delta);
+	}
 	set_fipers(ptp_qoriq);
 
 	spin_unlock_irqrestore(&ptp_qoriq->lock, flags);
@@ -232,7 +266,7 @@ int ptp_qoriq_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 
 	spin_lock_irqsave(&ptp_qoriq->lock, flags);
 
-	ns = tmr_cnt_read(ptp_qoriq);
+	ns = tmr_cnt_read(ptp_qoriq) + tmr_offset_read(ptp_qoriq);
 
 	spin_unlock_irqrestore(&ptp_qoriq->lock, flags);
 
@@ -253,6 +287,7 @@ int ptp_qoriq_settime(struct ptp_clock_info *ptp,
 
 	spin_lock_irqsave(&ptp_qoriq->lock, flags);
 
+	tmr_offset_write(ptp_qoriq, 0);
 	tmr_cnt_write(ptp_qoriq, ns);
 	set_fipers(ptp_qoriq);
 
@@ -488,6 +523,7 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq, void __iomem *base,
 
 	/* The eTSEC uses differnt memory map with DPAA/ENETC */
 	if (of_device_is_compatible(node, "fsl,etsec-ptp")) {
+		ptp_qoriq->etsec = true;
 		ptp_qoriq->regs.ctrl_regs = base + ETSEC_CTRL_REGS_OFFSET;
 		ptp_qoriq->regs.alarm_regs = base + ETSEC_ALARM_REGS_OFFSET;
 		ptp_qoriq->regs.fiper_regs = base + ETSEC_FIPER_REGS_OFFSET;
diff --git a/include/linux/fsl/ptp_qoriq.h b/include/linux/fsl/ptp_qoriq.h
index 01acebe37fab..b301bf7199d3 100644
--- a/include/linux/fsl/ptp_qoriq.h
+++ b/include/linux/fsl/ptp_qoriq.h
@@ -149,6 +149,7 @@ struct ptp_qoriq {
 	struct device *dev;
 	bool extts_fifo_support;
 	bool fiper3_support;
+	bool etsec;
 	int irq;
 	int phc_index;
 	u32 tclk_period;  /* nanoseconds */
-- 
2.17.1


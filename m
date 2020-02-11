Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2CF6158948
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 05:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgBKEzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 23:55:17 -0500
Received: from inva020.nxp.com ([92.121.34.13]:54212 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbgBKEzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 23:55:17 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D7EEE1C30E6;
        Tue, 11 Feb 2020 05:55:14 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id BF1EF1C30DE;
        Tue, 11 Feb 2020 05:55:12 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id BD9C34029B;
        Tue, 11 Feb 2020 12:55:09 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH] ptp_qoriq: drop the code of alarm
Date:   Tue, 11 Feb 2020 12:52:49 +0800
Message-Id: <20200211045249.8150-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The alarm function hadn't been supported by PTP clock driver.
The recommended solution PHC + phc2sys + nanosleep provides
best performance. So drop the code of alarm in ptp_qoriq driver.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/ptp/ptp_qoriq.c       | 29 +----------------------------
 include/linux/fsl/ptp_qoriq.h |  2 --
 2 files changed, 1 insertion(+), 30 deletions(-)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index 66e7d57..315c454 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -131,8 +131,7 @@ irqreturn_t ptp_qoriq_isr(int irq, void *priv)
 	struct ptp_qoriq *ptp_qoriq = priv;
 	struct ptp_qoriq_registers *regs = &ptp_qoriq->regs;
 	struct ptp_clock_event event;
-	u64 ns;
-	u32 ack = 0, lo, hi, mask, val, irqs;
+	u32 ack = 0, mask, val, irqs;
 
 	spin_lock(&ptp_qoriq->lock);
 
@@ -153,32 +152,6 @@ irqreturn_t ptp_qoriq_isr(int irq, void *priv)
 		extts_clean_up(ptp_qoriq, 1, true);
 	}
 
-	if (irqs & ALM2) {
-		ack |= ALM2;
-		if (ptp_qoriq->alarm_value) {
-			event.type = PTP_CLOCK_ALARM;
-			event.index = 0;
-			event.timestamp = ptp_qoriq->alarm_value;
-			ptp_clock_event(ptp_qoriq->clock, &event);
-		}
-		if (ptp_qoriq->alarm_interval) {
-			ns = ptp_qoriq->alarm_value + ptp_qoriq->alarm_interval;
-			hi = ns >> 32;
-			lo = ns & 0xffffffff;
-			ptp_qoriq->write(&regs->alarm_regs->tmr_alarm2_l, lo);
-			ptp_qoriq->write(&regs->alarm_regs->tmr_alarm2_h, hi);
-			ptp_qoriq->alarm_value = ns;
-		} else {
-			spin_lock(&ptp_qoriq->lock);
-			mask = ptp_qoriq->read(&regs->ctrl_regs->tmr_temask);
-			mask &= ~ALM2EN;
-			ptp_qoriq->write(&regs->ctrl_regs->tmr_temask, mask);
-			spin_unlock(&ptp_qoriq->lock);
-			ptp_qoriq->alarm_value = 0;
-			ptp_qoriq->alarm_interval = 0;
-		}
-	}
-
 	if (irqs & PP1) {
 		ack |= PP1;
 		event.type = PTP_CLOCK_PPS;
diff --git a/include/linux/fsl/ptp_qoriq.h b/include/linux/fsl/ptp_qoriq.h
index b0b7435..7588456 100644
--- a/include/linux/fsl/ptp_qoriq.h
+++ b/include/linux/fsl/ptp_qoriq.h
@@ -149,8 +149,6 @@ struct ptp_qoriq {
 	bool extts_fifo_support;
 	int irq;
 	int phc_index;
-	u64 alarm_interval; /* for periodic alarm */
-	u64 alarm_value;
 	u32 tclk_period;  /* nanoseconds */
 	u32 tmr_prsc;
 	u32 tmr_add;
-- 
2.7.4


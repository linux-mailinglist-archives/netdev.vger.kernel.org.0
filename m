Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2913111CA42
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 11:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbfLLKI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 05:08:58 -0500
Received: from inva020.nxp.com ([92.121.34.13]:44778 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbfLLKI6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 05:08:58 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 147F91A10EC;
        Thu, 12 Dec 2019 11:08:56 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DC2441A06BA;
        Thu, 12 Dec 2019 11:08:53 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id CA2A9402C7;
        Thu, 12 Dec 2019 18:08:50 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH 1/3] ptp_qoriq: check valid status before reading extts fifo
Date:   Thu, 12 Dec 2019 18:08:04 +0800
Message-Id: <20191212100806.17447-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212100806.17447-1-yangbo.lu@nxp.com>
References: <20191212100806.17447-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For PTP timer supporting external trigger timestamp FIFO,
there is a valid bit in TMR_STAT register indicating the
timestamp is available. For PTP timer without FIFO, there
is not TMR_STAT register.
This patch is to check the valid bit for the FIFO before
reading timestamp, and to avoid operating TMR_STAT register
for PTP timer without the FIFO.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/ptp/ptp_qoriq.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index a577218..a3062cd 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -81,7 +81,7 @@ static int extts_clean_up(struct ptp_qoriq *ptp_qoriq, int index,
 	struct ptp_clock_event event;
 	void __iomem *reg_etts_l;
 	void __iomem *reg_etts_h;
-	u32 valid, stat, lo, hi;
+	u32 valid, lo, hi;
 
 	switch (index) {
 	case 0:
@@ -101,6 +101,10 @@ static int extts_clean_up(struct ptp_qoriq *ptp_qoriq, int index,
 	event.type = PTP_CLOCK_EXTTS;
 	event.index = index;
 
+	if (ptp_qoriq->extts_fifo_support)
+		if (!(ptp_qoriq->read(&regs->ctrl_regs->tmr_stat) & valid))
+			return 0;
+
 	do {
 		lo = ptp_qoriq->read(reg_etts_l);
 		hi = ptp_qoriq->read(reg_etts_h);
@@ -111,8 +115,9 @@ static int extts_clean_up(struct ptp_qoriq *ptp_qoriq, int index,
 			ptp_clock_event(ptp_qoriq->clock, &event);
 		}
 
-		stat = ptp_qoriq->read(&regs->ctrl_regs->tmr_stat);
-	} while (ptp_qoriq->extts_fifo_support && (stat & valid));
+		if (!ptp_qoriq->extts_fifo_support)
+			break;
+	} while (ptp_qoriq->read(&regs->ctrl_regs->tmr_stat) & valid);
 
 	return 0;
 }
-- 
2.7.4


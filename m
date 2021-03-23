Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6381134591E
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 08:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhCWHzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 03:55:53 -0400
Received: from inva021.nxp.com ([92.121.34.21]:58586 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229452AbhCWHzW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 03:55:22 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E54F820026B;
        Tue, 23 Mar 2021 08:55:21 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3A846200201;
        Tue, 23 Mar 2021 08:55:20 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id A62DD402BB;
        Tue, 23 Mar 2021 08:55:17 +0100 (CET)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH] ptp_qoriq: fix overflow in ptp_qoriq_adjfine() u64 calcalation
Date:   Tue, 23 Mar 2021 16:02:29 +0800
Message-Id: <20210323080229.28283-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current calculation for diff of TMR_ADD register value may have
64-bit overflow in this code line, when long type scaled_ppm is
large.

adj *= scaled_ppm;

This patch is to resolve it by using mul_u64_u64_div_u64().

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/ptp/ptp_qoriq.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index 68beb1bd07c0..f7f220700cb5 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -189,15 +189,16 @@ int ptp_qoriq_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	tmr_add = ptp_qoriq->tmr_add;
 	adj = tmr_add;
 
-	/* calculate diff as adj*(scaled_ppm/65536)/1000000
-	 * and round() to the nearest integer
+	/*
+	 * Calculate diff and round() to the nearest integer
+	 *
+	 * diff = adj * (ppb / 1000000000)
+	 *      = adj * scaled_ppm / 65536000000
 	 */
-	adj *= scaled_ppm;
-	diff = div_u64(adj, 8000000);
-	diff = (diff >> 13) + ((diff >> 12) & 1);
+	diff = mul_u64_u64_div_u64(adj, scaled_ppm, 32768000000);
+	diff = DIV64_U64_ROUND_UP(diff, 2);
 
 	tmr_add = neg_adj ? tmr_add - diff : tmr_add + diff;
-
 	ptp_qoriq->write(&regs->ctrl_regs->tmr_add, tmr_add);
 
 	return 0;
-- 
2.25.1


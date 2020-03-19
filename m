Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 971FF18BD54
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgCSQ6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:58:20 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:57212 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728474AbgCSQ6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:58:18 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02JGwEso092579;
        Thu, 19 Mar 2020 11:58:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584637094;
        bh=j9ewmM7hESI6g6wk0ydAH0XJIu7pbzNMSXUh1AYtGvM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=tfH3Imch4vH9XDfXn6VYWIsT4CbtVd0t+gOSyAScNMCHwhEQijLRRmQ+OYx3vkvQi
         ELef6W9DAKaqZnje82SbjGF1JQoPd+QAInE+pzu0+8xgSu+EiwFVQBFG0w1xPeibJN
         mwIrovO/xesjmWG8+CpdKD3CEfChcXte9x1JNUNU=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JGwERs005225;
        Thu, 19 Mar 2020 11:58:14 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 19
 Mar 2020 11:58:14 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 19 Mar 2020 11:58:14 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JGwCWj109835;
        Thu, 19 Mar 2020 11:58:13 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC:     Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 04/10] net: ethernet: ti: cpts: switch to use new .gettimex64() interface
Date:   Thu, 19 Mar 2020 18:57:56 +0200
Message-ID: <20200319165802.30898-5-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319165802.30898-1-grygorii.strashko@ti.com>
References: <20200319165802.30898-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CPTS HW latches and saves CPTS counter value in CPTS fifo immediately
after writing to CPSW_CPTS_PUSH.TS_PUSH (bit 0), so the total time that the
driver needs to read the CPTS timestamp is the time required CPSW_CPTS_PUSH
write to actually reach HW.

Hence switch CPTS driver to implement new .gettimex64() callback for more
precise measurement of the offset between a PHC and the system clock which
is measured as time between
  write(CPSW_CPTS_PUSH)
  read(CPSW_CPTS_PUSH)

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpts.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index e6a8ccae711c..7e4c1de0d207 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -203,9 +203,13 @@ static u64 cpts_systim_read(const struct cyclecounter *cc)
 	return READ_ONCE(cpts->cur_timestamp);
 }
 
-static void cpts_update_cur_time(struct cpts *cpts, int match)
+static void cpts_update_cur_time(struct cpts *cpts, int match,
+				 struct ptp_system_timestamp *sts)
 {
+	ptp_read_system_prets(sts);
 	cpts_write32(cpts, TS_PUSH, ts_push);
+	cpts_read32(cpts, ts_push);
+	ptp_read_system_postts(sts);
 
 	if (cpts_fifo_read(cpts, match) && match != -1)
 		dev_err(cpts->dev, "cpts: unable to obtain a time stamp\n");
@@ -234,7 +238,7 @@ static int cpts_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 
 	cpts->mult_new = neg_adj ? mult - diff : mult + diff;
 
-	cpts_update_cur_time(cpts, CPTS_EV_PUSH);
+	cpts_update_cur_time(cpts, CPTS_EV_PUSH, NULL);
 
 	spin_unlock_irqrestore(&cpts->lock, flags);
 
@@ -253,15 +257,17 @@ static int cpts_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	return 0;
 }
 
-static int cpts_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
+static int cpts_ptp_gettimeex(struct ptp_clock_info *ptp,
+			      struct timespec64 *ts,
+			      struct ptp_system_timestamp *sts)
 {
-	u64 ns;
-	unsigned long flags;
 	struct cpts *cpts = container_of(ptp, struct cpts, info);
+	unsigned long flags;
+	u64 ns;
 
 	spin_lock_irqsave(&cpts->lock, flags);
 
-	cpts_update_cur_time(cpts, CPTS_EV_PUSH);
+	cpts_update_cur_time(cpts, CPTS_EV_PUSH, sts);
 
 	ns = timecounter_read(&cpts->tc);
 	spin_unlock_irqrestore(&cpts->lock, flags);
@@ -302,7 +308,7 @@ static long cpts_overflow_check(struct ptp_clock_info *ptp)
 
 	spin_lock_irqsave(&cpts->lock, flags);
 
-	cpts_update_cur_time(cpts, -1);
+	cpts_update_cur_time(cpts, -1, NULL);
 
 	ns = timecounter_read(&cpts->tc);
 
@@ -326,7 +332,7 @@ static const struct ptp_clock_info cpts_info = {
 	.pps		= 0,
 	.adjfreq	= cpts_ptp_adjfreq,
 	.adjtime	= cpts_ptp_adjtime,
-	.gettime64	= cpts_ptp_gettime,
+	.gettimex64	= cpts_ptp_gettimeex,
 	.settime64	= cpts_ptp_settime,
 	.enable		= cpts_ptp_enable,
 	.do_aux_work	= cpts_overflow_check,
-- 
2.17.1


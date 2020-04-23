Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D781B5D88
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 16:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgDWOV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 10:21:28 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:35938 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbgDWOV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 10:21:26 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03NELJiG081984;
        Thu, 23 Apr 2020 09:21:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587651679;
        bh=3CsWhGK83hJxvb5HsJHvZXPsnkPrM4JAuYacqypkTI4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=ES6l+deBLwUxuvgKpRVyQ6Wlozd0fCW9s3fXZQCAHtqyqBGV7wJfl4ttrK3wfvWoR
         5WBb56UABzNCQDH3JJO/3Yp3/ZHywF0dTskcqjdr63i/y05xADqcJl0HB4QDUigx6G
         ZmkyvoZ7yYf/j5V/qb5lAr1EVDZW1OMrDM89Hae0=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03NELJOh040074
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Apr 2020 09:21:19 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 23
 Apr 2020 09:21:19 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 23 Apr 2020 09:21:19 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03NELIWP117421;
        Thu, 23 Apr 2020 09:21:18 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v5 04/10] net: ethernet: ti: cpts: switch to use new .gettimex64() interface
Date:   Thu, 23 Apr 2020 17:20:16 +0300
Message-ID: <20200423142022.10538-5-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200423142022.10538-1-grygorii.strashko@ti.com>
References: <20200423142022.10538-1-grygorii.strashko@ti.com>
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
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/ti/cpts.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index a2974b542bed..1f738bb3df74 100644
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


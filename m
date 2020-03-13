Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAF31851D6
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 23:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbgCMWt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 18:49:57 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:53624 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgCMWt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 18:49:56 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02DMnqpV030106;
        Fri, 13 Mar 2020 17:49:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584139792;
        bh=j9ewmM7hESI6g6wk0ydAH0XJIu7pbzNMSXUh1AYtGvM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=VccTTqhzIcvoiK4GMQt1Jxw1aJCrO34cPE6LSmC/kHqXsZpyseKjv/E1WeC4fKaOt
         5XGTohElOsb9ORLyk94zO9G0pwsJfDVGfE6AI/NHciN4COfx+z3A81iAUwUxrZzWgl
         eIUE22CkNH2fyFPRgxY6WqPsxDqOVI0VkQTGRF+k=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02DMnqpl127751
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Mar 2020 17:49:52 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 13
 Mar 2020 17:49:52 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 13 Mar 2020 17:49:52 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02DMnpEc057457;
        Fri, 13 Mar 2020 17:49:51 -0500
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
Subject: [PATCH net-next 04/11] net: ethernet: ti: cpts: switch to use new .gettimex64() interface
Date:   Sat, 14 Mar 2020 00:49:07 +0200
Message-ID: <20200313224914.5997-5-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313224914.5997-1-grygorii.strashko@ti.com>
References: <20200313224914.5997-1-grygorii.strashko@ti.com>
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


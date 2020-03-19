Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2C918BD3F
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgCSQ61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:58:27 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:45616 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728624AbgCSQ6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:58:25 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02JGwKom034154;
        Thu, 19 Mar 2020 11:58:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584637100;
        bh=BDh7JDA1u67mI0bzRlP2YIugwKL6tYVjHl2OGCvCnQg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Z/Jw0TpGXFmmCbs776tZA+fbAETN9Fzt6s2OJtuGLTR/GGyM3HEaAlBqyIA9TcpVI
         otP8w2ligXcLCG60fFPcoetqYIrscs27QYAwX2t78CDW4LtbTwuQbSyeaeqO7b4rGY
         IkOp2Ezo64LONC0FJjLe5fO35uPR4boiReVyNFOw=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02JGwKSg018529
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Mar 2020 11:58:20 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 19
 Mar 2020 11:58:19 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 19 Mar 2020 11:58:19 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JGwIVN110016;
        Thu, 19 Mar 2020 11:58:19 -0500
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
Subject: [PATCH net-next v2 07/10] net: ethernet: ti: cpts: rework locking
Date:   Thu, 19 Mar 2020 18:57:59 +0200
Message-ID: <20200319165802.30898-8-grygorii.strashko@ti.com>
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

Now spinlock is used to synchronize everything which is not required. Add
mutex and use to sync access to PTP interface and PTP worker and use
spinlock only to sync FIFO/events processing.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpts.c | 53 +++++++++++++++++++---------------
 drivers/net/ethernet/ti/cpts.h |  3 +-
 2 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 10061e17d7b4..3cfa0f78287b 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -99,9 +99,12 @@ static void cpts_purge_txq(struct cpts *cpts)
  */
 static int cpts_fifo_read(struct cpts *cpts, int match)
 {
+	struct cpts_event *event;
+	unsigned long flags;
 	int i, type = -1;
 	u32 hi, lo;
-	struct cpts_event *event;
+
+	spin_lock_irqsave(&cpts->lock, flags);
 
 	for (i = 0; i < CPTS_FIFO_DEPTH; i++) {
 		if (cpts_fifo_pop(cpts, &hi, &lo))
@@ -109,7 +112,7 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 
 		if (list_empty(&cpts->pool) && cpts_purge_events(cpts)) {
 			dev_info(cpts->dev, "cpts: event pool empty\n");
-			return -1;
+			break;
 		}
 
 		event = list_first_entry(&cpts->pool, struct cpts_event, list);
@@ -148,6 +151,9 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 		if (type == match)
 			break;
 	}
+
+	spin_unlock_irqrestore(&cpts->lock, flags);
+
 	return type == match ? 0 : -1;
 }
 
@@ -161,10 +167,15 @@ static u64 cpts_systim_read(const struct cyclecounter *cc)
 static void cpts_update_cur_time(struct cpts *cpts, int match,
 				 struct ptp_system_timestamp *sts)
 {
+	unsigned long flags;
+
+	/* use spin_lock_irqsave() here as it has to run very fast */
+	spin_lock_irqsave(&cpts->lock, flags);
 	ptp_read_system_prets(sts);
 	cpts_write32(cpts, TS_PUSH, ts_push);
 	cpts_read32(cpts, ts_push);
 	ptp_read_system_postts(sts);
+	spin_unlock_irqrestore(&cpts->lock, flags);
 
 	if (cpts_fifo_read(cpts, match) && match != -1)
 		dev_err(cpts->dev, "cpts: unable to obtain a time stamp\n");
@@ -174,11 +185,10 @@ static void cpts_update_cur_time(struct cpts *cpts, int match,
 
 static int cpts_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 {
-	u64 adj;
-	u32 diff, mult;
-	int neg_adj = 0;
-	unsigned long flags;
 	struct cpts *cpts = container_of(ptp, struct cpts, info);
+	int neg_adj = 0;
+	u32 diff, mult;
+	u64 adj;
 
 	if (ppb < 0) {
 		neg_adj = 1;
@@ -189,25 +199,23 @@ static int cpts_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 	adj *= ppb;
 	diff = div_u64(adj, 1000000000ULL);
 
-	spin_lock_irqsave(&cpts->lock, flags);
+	mutex_lock(&cpts->ptp_clk_mutex);
 
 	cpts->mult_new = neg_adj ? mult - diff : mult + diff;
 
 	cpts_update_cur_time(cpts, CPTS_EV_PUSH, NULL);
 
-	spin_unlock_irqrestore(&cpts->lock, flags);
-
+	mutex_unlock(&cpts->ptp_clk_mutex);
 	return 0;
 }
 
 static int cpts_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
-	unsigned long flags;
 	struct cpts *cpts = container_of(ptp, struct cpts, info);
 
-	spin_lock_irqsave(&cpts->lock, flags);
+	mutex_lock(&cpts->ptp_clk_mutex);
 	timecounter_adjtime(&cpts->tc, delta);
-	spin_unlock_irqrestore(&cpts->lock, flags);
+	mutex_unlock(&cpts->ptp_clk_mutex);
 
 	return 0;
 }
@@ -217,15 +225,14 @@ static int cpts_ptp_gettimeex(struct ptp_clock_info *ptp,
 			      struct ptp_system_timestamp *sts)
 {
 	struct cpts *cpts = container_of(ptp, struct cpts, info);
-	unsigned long flags;
 	u64 ns;
 
-	spin_lock_irqsave(&cpts->lock, flags);
+	mutex_lock(&cpts->ptp_clk_mutex);
 
 	cpts_update_cur_time(cpts, CPTS_EV_PUSH, sts);
 
 	ns = timecounter_read(&cpts->tc);
-	spin_unlock_irqrestore(&cpts->lock, flags);
+	mutex_unlock(&cpts->ptp_clk_mutex);
 
 	*ts = ns_to_timespec64(ns);
 
@@ -235,15 +242,14 @@ static int cpts_ptp_gettimeex(struct ptp_clock_info *ptp,
 static int cpts_ptp_settime(struct ptp_clock_info *ptp,
 			    const struct timespec64 *ts)
 {
-	u64 ns;
-	unsigned long flags;
 	struct cpts *cpts = container_of(ptp, struct cpts, info);
+	u64 ns;
 
 	ns = timespec64_to_ns(ts);
 
-	spin_lock_irqsave(&cpts->lock, flags);
+	mutex_lock(&cpts->ptp_clk_mutex);
 	timecounter_init(&cpts->tc, &cpts->cc, ns);
-	spin_unlock_irqrestore(&cpts->lock, flags);
+	mutex_unlock(&cpts->ptp_clk_mutex);
 
 	return 0;
 }
@@ -339,10 +345,9 @@ static long cpts_overflow_check(struct ptp_clock_info *ptp)
 	unsigned long flags;
 	u64 ns;
 
-	spin_lock_irqsave(&cpts->lock, flags);
-	cpts_update_cur_time(cpts, -1, NULL);
-	spin_unlock_irqrestore(&cpts->lock, flags);
+	mutex_lock(&cpts->ptp_clk_mutex);
 
+	cpts_update_cur_time(cpts, -1, NULL);
 	ns = timecounter_read(&cpts->tc);
 
 	cpts_process_events(cpts);
@@ -356,6 +361,7 @@ static long cpts_overflow_check(struct ptp_clock_info *ptp)
 	spin_unlock_irqrestore(&cpts->txq.lock, flags);
 
 	dev_dbg(cpts->dev, "cpts overflow check at %lld\n", ns);
+	mutex_unlock(&cpts->ptp_clk_mutex);
 	return (long)delay;
 }
 
@@ -425,8 +431,8 @@ static u64 cpts_find_ts(struct cpts *cpts, struct sk_buff *skb,
 	u32 mtype_seqid;
 	u64 ns = 0;
 
-	spin_lock_irqsave(&cpts->lock, flags);
 	cpts_fifo_read(cpts, -1);
+	spin_lock_irqsave(&cpts->lock, flags);
 	list_for_each_safe(this, next, &cpts->events) {
 		event = list_entry(this, struct cpts_event, list);
 		if (event_expired(event)) {
@@ -703,6 +709,7 @@ struct cpts *cpts_create(struct device *dev, void __iomem *regs,
 	cpts->dev = dev;
 	cpts->reg = (struct cpsw_cpts __iomem *)regs;
 	spin_lock_init(&cpts->lock);
+	mutex_init(&cpts->ptp_clk_mutex);
 
 	ret = cpts_of_parse(cpts, node);
 	if (ret)
diff --git a/drivers/net/ethernet/ti/cpts.h b/drivers/net/ethernet/ti/cpts.h
index 421630049ee7..f16e14d67f5f 100644
--- a/drivers/net/ethernet/ti/cpts.h
+++ b/drivers/net/ethernet/ti/cpts.h
@@ -104,7 +104,7 @@ struct cpts {
 	int rx_enable;
 	struct ptp_clock_info info;
 	struct ptp_clock *clock;
-	spinlock_t lock; /* protects time registers */
+	spinlock_t lock; /* protects fifo/events */
 	u32 cc_mult; /* for the nominal frequency */
 	struct cyclecounter cc;
 	struct timecounter tc;
@@ -117,6 +117,7 @@ struct cpts {
 	struct sk_buff_head txq;
 	u64 cur_timestamp;
 	u32 mult_new;
+	struct mutex ptp_clk_mutex; /* sync PTP interface and worker */
 };
 
 void cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb);
-- 
2.17.1


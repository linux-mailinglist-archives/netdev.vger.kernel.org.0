Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4BD18BD52
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgCSQ6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:58:20 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:45588 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728523AbgCSQ6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:58:17 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02JGwAme034114;
        Thu, 19 Mar 2020 11:58:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584637090;
        bh=r65crBqSQyMLYoz3u50e2Ikb848eo23JjhikeJXrBxA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=vGfgbnjF0sGGn/pPeqyaMMg0Iwbe0iOCBJNXuHNLks+lHCu0YA+9zziT5mbtwlaNM
         A+5OkWn1wv2rmvbvX3L6VYEsMwbtga5yjjblBdFhcNgWbV8CwmTptOux2rYFuQpz+Z
         c+Mj+rY37ftejiMdz8ahu2ifOzPxrYaGin1NB7h8=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JGwAxV005161;
        Thu, 19 Mar 2020 11:58:10 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 19
 Mar 2020 11:58:10 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 19 Mar 2020 11:58:10 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JGw9LF109759;
        Thu, 19 Mar 2020 11:58:09 -0500
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
Subject: [PATCH net-next v2 02/10] net: ethernet: ti: cpts: separate hw counter read from timecounter
Date:   Thu, 19 Mar 2020 18:57:54 +0200
Message-ID: <20200319165802.30898-3-grygorii.strashko@ti.com>
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

Separate hw counter read from timecounter code:
- add CPTS context field to store current HW counter value
- move HW timestamp request and FIFO read code out of timecounter code
- convert cyc2time on event reception in cpts_fifo_read()
- call timecounter_read() in cpts_fifo_read() to update tk->cycle_last

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpts.c | 53 +++++++++++++++++-----------------
 drivers/net/ethernet/ti/cpts.h |  2 ++
 2 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index f07b40504e5b..6a1844cd23ff 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -112,10 +112,8 @@ static bool cpts_match_tx_ts(struct cpts *cpts, struct cpts_event *event)
 					(struct cpts_skb_cb_data *)skb->cb;
 
 		if (cpts_match(skb, class, seqid, mtype)) {
-			u64 ns = timecounter_cyc2time(&cpts->tc, event->low);
-
 			memset(&ssh, 0, sizeof(ssh));
-			ssh.hwtstamp = ns_to_ktime(ns);
+			ssh.hwtstamp = ns_to_ktime(event->timestamp);
 			skb_tstamp_tx(skb, &ssh);
 			found = true;
 			__skb_unlink(skb, &cpts->txq);
@@ -158,8 +156,16 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 		event->tmo = jiffies + 2;
 		event->high = hi;
 		event->low = lo;
+		event->timestamp = timecounter_cyc2time(&cpts->tc, event->low);
 		type = event_type(event);
+
+		dev_dbg(cpts->dev, "CPTS_EV: %d high:%08X low:%08x\n",
+			type, event->high, event->low);
 		switch (type) {
+		case CPTS_EV_PUSH:
+			WRITE_ONCE(cpts->cur_timestamp, lo);
+			timecounter_read(&cpts->tc);
+			break;
 		case CPTS_EV_TX:
 			if (cpts_match_tx_ts(cpts, event)) {
 				/* if the new event matches an existing skb,
@@ -168,7 +174,6 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 				break;
 			}
 			/* fall through */
-		case CPTS_EV_PUSH:
 		case CPTS_EV_RX:
 			list_del_init(&event->list);
 			list_add_tail(&event->list, &cpts->events);
@@ -189,26 +194,17 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 
 static u64 cpts_systim_read(const struct cyclecounter *cc)
 {
-	u64 val = 0;
-	struct cpts_event *event;
-	struct list_head *this, *next;
 	struct cpts *cpts = container_of(cc, struct cpts, cc);
 
-	cpts_write32(cpts, TS_PUSH, ts_push);
-	if (cpts_fifo_read(cpts, CPTS_EV_PUSH))
-		dev_err(cpts->dev, "cpts: unable to obtain a time stamp\n");
+	return READ_ONCE(cpts->cur_timestamp);
+}
 
-	list_for_each_safe(this, next, &cpts->events) {
-		event = list_entry(this, struct cpts_event, list);
-		if (event_type(event) == CPTS_EV_PUSH) {
-			list_del_init(&event->list);
-			list_add(&event->list, &cpts->pool);
-			val = event->low;
-			break;
-		}
-	}
+static void cpts_update_cur_time(struct cpts *cpts, int match)
+{
+	cpts_write32(cpts, TS_PUSH, ts_push);
 
-	return val;
+	if (cpts_fifo_read(cpts, match) && match != -1)
+		dev_err(cpts->dev, "cpts: unable to obtain a time stamp\n");
 }
 
 /* PTP clock operations */
@@ -232,7 +228,7 @@ static int cpts_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 
 	spin_lock_irqsave(&cpts->lock, flags);
 
-	timecounter_read(&cpts->tc);
+	cpts_update_cur_time(cpts, CPTS_EV_PUSH);
 
 	cpts->cc.mult = neg_adj ? mult - diff : mult + diff;
 
@@ -260,6 +256,9 @@ static int cpts_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	struct cpts *cpts = container_of(ptp, struct cpts, info);
 
 	spin_lock_irqsave(&cpts->lock, flags);
+
+	cpts_update_cur_time(cpts, CPTS_EV_PUSH);
+
 	ns = timecounter_read(&cpts->tc);
 	spin_unlock_irqrestore(&cpts->lock, flags);
 
@@ -294,11 +293,14 @@ static long cpts_overflow_check(struct ptp_clock_info *ptp)
 {
 	struct cpts *cpts = container_of(ptp, struct cpts, info);
 	unsigned long delay = cpts->ov_check_period;
-	struct timespec64 ts;
 	unsigned long flags;
+	u64 ns;
 
 	spin_lock_irqsave(&cpts->lock, flags);
-	ts = ns_to_timespec64(timecounter_read(&cpts->tc));
+
+	cpts_update_cur_time(cpts, -1);
+
+	ns = timecounter_read(&cpts->tc);
 
 	if (!skb_queue_empty(&cpts->txq)) {
 		cpts_purge_txq(cpts);
@@ -307,8 +309,7 @@ static long cpts_overflow_check(struct ptp_clock_info *ptp)
 	}
 	spin_unlock_irqrestore(&cpts->lock, flags);
 
-	dev_dbg(cpts->dev, "cpts overflow check at %lld.%09ld\n",
-		(long long)ts.tv_sec, ts.tv_nsec);
+	dev_dbg(cpts->dev, "cpts overflow check at %lld\n", ns);
 	return (long)delay;
 }
 
@@ -390,7 +391,7 @@ static u64 cpts_find_ts(struct cpts *cpts, struct sk_buff *skb, int ev_type)
 		seqid = (event->high >> SEQUENCE_ID_SHIFT) & SEQUENCE_ID_MASK;
 		if (ev_type == event_type(event) &&
 		    cpts_match(skb, class, seqid, mtype)) {
-			ns = timecounter_cyc2time(&cpts->tc, event->low);
+			ns = event->timestamp;
 			list_del_init(&event->list);
 			list_add(&event->list, &cpts->pool);
 			break;
diff --git a/drivers/net/ethernet/ti/cpts.h b/drivers/net/ethernet/ti/cpts.h
index bb997c11ee15..32ecd1ce4d3b 100644
--- a/drivers/net/ethernet/ti/cpts.h
+++ b/drivers/net/ethernet/ti/cpts.h
@@ -94,6 +94,7 @@ struct cpts_event {
 	unsigned long tmo;
 	u32 high;
 	u32 low;
+	u64 timestamp;
 };
 
 struct cpts {
@@ -114,6 +115,7 @@ struct cpts {
 	struct cpts_event pool_data[CPTS_MAX_EVENTS];
 	unsigned long ov_check_period;
 	struct sk_buff_head txq;
+	u64 cur_timestamp;
 };
 
 void cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb);
-- 
2.17.1


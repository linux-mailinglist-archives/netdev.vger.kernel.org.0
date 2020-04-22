Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6434B1B4E23
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 22:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgDVUNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 16:13:25 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:46196 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgDVUNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 16:13:24 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03MKDHSU067814;
        Wed, 22 Apr 2020 15:13:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587586397;
        bh=agWItc8JofcjHPo/+950nEtdLQioZkt6XS5Sk3vvuS4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=JEGM+3SW1yIhrNIAjgCaYAbZRNRw0oc2y3HL9xlNIvF32srFc6yIMxS861Gijyntg
         dYy5yjDSJKJYA2tkORLQhk7IZeyOEXemh4pJ+8FoecrdjTSEm2DRPmsNYD/ofy09o5
         kcQxROiOaJY2xzOJCgAtCSh00hogTAOcYsGgF4gM=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03MKDHHw085596;
        Wed, 22 Apr 2020 15:13:17 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 22
 Apr 2020 15:13:16 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 22 Apr 2020 15:13:16 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03MKDFEq105147;
        Wed, 22 Apr 2020 15:13:16 -0500
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
Subject: [PATCH net-next v4 02/10] net: ethernet: ti: cpts: separate hw counter read from timecounter
Date:   Wed, 22 Apr 2020 23:12:46 +0300
Message-ID: <20200422201254.15232-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200422201254.15232-1-grygorii.strashko@ti.com>
References: <20200422201254.15232-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now CPTS HW time reading code is implemented in timecounter->cyclecounter
.read() callback and performs following operations:
timecounter_read() ->cc.read() -> cpts_systim_read()
 - request current CPTS HW time CPTS_TS_PUSH.TS_PUSH = 1
 - poll CPTS FIFO for CPTS_EV_PUSH event with current HW timestamp

This approach need to be changed for the future switch to PTP PHC
.gettimex64() callback, which require to separate requesting current CPTS
HW time and processing CPTS FIFO. And for the follow up patch, which
improves .adjfreq() implementation.

This patch moves code accessing CPTS HW out of timecounter code as
following:
- convert HW timestamp of every CPTS event to PTP time (us) and store it as
part struct cpts_event;
- add CPTS context field to store current CPTS HW time (counter) value and
update it on CPTS_EV_PUSH reception;
- move code accessing CPTS HW out of timecounter code and use current CPTS
HW time (counter) from CPTS context instead;
- ensure timecounter->cycle_last is updated on CPTS_EV_PUSH reception.

After this change CPTS timecounter will only perform timekeeper role
without actually accessing CPTS HW.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/ti/cpts.c | 53 +++++++++++++++++-----------------
 drivers/net/ethernet/ti/cpts.h |  2 ++
 2 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 445f445185df..f40a864d8c36 100644
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


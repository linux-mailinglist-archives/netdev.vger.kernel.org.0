Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC5218D896
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 20:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgCTTnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 15:43:31 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:40032 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCTTn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 15:43:29 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02KJhP8S027981;
        Fri, 20 Mar 2020 14:43:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584733405;
        bh=TQ3NwLkd7ZYcJa91yZrHE1XpSmWeGNXoGX/sRlDathA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=M6mPVFkMq30rttSw/lBXCKJb+jCnZDRit7KB95nI+tsijWCdsrC/YsmhwWCPt5EF9
         9Bv6x/CxAkQuPisWVA38Ecr+OhTxH91RFiuCNks55K6AMDhaWAt+GJ/P5pKhnoSO60
         1BpdY+y+Tp4ZmyweItyioFuWbZLb/3bf/Psz20Aw=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02KJhPPt117466
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Mar 2020 14:43:25 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 20
 Mar 2020 14:43:25 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 20 Mar 2020 14:43:24 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02KJhNfg073978;
        Fri, 20 Mar 2020 14:43:24 -0500
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
Subject: [PATCH net-next v3 06/11] net: ethernet: ti: cpts: move tx timestamp processing to ptp worker only
Date:   Fri, 20 Mar 2020 21:42:39 +0200
Message-ID: <20200320194244.4703-7-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320194244.4703-1-grygorii.strashko@ti.com>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now the tx timestamp processing happens from different contexts - softirq
and thread/PTP worker. Enabling IRQ will add one more hard_irq context.
This makes over all defered TX timestamp processing and locking
overcomplicated. Move tx timestamp processing to PTP worker always instead.

napi_rx->cpts_tx_timestamp
 if ptp_packet then
    push to txq
    ptp_schedule_worker()

do_aux_work->cpts_overflow_check
 cpts_process_events()

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpts.c | 165 +++++++++++++++++++--------------
 1 file changed, 94 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index f7ce482ad09c..10061e17d7b4 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -21,6 +21,8 @@
 #include "cpts.h"
 
 #define CPTS_SKB_TX_WORK_TIMEOUT 1 /* jiffies */
+#define CPTS_SKB_RX_TX_TMO 100 /*ms */
+#define CPTS_EVENT_RX_TX_TIMEOUT (100) /* ms */
 
 struct cpts_skb_cb_data {
 	u32 skb_mtype_seqid;
@@ -92,46 +94,6 @@ static void cpts_purge_txq(struct cpts *cpts)
 		dev_dbg(cpts->dev, "txq cleaned up %d\n", removed);
 }
 
-static bool cpts_match_tx_ts(struct cpts *cpts, struct cpts_event *event)
-{
-	struct sk_buff *skb, *tmp;
-	bool found = false;
-	u32 mtype_seqid;
-
-	mtype_seqid = event->high &
-		      ((MESSAGE_TYPE_MASK << MESSAGE_TYPE_SHIFT) |
-		       (SEQUENCE_ID_MASK << SEQUENCE_ID_SHIFT) |
-		       (EVENT_TYPE_MASK << EVENT_TYPE_SHIFT));
-
-	/* no need to grab txq.lock as access is always done under cpts->lock */
-	skb_queue_walk_safe(&cpts->txq, skb, tmp) {
-		struct skb_shared_hwtstamps ssh;
-		struct cpts_skb_cb_data *skb_cb =
-					(struct cpts_skb_cb_data *)skb->cb;
-
-		if (mtype_seqid == skb_cb->skb_mtype_seqid) {
-			memset(&ssh, 0, sizeof(ssh));
-			ssh.hwtstamp = ns_to_ktime(event->timestamp);
-			skb_tstamp_tx(skb, &ssh);
-			found = true;
-			__skb_unlink(skb, &cpts->txq);
-			dev_consume_skb_any(skb);
-			dev_dbg(cpts->dev, "match tx timestamp mtype_seqid %08x\n",
-				mtype_seqid);
-			break;
-		}
-
-		if (time_after(jiffies, skb_cb->tmo)) {
-			/* timeout any expired skbs over 1s */
-			dev_dbg(cpts->dev, "expiring tx timestamp from txq\n");
-			__skb_unlink(skb, &cpts->txq);
-			dev_consume_skb_any(skb);
-		}
-	}
-
-	return found;
-}
-
 /*
  * Returns zero if matching event type was found.
  */
@@ -151,7 +113,6 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 		}
 
 		event = list_first_entry(&cpts->pool, struct cpts_event, list);
-		event->tmo = jiffies + 2;
 		event->high = hi;
 		event->low = lo;
 		event->timestamp = timecounter_cyc2time(&cpts->tc, event->low);
@@ -169,14 +130,10 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 			}
 			break;
 		case CPTS_EV_TX:
-			if (cpts_match_tx_ts(cpts, event)) {
-				/* if the new event matches an existing skb,
-				 * then don't queue it
-				 */
-				break;
-			}
-			/* fall through */
 		case CPTS_EV_RX:
+			event->tmo = jiffies +
+				msecs_to_jiffies(CPTS_EVENT_RX_TX_TIMEOUT);
+
 			list_del_init(&event->list);
 			list_add_tail(&event->list, &cpts->events);
 			break;
@@ -297,6 +254,84 @@ static int cpts_ptp_enable(struct ptp_clock_info *ptp,
 	return -EOPNOTSUPP;
 }
 
+static bool cpts_match_tx_ts(struct cpts *cpts, struct cpts_event *event)
+{
+	struct sk_buff_head txq_list;
+	struct sk_buff *skb, *tmp;
+	unsigned long flags;
+	bool found = false;
+	u32 mtype_seqid;
+
+	mtype_seqid = event->high &
+		      ((MESSAGE_TYPE_MASK << MESSAGE_TYPE_SHIFT) |
+		       (SEQUENCE_ID_MASK << SEQUENCE_ID_SHIFT) |
+		       (EVENT_TYPE_MASK << EVENT_TYPE_SHIFT));
+
+	__skb_queue_head_init(&txq_list);
+
+	spin_lock_irqsave(&cpts->txq.lock, flags);
+	skb_queue_splice_init(&cpts->txq, &txq_list);
+	spin_unlock_irqrestore(&cpts->txq.lock, flags);
+
+	skb_queue_walk_safe(&txq_list, skb, tmp) {
+		struct skb_shared_hwtstamps ssh;
+		struct cpts_skb_cb_data *skb_cb =
+					(struct cpts_skb_cb_data *)skb->cb;
+
+		if (mtype_seqid == skb_cb->skb_mtype_seqid) {
+			memset(&ssh, 0, sizeof(ssh));
+			ssh.hwtstamp = ns_to_ktime(event->timestamp);
+			skb_tstamp_tx(skb, &ssh);
+			found = true;
+			__skb_unlink(skb, &txq_list);
+			dev_consume_skb_any(skb);
+			dev_dbg(cpts->dev, "match tx timestamp mtype_seqid %08x\n",
+				mtype_seqid);
+			break;
+		}
+
+		if (time_after(jiffies, skb_cb->tmo)) {
+			/* timeout any expired skbs over 1s */
+			dev_dbg(cpts->dev, "expiring tx timestamp from txq\n");
+			__skb_unlink(skb, &txq_list);
+			dev_consume_skb_any(skb);
+		}
+	}
+
+	spin_lock_irqsave(&cpts->txq.lock, flags);
+	skb_queue_splice(&txq_list, &cpts->txq);
+	spin_unlock_irqrestore(&cpts->txq.lock, flags);
+
+	return found;
+}
+
+static void cpts_process_events(struct cpts *cpts)
+{
+	struct list_head *this, *next;
+	struct cpts_event *event;
+	LIST_HEAD(events_free);
+	unsigned long flags;
+	LIST_HEAD(events);
+
+	spin_lock_irqsave(&cpts->lock, flags);
+	list_splice_init(&cpts->events, &events);
+	spin_unlock_irqrestore(&cpts->lock, flags);
+
+	list_for_each_safe(this, next, &events) {
+		event = list_entry(this, struct cpts_event, list);
+		if (cpts_match_tx_ts(cpts, event) ||
+		    time_after(jiffies, event->tmo)) {
+			list_del_init(&event->list);
+			list_add(&event->list, &events_free);
+		}
+	}
+
+	spin_lock_irqsave(&cpts->lock, flags);
+	list_splice_tail(&events, &cpts->events);
+	list_splice_tail(&events_free, &cpts->pool);
+	spin_unlock_irqrestore(&cpts->lock, flags);
+}
+
 static long cpts_overflow_check(struct ptp_clock_info *ptp)
 {
 	struct cpts *cpts = container_of(ptp, struct cpts, info);
@@ -305,17 +340,20 @@ static long cpts_overflow_check(struct ptp_clock_info *ptp)
 	u64 ns;
 
 	spin_lock_irqsave(&cpts->lock, flags);
-
 	cpts_update_cur_time(cpts, -1, NULL);
+	spin_unlock_irqrestore(&cpts->lock, flags);
 
 	ns = timecounter_read(&cpts->tc);
 
+	cpts_process_events(cpts);
+
+	spin_lock_irqsave(&cpts->txq.lock, flags);
 	if (!skb_queue_empty(&cpts->txq)) {
 		cpts_purge_txq(cpts);
 		if (!skb_queue_empty(&cpts->txq))
 			delay = CPTS_SKB_TX_WORK_TIMEOUT;
 	}
-	spin_unlock_irqrestore(&cpts->lock, flags);
+	spin_unlock_irqrestore(&cpts->txq.lock, flags);
 
 	dev_dbg(cpts->dev, "cpts overflow check at %lld\n", ns);
 	return (long)delay;
@@ -409,19 +447,6 @@ static u64 cpts_find_ts(struct cpts *cpts, struct sk_buff *skb,
 			break;
 		}
 	}
-
-	if (ev_type == CPTS_EV_TX && !ns) {
-		struct cpts_skb_cb_data *skb_cb =
-				(struct cpts_skb_cb_data *)skb->cb;
-		/* Not found, add frame to queue for processing later.
-		 * The periodic FIFO check will handle this.
-		 */
-		skb_get(skb);
-		/* get the timestamp for timeouts */
-		skb_cb->tmo = jiffies + msecs_to_jiffies(100);
-		__skb_queue_tail(&cpts->txq, skb);
-		ptp_schedule_worker(cpts->clock, 0);
-	}
 	spin_unlock_irqrestore(&cpts->lock, flags);
 
 	return ns;
@@ -455,9 +480,7 @@ EXPORT_SYMBOL_GPL(cpts_rx_timestamp);
 void cpts_tx_timestamp(struct cpts *cpts, struct sk_buff *skb)
 {
 	struct cpts_skb_cb_data *skb_cb = (struct cpts_skb_cb_data *)skb->cb;
-	struct skb_shared_hwtstamps ssh;
 	int ret;
-	u64 ns;
 
 	if (!(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS))
 		return;
@@ -471,12 +494,12 @@ void cpts_tx_timestamp(struct cpts *cpts, struct sk_buff *skb)
 	dev_dbg(cpts->dev, "%s mtype seqid %08x\n",
 		__func__, skb_cb->skb_mtype_seqid);
 
-	ns = cpts_find_ts(cpts, skb, CPTS_EV_TX, skb_cb->skb_mtype_seqid);
-	if (!ns)
-		return;
-	memset(&ssh, 0, sizeof(ssh));
-	ssh.hwtstamp = ns_to_ktime(ns);
-	skb_tstamp_tx(skb, &ssh);
+	/* Always defer TX TS processing to PTP worker */
+	skb_get(skb);
+	/* get the timestamp for timeouts */
+	skb_cb->tmo = jiffies + msecs_to_jiffies(CPTS_SKB_RX_TX_TMO);
+	skb_queue_tail(&cpts->txq, skb);
+	ptp_schedule_worker(cpts->clock, 0);
 }
 EXPORT_SYMBOL_GPL(cpts_tx_timestamp);
 
-- 
2.17.1


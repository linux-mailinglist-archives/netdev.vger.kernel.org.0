Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4371718ADBE
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 08:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgCSH4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 03:56:16 -0400
Received: from mx.socionext.com ([202.248.49.38]:23193 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgCSH4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 03:56:16 -0400
Received: from unknown (HELO iyokan-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 19 Mar 2020 16:56:14 +0900
Received: from mail.mfilter.local (m-filter-1 [10.213.24.61])
        by iyokan-ex.css.socionext.com (Postfix) with ESMTP id 91D9560057;
        Thu, 19 Mar 2020 16:56:14 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Thu, 19 Mar 2020 16:56:14 +0900
Received: from yuzu.css.socionext.com (yuzu [172.31.8.45])
        by kinkan.css.socionext.com (Postfix) with ESMTP id 425CA1A0E67;
        Thu, 19 Mar 2020 16:56:14 +0900 (JST)
Received: from ptp-master.e01.socionext.com (unknown [10.213.95.142])
        by yuzu.css.socionext.com (Postfix) with ESMTP id 37033120134;
        Thu, 19 Mar 2020 16:56:14 +0900 (JST)
From:   Zh-yuan Ye <ye.zh-yuan@socionext.com>
To:     netdev@vger.kernel.org
Cc:     okamoto.satoru@socionext.com, kojima.masahisa@socionext.com,
        vinicius.gomes@intel.com, Zh-yuan Ye <ye.zh-yuan@socionext.com>
Subject: [PATCH net] net: cbs: Fix software cbs to consider packet
Date:   Thu, 19 Mar 2020 16:56:59 +0900
Message-Id: <20200319075659.3126-1-ye.zh-yuan@socionext.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the software CBS does not consider the packet sending time
when depleting the credits. It caused the throughput to be
Idleslope[kbps] * (Port transmit rate[kbps] / |Sendslope[kbps]|) where
Idleslope * (Port transmit rate / (Idleslope + |Sendslope|)) is expected.
In order to fix the issue above, this patch takes the time when the
packet sending completes into account by moving the anchor time variable
"last" ahead to the send completion time upon transmission and adding
wait when the next dequeue request comes before the send completion time
of the previous packet.

Signed-off-by: Zh-yuan Ye <ye.zh-yuan@socionext.com>
---
 net/sched/sch_cbs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index b2905b03a432..a78b8a750bd9 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -71,6 +71,7 @@ struct cbs_sched_data {
 	int queue;
 	atomic64_t port_rate; /* in bytes/s */
 	s64 last; /* timestamp in ns */
+	s64 send_completed; /* timestamp in ns */
 	s64 credits; /* in bytes */
 	s32 locredit; /* in bytes */
 	s32 hicredit; /* in bytes */
@@ -181,6 +182,10 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
 	s64 credits;
 	int len;
 
+	if (now < q->send_completed) {
+		qdisc_watchdog_schedule_ns(&q->watchdog, q->send_completed);
+		return NULL;
+	}
 	if (q->credits < 0) {
 		credits = timediff_to_credits(now - q->last, q->idleslope);
 
@@ -192,7 +197,6 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
 
 			delay = delay_from_credits(q->credits, q->idleslope);
 			qdisc_watchdog_schedule_ns(&q->watchdog, now + delay);
-
 			q->last = now;
 
 			return NULL;
@@ -212,7 +216,9 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
 	credits += q->credits;
 
 	q->credits = max_t(s64, credits, q->locredit);
-	q->last = now;
+	q->send_completed = now + div64_s64(len * NSEC_PER_SEC,
+					    atomic64_read(&q->port_rate));
+	q->last = q->send_completed;
 
 	return skb;
 }
-- 
2.20.1


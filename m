Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82DF319077C
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 09:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgCXI1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 04:27:46 -0400
Received: from mx.socionext.com ([202.248.49.38]:18189 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgCXI1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 04:27:46 -0400
Received: from unknown (HELO kinkan-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 24 Mar 2020 17:27:44 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by kinkan-ex.css.socionext.com (Postfix) with ESMTP id 856FE180061;
        Tue, 24 Mar 2020 17:27:44 +0900 (JST)
Received: from 172.31.9.53 (172.31.9.53) by m-FILTER with ESMTP; Tue, 24 Mar 2020 17:27:44 +0900
Received: from yuzu.css.socionext.com (yuzu [172.31.8.45])
        by iyokan.css.socionext.com (Postfix) with ESMTP id 1EA33403AF;
        Tue, 24 Mar 2020 17:27:44 +0900 (JST)
Received: from ptp-master.e01.socionext.com (unknown [10.213.95.142])
        by yuzu.css.socionext.com (Postfix) with ESMTP id 96CAB12013D;
        Tue, 24 Mar 2020 17:27:43 +0900 (JST)
From:   Zh-yuan Ye <ye.zh-yuan@socionext.com>
To:     netdev@vger.kernel.org
Cc:     okamoto.satoru@socionext.com, kojima.masahisa@socionext.com,
        vinicius.gomes@intel.com, kuba@kernel.org,
        Zh-yuan Ye <ye.zh-yuan@socionext.com>
Subject: [PATCH net v3] net: cbs: Fix software cbs to consider packet sending time
Date:   Tue, 24 Mar 2020 17:28:25 +0900
Message-Id: <20200324082825.3095-1-ye.zh-yuan@socionext.com>
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
Idleslope * (Port transmit rate / (Idleslope + |Sendslope|)) = Idleslope
is expected. In order to fix the issue above, this patch takes the time
when the packet sending completes into account by moving the anchor time
variable "last" ahead to the send completion time upon transmission and
adding wait when the next dequeue request comes before the send
completion time of the previous packet.

changelog:
V2->V3:
 - remove unnecessary whitespace cleanup
 - add the checks if port_rate is 0 before division

V1->V2:
 - combine variable "send_completed" into "last"
 - add the comment for estimate of the packet sending

Fixes: 585d763af09c ("net/sched: Introduce Credit Based Shaper (CBS) qdisc")
Signed-off-by: Zh-yuan Ye <ye.zh-yuan@socionext.com>
Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_cbs.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index b2905b03a432..2eaac2ff380f 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -181,6 +181,11 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
 	s64 credits;
 	int len;
 
+	/* The previous packet is still being sent */
+	if (now < q->last) {
+		qdisc_watchdog_schedule_ns(&q->watchdog, q->last);
+		return NULL;
+	}
 	if (q->credits < 0) {
 		credits = timediff_to_credits(now - q->last, q->idleslope);
 
@@ -212,7 +217,12 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
 	credits += q->credits;
 
 	q->credits = max_t(s64, credits, q->locredit);
-	q->last = now;
+	/* Estimate of the transmission of the last byte of the packet in ns */
+	if (unlikely(atomic64_read(&q->port_rate) == 0))
+		q->last = now;
+	else
+		q->last = now + div64_s64(len * NSEC_PER_SEC,
+					  atomic64_read(&q->port_rate));
 
 	return skb;
 }
-- 
2.20.1


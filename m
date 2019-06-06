Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49FC837B76
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbfFFRvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:51:17 -0400
Received: from mga06.intel.com ([134.134.136.31]:29832 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730312AbfFFRvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 13:51:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 10:51:14 -0700
X-ExtLoop1: 1
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga003.jf.intel.com with ESMTP; 06 Jun 2019 10:51:14 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org, jakub.kicinski@netronome.com, m-karicheri2@ti.com,
        Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH net-next v2 5/6] taprio: make clock reference conversions easier
Date:   Thu,  6 Jun 2019 10:50:57 -0700
Message-Id: <1559843458-12517-6-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1559843458-12517-1-git-send-email-vedang.patel@intel.com>
References: <1559843458-12517-1-git-send-email-vedang.patel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Later in this series we will need to transform from
CLOCK_MONOTONIC (used in TCP) to the clock reference used in TAPRIO.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
---
 net/sched/sch_taprio.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index a5676fb2b2dd..9f621e6c2503 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -62,6 +62,7 @@ struct taprio_sched {
 	struct Qdisc **qdiscs;
 	struct Qdisc *root;
 	u32 flags;
+	enum tk_offsets tk_offset;
 	int clockid;
 	atomic64_t picos_per_byte; /* Using picoseconds because for 10Gbps+
 				    * speeds it's sub-nanoseconds per byte
@@ -72,7 +73,6 @@ struct taprio_sched {
 	struct sched_entry __rcu *current_entry;
 	struct sched_gate_list __rcu *oper_sched;
 	struct sched_gate_list __rcu *admin_sched;
-	ktime_t (*get_time)(void);
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
 	int txtime_delay;
@@ -86,6 +86,20 @@ static ktime_t sched_base_time(const struct sched_gate_list *sched)
 	return ns_to_ktime(sched->base_time);
 }
 
+static inline ktime_t taprio_get_time(struct taprio_sched *q)
+{
+	ktime_t mono = ktime_get();
+
+	switch (q->tk_offset) {
+	case TK_OFFS_MAX:
+		return mono;
+	default:
+		return ktime_mono_to_any(mono, q->tk_offset);
+	}
+
+	return KTIME_MAX;
+}
+
 static void taprio_free_sched_cb(struct rcu_head *head)
 {
 	struct sched_gate_list *sched = container_of(head, struct sched_gate_list, rcu);
@@ -289,7 +303,7 @@ static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
 	struct sched_entry *entry;
 	bool sched_changed;
 
-	now = q->get_time();
+	now = taprio_get_time(q);
 	minimum_time = ktime_add_ns(now, q->txtime_delay);
 
 	rcu_read_lock();
@@ -480,7 +494,7 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 			continue;
 
 		len = qdisc_pkt_len(skb);
-		guard = ktime_add_ns(q->get_time(),
+		guard = ktime_add_ns(taprio_get_time(q),
 				     length_to_duration(q, len));
 
 		/* In the case that there's no gate entry, there's no
@@ -849,7 +863,7 @@ static int taprio_get_start_time(struct Qdisc *sch,
 	s64 n;
 
 	base = sched_base_time(sched);
-	now = q->get_time();
+	now = taprio_get_time(q);
 
 	if (ktime_after(base, now)) {
 		*start = base;
@@ -1088,16 +1102,16 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 	switch (q->clockid) {
 	case CLOCK_REALTIME:
-		q->get_time = ktime_get_real;
+		q->tk_offset = TK_OFFS_REAL;
 		break;
 	case CLOCK_MONOTONIC:
-		q->get_time = ktime_get;
+		q->tk_offset = TK_OFFS_MAX;
 		break;
 	case CLOCK_BOOTTIME:
-		q->get_time = ktime_get_boottime;
+		q->tk_offset = TK_OFFS_BOOT;
 		break;
 	case CLOCK_TAI:
-		q->get_time = ktime_get_clocktai;
+		q->tk_offset = TK_OFFS_TAI;
 		break;
 	default:
 		NL_SET_ERR_MSG(extack, "Invalid 'clockid'");
-- 
2.7.3


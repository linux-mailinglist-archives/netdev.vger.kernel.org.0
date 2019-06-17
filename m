Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2FDD48F3A
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbfFQTb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:31:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:50086 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728978AbfFQTbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 15:31:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 12:31:25 -0700
X-ExtLoop1: 1
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga007.jf.intel.com with ESMTP; 17 Jun 2019 12:31:25 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org, Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH net-next v3 5/6] taprio: make clock reference conversions easier
Date:   Mon, 17 Jun 2019 12:31:09 -0700
Message-Id: <1560799870-18956-6-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1560799870-18956-1-git-send-email-vedang.patel@intel.com>
References: <1560799870-18956-1-git-send-email-vedang.patel@intel.com>
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
index ab6080013666..f63cc3a9e69a 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -61,6 +61,7 @@ struct taprio_sched {
 	struct Qdisc **qdiscs;
 	struct Qdisc *root;
 	u32 flags;
+	enum tk_offsets tk_offset;
 	int clockid;
 	atomic64_t picos_per_byte; /* Using picoseconds because for 10Gbps+
 				    * speeds it's sub-nanoseconds per byte
@@ -71,7 +72,6 @@ struct taprio_sched {
 	struct sched_entry __rcu *current_entry;
 	struct sched_gate_list __rcu *oper_sched;
 	struct sched_gate_list __rcu *admin_sched;
-	ktime_t (*get_time)(void);
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
 	int txtime_delay;
@@ -85,6 +85,20 @@ static ktime_t sched_base_time(const struct sched_gate_list *sched)
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
@@ -288,7 +302,7 @@ static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
 	struct sched_entry *entry;
 	bool sched_changed;
 
-	now = q->get_time();
+	now = taprio_get_time(q);
 	minimum_time = ktime_add_ns(now, q->txtime_delay);
 
 	rcu_read_lock();
@@ -479,7 +493,7 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 			continue;
 
 		len = qdisc_pkt_len(skb);
-		guard = ktime_add_ns(q->get_time(),
+		guard = ktime_add_ns(taprio_get_time(q),
 				     length_to_duration(q, len));
 
 		/* In the case that there's no gate entry, there's no
@@ -848,7 +862,7 @@ static int taprio_get_start_time(struct Qdisc *sch,
 	s64 n;
 
 	base = sched_base_time(sched);
-	now = q->get_time();
+	now = taprio_get_time(q);
 
 	if (ktime_after(base, now)) {
 		*start = base;
@@ -1094,16 +1108,16 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
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


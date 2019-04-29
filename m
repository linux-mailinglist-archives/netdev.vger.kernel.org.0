Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEFCEECF0
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbfD2WtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:49:13 -0400
Received: from mga06.intel.com ([134.134.136.31]:39194 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729629AbfD2WtL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 18:49:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 15:49:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,411,1549958400"; 
   d="scan'208";a="166072456"
Received: from ellie.jf.intel.com ([10.54.70.78])
  by fmsmga002.fm.intel.com with ESMTP; 29 Apr 2019 15:49:09 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, olteanv@gmail.com,
        timo.koskiahde@tttech.com, m-karicheri2@ti.com
Subject: [PATCH net-next v1 3/4] taprio: Add support for setting the cycle-time manually
Date:   Mon, 29 Apr 2019 15:48:32 -0700
Message-Id: <20190429224833.18208-4-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190429224833.18208-1-vinicius.gomes@intel.com>
References: <20190429224833.18208-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE 802.1Q-2018 defines that a the cycle-time of a schedule may be
overridden, so the schedule is truncated to a determined "width".

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 include/uapi/linux/pkt_sched.h |  1 +
 net/sched/sch_taprio.c         | 59 +++++++++++++++++++++++++++++-----
 2 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index d59770d0eb84..7a32276838e1 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1167,6 +1167,7 @@ enum {
 	TCA_TAPRIO_ATTR_SCHED_CLOCKID, /* s32 */
 	TCA_TAPRIO_PAD,
 	TCA_TAPRIO_ATTR_ADMIN_SCHED, /* The admin sched, only used in dump */
+	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
 	__TCA_TAPRIO_ATTR_MAX,
 };
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index ec8ccaee64e6..6b37ffda23ec 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -46,6 +46,8 @@ struct sched_gate_list {
 	struct rcu_head rcu;
 	struct list_head entries;
 	size_t num_entries;
+	ktime_t cycle_close_time;
+	s64 cycle_time;
 	s64 base_time;
 };
 
@@ -105,6 +107,22 @@ static void switch_schedules(struct taprio_sched *q,
 	*admin = NULL;
 }
 
+static ktime_t get_cycle_time(struct sched_gate_list *sched)
+{
+	struct sched_entry *entry;
+	ktime_t cycle = 0;
+
+	if (sched->cycle_time != 0)
+		return sched->cycle_time;
+
+	list_for_each_entry(entry, &sched->entries, list)
+		cycle = ktime_add_ns(cycle, entry->interval);
+
+	sched->cycle_time = cycle;
+
+	return cycle;
+}
+
 static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			  struct sk_buff **to_free)
 {
@@ -256,6 +274,18 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 	return skb;
 }
 
+static bool should_restart_cycle(const struct sched_gate_list *oper,
+				 const struct sched_entry *entry)
+{
+	if (list_is_last(&entry->list, &oper->entries))
+		return true;
+
+	if (ktime_compare(entry->close_time, oper->cycle_close_time) == 0)
+		return true;
+
+	return false;
+}
+
 static bool should_change_schedules(const struct sched_gate_list *admin,
 				    const struct sched_gate_list *oper,
 				    ktime_t close_time)
@@ -309,13 +339,17 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 		goto first_run;
 	}
 
-	if (list_is_last(&entry->list, &oper->entries))
+	if (should_restart_cycle(oper, entry)) {
 		next = list_first_entry(&oper->entries, struct sched_entry,
 					list);
-	else
+		oper->cycle_close_time = ktime_add_ns(oper->cycle_close_time,
+						      oper->cycle_time);
+	} else {
 		next = list_next_entry(entry, list);
+	}
 
 	close_time = ktime_add_ns(entry->close_time, next->interval);
+	close_time = min_t(ktime_t, close_time, oper->cycle_close_time);
 
 	if (should_change_schedules(admin, oper, close_time)) {
 		/* Set things so the next time this runs, the new
@@ -360,6 +394,7 @@ static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_SCHED_BASE_TIME]      = { .type = NLA_S64 },
 	[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]   = { .type = NLA_NESTED },
 	[TCA_TAPRIO_ATTR_SCHED_CLOCKID]        = { .type = NLA_S32 },
+	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]     = { .type = NLA_S64 },
 };
 
 static int fill_sched_entry(struct nlattr **tb, struct sched_entry *entry,
@@ -461,6 +496,9 @@ static int parse_taprio_schedule(struct nlattr **tb,
 	if (tb[TCA_TAPRIO_ATTR_SCHED_BASE_TIME])
 		new->base_time = nla_get_s64(tb[TCA_TAPRIO_ATTR_SCHED_BASE_TIME]);
 
+	if (tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME])
+		new->cycle_time = nla_get_s64(tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]);
+
 	if (tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST])
 		err = parse_sched_list(
 			tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST], new, extack);
@@ -537,7 +575,6 @@ static int taprio_get_start_time(struct Qdisc *sch,
 				 ktime_t *start)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
-	struct sched_entry *entry;
 	ktime_t now, base, cycle;
 	s64 n;
 
@@ -549,11 +586,7 @@ static int taprio_get_start_time(struct Qdisc *sch,
 		return 0;
 	}
 
-	/* Calculate the cycle_time, by summing all the intervals.
-	 */
-	cycle = 0;
-	list_for_each_entry(entry, &sched->entries, list)
-		cycle = ktime_add_ns(cycle, entry->interval);
+	cycle = get_cycle_time(sched);
 
 	/* The qdisc is expected to have at least one sched_entry.  Moreover,
 	 * any entry must have 'interval' > 0. Thus if the cycle time is zero,
@@ -575,10 +608,16 @@ static void setup_first_close_time(struct taprio_sched *q,
 				   struct sched_gate_list *sched, ktime_t base)
 {
 	struct sched_entry *first;
+	ktime_t cycle;
 
 	first = list_first_entry(&sched->entries,
 				 struct sched_entry, list);
 
+	cycle = get_cycle_time(sched);
+
+	/* FIXME: find a better place to do this */
+	sched->cycle_close_time = ktime_add_ns(base, cycle);
+
 	first->close_time = ktime_add_ns(base, first->interval);
 	taprio_set_budget(q, first);
 	rcu_assign_pointer(q->current_entry, NULL);
@@ -965,6 +1004,10 @@ static int dump_schedule(struct sk_buff *msg,
 			root->base_time, TCA_TAPRIO_PAD))
 		return -1;
 
+	if (nla_put_s64(msg, TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME,
+			root->cycle_time, TCA_TAPRIO_PAD))
+		return -1;
+
 	entry_list = nla_nest_start_noflag(msg,
 					   TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST);
 	if (!entry_list)
-- 
2.21.0


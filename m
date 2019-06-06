Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCF537B7A
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbfFFRvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:51:22 -0400
Received: from mga06.intel.com ([134.134.136.31]:29817 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730315AbfFFRvL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 13:51:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 10:51:11 -0700
X-ExtLoop1: 1
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga003.jf.intel.com with ESMTP; 06 Jun 2019 10:51:11 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org, jakub.kicinski@netronome.com, m-karicheri2@ti.com,
        Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH net-next v2 3/6] taprio: calculate cycle_time when schedule is installed
Date:   Thu,  6 Jun 2019 10:50:55 -0700
Message-Id: <1559843458-12517-4-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1559843458-12517-1-git-send-email-vedang.patel@intel.com>
References: <1559843458-12517-1-git-send-email-vedang.patel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cycle time for a particular schedule is calculated only when it is first
installed. So, it makes sense to just calculate it once right after the
'cycle_time' parameter has been parsed and store it in cycle_time.

Signed-off-by: Vedang Patel <vedang.patel@intel.com>
---
 net/sched/sch_taprio.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 9ecfb8f5902a..a41d7d4434ee 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -108,22 +108,6 @@ static void switch_schedules(struct taprio_sched *q,
 	*admin = NULL;
 }
 
-static ktime_t get_cycle_time(struct sched_gate_list *sched)
-{
-	struct sched_entry *entry;
-	ktime_t cycle = 0;
-
-	if (sched->cycle_time != 0)
-		return sched->cycle_time;
-
-	list_for_each_entry(entry, &sched->entries, list)
-		cycle = ktime_add_ns(cycle, entry->interval);
-
-	sched->cycle_time = cycle;
-
-	return cycle;
-}
-
 static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			  struct sk_buff **to_free)
 {
@@ -524,6 +508,15 @@ static int parse_taprio_schedule(struct nlattr **tb,
 	if (err < 0)
 		return err;
 
+	if (!new->cycle_time) {
+		struct sched_entry *entry;
+		ktime_t cycle = 0;
+
+		list_for_each_entry(entry, &new->entries, list)
+			cycle = ktime_add_ns(cycle, entry->interval);
+		new->cycle_time = cycle;
+	}
+
 	return 0;
 }
 
@@ -605,7 +598,7 @@ static int taprio_get_start_time(struct Qdisc *sch,
 		return 0;
 	}
 
-	cycle = get_cycle_time(sched);
+	cycle = sched->cycle_time;
 
 	/* The qdisc is expected to have at least one sched_entry.  Moreover,
 	 * any entry must have 'interval' > 0. Thus if the cycle time is zero,
@@ -632,7 +625,7 @@ static void setup_first_close_time(struct taprio_sched *q,
 	first = list_first_entry(&sched->entries,
 				 struct sched_entry, list);
 
-	cycle = get_cycle_time(sched);
+	cycle = sched->cycle_time;
 
 	/* FIXME: find a better place to do this */
 	sched->cycle_close_time = ktime_add_ns(base, cycle);
-- 
2.7.3


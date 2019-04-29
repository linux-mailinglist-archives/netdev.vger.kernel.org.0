Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494ABECF1
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbfD2WtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:49:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:39194 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729593AbfD2WtL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 18:49:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 15:49:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,411,1549958400"; 
   d="scan'208";a="166072462"
Received: from ellie.jf.intel.com ([10.54.70.78])
  by fmsmga002.fm.intel.com with ESMTP; 29 Apr 2019 15:49:10 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, olteanv@gmail.com,
        timo.koskiahde@tttech.com, m-karicheri2@ti.com
Subject: [PATCH net-next v1 4/4] taprio: Add support for cycle-time-extension
Date:   Mon, 29 Apr 2019 15:48:33 -0700
Message-Id: <20190429224833.18208-5-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190429224833.18208-1-vinicius.gomes@intel.com>
References: <20190429224833.18208-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE 802.1Q-2018 defines the concept of a cycle-time-extension, so the
last entry of a schedule before the start of a new schedule can be
extended, so "too-short" entries can be avoided.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 include/uapi/linux/pkt_sched.h |  1 +
 net/sched/sch_taprio.c         | 35 ++++++++++++++++++++++++++++------
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 7a32276838e1..8b2f993cbb77 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1168,6 +1168,7 @@ enum {
 	TCA_TAPRIO_PAD,
 	TCA_TAPRIO_ATTR_ADMIN_SCHED, /* The admin sched, only used in dump */
 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
+	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
 	__TCA_TAPRIO_ATTR_MAX,
 };
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 6b37ffda23ec..539677120b9f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -48,6 +48,7 @@ struct sched_gate_list {
 	size_t num_entries;
 	ktime_t cycle_close_time;
 	s64 cycle_time;
+	s64 cycle_time_extension;
 	s64 base_time;
 };
 
@@ -290,7 +291,7 @@ static bool should_change_schedules(const struct sched_gate_list *admin,
 				    const struct sched_gate_list *oper,
 				    ktime_t close_time)
 {
-	ktime_t next_base_time;
+	ktime_t next_base_time, extension_time;
 
 	if (!admin)
 		return false;
@@ -303,6 +304,20 @@ static bool should_change_schedules(const struct sched_gate_list *admin,
 	if (ktime_compare(next_base_time, close_time) <= 0)
 		return true;
 
+	/* This is the cycle_time_extension case, if the close_time
+	 * plus the amount that can be extended would fall after the
+	 * next schedule base_time, we can extend the current schedule
+	 * for that amount.
+	 */
+	extension_time = ktime_add_ns(close_time, oper->cycle_time_extension);
+
+	/* FIXME: the IEEE 802.1Q-2018 Specification isn't clear about
+	 * how precisely the extension should be made. So after
+	 * conformance testing, this logic may change.
+	 */
+	if (ktime_compare(next_base_time, extension_time) <= 0)
+		return true;
+
 	return false;
 }
 
@@ -390,11 +405,12 @@ static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_PRIOMAP]	       = {
 		.len = sizeof(struct tc_mqprio_qopt)
 	},
-	[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST]     = { .type = NLA_NESTED },
-	[TCA_TAPRIO_ATTR_SCHED_BASE_TIME]      = { .type = NLA_S64 },
-	[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]   = { .type = NLA_NESTED },
-	[TCA_TAPRIO_ATTR_SCHED_CLOCKID]        = { .type = NLA_S32 },
-	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]     = { .type = NLA_S64 },
+	[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST]           = { .type = NLA_NESTED },
+	[TCA_TAPRIO_ATTR_SCHED_BASE_TIME]            = { .type = NLA_S64 },
+	[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]         = { .type = NLA_NESTED },
+	[TCA_TAPRIO_ATTR_SCHED_CLOCKID]              = { .type = NLA_S32 },
+	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]           = { .type = NLA_S64 },
+	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION] = { .type = NLA_S64 },
 };
 
 static int fill_sched_entry(struct nlattr **tb, struct sched_entry *entry,
@@ -496,6 +512,9 @@ static int parse_taprio_schedule(struct nlattr **tb,
 	if (tb[TCA_TAPRIO_ATTR_SCHED_BASE_TIME])
 		new->base_time = nla_get_s64(tb[TCA_TAPRIO_ATTR_SCHED_BASE_TIME]);
 
+	if (tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION])
+		new->cycle_time_extension = nla_get_s64(tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION]);
+
 	if (tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME])
 		new->cycle_time = nla_get_s64(tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]);
 
@@ -1008,6 +1027,10 @@ static int dump_schedule(struct sk_buff *msg,
 			root->cycle_time, TCA_TAPRIO_PAD))
 		return -1;
 
+	if (nla_put_s64(msg, TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION,
+			root->cycle_time_extension, TCA_TAPRIO_PAD))
+		return -1;
+
 	entry_list = nla_nest_start_noflag(msg,
 					   TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST);
 	if (!entry_list)
-- 
2.21.0


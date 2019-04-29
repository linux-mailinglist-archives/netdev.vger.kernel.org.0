Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D30ECF9
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbfD2Wwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:52:34 -0400
Received: from mga12.intel.com ([192.55.52.136]:42478 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729630AbfD2Wwd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 18:52:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 15:52:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,411,1549958400"; 
   d="scan'208";a="166072984"
Received: from ellie.jf.intel.com ([10.54.70.78])
  by fmsmga002.fm.intel.com with ESMTP; 29 Apr 2019 15:52:32 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: [PATCH iproute2 net-next v1 2/3] taprio: Add support for changing schedules
Date:   Mon, 29 Apr 2019 15:52:18 -0700
Message-Id: <20190429225219.18984-2-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190429225219.18984-1-vinicius.gomes@intel.com>
References: <20190429225219.18984-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows for a new schedule to be specified during runtime, without
removing the current one.

For that, the semantics of the 'tc qdisc change' operation in the
context of taprio is that if "change" is called and there is a running
schedule, a new schedule is created and the base-time (let's call it
X) of this new schedule is used so at instant X, it becomes the
"current" schedule. So, in short, "change" doesn't change the current
schedule, it creates a new one and sets it up to it becomes the
current one at some point.

In IEEE 802.1Q terms, it means that we have support for the
"Oper" (current and read-only) and "Admin" (future and mutable)
schedules.

Example of creating the first schedule, then adding a new one:

(1)
tc qdisc add dev IFACE parent root handle 100 taprio \
      	      num_tc 1 \
	      map 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 \
	      queues 1@0 \
	      sched-entry S 0x1 1000000 \
	      sched-entry S 0x0 2000000 \
	      sched-entry S 0x1 3000000 \
	      sched-entry S 0x0 4000000 \
	      base-time 100000000 \
	      clockid CLOCK_TAI

(2)
tc qdisc change dev IFACE parent root handle 100 taprio \
	      base-time 7500000000000 \
	      sched-entry S 0x0 5000000 \
              sched-entry S 0x1 5000000 \

It was necessary to fix a bug, so the clockid doesn't need to be
specified when changing the schedule.

Most of the changes are related to make it easier to reuse the same
function for printing the "admin" and "oper" schedules.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 tc/q_taprio.c | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index 8f6b263a..336bb245 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -268,14 +268,15 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 	tail = NLMSG_TAIL(n);
 	addattr_l(n, 1024, TCA_OPTIONS, NULL, 0);
 
+	if (clockid != CLOCKID_INVALID)
+		addattr_l(n, 1024, TCA_TAPRIO_ATTR_SCHED_CLOCKID, &clockid, sizeof(clockid));
+
 	if (opt.num_tc > 0)
 		addattr_l(n, 1024, TCA_TAPRIO_ATTR_PRIOMAP, &opt, sizeof(opt));
 
 	if (base_time)
 		addattr_l(n, 1024, TCA_TAPRIO_ATTR_SCHED_BASE_TIME, &base_time, sizeof(base_time));
 
-	addattr_l(n, 1024, TCA_TAPRIO_ATTR_SCHED_CLOCKID, &clockid, sizeof(clockid));
-
 	if (!list_empty(&sched_entries)) {
 		struct rtattr *entry_list;
 		entry_list = addattr_nest(n, 1024, TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST | NLA_F_NESTED);
@@ -306,6 +307,8 @@ static int print_sched_list(FILE *f, struct rtattr *list)
 
 	open_json_array(PRINT_JSON, "schedule");
 
+	print_string(PRINT_FP, NULL, "%s", _SL_);
+
 	for (item = RTA_DATA(list); RTA_OK(item, rem); item = RTA_NEXT(item, rem)) {
 		struct rtattr *tb[TCA_TAPRIO_SCHED_ENTRY_MAX + 1];
 		__u32 index = 0, gatemask = 0, interval = 0;
@@ -340,12 +343,25 @@ static int print_sched_list(FILE *f, struct rtattr *list)
 	return 0;
 }
 
+static int print_schedule(FILE *f, struct rtattr **tb)
+{
+	int64_t base_time = 0;
+
+	if (tb[TCA_TAPRIO_ATTR_SCHED_BASE_TIME])
+		base_time = rta_getattr_s64(tb[TCA_TAPRIO_ATTR_SCHED_BASE_TIME]);
+
+	print_lluint(PRINT_ANY, "base_time", "\tbase-time %lld", base_time);
+
+	print_sched_list(f, tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST]);
+
+	return 0;
+}
+
 static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 {
 	struct rtattr *tb[TCA_TAPRIO_ATTR_MAX + 1];
 	struct tc_mqprio_qopt *qopt = 0;
 	__s32 clockid = CLOCKID_INVALID;
-	__s64 base_time = 0;
 	int i;
 
 	if (opt == NULL)
@@ -378,19 +394,27 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 
 	print_string(PRINT_FP, NULL, "%s", _SL_);
 
-	if (tb[TCA_TAPRIO_ATTR_SCHED_BASE_TIME])
-		base_time = rta_getattr_s64(tb[TCA_TAPRIO_ATTR_SCHED_BASE_TIME]);
-
 	if (tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID])
 		clockid = rta_getattr_s32(tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]);
 
 	print_string(PRINT_ANY, "clockid", "clockid %s", get_clock_name(clockid));
 
-	print_lluint(PRINT_ANY, "base_time", " base-time %lld", base_time);
+	print_schedule(f, tb);
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	if (tb[TCA_TAPRIO_ATTR_ADMIN_SCHED]) {
+		struct rtattr *t[TCA_TAPRIO_ATTR_MAX + 1];
+
+		parse_rtattr_nested(t, TCA_TAPRIO_ATTR_MAX,
+				    tb[TCA_TAPRIO_ATTR_ADMIN_SCHED]);
 
-	return print_sched_list(f, tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST]);
+		open_json_object(NULL);
+
+		print_schedule(f, t);
+
+		close_json_object();
+	}
+
+	return 0;
 }
 
 struct qdisc_util taprio_qdisc_util = {
-- 
2.21.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1341ECFA
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729669AbfD2Wwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:52:37 -0400
Received: from mga12.intel.com ([192.55.52.136]:42478 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729650AbfD2Wwd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 18:52:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 15:52:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,411,1549958400"; 
   d="scan'208";a="166072988"
Received: from ellie.jf.intel.com ([10.54.70.78])
  by fmsmga002.fm.intel.com with ESMTP; 29 Apr 2019 15:52:32 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: [PATCH iproute2 net-next v1 3/3] taprio: Add support for cycle_time and cycle_time_extension
Date:   Mon, 29 Apr 2019 15:52:19 -0700
Message-Id: <20190429225219.18984-3-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190429225219.18984-1-vinicius.gomes@intel.com>
References: <20190429225219.18984-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows a cycle-time and a cycle-time-extension to be specified.

Specifying a cycle-time will truncate that cycle, so when that instant
is reached, the cycle will start from its beginning.

A cycle-time-extension may cause the last entry of a cycle, just
before the start of a new schedule (the base-time of the "admin"
schedule) to be extended by at maximum "cycle-time-extension"
nanoseconds. The idea of this feauture, as described by the IEEE
802.1Q, is too avoid too narrow gate states.

Example:

tc qdisc change dev IFACE parent root handle 100 taprio \
	      sched-entry S 0x1 1000000 \
	      sched-entry S 0x0 2000000 \
	      sched-entry S 0x1 3000000 \
	      sched-entry S 0x0 4000000 \
	      cycle-time-extension 100000 \
	      cycle-time 9000000 \
	      base-time 12345678900000000

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 tc/q_taprio.c | 64 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 53 insertions(+), 11 deletions(-)

diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index 336bb245..aad055d8 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -155,8 +155,10 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 {
 	__s32 clockid = CLOCKID_INVALID;
 	struct tc_mqprio_qopt opt = { };
+	__s64 cycle_time_extension = 0;
 	struct list_head sched_entries;
-	struct rtattr *tail;
+	struct rtattr *tail, *l;
+	__s64 cycle_time = 0;
 	__s64 base_time = 0;
 	int err, idx;
 
@@ -245,6 +247,29 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 				PREV_ARG();
 				break;
 			}
+		} else if (strcmp(*argv, "cycle-time") == 0) {
+			NEXT_ARG();
+			if (cycle_time) {
+				fprintf(stderr, "taprio: duplicate \"cycle-time\" specification\n");
+				return -1;
+			}
+
+			if (get_s64(&cycle_time, *argv, 10)) {
+				PREV_ARG();
+				break;
+			}
+
+		} else if (strcmp(*argv, "cycle-time-extension") == 0) {
+			NEXT_ARG();
+			if (cycle_time_extension) {
+				fprintf(stderr, "taprio: duplicate \"cycle-time-extension\" specification\n");
+				return -1;
+			}
+
+			if (get_s64(&cycle_time_extension, *argv, 10)) {
+				PREV_ARG();
+				break;
+			}
 		} else if (strcmp(*argv, "clockid") == 0) {
 			NEXT_ARG();
 			if (clockid != CLOCKID_INVALID) {
@@ -277,19 +302,24 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 	if (base_time)
 		addattr_l(n, 1024, TCA_TAPRIO_ATTR_SCHED_BASE_TIME, &base_time, sizeof(base_time));
 
-	if (!list_empty(&sched_entries)) {
-		struct rtattr *entry_list;
-		entry_list = addattr_nest(n, 1024, TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST | NLA_F_NESTED);
+	if (cycle_time)
+		addattr_l(n, 1024, TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME,
+			  &cycle_time, sizeof(cycle_time));
 
-		err = add_sched_list(&sched_entries, n);
-		if (err < 0) {
-			fprintf(stderr, "Could not add schedule to netlink message\n");
-			return -1;
-		}
+	if (cycle_time_extension)
+		addattr_l(n, 1024, TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION,
+			  &cycle_time_extension, sizeof(cycle_time_extension));
+
+	l = addattr_nest(n, 1024, TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST | NLA_F_NESTED);
 
-		addattr_nest_end(n, entry_list);
+	err = add_sched_list(&sched_entries, n);
+	if (err < 0) {
+		fprintf(stderr, "Could not add schedule to netlink message\n");
+		return -1;
 	}
 
+	addattr_nest_end(n, l);
+
 	tail->rta_len = (void *) NLMSG_TAIL(n) - (void *) tail;
 
 	return 0;
@@ -345,13 +375,25 @@ static int print_sched_list(FILE *f, struct rtattr *list)
 
 static int print_schedule(FILE *f, struct rtattr **tb)
 {
-	int64_t base_time = 0;
+	int64_t base_time = 0, cycle_time = 0, cycle_time_extension = 0;
 
 	if (tb[TCA_TAPRIO_ATTR_SCHED_BASE_TIME])
 		base_time = rta_getattr_s64(tb[TCA_TAPRIO_ATTR_SCHED_BASE_TIME]);
 
+	if (tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME])
+		cycle_time = rta_getattr_s64(tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]);
+
+	if (tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION])
+		cycle_time_extension = rta_getattr_s64(
+			tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION]);
+
 	print_lluint(PRINT_ANY, "base_time", "\tbase-time %lld", base_time);
 
+	print_lluint(PRINT_ANY, "cycle_time", " cycle-time %lld", cycle_time);
+
+	print_lluint(PRINT_ANY, "cycle_time_extension",
+		     " cycle-time-extension %lld", cycle_time_extension);
+
 	print_sched_list(f, tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST]);
 
 	return 0;
-- 
2.21.0


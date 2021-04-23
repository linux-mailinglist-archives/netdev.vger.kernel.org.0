Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753FA369BE3
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244078AbhDWVJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:09:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:19564 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244132AbhDWVJS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 17:09:18 -0400
IronPort-SDR: pl0tWENhnVXVPKlsFA2lrJSBodV5Mgy/8+ESzR9MpRWGLEdguRDOhaaPTD+cQF9zTsTHzjh8rX
 4r83COdboFgw==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="192946331"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="192946331"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 14:08:16 -0700
IronPort-SDR: v+HsLChDWD6yHecvmGtxWukhEzlCMHsMurI5T3fVHpjRqRBW7xtj/GNyXscr3ugMPotLzVxnqE
 s6e/vKw4bo9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="421885719"
Received: from anambiarhost.jf.intel.com ([10.166.224.238])
  by fmsmga008.fm.intel.com with ESMTP; 23 Apr 2021 14:08:16 -0700
Subject: [iproute2-next,
 RFC PATCH] tc/mqprio: Extend TC limit beyond 16 to 255
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@kernel.org
Cc:     jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        john.fastabend@gmail.com, alexander.duyck@gmail.com,
        vinicius.gomes@intel.com, vedang.patel@intel.com,
        sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date:   Fri, 23 Apr 2021 14:12:32 -0700
Message-ID: <161921235266.33234.11141506572174881.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the max limit of TCs to 255 from current max of 16. This
requires the size of certain netlink messages to be increased to
2048 from 1024 to support the additional attribute options (that
depends on the number of TCs).

Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 include/uapi/linux/pkt_sched.h |    6 +++---
 tc/q_mqprio.c                  |   12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 79a699f1..b5d73313 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -692,8 +692,8 @@ struct tc_drr_stats {
 };
 
 /* MQPRIO */
-#define TC_QOPT_BITMASK 15
-#define TC_QOPT_MAX_QUEUE 16
+#define TC_QOPT_BITMASK 255
+#define TC_QOPT_MAX_QUEUE 255
 
 enum {
 	TC_MQPRIO_HW_OFFLOAD_NONE,	/* no offload requested */
@@ -721,7 +721,7 @@ enum {
 
 struct tc_mqprio_qopt {
 	__u8	num_tc;
-	__u8	prio_tc_map[TC_QOPT_BITMASK + 1];
+	__u8	prio_tc_map[TC_QOPT_BITMASK];
 	__u8	hw;
 	__u16	count[TC_QOPT_MAX_QUEUE];
 	__u16	offset[TC_QOPT_MAX_QUEUE];
diff --git a/tc/q_mqprio.c b/tc/q_mqprio.c
index 706452d0..59960020 100644
--- a/tc/q_mqprio.c
+++ b/tc/q_mqprio.c
@@ -182,7 +182,7 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
 	}
 
 	tail = NLMSG_TAIL(n);
-	addattr_l(n, 1024, TCA_OPTIONS, &opt, sizeof(opt));
+	addattr_l(n, 2048, TCA_OPTIONS, &opt, sizeof(opt));
 
 	if (flags & TC_MQPRIO_F_MODE)
 		addattr_l(n, 1024, TCA_MQPRIO_MODE,
@@ -194,11 +194,11 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
 	if (flags & TC_MQPRIO_F_MIN_RATE) {
 		struct rtattr *start;
 
-		start = addattr_nest(n, 1024,
+		start = addattr_nest(n, 2048,
 				     TCA_MQPRIO_MIN_RATE64 | NLA_F_NESTED);
 
 		for (idx = 0; idx < TC_QOPT_MAX_QUEUE; idx++)
-			addattr_l(n, 1024, TCA_MQPRIO_MIN_RATE64,
+			addattr_l(n, 2048, TCA_MQPRIO_MIN_RATE64,
 				  &min_rate64[idx], sizeof(min_rate64[idx]));
 
 		addattr_nest_end(n, start);
@@ -207,11 +207,11 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
 	if (flags & TC_MQPRIO_F_MAX_RATE) {
 		struct rtattr *start;
 
-		start = addattr_nest(n, 1024,
+		start = addattr_nest(n, 2048,
 				     TCA_MQPRIO_MAX_RATE64 | NLA_F_NESTED);
 
 		for (idx = 0; idx < TC_QOPT_MAX_QUEUE; idx++)
-			addattr_l(n, 1024, TCA_MQPRIO_MAX_RATE64,
+			addattr_l(n, 2048, TCA_MQPRIO_MAX_RATE64,
 				  &max_rate64[idx], sizeof(max_rate64[idx]));
 
 		addattr_nest_end(n, start);
@@ -243,7 +243,7 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 
 	print_uint(PRINT_ANY, "tc", "tc %u ", qopt->num_tc);
 	open_json_array(PRINT_ANY, is_json_context() ? "map" : "map ");
-	for (i = 0; i <= TC_PRIO_MAX; i++)
+	for (i = 0; i < qopt->num_tc; i++)
 		print_uint(PRINT_ANY, NULL, "%u ", qopt->prio_tc_map[i]);
 	close_json_array(PRINT_ANY, "");
 	open_json_array(PRINT_ANY, is_json_context() ? "queues" : "\n             queues:");


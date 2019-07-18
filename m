Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF7016D580
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391450AbfGRTzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:55:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:40934 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbfGRTzr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 15:55:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 12:55:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,279,1559545200"; 
   d="scan'208";a="158881601"
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga007.jf.intel.com with ESMTP; 18 Jul 2019 12:55:47 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com, dsahern@gmail.com,
        Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH iproute2 net-next v5 2/5] taprio: Add support for setting flags
Date:   Thu, 18 Jul 2019 12:55:40 -0700
Message-Id: <1563479743-8371-2-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1563479743-8371-1-git-send-email-vedang.patel@intel.com>
References: <1563479743-8371-1-git-send-email-vedang.patel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

This allows a new parameter, flags, to be passed to taprio. Currently, it
only supports enabling the txtime-assist mode. But, we plan to add
different modes for taprio (e.g. hardware offloading) and this parameter
will be useful in enabling those modes.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
---
 tc/q_taprio.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index 62c8c591da99..1db2aba6efe7 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -159,6 +159,7 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 	__s64 cycle_time_extension = 0;
 	struct list_head sched_entries;
 	struct rtattr *tail, *l;
+	__u32 taprio_flags = 0;
 	__s64 cycle_time = 0;
 	__s64 base_time = 0;
 	int err, idx;
@@ -281,6 +282,17 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 				explain_clockid(*argv);
 				return -1;
 			}
+		} else if (strcmp(*argv, "flags") == 0) {
+			NEXT_ARG();
+			if (taprio_flags) {
+				fprintf(stderr, "taprio: duplicate \"flags\" specification\n");
+				return -1;
+			}
+			if (get_u32(&taprio_flags, *argv, 0)) {
+				PREV_ARG();
+				return -1;
+			}
+
 		} else if (strcmp(*argv, "help") == 0) {
 			explain();
 			return -1;
@@ -297,6 +309,9 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 	if (clockid != CLOCKID_INVALID)
 		addattr_l(n, 1024, TCA_TAPRIO_ATTR_SCHED_CLOCKID, &clockid, sizeof(clockid));
 
+	if (taprio_flags)
+		addattr_l(n, 1024, TCA_TAPRIO_ATTR_FLAGS, &taprio_flags, sizeof(taprio_flags));
+
 	if (opt.num_tc > 0)
 		addattr_l(n, 1024, TCA_TAPRIO_ATTR_PRIOMAP, &opt, sizeof(opt));
 
@@ -442,6 +457,13 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 
 	print_string(PRINT_ANY, "clockid", "clockid %s", get_clock_name(clockid));
 
+	if (tb[TCA_TAPRIO_ATTR_FLAGS]) {
+		__u32 flags;
+
+		flags = rta_getattr_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
+		print_0xhex(PRINT_ANY, "flags", " flags %#x", flags);
+	}
+
 	print_schedule(f, tb);
 
 	if (tb[TCA_TAPRIO_ATTR_ADMIN_SCHED]) {
-- 
2.7.3


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A4138081
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbfFFWWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:22:37 -0400
Received: from mga05.intel.com ([192.55.52.43]:40655 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729174AbfFFWWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 18:22:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 15:22:34 -0700
X-ExtLoop1: 1
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga001.jf.intel.com with ESMTP; 06 Jun 2019 15:22:34 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com, Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH iproute2 net-next v2 4/6] taprio: add support for setting txtime_delay.
Date:   Thu,  6 Jun 2019 15:22:13 -0700
Message-Id: <1559859735-17237-4-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1559859735-17237-1-git-send-email-vedang.patel@intel.com>
References: <1559859735-17237-1-git-send-email-vedang.patel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for setting the txtime_delay parameter which is useful
for the txtime offload mode of taprio.

Signed-off-by: Vedang Patel <vedang.patel@intel.com>
---
 tc/q_taprio.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index 930ecb9d1eef..13bd5c44cac9 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -52,7 +52,7 @@ static void explain(void)
 		"		[num_tc NUMBER] [map P0 P1 ...] "
 		"		[queues COUNT@OFFSET COUNT@OFFSET COUNT@OFFSET ...] "
 		"		[ [sched-entry index cmd gate-mask interval] ... ] "
-		"		[base-time time] "
+		"		[base-time time] [txtime-delay delay]"
 		"\n"
 		"CLOCKID must be a valid SYS-V id (i.e. CLOCK_TAI)\n");
 }
@@ -162,6 +162,7 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 	struct rtattr *tail, *l;
 	__s64 cycle_time = 0;
 	__s64 base_time = 0;
+	__s32 txtime_delay = 0;
 	int err, idx;
 
 	INIT_LIST_HEAD(&sched_entries);
@@ -293,6 +294,17 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 				return -1;
 			}
 
+		} else if (strcmp(*argv, "txtime-delay") == 0) {
+			NEXT_ARG();
+			if (txtime_delay != 0) {
+				fprintf(stderr, "taprio: duplicate \"txtime-delay\" specification\n");
+				return -1;
+			}
+			if (get_s32(&txtime_delay, *argv, 0)) {
+				PREV_ARG();
+				return -1;
+			}
+
 		} else if (strcmp(*argv, "help") == 0) {
 			explain();
 			return -1;
@@ -315,6 +327,9 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 	if (opt.num_tc > 0)
 		addattr_l(n, 1024, TCA_TAPRIO_ATTR_PRIOMAP, &opt, sizeof(opt));
 
+	if (txtime_delay)
+		addattr_l(n, 1024, TCA_TAPRIO_ATTR_TXTIME_DELAY, &txtime_delay, sizeof(txtime_delay));
+
 	if (base_time)
 		addattr_l(n, 1024, TCA_TAPRIO_ATTR_SCHED_BASE_TIME, &base_time, sizeof(base_time));
 
@@ -421,6 +436,7 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	struct tc_mqprio_qopt *qopt = 0;
 	__s32 clockid = CLOCKID_INVALID;
 	__u32 taprio_flags = 0;
+	__s32 txtime_delay = 0;
 	int i;
 
 	if (opt == NULL)
@@ -463,6 +479,11 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		print_uint(PRINT_ANY, "flags", " flags %x", taprio_flags);
 	}
 
+	if (tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]) {
+		txtime_delay = rta_getattr_s32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]);
+		print_int(PRINT_ANY, "txtime_delay", " txtime delay %d", txtime_delay);
+	}
+
 	print_schedule(f, tb);
 
 	if (tb[TCA_TAPRIO_ATTR_ADMIN_SCHED]) {
-- 
2.7.3


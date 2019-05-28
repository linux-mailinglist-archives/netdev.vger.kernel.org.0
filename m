Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA75B2CE0C
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 19:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfE1RxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 13:53:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:39629 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727482AbfE1RxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 13:53:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 10:53:01 -0700
X-ExtLoop1: 1
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga007.jf.intel.com with ESMTP; 28 May 2019 10:53:01 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com
Subject: [PATCH iproute2 net-next v1 3/6] taprio: Add support for enabling offload mode
Date:   Tue, 28 May 2019 10:52:51 -0700
Message-Id: <1559065974-28521-3-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1559065974-28521-1-git-send-email-vedang.patel@intel.com>
References: <1559065974-28521-1-git-send-email-vedang.patel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

This allows a new parameter to be passed to taprio, "offload",
accepting a hexadecimal number which selects the offloading flags
thats should be enabled.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 tc/q_taprio.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index 62c8c591..69e52ff5 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -154,6 +154,7 @@ static struct sched_entry *create_entry(uint32_t gatemask, uint32_t interval, ui
 static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 			    char **argv, struct nlmsghdr *n, const char *dev)
 {
+	__u32 offload_flags = UINT32_MAX;
 	__s32 clockid = CLOCKID_INVALID;
 	struct tc_mqprio_qopt opt = { };
 	__s64 cycle_time_extension = 0;
@@ -281,6 +282,17 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 				explain_clockid(*argv);
 				return -1;
 			}
+		} else if (strcmp(*argv, "offload") == 0) {
+			NEXT_ARG();
+			if (offload_flags != UINT32_MAX) {
+				fprintf(stderr, "taprio: duplicate \"offload\" specification\n");
+				return -1;
+			}
+			if (get_u32(&offload_flags, *argv, 0)) {
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
 
+	if (offload_flags != UINT32_MAX)
+		addattr_l(n, 1024, TCA_TAPRIO_ATTR_OFFLOAD_FLAGS, &offload_flags, sizeof(offload_flags));
+
 	if (opt.num_tc > 0)
 		addattr_l(n, 1024, TCA_TAPRIO_ATTR_PRIOMAP, &opt, sizeof(opt));
 
@@ -405,6 +420,7 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	struct rtattr *tb[TCA_TAPRIO_ATTR_MAX + 1];
 	struct tc_mqprio_qopt *qopt = 0;
 	__s32 clockid = CLOCKID_INVALID;
+	__u32 offload_flags = 0;
 	int i;
 
 	if (opt == NULL)
@@ -442,6 +458,11 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 
 	print_string(PRINT_ANY, "clockid", "clockid %s", get_clock_name(clockid));
 
+	if (tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS])
+		offload_flags = rta_getattr_u32(tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS]);
+
+	print_uint(PRINT_ANY, "offload", " offload %x", offload_flags);
+
 	print_schedule(f, tb);
 
 	if (tb[TCA_TAPRIO_ATTR_ADMIN_SCHED]) {
-- 
2.17.0


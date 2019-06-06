Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65D733807F
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbfFFWWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:22:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:40653 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729173AbfFFWWd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 18:22:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 15:22:33 -0700
X-ExtLoop1: 1
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga001.jf.intel.com with ESMTP; 06 Jun 2019 15:22:33 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com, Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH iproute2 net-next v2 3/6] taprio: Add support for setting flags
Date:   Thu,  6 Jun 2019 15:22:12 -0700
Message-Id: <1559859735-17237-3-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1559859735-17237-1-git-send-email-vedang.patel@intel.com>
References: <1559859735-17237-1-git-send-email-vedang.patel@intel.com>
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
 tc/q_taprio.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index 62c8c591da99..930ecb9d1eef 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -154,6 +154,7 @@ static struct sched_entry *create_entry(uint32_t gatemask, uint32_t interval, ui
 static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 			    char **argv, struct nlmsghdr *n, const char *dev)
 {
+	__u32 taprio_flags = UINT32_MAX;
 	__s32 clockid = CLOCKID_INVALID;
 	struct tc_mqprio_qopt opt = { };
 	__s64 cycle_time_extension = 0;
@@ -281,6 +282,17 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 				explain_clockid(*argv);
 				return -1;
 			}
+		} else if (strcmp(*argv, "flags") == 0) {
+			NEXT_ARG();
+			if (taprio_flags != UINT32_MAX) {
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
 
+	if (taprio_flags != UINT32_MAX)
+		addattr_l(n, 1024, TCA_TAPRIO_ATTR_FLAGS, &taprio_flags, sizeof(taprio_flags));
+
 	if (opt.num_tc > 0)
 		addattr_l(n, 1024, TCA_TAPRIO_ATTR_PRIOMAP, &opt, sizeof(opt));
 
@@ -405,6 +420,7 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	struct rtattr *tb[TCA_TAPRIO_ATTR_MAX + 1];
 	struct tc_mqprio_qopt *qopt = 0;
 	__s32 clockid = CLOCKID_INVALID;
+	__u32 taprio_flags = 0;
 	int i;
 
 	if (opt == NULL)
@@ -442,6 +458,11 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 
 	print_string(PRINT_ANY, "clockid", "clockid %s", get_clock_name(clockid));
 
+	if (tb[TCA_TAPRIO_ATTR_FLAGS]) {
+		taprio_flags = rta_getattr_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
+		print_uint(PRINT_ANY, "flags", " flags %x", taprio_flags);
+	}
+
 	print_schedule(f, tb);
 
 	if (tb[TCA_TAPRIO_ATTR_ADMIN_SCHED]) {
-- 
2.7.3


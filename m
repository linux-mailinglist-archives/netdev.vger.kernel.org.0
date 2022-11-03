Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9554617665
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 06:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiKCFxg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Nov 2022 01:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiKCFxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 01:53:31 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CC56259
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 22:53:25 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVquh020776
        for <netdev@vger.kernel.org>; Wed, 2 Nov 2022 22:53:24 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3kkhd9jypv-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 22:53:24 -0700
Received: from twshared13315.14.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 22:53:22 -0700
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id 2E9BD2102ECF8; Wed,  2 Nov 2022 22:53:18 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 06/10] selftests/bpf: support simple filtering of stats in veristat
Date:   Wed, 2 Nov 2022 22:53:00 -0700
Message-ID: <20221103055304.2904589-7-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221103055304.2904589-1-andrii@kernel.org>
References: <20221103055304.2904589-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: orCF8FExfP4JibNShQbjR1LbAukHs7Hn
X-Proofpoint-ORIG-GUID: orCF8FExfP4JibNShQbjR1LbAukHs7Hn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define simple expressions to filter not just by file and program name,
but also by resulting values of collected stats. Support usual
equality and inequality operators. Verdict, which is a boolean-like
field can be also filtered either as 0/1, failure/success (with f/s,
fail/succ, and failure/success aliases) symbols, or as false/true (f/t).
Aliases are case insensitive.

Currently this filtering is honored only in verification and replay
modes. Comparison mode support will be added in next patch.

Here's an example of verifying a bunch of BPF object files and emitting
only results for successfully validated programs that have more than 100
total instructions processed by BPF verifier, sorted by number of
instructions in ascending order:

  $ sudo ./veristat *.bpf.o -s insns^ -f 'insns>100'

There can be many filters (both allow and deny flavors), all of them are
combined.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c | 158 ++++++++++++++++++++++++-
 1 file changed, 157 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index 56ba55156abb..37e512d233a7 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -54,10 +54,30 @@ enum resfmt {
 	RESFMT_CSV,
 };
 
+enum filter_kind {
+	FILTER_NAME,
+	FILTER_STAT,
+};
+
+enum operator_kind {
+	OP_EQ,		/* == or = */
+	OP_NEQ,		/* != or <> */
+	OP_LT,		/* < */
+	OP_LE,		/* <= */
+	OP_GT,		/* > */
+	OP_GE,		/* >= */
+};
+
 struct filter {
+	enum filter_kind kind;
+	/* FILTER_NAME */
 	char *any_glob;
 	char *file_glob;
 	char *prog_glob;
+	/* FILTER_STAT */
+	enum operator_kind op;
+	int stat_id;
+	long value;
 };
 
 static struct env {
@@ -271,6 +291,8 @@ static bool should_process_file_prog(const char *filename, const char *prog_name
 
 	for (i = 0; i < env.deny_filter_cnt; i++) {
 		f = &env.deny_filters[i];
+		if (f->kind != FILTER_NAME)
+			continue;
 
 		if (f->any_glob && glob_matches(filename, f->any_glob))
 			return false;
@@ -284,8 +306,10 @@ static bool should_process_file_prog(const char *filename, const char *prog_name
 
 	for (i = 0; i < env.allow_filter_cnt; i++) {
 		f = &env.allow_filters[i];
-		allow_cnt++;
+		if (f->kind != FILTER_NAME)
+			continue;
 
+		allow_cnt++;
 		if (f->any_glob) {
 			if (glob_matches(filename, f->any_glob))
 				return true;
@@ -306,11 +330,32 @@ static bool should_process_file_prog(const char *filename, const char *prog_name
 	return allow_cnt == 0;
 }
 
+static struct {
+	enum operator_kind op_kind;
+	const char *op_str;
+} operators[] = {
+	/* Order of these definitions matter to avoid situations like '<'
+	 * matching part of what is actually a '<>' operator. That is,
+	 * substrings should go last.
+	 */
+	{ OP_EQ, "==" },
+	{ OP_NEQ, "!=" },
+	{ OP_NEQ, "<>" },
+	{ OP_LE, "<=" },
+	{ OP_LT, "<" },
+	{ OP_GE, ">=" },
+	{ OP_GT, ">" },
+	{ OP_EQ, "=" },
+};
+
+static bool parse_stat_id(const char *name, size_t len, int *id);
+
 static int append_filter(struct filter **filters, int *cnt, const char *str)
 {
 	struct filter *f;
 	void *tmp;
 	const char *p;
+	int i;
 
 	tmp = realloc(*filters, (*cnt + 1) * sizeof(**filters));
 	if (!tmp)
@@ -320,6 +365,67 @@ static int append_filter(struct filter **filters, int *cnt, const char *str)
 	f = &(*filters)[*cnt];
 	memset(f, 0, sizeof(*f));
 
+	/* First, let's check if it's a stats filter of the following form:
+	 * <stat><op><value, where:
+	 *   - <stat> is one of supported numerical stats (verdict is also
+	 *     considered numerical, failure == 0, success == 1);
+	 *   - <op> is comparison operator (see `operators` definitions);
+	 *   - <value> is an integer (or failure/success, or false/true as
+	 *     special aliases for 0 and 1, respectively).
+	 * If the form doesn't match what user provided, we assume file/prog
+	 * glob filter.
+	 */
+	for (i = 0; i < ARRAY_SIZE(operators); i++) {
+		int id;
+		long val;
+		const char *end = str;
+		const char *op_str;
+
+		op_str = operators[i].op_str;
+		p = strstr(str, op_str);
+		if (!p)
+			continue;
+
+		if (!parse_stat_id(str, p - str, &id)) {
+			fprintf(stderr, "Unrecognized stat name in '%s'!\n", str);
+			return -EINVAL;
+		}
+		if (id >= FILE_NAME) {
+			fprintf(stderr, "Non-integer stat is specified in '%s'!\n", str);
+			return -EINVAL;
+		}
+
+		p += strlen(op_str);
+
+		if (strcasecmp(p, "true") == 0 ||
+		    strcasecmp(p, "t") == 0 ||
+		    strcasecmp(p, "success") == 0 ||
+		    strcasecmp(p, "succ") == 0 ||
+		    strcasecmp(p, "s") == 0) {
+			val = 1;
+		} else if (strcasecmp(p, "false") == 0 ||
+			   strcasecmp(p, "f") == 0 ||
+			   strcasecmp(p, "failure") == 0 ||
+			   strcasecmp(p, "fail") == 0) {
+			val = 0;
+		} else {
+			errno = 0;
+			val = strtol(p, (char **)&end, 10);
+			if (errno || end == p || *end != '\0' ) {
+				fprintf(stderr, "Invalid integer value in '%s'!\n", str);
+				return -EINVAL;
+			}
+		}
+
+		f->kind = FILTER_STAT;
+		f->stat_id = id;
+		f->op = operators[i].op_kind;
+		f->value = val;
+
+		*cnt += 1;
+		return 0;
+	}
+
 	/* File/prog filter can be specified either as '<glob>' or
 	 * '<file-glob>/<prog-glob>'. In the former case <glob> is applied to
 	 * both file and program names. This seems to be way more useful in
@@ -328,6 +434,7 @@ static int append_filter(struct filter **filters, int *cnt, const char *str)
 	 * name. But usually common <glob> seems to be the most useful and
 	 * ergonomic way.
 	 */
+	f->kind = FILTER_NAME;
 	p = strchr(str, '/');
 	if (!p) {
 		f->any_glob = strdup(str);
@@ -1317,6 +1424,51 @@ static int handle_comparison_mode(void)
 	return 0;
 }
 
+static bool is_stat_filter_matched(struct filter *f, const struct verif_stats *stats)
+{
+	long value = stats->stats[f->stat_id];
+
+	switch (f->op) {
+	case OP_EQ: return value == f->value;
+	case OP_NEQ: return value != f->value;
+	case OP_LT: return value < f->value;
+	case OP_LE: return value <= f->value;
+	case OP_GT: return value > f->value;
+	case OP_GE: return value >= f->value;
+	}
+
+	fprintf(stderr, "BUG: unknown filter op %d!\n", f->op);
+	return false;
+}
+
+static bool should_output_stats(const struct verif_stats *stats)
+{
+	struct filter *f;
+	int i, allow_cnt = 0;
+
+	for (i = 0; i < env.deny_filter_cnt; i++) {
+		f = &env.deny_filters[i];
+		if (f->kind != FILTER_STAT)
+			continue;
+
+		if (is_stat_filter_matched(f, stats))
+			return false;
+	}
+
+	for (i = 0; i < env.allow_filter_cnt; i++) {
+		f = &env.allow_filters[i];
+		if (f->kind != FILTER_STAT)
+			continue;
+		allow_cnt++;
+
+		if (is_stat_filter_matched(f, stats))
+			return true;
+	}
+
+	/* if there are no stat allowed filters, pass everything through */
+	return allow_cnt == 0;
+}
+
 static void output_prog_stats(void)
 {
 	const struct verif_stats *stats;
@@ -1327,6 +1479,8 @@ static void output_prog_stats(void)
 		output_headers(RESFMT_TABLE_CALCLEN);
 		for (i = 0; i < env.prog_stat_cnt; i++) {
 			stats = &env.prog_stats[i];
+			if (!should_output_stats(stats))
+				continue;
 			output_stats(stats, RESFMT_TABLE_CALCLEN, false);
 			last_stat_idx = i;
 		}
@@ -1336,6 +1490,8 @@ static void output_prog_stats(void)
 	output_headers(env.out_fmt);
 	for (i = 0; i < env.prog_stat_cnt; i++) {
 		stats = &env.prog_stats[i];
+		if (!should_output_stats(stats))
+			continue;
 		output_stats(stats, env.out_fmt, i == last_stat_idx);
 	}
 }
-- 
2.30.2


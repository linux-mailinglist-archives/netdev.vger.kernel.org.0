Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0935261766E
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 06:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiKCFyh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Nov 2022 01:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiKCFxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 01:53:34 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0E52DDF
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 22:53:30 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVsQk010857
        for <netdev@vger.kernel.org>; Wed, 2 Nov 2022 22:53:30 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkhkvttgs-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 22:53:29 -0700
Received: from twshared25017.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 22:53:26 -0700
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id 669692102ED3B; Wed,  2 Nov 2022 22:53:24 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 09/10] selftests/bpf: support stats ordering in comparison mode in veristat
Date:   Wed, 2 Nov 2022 22:53:03 -0700
Message-ID: <20221103055304.2904589-10-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221103055304.2904589-1-andrii@kernel.org>
References: <20221103055304.2904589-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: i8nM83kruL9EWKyZToo5kmpD5EO9TL0U
X-Proofpoint-ORIG-GUID: i8nM83kruL9EWKyZToo5kmpD5EO9TL0U
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

Introduce the concept of "stat variant", by which it's possible to
specify whether to use the value from A (baseline) side, B (comparison
or control) side, the absolute difference value or relative (percentage)
difference value.

To support specifying this, veristat recognizes `_a`, `_b`, `_diff`,
`_pct` suffixes, which can be appended to stat name(s). In
non-comparison mode variants are ignored (there is only `_a` variant
effectively), if no variant suffix is provided, `_b` is assumed, as
control group is of primary interest in comparison mode.

These stat variants can be flexibly combined with asc/desc orders.

Here's an example of ordering results first by verdict match/mismatch (or n/a
if one of the sides is missing; n/a is always considered to be the lowest
value), and within each match/mismatch/n/a group further sort by number of
instructions in B side. In this case we don't have MISMATCH cases, but N/A are
split from MATCH, demonstrating this custom ordering.

  $ ./veristat -e file,prog,verdict,insns -s verdict_diff,insns_b_ -C ~/base.csv ~/comp.csv
  File                Program                         Verdict (A)  Verdict (B)  Verdict (DIFF)  Insns (A)  Insns (B)  Insns   (DIFF)
  ------------------  ------------------------------  -----------  -----------  --------------  ---------  ---------  --------------
  bpf_xdp.o           tail_lb_ipv6                    N/A          success      N/A                   N/A     151895             N/A
  bpf_xdp.o           tail_nodeport_nat_egress_ipv4   N/A          success      N/A                   N/A      15619             N/A
  bpf_xdp.o           tail_nodeport_ipv6_dsr          N/A          success      N/A                   N/A       1206             N/A
  bpf_xdp.o           tail_nodeport_ipv4_dsr          N/A          success      N/A                   N/A       1162             N/A
  bpf_alignchecker.o  tail_icmp6_send_echo_reply      N/A          failure      N/A                   N/A         74             N/A
  bpf_alignchecker.o  __send_drop_notify              success      N/A          N/A                    53        N/A             N/A
  bpf_host.o          __send_drop_notify              success      N/A          N/A                    53        N/A             N/A
  bpf_host.o          cil_from_host                   success      N/A          N/A                   762        N/A             N/A
  bpf_xdp.o           tail_lb_ipv4                    success      success      MATCH               71736      73430  +1694 (+2.36%)
  bpf_xdp.o           tail_handle_nat_fwd_ipv4        success      success      MATCH               21547      20920   -627 (-2.91%)
  bpf_xdp.o           tail_rev_nodeport_lb6           success      success      MATCH               17954      17905    -49 (-0.27%)
  bpf_xdp.o           tail_handle_nat_fwd_ipv6        success      success      MATCH               16974      17039    +65 (+0.38%)
  bpf_xdp.o           tail_nodeport_nat_ingress_ipv4  success      success      MATCH                7658       7713    +55 (+0.72%)
  bpf_xdp.o           tail_rev_nodeport_lb4           success      success      MATCH                7126       6934   -192 (-2.69%)
  bpf_xdp.o           tail_nodeport_nat_ingress_ipv6  success      success      MATCH                6405       6397     -8 (-0.12%)
  bpf_xdp.o           tail_nodeport_nat_ipv6_egress   failure      failure      MATCH                 752        752     +0 (+0.00%)
  bpf_xdp.o           cil_xdp_entry                   success      success      MATCH                 423        423     +0 (+0.00%)
  bpf_xdp.o           __send_drop_notify              success      success      MATCH                 151        151     +0 (+0.00%)
  bpf_alignchecker.o  tail_icmp6_handle_ns            failure      failure      MATCH                  33         33     +0 (+0.00%)
  ------------------  ------------------------------  -----------  -----------  --------------  ---------  ---------  --------------

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c | 192 +++++++++++++++++++++++--
 1 file changed, 182 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index 5a9568a8c0bf..f2ea825ee80a 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -17,6 +17,7 @@
 #include <bpf/libbpf.h>
 #include <libelf.h>
 #include <gelf.h>
+#include <float.h>
 
 enum stat_id {
 	VERDICT,
@@ -34,6 +35,45 @@ enum stat_id {
 	NUM_STATS_CNT = FILE_NAME - VERDICT,
 };
 
+/* In comparison mode each stat can specify up to four different values:
+ *   - A side value;
+ *   - B side value;
+ *   - absolute diff value;
+ *   - relative (percentage) diff value.
+ *
+ * When specifying stat specs in comparison mode, user can use one of the
+ * following variant suffixes to specify which exact variant should be used for
+ * ordering or filtering:
+ *   - `_a` for A side value;
+ *   - `_b` for B side value;
+ *   - `_diff` for absolute diff value;
+ *   - `_pct` for relative (percentage) diff value.
+ *
+ * If no variant suffix is provided, then `_b` (control data) is assumed.
+ *
+ * As an example, let's say instructions stat has the following output:
+ *
+ * Insns (A)  Insns (B)  Insns   (DIFF)
+ * ---------  ---------  --------------
+ * 21547      20920       -627 (-2.91%)
+ *
+ * Then:
+ *   - 21547 is A side value (insns_a);
+ *   - 20920 is B side value (insns_b);
+ *   - -627 is absolute diff value (insns_diff);
+ *   - -2.91% is relative diff value (insns_pct).
+ *
+ * For verdict there is no verdict_pct variant.
+ * For file and program name, _a and _b variants are equivalent and there are
+ * no _diff or _pct variants.
+ */
+enum stat_variant {
+	VARIANT_A,
+	VARIANT_B,
+	VARIANT_DIFF,
+	VARIANT_PCT,
+};
+
 struct verif_stats {
 	char *file_name;
 	char *prog_name;
@@ -53,6 +93,7 @@ struct verif_stats_join {
 struct stat_specs {
 	int spec_cnt;
 	enum stat_id ids[ALL_STATS_CNT];
+	enum stat_variant variants[ALL_STATS_CNT];
 	bool asc[ALL_STATS_CNT];
 	int lens[ALL_STATS_CNT * 3]; /* 3x for comparison mode */
 };
@@ -86,6 +127,7 @@ struct filter {
 	/* FILTER_STAT */
 	enum operator_kind op;
 	int stat_id;
+	enum stat_variant stat_var;
 	long value;
 };
 
@@ -360,7 +402,7 @@ static struct {
 	{ OP_EQ, "=" },
 };
 
-static bool parse_stat_id(const char *name, size_t len, int *id);
+static bool parse_stat_id_var(const char *name, size_t len, int *id, enum stat_variant *var);
 
 static int append_filter(struct filter **filters, int *cnt, const char *str)
 {
@@ -388,6 +430,7 @@ static int append_filter(struct filter **filters, int *cnt, const char *str)
 	 * glob filter.
 	 */
 	for (i = 0; i < ARRAY_SIZE(operators); i++) {
+		enum stat_variant var;
 		int id;
 		long val;
 		const char *end = str;
@@ -398,7 +441,7 @@ static int append_filter(struct filter **filters, int *cnt, const char *str)
 		if (!p)
 			continue;
 
-		if (!parse_stat_id(str, p - str, &id)) {
+		if (!parse_stat_id_var(str, p - str, &id, &var)) {
 			fprintf(stderr, "Unrecognized stat name in '%s'!\n", str);
 			return -EINVAL;
 		}
@@ -431,6 +474,7 @@ static int append_filter(struct filter **filters, int *cnt, const char *str)
 
 		f->kind = FILTER_STAT;
 		f->stat_id = id;
+		f->stat_var = var;
 		f->op = operators[i].op_kind;
 		f->value = val;
 
@@ -556,22 +600,52 @@ static struct stat_def {
 	[MARK_READ_MAX_LEN] = { "Max mark read length", {"max_mark_read_len", "mark_read"}, },
 };
 
-static bool parse_stat_id(const char *name, size_t len, int *id)
+static bool parse_stat_id_var(const char *name, size_t len, int *id, enum stat_variant *var)
 {
-	int i, j;
+	static const char *var_sfxs[] = {
+		[VARIANT_A] = "_a",
+		[VARIANT_B] = "_b",
+		[VARIANT_DIFF] = "_diff",
+		[VARIANT_PCT] = "_pct",
+	};
+	int i, j, k;
 
 	for (i = 0; i < ARRAY_SIZE(stat_defs); i++) {
 		struct stat_def *def = &stat_defs[i];
+		size_t alias_len, sfx_len;
+		const char *alias;
 
 		for (j = 0; j < ARRAY_SIZE(stat_defs[i].names); j++) {
+			alias = def->names[j];
+			if (!alias)
+				continue;
 
-			if (!def->names[j] ||
-			    strlen(def->names[j]) != len ||
-			    strncmp(def->names[j], name, len) != 0)
+			alias_len = strlen(alias);
+			if (strncmp(name, alias, alias_len) != 0)
 				continue;
 
-			*id = i;
-			return true;
+			if (alias_len == len) {
+				/* If no variant suffix is specified, we
+				 * assume control group (just in case we are
+				 * in comparison mode. Variant is ignored in
+				 * non-comparison mode.
+				 */
+				*var = VARIANT_B;
+				*id = i;
+				return true;
+			}
+
+			for (k = 0; k < ARRAY_SIZE(var_sfxs); k++) {
+				sfx_len = strlen(var_sfxs[k]);
+				if (alias_len + sfx_len != len)
+					continue;
+
+				if (strncmp(name + alias_len, var_sfxs[k], sfx_len) == 0) {
+					*var = (enum stat_variant)k;
+					*id = i;
+					return true;
+				}
+			}
 		}
 	}
 
@@ -593,6 +667,7 @@ static int parse_stat(const char *stat_name, struct stat_specs *specs)
 	int id;
 	bool has_order = false, is_asc = false;
 	size_t len = strlen(stat_name);
+	enum stat_variant var;
 
 	if (specs->spec_cnt >= ARRAY_SIZE(specs->ids)) {
 		fprintf(stderr, "Can't specify more than %zd stats\n", ARRAY_SIZE(specs->ids));
@@ -605,12 +680,13 @@ static int parse_stat(const char *stat_name, struct stat_specs *specs)
 		len -= 1;
 	}
 
-	if (!parse_stat_id(stat_name, len, &id)) {
+	if (!parse_stat_id_var(stat_name, len, &id, &var)) {
 		fprintf(stderr, "Unrecognized stat name '%s'\n", stat_name);
 		return -ESRCH;
 	}
 
 	specs->ids[specs->spec_cnt] = id;
+	specs->variants[specs->spec_cnt] = var;
 	specs->asc[specs->spec_cnt] = has_order ? is_asc : stat_defs[id].asc_by_default;
 	specs->spec_cnt++;
 
@@ -900,6 +976,99 @@ static int cmp_prog_stats(const void *v1, const void *v2)
 	return strcmp(s1->prog_name, s2->prog_name);
 }
 
+static void fetch_join_stat_value(const struct verif_stats_join *s,
+				  enum stat_id id, enum stat_variant var,
+				  const char **str_val,
+				  double *num_val)
+{
+	long v1, v2;
+
+	if (id == FILE_NAME) {
+		*str_val = s->file_name;
+		return;
+	}
+	if (id == PROG_NAME) {
+		*str_val = s->prog_name;
+		return;
+	}
+
+	v1 = s->stats_a ? s->stats_a->stats[id] : 0;
+	v2 = s->stats_b ? s->stats_b->stats[id] : 0;
+
+	switch (var) {
+	case VARIANT_A:
+		if (!s->stats_a)
+			*num_val = -DBL_MAX;
+		else
+			*num_val = s->stats_a->stats[id];
+		return;
+	case VARIANT_B:
+		if (!s->stats_b)
+			*num_val = -DBL_MAX;
+		else
+			*num_val = s->stats_b->stats[id];
+		return;
+	case VARIANT_DIFF:
+		if (!s->stats_a || !s->stats_b)
+			*num_val = -DBL_MAX;
+		else
+			*num_val = (double)(v2 - v1);
+		return;
+	case VARIANT_PCT:
+		if (!s->stats_a || !s->stats_b) {
+			*num_val = -DBL_MAX;
+		} else if (v1 == 0) {
+			if (v1 == v2)
+				*num_val = 0.0;
+			else
+				*num_val = v2 < v1 ? -100.0 : 100.0;
+		} else {
+			 *num_val = (v2 - v1) * 100.0 / v1;
+		}
+		return;
+	}
+}
+
+static int cmp_join_stat(const struct verif_stats_join *s1,
+			 const struct verif_stats_join *s2,
+			 enum stat_id id, enum stat_variant var, bool asc)
+{
+	const char *str1 = NULL, *str2 = NULL;
+	double v1, v2;
+	int cmp = 0;
+
+	fetch_join_stat_value(s1, id, var, &str1, &v1);
+	fetch_join_stat_value(s2, id, var, &str2, &v2);
+
+	if (str1)
+		cmp = strcmp(str1, str2);
+	else if (v1 != v2)
+		cmp = v1 < v2 ? -1 : 1;
+
+	return asc ? cmp : -cmp;
+}
+
+static int cmp_join_stats(const void *v1, const void *v2)
+{
+	const struct verif_stats_join *s1 = v1, *s2 = v2;
+	int i, cmp;
+
+	for (i = 0; i < env.sort_spec.spec_cnt; i++) {
+		cmp = cmp_join_stat(s1, s2,
+				    env.sort_spec.ids[i],
+				    env.sort_spec.variants[i],
+				    env.sort_spec.asc[i]);
+		if (cmp != 0)
+			return cmp;
+	}
+
+	/* always disambiguate with file+prog, which are unique */
+	cmp = strcmp(s1->file_name, s2->file_name);
+	if (cmp != 0)
+		return cmp;
+	return strcmp(s1->prog_name, s2->prog_name);
+}
+
 #define HEADER_CHAR '-'
 #define COLUMN_SEP "  "
 
@@ -1477,6 +1646,9 @@ static int handle_comparison_mode(void)
 		env.join_stat_cnt += 1;
 	}
 
+	/* now sort joined results accorsing to sort spec */
+	qsort(env.join_stats, env.join_stat_cnt, sizeof(*env.join_stats), cmp_join_stats);
+
 	/* for human-readable table output we need to do extra pass to
 	 * calculate column widths, so we substitute current output format
 	 * with RESFMT_TABLE_CALCLEN and later revert it back to RESFMT_TABLE
-- 
2.30.2


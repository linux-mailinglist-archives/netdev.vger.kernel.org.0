Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36C961766B
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 06:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbiKCFyQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Nov 2022 01:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiKCFyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 01:54:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F5619C14
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 22:53:38 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVs96022925
        for <netdev@vger.kernel.org>; Wed, 2 Nov 2022 22:53:37 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkj3bb32c-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 22:53:37 -0700
Received: from twshared24130.14.prn3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 22:53:35 -0700
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id 74FA02102ED42; Wed,  2 Nov 2022 22:53:26 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 10/10] selftests/bpf: support stat filtering in comparison mode in veristat
Date:   Wed, 2 Nov 2022 22:53:04 -0700
Message-ID: <20221103055304.2904589-11-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221103055304.2904589-1-andrii@kernel.org>
References: <20221103055304.2904589-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ud-PNsQfxTHSrFNNLXdqh8P3CqivKQTa
X-Proofpoint-GUID: ud-PNsQfxTHSrFNNLXdqh8P3CqivKQTa
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

Finally add support for filtering stats values, similar to
non-comparison mode filtering. For comparison mode 4 variants of stats
are important for filtering, as they allow to filter either A or B side,
but even more importantly they allow to filter based on value
difference, and for verdict stat value difference is MATCH/MISMATCH
classification. So with these changes it's finally possible to easily
check if there were any mismatches between failure/success outcomes on
two separate data sets. Like in an example below:

  $ ./veristat -e file,prog,verdict,insns -C ~/baseline-results.csv ~/shortest-results.csv -f verdict_diff=mismatch
  File                                   Program                Verdict (A)  Verdict (B)  Verdict (DIFF)  Insns (A)  Insns (B)  Insns        (DIFF)
  -------------------------------------  ---------------------  -----------  -----------  --------------  ---------  ---------  -------------------
  dynptr_success.bpf.linked1.o           test_data_slice        success      failure      MISMATCH               85          0       -85 (-100.00%)
  dynptr_success.bpf.linked1.o           test_read_write        success      failure      MISMATCH             1992          0     -1992 (-100.00%)
  dynptr_success.bpf.linked1.o           test_ringbuf           success      failure      MISMATCH               74          0       -74 (-100.00%)
  kprobe_multi.bpf.linked1.o             test_kprobe            failure      success      MISMATCH                0        246      +246 (+100.00%)
  kprobe_multi.bpf.linked1.o             test_kprobe_manual     failure      success      MISMATCH                0        246      +246 (+100.00%)
  kprobe_multi.bpf.linked1.o             test_kretprobe         failure      success      MISMATCH                0        248      +248 (+100.00%)
  kprobe_multi.bpf.linked1.o             test_kretprobe_manual  failure      success      MISMATCH                0        248      +248 (+100.00%)
  kprobe_multi.bpf.linked1.o             trigger                failure      success      MISMATCH                0          2        +2 (+100.00%)
  netcnt_prog.bpf.linked1.o              bpf_nextcnt            failure      success      MISMATCH                0         56       +56 (+100.00%)
  pyperf600_nounroll.bpf.linked1.o       on_event               success      failure      MISMATCH           568128    1000001    +431873 (+76.02%)
  ringbuf_bench.bpf.linked1.o            bench_ringbuf          success      failure      MISMATCH                8          0        -8 (-100.00%)
  strobemeta.bpf.linked1.o               on_event               success      failure      MISMATCH           557149    1000001    +442852 (+79.49%)
  strobemeta_nounroll1.bpf.linked1.o     on_event               success      failure      MISMATCH            57240    1000001  +942761 (+1647.03%)
  strobemeta_nounroll2.bpf.linked1.o     on_event               success      failure      MISMATCH           501725    1000001    +498276 (+99.31%)
  strobemeta_subprogs.bpf.linked1.o      on_event               success      failure      MISMATCH            65420    1000001  +934581 (+1428.59%)
  test_map_in_map_invalid.bpf.linked1.o  xdp_noop0              success      failure      MISMATCH                2          0        -2 (-100.00%)
  test_mmap.bpf.linked1.o                test_mmap              success      failure      MISMATCH               46          0       -46 (-100.00%)
  test_verif_scale3.bpf.linked1.o        balancer_ingress       success      failure      MISMATCH           845499    1000001    +154502 (+18.27%)
  -------------------------------------  ---------------------  -----------  -----------  --------------  ---------  ---------  -------------------

Note that by filtering on verdict_diff=mismatch, it's now extremely easy and
fast to see any changes in verdict. Example above showcases both failure ->
success transitions (which are generally surprising) and success -> failure
transitions (which are expected if bugs are present).

Given veristat allows to query relative percent difference values, internal
logic for comparison mode is based on floating point numbers, so requires a bit
of epsilon precision logic, deviating from typical integer simple handling
rules.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c | 70 ++++++++++++++++++++++++--
 1 file changed, 65 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index f2ea825ee80a..9e3811ab4866 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -456,12 +456,16 @@ static int append_filter(struct filter **filters, int *cnt, const char *str)
 		    strcasecmp(p, "t") == 0 ||
 		    strcasecmp(p, "success") == 0 ||
 		    strcasecmp(p, "succ") == 0 ||
-		    strcasecmp(p, "s") == 0) {
+		    strcasecmp(p, "s") == 0 ||
+		    strcasecmp(p, "match") == 0 ||
+		    strcasecmp(p, "m") == 0) {
 			val = 1;
 		} else if (strcasecmp(p, "false") == 0 ||
 			   strcasecmp(p, "f") == 0 ||
 			   strcasecmp(p, "failure") == 0 ||
-			   strcasecmp(p, "fail") == 0) {
+			   strcasecmp(p, "fail") == 0 ||
+			   strcasecmp(p, "mismatch") == 0 ||
+			   strcasecmp(p, "mis") == 0) {
 			val = 0;
 		} else {
 			errno = 0;
@@ -1011,6 +1015,8 @@ static void fetch_join_stat_value(const struct verif_stats_join *s,
 	case VARIANT_DIFF:
 		if (!s->stats_a || !s->stats_b)
 			*num_val = -DBL_MAX;
+		else if (id == VERDICT)
+			*num_val = v1 == v2 ? 1.0 /* MATCH */ : 0.0 /* MISMATCH */;
 		else
 			*num_val = (double)(v2 - v1);
 		return;
@@ -1532,12 +1538,61 @@ static int cmp_stats_key(const struct verif_stats *base, const struct verif_stat
 	return strcmp(base->prog_name, comp->prog_name);
 }
 
+static bool is_join_stat_filter_matched(struct filter *f, const struct verif_stats_join *stats)
+{
+	static const double eps = 1e-9;
+	const char *str = NULL;
+	double value = 0.0;
+
+	fetch_join_stat_value(stats, f->stat_id, f->stat_var, &str, &value);
+
+	switch (f->op) {
+	case OP_EQ: return value > f->value - eps && value < f->value + eps;
+	case OP_NEQ: return value < f->value - eps || value > f->value + eps;
+	case OP_LT: return value < f->value - eps;
+	case OP_LE: return value <= f->value + eps;
+	case OP_GT: return value > f->value + eps;
+	case OP_GE: return value >= f->value - eps;
+	}
+
+	fprintf(stderr, "BUG: unknown filter op %d!\n", f->op);
+	return false;
+}
+
+static bool should_output_join_stats(const struct verif_stats_join *stats)
+{
+	struct filter *f;
+	int i, allow_cnt = 0;
+
+	for (i = 0; i < env.deny_filter_cnt; i++) {
+		f = &env.deny_filters[i];
+		if (f->kind != FILTER_STAT)
+			continue;
+
+		if (is_join_stat_filter_matched(f, stats))
+			return false;
+	}
+
+	for (i = 0; i < env.allow_filter_cnt; i++) {
+		f = &env.allow_filters[i];
+		if (f->kind != FILTER_STAT)
+			continue;
+		allow_cnt++;
+
+		if (is_join_stat_filter_matched(f, stats))
+			return true;
+	}
+
+	/* if there are no stat allowed filters, pass everything through */
+	return allow_cnt == 0;
+}
+
 static int handle_comparison_mode(void)
 {
 	struct stat_specs base_specs = {}, comp_specs = {};
 	struct stat_specs tmp_sort_spec;
 	enum resfmt cur_fmt;
-	int err, i, j;
+	int err, i, j, last_idx;
 
 	if (env.filename_cnt != 2) {
 		fprintf(stderr, "Comparison mode expects exactly two input CSV files!\n\n");
@@ -1664,9 +1719,14 @@ static int handle_comparison_mode(void)
 
 	for (i = 0; i < env.join_stat_cnt; i++) {
 		const struct verif_stats_join *join = &env.join_stats[i];
-		bool last = i == env.join_stat_cnt - 1;
 
-		output_comp_stats(join, cur_fmt, last);
+		if (!should_output_join_stats(join))
+			continue;
+
+		if (cur_fmt == RESFMT_TABLE_CALCLEN)
+			last_idx = i;
+
+		output_comp_stats(join, cur_fmt, i == last_idx);
 	}
 
 	if (cur_fmt == RESFMT_TABLE_CALCLEN) {
-- 
2.30.2


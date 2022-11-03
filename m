Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966C761766A
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 06:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbiKCFyL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Nov 2022 01:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiKCFxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 01:53:38 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A7160DE
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 22:53:33 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVs8x022925
        for <netdev@vger.kernel.org>; Wed, 2 Nov 2022 22:53:33 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkj3bb32c-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 22:53:33 -0700
Received: from twshared19054.43.prn1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 22:53:30 -0700
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id 5A3CD2102ED31; Wed,  2 Nov 2022 22:53:22 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 08/10] selftests/bpf: handle missing records in comparison mode better in veristat
Date:   Wed, 2 Nov 2022 22:53:02 -0700
Message-ID: <20221103055304.2904589-9-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221103055304.2904589-1-andrii@kernel.org>
References: <20221103055304.2904589-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: EWUAGR_OL2qiz2XMEfnEfnjLYDu4y-K3
X-Proofpoint-GUID: EWUAGR_OL2qiz2XMEfnEfnjLYDu4y-K3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When comparing two datasets, if either side is missing corresponding
record with the same file and prog name, currently veristat emits
misleading zeros/failures, and even tried to calculate a difference,
even though there is no data to compare against.

This patch improves internal logic of handling such situations. Now
we'll emit "N/A" in places where data is missing and comparison is
non-sensical.

As an example, in an artificially truncated and mismatched Cilium
results, the output looks like below:

  $ ./veristat -e file,prog,verdict,insns -C ~/base.csv ~/comp.csv
  File                Program                         Verdict (A)  Verdict (B)  Verdict (DIFF)  Insns (A)  Insns (B)  Insns   (DIFF)
  ------------------  ------------------------------  -----------  -----------  --------------  ---------  ---------  --------------
  bpf_alignchecker.o  __send_drop_notify              success      N/A          N/A                    53        N/A             N/A
  bpf_alignchecker.o  tail_icmp6_handle_ns            failure      failure      MATCH                  33         33     +0 (+0.00%)
  bpf_alignchecker.o  tail_icmp6_send_echo_reply      N/A          failure      N/A                   N/A         74             N/A
  bpf_host.o          __send_drop_notify              success      N/A          N/A                    53        N/A             N/A
  bpf_host.o          cil_from_host                   success      N/A          N/A                   762        N/A             N/A
  bpf_xdp.o           __send_drop_notify              success      success      MATCH                 151        151     +0 (+0.00%)
  bpf_xdp.o           cil_xdp_entry                   success      success      MATCH                 423        423     +0 (+0.00%)
  bpf_xdp.o           tail_handle_nat_fwd_ipv4        success      success      MATCH               21547      20920   -627 (-2.91%)
  bpf_xdp.o           tail_handle_nat_fwd_ipv6        success      success      MATCH               16974      17039    +65 (+0.38%)
  bpf_xdp.o           tail_lb_ipv4                    success      success      MATCH               71736      73430  +1694 (+2.36%)
  bpf_xdp.o           tail_lb_ipv6                    N/A          success      N/A                   N/A     151895             N/A
  bpf_xdp.o           tail_nodeport_ipv4_dsr          N/A          success      N/A                   N/A       1162             N/A
  bpf_xdp.o           tail_nodeport_ipv6_dsr          N/A          success      N/A                   N/A       1206             N/A
  bpf_xdp.o           tail_nodeport_nat_egress_ipv4   N/A          success      N/A                   N/A      15619             N/A
  bpf_xdp.o           tail_nodeport_nat_ingress_ipv4  success      success      MATCH                7658       7713    +55 (+0.72%)
  bpf_xdp.o           tail_nodeport_nat_ingress_ipv6  success      success      MATCH                6405       6397     -8 (-0.12%)
  bpf_xdp.o           tail_nodeport_nat_ipv6_egress   failure      failure      MATCH                 752        752     +0 (+0.00%)
  bpf_xdp.o           tail_rev_nodeport_lb4           success      success      MATCH                7126       6934   -192 (-2.69%)
  bpf_xdp.o           tail_rev_nodeport_lb6           success      success      MATCH               17954      17905    -49 (-0.27%)
  ------------------  ------------------------------  -----------  -----------  --------------  ---------  ---------  --------------

Internally veristat now separates joining two datasets and remembering the
join, and actually emitting a comparison view. This will come handy when we add
support for filtering and custom ordering in comparison mode.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c | 147 ++++++++++++++++++-------
 1 file changed, 110 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index ec1a8ba7791c..5a9568a8c0bf 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -41,6 +41,15 @@ struct verif_stats {
 	long stats[NUM_STATS_CNT];
 };
 
+/* joined comparison mode stats */
+struct verif_stats_join {
+	char *file_name;
+	char *prog_name;
+
+	const struct verif_stats *stats_a;
+	const struct verif_stats *stats_b;
+};
+
 struct stat_specs {
 	int spec_cnt;
 	enum stat_id ids[ALL_STATS_CNT];
@@ -97,6 +106,9 @@ static struct env {
 	struct verif_stats *baseline_stats;
 	int baseline_stat_cnt;
 
+	struct verif_stats_join *join_stats;
+	int join_stat_cnt;
+
 	struct stat_specs output_spec;
 	struct stat_specs sort_spec;
 
@@ -518,6 +530,15 @@ static const struct stat_specs default_sort_spec = {
 	.asc = { true, true, },
 };
 
+/* sorting for comparison mode to join two data sets */
+static const struct stat_specs join_sort_spec = {
+	.spec_cnt = 2,
+	.ids = {
+		FILE_NAME, PROG_NAME,
+	},
+	.asc = { true, true, },
+};
+
 static struct stat_def {
 	const char *header;
 	const char *names[4];
@@ -934,13 +955,16 @@ static void prepare_value(const struct verif_stats *s, enum stat_id id,
 {
 	switch (id) {
 	case FILE_NAME:
-		*str = s->file_name;
+		*str = s ? s->file_name : "N/A";
 		break;
 	case PROG_NAME:
-		*str = s->prog_name;
+		*str = s ? s->prog_name : "N/A";
 		break;
 	case VERDICT:
-		*str = s->stats[VERDICT] ? "success" : "failure";
+		if (!s)
+			*str = "N/A";
+		else
+			*str = s->stats[VERDICT] ? "success" : "failure";
 		break;
 	case DURATION:
 	case TOTAL_INSNS:
@@ -948,7 +972,7 @@ static void prepare_value(const struct verif_stats *s, enum stat_id id,
 	case PEAK_STATES:
 	case MAX_STATES_PER_INSN:
 	case MARK_READ_MAX_LEN:
-		*val = s->stats[id];
+		*val = s ? s->stats[id] : 0;
 		break;
 	default:
 		fprintf(stderr, "Unrecognized stat #%d\n", id);
@@ -1223,9 +1247,11 @@ static void output_comp_headers(enum resfmt fmt)
 		output_comp_header_underlines();
 }
 
-static void output_comp_stats(const struct verif_stats *base, const struct verif_stats *comp,
+static void output_comp_stats(const struct verif_stats_join *join_stats,
 			      enum resfmt fmt, bool last)
 {
+	const struct verif_stats *base = join_stats->stats_a;
+	const struct verif_stats *comp = join_stats->stats_b;
 	char base_buf[1024] = {}, comp_buf[1024] = {}, diff_buf[1024] = {};
 	int i;
 
@@ -1243,33 +1269,45 @@ static void output_comp_stats(const struct verif_stats *base, const struct verif
 		/* normalize all the outputs to be in string buffers for simplicity */
 		if (is_key_stat(id)) {
 			/* key stats (file and program name) are always strings */
-			if (base != &fallback_stats)
+			if (base)
 				snprintf(base_buf, sizeof(base_buf), "%s", base_str);
 			else
 				snprintf(base_buf, sizeof(base_buf), "%s", comp_str);
 		} else if (base_str) {
 			snprintf(base_buf, sizeof(base_buf), "%s", base_str);
 			snprintf(comp_buf, sizeof(comp_buf), "%s", comp_str);
-			if (strcmp(base_str, comp_str) == 0)
+			if (!base || !comp)
+				snprintf(diff_buf, sizeof(diff_buf), "%s", "N/A");
+			else if (strcmp(base_str, comp_str) == 0)
 				snprintf(diff_buf, sizeof(diff_buf), "%s", "MATCH");
 			else
 				snprintf(diff_buf, sizeof(diff_buf), "%s", "MISMATCH");
 		} else {
 			double p = 0.0;
 
-			snprintf(base_buf, sizeof(base_buf), "%ld", base_val);
-			snprintf(comp_buf, sizeof(comp_buf), "%ld", comp_val);
+			if (base)
+				snprintf(base_buf, sizeof(base_buf), "%ld", base_val);
+			else
+				snprintf(base_buf, sizeof(base_buf), "%s", "N/A");
+			if (comp)
+				snprintf(comp_buf, sizeof(comp_buf), "%ld", comp_val);
+			else
+				snprintf(comp_buf, sizeof(comp_buf), "%s", "N/A");
 
 			diff_val = comp_val - base_val;
-			if (base == &fallback_stats || comp == &fallback_stats || base_val == 0) {
-				if (comp_val == base_val)
-					p = 0.0; /* avoid +0 (+100%) case */
-				else
-					p = comp_val < base_val ? -100.0 : 100.0;
+			if (!base || !comp) {
+				snprintf(diff_buf, sizeof(diff_buf), "%s", "N/A");
 			} else {
-				 p = diff_val * 100.0 / base_val;
+				if (base_val == 0) {
+					if (comp_val == base_val)
+						p = 0.0; /* avoid +0 (+100%) case */
+					else
+						p = comp_val < base_val ? -100.0 : 100.0;
+				} else {
+					 p = diff_val * 100.0 / base_val;
+				}
+				snprintf(diff_buf, sizeof(diff_buf), "%+ld (%+.2lf%%)", diff_val, p);
 			}
-			snprintf(diff_buf, sizeof(diff_buf), "%+ld (%+.2lf%%)", diff_val, p);
 		}
 
 		switch (fmt) {
@@ -1328,6 +1366,7 @@ static int cmp_stats_key(const struct verif_stats *base, const struct verif_stat
 static int handle_comparison_mode(void)
 {
 	struct stat_specs base_specs = {}, comp_specs = {};
+	struct stat_specs tmp_sort_spec;
 	enum resfmt cur_fmt;
 	int err, i, j;
 
@@ -1370,31 +1409,26 @@ static int handle_comparison_mode(void)
 		}
 	}
 
+	/* Replace user-specified sorting spec with file+prog sorting rule to
+	 * be able to join two datasets correctly. Once we are done, we will
+	 * restore the original sort spec.
+	 */
+	tmp_sort_spec = env.sort_spec;
+	env.sort_spec = join_sort_spec;
 	qsort(env.prog_stats, env.prog_stat_cnt, sizeof(*env.prog_stats), cmp_prog_stats);
 	qsort(env.baseline_stats, env.baseline_stat_cnt, sizeof(*env.baseline_stats), cmp_prog_stats);
+	env.sort_spec = tmp_sort_spec;
 
-	/* for human-readable table output we need to do extra pass to
-	 * calculate column widths, so we substitute current output format
-	 * with RESFMT_TABLE_CALCLEN and later revert it back to RESFMT_TABLE
-	 * and do everything again.
-	 */
-	if (env.out_fmt == RESFMT_TABLE)
-		cur_fmt = RESFMT_TABLE_CALCLEN;
-	else
-		cur_fmt = env.out_fmt;
-
-one_more_time:
-	output_comp_headers(cur_fmt);
-
-	/* If baseline and comparison datasets have different subset of rows
-	 * (we match by 'object + prog' as a unique key) then assume
-	 * empty/missing/zero value for rows that are missing in the opposite
-	 * data set
+	/* Join two datasets together. If baseline and comparison datasets
+	 * have different subset of rows (we match by 'object + prog' as
+	 * a unique key) then assume empty/missing/zero value for rows that
+	 * are missing in the opposite data set.
 	 */
 	i = j = 0;
 	while (i < env.baseline_stat_cnt || j < env.prog_stat_cnt) {
-		bool last = (i == env.baseline_stat_cnt - 1) || (j == env.prog_stat_cnt - 1);
 		const struct verif_stats *base, *comp;
+		struct verif_stats_join *join;
+		void *tmp;
 		int r;
 
 		base = i < env.baseline_stat_cnt ? &env.baseline_stats[i] : &fallback_stats;
@@ -1411,18 +1445,56 @@ static int handle_comparison_mode(void)
 			return -EINVAL;
 		}
 
+		tmp = realloc(env.join_stats, (env.join_stat_cnt + 1) * sizeof(*env.join_stats));
+		if (!tmp)
+			return -ENOMEM;
+		env.join_stats = tmp;
+
+		join = &env.join_stats[env.join_stat_cnt];
+		memset(join, 0, sizeof(*join));
+
 		r = cmp_stats_key(base, comp);
 		if (r == 0) {
-			output_comp_stats(base, comp, cur_fmt, last);
+			join->file_name = base->file_name;
+			join->prog_name = base->prog_name;
+			join->stats_a = base;
+			join->stats_b = comp;
 			i++;
 			j++;
 		} else if (comp == &fallback_stats || r < 0) {
-			output_comp_stats(base, &fallback_stats, cur_fmt, last);
+			join->file_name = base->file_name;
+			join->prog_name = base->prog_name;
+			join->stats_a = base;
+			join->stats_b = NULL;
 			i++;
 		} else {
-			output_comp_stats(&fallback_stats, comp, cur_fmt, last);
+			join->file_name = comp->file_name;
+			join->prog_name = comp->prog_name;
+			join->stats_a = NULL;
+			join->stats_b = comp;
 			j++;
 		}
+		env.join_stat_cnt += 1;
+	}
+
+	/* for human-readable table output we need to do extra pass to
+	 * calculate column widths, so we substitute current output format
+	 * with RESFMT_TABLE_CALCLEN and later revert it back to RESFMT_TABLE
+	 * and do everything again.
+	 */
+	if (env.out_fmt == RESFMT_TABLE)
+		cur_fmt = RESFMT_TABLE_CALCLEN;
+	else
+		cur_fmt = env.out_fmt;
+
+one_more_time:
+	output_comp_headers(cur_fmt);
+
+	for (i = 0; i < env.join_stat_cnt; i++) {
+		const struct verif_stats_join *join = &env.join_stats[i];
+		bool last = i == env.join_stat_cnt - 1;
+
+		output_comp_stats(join, cur_fmt, last);
 	}
 
 	if (cur_fmt == RESFMT_TABLE_CALCLEN) {
@@ -1594,6 +1666,7 @@ int main(int argc, char **argv)
 
 	free_verif_stats(env.prog_stats, env.prog_stat_cnt);
 	free_verif_stats(env.baseline_stats, env.baseline_stat_cnt);
+	free(env.join_stats);
 	for (i = 0; i < env.filename_cnt; i++)
 		free(env.filenames[i]);
 	free(env.filenames);
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE922617662
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 06:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiKCFxe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Nov 2022 01:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiKCFx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 01:53:29 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4C52628
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 22:53:21 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVsc8010769
        for <netdev@vger.kernel.org>; Wed, 2 Nov 2022 22:53:21 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkhkvttgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 22:53:20 -0700
Received: from twshared29133.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 22:53:20 -0700
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id BCDA02102ECC1; Wed,  2 Nov 2022 22:53:07 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 01/10] selftests/bpf: add veristat replay mode
Date:   Wed, 2 Nov 2022 22:52:55 -0700
Message-ID: <20221103055304.2904589-2-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221103055304.2904589-1-andrii@kernel.org>
References: <20221103055304.2904589-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: M5ZE9_EN-yAkPNrOJYEmMo4fivKM7UJw
X-Proofpoint-ORIG-GUID: M5ZE9_EN-yAkPNrOJYEmMo4fivKM7UJw
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

Replay mode allow to parse previously stored CSV file with verification
results and present it in desired output (presumable human-readable
table, but CSV to CSV convertion is supported as well). While doing
that, it's possible to use veristat's sorting rules, specify subset of
columns, and filter by file and program name.

In subsequent patches veristat's filtering capabilities will just grow
making replay mode even more useful in practice for post-processing
results.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c | 126 +++++++++++++++++--------
 1 file changed, 88 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index 973cbf6af323..7e1432c06e0c 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -67,6 +67,7 @@ static struct env {
 	int log_level;
 	enum resfmt out_fmt;
 	bool comparison_mode;
+	bool replay_mode;
 
 	struct verif_stats *prog_stats;
 	int prog_stat_cnt;
@@ -115,6 +116,7 @@ static const struct argp_option opts[] = {
 	{ "sort", 's', "SPEC", 0, "Specify sort order" },
 	{ "output-format", 'o', "FMT", 0, "Result output format (table, csv), default is table." },
 	{ "compare", 'C', NULL, 0, "Comparison mode" },
+	{ "replay", 'R', NULL, 0, "Replay mode" },
 	{ "filter", 'f', "FILTER", 0, "Filter expressions (or @filename for file with expressions)." },
 	{},
 };
@@ -169,6 +171,9 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
 	case 'C':
 		env.comparison_mode = true;
 		break;
+	case 'R':
+		env.replay_mode = true;
+		break;
 	case 'f':
 		if (arg[0] == '@')
 			err = append_filter_file(arg + 1);
@@ -841,42 +846,6 @@ static void output_stats(const struct verif_stats *s, enum resfmt fmt, bool last
 	}
 }
 
-static int handle_verif_mode(void)
-{
-	int i, err;
-
-	if (env.filename_cnt == 0) {
-		fprintf(stderr, "Please provide path to BPF object file!\n");
-		argp_help(&argp, stderr, ARGP_HELP_USAGE, "veristat");
-		return -EINVAL;
-	}
-
-	for (i = 0; i < env.filename_cnt; i++) {
-		err = process_obj(env.filenames[i]);
-		if (err) {
-			fprintf(stderr, "Failed to process '%s': %d\n", env.filenames[i], err);
-			return err;
-		}
-	}
-
-	qsort(env.prog_stats, env.prog_stat_cnt, sizeof(*env.prog_stats), cmp_prog_stats);
-
-	if (env.out_fmt == RESFMT_TABLE) {
-		/* calculate column widths */
-		output_headers(RESFMT_TABLE_CALCLEN);
-		for (i = 0; i < env.prog_stat_cnt; i++)
-			output_stats(&env.prog_stats[i], RESFMT_TABLE_CALCLEN, false);
-	}
-
-	/* actually output the table */
-	output_headers(env.out_fmt);
-	for (i = 0; i < env.prog_stat_cnt; i++) {
-		output_stats(&env.prog_stats[i], env.out_fmt, i == env.prog_stat_cnt - 1);
-	}
-
-	return 0;
-}
-
 static int parse_stat_value(const char *str, enum stat_id id, struct verif_stats *st)
 {
 	switch (id) {
@@ -1206,7 +1175,7 @@ static int handle_comparison_mode(void)
 	int err, i, j;
 
 	if (env.filename_cnt != 2) {
-		fprintf(stderr, "Comparison mode expects exactly two input CSV files!\n");
+		fprintf(stderr, "Comparison mode expects exactly two input CSV files!\n\n");
 		argp_help(&argp, stderr, ARGP_HELP_USAGE, "veristat");
 		return -EINVAL;
 	}
@@ -1307,6 +1276,79 @@ static int handle_comparison_mode(void)
 	return 0;
 }
 
+static void output_prog_stats(void)
+{
+	const struct verif_stats *stats;
+	int i, last_stat_idx = 0;
+
+	if (env.out_fmt == RESFMT_TABLE) {
+		/* calculate column widths */
+		output_headers(RESFMT_TABLE_CALCLEN);
+		for (i = 0; i < env.prog_stat_cnt; i++) {
+			stats = &env.prog_stats[i];
+			output_stats(stats, RESFMT_TABLE_CALCLEN, false);
+			last_stat_idx = i;
+		}
+	}
+
+	/* actually output the table */
+	output_headers(env.out_fmt);
+	for (i = 0; i < env.prog_stat_cnt; i++) {
+		stats = &env.prog_stats[i];
+		output_stats(stats, env.out_fmt, i == last_stat_idx);
+	}
+}
+
+static int handle_verif_mode(void)
+{
+	int i, err;
+
+	if (env.filename_cnt == 0) {
+		fprintf(stderr, "Please provide path to BPF object file!\n\n");
+		argp_help(&argp, stderr, ARGP_HELP_USAGE, "veristat");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < env.filename_cnt; i++) {
+		err = process_obj(env.filenames[i]);
+		if (err) {
+			fprintf(stderr, "Failed to process '%s': %d\n", env.filenames[i], err);
+			return err;
+		}
+	}
+
+	qsort(env.prog_stats, env.prog_stat_cnt, sizeof(*env.prog_stats), cmp_prog_stats);
+
+	output_prog_stats();
+
+	return 0;
+}
+
+static int handle_replay_mode(void)
+{
+	struct stat_specs specs = {};
+	int err;
+
+	if (env.filename_cnt != 1) {
+		fprintf(stderr, "Replay mode expects exactly one input CSV file!\n\n");
+		argp_help(&argp, stderr, ARGP_HELP_USAGE, "veristat");
+		return -EINVAL;
+	}
+
+	err = parse_stats_csv(env.filenames[0], &specs,
+			      &env.prog_stats, &env.prog_stat_cnt);
+	if (err) {
+		fprintf(stderr, "Failed to parse stats from '%s': %d\n", env.filenames[0], err);
+		return err;
+	}
+
+	qsort(env.prog_stats, env.prog_stat_cnt, sizeof(*env.prog_stats), cmp_prog_stats);
+
+	output_prog_stats();
+
+	return 0;
+}
+
 int main(int argc, char **argv)
 {
 	int err = 0, i;
@@ -1315,7 +1357,7 @@ int main(int argc, char **argv)
 		return 1;
 
 	if (env.verbose && env.quiet) {
-		fprintf(stderr, "Verbose and quiet modes are incompatible, please specify just one or neither!\n");
+		fprintf(stderr, "Verbose and quiet modes are incompatible, please specify just one or neither!\n\n");
 		argp_help(&argp, stderr, ARGP_HELP_USAGE, "veristat");
 		return 1;
 	}
@@ -1327,8 +1369,16 @@ int main(int argc, char **argv)
 	if (env.sort_spec.spec_cnt == 0)
 		env.sort_spec = default_sort_spec;
 
+	if (env.comparison_mode && env.replay_mode) {
+		fprintf(stderr, "Can't specify replay and comparison mode at the same time!\n\n");
+		argp_help(&argp, stderr, ARGP_HELP_USAGE, "veristat");
+		return 1;
+	}
+
 	if (env.comparison_mode)
 		err = handle_comparison_mode();
+	else if (env.replay_mode)
+		err = handle_replay_mode();
 	else
 		err = handle_verif_mode();
 
-- 
2.30.2


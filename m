Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A182B1D5696
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgEOQui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726665AbgEOQuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 12:50:24 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55835C05BD0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 09:50:24 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id ce16so3175007qvb.15
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 09:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Qx5DR7q9yKe+bR/yiFue61eKIkA72C71MJNDdOxOzy4=;
        b=ghve48lJdL7a0PhjG8X6wjAjP0AxWuPkU5vybqrnBGVqMTw1Jo0XaaiJVG+Vfu4WIe
         XUjjQKbOg1bFr7mGVIG6Cfr5X0rJRIGYjWsDPSUaoFsHXWd5s9XYXZQRy/vt8JZ5o0hV
         FqJzBKMWkkI0+kg7w3Bi93YWMh0/r5ECqIGKTIi4yV3Jj8mFthW1zCqu2GdHLEBPhIiy
         rYARDDlP3q5K6aDd01qe/e/LVuk4ouQXhDuW60JF+9PjhUMQCNM+SgnGWhD7lQL5cbrz
         9RkOUljViX68JaIGP234t8zO2nnDyrG73Ykbl+OC5NoNrXgHFy/EoXkfBwaPPKTvP19I
         K3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Qx5DR7q9yKe+bR/yiFue61eKIkA72C71MJNDdOxOzy4=;
        b=lg37F87nu9CdRwkoKk2M4m+ZDTWnffQW5N2WfhTgsZFZVOK2ssKbjQ6j3Z+ozoIDqp
         D8G2uja1VLr5NopZC6bwrs+N6IWuRhCB9/alof0S5laVCTS6H0+Ve4S9hCrOmbsHGDns
         HSzvyTdaLlgBRy52bGfcyJd7PW/tlgxZYMOSgDu1msa5jxF6HTIYoc24wNBNq/GUtvVz
         P4wahZ2ExXpWJ64dPeIkAkto9ws80tyrR13e7e0Pmu5Aa4qPcW2OVaGuc991/d9Dwt1P
         UPzuHryiG9KQUhwbOtQ7QvSs+/rm6o8d+3iRXmzucTXAl0eSGROrT7hOSNMcvg4U/tIA
         5xdw==
X-Gm-Message-State: AOAM530TzUbgQzs8ZVfK7RYF3uVTUOqSVZIhLaa8uj6RumzUuRz4+d5g
        VNODEwktJaTRJ5d4PY+cVCZDK4VEzaMI
X-Google-Smtp-Source: ABdhPJyzB2+s5r9taCckBNXZJBSNUxCJz1wu1Th0hkKRNHwTEZbWa8Ppfo14hdhlGoVQ0zXKrjc1TlndTmZg
X-Received: by 2002:ad4:4b61:: with SMTP id m1mr4521452qvx.235.1589561423365;
 Fri, 15 May 2020 09:50:23 -0700 (PDT)
Date:   Fri, 15 May 2020 09:50:06 -0700
In-Reply-To: <20200515165007.217120-1-irogers@google.com>
Message-Id: <20200515165007.217120-7-irogers@google.com>
Mime-Version: 1.0
References: <20200515165007.217120-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH v2 6/7] perf test: Improve pmu event metric testing
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>, Paul Clarke <pc@us.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Break pmu-events test into 2 and add a test to verify that all pmu
metric expressions simply parse. Try to parse all metric ids/events,
skip/warn if metrics for the current architecture fail to parse. To
support warning for a skip, and an ability for a subtest to describe why
it skips.

Tested on power9, skylakex, haswell, broadwell, westmere, sandybridge and
ivybridge.

May skip/warn on other architectures if metrics are invalid. In
particular s390 is untested, but its expressions are trivial. The
untested architectures with expressions are power8, cascadelakex,
tremontx, skylake, jaketown, ivytown and variants of haswell and
broadwell.

v3. addresses review comments from John Garry <john.garry@huawei.com>,
Jiri Olsa <jolsa@redhat.com> and Arnaldo Carvalho de Melo
<acme@kernel.org>.
v2. changes the commit message as event parsing errors no longer cause
the test to fail.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Clarke <pc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20200513212933.41273-1-irogers@google.com
[ split from a larger patch ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/builtin-test.c |   7 ++
 tools/perf/tests/pmu-events.c   | 168 ++++++++++++++++++++++++++++++--
 tools/perf/tests/tests.h        |   3 +
 3 files changed, 172 insertions(+), 6 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index baee735e6aa5..9553f8061772 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -75,6 +75,13 @@ static struct test generic_tests[] = {
 	{
 		.desc = "PMU events",
 		.func = test__pmu_events,
+		.subtest = {
+			.skip_if_fail	= false,
+			.get_nr		= test__pmu_events_subtest_get_nr,
+			.get_desc	= test__pmu_events_subtest_get_desc,
+			.skip_reason	= test__pmu_events_subtest_skip_reason,
+		},
+
 	},
 	{
 		.desc = "DSO data read",
diff --git a/tools/perf/tests/pmu-events.c b/tools/perf/tests/pmu-events.c
index d64261da8bf7..e21f0addcfbb 100644
--- a/tools/perf/tests/pmu-events.c
+++ b/tools/perf/tests/pmu-events.c
@@ -8,6 +8,9 @@
 #include <linux/zalloc.h>
 #include "debug.h"
 #include "../pmu-events/pmu-events.h"
+#include "util/evlist.h"
+#include "util/expr.h"
+#include "util/parse-events.h"
 
 struct perf_pmu_test_event {
 	struct pmu_event event;
@@ -144,7 +147,7 @@ static struct pmu_events_map *__test_pmu_get_events_map(void)
 }
 
 /* Verify generated events from pmu-events.c is as expected */
-static int __test_pmu_event_table(void)
+static int test_pmu_event_table(void)
 {
 	struct pmu_events_map *map = __test_pmu_get_events_map();
 	struct pmu_event *table;
@@ -347,14 +350,11 @@ static int __test__pmu_event_aliases(char *pmu_name, int *count)
 	return res;
 }
 
-int test__pmu_events(struct test *test __maybe_unused,
-		     int subtest __maybe_unused)
+
+static int test_aliases(void)
 {
 	struct perf_pmu *pmu = NULL;
 
-	if (__test_pmu_event_table())
-		return -1;
-
 	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
 		int count = 0;
 
@@ -377,3 +377,159 @@ int test__pmu_events(struct test *test __maybe_unused,
 
 	return 0;
 }
+
+static bool is_number(const char *str)
+{
+	char *end_ptr;
+
+	strtod(str, &end_ptr);
+	return end_ptr != str;
+}
+
+static int check_parse_id(const char *id, bool same_cpu, struct pmu_event *pe)
+{
+	struct parse_events_error error;
+	struct evlist *evlist;
+	int ret;
+
+	/* Numbers are always valid. */
+	if (is_number(id))
+		return 0;
+
+	evlist = evlist__new();
+	memset(&error, 0, sizeof(error));
+	ret = parse_events(evlist, id, &error);
+	if (ret && same_cpu) {
+		pr_warning("Parse event failed metric '%s' id '%s' expr '%s'\n",
+			pe->metric_name, id, pe->metric_expr);
+		pr_warning("Error string '%s' help '%s'\n", error.str,
+			error.help);
+	} else if (ret) {
+		pr_debug3("Parse event failed, but for an event that may not be supported by this CPU.\nid '%s' metric '%s' expr '%s'\n",
+			  id, pe->metric_name, pe->metric_expr);
+		ret = 0;
+	}
+	evlist__delete(evlist);
+	free(error.str);
+	free(error.help);
+	free(error.first_str);
+	free(error.first_help);
+	return ret;
+}
+
+static void expr_failure(const char *msg,
+			 const struct pmu_events_map *map,
+			 const struct pmu_event *pe)
+{
+	pr_debug("%s for map %s %s %s\n",
+		msg, map->cpuid, map->version, map->type);
+	pr_debug("On metric %s\n", pe->metric_name);
+	pr_debug("On expression %s\n", pe->metric_expr);
+}
+
+static int test_parsing(void)
+{
+	struct pmu_events_map *cpus_map = perf_pmu__find_map(NULL);
+	struct pmu_events_map *map;
+	struct pmu_event *pe;
+	int i, j, k;
+	const char **ids;
+	int idnum;
+	int ret = 0;
+	struct expr_parse_ctx ctx;
+	double result;
+
+	i = 0;
+	for (;;) {
+		map = &pmu_events_map[i++];
+		if (!map->table)
+			break;
+		j = 0;
+		for (;;) {
+			pe = &map->table[j++];
+			if (!pe->name && !pe->metric_group && !pe->metric_name)
+				break;
+			if (!pe->metric_expr)
+				continue;
+			if (expr__find_other(pe->metric_expr, NULL,
+						&ids, &idnum, 0) < 0) {
+				expr_failure("Parse other failed", map, pe);
+				ret++;
+				continue;
+			}
+			expr__ctx_init(&ctx);
+
+			/*
+			 * Add all ids with a made up value. The value may
+			 * trigger divide by zero when subtracted and so try to
+			 * make them unique.
+			 */
+			for (k = 0; k < idnum; k++)
+				expr__add_id(&ctx, ids[k], k + 1);
+
+			for (k = 0; k < idnum; k++) {
+				if (check_parse_id(ids[k], map == cpus_map, pe))
+					ret++;
+			}
+
+			if (expr__parse(&result, &ctx, pe->metric_expr, 0)) {
+				expr_failure("Parse failed", map, pe);
+				ret++;
+			}
+			for (k = 0; k < idnum; k++)
+				zfree(&ids[k]);
+			free(ids);
+		}
+	}
+	/* TODO: fail when not ok */
+	return ret == 0 ? TEST_OK : TEST_SKIP;
+}
+
+static const struct {
+	int (*func)(void);
+	const char *desc;
+} pmu_events_testcase_table[] = {
+	{
+		.func = test_pmu_event_table,
+		.desc = "PMU event table sanity",
+	},
+	{
+		.func = test_aliases,
+		.desc = "PMU event map aliases",
+	},
+	{
+		.func = test_parsing,
+		.desc = "Parsing of PMU event table metrics",
+	},
+};
+
+const char *test__pmu_events_subtest_get_desc(int subtest)
+{
+	if (subtest < 0 ||
+	    subtest >= (int)ARRAY_SIZE(pmu_events_testcase_table))
+		return NULL;
+	return pmu_events_testcase_table[subtest].desc;
+}
+
+const char *test__pmu_events_subtest_skip_reason(int subtest)
+{
+	if (subtest < 0 ||
+	    subtest >= (int)ARRAY_SIZE(pmu_events_testcase_table))
+		return NULL;
+	if (pmu_events_testcase_table[subtest].func != test_parsing)
+		return NULL;
+	return "some metrics failed";
+}
+
+int test__pmu_events_subtest_get_nr(void)
+{
+	return (int)ARRAY_SIZE(pmu_events_testcase_table);
+}
+
+int test__pmu_events(struct test *test __maybe_unused, int subtest)
+{
+	if (subtest < 0 ||
+	    subtest >= (int)ARRAY_SIZE(pmu_events_testcase_table))
+		return TEST_FAIL;
+	return pmu_events_testcase_table[subtest].func();
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 88e45aeab94f..6c6c4b6a4796 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -51,6 +51,9 @@ int test__perf_evsel__tp_sched_test(struct test *test, int subtest);
 int test__syscall_openat_tp_fields(struct test *test, int subtest);
 int test__pmu(struct test *test, int subtest);
 int test__pmu_events(struct test *test, int subtest);
+const char *test__pmu_events_subtest_get_desc(int subtest);
+const char *test__pmu_events_subtest_skip_reason(int subtest);
+int test__pmu_events_subtest_get_nr(void);
 int test__attr(struct test *test, int subtest);
 int test__dso_data(struct test *test, int subtest);
 int test__dso_data_cache(struct test *test, int subtest);
-- 
2.26.2.761.g0e0b3e54be-goog


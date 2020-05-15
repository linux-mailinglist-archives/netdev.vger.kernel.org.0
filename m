Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070221D4674
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 08:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgEOG4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 02:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727001AbgEOG4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 02:56:46 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAD2C05BD0B
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 23:56:44 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h129so1584822ybc.3
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 23:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Qx5DR7q9yKe+bR/yiFue61eKIkA72C71MJNDdOxOzy4=;
        b=l6axO6bpPJ7he34PyFvu8nbo+5/gL2/wskwqJcsi+3p/gzezErAmQXMVXTfenMNQZ1
         k6q2a7FcJhnSKpOm4kAvgrxirH4c7PSVQVPUd7NEcdO9v/0wxLdGI6uij7Db1BKjRFZJ
         rwu3eUq0dJCEkUxzIZ/ooYoAVRtJ2XXa09toHvdbgcG/2hwPrdwyWGdR3YarILVfRqTr
         QkBzTiEtTXoXKMOuHJ6lNiry06XO8jpE6PqO7zd/HltHVEjWX+93N7Fk8/+vTaSewTt3
         nn4OwQiPIhFmjuZQq4JdUWSF1l8Cp5fTOdItSdZIv31MpSfy2BBV/nH6HFZfF3rW5XQE
         ehwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Qx5DR7q9yKe+bR/yiFue61eKIkA72C71MJNDdOxOzy4=;
        b=U4T5V+TUZe2IvQTFrJWu8FXlWKMHj9SrrmgybvJ5gidUi0Y7n88eOhv70j1nWx5eO4
         hyjT6461QPzn6zx+eCnDbZv2BPED9o1a8c/7eXl8D1I/UM4/iSGX9fZGtLmCzWb5sCtY
         oamWjb0UB/9rVUdMRoOCE1WjvIIKgeJa9ALZj1H2hAIXBK5583nk+nrLqHrVaJLdrYhh
         zN/kLgIrpUkrUHjSBf9xhE4lZuYDfcSsdie8N8REy5lEZkwYj+n+5v7PqJUJd9UurGot
         yTfxWQiRHDbgHHcJJpOGA1ooQUiq7G924Gs+gopNHwFZZRsL3uUAuLeoQkA2uPpJO/LR
         O1Yw==
X-Gm-Message-State: AOAM531NrMZ0KLgFXFMe8Q1RyVO8Mmg8FJ2xq7A7yT9/I7pH8bhxgDNf
        BWz66vaAINT0ITY/1fyMuSxp3G1Hk0ZS
X-Google-Smtp-Source: ABdhPJz9N+s3X6xjDoBQW0ErfYd0gLJbKsfNrHL07fBzBUoDJYr0IlyawWKrulzcmnBOi338kjc5lHSHvShy
X-Received: by 2002:a25:810e:: with SMTP id o14mr3112716ybk.453.1589525803900;
 Thu, 14 May 2020 23:56:43 -0700 (PDT)
Date:   Thu, 14 May 2020 23:56:23 -0700
In-Reply-To: <20200515065624.21658-1-irogers@google.com>
Message-Id: <20200515065624.21658-8-irogers@google.com>
Mime-Version: 1.0
References: <20200515065624.21658-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 7/8] perf test: Improve pmu event metric testing
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


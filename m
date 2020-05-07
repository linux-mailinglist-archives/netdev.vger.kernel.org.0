Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0207B1C8DC3
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgEGOIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728244AbgEGOIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:08:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134E3C05BD09
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 07:08:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n205so7153375ybf.14
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 07:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rIGhmr2k2fsuEkFgHHc3VNTSROpqunp3er0RiFQ8AOI=;
        b=sA6oZ5FyVrY8dQglX1KLmjYSulIYTUtv7sgrgC62rtFBGDO8ifcNw7Vakk6sn8TyKF
         CVGKrX/06P/E49URHd5MT8FpVd3RQrm+6DeesVhVVCOwlIKKTbmix/RQyMU2UI/X5ehT
         g30Pj+gmCu1uxvTagvvA98fm0cjfP0+PJcXBNy9e8GEQq5DiuYhQlADhy6tFgwgu25ZK
         FyjhGeaUJMY0kjaM8H6+4eH+SfhAlKYGPrMQph+x97MU/BRxiXxlVwKZOHh9nyjOJQo4
         bGfWvOMOsd4izEbUHK4INqgWzGiABtZ8LsvVJWyiNKPKMUSb/L7Y+o5S+gjHg8Tm2Jq/
         PGYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rIGhmr2k2fsuEkFgHHc3VNTSROpqunp3er0RiFQ8AOI=;
        b=fAOIDjSI7V9vWtWhy3T7k/rWFm7u3xGW31xL1KeehGoZwMlXjwB8ootEVD3c6O0YsI
         ngAoscoBnlfR4pGZ0e3M5ByjwlQ0z0dpBflhgHF07b/C+Za7JDE1HP0/EZpnkihBPLor
         Hhav2eh4qSlyiPV2wW5h/y3RbwH0nR6bpX+fTZ4zB08UfWNDy8Z/YEuWwyrecv3A0SNj
         bQn8PUQC82BiiJVqzP1pRjB8uwQW4anRXaKQveVfNUR3AXB1guxhkH0KU/yeI64sJ0wH
         sxWb/vQJ+vOi0w0Z8KOACmzADw6IB8oWVHGXsnHbhzmBQguXOARBKjmJ3XjqlGE8Or7e
         h/1w==
X-Gm-Message-State: AGi0PualNJCXJQXBI52YxtmcJ+/r42tzZrW6le+1pgBfzq+Y7YUNU3d8
        0++ySRm6dfS+rdkGNsdlqfh53NxOOpwd
X-Google-Smtp-Source: APiQypKitkprOUX6Ty32h3Hvvn+AL1eOiIeSJ2wkpA4G/oYuee3HlrAoqUdkBxc6K4PWHTN6ksoIH+EZnRsn
X-Received: by 2002:a5b:58a:: with SMTP id l10mr23253413ybp.483.1588860527214;
 Thu, 07 May 2020 07:08:47 -0700 (PDT)
Date:   Thu,  7 May 2020 07:08:08 -0700
In-Reply-To: <20200507140819.126960-1-irogers@google.com>
Message-Id: <20200507140819.126960-13-irogers@google.com>
Mime-Version: 1.0
References: <20200507140819.126960-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [RFC PATCH v2 12/23] perf test: improve pmu event metric testing
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
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a basic floating point number test to expr.
Break pmu-events test into 2 and add a test to verify that all pmu metric
expressions simply parse. Try to parse all metric ids/events, failing if
metrics for the current architecture fail to parse.

Tested on skylakex with the patch set in place. May fail on other
architectures if metrics are invalid.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/tests/builtin-test.c |   5 +
 tools/perf/tests/expr.c         |   1 +
 tools/perf/tests/pmu-events.c   | 158 ++++++++++++++++++++++++++++++--
 tools/perf/tests/tests.h        |   2 +
 4 files changed, 160 insertions(+), 6 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 3471ec52ea11..8147c17c71ab 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -75,6 +75,11 @@ static struct test generic_tests[] = {
 	{
 		.desc = "PMU events",
 		.func = test__pmu_events,
+		.subtest = {
+			.get_nr		= test__pmu_events_subtest_get_nr,
+			.get_desc	= test__pmu_events_subtest_get_desc,
+		},
+
 	},
 	{
 		.desc = "DSO data read",
diff --git a/tools/perf/tests/expr.c b/tools/perf/tests/expr.c
index f9e8e5628836..3f742612776a 100644
--- a/tools/perf/tests/expr.c
+++ b/tools/perf/tests/expr.c
@@ -39,6 +39,7 @@ int test__expr(struct test *t __maybe_unused, int subtest __maybe_unused)
 	ret |= test(&ctx, "min(1,2) + 1", 2);
 	ret |= test(&ctx, "max(1,2) + 1", 3);
 	ret |= test(&ctx, "1+1 if 3*4 else 0", 2);
+	ret |= test(&ctx, "1.1 + 2.1", 3.2);
 
 	if (ret)
 		return ret;
diff --git a/tools/perf/tests/pmu-events.c b/tools/perf/tests/pmu-events.c
index d64261da8bf7..c18b9ce8cace 100644
--- a/tools/perf/tests/pmu-events.c
+++ b/tools/perf/tests/pmu-events.c
@@ -8,6 +8,10 @@
 #include <linux/zalloc.h>
 #include "debug.h"
 #include "../pmu-events/pmu-events.h"
+#include "util/evlist.h"
+#include "util/expr.h"
+#include "util/parse-events.h"
+#include <ctype.h>
 
 struct perf_pmu_test_event {
 	struct pmu_event event;
@@ -144,7 +148,7 @@ static struct pmu_events_map *__test_pmu_get_events_map(void)
 }
 
 /* Verify generated events from pmu-events.c is as expected */
-static int __test_pmu_event_table(void)
+static int test_pmu_event_table(void)
 {
 	struct pmu_events_map *map = __test_pmu_get_events_map();
 	struct pmu_event *table;
@@ -347,14 +351,11 @@ static int __test__pmu_event_aliases(char *pmu_name, int *count)
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
 
@@ -377,3 +378,148 @@ int test__pmu_events(struct test *test __maybe_unused,
 
 	return 0;
 }
+
+static bool is_number(const char *str)
+{
+	size_t i;
+
+	for (i = 0; i < strlen(str); i++) {
+		if (!isdigit(str[i]) && str[i] != '.')
+			return false;
+	}
+	return true;
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
+		fprintf(stderr,
+			"\nWARNING: Parse event failed metric '%s' id '%s' expr '%s'\n",
+			pe->metric_name, id, pe->metric_expr);
+		fprintf(stderr, "Error string '%s' help '%s'\n",
+			error.str, error.help);
+	} else if (ret) {
+		pr_debug3("Parse event failed, but for an event that may not be supported by this CPU.\nid '%s' metric '%s' expr '%s'\n",
+			id, pe->metric_name, pe->metric_expr);
+	}
+	evlist__delete(evlist);
+	free(error.str);
+	free(error.help);
+	free(error.first_str);
+	free(error.first_help);
+	/* TODO: too many metrics are broken to fail on this test currently. */
+	return 0;
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
+		if (!map->table) {
+			map = NULL;
+			break;
+		}
+		j = 0;
+		for (;;) {
+			pe = &map->table[j++];
+			if (!pe->name && !pe->metric_group && !pe->metric_name)
+				break;
+			if (!pe->metric_expr)
+				continue;
+			if (expr__find_other(pe->metric_expr, NULL,
+						&ids, &idnum, 0) < 0) {
+				pr_debug("Parse other failed for map %s %s %s\n",
+					map->cpuid, map->version, map->type);
+				pr_debug("On metric %s\n", pe->metric_name);
+				pr_debug("On expression %s\n", pe->metric_expr);
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
+				pr_debug("Parse failed for map %s %s %s\n",
+					map->cpuid, map->version, map->type);
+				pr_debug("On metric %s\n", pe->metric_name);
+				pr_debug("On expression %s\n", pe->metric_expr);
+				ret++;
+			}
+			for (k = 0; k < idnum; k++)
+				zfree(&ids[k]);
+			free(ids);
+		}
+	}
+	return ret;
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
+const char *test__pmu_events_subtest_get_desc(int i)
+{
+	if (i < 0 || i >= (int)ARRAY_SIZE(pmu_events_testcase_table))
+		return NULL;
+	return pmu_events_testcase_table[i].desc;
+}
+
+int test__pmu_events_subtest_get_nr(void)
+{
+	return (int)ARRAY_SIZE(pmu_events_testcase_table);
+}
+
+int test__pmu_events(struct test *test __maybe_unused, int i)
+{
+	if (i < 0 || i >= (int)ARRAY_SIZE(pmu_events_testcase_table))
+		return TEST_FAIL;
+	return pmu_events_testcase_table[i].func();
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index d6d4ac34eeb7..8e316c30ed3c 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -50,6 +50,8 @@ int test__perf_evsel__tp_sched_test(struct test *test, int subtest);
 int test__syscall_openat_tp_fields(struct test *test, int subtest);
 int test__pmu(struct test *test, int subtest);
 int test__pmu_events(struct test *test, int subtest);
+const char *test__pmu_events_subtest_get_desc(int subtest);
+int test__pmu_events_subtest_get_nr(void);
 int test__attr(struct test *test, int subtest);
 int test__dso_data(struct test *test, int subtest);
 int test__dso_data_cache(struct test *test, int subtest);
-- 
2.26.2.526.g744177e7f7-goog


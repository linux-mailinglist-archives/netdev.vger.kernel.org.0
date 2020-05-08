Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F085A1CA2BE
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 07:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgEHFgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 01:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgEHFgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 01:36:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4576BC05BD09
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 22:36:47 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y189so755376ybc.14
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 22:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jUtNc5VuiSSf4v5M7uiQ4wMAqQTfgQdTth2yiGp5mbo=;
        b=fmP3MUBxMXT9npUORuVNHbVGcvLN7Vz6boneXg8TgkhtVcPxBa85TarpQmC18LvdSJ
         xY01VDEz0YIlO8tRPk8CXSzbSDofEW7YB0rob242P8UpgCfi4epveME8fxEhjGMdOAxd
         SZu8qm5T2QvLj53xXzPag8Uf0J2DDz+bJTqXvPMdQke1BAKGWTG0cUGGyBnZfJ1geNT8
         +29NT4veMmr3PNPi572Mx+coGUwBtVAL6V3EhLe0ssbxLvO/F6CT+zlQ25pvRCMIWJV8
         5EmmtHfZn5gZNtw4z6zrwpZeJrQV42oUvOncHIs4wWiw8ddkYesAqp0whUhfKm3CFWAu
         w0zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jUtNc5VuiSSf4v5M7uiQ4wMAqQTfgQdTth2yiGp5mbo=;
        b=J0xegdKDxrctmAkLE7fYoyq+KRbYhrKdGOVy0tC4WDIsGxYiTJpwM3zpPcm1NtbAoN
         P/YByClVjdB8R8fw5dMjDTqhHSxPuCM0cEmxCIv0AhUtkMJlKmfuTK5lJzeiAXssG0u+
         +q9hWAKD9s9GF23sFFZ+tdO5wEGz1gLSv29hMZ4IvU2Fdre19Zt92DlRXi/yCkZKnV0V
         yFqGAAv6OCIHP+mDT5QjPlFGrMuK/s/6swJqeF4A5cPQ0xovBOO40vcocp/uxu5P3ilF
         7X46futyyxqanfAZhs5P/AdxV1XJaJcZmlo2ffq1GzM6t8vDZ1EWGny83CWZ2WPnEu6e
         9P5g==
X-Gm-Message-State: AGi0Puascf1dK9t34Z9tTZzTVjvH1ngNCpS4NCSXLJK0o/RpiK6FQkx6
        WJVf84aa237edlPVirgxP1UAPcPltcMd
X-Google-Smtp-Source: APiQypIkyrnH6H/vbpqPw716qbcLGXp/Vbv0rbCQvSRjw3Ra7/DVaiKu1d2QS7kSvIRxE6+gvKNfsp3jD9+A
X-Received: by 2002:a25:6f86:: with SMTP id k128mr1982940ybc.305.1588916206358;
 Thu, 07 May 2020 22:36:46 -0700 (PDT)
Date:   Thu,  7 May 2020 22:36:22 -0700
In-Reply-To: <20200508053629.210324-1-irogers@google.com>
Message-Id: <20200508053629.210324-8-irogers@google.com>
Mime-Version: 1.0
References: <20200508053629.210324-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [RFC PATCH v3 07/14] perf expr: migrate expr ids table to libbpf's hashmap
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
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a hashmap between a char* string and a double* value. While bpf's
hashmap entries are size_t in size, we can't guarantee sizeof(size_t) >=
sizeof(double). Avoid a memory allocation when gathering ids by making 0.0
a special value encoded as NULL.

Suggested by Andi Kleen:
https://lore.kernel.org/lkml/20200224210308.GQ160988@tassilo.jf.intel.com/
and seconded by Jiri Olsa:
https://lore.kernel.org/lkml/20200423112915.GH1136647@krava/

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/tests/expr.c       |  40 ++++++-----
 tools/perf/tests/pmu-events.c |  25 +++----
 tools/perf/util/expr.c        | 129 +++++++++++++++++++---------------
 tools/perf/util/expr.h        |  22 +++---
 tools/perf/util/expr.y        |  22 +-----
 tools/perf/util/metricgroup.c |  87 +++++++++++------------
 tools/perf/util/stat-shadow.c |  49 ++++++++-----
 7 files changed, 193 insertions(+), 181 deletions(-)

diff --git a/tools/perf/tests/expr.c b/tools/perf/tests/expr.c
index 3f742612776a..5e606fd5a2c6 100644
--- a/tools/perf/tests/expr.c
+++ b/tools/perf/tests/expr.c
@@ -19,11 +19,9 @@ static int test(struct expr_parse_ctx *ctx, const char *e, double val2)
 int test__expr(struct test *t __maybe_unused, int subtest __maybe_unused)
 {
 	const char *p;
-	const char **other;
-	double val;
-	int i, ret;
+	double val, *val_ptr;
+	int ret;
 	struct expr_parse_ctx ctx;
-	int num_other;
 
 	expr__ctx_init(&ctx);
 	expr__add_id(&ctx, "FOO", 1);
@@ -52,25 +50,29 @@ int test__expr(struct test *t __maybe_unused, int subtest __maybe_unused)
 	ret = expr__parse(&val, &ctx, p, 1);
 	TEST_ASSERT_VAL("missing operand", ret == -1);
 
+	hashmap__clear(&ctx.ids);
 	TEST_ASSERT_VAL("find other",
-			expr__find_other("FOO + BAR + BAZ + BOZO", "FOO", &other, &num_other, 1) == 0);
-	TEST_ASSERT_VAL("find other", num_other == 3);
-	TEST_ASSERT_VAL("find other", !strcmp(other[0], "BAR"));
-	TEST_ASSERT_VAL("find other", !strcmp(other[1], "BAZ"));
-	TEST_ASSERT_VAL("find other", !strcmp(other[2], "BOZO"));
-	TEST_ASSERT_VAL("find other", other[3] == NULL);
+			expr__find_other("FOO + BAR + BAZ + BOZO", "FOO",
+					 &ctx, 1) == 0);
+	TEST_ASSERT_VAL("find other", hashmap__size(&ctx.ids) == 3);
+	TEST_ASSERT_VAL("find other", hashmap__find(&ctx.ids, "BAR",
+						    (void **)&val_ptr));
+	TEST_ASSERT_VAL("find other", hashmap__find(&ctx.ids, "BAZ",
+						    (void **)&val_ptr));
+	TEST_ASSERT_VAL("find other", hashmap__find(&ctx.ids, "BOZO",
+						    (void **)&val_ptr));
 
+	hashmap__clear(&ctx.ids);
 	TEST_ASSERT_VAL("find other",
-			expr__find_other("EVENT1\\,param\\=?@ + EVENT2\\,param\\=?@", NULL,
-				   &other, &num_other, 3) == 0);
-	TEST_ASSERT_VAL("find other", num_other == 2);
-	TEST_ASSERT_VAL("find other", !strcmp(other[0], "EVENT1,param=3/"));
-	TEST_ASSERT_VAL("find other", !strcmp(other[1], "EVENT2,param=3/"));
-	TEST_ASSERT_VAL("find other", other[2] == NULL);
+			expr__find_other("EVENT1\\,param\\=?@ + EVENT2\\,param\\=?@",
+					 NULL, &ctx, 3) == 0);
+	TEST_ASSERT_VAL("find other", hashmap__size(&ctx.ids) == 2);
+	TEST_ASSERT_VAL("find other", hashmap__find(&ctx.ids, "EVENT1,param=3/",
+						    (void **)&val_ptr));
+	TEST_ASSERT_VAL("find other", hashmap__find(&ctx.ids, "EVENT2,param=3/",
+						    (void **)&val_ptr));
 
-	for (i = 0; i < num_other; i++)
-		zfree(&other[i]);
-	free((void *)other);
+	expr__ctx_clear(&ctx);
 
 	return 0;
 }
diff --git a/tools/perf/tests/pmu-events.c b/tools/perf/tests/pmu-events.c
index c18b9ce8cace..054550ee811c 100644
--- a/tools/perf/tests/pmu-events.c
+++ b/tools/perf/tests/pmu-events.c
@@ -428,8 +428,6 @@ static int test_parsing(void)
 	struct pmu_events_map *map;
 	struct pmu_event *pe;
 	int i, j, k;
-	const char **ids;
-	int idnum;
 	int ret = 0;
 	struct expr_parse_ctx ctx;
 	double result;
@@ -443,13 +441,17 @@ static int test_parsing(void)
 		}
 		j = 0;
 		for (;;) {
+			struct hashmap_entry *cur;
+			size_t bkt;
+
 			pe = &map->table[j++];
 			if (!pe->name && !pe->metric_group && !pe->metric_name)
 				break;
 			if (!pe->metric_expr)
 				continue;
-			if (expr__find_other(pe->metric_expr, NULL,
-						&ids, &idnum, 0) < 0) {
+			expr__ctx_init(&ctx);
+			if (expr__find_other(pe->metric_expr, NULL, &ctx, 0)
+				  < 0) {
 				pr_debug("Parse other failed for map %s %s %s\n",
 					map->cpuid, map->version, map->type);
 				pr_debug("On metric %s\n", pe->metric_name);
@@ -457,18 +459,19 @@ static int test_parsing(void)
 				ret++;
 				continue;
 			}
-			expr__ctx_init(&ctx);
 
 			/*
 			 * Add all ids with a made up value. The value may
 			 * trigger divide by zero when subtracted and so try to
 			 * make them unique.
 			 */
-			for (k = 0; k < idnum; k++)
-				expr__add_id(&ctx, ids[k], k + 1);
+			k = 1;
+			hashmap__for_each_entry((&ctx.ids), cur, bkt)
+				expr__add_id(&ctx, strdup(cur->key), k++);
 
-			for (k = 0; k < idnum; k++) {
-				if (check_parse_id(ids[k], map == cpus_map, pe))
+			hashmap__for_each_entry((&ctx.ids), cur, bkt) {
+				if (check_parse_id(cur->key, map == cpus_map,
+						   pe))
 					ret++;
 			}
 
@@ -479,9 +482,7 @@ static int test_parsing(void)
 				pr_debug("On expression %s\n", pe->metric_expr);
 				ret++;
 			}
-			for (k = 0; k < idnum; k++)
-				zfree(&ids[k]);
-			free(ids);
+			expr__ctx_clear(&ctx);
 		}
 	}
 	return ret;
diff --git a/tools/perf/util/expr.c b/tools/perf/util/expr.c
index 8b4ce704a68d..f64ab91c432b 100644
--- a/tools/perf/util/expr.c
+++ b/tools/perf/util/expr.c
@@ -4,25 +4,76 @@
 #include "expr.h"
 #include "expr-bison.h"
 #include "expr-flex.h"
+#include <linux/kernel.h>
 
 #ifdef PARSER_DEBUG
 extern int expr_debug;
 #endif
 
+static size_t key_hash(const void *key, void *ctx __maybe_unused)
+{
+	const char *str = (const char *)key;
+	size_t hash = 0;
+
+	while (*str != '\0') {
+		hash *= 31;
+		hash += *str;
+		str++;
+	}
+	return hash;
+}
+
+static bool key_equal(const void *key1, const void *key2,
+		    void *ctx __maybe_unused)
+{
+	return !strcmp((const char *)key1, (const char *)key2);
+}
+
 /* Caller must make sure id is allocated */
-void expr__add_id(struct expr_parse_ctx *ctx, const char *name, double val)
+int expr__add_id(struct expr_parse_ctx *ctx, const char *name, double val)
 {
-	int idx;
+	double *val_ptr = NULL, *old_val = NULL;
+	char *old_key = NULL;
+	int ret;
+
+	if (val != 0.0) {
+		val_ptr = malloc(sizeof(double));
+		if (!val_ptr)
+			return -ENOMEM;
+		*val_ptr = val;
+	}
+	ret = hashmap__set(&ctx->ids, name, val_ptr,
+			   (const void **)&old_key, (void **)&old_val);
+	free(old_key);
+	free(old_val);
+	return ret;
+}
+
+int expr__get_id(struct expr_parse_ctx *ctx, const char *id, double *val_ptr)
+{
+	double *data;
 
-	assert(ctx->num_ids < MAX_PARSE_ID);
-	idx = ctx->num_ids++;
-	ctx->ids[idx].name = name;
-	ctx->ids[idx].val = val;
+	if (!hashmap__find(&ctx->ids, id, (void **)&data))
+		return -1;
+	*val_ptr = (data == NULL) ?  0.0 : *data;
+	return 0;
 }
 
 void expr__ctx_init(struct expr_parse_ctx *ctx)
 {
-	ctx->num_ids = 0;
+	hashmap__init(&ctx->ids, key_hash, key_equal, NULL);
+}
+
+void expr__ctx_clear(struct expr_parse_ctx *ctx)
+{
+	struct hashmap_entry *cur;
+	size_t bkt;
+
+	hashmap__for_each_entry((&ctx->ids), cur, bkt) {
+		free((char *)cur->key);
+		free(cur->value);
+	}
+	hashmap__clear(&ctx->ids);
 }
 
 static int
@@ -56,61 +107,25 @@ __expr__parse(double *val, struct expr_parse_ctx *ctx, const char *expr,
 	return ret;
 }
 
-int expr__parse(double *final_val, struct expr_parse_ctx *ctx, const char *expr, int runtime)
+int expr__parse(double *final_val, struct expr_parse_ctx *ctx,
+		const char *expr, int runtime)
 {
 	return __expr__parse(final_val, ctx, expr, EXPR_PARSE, runtime) ? -1 : 0;
 }
 
-static bool
-already_seen(const char *val, const char *one, const char **other,
-	     int num_other)
-{
-	int i;
-
-	if (one && !strcasecmp(one, val))
-		return true;
-	for (i = 0; i < num_other; i++)
-		if (!strcasecmp(other[i], val))
-			return true;
-	return false;
-}
-
-int expr__find_other(const char *expr, const char *one, const char ***other,
-		     int *num_other, int runtime)
+int expr__find_other(const char *expr, const char *one,
+		     struct expr_parse_ctx *ctx, int runtime)
 {
-	int err, i = 0, j = 0;
-	struct expr_parse_ctx ctx;
-
-	expr__ctx_init(&ctx);
-	err = __expr__parse(NULL, &ctx, expr, EXPR_OTHER, runtime);
-	if (err)
-		return -1;
-
-	*other = malloc((ctx.num_ids + 1) * sizeof(char *));
-	if (!*other)
-		return -ENOMEM;
-
-	for (i = 0, j = 0; i < ctx.num_ids; i++) {
-		const char *str = ctx.ids[i].name;
-
-		if (already_seen(str, one, *other, j))
-			continue;
-
-		str = strdup(str);
-		if (!str)
-			goto out;
-		(*other)[j++] = str;
-	}
-	(*other)[j] = NULL;
-
-out:
-	if (i != ctx.num_ids) {
-		while (--j)
-			free((char *) (*other)[i]);
-		free(*other);
-		err = -1;
+	double *old_val = NULL;
+	char *old_key = NULL;
+	int ret = __expr__parse(NULL, ctx, expr, EXPR_OTHER, runtime);
+
+	if (one) {
+		hashmap__delete(&ctx->ids, one,
+				(const void **)&old_key, (void **)&old_val);
+		free(old_key);
+		free(old_val);
 	}
 
-	*num_other = j;
-	return err;
+	return ret;
 }
diff --git a/tools/perf/util/expr.h b/tools/perf/util/expr.h
index 40fc452b0f2b..f01bd5ecb09d 100644
--- a/tools/perf/util/expr.h
+++ b/tools/perf/util/expr.h
@@ -2,17 +2,10 @@
 #ifndef PARSE_CTX_H
 #define PARSE_CTX_H 1
 
-#define EXPR_MAX_OTHER 64
-#define MAX_PARSE_ID EXPR_MAX_OTHER
-
-struct expr_parse_id {
-	const char *name;
-	double val;
-};
+#include <bpf/hashmap.h>
 
 struct expr_parse_ctx {
-	int num_ids;
-	struct expr_parse_id ids[MAX_PARSE_ID];
+	struct hashmap ids;
 };
 
 struct expr_scanner_ctx {
@@ -21,9 +14,12 @@ struct expr_scanner_ctx {
 };
 
 void expr__ctx_init(struct expr_parse_ctx *ctx);
-void expr__add_id(struct expr_parse_ctx *ctx, const char *id, double val);
-int expr__parse(double *final_val, struct expr_parse_ctx *ctx, const char *expr, int runtime);
-int expr__find_other(const char *expr, const char *one, const char ***other,
-		int *num_other, int runtime);
+void expr__ctx_clear(struct expr_parse_ctx *ctx);
+int expr__add_id(struct expr_parse_ctx *ctx, const char *id, double val);
+int expr__get_id(struct expr_parse_ctx *ctx, const char *id, double *val_ptr);
+int expr__parse(double *final_val, struct expr_parse_ctx *ctx,
+		const char *expr, int runtime);
+int expr__find_other(const char *expr, const char *one,
+		struct expr_parse_ctx *ids, int runtime);
 
 #endif
diff --git a/tools/perf/util/expr.y b/tools/perf/util/expr.y
index 3b49b230b111..bf3e898e3055 100644
--- a/tools/perf/util/expr.y
+++ b/tools/perf/util/expr.y
@@ -47,19 +47,6 @@ static void expr_error(double *final_val __maybe_unused,
 	pr_debug("%s\n", s);
 }
 
-static int lookup_id(struct expr_parse_ctx *ctx, char *id, double *val)
-{
-	int i;
-
-	for (i = 0; i < ctx->num_ids; i++) {
-		if (!strcasecmp(ctx->ids[i].name, id)) {
-			*val = ctx->ids[i].val;
-			return 0;
-		}
-	}
-	return -1;
-}
-
 %}
 %%
 
@@ -73,12 +60,7 @@ all_other: all_other other
 
 other: ID
 {
-	if (ctx->num_ids + 1 >= EXPR_MAX_OTHER) {
-		pr_err("failed: way too many variables");
-		YYABORT;
-	}
-
-	ctx->ids[ctx->num_ids++].name = $1;
+	expr__add_id(ctx, $1, 0.0);
 }
 |
 MIN | MAX | IF | ELSE | SMT_ON | NUMBER | '|' | '^' | '&' | '-' | '+' | '*' | '/' | '%' | '(' | ')' | ','
@@ -93,7 +75,7 @@ if_expr:
 	;
 
 expr:	  NUMBER
-	| ID			{ if (lookup_id(ctx, $1, &$$) < 0) {
+	| ID			{ if (expr__get_id(ctx, $1, &$$)) {
 					pr_debug("%s not found\n", $1);
 					free($1);
 					YYABORT;
diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index b071df373f8b..37be5a368d6e 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -85,8 +85,7 @@ static void metricgroup__rblist_init(struct rblist *metric_events)
 
 struct egroup {
 	struct list_head nd;
-	int idnum;
-	const char **ids;
+	struct expr_parse_ctx pctx;
 	const char *metric_name;
 	const char *metric_expr;
 	const char *metric_unit;
@@ -94,19 +93,21 @@ struct egroup {
 };
 
 static struct evsel *find_evsel_group(struct evlist *perf_evlist,
-				      const char **ids,
-				      int idnum,
+				      struct expr_parse_ctx *pctx,
 				      struct evsel **metric_events,
 				      bool *evlist_used)
 {
 	struct evsel *ev;
-	int i = 0, j = 0;
 	bool leader_found;
+	const size_t idnum = hashmap__size(&pctx->ids);
+	size_t i = 0;
+	int j = 0;
+	double *val_ptr;
 
 	evlist__for_each_entry (perf_evlist, ev) {
 		if (evlist_used[j++])
 			continue;
-		if (!strcmp(ev->name, ids[i])) {
+		if (hashmap__find(&pctx->ids, ev->name, (void **)&val_ptr)) {
 			if (!metric_events[i])
 				metric_events[i] = ev;
 			i++;
@@ -118,7 +119,8 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 			memset(metric_events, 0,
 				sizeof(struct evsel *) * idnum);
 
-			if (!strcmp(ev->name, ids[i])) {
+			if (hashmap__find(&pctx->ids, ev->name,
+					  (void **)&val_ptr)) {
 				if (!metric_events[i])
 					metric_events[i] = ev;
 				i++;
@@ -175,19 +177,20 @@ static int metricgroup__setup_events(struct list_head *groups,
 	list_for_each_entry (eg, groups, nd) {
 		struct evsel **metric_events;
 
-		metric_events = calloc(sizeof(void *), eg->idnum + 1);
+		metric_events = calloc(sizeof(void *),
+				hashmap__size(&eg->pctx.ids) + 1);
 		if (!metric_events) {
 			ret = -ENOMEM;
 			break;
 		}
-		evsel = find_evsel_group(perf_evlist, eg->ids, eg->idnum,
-					 metric_events, evlist_used);
+		evsel = find_evsel_group(perf_evlist, &eg->pctx, metric_events,
+					evlist_used);
 		if (!evsel) {
 			pr_debug("Cannot resolve %s: %s\n",
 					eg->metric_name, eg->metric_expr);
 			continue;
 		}
-		for (i = 0; i < eg->idnum; i++)
+		for (i = 0; metric_events[i]; i++)
 			metric_events[i]->collect_stat = true;
 		me = metricgroup__lookup(metric_events_list, evsel, true);
 		if (!me) {
@@ -415,20 +418,20 @@ void metricgroup__print(bool metrics, bool metricgroups, char *filter,
 }
 
 static void metricgroup__add_metric_weak_group(struct strbuf *events,
-					       const char **ids,
-					       int idnum)
+					       struct expr_parse_ctx *ctx)
 {
+	struct hashmap_entry *cur;
+	size_t bkt, i = 0;
 	bool no_group = false;
-	int i;
 
-	for (i = 0; i < idnum; i++) {
-		pr_debug("found event %s\n", ids[i]);
+	hashmap__for_each_entry((&ctx->ids), cur, bkt) {
+		pr_debug("found event %s\n", (const char *)cur->key);
 		/*
 		 * Duration time maps to a software event and can make
 		 * groups not count. Always use it outside a
 		 * group.
 		 */
-		if (!strcmp(ids[i], "duration_time")) {
+		if (!strcmp(cur->key, "duration_time")) {
 			if (i > 0)
 				strbuf_addf(events, "}:W,");
 			strbuf_addf(events, "duration_time");
@@ -437,21 +440,22 @@ static void metricgroup__add_metric_weak_group(struct strbuf *events,
 		}
 		strbuf_addf(events, "%s%s",
 			i == 0 || no_group ? "{" : ",",
-			ids[i]);
+			(const char *)cur->key);
 		no_group = false;
+		i++;
 	}
 	if (!no_group)
 		strbuf_addf(events, "}:W");
 }
 
 static void metricgroup__add_metric_non_group(struct strbuf *events,
-					      const char **ids,
-					      int idnum)
+					      struct expr_parse_ctx *ctx)
 {
-	int i;
+	struct hashmap_entry *cur;
+	size_t bkt;
 
-	for (i = 0; i < idnum; i++)
-		strbuf_addf(events, ",%s", ids[i]);
+	hashmap__for_each_entry((&ctx->ids), cur, bkt)
+		strbuf_addf(events, ",%s", (const char *)cur->key);
 }
 
 static void metricgroup___watchdog_constraint_hint(const char *name, bool foot)
@@ -495,32 +499,32 @@ int __weak arch_get_runtimeparam(void)
 static int __metricgroup__add_metric(struct strbuf *events,
 		struct list_head *group_list, struct pmu_event *pe, int runtime)
 {
-
-	const char **ids;
-	int idnum;
 	struct egroup *eg;
 
-	if (expr__find_other(pe->metric_expr, NULL, &ids, &idnum, runtime) < 0)
-		return -EINVAL;
-
-	if (events->len > 0)
-		strbuf_addf(events, ",");
-
-	if (metricgroup__has_constraint(pe))
-		metricgroup__add_metric_non_group(events, ids, idnum);
-	else
-		metricgroup__add_metric_weak_group(events, ids, idnum);
-
 	eg = malloc(sizeof(*eg));
 	if (!eg)
 		return -ENOMEM;
 
-	eg->ids = ids;
-	eg->idnum = idnum;
+	expr__ctx_init(&eg->pctx);
 	eg->metric_name = pe->metric_name;
 	eg->metric_expr = pe->metric_expr;
 	eg->metric_unit = pe->unit;
 	eg->runtime = runtime;
+
+	if (expr__find_other(pe->metric_expr, NULL, &eg->pctx, runtime) < 0) {
+		expr__ctx_clear(&eg->pctx);
+		free(eg);
+		return -EINVAL;
+	}
+
+	if (events->len > 0)
+		strbuf_addf(events, ",");
+
+	if (metricgroup__has_constraint(pe))
+		metricgroup__add_metric_non_group(events, &eg->pctx);
+	else
+		metricgroup__add_metric_weak_group(events, &eg->pctx);
+
 	list_add_tail(&eg->nd, group_list);
 
 	return 0;
@@ -603,12 +607,9 @@ static int metricgroup__add_metric_list(const char *list, struct strbuf *events,
 static void metricgroup__free_egroups(struct list_head *group_list)
 {
 	struct egroup *eg, *egtmp;
-	int i;
 
 	list_for_each_entry_safe (eg, egtmp, group_list, nd) {
-		for (i = 0; i < eg->idnum; i++)
-			zfree(&eg->ids[i]);
-		zfree(&eg->ids);
+		expr__ctx_clear(&eg->pctx);
 		list_del_init(&eg->nd);
 		free(eg);
 	}
diff --git a/tools/perf/util/stat-shadow.c b/tools/perf/util/stat-shadow.c
index 9bd7a8d2a858..c44dc814b377 100644
--- a/tools/perf/util/stat-shadow.c
+++ b/tools/perf/util/stat-shadow.c
@@ -323,35 +323,46 @@ void perf_stat__collect_metric_expr(struct evlist *evsel_list)
 {
 	struct evsel *counter, *leader, **metric_events, *oc;
 	bool found;
-	const char **metric_names;
+	struct expr_parse_ctx ctx;
+	struct hashmap_entry *cur;
+	size_t bkt;
 	int i;
-	int num_metric_names;
 
+	expr__ctx_init(&ctx);
 	evlist__for_each_entry(evsel_list, counter) {
 		bool invalid = false;
 
 		leader = counter->leader;
 		if (!counter->metric_expr)
 			continue;
+
+		expr__ctx_clear(&ctx);
 		metric_events = counter->metric_events;
 		if (!metric_events) {
-			if (expr__find_other(counter->metric_expr, counter->name,
-						&metric_names, &num_metric_names, 1) < 0)
+			if (expr__find_other(counter->metric_expr,
+					     counter->name,
+					     &ctx, 1) < 0)
 				continue;
 
 			metric_events = calloc(sizeof(struct evsel *),
-					       num_metric_names + 1);
-			if (!metric_events)
+					       hashmap__size(&ctx.ids) + 1);
+			if (!metric_events) {
+				expr__ctx_clear(&ctx);
 				return;
+			}
 			counter->metric_events = metric_events;
 		}
 
-		for (i = 0; i < num_metric_names; i++) {
+		i = 0;
+		hashmap__for_each_entry((&ctx.ids), cur, bkt) {
+			const char *metric_name = (const char *)cur->key;
+
 			found = false;
 			if (leader) {
 				/* Search in group */
 				for_each_group_member (oc, leader) {
-					if (!strcasecmp(oc->name, metric_names[i]) &&
+					if (!strcasecmp(oc->name,
+							metric_name) &&
 						!oc->collect_stat) {
 						found = true;
 						break;
@@ -360,7 +371,8 @@ void perf_stat__collect_metric_expr(struct evlist *evsel_list)
 			}
 			if (!found) {
 				/* Search ignoring groups */
-				oc = perf_stat__find_event(evsel_list, metric_names[i]);
+				oc = perf_stat__find_event(evsel_list,
+							   metric_name);
 			}
 			if (!oc) {
 				/* Deduping one is good enough to handle duplicated PMUs. */
@@ -373,27 +385,28 @@ void perf_stat__collect_metric_expr(struct evlist *evsel_list)
 				 * of events. So we ask the user instead to add the missing
 				 * events.
 				 */
-				if (!printed || strcasecmp(printed, metric_names[i])) {
+				if (!printed ||
+				    strcasecmp(printed, metric_name)) {
 					fprintf(stderr,
 						"Add %s event to groups to get metric expression for %s\n",
-						metric_names[i],
+						metric_name,
 						counter->name);
-					printed = strdup(metric_names[i]);
+					printed = strdup(metric_name);
 				}
 				invalid = true;
 				continue;
 			}
-			metric_events[i] = oc;
+			metric_events[i++] = oc;
 			oc->collect_stat = true;
 		}
 		metric_events[i] = NULL;
-		free(metric_names);
 		if (invalid) {
 			free(metric_events);
 			counter->metric_events = NULL;
 			counter->metric_expr = NULL;
 		}
 	}
+	expr__ctx_clear(&ctx);
 }
 
 static double runtime_stat_avg(struct runtime_stat *st,
@@ -738,7 +751,10 @@ static void generic_metric(struct perf_stat_config *config,
 
 	expr__ctx_init(&pctx);
 	/* Must be first id entry */
-	expr__add_id(&pctx, name, avg);
+	n = strdup(name);
+	if (!n)
+		return;
+	expr__add_id(&pctx, n, avg);
 	for (i = 0; metric_events[i]; i++) {
 		struct saved_value *v;
 		struct stats *stats;
@@ -814,8 +830,7 @@ static void generic_metric(struct perf_stat_config *config,
 			     (metric_name ? metric_name : name) : "", 0);
 	}
 
-	for (i = 1; i < pctx.num_ids; i++)
-		zfree(&pctx.ids[i].name);
+	expr__ctx_clear(&pctx);
 }
 
 void perf_stat__print_shadow_stats(struct perf_stat_config *config,
-- 
2.26.2.645.ge9eca65c58-goog


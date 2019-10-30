Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11828EA64F
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfJ3WfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:35:16 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:39770 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbfJ3WfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:35:14 -0400
Received: by mail-pg1-f202.google.com with SMTP id m20so2732884pgv.6
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XBR+LBIO8UwhtIFgRGeRHsyC7SP8OsXmQpo/yiQxcx4=;
        b=jeP0KC58lwMIbpA1jDbbGJucE9/RK7tMjDPU3JnpWci1v803G6/p73N28/TgtGaSP6
         lfu/E4pTKtNYRM7QtNAxdlfZ0nFAsC+vIqYksAOqB0FWw4W1j/TlummG2HpYo0zymOkb
         ehNACuxtsv/HJsgdibi/K+3VQGL0rMDek+iX9iPLyiJlMDXkmeRsQVfKTN2yrddajZEk
         y60Jv+wq24bOFDUFw7XjTTFYUEQjkk5+lRAKFH9ejSBaUQrQkYKi+EhIXM9TwM6hnGph
         AULgkXWPjSJFbzgXStgUxphQUR4TeSlt+5yVMT3dGKtna41Kgm9Hj8vfxiwkZz39FT1Q
         S/CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XBR+LBIO8UwhtIFgRGeRHsyC7SP8OsXmQpo/yiQxcx4=;
        b=DOX8Ab8jkShzh179bFXvZ/YyUFow/aGa/cBDTdG/LHLY8bVjkg3bVsXtimm3rqYR3e
         hocK5eaY1ooFfqIAuBYjf8CBplivL+yTLPuV/q7l7synHj5NQTSd15UmQzFumheP5Q4T
         eu880gLhZUfp+geSqB1Fq/ortfomo+37K1YVLyZAvI3WY1giQvbPzGCKxa+eWT49kJMl
         RLS2huwA7Xe6cle2rR1DqQ6DKoyyZG5fNnnMxgCdyK38o4p664zHtuB+VuDYAcnnKubH
         GUr+lSaxwecBVW1QEF8PPua7uRE/i0SkWOuUtZtfjRS4bIlM5JhB/VW0DZ9Dtb9JZdBy
         dKxg==
X-Gm-Message-State: APjAAAXlWT9/TnjZIuUfJe8bawzzXmDLXUmVNWaV4EdMG8BeFglB0yuN
        EfzvX2aKgS39+1RS3aMWEADyZEji+VMh
X-Google-Smtp-Source: APXvYqyN6D2cz7ERmBa0fMmhzNzSS+ISrUjf+kwHhxIs44P6eG/XvqhBW6AY0QGPp1aJHtlhGIxKMBWdxvee
X-Received: by 2002:a63:e055:: with SMTP id n21mr1936911pgj.411.1572474911501;
 Wed, 30 Oct 2019 15:35:11 -0700 (PDT)
Date:   Wed, 30 Oct 2019 15:34:45 -0700
In-Reply-To: <20191030223448.12930-1-irogers@google.com>
Message-Id: <20191030223448.12930-8-irogers@google.com>
Mime-Version: 1.0
References: <20191025180827.191916-1-irogers@google.com> <20191030223448.12930-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 07/10] perf tools: before yyabort-ing free components
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
        Andi Kleen <ak@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yyabort doesn't destruct inputs and so this must be done manually before
using yyabort.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/parse-events.y | 252 ++++++++++++++++++++++++++-------
 1 file changed, 197 insertions(+), 55 deletions(-)

diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 035edfa8d42e..376b19855470 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -152,6 +152,7 @@ start_events: groups
 {
 	struct parse_events_state *parse_state = _parse_state;
 
+	/* frees $1 */
 	parse_events_update_lists($1, &parse_state->list);
 }
 
@@ -161,6 +162,7 @@ groups ',' group
 	struct list_head *list  = $1;
 	struct list_head *group = $3;
 
+	/* frees $3 */
 	parse_events_update_lists(group, list);
 	$$ = list;
 }
@@ -170,6 +172,7 @@ groups ',' event
 	struct list_head *list  = $1;
 	struct list_head *event = $3;
 
+	/* frees $3 */
 	parse_events_update_lists(event, list);
 	$$ = list;
 }
@@ -182,8 +185,14 @@ group:
 group_def ':' PE_MODIFIER_EVENT
 {
 	struct list_head *list = $1;
+	int err;
 
-	ABORT_ON(parse_events__modifier_group(list, $3));
+	err = parse_events__modifier_group(list, $3);
+	free($3);
+	if (err) {
+		free_list_evsel(list);
+		YYABORT;
+	}
 	$$ = list;
 }
 |
@@ -196,6 +205,7 @@ PE_NAME '{' events '}'
 
 	inc_group_count(list, _parse_state);
 	parse_events__set_leader($1, list, _parse_state);
+	free($1);
 	$$ = list;
 }
 |
@@ -214,6 +224,7 @@ events ',' event
 	struct list_head *event = $3;
 	struct list_head *list  = $1;
 
+	/* frees $3 */
 	parse_events_update_lists(event, list);
 	$$ = list;
 }
@@ -226,13 +237,19 @@ event_mod:
 event_name PE_MODIFIER_EVENT
 {
 	struct list_head *list = $1;
+	int err;
 
 	/*
 	 * Apply modifier on all events added by single event definition
 	 * (there could be more events added for multiple tracepoint
 	 * definitions via '*?'.
 	 */
-	ABORT_ON(parse_events__modifier_event(list, $2, false));
+	err = parse_events__modifier_event(list, $2, false);
+	free($2);
+	if (err) {
+		free_list_evsel(list);
+		YYABORT;
+	}
 	$$ = list;
 }
 |
@@ -241,8 +258,14 @@ event_name
 event_name:
 PE_EVENT_NAME event_def
 {
-	ABORT_ON(parse_events_name($2, $1));
+	int err;
+
+	err = parse_events_name($2, $1);
 	free($1);
+	if (err) {
+		free_list_evsel($2);
+		YYABORT;
+	}
 	$$ = $2;
 }
 |
@@ -262,23 +285,33 @@ PE_NAME opt_pmu_config
 {
 	struct parse_events_state *parse_state = _parse_state;
 	struct parse_events_error *error = parse_state->error;
-	struct list_head *list, *orig_terms, *terms;
+	struct list_head *list = NULL, *orig_terms = NULL, *terms= NULL;
+	char *pattern = NULL;
+
+#define CLEANUP_YYABORT					\
+	do {						\
+		parse_events_terms__delete($2);		\
+		parse_events_terms__delete(orig_terms);	\
+		free($1);				\
+		free(pattern);				\
+		YYABORT;				\
+	} while(0)
 
 	if (parse_events_copy_term_list($2, &orig_terms))
-		YYABORT;
+		CLEANUP_YYABORT;
 
 	if (error)
 		error->idx = @1.first_column;
 
 	list = alloc_list();
-	ABORT_ON(!list);
+	if (!list)
+		CLEANUP_YYABORT;
 	if (parse_events_add_pmu(_parse_state, list, $1, $2, false, false)) {
 		struct perf_pmu *pmu = NULL;
 		int ok = 0;
-		char *pattern;
 
 		if (asprintf(&pattern, "%s*", $1) < 0)
-			YYABORT;
+			CLEANUP_YYABORT;
 
 		while ((pmu = perf_pmu__scan(pmu)) != NULL) {
 			char *name = pmu->name;
@@ -287,31 +320,32 @@ PE_NAME opt_pmu_config
 			    strncmp($1, "uncore_", 7))
 				name += 7;
 			if (!fnmatch(pattern, name, 0)) {
-				if (parse_events_copy_term_list(orig_terms, &terms)) {
-					free(pattern);
-					YYABORT;
-				}
+				if (parse_events_copy_term_list(orig_terms, &terms))
+					CLEANUP_YYABORT;
 				if (!parse_events_add_pmu(_parse_state, list, pmu->name, terms, true, false))
 					ok++;
 				parse_events_terms__delete(terms);
 			}
 		}
 
-		free(pattern);
-
 		if (!ok)
-			YYABORT;
+			CLEANUP_YYABORT;
 	}
 	parse_events_terms__delete($2);
 	parse_events_terms__delete(orig_terms);
+	free($1);
 	$$ = list;
+#undef CLEANUP_YYABORT
 }
 |
 PE_KERNEL_PMU_EVENT sep_dc
 {
 	struct list_head *list;
+	int err;
 
-	if (parse_events_multi_pmu_add(_parse_state, $1, &list) < 0)
+	err = parse_events_multi_pmu_add(_parse_state, $1, &list);
+	free($1);
+	if (err < 0)
 		YYABORT;
 	$$ = list;
 }
@@ -322,6 +356,8 @@ PE_PMU_EVENT_PRE '-' PE_PMU_EVENT_SUF sep_dc
 	char pmu_name[128];
 
 	snprintf(&pmu_name, 128, "%s-%s", $1, $3);
+	free($1);
+	free($3);
 	if (parse_events_multi_pmu_add(_parse_state, pmu_name, &list) < 0)
 		YYABORT;
 	$$ = list;
@@ -338,11 +374,16 @@ value_sym '/' event_config '/'
 	struct list_head *list;
 	int type = $1 >> 16;
 	int config = $1 & 255;
+	int err;
 
 	list = alloc_list();
 	ABORT_ON(!list);
-	ABORT_ON(parse_events_add_numeric(_parse_state, list, type, config, $3));
+	err = parse_events_add_numeric(_parse_state, list, type, config, $3);
 	parse_events_terms__delete($3);
+	if (err) {
+		free_list_evsel(list);
+		YYABORT;
+	}
 	$$ = list;
 }
 |
@@ -374,11 +415,19 @@ PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT opt_e
 	struct parse_events_state *parse_state = _parse_state;
 	struct parse_events_error *error = parse_state->error;
 	struct list_head *list;
+	int err;
 
 	list = alloc_list();
 	ABORT_ON(!list);
-	ABORT_ON(parse_events_add_cache(list, &parse_state->idx, $1, $3, $5, error, $6));
+	err = parse_events_add_cache(list, &parse_state->idx, $1, $3, $5, error, $6);
 	parse_events_terms__delete($6);
+	free($1);
+	free($3);
+	free($5);
+	if (err) {
+		free_list_evsel(list);
+		YYABORT;
+	}
 	$$ = list;
 }
 |
@@ -387,11 +436,18 @@ PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT opt_event_config
 	struct parse_events_state *parse_state = _parse_state;
 	struct parse_events_error *error = parse_state->error;
 	struct list_head *list;
+	int err;
 
 	list = alloc_list();
 	ABORT_ON(!list);
-	ABORT_ON(parse_events_add_cache(list, &parse_state->idx, $1, $3, NULL, error, $4));
+	err = parse_events_add_cache(list, &parse_state->idx, $1, $3, NULL, error, $4);
 	parse_events_terms__delete($4);
+	free($1);
+	free($3);
+	if (err) {
+		free_list_evsel(list);
+		YYABORT;
+	}
 	$$ = list;
 }
 |
@@ -400,11 +456,17 @@ PE_NAME_CACHE_TYPE opt_event_config
 	struct parse_events_state *parse_state = _parse_state;
 	struct parse_events_error *error = parse_state->error;
 	struct list_head *list;
+	int err;
 
 	list = alloc_list();
 	ABORT_ON(!list);
-	ABORT_ON(parse_events_add_cache(list, &parse_state->idx, $1, NULL, NULL, error, $2));
+	err = parse_events_add_cache(list, &parse_state->idx, $1, NULL, NULL, error, $2);
 	parse_events_terms__delete($2);
+	free($1);
+	if (err) {
+		free_list_evsel(list);
+		YYABORT;
+	}
 	$$ = list;
 }
 
@@ -413,11 +475,17 @@ PE_PREFIX_MEM PE_VALUE '/' PE_VALUE ':' PE_MODIFIER_BP sep_dc
 {
 	struct parse_events_state *parse_state = _parse_state;
 	struct list_head *list;
+	int err;
 
 	list = alloc_list();
 	ABORT_ON(!list);
-	ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
-					     (void *) $2, $6, $4));
+	err = parse_events_add_breakpoint(list, &parse_state->idx,
+					(void *) $2, $6, $4);
+	free($6);
+	if (err) {
+		free(list);
+		YYABORT;
+	}
 	$$ = list;
 }
 |
@@ -428,8 +496,11 @@ PE_PREFIX_MEM PE_VALUE '/' PE_VALUE sep_dc
 
 	list = alloc_list();
 	ABORT_ON(!list);
-	ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
-					     (void *) $2, NULL, $4));
+	if (parse_events_add_breakpoint(list, &parse_state->idx,
+						(void *) $2, NULL, $4)) {
+		free(list);
+		YYABORT;
+	}
 	$$ = list;
 }
 |
@@ -437,11 +508,17 @@ PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 {
 	struct parse_events_state *parse_state = _parse_state;
 	struct list_head *list;
+	int err;
 
 	list = alloc_list();
 	ABORT_ON(!list);
-	ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
-					     (void *) $2, $4, 0));
+	err = parse_events_add_breakpoint(list, &parse_state->idx,
+					(void *) $2, $4, 0);
+	free($4);
+	if (err) {
+		free(list);
+		YYABORT;
+	}
 	$$ = list;
 }
 |
@@ -452,8 +529,11 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 
 	list = alloc_list();
 	ABORT_ON(!list);
-	ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
-					     (void *) $2, NULL, 0));
+	if (parse_events_add_breakpoint(list, &parse_state->idx,
+						(void *) $2, NULL, 0)) {
+		free(list);
+		YYABORT;
+	}
 	$$ = list;
 }
 
@@ -463,29 +543,35 @@ tracepoint_name opt_event_config
 	struct parse_events_state *parse_state = _parse_state;
 	struct parse_events_error *error = parse_state->error;
 	struct list_head *list;
+	int err;
 
 	list = alloc_list();
 	ABORT_ON(!list);
 	if (error)
 		error->idx = @1.first_column;
 
-	if (parse_events_add_tracepoint(list, &parse_state->idx, $1.sys, $1.event,
-					error, $2))
-		return -1;
+	err = parse_events_add_tracepoint(list, &parse_state->idx, $1.sys, $1.event,
+					error, $2);
 
+	parse_events_terms__delete($2);
+	free($1.sys);
+	free($1.event);
+	if (err) {
+		free(list);
+		return -1;
+	}
 	$$ = list;
 }
 
 tracepoint_name:
 PE_NAME '-' PE_NAME ':' PE_NAME
 {
-	char sys_name[128];
 	struct tracepoint_name tracepoint;
 
-	snprintf(&sys_name, 128, "%s-%s", $1, $3);
-	tracepoint.sys = &sys_name;
+	ABORT_ON(asprintf(&tracepoint.sys, "%s-%s", $1, $3) < 0);
 	tracepoint.event = $5;
-
+	free($1);
+	free($3);
 	$$ = tracepoint;
 }
 |
@@ -500,11 +586,16 @@ event_legacy_numeric:
 PE_VALUE ':' PE_VALUE opt_event_config
 {
 	struct list_head *list;
+	int err;
 
 	list = alloc_list();
 	ABORT_ON(!list);
-	ABORT_ON(parse_events_add_numeric(_parse_state, list, (u32)$1, $3, $4));
+	err = parse_events_add_numeric(_parse_state, list, (u32)$1, $3, $4);
 	parse_events_terms__delete($4);
+	if (err) {
+		free(list);
+		YYABORT;
+	}
 	$$ = list;
 }
 
@@ -512,11 +603,16 @@ event_legacy_raw:
 PE_RAW opt_event_config
 {
 	struct list_head *list;
+	int err;
 
 	list = alloc_list();
 	ABORT_ON(!list);
-	ABORT_ON(parse_events_add_numeric(_parse_state, list, PERF_TYPE_RAW, $1, $2));
+	err = parse_events_add_numeric(_parse_state, list, PERF_TYPE_RAW, $1, $2);
 	parse_events_terms__delete($2);
+	if (err) {
+		free(list);
+		YYABORT;
+	}
 	$$ = list;
 }
 
@@ -525,22 +621,33 @@ PE_BPF_OBJECT opt_event_config
 {
 	struct parse_events_state *parse_state = _parse_state;
 	struct list_head *list;
+	int err;
 
 	list = alloc_list();
 	ABORT_ON(!list);
-	ABORT_ON(parse_events_load_bpf(parse_state, list, $1, false, $2));
+	err = parse_events_load_bpf(parse_state, list, $1, false, $2);
 	parse_events_terms__delete($2);
+	free($1);
+	if (err) {
+		free(list);
+		YYABORT;
+	}
 	$$ = list;
 }
 |
 PE_BPF_SOURCE opt_event_config
 {
 	struct list_head *list;
+	int err;
 
 	list = alloc_list();
 	ABORT_ON(!list);
-	ABORT_ON(parse_events_load_bpf(_parse_state, list, $1, true, $2));
+	err = parse_events_load_bpf(_parse_state, list, $1, true, $2);
 	parse_events_terms__delete($2);
+	if (err) {
+		free(list);
+		YYABORT;
+	}
 	$$ = list;
 }
 
@@ -573,6 +680,10 @@ opt_pmu_config:
 start_terms: event_config
 {
 	struct parse_events_state *parse_state = _parse_state;
+	if (parse_state->terms) {
+		parse_events_terms__delete ($1);
+		YYABORT;
+	}
 	parse_state->terms = $1;
 }
 
@@ -582,7 +693,10 @@ event_config ',' event_term
 	struct list_head *head = $1;
 	struct parse_events_term *term = $3;
 
-	ABORT_ON(!head);
+	if (!head) {
+		free_term(term);
+		YYABORT;
+	}
 	list_add_tail(&term->list, head);
 	$$ = $1;
 }
@@ -603,8 +717,12 @@ PE_NAME '=' PE_NAME
 {
 	struct parse_events_term *term;
 
-	ABORT_ON(parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_USER,
-					$1, $3, &@1, &@3));
+	if (parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, $3, &@1, &@3)) {
+		free($1);
+		free($3);
+		YYABORT;
+	}
 	$$ = term;
 }
 |
@@ -612,8 +730,11 @@ PE_NAME '=' PE_VALUE
 {
 	struct parse_events_term *term;
 
-	ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
-					$1, $3, false, &@1, &@3));
+	if (parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, $3, false, &@1, &@3)) {
+		free($1);
+		YYABORT;
+	}
 	$$ = term;
 }
 |
@@ -622,7 +743,10 @@ PE_NAME '=' PE_VALUE_SYM_HW
 	struct parse_events_term *term;
 	int config = $3 & 255;
 
-	ABORT_ON(parse_events_term__sym_hw(&term, $1, config));
+	if (parse_events_term__sym_hw(&term, $1, config)) {
+		free($1);
+		YYABORT;
+	}
 	$$ = term;
 }
 |
@@ -630,8 +754,11 @@ PE_NAME
 {
 	struct parse_events_term *term;
 
-	ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
-					$1, 1, true, &@1, NULL));
+	if (parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, 1, true, &@1, NULL)) {
+		free($1);
+		YYABORT;
+	}
 	$$ = term;
 }
 |
@@ -648,7 +775,10 @@ PE_TERM '=' PE_NAME
 {
 	struct parse_events_term *term;
 
-	ABORT_ON(parse_events_term__str(&term, (int)$1, NULL, $3, &@1, &@3));
+	if (parse_events_term__str(&term, (int)$1, NULL, $3, &@1, &@3)) {
+		free($3);
+		YYABORT;
+	}
 	$$ = term;
 }
 |
@@ -672,9 +802,13 @@ PE_NAME array '=' PE_NAME
 {
 	struct parse_events_term *term;
 
-	ABORT_ON(parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_USER,
-					$1, $4, &@1, &@4));
-
+	if (parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, $4, &@1, &@4)) {
+		free($1);
+		free($4);
+		free($2.ranges);
+		YYABORT;
+	}
 	term->array = $2;
 	$$ = term;
 }
@@ -683,8 +817,12 @@ PE_NAME array '=' PE_VALUE
 {
 	struct parse_events_term *term;
 
-	ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
-					$1, $4, false, &@1, &@4));
+	if (parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, $4, false, &@1, &@4)) {
+		free($1);
+		free($2.ranges);
+		YYABORT;
+	}
 	term->array = $2;
 	$$ = term;
 }
@@ -695,8 +833,12 @@ PE_DRV_CFG_TERM
 	char *config = strdup($1);
 
 	ABORT_ON(!config);
-	ABORT_ON(parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_DRV_CFG,
-					config, $1, &@1, NULL));
+	if (parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_DRV_CFG,
+					config, $1, &@1, NULL)) {
+		free($1);
+		free(config);
+		YYABORT;
+	}
 	$$ = term;
 }
 
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7351E5371
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733134AbfJYSIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:08:43 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:34686 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733051AbfJYSIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 14:08:42 -0400
Received: by mail-pl1-f201.google.com with SMTP id 70so2012160ple.1
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 11:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wRg/ZOz5Sv3KFksCXWkdb5uyUHUz1WOkPfhEj4f8E+w=;
        b=NaP5JlN+LH0ehhG8xNigtXIi0/RKYaQ/OdQ25l1kEKjwjMpNLrYAE4vbTeMgl+vctF
         SjF3r3UVOIIp1wcagQSHxE2PcrPvyxWLwyVVxuuaEksAaApROH8wefTOYfxnvBjguXN5
         f2VMG8joWQnXw9ptSJNTe98H/qmFbdqCgU6yruP+UA2xwpUhY1KhzqArXolfb0i8Hlju
         Y2TFwue+AJJAAFG5EgGeYdtOQA0GRTNk4bv3/IWI/TWCppt0beQVOjSx+4p2pTEJqliy
         +QZKy1g8h+135oeVjZl6E8AIeH090CHdIBNYHh8HW2oB1QrZwMe/3C9s7IwVddvbEXP/
         ckVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wRg/ZOz5Sv3KFksCXWkdb5uyUHUz1WOkPfhEj4f8E+w=;
        b=h6ocLlgMNj+lDDcc66Q//ewMhGstzs3JEB/aXq2mI38uJ/mN35sgeXIjY/uY5srDUb
         IxCNlpz0Z5EkF+zdNkmGUpjnrFsDAURQegO7h7iwGPgw2ARLdGCtqxQydrxaQXdGjiWU
         cfE9hwG4JOhzYLnOmmh1NiZ+mbYEOE+6/6PYLeUTcuBZh+acWwGjjKMm9W3Wuct9vtAn
         vsvElGvSkI2O90bJMrJmAtZ9pe2XHbP19fFqsAMZ/IIdCs9ifUNV/XPtVoLYd9Mx9CCk
         LIeuYv87VZv6w1yUwPjrggobIPa8+g94XLyCjsoXZmZ2SHKfm+xLF8A0E9HpltGQ3rao
         hh4w==
X-Gm-Message-State: APjAAAXTi2PNrA2ZGsYYIZMfi5OkuA1KtjWKobH0f08bnnWJfM0606rL
        eUQbbPa4Y10OY3eBBYgtWqeXu/4nDNfo
X-Google-Smtp-Source: APXvYqzzpwm+En+DCgldG9gNUzXirVolhBKFcxmvPprt+VEMKBIrFRAeTRtyjkVcIqtXCFBRM67KCoehhEvV
X-Received: by 2002:a65:609a:: with SMTP id t26mr6161474pgu.349.1572026920964;
 Fri, 25 Oct 2019 11:08:40 -0700 (PDT)
Date:   Fri, 25 Oct 2019 11:08:20 -0700
In-Reply-To: <20191025180827.191916-1-irogers@google.com>
Message-Id: <20191025180827.191916-3-irogers@google.com>
Mime-Version: 1.0
References: <20191024190202.109403-1-irogers@google.com> <20191025180827.191916-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v4 2/9] perf tools: move ALLOC_LIST into a function
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

Having a YYABORT in a macro makes it hard to free memory for components
of a rule. Separate the logic out.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/parse-events.y | 65 ++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 48126ae4cd13..5863acb34780 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -25,12 +25,17 @@ do { \
 		YYABORT; \
 } while (0)
 
-#define ALLOC_LIST(list) \
-do { \
-	list = malloc(sizeof(*list)); \
-	ABORT_ON(!list);              \
-	INIT_LIST_HEAD(list);         \
-} while (0)
+static struct list_head* alloc_list()
+{
+	struct list_head *list;
+
+	list = malloc(sizeof(*list));
+	if (!list)
+		return NULL;
+
+	INIT_LIST_HEAD(list);
+	return list;
+}
 
 static void inc_group_count(struct list_head *list,
 		       struct parse_events_state *parse_state)
@@ -238,7 +243,8 @@ PE_NAME opt_pmu_config
 	if (error)
 		error->idx = @1.first_column;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	if (parse_events_add_pmu(_parse_state, list, $1, $2, false, false)) {
 		struct perf_pmu *pmu = NULL;
 		int ok = 0;
@@ -306,7 +312,8 @@ value_sym '/' event_config '/'
 	int type = $1 >> 16;
 	int config = $1 & 255;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	ABORT_ON(parse_events_add_numeric(_parse_state, list, type, config, $3));
 	parse_events_terms__delete($3);
 	$$ = list;
@@ -318,7 +325,8 @@ value_sym sep_slash_slash_dc
 	int type = $1 >> 16;
 	int config = $1 & 255;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	ABORT_ON(parse_events_add_numeric(_parse_state, list, type, config, NULL));
 	$$ = list;
 }
@@ -327,7 +335,8 @@ PE_VALUE_SYM_TOOL sep_slash_slash_dc
 {
 	struct list_head *list;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	ABORT_ON(parse_events_add_tool(_parse_state, list, $1));
 	$$ = list;
 }
@@ -339,7 +348,8 @@ PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT opt_e
 	struct parse_events_error *error = parse_state->error;
 	struct list_head *list;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	ABORT_ON(parse_events_add_cache(list, &parse_state->idx, $1, $3, $5, error, $6));
 	parse_events_terms__delete($6);
 	$$ = list;
@@ -351,7 +361,8 @@ PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT opt_event_config
 	struct parse_events_error *error = parse_state->error;
 	struct list_head *list;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	ABORT_ON(parse_events_add_cache(list, &parse_state->idx, $1, $3, NULL, error, $4));
 	parse_events_terms__delete($4);
 	$$ = list;
@@ -363,7 +374,8 @@ PE_NAME_CACHE_TYPE opt_event_config
 	struct parse_events_error *error = parse_state->error;
 	struct list_head *list;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	ABORT_ON(parse_events_add_cache(list, &parse_state->idx, $1, NULL, NULL, error, $2));
 	parse_events_terms__delete($2);
 	$$ = list;
@@ -375,7 +387,8 @@ PE_PREFIX_MEM PE_VALUE '/' PE_VALUE ':' PE_MODIFIER_BP sep_dc
 	struct parse_events_state *parse_state = _parse_state;
 	struct list_head *list;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
 					     (void *) $2, $6, $4));
 	$$ = list;
@@ -386,7 +399,8 @@ PE_PREFIX_MEM PE_VALUE '/' PE_VALUE sep_dc
 	struct parse_events_state *parse_state = _parse_state;
 	struct list_head *list;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
 					     (void *) $2, NULL, $4));
 	$$ = list;
@@ -397,7 +411,8 @@ PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 	struct parse_events_state *parse_state = _parse_state;
 	struct list_head *list;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
 					     (void *) $2, $4, 0));
 	$$ = list;
@@ -408,7 +423,8 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 	struct parse_events_state *parse_state = _parse_state;
 	struct list_head *list;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
 					     (void *) $2, NULL, 0));
 	$$ = list;
@@ -421,7 +437,8 @@ tracepoint_name opt_event_config
 	struct parse_events_error *error = parse_state->error;
 	struct list_head *list;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	if (error)
 		error->idx = @1.first_column;
 
@@ -457,7 +474,8 @@ PE_VALUE ':' PE_VALUE opt_event_config
 {
 	struct list_head *list;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	ABORT_ON(parse_events_add_numeric(_parse_state, list, (u32)$1, $3, $4));
 	parse_events_terms__delete($4);
 	$$ = list;
@@ -468,7 +486,8 @@ PE_RAW opt_event_config
 {
 	struct list_head *list;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	ABORT_ON(parse_events_add_numeric(_parse_state, list, PERF_TYPE_RAW, $1, $2));
 	parse_events_terms__delete($2);
 	$$ = list;
@@ -480,7 +499,8 @@ PE_BPF_OBJECT opt_event_config
 	struct parse_events_state *parse_state = _parse_state;
 	struct list_head *list;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	ABORT_ON(parse_events_load_bpf(parse_state, list, $1, false, $2));
 	parse_events_terms__delete($2);
 	$$ = list;
@@ -490,7 +510,8 @@ PE_BPF_SOURCE opt_event_config
 {
 	struct list_head *list;
 
-	ALLOC_LIST(list);
+	list = alloc_list();
+	ABORT_ON(!list);
 	ABORT_ON(parse_events_load_bpf(_parse_state, list, $1, true, $2));
 	parse_events_terms__delete($2);
 	$$ = list;
-- 
2.24.0.rc0.303.g954a862665-goog


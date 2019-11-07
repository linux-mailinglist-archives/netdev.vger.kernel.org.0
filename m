Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B32BBF3817
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 20:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbfKGTID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 14:08:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbfKGTID (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 14:08:03 -0500
Received: from quaco.ghostprotocols.net (179-240-172-58.3g.claro.net.br [179.240.172.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 861B12084D;
        Thu,  7 Nov 2019 19:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573153681;
        bh=x0U+idijloZ3ABTyDoe6njQvzv2HnpI5hJKa44rEGO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BF0KSk+cd/dEuV3DFZ/8IvhwQl93OH5dbYGwHJdd2N5umhn2oj/9756C7YWyRK/sv
         IkENsjfyqBKJnoszABbOuyax4OC1NgG+TVDFwDakZMFo84P57qKEVdyZt5CMaVrPc9
         hZx7XygFlK8YjOmqI6xHN9T85hfhqL90saqX23q8=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jin Yao <yao.jin@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, netdev@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 46/63] perf parse: Add a deep delete for parse event terms
Date:   Thu,  7 Nov 2019 15:59:54 -0300
Message-Id: <20191107190011.23924-47-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107190011.23924-1-acme@kernel.org>
References: <20191107190011.23924-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ian Rogers <irogers@google.com>

Add a parse_events_term deep delete function so that owned strings and
arrays are freed.

Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: bpf@vger.kernel.org
Cc: clang-built-linux@googlegroups.com
Cc: netdev@vger.kernel.org
Link: http://lore.kernel.org/lkml/20191030223448.12930-10-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c | 16 +++++++++++++---
 tools/perf/util/parse-events.h |  1 +
 tools/perf/util/parse-events.y | 12 ++----------
 tools/perf/util/pmu.c          |  2 +-
 4 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a0a80f4e7038..6d18ff9bce49 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -2812,6 +2812,18 @@ int parse_events_term__clone(struct parse_events_term **new,
 	return new_term(new, &temp, str, 0);
 }
 
+void parse_events_term__delete(struct parse_events_term *term)
+{
+	if (term->array.nr_ranges)
+		zfree(&term->array.ranges);
+
+	if (term->type_val != PARSE_EVENTS__TERM_TYPE_NUM)
+		zfree(&term->val.str);
+
+	zfree(&term->config);
+	free(term);
+}
+
 int parse_events_copy_term_list(struct list_head *old,
 				 struct list_head **new)
 {
@@ -2842,10 +2854,8 @@ void parse_events_terms__purge(struct list_head *terms)
 	struct parse_events_term *term, *h;
 
 	list_for_each_entry_safe(term, h, terms, list) {
-		if (term->array.nr_ranges)
-			zfree(&term->array.ranges);
 		list_del_init(&term->list);
-		free(term);
+		parse_events_term__delete(term);
 	}
 }
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 34f58d24a06a..5ee8ac93840c 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -139,6 +139,7 @@ int parse_events_term__sym_hw(struct parse_events_term **term,
 			      char *config, unsigned idx);
 int parse_events_term__clone(struct parse_events_term **new,
 			     struct parse_events_term *term);
+void parse_events_term__delete(struct parse_events_term *term);
 void parse_events_terms__delete(struct list_head *terms);
 void parse_events_terms__purge(struct list_head *terms);
 void parse_events__clear_array(struct parse_events_array *a);
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 376b19855470..4cac830015be 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -49,14 +49,6 @@ static void free_list_evsel(struct list_head* list_evsel)
 	free(list_evsel);
 }
 
-static void free_term(struct parse_events_term *term)
-{
-	if (term->type_val == PARSE_EVENTS__TERM_TYPE_STR)
-		free(term->val.str);
-	zfree(&term->array.ranges);
-	free(term);
-}
-
 static void inc_group_count(struct list_head *list,
 		       struct parse_events_state *parse_state)
 {
@@ -99,7 +91,7 @@ static void inc_group_count(struct list_head *list,
 %type <str> PE_DRV_CFG_TERM
 %destructor { free ($$); } <str>
 %type <term> event_term
-%destructor { free_term ($$); } <term>
+%destructor { parse_events_term__delete ($$); } <term>
 %type <list_terms> event_config
 %type <list_terms> opt_event_config
 %type <list_terms> opt_pmu_config
@@ -694,7 +686,7 @@ event_config ',' event_term
 	struct parse_events_term *term = $3;
 
 	if (!head) {
-		free_term(term);
+		parse_events_term__delete(term);
 		YYABORT;
 	}
 	list_add_tail(&term->list, head);
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index f9f427d4c313..db1e57113f4b 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1260,7 +1260,7 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 		info->metric_name = alias->metric_name;
 
 		list_del_init(&term->list);
-		free(term);
+		parse_events_term__delete(term);
 	}
 
 	/*
-- 
2.21.0


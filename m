Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A02E3BA7
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504360AbfJXTCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:02:39 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:37856 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504337AbfJXTCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 15:02:32 -0400
Received: by mail-pl1-f202.google.com with SMTP id r13so7426769pls.4
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 12:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Vv3fl0qJdzHLXy2OjdOBT5vACl8HVGHNjtSIwYY4lOU=;
        b=vcWjo9hmVdfoOxWVNcUU5ScBonNRmQdutNRA/h1k6pySizGYv+OfDHyDtgGJDaLRHO
         zq2QJ/fNEGYNKLX9oeI9ORUzV9QmhtXvZkUddYEr9bwW6ELWPOGJDYvPPaGrYmCp+S02
         CVUOGnEZejNWPb3V2H7KfoLd4Rbg/qjBTjI3B1l/TaNoioXVG+UFQwRtXbNH9lJ0hP6V
         bRXmIJYU5b3067tRQTQQ6B+KONhiXRLegQTxZCQ4kDK7AerUVu/+AWFwohk2ll6u6+sQ
         SijOrwE1A+kZF2UUvQD4lHA8AReBSNB1Y1iBLFUPjQ0bugHH2Uku4/nYMhMVXvX0U6Al
         9Dkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Vv3fl0qJdzHLXy2OjdOBT5vACl8HVGHNjtSIwYY4lOU=;
        b=Jn+aEydkaxmue0eRkIY2u+/7NM9TSBPcQDXyQRark8yHDYuvHc9IqYNRYhugw4q4kV
         lN5YFGLfQqBBrmVW1olk2OpKWJ+ngxKDbOMAjsXyuk92naGPc6HYYMi3PpqXcxJTVNvz
         eYTpKjfmOGTj99ikHk3gOoQFb0uIV+zAz+X1DD6gHo3vvAV1jCdu+iYEFOvsTeCLj+E6
         39TrOUmBhWeyYPEvDAnBuX5n8mEkm35AQMDzTGxPSkWkKXUpmf/R7jSe6RRN3QgNi3ai
         qkh7zg7gn+AEBXlu0Rl55OqJYjb4945PgBfUZ/lRABCgPqHqBKfyvaxgjyFnWXHmedAB
         XPow==
X-Gm-Message-State: APjAAAVTRatfE4kbOpbmqgmyJPYqdZEnGHnatLHrdHSfVzmIHYOBiQq9
        CsKNuVzBrXstC0H1LOVIe6fbT3CMo45F
X-Google-Smtp-Source: APXvYqwfY7PRgsCQp0QP0GfBxvTk820ww76P1nt/VcBZLK7gwkQtbqd+NmDQ7hd+pBSZ6WSYY8eUfcBFlEAH
X-Received: by 2002:a63:69c9:: with SMTP id e192mr7080758pgc.271.1571943750903;
 Thu, 24 Oct 2019 12:02:30 -0700 (PDT)
Date:   Thu, 24 Oct 2019 12:02:02 -0700
In-Reply-To: <20191024190202.109403-1-irogers@google.com>
Message-Id: <20191024190202.109403-10-irogers@google.com>
Mime-Version: 1.0
References: <20191023005337.196160-1-irogers@google.com> <20191024190202.109403-1-irogers@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v3 9/9] perf tools: add a deep delete for parse event terms
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

Add a parse_events_term deep delete function so that owned strings and
arrays are freed.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/parse-events.c | 16 +++++++++++++---
 tools/perf/util/parse-events.h |  1 +
 tools/perf/util/parse-events.y | 12 ++----------
 tools/perf/util/pmu.c          |  2 +-
 4 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 999ea7378969..58322cb3b5df 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -2830,6 +2830,18 @@ int parse_events_term__clone(struct parse_events_term **new,
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
@@ -2860,10 +2872,8 @@ void parse_events_terms__purge(struct list_head *terms)
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
index a7d42faeab0c..d1ade97e2357 100644
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
index d1cceb3bc620..649c63809bad 100644
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
@@ -693,7 +685,7 @@ event_config ',' event_term
 	struct parse_events_term *term = $3;
 
 	if (!head) {
-		free_term(term);
+		parse_events_term__delete(term);
 		YYABORT;
 	}
 	list_add_tail(&term->list, head);
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 4015ec11944a..53af92321693 100644
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
2.23.0.866.gb869b98d4c-goog


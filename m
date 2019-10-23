Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4D9E0F76
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 02:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733222AbfJWAy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 20:54:26 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:53485 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733195AbfJWAyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 20:54:24 -0400
Received: by mail-pl1-f201.google.com with SMTP id g13so11579083plq.20
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 17:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PC42O41NBd9i4kPitdETrfG1Za58EwGfR6rcMq8N6/A=;
        b=r0rbBPq3zpHRSh0k4CXUWN+PXGWGcH8Ra0xoXnRwQ8P1bprYbq8aMicMKIu2ImqIQ7
         MDSSYQfeTaiJpLjTAUJQ2ipOGzsIVFRfx3VI0THolL1pXV6nqyOdO9WXwfSLRWnMkR70
         6y2E0N1kF6/qWjyqDEO3U3vtpDMEpsv6xlO24q7JxIIyuHPdFm13QEO0jbYPDIvMLYZx
         8FaE0eeXPISxOWkRiap7IQPhvErtd1lc1jTm/9quWMF2iFevLI5BjCvlRYsrOvI7P9Hc
         TFRxmQ7r64tZv0/Yh365ScvoWZK53o8xHze1Q5hlgbDcmgbMzAlCzWEUka8kqRLYU5tD
         49CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PC42O41NBd9i4kPitdETrfG1Za58EwGfR6rcMq8N6/A=;
        b=oE4xyga+opK9VS7U666nXgS4E1jDGJx0CUOu3MEHSEM0lY6pIeiAvLRg16jAL1LSwA
         Jt+ADQ3HU4wygdJuT2gEZQg4wmzs6jZ8AMOoP5GA3b7Z/Z4fIftz3tkpZAfZibxVZdRW
         mBcjT3I0opXkWWOVhcnVhN/eeE/JD6QFCqVw/2eDunC2O3BA0ZKSIxYmDQ6Sq3DCtotK
         Nu/uymL561tFB8IfsxxIDY7I+ZDa+YwIPTYR9Hpt28eOEeVgDUB9A++dUtkiVb/KZd0I
         LEoCSOFiF90KjHSkBdVUrgjMfPnyZvFL1po/jFvlk8bHxir0aaYLqc+Yzq/cWcdn3gE7
         piUw==
X-Gm-Message-State: APjAAAWeIaXvTDxwfMUFNOIh/8LTLfItS4IEGCoHbBrE9dSGis3kEn2P
        AYB26C3bepXPrXve/lHtlexkYfXcb/hX
X-Google-Smtp-Source: APXvYqwVBqK65JMFO/1L3DV9WrvU2qA1aac/SY8ENQ2THYATWcqtOPLUbl+6/IfMrZt9xHPeGxFd/Q765iSO
X-Received: by 2002:a63:1904:: with SMTP id z4mr6953016pgl.413.1571792062316;
 Tue, 22 Oct 2019 17:54:22 -0700 (PDT)
Date:   Tue, 22 Oct 2019 17:53:37 -0700
In-Reply-To: <20191023005337.196160-1-irogers@google.com>
Message-Id: <20191023005337.196160-10-irogers@google.com>
Mime-Version: 1.0
References: <20191017170531.171244-1-irogers@google.com> <20191023005337.196160-1-irogers@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v2 9/9] perf tools: add a deep delete for parse event terms
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
index 6bf64b3767cc..5e7bebc8fad4 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -2806,6 +2806,18 @@ int parse_events_term__clone(struct parse_events_term **new,
 		return new_term(new, &temp, strdup(term->val.str), 0);
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
@@ -2836,10 +2848,8 @@ void parse_events_terms__purge(struct list_head *terms)
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
index 0fc2a51bb953..081e55300237 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1258,7 +1258,7 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 		info->metric_name = alias->metric_name;
 
 		list_del_init(&term->list);
-		free(term);
+		parse_events_term__delete(term);
 	}
 
 	/*
-- 
2.23.0.866.gb869b98d4c-goog


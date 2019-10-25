Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D663CE535B
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387680AbfJYSJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:09:01 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:55750 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387625AbfJYSJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 14:09:00 -0400
Received: by mail-pl1-f201.google.com with SMTP id g11so1986984plm.22
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 11:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ctmZG51sv2R5UJ2kBx8tVOr4dCy1I0HKxUdPtmnT1GM=;
        b=dYyeYPevtPk/t37x9mRrMR5qzd0EiRxgbC+WOzHaBhT7OuVZOThJLLcRcDbJl+lm4E
         +g4PT7uBh8q2SXf20DR3Fp+XTWs4+/ig0w+6mA7Vsryya1nhFv/dAUNdpVrSN4QGDVtK
         4lhyzAwfouI0ZoIopv4e11GAQB5RMIaHVrh7Zph7Zik5ZHDaXnIs30Xd7GAqSv6v2zPa
         tLUY+i0YV6R8vfrkPalvVvqtnzO3DMLjn7vi0jbU4TAj0+3sGH5ZUmOeR8z7Q9iyxZR5
         a+G6rYmpJOet9Oef2p+kkO7e6XdDlIQBA8xdMwwx89yuqdVdNZxqhALFQKn8kgfoMbTM
         naKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ctmZG51sv2R5UJ2kBx8tVOr4dCy1I0HKxUdPtmnT1GM=;
        b=EMl1jqg+lfrmSoa606RDTBZNGIRsiBtvQmIXcYMbfbGlOWy/98PifDqBgeg8EZpCnB
         vEJSC4VuSjppOxs/PNqf875uOKQAhs/1UxQ8ZqM0sIVV+JcGv7O7/ixW+heuyJPaiIZy
         Vv73pyNJ5+4pK6GMIYnX/h0dZdyGb5/x4iIZUJQBgF7xsRE+OCvH4zaZ90PfcUlrW7U4
         Ax5vgN2PjzkmKz4mZaOHka+e3zrh6SOfPJ/bA28/Fnd/GLH9QsYjjC4LddrEqzKhaTuR
         TGABLfDTCf54Ybbvj6Te7jEZcRVK9WO1vKW2u0Yg4u/TWAEQIj/63UZOV6uu8S9gRpvU
         g4HA==
X-Gm-Message-State: APjAAAUavj5hvzmbub7MZ8eyvXpye+IeW0GHTU2+H4djf6HBJxfWkoCy
        qys27ATbkVTrkFi9uVV8ieSX9Dp0p8Oe
X-Google-Smtp-Source: APXvYqxKrTwQDIKiiFKmpRyDS3SgYyCMORvUXmlra460C8yXTKbzaNzYpXk2mqOgOIOxbjFf5CygsBaCr6qa
X-Received: by 2002:a63:ff54:: with SMTP id s20mr5793046pgk.398.1572026939470;
 Fri, 25 Oct 2019 11:08:59 -0700 (PDT)
Date:   Fri, 25 Oct 2019 11:08:27 -0700
In-Reply-To: <20191025180827.191916-1-irogers@google.com>
Message-Id: <20191025180827.191916-10-irogers@google.com>
Mime-Version: 1.0
References: <20191024190202.109403-1-irogers@google.com> <20191025180827.191916-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v4 9/9] perf tools: add a deep delete for parse event terms
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
index 3db1b647db38..d4347227b396 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -2814,6 +2814,18 @@ int parse_events_term__clone(struct parse_events_term **new,
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
@@ -2844,10 +2856,8 @@ void parse_events_terms__purge(struct list_head *terms)
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
index 1438749fb178..401ab359a524 100644
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
2.24.0.rc0.303.g954a862665-goog


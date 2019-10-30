Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 963BAEA65A
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfJ3Wff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:35:35 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:43516 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbfJ3WfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:35:20 -0400
Received: by mail-pf1-f201.google.com with SMTP id i187so2887761pfc.10
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=p9FVirzTzYKaiGv+x7/Rx/zUK46UD8R9gJICu3l/Lr8=;
        b=BKymhZUZ7xaDlDvS89wo1zhChJLnMb2wZLQ2xiOsUEwqPL2rfzCSAlAVtxmZ1JgIB6
         EOh4p8N4ksRVf6Kyxr9oRX+SXbxyWj8ZVsXg1lvDNn0P1DOy/bIgHvhkMkKFnphFUzVd
         UJytedKiCghegTR5QQcGRxQI4O5NXiJkmbJ21WcqnnWWyHJ4FK+oKMdMTb3S6QL+WJYg
         8Xq1Gl7jL/5AjSBKqiWVbfqoXGFa0vhnyQGHEFqWgmlTUwrCdnm3RfKYh6efGRxjtN0M
         SAUdVYCmZAKCwijkAFoyqIXnc9Ss+N0tMa/+2br8djBilJM3Pw+j6DahJbK95MaTiVL1
         D6Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=p9FVirzTzYKaiGv+x7/Rx/zUK46UD8R9gJICu3l/Lr8=;
        b=Kx9V+gNVdUQ9YNqVUw4cJ8QRnkoK02E+YrDM4MNeNgaOGmnXLCR3yls4iQlQOxyMry
         0heiIFEih6RbP05nv1vqdB1uJ4yst4EbzPFu/HuuAFV51UGUk0C82amV9OJ1SER5pdDu
         TiWiCrWvZPrEf1hB7ifzSOt59YfLHXjGmUbbWTf0ZkLHzNUI9nseD43mjsE7KWUS8Qz2
         ITYL/pMECIz+spL7Tm/sx5Ulvy3+HjL94pbPygEbSq+0ntrHI2GoicwA+xYtuGGVrEKA
         +j8qyTV2cvduh55fW6eFNmKipeZjw99/wTY51aMqqGefunVElBBHP02R2wudclWGCI/9
         hjvw==
X-Gm-Message-State: APjAAAVKoPvitcz5dB9GuykJdfbKCvNZDVBO5Qm6a2a9F6X5W/U/Sd+w
        WT8DkskGRRZXynxwGLcvjvdU54fh+pCo
X-Google-Smtp-Source: APXvYqzRsOFDWsM7cxUzRHzzOvsVAPisUEnAQL8FNzENf20i+hYWQuBS8kbaiVsNxi94sN33CUCfnQtOoEgb
X-Received: by 2002:a63:3445:: with SMTP id b66mr1958323pga.177.1572474917209;
 Wed, 30 Oct 2019 15:35:17 -0700 (PDT)
Date:   Wed, 30 Oct 2019 15:34:47 -0700
In-Reply-To: <20191030223448.12930-1-irogers@google.com>
Message-Id: <20191030223448.12930-10-irogers@google.com>
Mime-Version: 1.0
References: <20191025180827.191916-1-irogers@google.com> <20191030223448.12930-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 09/10] perf tools: add a deep delete for parse event terms
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
2.24.0.rc1.363.gb1bccd3e3d-goog


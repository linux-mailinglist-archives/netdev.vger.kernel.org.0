Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3645F3B20
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbfKGWPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:15:00 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:48824 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbfKGWO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:14:58 -0500
Received: by mail-pl1-f202.google.com with SMTP id t5so2678266plz.15
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 14:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GYsTOK8xYRxAzUxpL4TGFf0MCdaNxbX2unbIlv+2Rhk=;
        b=dDOQDYZGFPLwMGpwr2hhtnIpsHI7U4swqrRNpgAChvbsTVUGuZPenhcLJdGAIc11Du
         DVf7vUNvjhCLem50JEixRT600aTgf98lEkkLCaALXfUBeIYBf6sgHo1oSZ+2hrnRpkc6
         EMEEi/i4dirlukS8+KCZaJqiKWTBwj4TEGn+0QA/YsNAr+POQ3RUWEiIPDxO+D8C8JZf
         hY6QUp463dJe29T/Ae5hJYc2Pj1ESimAza8tUSUoDcSAs55MGI0ibtBwtCmud6t4P09V
         W1TTT1MH4ITFTBziDbFKaLQIuoq92ICWKXYtDZUVdZIcSUZ7xnxYefMSp+a81J+l9ahW
         oc0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GYsTOK8xYRxAzUxpL4TGFf0MCdaNxbX2unbIlv+2Rhk=;
        b=NSun83HbWXnI5BShLiUSYM4Ug8OqcyxMFLIlVRGfcm/bXWqxZT+DlgMJQmvOYoDK9C
         hR5Cea8De8oXrkIC2iuUTtfYDnEZIDpZCQzGPy8wkwAdm9oxWqalp5t91MsYDKCDTDnV
         i497/akJCacM/sHPevhhhSZfY3VMm+BhzQAUPmjkYpIMs6Gnfon+yYtfkeLwkvGeOZ3R
         d/ySY8g3LzO7q8/mTawzy9mv7aq90HKhsQDGkpJmpIZZAOEiVZCWtMGjoLwNQ3IoJ0Ym
         PnhUzmQA9jNrALiPMb5udkMyxTLmRbtGuP+MHxhV94xnk4RhxpLzFY9DDuJcvWYK/Svt
         QLpg==
X-Gm-Message-State: APjAAAVHIgIi3AohmXMXsPIeAQd8sB7iunXGrN4dIbFCFM+03xzIK412
        Dizka+ZS/S2R2DRuP+zIozkB6Od3jfN1
X-Google-Smtp-Source: APXvYqyHnBkfFWSvF0SsHBpO7tRDjCvzidF9DaLZPcJPFcMSsf6lwjqg8g/em4GcJRBz9bO384nwjQLs08WO
X-Received: by 2002:a63:f513:: with SMTP id w19mr7443214pgh.55.1573164897568;
 Thu, 07 Nov 2019 14:14:57 -0800 (PST)
Date:   Thu,  7 Nov 2019 14:14:24 -0800
In-Reply-To: <20191107221428.168286-1-irogers@google.com>
Message-Id: <20191107221428.168286-7-irogers@google.com>
Mime-Version: 1.0
References: <20191030223448.12930-1-irogers@google.com> <20191107221428.168286-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v6 06/10] perf tools: add destructors for parse event terms
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

If parsing fails then destructors are ran to clean the up the stack.
Rename the head union member to make the term and evlist use cases more
distinct, this simplifies matching the correct destructor.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/parse-events.y | 69 +++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 545ab7cefc20..035edfa8d42e 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -12,6 +12,7 @@
 #include <stdio.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/zalloc.h>
 #include "pmu.h"
 #include "evsel.h"
 #include "parse-events.h"
@@ -37,6 +38,25 @@ static struct list_head* alloc_list()
 	return list;
 }
 
+static void free_list_evsel(struct list_head* list_evsel)
+{
+	struct evsel *evsel, *tmp;
+
+	list_for_each_entry_safe(evsel, tmp, list_evsel, core.node) {
+		list_del_init(&evsel->core.node);
+		perf_evsel__delete(evsel);
+	}
+	free(list_evsel);
+}
+
+static void free_term(struct parse_events_term *term)
+{
+	if (term->type_val == PARSE_EVENTS__TERM_TYPE_STR)
+		free(term->val.str);
+	zfree(&term->array.ranges);
+	free(term);
+}
+
 static void inc_group_count(struct list_head *list,
 		       struct parse_events_state *parse_state)
 {
@@ -66,6 +86,7 @@ static void inc_group_count(struct list_head *list,
 %type <num> PE_VALUE_SYM_TOOL
 %type <num> PE_RAW
 %type <num> PE_TERM
+%type <num> value_sym
 %type <str> PE_NAME
 %type <str> PE_BPF_OBJECT
 %type <str> PE_BPF_SOURCE
@@ -76,37 +97,43 @@ static void inc_group_count(struct list_head *list,
 %type <str> PE_EVENT_NAME
 %type <str> PE_PMU_EVENT_PRE PE_PMU_EVENT_SUF PE_KERNEL_PMU_EVENT
 %type <str> PE_DRV_CFG_TERM
-%type <num> value_sym
-%type <head> event_config
-%type <head> opt_event_config
-%type <head> opt_pmu_config
+%destructor { free ($$); } <str>
 %type <term> event_term
-%type <head> event_pmu
-%type <head> event_legacy_symbol
-%type <head> event_legacy_cache
-%type <head> event_legacy_mem
-%type <head> event_legacy_tracepoint
+%destructor { free_term ($$); } <term>
+%type <list_terms> event_config
+%type <list_terms> opt_event_config
+%type <list_terms> opt_pmu_config
+%destructor { parse_events_terms__delete ($$); } <list_terms>
+%type <list_evsel> event_pmu
+%type <list_evsel> event_legacy_symbol
+%type <list_evsel> event_legacy_cache
+%type <list_evsel> event_legacy_mem
+%type <list_evsel> event_legacy_tracepoint
+%type <list_evsel> event_legacy_numeric
+%type <list_evsel> event_legacy_raw
+%type <list_evsel> event_bpf_file
+%type <list_evsel> event_def
+%type <list_evsel> event_mod
+%type <list_evsel> event_name
+%type <list_evsel> event
+%type <list_evsel> events
+%type <list_evsel> group_def
+%type <list_evsel> group
+%type <list_evsel> groups
+%destructor { free_list_evsel ($$); } <list_evsel>
 %type <tracepoint_name> tracepoint_name
-%type <head> event_legacy_numeric
-%type <head> event_legacy_raw
-%type <head> event_bpf_file
-%type <head> event_def
-%type <head> event_mod
-%type <head> event_name
-%type <head> event
-%type <head> events
-%type <head> group_def
-%type <head> group
-%type <head> groups
+%destructor { free ($$.sys); free ($$.event); } <tracepoint_name>
 %type <array> array
 %type <array> array_term
 %type <array> array_terms
+%destructor { free ($$.ranges); } <array>
 
 %union
 {
 	char *str;
 	u64 num;
-	struct list_head *head;
+	struct list_head *list_evsel;
+	struct list_head *list_terms;
 	struct parse_events_term *term;
 	struct tracepoint_name {
 		char *sys;
-- 
2.24.0.432.g9d3f5f5b63-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47AE0E3BAE
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504384AbfJXTCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:02:53 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:52053 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504304AbfJXTCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 15:02:24 -0400
Received: by mail-pl1-f202.google.com with SMTP id q13so7324932plr.18
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 12:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5ErD/uUW7vtCV74qLmYJVVPg+bMOBGzP+X5HkC35T58=;
        b=CgSp5bXhlUTobiRM02zmWJl/O1es6j5hx616jElbXLxD1B/jx2Kr8Rtetuhpq0IELJ
         d6CyfMksRrCJHO9l8rwsrCQVTs5T/o5z0pSly17+SuoOFAKaR34TpAtw4uSAaTYm/NfE
         uE4UUFgHPw3V9+cSTUJJ6pn6Wh2WkdbnfNHVit9yo2tyY6FZELkiS+1f13s0E3cXnkk3
         bYE0Pce24L/CUrFWL5M4tJtuuVEO7/DuF8T0K/0y0JUO5/fq5fVO26BK1gkBi1UqwlFm
         7S3FyUeoj/LGDVT46VMlxoaYsT//fiNtfwVq7w6e/CtbzmIF04pCGq+U3yXoFtpXktab
         yEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5ErD/uUW7vtCV74qLmYJVVPg+bMOBGzP+X5HkC35T58=;
        b=IPcMz0fAbwi+aMjyl+TaTkfVhtGorBwhP7g7Y9oDoG4N38dyu5p92Ihv2bPIHfpkMD
         JzmYffuLathulmwcWP7PptSsyjOaXJQFnGNKuO7pXqV/VxiONdd1hrdlFT/RhTLM7EvU
         yOYxWjxWJ5UxauqEcBlCA3WOy/8vWEsTWyQR1270wSPYq+wCeIRH9zqCErWdtvjVFSwq
         bMM1FqezxSBIELIoRFRCBTWSVy9149f6MZh/hEE6rt/szS5YS9UrNtZB78m8gpRYryvQ
         FYy7ZvRrRDN2qGHbV57bO5bYCe9Wn7X7pZrXF259kPtFrplXOWsHZXYQ2BFG7R0WBjZ+
         3Ozw==
X-Gm-Message-State: APjAAAWpfrqtOY523Sf7AhZd66DzHXnqtBYvgmULFoiq6PAodps/l3Qo
        wSVpl7B53it7Wr8hMjLXnaOoz1x+FrZN
X-Google-Smtp-Source: APXvYqyXwpQ3TOn2fiGdk7NbgwLDCWGp6oVYQFmvn282WUx13NemB5ayXRRZtlfNgRR6m60/vRmJgLC56SrG
X-Received: by 2002:a63:8f41:: with SMTP id r1mr13088716pgn.83.1571943743102;
 Thu, 24 Oct 2019 12:02:23 -0700 (PDT)
Date:   Thu, 24 Oct 2019 12:01:59 -0700
In-Reply-To: <20191024190202.109403-1-irogers@google.com>
Message-Id: <20191024190202.109403-7-irogers@google.com>
Mime-Version: 1.0
References: <20191023005337.196160-1-irogers@google.com> <20191024190202.109403-1-irogers@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v3 6/9] perf tools: add destructors for parse event terms
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
index 545ab7cefc20..4725b14b9db4 100644
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
+	struct perf_evsel *pos, *tmp;
+
+	list_for_each_entry_safe(pos, tmp, list_evsel, node) {
+		list_del_init(&pos->node);
+		perf_evsel__delete(pos);
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
2.23.0.866.gb869b98d4c-goog


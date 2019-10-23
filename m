Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118DFE0F70
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 02:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733073AbfJWAyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 20:54:17 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:41104 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732913AbfJWAyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 20:54:16 -0400
Received: by mail-pg1-f201.google.com with SMTP id s125so13833609pgc.8
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 17:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5ErD/uUW7vtCV74qLmYJVVPg+bMOBGzP+X5HkC35T58=;
        b=nz2uurdimjtldNTEoiMbb+rZ7G6+/McOYNx3KBrG80NV8yIYQCsVz+nZZ64wjXn/CD
         194GMWoqLJKDaHgh348xPChUS2ZdNA8yfMtHFsaphbhOgU4pV1O8kRsA8vpsGMErkhoj
         2xVkP5gGBwd1/Ze9WU/sHaXlFhfK655QyKXE5GeZv7YBQFoDJhksFk9YaNnvJH8vNTau
         8PWgPHVPZaaaVCYDGnLqbQ975KiKdmnWlD/AxK8gcc/miyNAn/lwWmzNUR5qxxPIyAJN
         L+P3vDMqaUUbRxx+deiXD+SVNpXMcKFY1sEkEUD5GNbDae87brG+/icY+y7PWfCtslZ4
         d66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5ErD/uUW7vtCV74qLmYJVVPg+bMOBGzP+X5HkC35T58=;
        b=iQeFwl1YsjQVcgVBCumonTfMWoTcv5MMSrnkrYhKdzrZlznRFUm8huvr2NhYkVY+Tx
         CSV6U6aPaZ9jz06giDl9vrsUyB8sM+Y8tfcwnqLPTTQxC2oCoNmAySo6cEG/uB9pK1X0
         /tU4kIG36DAixiUsogYUZzRwn3qSXva9hT5mHac4EHVzUOEvoLn83a+nTHg2miEPqHCR
         UGM3UY/mjMIxIYjnXHr3gi/oTadt3tL/d0AMcH9Vvk/R5FPaV5VAoSSQkUTMbpE4ms1V
         46EGS4PBvSeuiD44kF//GF0rhqqMHgaCLGhOSSthR+arXjOSF289YeF5abSvgiQUxpG8
         zJEw==
X-Gm-Message-State: APjAAAVn1xcw/et+nsZV+Zk1x7/4zmSP5+OqQrLVzjGJHS65lbuO50jr
        BGAhkmtBS/Gigu4np9Duo4mm7GmOT0jN
X-Google-Smtp-Source: APXvYqw68MRltqDbbSVJXBzvXcrD1zPG/SpAMuWzVbvPk288n4oOn7iZOhweSgAzWN/4RfD4Mm+Aurb8OQBb
X-Received: by 2002:a63:7c14:: with SMTP id x20mr49380pgc.208.1571792054270;
 Tue, 22 Oct 2019 17:54:14 -0700 (PDT)
Date:   Tue, 22 Oct 2019 17:53:34 -0700
In-Reply-To: <20191023005337.196160-1-irogers@google.com>
Message-Id: <20191023005337.196160-7-irogers@google.com>
Mime-Version: 1.0
References: <20191017170531.171244-1-irogers@google.com> <20191023005337.196160-1-irogers@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v2 6/9] perf tools: add destructors for parse event terms
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


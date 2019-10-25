Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6BFE5366
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387557AbfJYSI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:08:57 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:48199 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731490AbfJYSIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 14:08:54 -0400
Received: by mail-vs1-f74.google.com with SMTP id u26so410000vsq.15
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 11:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wkY00adrftjM1UcXkLzxDNdETKKPM8qAwCHI/0MFpTM=;
        b=sZPGioXJc6DRg+w32EGDOpeu0Eq45ALYUjcmxjXQdEAWz2EAhzpn4TyY72XWFaGEis
         WcnvW9TFcdN5M+VC5cJWR9ysJuEpnnmSwq0ZjXfbOkZGNpF3aok5lJk0upciYwaFzMJx
         J94nxgA0oiIBHwO07MPI8hWm8Zeh0qg+mZMFjmagRS4zr18SB/OporvS+GZv7Y8W9Vyj
         SHaIGo85kciMTMllXth5znfQyZhhdjMdTWNJ94QLWSEv+S4RC9aBfQRRO5jNrRBFhSMB
         pYxFz13rrOcUObBp5IVveTZxaGjiThp6BWBlxDajrgLN1asCpEHb4KEHpJA297Y8SY7t
         eYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wkY00adrftjM1UcXkLzxDNdETKKPM8qAwCHI/0MFpTM=;
        b=QvsHryLKuSSlTaIbXVUWcnaOs0ZIjAp0Xt5AA02ElKjdNpLFPyGn0B2kVJY/+kFqTW
         64c8Osb+LDV/rwUPoMSWbuPDkwlm+9GYMF+xcFi3B33f0xalOgJnYWbxJMQD1OGHZ3hp
         qrXqDIBQzuulwc0miIPNr9ZZEfIhEtmblYiDj3IMVQxIm1XM4AGqPHqGaXkSm189kGhc
         wNGQZSNfHtJPzilUuiaeKozLRtcmiNVjowYcY9YtimWojKr/2t6b2YsZhclPC50NmSzq
         8wYDTRzasjEAYdvts675OQnncPZ+VMlsNCUrFOvOMGXNkN/XkOXU8hXDENQjuwlWk5CW
         YVVw==
X-Gm-Message-State: APjAAAXYmtv9MTMfi1nSMtWveiallAZErxJr6pu1MXT21qGzyoNzT3p5
        cDvg7zYP6pw2iWYdaDnQP7/3ubZcskJX
X-Google-Smtp-Source: APXvYqxki5e4SVi1lYerk0ewLOY/dU/mRpWxHrNNM2SMynEXVLejaGqb7tpFktcSeG0+XJohtbl/Qxb4Yvys
X-Received: by 2002:ab0:2a12:: with SMTP id o18mr1728999uar.60.1572026931812;
 Fri, 25 Oct 2019 11:08:51 -0700 (PDT)
Date:   Fri, 25 Oct 2019 11:08:24 -0700
In-Reply-To: <20191025180827.191916-1-irogers@google.com>
Message-Id: <20191025180827.191916-7-irogers@google.com>
Mime-Version: 1.0
References: <20191024190202.109403-1-irogers@google.com> <20191025180827.191916-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v4 6/9] perf tools: add destructors for parse event terms
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
2.24.0.rc0.303.g954a862665-goog


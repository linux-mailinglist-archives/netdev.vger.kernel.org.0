Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8FE0F3B1C
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfKGWOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:14:54 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:47927 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbfKGWOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:14:53 -0500
Received: by mail-pl1-f201.google.com with SMTP id v2so2675593plp.14
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 14:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=o8eDtK4XLT1yB0wxfi9aIxQpXeS3/ycmioxd58yIuN4=;
        b=mKKIHHcPsVgAONMoZXSGtLwt9SP+tD9wXU5Rr4ErMd4qk25xxGHIDhu0/Qj6blDSXu
         vw8yk435k0zSoO7r85MUWnIiDGrJKFGdKDK82Jw7m6NySbCo1Vauj2i4miFVTQu63CO2
         lA2NNfwcoNrNMgMCR2EJDl6GnmqjppeRJr8OGLkbz4E3cUhsSmX7F6VsUKv6g416lBld
         ejPPz9FG0oGRPSlxptOA762PUJY1ysICvSgHASLoYEhjd4BKZ04jbyyLmhEgBxGvpZsR
         VTQmYTQpApuWnvWKLmyzGmGQ6t5rq1PWRG9ioiWslfV5INFn/whzTGswzoaPdX9PRlzp
         1VWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=o8eDtK4XLT1yB0wxfi9aIxQpXeS3/ycmioxd58yIuN4=;
        b=pWl8R0+E3Oz+1SmuMzcpB4BWnJAhOGviCKd6zBhZD9IKW/F+6FZl6CPOdL36wWp9jN
         W2WS2lRnD3u4KWpz3BVSEcIjJ1IOzDlOe5E2LAyspCk7v+bpPh82by1vyn0pltGRtbaw
         hU40B40OW5Bf6w9NArWS3cFbocY+NUiz5MVqHq4UeUcSxMFItiiHODUqgm64vBbvXAeu
         sHBD7ozl9uz736ctslr0himRalnYUhCgFzDUHKA2cBa9PSHI1to0H+/yw9+yeorkqV6z
         fnUcsPKY85rvLYWWmb9v5uncwUrvgyCA/wrA+s5tu2RnmFkB1NPv/7/GhMJ8OwMtxBGB
         kT8A==
X-Gm-Message-State: APjAAAXzaaz8gNYTiHD5HOoo6lKQAufxOhbhenFr205CnHQNGsqvqu7r
        ZDtmNOoAnNZKSQNp8ybBhL2XStnWPGj1
X-Google-Smtp-Source: APXvYqwJ8VuG9hRWejetPkhG8pMOZtZDUOZmAuU7dpgY1u7aUXH4GS+ccoeO9Va6IB9QTmImhuarKgMRCuzR
X-Received: by 2002:a63:2b84:: with SMTP id r126mr7381052pgr.77.1573164892310;
 Thu, 07 Nov 2019 14:14:52 -0800 (PST)
Date:   Thu,  7 Nov 2019 14:14:22 -0800
In-Reply-To: <20191107221428.168286-1-irogers@google.com>
Message-Id: <20191107221428.168286-5-irogers@google.com>
Mime-Version: 1.0
References: <20191030223448.12930-1-irogers@google.com> <20191107221428.168286-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v6 04/10] perf tools: splice events onto evlist even on error
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

If event parsing fails the event list is leaked, instead splice the list
onto the out result and let the caller cleanup.

An example input for parse_events found by libFuzzer that reproduces
this memory leak is 'm{'.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/parse-events.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index e9b958d6c534..03e54a2d8685 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1950,15 +1950,20 @@ int parse_events(struct evlist *evlist, const char *str,
 
 	ret = parse_events__scanner(str, &parse_state, PE_START_EVENTS);
 	perf_pmu__parse_cleanup();
+
+	if (!ret && list_empty(&parse_state.list)) {
+		WARN_ONCE(true, "WARNING: event parser found nothing\n");
+		return -1;
+	}
+
+	/*
+	 * Add list to the evlist even with errors to allow callers to clean up.
+	 */
+	perf_evlist__splice_list_tail(evlist, &parse_state.list);
+
 	if (!ret) {
 		struct evsel *last;
 
-		if (list_empty(&parse_state.list)) {
-			WARN_ONCE(true, "WARNING: event parser found nothing\n");
-			return -1;
-		}
-
-		perf_evlist__splice_list_tail(evlist, &parse_state.list);
 		evlist->nr_groups += parse_state.nr_groups;
 		last = evlist__last(evlist);
 		last->cmdline_group_boundary = true;
-- 
2.24.0.432.g9d3f5f5b63-goog


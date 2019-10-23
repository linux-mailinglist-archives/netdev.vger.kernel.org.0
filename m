Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD38E0F66
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 02:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732358AbfJWAyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 20:54:05 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:56992 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732334AbfJWAyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 20:54:04 -0400
Received: by mail-pg1-f201.google.com with SMTP id u4so13800557pgp.23
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 17:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=orKMDyFq0pxDsmp0+soEOe34Z3iGwylS1aF6XcYLmDY=;
        b=dxp56W5QwoEHYr+VvlnDojJFQ2s5Jr00cBo2UlZtUhbLztqDX+v6+mFLiFTmFce6QW
         upwIV8Rb7h9vSzOV5rCKmO/VSgT7BjrhF61lxGDW61AFZDGWzaayL/+597j709GkCi0K
         5rt3aQ2QeeayYfKJQ3lcb0LVh0i6yEutFUwWaWPtq+YPMOwqkW0jf9D83dbFi9F99gdS
         KnF088Q2o6Af0a44MJQKk7o6My2hjCNyEk+VeoK2UfTTar3KkzLwaIUqUh/ZwrY3FsVW
         gMFBtHZ/psrnbjZJJYDvno+NZqro2sxpRd6v2a0VIJ/42OdJaudV25DhgeWP532RlMy7
         ycbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=orKMDyFq0pxDsmp0+soEOe34Z3iGwylS1aF6XcYLmDY=;
        b=O2Cgqpy4X1iXZ0Y+ULi00teaTFmVKJqgaqO0KeC4s91IdAbvVcmbOftdfWgwR3Q2wj
         0KRhtpaWvGlgyn+87L/f5bDGt807ynziNELP/e+nMaXmO5TQl+Q9YpjD66VRaoI70DUY
         aC2939AsqS8r5vLMO+Olz2Ja7HOKEhhwnppRld1gKViEGjBO8nhjmEODlHXD/YpbrWGd
         hjw9SVKJjYuVtsQ+M4RuqOng+zqW8yUACbTV5QLaEKVsLkhhkUhH/8Fd9bYwehcdThJd
         EydJYW2v/3Omr+Y7ofUstrzaxxvbc+PnxKa8lddctwsiHhUG1D9ch4D7D0DGlFVhni6P
         QtVw==
X-Gm-Message-State: APjAAAWmlKQ4Xn9MY7xK+tSVjLHBPJL6dM1W/ZvKwcKXvgnzMGGgJUK0
        5sFLX1oGB5jAUKYXPHLIZKvAP+vkaczy
X-Google-Smtp-Source: APXvYqzyVIwLoq+9wyp9C7zURVMoBQyLpOCJQ6F7p/ccsS8pjZFa43S0nRwH0x7KWI+lYdhQ17E8tgEaTCrC
X-Received: by 2002:a63:1904:: with SMTP id z4mr6951997pgl.413.1571792043458;
 Tue, 22 Oct 2019 17:54:03 -0700 (PDT)
Date:   Tue, 22 Oct 2019 17:53:30 -0700
In-Reply-To: <20191023005337.196160-1-irogers@google.com>
Message-Id: <20191023005337.196160-3-irogers@google.com>
Mime-Version: 1.0
References: <20191017170531.171244-1-irogers@google.com> <20191023005337.196160-1-irogers@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v2 2/9] perf tools: splice events onto evlist even on error
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

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/parse-events.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4d42344698b8..a8f8801bd127 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1962,15 +1962,20 @@ int parse_events(struct evlist *evlist, const char *str,
 
 	ret = parse_events__scanner(str, &parse_state, PE_START_EVENTS);
 	perf_pmu__parse_cleanup();
+
+	if (list_empty(&parse_state.list)) {
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
2.23.0.866.gb869b98d4c-goog


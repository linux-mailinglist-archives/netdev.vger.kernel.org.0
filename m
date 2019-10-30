Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 662B3EA65E
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfJ3Wfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:35:46 -0400
Received: from mail-yw1-f73.google.com ([209.85.161.73]:46762 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbfJ3WfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:35:06 -0400
Received: by mail-yw1-f73.google.com with SMTP id c72so2848402ywb.13
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O46qQh0NfSafqZOQ3RB2bA5TlgUNmGeU07O7S2mDmp8=;
        b=CrSETiRqHMQOjdJ2lCCBT1pvusZ8sr35GXcohgUIb9pSfaqD9joqRIt248vJFuJbRn
         Vo/8A89RlQMQyyw7p0itwye5sPZNGqaR6KYv2mrmxYxgyzU5CzhJyaJEv5Z9hCpQXEM5
         pU4tszddJsg2nDsmH9PEDvoJYMaMWgm8UPpKIornmNUdfmMNvW7eR8KzZM1jPlI3nnSz
         yhTxFqGUhGL5nyUgJwuEdiShi101PN6is0peh5f5Ms+MLom82m8fBaJPrR+FW3gnhEF0
         z0ik5ClTfj81uwC34dQf42MrKwhBjUvsgJbS/OYcBWgpdn80siccizLp/y9mTyEsRamc
         ZSKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O46qQh0NfSafqZOQ3RB2bA5TlgUNmGeU07O7S2mDmp8=;
        b=I1SgZHmrZM7yirgSVjicH+jIOiJBOj5LXkzww86emIPodUmZFuyUU5YDNTlMNQ/KDU
         Uzo4KCuAGAKyHsa7u1TIO/7IJgef0h8Q2azLgn6TlQKLN/VZfQqVANGSM+PVUyPu+PGX
         /Rzk0HciugJTNdangihMnor9AcpX5ijFvgNUmSFUz34qKT80rl6R8nqdIROlH6MI5JhM
         XN8bWYu8I9ZVp/HMg0poMCXv70d/OcUqXNZUhbtCLWtY/Uz9sXh1nwN72spuT74R0nh0
         gJqLTVM9KQUw91Ile6eriyp2k35iEb6tKmw50eXx5e7VXP3K2tsSP440Y6h2TOarZQrU
         77eA==
X-Gm-Message-State: APjAAAWX5LSUwqk5wxwQrCxKN6A8UY0v0rekI+BTZSmwzxPtgpxKLFDD
        ud1p0C65YkWdmefi19zPDqZlfaBKVi8U
X-Google-Smtp-Source: APXvYqzX3t2nUPQZVTOUg6iHaQA+sKWtzQICOwxNqxdMb2uq625C2MYcu4zfy22ADO3aYpTWbjATa7LM2Bla
X-Received: by 2002:a81:4948:: with SMTP id w69mr1570034ywa.404.1572474903817;
 Wed, 30 Oct 2019 15:35:03 -0700 (PDT)
Date:   Wed, 30 Oct 2019 15:34:42 -0700
In-Reply-To: <20191030223448.12930-1-irogers@google.com>
Message-Id: <20191030223448.12930-5-irogers@google.com>
Mime-Version: 1.0
References: <20191025180827.191916-1-irogers@google.com> <20191030223448.12930-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 04/10] perf tools: splice events onto evlist even on error
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
2.24.0.rc1.363.gb1bccd3e3d-goog


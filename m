Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FEB1D467B
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 08:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgEOG5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 02:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726863AbgEOG4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 02:56:43 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0564DC05BD0A
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 23:56:43 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id d19so1226156qkj.21
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 23:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HRcsgixZKIGHXE809MZwKkXe7/yWNFRQw3Pqfn6iPQ4=;
        b=j0EVcEkUBLjPQgdo3WSyM3qJ84Z+fbTZaJe/5D+JTuRP4nQM87i/fzxocDWW33TKP0
         KWVRqqAGrHS/zckUbOO9aOYW+AaTF0WycfWPgIQKnZu7I0pMHT3WB9nv/r7FCKd43QtM
         /lbxGNGZCFS8wXUCTC6hR9ecRXJvX65b67ftpeDTLYb9RtQCN0azwYHUXxOAIWjXlDqT
         EWrj9dO3op7IaLqNKerRK5f3alhUP6wi/TiEgXjMbeRw+ipFRXzYJrZhgZOEjbz0BlQy
         YcgLhsTOSNZ3P0u0hFLaYgsgbRoQF/ejZU30j5+INhQHqe4p+07dP/KWEpDVvRk5ABj4
         UyYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HRcsgixZKIGHXE809MZwKkXe7/yWNFRQw3Pqfn6iPQ4=;
        b=kAPNInljD6vuznlzCQ63Vd00er9st0y6RSD60optLGlsM7naHyVDE/bAXItCxgvLho
         /h6kKuOgY7RgiSRECp0GXVLRwMlDMdTcxAvcHzSXCflTUDtoaZYu7OfSLTAh7xYaagKZ
         9rH9OPDc5a4gJ8j/ia2pZzELk9RsMPJEe4PfWkOaage9xyRmz7At/XH3sGwdqxEN6Rq1
         Towzq5iygvWikmWK4qxSBTz9j1WzpW7SOrYlgi7GpaVbXfOiTIOAYWN6Y4EqXfMIwPYM
         j0d0TS+zlgUPBJ1R8hTrHmnlWhIWKHmMoOQEf+p1v2Obhg27cLDOnp7jZMkEmYfUA3Lh
         sYNw==
X-Gm-Message-State: AOAM530+9K62efceokgl6VAHpezf742unpFha5pErTtNMlVEDxqu9+vZ
        OhNZHYaJptEAZtkB6EnufVNceA/zFxDa
X-Google-Smtp-Source: ABdhPJwSFLjEFtRA2Y0gUBr1G22pIPriwKT5ufbbnoybsN93DW5fiomOe6xfzfWE6tcnEJeXnwfNiLMlj5N8
X-Received: by 2002:ad4:5903:: with SMTP id ez3mr2102437qvb.105.1589525802128;
 Thu, 14 May 2020 23:56:42 -0700 (PDT)
Date:   Thu, 14 May 2020 23:56:22 -0700
In-Reply-To: <20200515065624.21658-1-irogers@google.com>
Message-Id: <20200515065624.21658-7-irogers@google.com>
Mime-Version: 1.0
References: <20200515065624.21658-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 6/8] perf test: Provide a subtest callback to ask for the
 reason for skipping a subtest
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
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>, Paul Clarke <pc@us.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now subtests can inform why a test was skipped. The upcoming patch
improvint PMU event metric testing will use it.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Clarke <pc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20200513212933.41273-1-irogers@google.com
[ split from a larger patch ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/builtin-test.c | 11 +++++++++--
 tools/perf/tests/tests.h        |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 3471ec52ea11..baee735e6aa5 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -429,8 +429,15 @@ static int test_and_print(struct test *t, bool force_skip, int subtest)
 	case TEST_OK:
 		pr_info(" Ok\n");
 		break;
-	case TEST_SKIP:
-		color_fprintf(stderr, PERF_COLOR_YELLOW, " Skip\n");
+	case TEST_SKIP: {
+		const char *skip_reason = NULL;
+		if (t->subtest.skip_reason)
+			skip_reason = t->subtest.skip_reason(subtest);
+		if (skip_reason)
+			color_fprintf(stderr, PERF_COLOR_YELLOW, " Skip (%s)\n", skip_reason);
+		else
+			color_fprintf(stderr, PERF_COLOR_YELLOW, " Skip\n");
+	}
 		break;
 	case TEST_FAIL:
 	default:
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index d6d4ac34eeb7..88e45aeab94f 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -34,6 +34,7 @@ struct test {
 		bool skip_if_fail;
 		int (*get_nr)(void);
 		const char *(*get_desc)(int subtest);
+		const char *(*skip_reason)(int subtest);
 	} subtest;
 	bool (*is_supported)(void);
 	void *priv;
-- 
2.26.2.761.g0e0b3e54be-goog


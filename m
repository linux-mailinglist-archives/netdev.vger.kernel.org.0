Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889EC1D5698
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgEOQuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726663AbgEOQuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 12:50:24 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C825C05BD0A
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 09:50:22 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id h15so3220681qvk.0
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 09:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HRcsgixZKIGHXE809MZwKkXe7/yWNFRQw3Pqfn6iPQ4=;
        b=Ty9ss6ZF+Dkg8BzgAfgIZxpJLKi/+7c1ULD69kwV8E8EzgDH4EswWfAA+fgnXMwCrA
         eyqL2F2Zgvu0ZzQ0OHiLdtwnya1oLp2+h700/6dAhHL0g7eT474c754k1iEv3gNRr3wU
         5GvMzg5ACPAkm5+Hg1AUq6s3T8cu9nprggCKzr9cBV3MqhT6IP1l6pKLdlLw60PF9h7P
         YgPZLPCCLaPY0TJhIyyo3MzXoKjGgf1OmmcjF7ubhdw5xNFFaYW7szurgXJSZsnA0Xmn
         XeYp3DI75axN+Bl7dnGgyF5ZzuYoEcFQGBs6ILM1iv3dAAfmnjeEs+Wxv3joxghkTL/0
         3W6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HRcsgixZKIGHXE809MZwKkXe7/yWNFRQw3Pqfn6iPQ4=;
        b=CBAesjx2M4rQMS48V0hGUm1SFL5GxoNVhf7ufD9r1svHMo46a/c4gHSYjKc8TrUKTt
         Wj7UC14CpuCi/dR9mIZFKuxKA4OA4CP0xmvVAkjXXepUVTYhNOp1PmKwSJXyPocJJipG
         vGG0jdeuBFud9Dnim829iHrBMI224cYiWTxBp5qkWjsksTsJUU0tZnyXWHxKLxDhvhGg
         pPPY3CoDp50/FAHpymGIWnECgrlBFaVwUSZwqm2chZF/HbUZTqJCHypSgnAB54TV4jk/
         jgXLatw40/aqUXJhCVhOvdTSfmSMuj3jjYQrn8RP47FUYBt81Je860CJNjo6R4zZZ8+0
         v86Q==
X-Gm-Message-State: AOAM533Guv2Cvphf7n5I5CH82ysJ6Aqr3fKdTdjrcSJfnHh+riKFKK9j
        yvY58ig+U7/pRhIpj4OMo7joDssItpB1
X-Google-Smtp-Source: ABdhPJzdkZmiAD7+WG9HYDPYJtwE9sP5O4jfN3LNO0DqKa5LmIg6bGj172k+mPgkkH80yUyWNr6lczkXSpaW
X-Received: by 2002:a0c:f407:: with SMTP id h7mr4274894qvl.116.1589561421592;
 Fri, 15 May 2020 09:50:21 -0700 (PDT)
Date:   Fri, 15 May 2020 09:50:05 -0700
In-Reply-To: <20200515165007.217120-1-irogers@google.com>
Message-Id: <20200515165007.217120-6-irogers@google.com>
Mime-Version: 1.0
References: <20200515165007.217120-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH v2 5/7] perf test: Provide a subtest callback to ask for the
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


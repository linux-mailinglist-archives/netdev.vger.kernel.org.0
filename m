Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A58C1D5C3D
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgEOWSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgEOWRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 18:17:48 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B430C05BD0A
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 15:17:48 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id q4so4083937qve.19
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 15:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HRcsgixZKIGHXE809MZwKkXe7/yWNFRQw3Pqfn6iPQ4=;
        b=rrfoKJQ6uEbNM5QNyXWM5Tafq0oFhV0It35ydDtbQPivuXG2yFkKJc6zSoeAzeseBo
         cHWPQ3AhzwULnPMY+tmC/auw950PDXqItWbcSI5an1uWDXP+aWogJ4vio0giVLPizuRT
         /3l5KcgSrsAlSJ8bcHdjp77uVJp0NMq+0rQys1Wsdgrf4YFEYLrGDCL8aWJLAYwLkolT
         VYoZUA2NJssZpk+hWLIy3NZaKibqmsrceocYy72OB5aw9db3fZ7HOYDB2BhXSRP19LrU
         Nu9bBLmasQRkNViuCvlfWwuCyzsK8jLtlWHCeDSq+5mQgVuximLTnndg0xfFU71vAFiA
         wn0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HRcsgixZKIGHXE809MZwKkXe7/yWNFRQw3Pqfn6iPQ4=;
        b=MrU3L+1u79gLN6PH5mGG2+My6n6a6t9lA/g9eUbhQQuHbbB4iqafCekAj/cIDb+zMV
         6HAB0h1OOtxPUGyr14LPZIXQY7TTvmWctCDi6Rup2s0I6JxgZLBTF3WMvy0aFo80jRC7
         gPIOPPsjS9HaBozLlDUy4txN0AIFJ3PwZ6tUWLLrTKcSz/gckS6ze92dZDM/KREs/vO2
         C6MWfsiiwps9xKSe6yHLBGwcbHHp6pUrKusy+DPaqNJGrTJ/naDh+/35ksSnvT4ODc82
         yTAEvxcP1LMhML0UYVuyOamzhd7hK4njAiwUy40EKr9uldIN061R9Q2KAGfIXOjDb8O5
         lm6A==
X-Gm-Message-State: AOAM531Ofhp+L9dF/k+466VmRyAJDdaXHIBzzvTX25tgOlVA/WDMjzIM
        LnnnTmCjqQSCewhMfIR/tnyYNS9HrTl1
X-Google-Smtp-Source: ABdhPJyoHkule5YldEKk5Xf0cZyLw1nWJ+TgirnVpw8RyE2ULnRL+yfx9jagb0wVOKxXIt808HBDjF1N8fx3
X-Received: by 2002:a0c:b60c:: with SMTP id f12mr5663702qve.244.1589581067194;
 Fri, 15 May 2020 15:17:47 -0700 (PDT)
Date:   Fri, 15 May 2020 15:17:30 -0700
In-Reply-To: <20200515221732.44078-1-irogers@google.com>
Message-Id: <20200515221732.44078-6-irogers@google.com>
Mime-Version: 1.0
References: <20200515221732.44078-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH v3 5/7] perf test: Provide a subtest callback to ask for the
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


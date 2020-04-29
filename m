Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A411BEC89
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 01:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgD2XPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 19:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbgD2XO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 19:14:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0717C09B041
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 16:14:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l187so5529053ybf.17
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 16:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8gY6v9J8FfbbwZkEG4Nn5uBCpCuSVyf2CJPw0f8f/F4=;
        b=j53Z5TngwbNIBG7fz7dPedULnCpGEsFxHx7XikbU76ZSEueRgzAojZFFZqDeAmBC+8
         DcJH61iPiVLyE1B0LNBnISwQCeqTEkqcqF0ifSQ6wGDvqsR3n/V+zLGxvF/C3I1FVFi8
         WmNP31WrIltq5N9Dc5ax2y2w1tPwfKJBJm1WaQm7pA7nH61PkBGy5HhwBzeWA4kuZUS6
         x1T01Dkt6V26Zq1y+H/NDdU9xI+EpiRsES6lOXasnUkTdtMmb343HWR0t6ugfxQi6vaW
         ihO5uqR22J3cNn/lV0jTqAooYf7Rz7PN44C9nNc/M2wORlDoA0WDrRe65SAdGECFAlGi
         fMog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8gY6v9J8FfbbwZkEG4Nn5uBCpCuSVyf2CJPw0f8f/F4=;
        b=sqkhitXlDoRXUKlUlXZAtDAN52+S+dRWmQNm5wVapGE6Brluc7mDQk4NaBqplEsQ+8
         FCoCiZqrVrarxiFh+RCoMrMEAmBH96qt/BxY2QFigyxabnO+kegXdxspwxrTMoh8Prx5
         n7R+w7lE6fdN2tUKGq5hKZT8XXQlTvCbN8N6KaGQZe91bj1QHdhCYbjnf52KWl0xxe0d
         BwIzpnewnQVF4sLyfR8uGGxHXF+H9pfkct4pmRqAQW0xfWLDZS+fVN8yut8Tmi2eBnwh
         na0ZaC8Qow1QUf521mrc0SDJUKNBQ6TvQ6L4bFpOq9SWmTHU65qmqZgqSFwYFxl5LZKu
         Qvsw==
X-Gm-Message-State: AGi0Puacl4xXvzGAr/ySVyg62lO4QG4g4TfJ2pAwTzRXafUIiXuU6uG7
        n7fCgachgibk0fWb/tol9M2xmVILL1HY
X-Google-Smtp-Source: APiQypLWn5UzCICVrx/KvH2GTIhnZrDmbo/WAmtqo8hNyPqvYDquWDMHiJie4pxY1ZcqEleo72Sf+YzyysFR
X-Received: by 2002:a25:d14c:: with SMTP id i73mr1231247ybg.116.1588202093016;
 Wed, 29 Apr 2020 16:14:53 -0700 (PDT)
Date:   Wed, 29 Apr 2020 16:14:42 -0700
In-Reply-To: <20200429231443.207201-1-irogers@google.com>
Message-Id: <20200429231443.207201-4-irogers@google.com>
Mime-Version: 1.0
References: <20200429231443.207201-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH v12 3/4] perf pmu: add perf_pmu__find_by_type helper
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
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This is used by libpfm4 during event parsing to locate the pmu for an
event.

Signed-off-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/pmu.c | 11 +++++++++++
 tools/perf/util/pmu.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index d9f89ed18dea..0fb7d438d9ad 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -871,6 +871,17 @@ static struct perf_pmu *pmu_find(const char *name)
 	return NULL;
 }
 
+struct perf_pmu *perf_pmu__find_by_type(unsigned int type)
+{
+	struct perf_pmu *pmu;
+
+	list_for_each_entry(pmu, &pmus, list)
+		if (pmu->type == type)
+			return pmu;
+
+	return NULL;
+}
+
 struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu)
 {
 	/*
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 1edd214b75a5..cb6fbec50313 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -72,6 +72,7 @@ struct perf_pmu_alias {
 };
 
 struct perf_pmu *perf_pmu__find(const char *name);
+struct perf_pmu *perf_pmu__find_by_type(unsigned int type);
 int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms,
 		     struct parse_events_error *error);
-- 
2.26.2.303.gf8c07b1a785-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1E11A88BD
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503529AbgDNSL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503483AbgDNSLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:11:09 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8258C0610D5
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:11:07 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id v11so607598qvw.5
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zcExPUIjugAT8xV6VI04RQsiRvISnNIvuUHEvy30OPQ=;
        b=ZBJvjQZ7S0H7g7dGFOCFUEHvsaRcW9EiWMXBZ2djyZfTOihoQcg+OCkWR5O9DVKrLP
         7NOBkGjPs2OgzNHER/gXrnr2mU4MSkH0UZfjq+EKsykmrHo87H4VRLNAq//Ige5b8zuv
         RRBArhBoOTQRZykqIvq2ECJKsEIF/s2vK3hU+oDK+tncfAH1007l9mOg5gHlCVr6Kt9o
         2+ixDpZydTNpJ/uvIFmw6ETeWO9KZC0w7gaQIPYg8pcRcLesNw/MCqpOtcaIqGZvDEyI
         t293S67vHrq58vdb41c2eN1Y9/BQ4rv6cKFzNSQJMRv/exAN0bbLJTWDM4hL6ku7n6fc
         qJUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zcExPUIjugAT8xV6VI04RQsiRvISnNIvuUHEvy30OPQ=;
        b=E5I0ixyKBBcV1MGL3znfHjXsERUoU55P7eLrJk27+XGpOW7nKuiTmVT+jH/f452Ijs
         NX2Lb9CN6XuOMO/0a9sBY++np/GI+7InfEoH5OCDdZs7qCd5h8RS5fqHFSPlVh/4Elp0
         4xsWA2jx7E87yp+Vz6erbzVtJzs5FmRKydTonnoyOPHpt8OJJWWhZ6X10dM4NN8ZkmEb
         VuWWvm3f/FocL3ErZ6C/t1Q6hNZnHspgytDITyhYrmI3weXNB/LPdC2t16Xq83ACO+wj
         P+zzGFm+vA6poB8DMhFc1/dk+O1rZvXqbKmVaB0Dy/6Qo0Fa67UK3epf9/OEuRhirefF
         WnIQ==
X-Gm-Message-State: AGi0PubdbPu+RfoSDaxGmAH3OOACGOtX8+pEtqVylgJndQTQL4VGZG9E
        AmTMXzyBgp6IKJPDG4cCueYkgs1Mqq3i
X-Google-Smtp-Source: APiQypL7lljiWPR9gDt9kyZti8EWxbZqDY0GWqpVMgq3xEKyNJazIUclxhN3genl9KEXl5Vgs1UG+EYue0iV
X-Received: by 2002:a0c:fd8c:: with SMTP id p12mr1256220qvr.163.1586887866597;
 Tue, 14 Apr 2020 11:11:06 -0700 (PDT)
Date:   Tue, 14 Apr 2020 11:10:53 -0700
In-Reply-To: <20200414181054.22435-1-irogers@google.com>
Message-Id: <20200414181054.22435-4-irogers@google.com>
Mime-Version: 1.0
References: <20200414181054.22435-1-irogers@google.com>
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH v9 3/4] perf pmu: add perf_pmu__find_by_type helper
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
index ef6a63f3d386..5e918ca740c6 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -869,6 +869,17 @@ static struct perf_pmu *pmu_find(const char *name)
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
index 5fb3f16828df..de3b868d912c 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -65,6 +65,7 @@ struct perf_pmu_alias {
 };
 
 struct perf_pmu *perf_pmu__find(const char *name);
+struct perf_pmu *perf_pmu__find_by_type(unsigned int type);
 int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms,
 		     struct parse_events_error *error);
-- 
2.26.0.110.g2183baf09c-goog


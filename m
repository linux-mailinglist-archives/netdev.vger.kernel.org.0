Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A361C847E
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 10:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgEGIPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 04:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727093AbgEGIO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 04:14:59 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FB5C03C1A8
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 01:14:58 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id z8so5795433qtu.17
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 01:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=37IhcnJ8/vjmrEBEbWQ5EKKAlYXyNL6TpEjB8zoBU+I=;
        b=NBD8jR8Z4jCqufCDci5gSr0lwIjSz+GUfkc0vsxzwut7aRab5J7mNCxjsLZQ6yKYfc
         HHnwGhftKE4MPP+AbDy+KaEZeGzptD/T1FYOC7gDAuKMplFBhoGv2jN4Re5qTEebjfUT
         bnsHBrE7McUl9bl2HtqJc9jjBJniEKl+lUJqSY+MwNbF7uW5Eant9SvWS783nM7COBBb
         KjlYpbL3pan5IedueHdBoLhiIqnQHiLM/zf9Bxy6wacUCeqtVBR4C71Kt5N6MYqYejEu
         sdCyVaCPupL8mJyfbOvSYAVHl0JwWw6DxhNAOsL+UdSjXOqi351ZGKdQXBGom3Ta/qxi
         OtxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=37IhcnJ8/vjmrEBEbWQ5EKKAlYXyNL6TpEjB8zoBU+I=;
        b=UOTGpRxBnOZTZoRJiXiiqtv0W/iA6k83qeAHed7J7qPkUXUR00Z+dtxEHgScsmuPrO
         vedfe0APcAYBssUdNOHWAKmv2x0bvc+gUytH13eloedc3ZK8UJnVtquT6xZ9Gi+eOmks
         2a2GEVWsYRdznVT7ArbkPvRy3Btx+SXEKIZJE4hI8DTcKb51U3yzoTyAO3Es77D4WNMx
         J4qewCywaNAMG2Z6C3YW1GvH8ddxJ7XGlmdfaAEddHWdyHhDfaZ3xZYD9rfhtEcljgRW
         FtgokHdiTfxJMfbO8QypFkALc8tmG797vWj5TuZyU1g50uTJRBJjA9hmnp8rxA4ohbjJ
         qdYQ==
X-Gm-Message-State: AGi0PuaRx73sd8eYbInHLZ0T/HuhiX+P+cDuazazXqQYOArstu0CNaKy
        jLEcIcXQ/G8NdW5blv3LH8UFrMH7FDDx
X-Google-Smtp-Source: APiQypIXqLy5n+p2wBYTxOYoVY+coeUGgLYdh1PlgWGFG7WUqsWYfBI7sc++z6s7SsrCpu/pXjLhU1eMBgW7
X-Received: by 2002:a05:6214:7a7:: with SMTP id v7mr12232693qvz.27.1588839297231;
 Thu, 07 May 2020 01:14:57 -0700 (PDT)
Date:   Thu,  7 May 2020 01:14:34 -0700
In-Reply-To: <20200507081436.49071-1-irogers@google.com>
Message-Id: <20200507081436.49071-6-irogers@google.com>
Mime-Version: 1.0
References: <20200507081436.49071-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [RFC PATCH 5/7] perf metricgroup: delay events string creation
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
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently event groups are placed into groups_list at the same time as
the events string containing the events is built. Separate these two
operations and build the groups_list first, then the event string from
the groups_list. This adds an ability to reorder the groups_list that
will be used in a later patch.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/metricgroup.c | 38 +++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 48d0143b4b0c..0a00c0f87872 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -90,6 +90,7 @@ struct egroup {
 	const char *metric_expr;
 	const char *metric_unit;
 	int runtime;
+	bool has_constraint;
 };
 
 static struct evsel *find_evsel_group(struct evlist *perf_evlist,
@@ -496,8 +497,8 @@ int __weak arch_get_runtimeparam(void)
 	return 1;
 }
 
-static int __metricgroup__add_metric(struct strbuf *events,
-		struct list_head *group_list, struct pmu_event *pe, int runtime)
+static int __metricgroup__add_metric(struct list_head *group_list,
+				     struct pmu_event *pe, int runtime)
 {
 	struct egroup *eg;
 
@@ -510,6 +511,7 @@ static int __metricgroup__add_metric(struct strbuf *events,
 	eg->metric_expr = pe->metric_expr;
 	eg->metric_unit = pe->unit;
 	eg->runtime = runtime;
+	eg->has_constraint = metricgroup__has_constraint(pe);
 
 	if (expr__find_other(pe->metric_expr, NULL, &eg->pctx, runtime) < 0) {
 		expr__ctx_clear(&eg->pctx);
@@ -517,14 +519,6 @@ static int __metricgroup__add_metric(struct strbuf *events,
 		return -EINVAL;
 	}
 
-	if (events->len > 0)
-		strbuf_addf(events, ",");
-
-	if (metricgroup__has_constraint(pe))
-		metricgroup__add_metric_non_group(events, &eg->pctx);
-	else
-		metricgroup__add_metric_weak_group(events, &eg->pctx);
-
 	list_add_tail(&eg->nd, group_list);
 
 	return 0;
@@ -535,6 +529,7 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
 {
 	struct pmu_events_map *map = perf_pmu__find_map(NULL);
 	struct pmu_event *pe;
+	struct egroup *eg;
 	int i, ret = -EINVAL;
 
 	if (!map)
@@ -553,7 +548,8 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
 			pr_debug("metric expr %s for %s\n", pe->metric_expr, pe->metric_name);
 
 			if (!strstr(pe->metric_expr, "?")) {
-				ret = __metricgroup__add_metric(events, group_list, pe, 1);
+				ret = __metricgroup__add_metric(group_list,
+								pe, 1);
 			} else {
 				int j, count;
 
@@ -564,13 +560,29 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
 				 * those events to group_list.
 				 */
 
-				for (j = 0; j < count; j++)
-					ret = __metricgroup__add_metric(events, group_list, pe, j);
+				for (j = 0; j < count; j++) {
+					ret = __metricgroup__add_metric(
+						group_list, pe, j);
+				}
 			}
 			if (ret == -ENOMEM)
 				break;
 		}
 	}
+	if (!ret) {
+		list_for_each_entry (eg, group_list, nd) {
+			if (events->len > 0)
+				strbuf_addf(events, ",");
+
+			if (eg->has_constraint) {
+				metricgroup__add_metric_non_group(events,
+								  &eg->pctx);
+			} else {
+				metricgroup__add_metric_weak_group(events,
+								   &eg->pctx);
+			}
+		}
+	}
 	return ret;
 }
 
-- 
2.26.2.526.g744177e7f7-goog


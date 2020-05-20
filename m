Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64681DBC93
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgETSU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 14:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgETSU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 14:20:26 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70842C05BD43
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:20:26 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id e43so4786043qtc.3
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KKQUK0ht2kaKDrQ/rdrxhZMGnz6XCmJO5hA8GPHu2yA=;
        b=dzBNCrelUrT1JxAQv8vNvpOAWP6S6LumYmJircB+N3/gszxbhqSdn8q233fNWA60eX
         kg44zXMH51b77C43kXXKjg1IeO236183xY/tsmVczZ0ZFwxJoWGiEjG6vnU/U6yJyUvA
         Ec9aceakvgFlmtKypStS2qo0XIq51G/SfOw251x/GZFIuzIeckOvaDZUA890WzTuwn5U
         vxDzw2A8cnQNg6STnrQQcNDtUTtVJqdp113A3RnqOhCincW5i76Tb5GMQ0POIMKPVcCa
         tHGwpafAyhI/1EeRXorSP/bjo+8T81IX0KW0n4PZvL27oi6XAENG0QjZBR7xFUN8UnzY
         8D0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KKQUK0ht2kaKDrQ/rdrxhZMGnz6XCmJO5hA8GPHu2yA=;
        b=op7SZ+sF1CQd757nkiIP7l63iwYVuqWfF0EAMukefLvkpte/fdjOP4inBEPNd9/9Lq
         1785qBhbUchvQS6tYcdfDMtupnX0aH5mfo4ENZMXNAgr+So6jwvpy7sTrs1aeV+GzHGi
         DASNDPpI5+S0+Tm0ELLIu0YVWSpsfq3qevhy5BPDcaUmE2voLApEgFcr7ORPo3XePuyv
         u/Iv1cc7IlHkoooK797YcyVII4ocizuXq5VviBJTCVr1iPDxesPHNOLCCm4U4aVK8QKq
         pDOVt+AS+38urW1qWXkbV47rrWzlbQIbv9hbVnEId6BQmxwdeJ//+cv3SABcFCGcXcxP
         9pEg==
X-Gm-Message-State: AOAM533YfVV/wCmw0qh6tRzk9dB1pe4PwEGDBvckiGPwkQZpuQ11JKNL
        3Nyc0pkuxO1B/D+JHwOLy55DNV/2HRPk
X-Google-Smtp-Source: ABdhPJxs3av1fJD8WsF76BuWXwHu5sAYT+IWWJCwS+9YgSKfRnU38Sm2Lt9qWQzaPsCtKzaoQ1TjJ8FINtIE
X-Received: by 2002:ad4:47c8:: with SMTP id p8mr6022353qvw.93.1589998825230;
 Wed, 20 May 2020 11:20:25 -0700 (PDT)
Date:   Wed, 20 May 2020 11:20:07 -0700
In-Reply-To: <20200520182011.32236-1-irogers@google.com>
Message-Id: <20200520182011.32236-4-irogers@google.com>
Mime-Version: 1.0
References: <20200520182011.32236-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH v2 3/7] perf metricgroup: Delay events string creation
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paul Clarke <pc@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
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
 tools/perf/util/metricgroup.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 5c0603ef4c75..dca433520b92 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -90,6 +90,7 @@ struct egroup {
 	const char *metric_expr;
 	const char *metric_unit;
 	int runtime;
+	bool has_constraint;
 };
 
 static struct evsel *find_evsel_group(struct evlist *perf_evlist,
@@ -485,8 +486,8 @@ int __weak arch_get_runtimeparam(void)
 	return 1;
 }
 
-static int __metricgroup__add_metric(struct strbuf *events,
-		struct list_head *group_list, struct pmu_event *pe, int runtime)
+static int __metricgroup__add_metric(struct list_head *group_list,
+				     struct pmu_event *pe, int runtime)
 {
 	struct egroup *eg;
 
@@ -499,6 +500,7 @@ static int __metricgroup__add_metric(struct strbuf *events,
 	eg->metric_expr = pe->metric_expr;
 	eg->metric_unit = pe->unit;
 	eg->runtime = runtime;
+	eg->has_constraint = metricgroup__has_constraint(pe);
 
 	if (expr__find_other(pe->metric_expr, NULL, &eg->pctx, runtime) < 0) {
 		expr__ctx_clear(&eg->pctx);
@@ -506,14 +508,6 @@ static int __metricgroup__add_metric(struct strbuf *events,
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
@@ -524,6 +518,7 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
 {
 	struct pmu_events_map *map = perf_pmu__find_map(NULL);
 	struct pmu_event *pe;
+	struct egroup *eg;
 	int i, ret;
 	bool has_match = false;
 
@@ -547,7 +542,8 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
 			pr_debug("metric expr %s for %s\n", pe->metric_expr, pe->metric_name);
 
 			if (!strstr(pe->metric_expr, "?")) {
-				ret = __metricgroup__add_metric(events, group_list, pe, 1);
+				ret = __metricgroup__add_metric(group_list,
+								pe, 1);
 				if (ret)
 					return ret;
 			} else {
@@ -561,13 +557,26 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
 				 */
 
 				for (j = 0; j < count; j++) {
-					ret = __metricgroup__add_metric(events, group_list, pe, j);
+					ret = __metricgroup__add_metric(
+						group_list, pe, j);
 					if (ret)
 						return ret;
 				}
 			}
 		}
 	}
+	list_for_each_entry(eg, group_list, nd) {
+		if (events->len > 0)
+			strbuf_addf(events, ",");
+
+		if (eg->has_constraint) {
+			metricgroup__add_metric_non_group(events,
+							  &eg->pctx);
+		} else {
+			metricgroup__add_metric_weak_group(events,
+							   &eg->pctx);
+		}
+	}
 	return 0;
 }
 
-- 
2.26.2.761.g0e0b3e54be-goog


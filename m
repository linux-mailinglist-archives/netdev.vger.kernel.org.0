Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCD31DAC12
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgETH2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgETH22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 03:28:28 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0521C08C5C3
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 00:28:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q16so1005190ybg.18
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 00:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=o4Mcc3EBUBAZPRcOBmuKP8P17khXnklwMDwupwtwADU=;
        b=E7qIea7lgARcu17xRzZT4dlI+Doj2AovHbm3fH+LzBR8a7/xPEzErl4ddURFqBEAWy
         x2oZjn4VLDvoZGqzLxPSYHMBKBmTglFIxv9mh9nuwqNnYBlK8RoTKcX6+73EvgJ8NVKs
         KtGwa2fAf4EoW4NAxpsBTtOBWQcL0+actfcy9A7w4DYzTohfq8sYt3/Iq8vC1ftMNUEK
         iex2wq64z9POBNuvMkXOj30a+TXpzWhzHfXeeoAyhktUWAMmwCOEoJuIMmeRk43V9roy
         yIX90ZNKQ5LrNrIvE1IwgKaR5uy+iqo7mujARZ6UBCgeN29NSxBkRj2ks+exbqPiAOiI
         FRUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=o4Mcc3EBUBAZPRcOBmuKP8P17khXnklwMDwupwtwADU=;
        b=UauxW3UJM+rCmkosUETzdYucBlq0FrxqEMrli7/oNJEVlt1xntO8D0+V8zU3ty3qun
         hoefcSPtoT86seNVZrqK61GPF3nfAoxqVCQhYJDQoLO1Yt0GFknUkOY65Nxt2XlSfGVy
         0g9nHLpWmDrTbZ6h8mgTTnstM6Th8vTLtz7VHq/u04Goy1Th2MuDrserc6rggiMqLwhm
         yekPpuD4eqqxkh6IT84vmvZzRclRoexh/9+GgLjhd0SEshWeu+ysl6nOh08cXRBO+V3o
         l57pI5PYbh/m7I76JdDNrlLDtwTQLzxowIhMnX3RxEGcHiAavHXikFGvSb+Yu8v2Ip/J
         xmjg==
X-Gm-Message-State: AOAM531l4R0Sv70OQzXMfP+ciyCMzxJEgBG4UpnHsvI1AyFA+I0lG9FY
        oBZSkIX9Sb20BiN8kgINqOOremzfIABh
X-Google-Smtp-Source: ABdhPJwr7JG0cSeS9+mCHOwlJ6RjWmrR/f66hLRFeEWdfWL3VDAXqjcBAntI60lfH01j8lX1BBuD7HsK4KF7
X-Received: by 2002:a5b:301:: with SMTP id j1mr4973710ybp.142.1589959707803;
 Wed, 20 May 2020 00:28:27 -0700 (PDT)
Date:   Wed, 20 May 2020 00:28:10 -0700
In-Reply-To: <20200520072814.128267-1-irogers@google.com>
Message-Id: <20200520072814.128267-4-irogers@google.com>
Mime-Version: 1.0
References: <20200520072814.128267-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 3/7] perf metricgroup: Delay events string creation
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
 tools/perf/util/metricgroup.c | 38 +++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 7a43ee0a2e40..afd960d03a77 100644
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
 	int i, ret = -EINVAL;
 
 	if (!map)
@@ -542,7 +537,8 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
 			pr_debug("metric expr %s for %s\n", pe->metric_expr, pe->metric_name);
 
 			if (!strstr(pe->metric_expr, "?")) {
-				ret = __metricgroup__add_metric(events, group_list, pe, 1);
+				ret = __metricgroup__add_metric(group_list,
+								pe, 1);
 			} else {
 				int j, count;
 
@@ -553,13 +549,29 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
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
+		list_for_each_entry(eg, group_list, nd) {
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
2.26.2.761.g0e0b3e54be-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBC71DAC0A
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgETH2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgETH2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 03:28:36 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CF5C061A0F
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 00:28:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 186so1013318ybq.1
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 00:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=I3l1kitFEQEOYpgkX26nLxNxQ4LDzHncnayugA9zuFc=;
        b=by4Ir6uBme+an8i3wfo/O8JoZF4fTn/bxSGzVZQ1xcWt1NckdUSQPncThqGydE418s
         bEZh4jHOj0akD6aN9pwF8aFHbC95/kBbhpyUfs8N3OTh0zEETZJ1Bs3A1Qp1D8d6RuZo
         VYwxQTnSUGPdYQ6z1YGWr/E/OozvNyOchSODzEfLyj5D4pbxmULk9uzaTc1ownCAUrfH
         P9f5Q2RoCVx9VPby1D8gNe2+QbmdraNIs2RO6OBZ7UV3I0+G80GIhaRQEOu9fqyV6ysL
         tcoho9Ch7ZZdJNdbYBWiJP3wmKRfhBXwmHdKDX0x9GYO1MNFOy86lv6vlmAqBfO/oaf6
         ueog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=I3l1kitFEQEOYpgkX26nLxNxQ4LDzHncnayugA9zuFc=;
        b=d3q1O3A5fxZaatb9o5xV8A0mJkRP1qgiGdlQ0RM10MD8XSU/0Xlm6toa9IUtSJzVO8
         /+Juz3JE6z5KpsjRMT+kUJs6I1hhCy6N++ROQQkCaLsvDL8qHZjicuUKLiW2tqy9MSeO
         qQOv4VdU6AM9R9J4Vc5IeCjuJjPNo4r42DbIiwiJgoS4hMzFKvIC+9aTU0TqbUJ+4iiv
         M67a68eeFcEMrwFguqmeZ62iTwJp9bKw1eTRoLJ03E1cSD07KkaD1zrH6/vycvwUv21U
         Tc62VTsSBuS/9ryPN5IzAaS57/CnTeTy7AYq/efzggL5GywM0Nk4ZbAKeIhBAdh0akXZ
         zpMQ==
X-Gm-Message-State: AOAM531PCVJ9CSdYwchBBCrwoPPF/zeUMrOS/Im1HlWkOn3+tQcswwY8
        xFxg2gnxXigCXfnDqCU33Aljmd0VmlFd
X-Google-Smtp-Source: ABdhPJxG0fBdKWJFuEG/l4b+rnSlUAKmc1Q4YXSyxwWMLCKEQrj+3B1wfbD5a5IlEYXZ33gla2E3j3CDx7mZ
X-Received: by 2002:a25:f302:: with SMTP id c2mr5079681ybs.440.1589959715123;
 Wed, 20 May 2020 00:28:35 -0700 (PDT)
Date:   Wed, 20 May 2020 00:28:13 -0700
In-Reply-To: <20200520072814.128267-1-irogers@google.com>
Message-Id: <20200520072814.128267-7-irogers@google.com>
Mime-Version: 1.0
References: <20200520072814.128267-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 6/7] perf metricgroup: Add options to not group or merge
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

Add --metric-no-group that causes all events within metrics to not be
grouped. This can allow the event to get more time when multiplexed, but
may also lower accuracy.
Add --metric-no-merge option. By default events in different metrics may
be shared if the group of events for one metric is the same or larger
than that of the second. Sharing may increase or lower accuracy and so
is now configurable.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/Documentation/perf-stat.txt | 19 +++++++
 tools/perf/builtin-stat.c              | 11 ++++-
 tools/perf/util/metricgroup.c          | 68 ++++++++++++++++++++------
 tools/perf/util/metricgroup.h          |  6 ++-
 tools/perf/util/stat.h                 |  2 +
 5 files changed, 87 insertions(+), 19 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 3fb5028aef08..cc1e4c62bc91 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -234,6 +234,25 @@ filter out the startup phase of the program, which is often very different.
 
 Print statistics of transactional execution if supported.
 
+--metric-no-group::
+By default, events to compute a metric are placed in weak groups. The
+group tries to enforce scheduling all or none of the events. The
+--metric-no-group option places events outside of groups and may
+increase the chance of the event being scheduled - leading to more
+accuracy. However, as events may not be scheduled together accuracy
+for metrics like instructions per cycle can be lower - as both metrics
+may no longer be being measured at the same time.
+
+--metric-no-merge::
+By default metric events in different weak groups can be shared if one
+group contains all the events needed by another. In such cases one
+group will be eliminated reducing event multiplexing and making it so
+that certain groups of metrics sum to 100%. A downside to sharing a
+group is that the group may require multiplexing and so accuracy for a
+small group that need not have multiplexing is lowered. This option
+forbids the event merging logic from sharing events between groups and
+may be used to increase accuracy in this case.
+
 STAT RECORD
 -----------
 Stores stat data into perf data file.
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 4deb2d46a343..b013fea29e0b 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -840,7 +840,10 @@ static int parse_metric_groups(const struct option *opt,
 			       const char *str,
 			       int unset __maybe_unused)
 {
-	return metricgroup__parse_groups(opt, str, &stat_config.metric_events);
+	return metricgroup__parse_groups(opt, str,
+					 stat_config.metric_no_group,
+					 stat_config.metric_no_merge,
+					 &stat_config.metric_events);
 }
 
 static struct option stat_options[] = {
@@ -918,6 +921,10 @@ static struct option stat_options[] = {
 		     "ms to wait before starting measurement after program start"),
 	OPT_CALLBACK_NOOPT(0, "metric-only", &stat_config.metric_only, NULL,
 			"Only print computed metrics. No raw values", enable_metric_only),
+	OPT_BOOLEAN(0, "metric-no-group", &stat_config.metric_no_group,
+		       "don't group metric events, impacts multiplexing"),
+	OPT_BOOLEAN(0, "metric-no-merge", &stat_config.metric_no_merge,
+		       "don't try to share events between metrics in a group"),
 	OPT_BOOLEAN(0, "topdown", &topdown_run,
 			"measure topdown level 1 statistics"),
 	OPT_BOOLEAN(0, "smi-cost", &smi_cost,
@@ -1442,6 +1449,8 @@ static int add_default_attributes(void)
 			struct option opt = { .value = &evsel_list };
 
 			return metricgroup__parse_groups(&opt, "transaction",
+							 stat_config.metric_no_group,
+							stat_config.metric_no_merge,
 							 &stat_config.metric_events);
 		}
 
diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 7ed32baeb767..432ae2e4c7b1 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -95,11 +95,15 @@ struct egroup {
 
 /**
  * Find a group of events in perf_evlist that correpond to those from a parsed
- * metric expression.
+ * metric expression. Note, as find_evsel_group is called in the same order as
+ * perf_evlist was constructed, metric_no_merge doesn't need to test for
+ * underfilling a group.
  * @perf_evlist: a list of events something like: {metric1 leader, metric1
  * sibling, metric1 sibling}:W,duration_time,{metric2 leader, metric2 sibling,
  * metric2 sibling}:W,duration_time
  * @pctx: the parse context for the metric expression.
+ * @metric_no_merge: don't attempt to share events for the metric with other
+ * metrics.
  * @has_constraint: is there a contraint on the group of events? In which case
  * the events won't be grouped.
  * @metric_events: out argument, null terminated array of evsel's associated
@@ -109,6 +113,7 @@ struct egroup {
  */
 static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 				      struct expr_parse_ctx *pctx,
+				      bool metric_no_merge,
 				      bool has_constraint,
 				      struct evsel **metric_events,
 				      unsigned long *evlist_used)
@@ -132,6 +137,9 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 		 */
 		if (has_constraint && ev->weak_group)
 			continue;
+		/* Ignore event if already used and merging is disabled. */
+		if (metric_no_merge && test_bit(ev->idx, evlist_used))
+			continue;
 		if (!has_constraint && ev->leader != current_leader) {
 			/*
 			 * Start of a new group, discard the whole match and
@@ -142,8 +150,23 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 				sizeof(struct evsel *) * idnum);
 			current_leader = ev->leader;
 		}
-		if (hashmap__find(&pctx->ids, ev->name, (void **)&val_ptr))
+		if (hashmap__find(&pctx->ids, ev->name, (void **)&val_ptr)) {
+			if (has_constraint) {
+				/*
+				 * Events aren't grouped, ensure the same event
+				 * isn't matched from two groups.
+				 */
+				for (i = 0; i < matched_events; i++) {
+					if (!strcmp(ev->name,
+						    metric_events[i]->name)) {
+						break;
+					}
+				}
+				if (i != matched_events)
+					continue;
+			}
 			metric_events[matched_events++] = ev;
+		}
 		if (matched_events == events_to_match)
 			break;
 	}
@@ -175,6 +198,7 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 }
 
 static int metricgroup__setup_events(struct list_head *groups,
+				     bool metric_no_merge,
 				     struct evlist *perf_evlist,
 				     struct rblist *metric_events_list)
 {
@@ -200,8 +224,9 @@ static int metricgroup__setup_events(struct list_head *groups,
 			break;
 		}
 		evsel = find_evsel_group(perf_evlist, &eg->pctx,
-					eg->has_constraint, metric_events,
-					evlist_used);
+					 metric_no_merge,
+					 eg->has_constraint, metric_events,
+					 evlist_used);
 		if (!evsel) {
 			pr_debug("Cannot resolve %s: %s\n",
 					eg->metric_name, eg->metric_expr);
@@ -520,7 +545,9 @@ int __weak arch_get_runtimeparam(void)
 }
 
 static int __metricgroup__add_metric(struct list_head *group_list,
-				     struct pmu_event *pe, int runtime)
+				     struct pmu_event *pe,
+				     bool metric_no_group,
+				     int runtime)
 {
 	struct egroup *eg;
 
@@ -533,7 +560,7 @@ static int __metricgroup__add_metric(struct list_head *group_list,
 	eg->metric_expr = pe->metric_expr;
 	eg->metric_unit = pe->unit;
 	eg->runtime = runtime;
-	eg->has_constraint = metricgroup__has_constraint(pe);
+	eg->has_constraint = metric_no_group || metricgroup__has_constraint(pe);
 
 	if (expr__find_other(pe->metric_expr, NULL, &eg->pctx, runtime) < 0) {
 		expr__ctx_clear(&eg->pctx);
@@ -560,7 +587,8 @@ static int __metricgroup__add_metric(struct list_head *group_list,
 	return 0;
 }
 
-static int metricgroup__add_metric(const char *metric, struct strbuf *events,
+static int metricgroup__add_metric(const char *metric, bool metric_no_group,
+				   struct strbuf *events,
 				   struct list_head *group_list)
 {
 	struct pmu_events_map *map = perf_pmu__find_map(NULL);
@@ -585,7 +613,9 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
 
 			if (!strstr(pe->metric_expr, "?")) {
 				ret = __metricgroup__add_metric(group_list,
-								pe, 1);
+								pe,
+								metric_no_group,
+								1);
 			} else {
 				int j, count;
 
@@ -598,7 +628,8 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
 
 				for (j = 0; j < count; j++) {
 					ret = __metricgroup__add_metric(
-						group_list, pe, j);
+						group_list, pe,
+						metric_no_group, j);
 				}
 			}
 			if (ret == -ENOMEM)
@@ -622,7 +653,8 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
 	return ret;
 }
 
-static int metricgroup__add_metric_list(const char *list, struct strbuf *events,
+static int metricgroup__add_metric_list(const char *list, bool metric_no_group,
+					struct strbuf *events,
 				        struct list_head *group_list)
 {
 	char *llist, *nlist, *p;
@@ -637,7 +669,8 @@ static int metricgroup__add_metric_list(const char *list, struct strbuf *events,
 	strbuf_addf(events, "%s", "");
 
 	while ((p = strsep(&llist, ",")) != NULL) {
-		ret = metricgroup__add_metric(p, events, group_list);
+		ret = metricgroup__add_metric(p, metric_no_group, events,
+					      group_list);
 		if (ret == -EINVAL) {
 			fprintf(stderr, "Cannot find metric or group `%s'\n",
 					p);
@@ -664,8 +697,10 @@ static void metricgroup__free_egroups(struct list_head *group_list)
 }
 
 int metricgroup__parse_groups(const struct option *opt,
-			   const char *str,
-			   struct rblist *metric_events)
+			      const char *str,
+			      bool metric_no_group,
+			      bool metric_no_merge,
+			      struct rblist *metric_events)
 {
 	struct parse_events_error parse_error;
 	struct evlist *perf_evlist = *(struct evlist **)opt->value;
@@ -675,7 +710,8 @@ int metricgroup__parse_groups(const struct option *opt,
 
 	if (metric_events->nr_entries == 0)
 		metricgroup__rblist_init(metric_events);
-	ret = metricgroup__add_metric_list(str, &extra_events, &group_list);
+	ret = metricgroup__add_metric_list(str, metric_no_group,
+					   &extra_events, &group_list);
 	if (ret)
 		return ret;
 	pr_debug("adding %s\n", extra_events.buf);
@@ -686,8 +722,8 @@ int metricgroup__parse_groups(const struct option *opt,
 		goto out;
 	}
 	strbuf_release(&extra_events);
-	ret = metricgroup__setup_events(&group_list, perf_evlist,
-					metric_events);
+	ret = metricgroup__setup_events(&group_list, metric_no_merge,
+					perf_evlist, metric_events);
 out:
 	metricgroup__free_egroups(&group_list);
 	return ret;
diff --git a/tools/perf/util/metricgroup.h b/tools/perf/util/metricgroup.h
index 6b09eb30b4ec..287850bcdeca 100644
--- a/tools/perf/util/metricgroup.h
+++ b/tools/perf/util/metricgroup.h
@@ -29,8 +29,10 @@ struct metric_event *metricgroup__lookup(struct rblist *metric_events,
 					 struct evsel *evsel,
 					 bool create);
 int metricgroup__parse_groups(const struct option *opt,
-			const char *str,
-			struct rblist *metric_events);
+			      const char *str,
+			      bool metric_no_group,
+			      bool metric_no_merge,
+			      struct rblist *metric_events);
 
 void metricgroup__print(bool metrics, bool groups, char *filter,
 			bool raw, bool details);
diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
index b4fdfaa7f2c0..ea054d27ce1d 100644
--- a/tools/perf/util/stat.h
+++ b/tools/perf/util/stat.h
@@ -110,6 +110,8 @@ struct perf_stat_config {
 	bool			 all_kernel;
 	bool			 all_user;
 	bool			 percore_show_thread;
+	bool			 metric_no_group;
+	bool			 metric_no_merge;
 	FILE			*output;
 	unsigned int		 interval;
 	unsigned int		 timeout;
-- 
2.26.2.761.g0e0b3e54be-goog


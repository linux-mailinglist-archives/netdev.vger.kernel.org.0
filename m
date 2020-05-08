Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1381CA2C8
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 07:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgEHFhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 01:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbgEHFhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 01:37:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B47AC05BD0B
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 22:36:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z1so780247ybm.5
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 22:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NI47XF21ZdHZtTwg9U3Xu5hLQ+KgyT9MTAu+sQz/TqI=;
        b=dzEo1npFQYDAAAa2R9qUj9LJDb4+qu9189mY1rhyIeoq+5C1/fZvUF3sIkiIKlpd4D
         GvmaBTO9offX6hAyEYsH5GfCUOW6d+FIXSo3oCT5I39Q4so7fbqZxDSx34LhVMhWUD1I
         ZUMOOkM26v0UdIT4X9X0u0dsJ+4roOqFBZ2h0/NAV4CaENVLyJUM7ZGH64kbWPerxbqb
         rkcXtvmAJa3gFY7sNrJtRoIEsoA5vqJT2dxWOjtDdLNn9RdqGGowTqycTeZBNlJMh7Zu
         cKt1DlKWYZIwKi7saZZvLxUZ8KCr/sPOXXRzhT3R30Wn0nEpamC77Jk79Sp/qqPDMNjY
         2tCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NI47XF21ZdHZtTwg9U3Xu5hLQ+KgyT9MTAu+sQz/TqI=;
        b=uRuVT0pSnvPx7ufmHWUJ+SPW6U/KJ2fuQ/FBAnaQm1P6cwDOR4vv+XVvK0coez/gJz
         Ns8eiQpNkPwJ3Id/TR3hSmj9t1Oh6U4e4dEHyYlY1T24yNSBc+l/vFISjjW7qmQ2C8Mz
         R8W/Z8Huswv14t9QXnfZ9sW6xB38K3v0vvsREs3peQzbNYv6F0QpUlfXRoEtn/mXmelD
         EjXtwJjrahko8S1ny4hlaTE5fXhRYlcLqATk8K3ZqtFgjbr3cLB0JjdQcPMXGLRCTCX0
         dd4B89hGjXLAaPO2GsgSrHa71ffVgtBZnQUBB6r+HqX09uQu7BrdBwmmaxm+kuWhTnGu
         u6NA==
X-Gm-Message-State: AGi0PuYsPxGEZ/4xK4LH2Ipz1LEke8Dblnd7mW153cpvgzRMR1HSunDP
        /6eQc+aXxiGpAgoW2gRxL62FvxV7vzky
X-Google-Smtp-Source: APiQypJfyOb7TU6NxWAm3Tx6pCvv7cbHZLLgM63DqwLHySAPKpDb+W3pYVIVFIs1UDD/f1qwrWL4VWY25KCc
X-Received: by 2002:a25:d408:: with SMTP id m8mr1938204ybf.336.1588916217716;
 Thu, 07 May 2020 22:36:57 -0700 (PDT)
Date:   Thu,  7 May 2020 22:36:28 -0700
In-Reply-To: <20200508053629.210324-1-irogers@google.com>
Message-Id: <20200508053629.210324-14-irogers@google.com>
Mime-Version: 1.0
References: <20200508053629.210324-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [RFC PATCH v3 13/14] perf metricgroup: remove duped metric group events
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
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A metric group contains multiple metrics. These metrics may use the same
events. If metrics use separate events then it leads to more
multiplexing and overall metric counts fail to sum to 100%.
Modify how metrics are associated with events so that if the events in
an earlier group satisfy the current metric, the same events are used.
A record of used events is kept and at the end of processing unnecessary
events are eliminated.

Before:
$ perf stat -a -M TopDownL1 sleep 1

 Performance counter stats for 'system wide':

       920,211,343      uops_issued.any           #      0.5 Backend_Bound            (16.56%)
     1,977,733,128      idq_uops_not_delivered.core                                     (16.56%)
        51,668,510      int_misc.recovery_cycles                                      (16.56%)
       732,305,692      uops_retired.retire_slots                                     (16.56%)
     1,497,621,849      cycles                                                        (16.56%)
       721,098,274      uops_issued.any           #      0.1 Bad_Speculation          (16.79%)
     1,332,681,791      cycles                                                        (16.79%)
       552,475,482      uops_retired.retire_slots                                     (16.79%)
        47,708,340      int_misc.recovery_cycles                                      (16.79%)
     1,383,713,292      cycles
                                                  #      0.4 Frontend_Bound           (16.76%)
     2,013,757,701      idq_uops_not_delivered.core                                     (16.76%)
     1,373,363,790      cycles
                                                  #      0.1 Retiring                 (33.54%)
       577,302,589      uops_retired.retire_slots                                     (33.54%)
       392,766,987      inst_retired.any          #      0.3 IPC                      (50.24%)
     1,351,873,350      cpu_clk_unhalted.thread                                       (50.24%)
     1,332,510,318      cycles
                                                  # 5330041272.0 SLOTS                (49.90%)

       1.006336145 seconds time elapsed

After:
$ perf stat -a -M TopDownL1 sleep 1

 Performance counter stats for 'system wide':

       765,949,145      uops_issued.any           #      0.1 Bad_Speculation
                                                  #      0.5 Backend_Bound            (50.09%)
     1,883,830,591      idq_uops_not_delivered.core #      0.3 Frontend_Bound           (50.09%)
        48,237,080      int_misc.recovery_cycles                                      (50.09%)
       581,798,385      uops_retired.retire_slots #      0.1 Retiring                 (50.09%)
     1,361,628,527      cycles
                                                  # 5446514108.0 SLOTS                (50.09%)
       391,415,714      inst_retired.any          #      0.3 IPC                      (49.91%)
     1,336,486,781      cpu_clk_unhalted.thread                                       (49.91%)

       1.005469298 seconds time elapsed

Note: Bad_Speculation + Backend_Bound + Frontend_Bound + Retiring = 100%
after, where as before it is 110%. After there are 2 groups, whereas
before there are 6. After the cycles event appears once, before it
appeared 5 times.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/metricgroup.c | 96 ++++++++++++++++++++++-------------
 1 file changed, 60 insertions(+), 36 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 69fbff47089f..c97dc87c2a31 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -93,45 +93,72 @@ struct egroup {
 	bool has_constraint;
 };
 
+/**
+ * Find a group of events in perf_evlist that correpond to those from a parsed
+ * metric expression.
+ * @perf_evlist: a list of events something like: {metric1 leader, metric1
+ * sibling, metric1 sibling}:W,duration_time,{metric2 leader, metric2 sibling,
+ * metric2 sibling}:W,duration_time
+ * @pctx: the parse context for the metric expression.
+ * @has_constraint: is there a contraint on the group of events? In which case
+ * the events won't be grouped.
+ * @metric_events: out argument, null terminated array of evsel's associated
+ * with the metric.
+ * @evlist_used: in/out argument, bitmap tracking which evlist events are used.
+ * @return the first metric event or NULL on failure.
+ */
 static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 				      struct expr_parse_ctx *pctx,
+				      bool has_constraint,
 				      struct evsel **metric_events,
 				      unsigned long *evlist_used)
 {
-	struct evsel *ev;
-	bool leader_found;
-	const size_t idnum = hashmap__size(&pctx->ids);
-	size_t i = 0;
-	int j = 0;
+	struct evsel *ev, *current_leader = NULL;
 	double *val_ptr;
+	int i = 0, matched_events = 0, events_to_match;
+	const int idnum = (int)hashmap__size(&pctx->ids);
+
+	/* duration_time is grouped separately. */
+	if (!has_constraint &&
+	    hashmap__find(&pctx->ids, "duration_time", (void **)&val_ptr))
+		events_to_match = idnum - 1;
+	else
+		events_to_match = idnum;
 
 	evlist__for_each_entry (perf_evlist, ev) {
-		if (test_bit(j++, evlist_used))
+		/*
+		 * Events with a constraint aren't grouped and match the first
+		 * events available.
+		 */
+		if (has_constraint && ev->weak_group)
 			continue;
-		if (hashmap__find(&pctx->ids, ev->name, (void **)&val_ptr)) {
-			if (!metric_events[i])
-				metric_events[i] = ev;
-			i++;
-			if (i == idnum)
-				break;
-		} else {
-			/* Discard the whole match and start again */
-			i = 0;
+		if (!has_constraint && ev->leader != current_leader) {
+			/*
+			 * Start of a new group, discard the whole match and
+			 * start again.
+			 */
+			matched_events = 0;
 			memset(metric_events, 0,
 				sizeof(struct evsel *) * idnum);
+			current_leader = ev->leader;
+		}
+		if (hashmap__find(&pctx->ids, ev->name, (void **)&val_ptr))
+			metric_events[matched_events++] = ev;
+		if (matched_events == events_to_match)
+			break;
+	}
 
-			if (hashmap__find(&pctx->ids, ev->name,
-					  (void **)&val_ptr)) {
-				if (!metric_events[i])
-					metric_events[i] = ev;
-				i++;
-				if (i == idnum)
-					break;
+	if (events_to_match != idnum) {
+		/* Add the first duration_time. */
+		evlist__for_each_entry(perf_evlist, ev) {
+			if (!strcmp(ev->name, "duration_time")) {
+				metric_events[matched_events++] = ev;
+				break;
 			}
 		}
 	}
 
-	if (i != idnum) {
+	if (matched_events != idnum) {
 		/* Not whole match */
 		return NULL;
 	}
@@ -139,18 +166,8 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 	metric_events[idnum] = NULL;
 
 	for (i = 0; i < idnum; i++) {
-		leader_found = false;
-		evlist__for_each_entry(perf_evlist, ev) {
-			if (!leader_found && (ev == metric_events[i]))
-				leader_found = true;
-
-			if (leader_found &&
-			    !strcmp(ev->name, metric_events[i]->name)) {
-				ev->metric_leader = metric_events[i];
-			}
-			j++;
-		}
 		ev = metric_events[i];
+		ev->metric_leader = ev;
 		set_bit(ev->idx, evlist_used);
 	}
 
@@ -166,7 +183,7 @@ static int metricgroup__setup_events(struct list_head *groups,
 	int i = 0;
 	int ret = 0;
 	struct egroup *eg;
-	struct evsel *evsel;
+	struct evsel *evsel, *tmp;
 	unsigned long *evlist_used;
 
 	evlist_used = bitmap_alloc(perf_evlist->core.nr_entries);
@@ -182,7 +199,8 @@ static int metricgroup__setup_events(struct list_head *groups,
 			ret = -ENOMEM;
 			break;
 		}
-		evsel = find_evsel_group(perf_evlist, &eg->pctx, metric_events,
+		evsel = find_evsel_group(perf_evlist, &eg->pctx,
+					eg->has_constraint, metric_events,
 					evlist_used);
 		if (!evsel) {
 			pr_debug("Cannot resolve %s: %s\n",
@@ -212,6 +230,12 @@ static int metricgroup__setup_events(struct list_head *groups,
 		list_add(&expr->nd, &me->head);
 	}
 
+	evlist__for_each_entry_safe(perf_evlist, tmp, evsel) {
+		if (!test_bit(evsel->idx, evlist_used)) {
+			evlist__remove(perf_evlist, evsel);
+			evsel__delete(evsel);
+		}
+	}
 	bitmap_free(evlist_used);
 
 	return ret;
-- 
2.26.2.645.ge9eca65c58-goog


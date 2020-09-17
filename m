Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC0D26E679
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgIQUSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgIQUSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:18:12 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D59C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:18:11 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id h9so2271957qvr.3
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=+qn0hmllJB1IjyXqhj19h4c4rALkHNh35RY+rYVLwWk=;
        b=oIqjID0Z7zC8gUeMsqR+odV/iEANb+zSaRcB7zHOKEFout655BQ6yGH9NaSq7vDeCe
         cpB4NI3WEDP3KZff3xXN0y3plrwFhTCO/PMXlC/pH7V/u9xJ+7T1gkI6Q38TRQuAvtsx
         ft90aah+CdQ1SQvjLfxDFdBhkFIMMVCr7L+VvL0IX+uIWCGuzY6ZsDACSxhX8RKWNGuQ
         HPl2Tn/++qAV+FHB5MOb5mkmBBuxkE6kU57QoM7G3TlG3AcQocWVPAYTreP6hWDyoSu+
         Q6buY1FkOqQsAvjlTGuO2Rs1wOchEfX0+SodaSwEKyGAdzY2NUwMVP8APBfUyTMpnF3c
         EzNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+qn0hmllJB1IjyXqhj19h4c4rALkHNh35RY+rYVLwWk=;
        b=hTIwAGuc/t+Tmik8xiZuvAqt3gq5NTi9MB0FqzSbaxgqlHc3YlwS8YuJRXkn9iil7v
         7+6uRpf2S7HKQCz0Gs/GzF8Pi4rAPnk4eG5eS+5iLgmXQ0AZxyNvdxK1Py9nIX3Zbxv5
         VS6c60UJNZEeq76R2kBbJ8CbM/olEWBXY3KLioFEUq1sUbb3ncgDLjFYNe7dmYGmvWcr
         zy+H4evLwJFpHmXBGLRLdHVgLSAeUrKWFCN+g0sazAivwq7m1hRL5T+l6mr+dh+6k2kf
         A73XQttpqFr+NLMzqmT1BCLFa7wzjfwLkgn9244VvfPMysguJfc32ve21mdjJblgsbgp
         ZR2Q==
X-Gm-Message-State: AOAM530o8+gXYWxTUxraIIkf69r8Y4ZQcBaGIeiVE7jpHwy5Am+a7bu2
        wSNWRVbhghwO/9nYRIsiasjdWhcyDOs+
X-Google-Smtp-Source: ABdhPJxwP13h73YzKi0iuDbLGGJt5UnSuAYRRUGk2Y3OfYFbqNk3PEaFzTqb1Xz8u9hjtGUleTwJVedyVk91
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:2:f693:9fff:fef4:4583])
 (user=irogers job=sendgmr) by 2002:ad4:5387:: with SMTP id
 i7mr13567860qvv.43.1600373890879; Thu, 17 Sep 2020 13:18:10 -0700 (PDT)
Date:   Thu, 17 Sep 2020 13:18:07 -0700
In-Reply-To: <20200917190026.GB1426933@kernel.org>
Message-Id: <20200917201807.4090224-1-irogers@google.com>
Mime-Version: 1.0
References: <20200917190026.GB1426933@kernel.org>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4] perf metricgroup: Fix uncore metric expressions
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>,
        Jin Yao <yao.jin@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A metric like DRAM_BW_Use has on SkylakeX events uncore_imc/cas_count_read/
and uncore_imc/case_count_write/. These events open 6 events per socket
with pmu names of uncore_imc_[0-5]. The current metric setup code in
find_evsel_group assumes one ID will map to 1 event to be recorded in
metric_events. For events with multiple matches, the first event is
recorded in metric_events (avoiding matching >1 event with the same
name) and the evlist_used updated so that duplicate events aren't
removed when the evlist has unused events removed.

Before this change:
$ /tmp/perf/perf stat -M DRAM_BW_Use -a -- sleep 1

 Performance counter stats for 'system wide':

             41.14 MiB  uncore_imc/cas_count_read/
     1,002,614,251 ns   duration_time

       1.002614251 seconds time elapsed

After this change:
$ /tmp/perf/perf stat -M DRAM_BW_Use -a -- sleep 1

 Performance counter stats for 'system wide':

            157.47 MiB  uncore_imc/cas_count_read/ #     0.00 DRAM_BW_Use
            126.97 MiB  uncore_imc/cas_count_write/
     1,003,019,728 ns   duration_time

Erroneous duplication introduced in:
commit 2440689d62e9 ("perf metricgroup: Remove duped metric group events").

Fixes: ded80bda8bc9 ("perf expr: Migrate expr ids table to a hashmap").
Reported-by: Jin Yao <yao.jin@linux.intel.com>
Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/metricgroup.c | 75 ++++++++++++++++++++++++++---------
 1 file changed, 56 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index ab5030fcfed4..d948a7f910cf 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -150,6 +150,18 @@ static void expr_ids__exit(struct expr_ids *ids)
 		free(ids->id[i].id);
 }
 
+static bool contains_event(struct evsel **metric_events, int num_events,
+			const char *event_name)
+{
+	int i;
+
+	for (i = 0; i < num_events; i++) {
+		if (!strcmp(metric_events[i]->name, event_name))
+			return true;
+	}
+	return false;
+}
+
 /**
  * Find a group of events in perf_evlist that correpond to those from a parsed
  * metric expression. Note, as find_evsel_group is called in the same order as
@@ -180,7 +192,11 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 	int i = 0, matched_events = 0, events_to_match;
 	const int idnum = (int)hashmap__size(&pctx->ids);
 
-	/* duration_time is grouped separately. */
+	/*
+	 * duration_time is always grouped separately, when events are grouped
+	 * (ie has_constraint is false) then ignore it in the matching loop and
+	 * add it to metric_events at the end.
+	 */
 	if (!has_constraint &&
 	    hashmap__find(&pctx->ids, "duration_time", (void **)&val_ptr))
 		events_to_match = idnum - 1;
@@ -207,23 +223,20 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 				sizeof(struct evsel *) * idnum);
 			current_leader = ev->leader;
 		}
-		if (hashmap__find(&pctx->ids, ev->name, (void **)&val_ptr)) {
-			if (has_constraint) {
-				/*
-				 * Events aren't grouped, ensure the same event
-				 * isn't matched from two groups.
-				 */
-				for (i = 0; i < matched_events; i++) {
-					if (!strcmp(ev->name,
-						    metric_events[i]->name)) {
-						break;
-					}
-				}
-				if (i != matched_events)
-					continue;
-			}
+		/*
+		 * Check for duplicate events with the same name. For example,
+		 * uncore_imc/cas_count_read/ will turn into 6 events per socket
+		 * on skylakex. Only the first such event is placed in
+		 * metric_events. If events aren't grouped then this also
+		 * ensures that the same event in different sibling groups
+		 * aren't both added to metric_events.
+		 */
+		if (contains_event(metric_events, matched_events, ev->name))
+			continue;
+		/* Does this event belong to the parse context? */
+		if (hashmap__find(&pctx->ids, ev->name, (void **)&val_ptr))
 			metric_events[matched_events++] = ev;
-		}
+
 		if (matched_events == events_to_match)
 			break;
 	}
@@ -239,7 +252,7 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 	}
 
 	if (matched_events != idnum) {
-		/* Not whole match */
+		/* Not a whole match */
 		return NULL;
 	}
 
@@ -247,8 +260,32 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 
 	for (i = 0; i < idnum; i++) {
 		ev = metric_events[i];
-		ev->metric_leader = ev;
+		/* Don't free the used events. */
 		set_bit(ev->idx, evlist_used);
+		/*
+		 * The metric leader points to the identically named event in
+		 * metric_events.
+		 */
+		ev->metric_leader = ev;
+		/*
+		 * Mark two events with identical names in the same group (or
+		 * globally) as being in use as uncore events may be duplicated
+		 * for each pmu. Set the metric leader of such events to be the
+		 * event that appears in metric_events.
+		 */
+		evlist__for_each_entry_continue(perf_evlist, ev) {
+			/*
+			 * If events are grouped then the search can terminate
+			 * when then group is left.
+			 */
+			if (!has_constraint &&
+			    ev->leader != metric_events[i]->leader)
+				break;
+			if (!strcmp(metric_events[i]->name, ev->name)) {
+				set_bit(ev->idx, evlist_used);
+				ev->metric_leader = metric_events[i];
+			}
+		}
 	}
 
 	return metric_events[0];
-- 
2.28.0.618.gf4bc123cb7-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8804B29B8BB
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801779AbgJ0PoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 11:44:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801086AbgJ0PjS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 11:39:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 009AF207C4;
        Tue, 27 Oct 2020 15:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813157;
        bh=/qJfFIqkuGpn2Z4BrA17tqg+7OPI9VD2L/aQAI9RoCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcj94eofXIiz76+Yx4DddzDO/CskrR6w2pNi+DEhieFQkrnCCzrhOsTMr2+xO9Ckg
         vqFnouyA7eqxL+pH543jARo97acBVrhjKCkTWvCVcpzhkPiLnnn+4hE8AyUo1b6FJV
         kphstncEMlLiBrp1uJRSc+xEzJ3T22uc2Ese6Dn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jin Yao <yao.jin@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 457/757] perf metricgroup: Fix uncore metric expressions
Date:   Tue, 27 Oct 2020 14:51:47 +0100
Message-Id: <20201027135511.952533635@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit dcc81be0fc4e66943041e6e19a5faf8f8704a27e ]

A metric like DRAM_BW_Use has on SkylakeX events uncore_imc/cas_count_read/
and uncore_imc/case_count_write/.

These events open 6 events per socket with pmu names of
uncore_imc_[0-5].

The current metric setup code in find_evsel_group assumes one ID will
map to 1 event to be recorded in metric_events.

For events with multiple matches, the first event is recorded in
metric_events (avoiding matching >1 event with the same name) and the
evlist_used updated so that duplicate events aren't removed when the
evlist has unused events removed.

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
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200917201807.4090224-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/metricgroup.c | 75 ++++++++++++++++++++++++++---------
 1 file changed, 56 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index ab5030fcfed4e..d948a7f910cfa 100644
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
2.25.1




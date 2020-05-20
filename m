Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F87F1DAC11
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgETH2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgETH2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 03:28:24 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB484C08C5C0
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 00:28:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 137so1007401ybf.7
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 00:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6G0fSxI3Vcpak9tGKbEidiJoDZmPk3JM/oqyp9Fo0xo=;
        b=ODyyex4Rzy3pxNy+CUgufAhEQhGUqPkLPQsj+k8YbHdW8NmnZ1zD58qmmgvj5jQb4D
         KwID3DIX10cBxQJgrl306beaHMIc3OwalV9n/RVfREOycb+4Yb6lctFDjjbPsjmhUt7I
         mo3rzAs1dzm+3wgBlc0/hFc6yeuweJSF+7JglzXqGowe3mO46jrZkojCuIptUGjmmhl5
         QYS5TwNkO5D0rkIoShnzF0WLHTXlFAkNE3HZ7XSumGsKBps9NiUW3BoMp6lg8tKTZ2lH
         5M5LvLPcTIsqOxeXRjkIt9UhUUGzZIMV2iPn65SjW5dcrwd1Cq5G7tTCfzFSTxGoOhC1
         YdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6G0fSxI3Vcpak9tGKbEidiJoDZmPk3JM/oqyp9Fo0xo=;
        b=sBg3AD2o4vx8FuTKjjFHV3qrX+8wAaKXJ/vvZSMOhRfdia+YDgpZcqoAwIxzBxJPO1
         WIHtcx54QtSFR1BTnUUca6fv+Bg0Ubx57851fF45D3zDOQbBfJVbm0goifTVwtStUIk+
         A+UvNqW1nV+HX6QMJWTD7zTHzhVWT+QaY5HGYJfjd6U09xA+/2xZe+ALiyT1ju1a41jn
         DNk50JUpuw/ioynxdrfnuF7bNZTFNCR4Eo7OCDz6EQYwHrqfTdOW6D4GC6cP765bNpbO
         jHzeoNPbnAZzPDjhMfOFDisWoCPxHvKQk2Khx1V9fqlTxkoJpS7XiFQhWPG47TF2SCs7
         ZU2g==
X-Gm-Message-State: AOAM533vUtArg5F3fhgYxcWnn1to/8nmFVO5tDDBA9gzvEnOKg0/j+Po
        p+9P9vbFJYTiuLYG1AAC+Z92QFaDlTHt
X-Google-Smtp-Source: ABdhPJxyHsX6k6DBXml3eqEzdYIAmBQFJVnrLcCwKnVnReYtN08WnRqD+MQ/EL3eTy2jL2AqNA3PmUoVim9I
X-Received: by 2002:a25:bd0b:: with SMTP id f11mr4819800ybk.351.1589959702996;
 Wed, 20 May 2020 00:28:22 -0700 (PDT)
Date:   Wed, 20 May 2020 00:28:08 -0700
In-Reply-To: <20200520072814.128267-1-irogers@google.com>
Message-Id: <20200520072814.128267-2-irogers@google.com>
Mime-Version: 1.0
References: <20200520072814.128267-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 1/7] perf metricgroup: Change evlist_used to a bitmap
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

Use a bitmap rather than an array of bools.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/metricgroup.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 6772d256dfdf..a16f60da06ab 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -95,7 +95,7 @@ struct egroup {
 static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 				      struct expr_parse_ctx *pctx,
 				      struct evsel **metric_events,
-				      bool *evlist_used)
+				      unsigned long *evlist_used)
 {
 	struct evsel *ev;
 	bool leader_found;
@@ -105,7 +105,7 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 	double *val_ptr;
 
 	evlist__for_each_entry (perf_evlist, ev) {
-		if (evlist_used[j++])
+		if (test_bit(j++, evlist_used))
 			continue;
 		if (hashmap__find(&pctx->ids, ev->name, (void **)&val_ptr)) {
 			if (!metric_events[i])
@@ -141,7 +141,7 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 			j++;
 		}
 		ev = metric_events[i];
-		evlist_used[ev->idx] = true;
+		set_bit(ev->idx, evlist_used);
 	}
 
 	return metric_events[0];
@@ -157,13 +157,11 @@ static int metricgroup__setup_events(struct list_head *groups,
 	int ret = 0;
 	struct egroup *eg;
 	struct evsel *evsel;
-	bool *evlist_used;
+	unsigned long *evlist_used;
 
-	evlist_used = calloc(perf_evlist->core.nr_entries, sizeof(bool));
-	if (!evlist_used) {
-		ret = -ENOMEM;
-		return ret;
-	}
+	evlist_used = bitmap_alloc(perf_evlist->core.nr_entries);
+	if (!evlist_used)
+		return -ENOMEM;
 
 	list_for_each_entry (eg, groups, nd) {
 		struct evsel **metric_events;
@@ -201,7 +199,7 @@ static int metricgroup__setup_events(struct list_head *groups,
 		list_add(&expr->nd, &me->head);
 	}
 
-	free(evlist_used);
+	bitmap_free(evlist_used);
 
 	return ret;
 }
-- 
2.26.2.761.g0e0b3e54be-goog


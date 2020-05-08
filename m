Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E6E1CA2CB
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 07:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgEHFg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 01:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgEHFgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 01:36:55 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0459FC05BD0A
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 22:36:55 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id g55so629138qtk.14
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 22:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Nctu/+daGFSzTSwQhLTKLSNlu5IFhHkllWDjdeI4leQ=;
        b=Lc+D+jRWNuHK6kbY+a3EZSsBSkaZvdmcY0LS9V8TH4ctxNRf4DdrAGxPvNWHQ5CVpK
         FtlMI4ZZiU49toz/iF8K+aMytXHdlOPTKJWIS1/1NjALeg+fGWQ+wko9JTmDmbZvGgXQ
         QzPI2mmW/6Jm8Hfr0y23sbcLRr726ouqNXfXO6E7TlpJbVWwhCXACmhbZfCZ/V907GN9
         a36/72deZ6+4rFc7aMDSWXo2u45hDfMkzbZ8DWPgLLF3Z5PZqJJjsDlMOBtNhpBQe6HS
         pLt9nHBJMwSpSzl377fL2Wa1lTtKV9IJpCIASa1yxbuBxiAdXLesWXLS8xthtN7DPjWJ
         T1Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Nctu/+daGFSzTSwQhLTKLSNlu5IFhHkllWDjdeI4leQ=;
        b=lUNt5Mp9LvLTvNAZ5MdbGHDN2dGwBt/tgbbca0FTLo1HBMW1191xispbxOjVUABLio
         4XfWd9wKnnvgZX11jSjDlL6eoA/wsHrKfbFs7EnpelgPLX/bq9egmZMaILLPDpDpttD2
         htAo8kD7hQWBPkpnoWGjhWm9M7HPCRrDCZrG5jEfgn5flMKl6Zb0UzvE8frm6WIVd/rV
         UXvmcykR9nD/WS+mM7Uw/KJQ/h5hmgMii29HpvVQ10Fw4gh8ePWB7Y/8LBXgNpd+xsgf
         J/NAqQM0x+7arN2Ak55sEabBtOQ2plggfTn/MpkVHCDtDxRP4Woqt3IaSkPBkCs93YVz
         +xzw==
X-Gm-Message-State: AGi0PubnCkjaGoh9U1jkzwUZWuP915I5Bjv3fYpRztj+QyNfC3XNJRZ1
        gqIfhY+EJGnX7QQdY3WaVxgIUVIeqn/F
X-Google-Smtp-Source: APiQypL1uvkQ72iK2J8WqG7nY7Hx2FBx6+zfvWI1PN3zCRzvT53dMH1hlsiZU1cCTp5d3kZxJYvsH9OSD+VR
X-Received: by 2002:a0c:efc3:: with SMTP id a3mr1071972qvt.223.1588916214070;
 Thu, 07 May 2020 22:36:54 -0700 (PDT)
Date:   Thu,  7 May 2020 22:36:26 -0700
In-Reply-To: <20200508053629.210324-1-irogers@google.com>
Message-Id: <20200508053629.210324-12-irogers@google.com>
Mime-Version: 1.0
References: <20200508053629.210324-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [RFC PATCH v3 11/14] perf metricgroup: delay events string creation
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
index 2c684fd3c4e3..2a6456fa178b 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -90,6 +90,7 @@ struct egroup {
 	const char *metric_expr;
 	const char *metric_unit;
 	int runtime;
+	bool has_constraint;
 };
 
 static struct evsel *find_evsel_group(struct evlist *perf_evlist,
@@ -497,8 +498,8 @@ int __weak arch_get_runtimeparam(void)
 	return 1;
 }
 
-static int __metricgroup__add_metric(struct strbuf *events,
-		struct list_head *group_list, struct pmu_event *pe, int runtime)
+static int __metricgroup__add_metric(struct list_head *group_list,
+				     struct pmu_event *pe, int runtime)
 {
 	struct egroup *eg;
 
@@ -511,6 +512,7 @@ static int __metricgroup__add_metric(struct strbuf *events,
 	eg->metric_expr = pe->metric_expr;
 	eg->metric_unit = pe->unit;
 	eg->runtime = runtime;
+	eg->has_constraint = metricgroup__has_constraint(pe);
 
 	if (expr__find_other(pe->metric_expr, NULL, &eg->pctx, runtime) < 0) {
 		expr__ctx_clear(&eg->pctx);
@@ -518,14 +520,6 @@ static int __metricgroup__add_metric(struct strbuf *events,
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
@@ -536,6 +530,7 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
 {
 	struct pmu_events_map *map = perf_pmu__find_map(NULL);
 	struct pmu_event *pe;
+	struct egroup *eg;
 	int i, ret = -EINVAL;
 
 	if (!map)
@@ -554,7 +549,8 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
 			pr_debug("metric expr %s for %s\n", pe->metric_expr, pe->metric_name);
 
 			if (!strstr(pe->metric_expr, "?")) {
-				ret = __metricgroup__add_metric(events, group_list, pe, 1);
+				ret = __metricgroup__add_metric(group_list,
+								pe, 1);
 			} else {
 				int j, count;
 
@@ -565,13 +561,29 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
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
2.26.2.645.ge9eca65c58-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605FE1C8DDE
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgEGOJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728339AbgEGOJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:09:06 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05260C05BD0B
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 07:09:06 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id r14so7038151ybk.21
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 07:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=37IhcnJ8/vjmrEBEbWQ5EKKAlYXyNL6TpEjB8zoBU+I=;
        b=EkuVilh9AmFXC3HpM+g1JVFE/YiLk2H9zDSDHs4rsZVdSYf0ZYS73iyFXwUgWgSu82
         QyUlZcOC1uk650y9TCYYPzENRfelJkos/eEoAi7FdJ1gTpXaA7dKBa5xposcjk0T46WA
         Eas0pEFm2fJjKH5ekMVAFZhAAmBb0Epl4Ipk5PctQTBbQzmBQdzhtJffM8F4yIo0HAem
         oxrRg5fQX8XwD5ezbWOx78Yd0T3JZYFXlxeQF5/fEqm5/dvySJ6YOEYs2Kc3YeTpf0Mp
         PSXVKXE9/s9UOThUIDJtdUZ1GJoKk/ym/60XbdgSIVCoU5lu7/ZbbM2DgpzeN4RitTCF
         M7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=37IhcnJ8/vjmrEBEbWQ5EKKAlYXyNL6TpEjB8zoBU+I=;
        b=TT7N/ZxNURlu74q5Nt5MM6qLVj5IGSBZualbwMd6Thj4ygr4r6/2ozP/4LnnFFLEVq
         xZiFR8npxgdzIjBZX0FlcxjBU9o0rsBVGNfz1+Z/ajcfUJTwmwq5KJhPS3S1/xHLKAHf
         L83HOBEXC29SuDsTVt4vm/d2cKWyFl/ZgWGZtjn2+7mfQxDR8fLpfioE55yTirIaTFjN
         m3OCC/gTrhkYg7sb1OcFn1qmQbb4gk2ZFLJrGcq/adFnlDiZMItJrqRDE0DAn3S7K5fq
         t+RFs0q0zExWH8R232/DMpfTuslPPrMz/2MeuCCIbi6rdmGErygf4eglE8ugha0Fp0O8
         KRnA==
X-Gm-Message-State: AGi0PuZK1vv7BMQmQpIShmnQ2lwsTvI0jItFaDimtAs/IEKtl7t+eXsx
        Iq7UqtzPiUBBDj+1YuE8Tacc2ht0geYL
X-Google-Smtp-Source: APiQypI+kE8+9TaK+MPhl7ecJ7TGimRuXG1CdkjPVyquiC9PvV3bNOhLRbsQRbAaRq1MFzkROoqcVorTCLxy
X-Received: by 2002:a25:9c47:: with SMTP id x7mr22370139ybo.258.1588860544978;
 Thu, 07 May 2020 07:09:04 -0700 (PDT)
Date:   Thu,  7 May 2020 07:08:17 -0700
In-Reply-To: <20200507140819.126960-1-irogers@google.com>
Message-Id: <20200507140819.126960-22-irogers@google.com>
Mime-Version: 1.0
References: <20200507140819.126960-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [RFC PATCH v2 21/23] perf metricgroup: delay events string creation
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


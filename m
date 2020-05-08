Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0B71CA2D1
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 07:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgEHFhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 01:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgEHFgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 01:36:53 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2326C05BD0B
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 22:36:52 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h185so774884ybg.6
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 22:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0QS1YqAYu664zYAVy5D9As+p1Vggn2+qgtokmxG8BMQ=;
        b=WdaMO2k2Y5pTljLKBJ0d+Y2TyM+fRid8W+wbZXFfMKUEmpNUE66nlFIgfWEtFPAr7L
         CqOKVwmwFYYlMF56xmSj5qCNhwYVnaRoUBy4pQUNYdHJsWcs8c3JahIOuVgpIz2UcSQb
         82foWpW+AbFOOZpv2wCDJ0VZ6yWEgeoa3MDgb0c75ADt33hDUr2YKSlALKJCG4viXCoC
         AsR+VbfVak6o1lcWU78xIIR+SoOKJ7RM6N6ma5tNRUfR43R9WF+1LC/RSIMZIEdDWlGO
         TMOBH3b/anKG9yG4krGWerI0oEC9haNtALFX4AWIw+/B+DhKdCYovPJTGDGCXOM59qz8
         WENQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0QS1YqAYu664zYAVy5D9As+p1Vggn2+qgtokmxG8BMQ=;
        b=WC+8eOwaHMuTcMJLR6/5tUsNe9XqhrBlk/vDzKAz6Zmadth8dthe3a3SW0aYVM94qG
         UhP/FIO0rcaCRAi6+PfW2qRduAOBXVZ+myTXAlPHbeSKnuSTtGIjXRDMNDJyFRAB9WKh
         HvA4TQg5Fu3DA1oPjoyxILiG04VNLFsCidXhMY8S1Y6nGx64HWhyhhmAaaiL+LR2RLpo
         Z3XbBdOo2mojxIcufFW+HHiBohxF02UFkKtTbm8JCY+e1hOaHY5F5FzcBzmbUA1fOScs
         8zdFHDJ6z6ALQKKcpCOGSXQ2hZ5gofgwSDqWktaQca4vPPwhmcv2x60tXckIuDl9qcO/
         JXRw==
X-Gm-Message-State: AGi0PuZYvvaY5rnGMWXN0WldOCFt1xmEddxBJJlDYDokAQjO6Ify4jMi
        LY9JtzybvrelAgrKvaU6RS1fQmIzCcqn
X-Google-Smtp-Source: APiQypJZ1+AqbfI+DjYgGYUs8urHT8j/MAgFPXvDoBMlgIUUiGiZxajQ4j6lYMcy7FGwHS6i6iEAD8GBx66/
X-Received: by 2002:a25:cb17:: with SMTP id b23mr1959004ybg.515.1588916212125;
 Thu, 07 May 2020 22:36:52 -0700 (PDT)
Date:   Thu,  7 May 2020 22:36:25 -0700
In-Reply-To: <20200508053629.210324-1-irogers@google.com>
Message-Id: <20200508053629.210324-11-irogers@google.com>
Mime-Version: 1.0
References: <20200508053629.210324-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [RFC PATCH v3 10/14] perf metricgroup: always place duration_time last
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

If a metric contains the duration_time event then the event is placed
outside of the metric's group of events. Rather than split the group,
make it so the duration_time is immediately after the group.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/metricgroup.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 7e1725d61c39..2c684fd3c4e3 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -422,8 +422,8 @@ static void metricgroup__add_metric_weak_group(struct strbuf *events,
 					       struct expr_parse_ctx *ctx)
 {
 	struct hashmap_entry *cur;
-	size_t bkt, i = 0;
-	bool no_group = false;
+	size_t bkt;
+	bool no_group = true, has_duration = false;
 
 	hashmap__for_each_entry((&ctx->ids), cur, bkt) {
 		pr_debug("found event %s\n", (const char *)cur->key);
@@ -433,20 +433,20 @@ static void metricgroup__add_metric_weak_group(struct strbuf *events,
 		 * group.
 		 */
 		if (!strcmp(cur->key, "duration_time")) {
-			if (i > 0)
-				strbuf_addf(events, "}:W,");
-			strbuf_addf(events, "duration_time");
-			no_group = true;
+			has_duration = true;
 			continue;
 		}
 		strbuf_addf(events, "%s%s",
-			i == 0 || no_group ? "{" : ",",
+			no_group ? "{" : ",",
 			(const char *)cur->key);
 		no_group = false;
-		i++;
 	}
-	if (!no_group)
+	if (!no_group) {
 		strbuf_addf(events, "}:W");
+		if (has_duration)
+			strbuf_addf(events, ",duration_time");
+	} else if (has_duration)
+		strbuf_addf(events, "duration_time");
 }
 
 static void metricgroup__add_metric_non_group(struct strbuf *events,
-- 
2.26.2.645.ge9eca65c58-goog


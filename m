Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594411DBCAA
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgETSVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 14:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgETSUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 14:20:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FE3C05BD43
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:20:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 5so2625105ybe.17
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pg8X3zsQYx36UMQsRQzJQNRzKxV0haL9XJi6KY3pltg=;
        b=VBmrZvCCpRZVw1T00v/lESnT7gpttLx7jwELUa4fEJrn+8/2Qq2iBQEZgVtggT3VpY
         oZjN4qja7wDJO/zdNXgBwIUSdj1m+WWHmrOHth5G5BXVE7IIu83QLP7zROmuGAotOer+
         qixha/bEOroun3NqM9wWI2EB94vwbuJ6tQdUC3py+QuhMajVTXUpxbfku/4qjJY5j6WM
         BteNzNNVPYViB4OGzMKxxlwXAWoaDLecZFdaHaj1DkWN0+62sXbuFUkhgJzey7XjgpoD
         95R1tIP9t5kbtyo4sZfSJ7tfZAcunS0EXb7v3z4FXlXuWc5SQjl5og0y5tFfKRUxuJcw
         K4RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pg8X3zsQYx36UMQsRQzJQNRzKxV0haL9XJi6KY3pltg=;
        b=ZBDupxsKGoqIt+7bgnswTGGU0PVVf2yWuBM+RnXK9H7hUljzmh9KeHDdq3Lo/iPYM4
         88blVxLmmohQNw02rUmOTrO+M9nfN8JplkK+cbwxyd/OXyWTPu4lbr0cMVTMsnRXnzSU
         VhwJdkHUHIO/7Ww5BaTPjuQ5fwmUazgIEv+fgdzJUqhHzXBWXIiMwKYtU3BNph4bZTHN
         E5Tq2nxalGsVbTx6hEEY6VcOSTCPaM5d1rPbKmBkrxNLHs15hqincKPehIzXbf67HVPc
         cYtbtb/m1B5hQooEC+fh6jRpsFO/AyQ/hQVw0bI+GLY14sVBA/1mQa9Dm+eX8vy9XiKG
         Vahw==
X-Gm-Message-State: AOAM533zY+PL7gA8wtP2eEcuRDULXqY6gay+R62F1K2tYGOL6RJIwR8S
        LowPLqNu5VkFxRnzkKmSVHyXej7OxzwX
X-Google-Smtp-Source: ABdhPJxXHOCLByEfiE0YgbrkzsO6F5SEvxAk7PYQaNFmnyIGcAQwXMWYQqMTZjQYQw78N+QHO0iimvN0QFh7
X-Received: by 2002:a25:9805:: with SMTP id a5mr3939790ybo.26.1589998820800;
 Wed, 20 May 2020 11:20:20 -0700 (PDT)
Date:   Wed, 20 May 2020 11:20:05 -0700
In-Reply-To: <20200520182011.32236-1-irogers@google.com>
Message-Id: <20200520182011.32236-2-irogers@google.com>
Mime-Version: 1.0
References: <20200520182011.32236-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH v2 1/7] perf metricgroup: Always place duration_time last
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

If a metric contains the duration_time event then the event is placed
outside of the metric's group of events. Rather than split the group,
make it so the duration_time is immediately after the group.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/metricgroup.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index a16f60da06ab..7a43ee0a2e40 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -410,8 +410,8 @@ static void metricgroup__add_metric_weak_group(struct strbuf *events,
 					       struct expr_parse_ctx *ctx)
 {
 	struct hashmap_entry *cur;
-	size_t bkt, i = 0;
-	bool no_group = false;
+	size_t bkt;
+	bool no_group = true, has_duration = false;
 
 	hashmap__for_each_entry((&ctx->ids), cur, bkt) {
 		pr_debug("found event %s\n", (const char *)cur->key);
@@ -421,20 +421,20 @@ static void metricgroup__add_metric_weak_group(struct strbuf *events,
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
2.26.2.761.g0e0b3e54be-goog


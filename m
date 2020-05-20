Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5F71DAC0F
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgETH2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgETH23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 03:28:29 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E7AC08C5C0
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 00:28:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v1so1010430ybo.23
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 00:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pg8X3zsQYx36UMQsRQzJQNRzKxV0haL9XJi6KY3pltg=;
        b=IFsBVZVLPNRULbE6YYRGkUm9WJ5b6ZkW+NDQK7kKTrzGDrri4yLsgAxoIcujJbtyn1
         sCqcgKrfPHW+BUF4AR7bN0sYsha93tqft11ntBzTK/LM7LQQ1PPNQdTSe0ZlQ3Ovej/D
         jGuSAP9/b/yGJCG8MtEHWjya9IVzKIBbh5ery1GKshTGhTHeRrLawlWRsgedy09QWwdX
         gVPbNYY6sZdrpRVbeUSn8zgIxBypbgHK71ceT/ZGWi6Xz4wKYJc/Qv6MVQnR183eJcrt
         gb9mcg5iMILoLqc3QUxysv1ilFc18koA4DuV9KRUWjlORirdy6Q9ijku3RKWOA1NH2zA
         jdhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pg8X3zsQYx36UMQsRQzJQNRzKxV0haL9XJi6KY3pltg=;
        b=VWxSS8pa4zBlgYRRLD9gF6UqkKOzUQpvD1r3T0M6GbBSWfvixZe73dm0D4M0jyogaV
         5euljlgI2N2SNv24Uz4zzviJUX1DTcdTWgxznDrK8Lv/K5dUOOG3QNLG0HkjBNBgR7QW
         HtkHQU0Mrc2U2bVsEN5OLFR6joT8/QCs4hlQIsTmyKtRQGbAuUqL5xGIVsWxi0Mi9Tg5
         jmPICupiiHX3QEl7EDDa9LEhs9/tqE1wQySm+66rZtizNvPaO0fNbdRfisj+NxTjT+22
         /SP/NOxsVWkRYqXTYTiR0Aq8+B0s8FAWxv1blG1hrV+2t/+zm8TVphM++4FEM+LBZaQE
         wF0g==
X-Gm-Message-State: AOAM532iy0FKz9yUSwy4cR+Sv5NVIKvczV4as6WzgPwq1oyIvlP3Kc/O
        Ag2Oe+c66vEbNkKpfvY30clElj4ZW5+1
X-Google-Smtp-Source: ABdhPJyyzwNekVBx1x6MqUBBsMhf9BSK8uRhitcUQ2Zfj9uqwbF9oil4MwNf1a97+WAkaMeiHsxsXPoe2WYF
X-Received: by 2002:a25:8012:: with SMTP id m18mr5146740ybk.123.1589959705364;
 Wed, 20 May 2020 00:28:25 -0700 (PDT)
Date:   Wed, 20 May 2020 00:28:09 -0700
In-Reply-To: <20200520072814.128267-1-irogers@google.com>
Message-Id: <20200520072814.128267-3-irogers@google.com>
Mime-Version: 1.0
References: <20200520072814.128267-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 2/7] perf metricgroup: Always place duration_time last
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


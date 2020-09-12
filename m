Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BB5267751
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 04:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgILC5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 22:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgILC5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 22:57:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9E0C0613ED
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 19:57:03 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 125so10865914ybg.12
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 19:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=S4BaSChoStuXn9hUjRtFrVEEliba+K91i8IvE/c8cWU=;
        b=pbPv6LoTFW9c9cgb1mIWL4TXAnmXnBP3zMCzGQT4KcZ4LkRTO9zyobxhuDAdLt0TLE
         Nf1zhQ2urZmVZga/imCGWFsImzFGhh6+S+JaXaQcSGRYYrxkWL1AqCEbSl7KKx30WL3x
         yhOQc/Qie9pC/KVnW+0U0CiC77suqzpyNuyTROVWMr7I977yEQiJsRYTlZ/w/t4GRHKM
         ctc2pp4bDM95NZAQnaMu/6SrTSGPpk6sEFIZi27286exnQw3qHUd4zxS4cK0dP8K4PCe
         ylkq0AvTJRbEV6nXKPYGWOv358H0PRerHbQOAuA7vrcfOAFxqf3ebJ4BYlcUpRSKSHyh
         6NXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=S4BaSChoStuXn9hUjRtFrVEEliba+K91i8IvE/c8cWU=;
        b=LotmtDWxlX8X365pfQDGeNx7vd1WLHpnaQXAZBcvq4Vtrji5WZhFHWuB2yLcQC8ZJ5
         +g1q9HKZQqOyckG5LN1Kqk5wc6sV8WMcc46W3oAWaKUZ1pOoiucPUE1smKeun7mZS+xO
         /VMnCAbfQDnsbXd+52I2nUZgmLBwhGBcAlSgMK+arRXkODSQUl7hxCTk6s2Bb3wkt2w4
         skquiw8UdCPurkqXu035fvQB9Y51xBsn62TZ2/7cXhk/lv2U+2rjoHGTQjRVeAkk17RK
         QFnxElLrH+V/WaTk9BmUX9lEYuqWuNwnLbuh8+nd3Dta6syPhh6M4Hn5YcnL1GmYBm5E
         dqTg==
X-Gm-Message-State: AOAM530ETcv4P0O7EsaVrbejY1qWQ0JoFFyRUS7InMjQ+HZwXAYg2E5B
        CLrqyk6ddH0jFN19fVw0oXyzPwWHI01v
X-Google-Smtp-Source: ABdhPJydvl5bZ5owq66oiX1WfPkpW16l0ovIc+lZVj9SuIGZawWsXOZx4KTvhzIJFWyCEUS5CSvNOxz6miJL
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:2:f693:9fff:fef4:4583])
 (user=irogers job=sendgmr) by 2002:a25:5096:: with SMTP id
 e144mr5872381ybb.32.1599879422845; Fri, 11 Sep 2020 19:57:02 -0700 (PDT)
Date:   Fri, 11 Sep 2020 19:56:54 -0700
In-Reply-To: <20200912025655.1337192-1-irogers@google.com>
Message-Id: <20200912025655.1337192-4-irogers@google.com>
Mime-Version: 1.0
References: <20200912025655.1337192-1-irogers@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v3 3/4] perf record: Don't clear event's period if set by a term
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
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If events in a group explicitly set a frequency or period with leader
sampling, don't disable the samples on those events.

Prior to 5.8:
perf record -e '{cycles/period=12345000/,instructions/period=6789000/}:S'
would clear the attributes then apply the config terms. In commit
5f34278867b7 leader sampling configuration was moved to after applying the
config terms, in the example, making the instructions' event have its period
cleared.
This change makes it so that sampling is only disabled if configuration
terms aren't present.

Fixes: 5f34278867b7 ("perf evlist: Move leader-sampling configuration")
Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/record.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index a4cc11592f6b..ea9aa1d7cf50 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -2,6 +2,7 @@
 #include "debug.h"
 #include "evlist.h"
 #include "evsel.h"
+#include "evsel_config.h"
 #include "parse-events.h"
 #include <errno.h>
 #include <limits.h>
@@ -33,11 +34,24 @@ static struct evsel *evsel__read_sampler(struct evsel *evsel, struct evlist *evl
 	return leader;
 }
 
+static u64 evsel__config_term_mask(struct evsel *evsel)
+{
+	struct evsel_config_term *term;
+	struct list_head *config_terms = &evsel->config_terms;
+	u64 term_types = 0;
+
+	list_for_each_entry(term, config_terms, list) {
+		term_types |= 1 << term->type;
+	}
+	return term_types;
+}
+
 static void evsel__config_leader_sampling(struct evsel *evsel, struct evlist *evlist)
 {
 	struct perf_event_attr *attr = &evsel->core.attr;
 	struct evsel *leader = evsel->leader;
 	struct evsel *read_sampler;
+	u64 term_types, freq_mask;
 
 	if (!leader->sample_read)
 		return;
@@ -47,16 +61,20 @@ static void evsel__config_leader_sampling(struct evsel *evsel, struct evlist *ev
 	if (evsel == read_sampler)
 		return;
 
+	term_types = evsel__config_term_mask(evsel);
 	/*
-	 * Disable sampling for all group members other than the leader in
-	 * case the leader 'leads' the sampling, except when the leader is an
-	 * AUX area event, in which case the 2nd event in the group is the one
-	 * that 'leads' the sampling.
+	 * Disable sampling for all group members except those with explicit
+	 * config terms or the leader. In the case of an AUX area event, the 2nd
+	 * event in the group is the one that 'leads' the sampling.
 	 */
-	attr->freq           = 0;
-	attr->sample_freq    = 0;
-	attr->sample_period  = 0;
-	attr->write_backward = 0;
+	freq_mask = (1 << EVSEL__CONFIG_TERM_FREQ) | (1 << EVSEL__CONFIG_TERM_PERIOD);
+	if ((term_types & freq_mask) == 0) {
+		attr->freq           = 0;
+		attr->sample_freq    = 0;
+		attr->sample_period  = 0;
+	}
+	if ((term_types & (1 << EVSEL__CONFIG_TERM_OVERWRITE)) == 0)
+		attr->write_backward = 0;
 
 	/*
 	 * We don't get a sample for slave events, we make them when delivering
-- 
2.28.0.618.gf4bc123cb7-goog


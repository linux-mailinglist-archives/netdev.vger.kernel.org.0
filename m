Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E444E5362
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733243AbfJYSIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:08:49 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:57010 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733205AbfJYSIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 14:08:47 -0400
Received: by mail-pg1-f201.google.com with SMTP id u4so2326974pgp.23
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 11:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ozw9D+vclIFM2icN5y6LJ8c4+4sMg5YbQ5WcIa5mPKI=;
        b=lTwv/eB1vvUrtK55Es+3jXhBGjnnYgmNWQK59Qb/+YzRNjqlhFS3AYPxqPH4v1iXi5
         eprA7oVUZ5OKMWCbnQ9m0qyj2I+eV8HltanVFKk3jKF8zieUgcjaJjFvZt1rOCzRZx58
         qommgWmHtuXi1KvnF8HhzO6l+0SPG5Aiyrjpcaekl4bCNMhMJSNyOMlRr+5i0mayny0/
         K4XLHkUMuoTOsLa8iYrtm30WMINkAmKuaUtTGvpBP9T+PtzjAZgciGR4zssanoipDQOt
         kZ/LBQyEqgDQYtBsojKIXrIquVaKqm3Qjng2pB10Lz5obqWKr0tfQ8Wcs+ap/waXBSlv
         2nPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ozw9D+vclIFM2icN5y6LJ8c4+4sMg5YbQ5WcIa5mPKI=;
        b=NqYAX7CEtpZzy9T0ZflZ2bOwKf9wiKhy3Ju0+722uQokg4hQKkBwNHeiVYTgRxoRa6
         IZvNpFmmVSRuwjBqBA2/ZQ3AzGkIXlHTkVn72FkWSA8OVh09GVkJEcOycDI/OeN0AoUY
         OdgxxC59uq+izlJiQPGB5G76LyxHJJ2ndTHPjSU15ajWhD90/+FLG3HbTNXDUj8CPv0J
         x9nIjxEEMmzUnQKy/Zdj98CjcqBcCXUauxzMYeV/dJoT+P42SLtdd3rNXPXQXV9OajIR
         JNckQptMVnTBgdc3D0JeFQyH/TTHUh2BTacbAm57OM218CVa0/15SuSSbNuz6ZBN1xtM
         Itag==
X-Gm-Message-State: APjAAAU85IKcMspIahRvY5/MJ7UiKVT/UPxuQHx/gmTeLCvWTgRfQNJB
        0Dr/JJ6uuSpfbYx9tB90XncyTeuRk86d
X-Google-Smtp-Source: APXvYqx33NkWbQAkNP63ERssM3E3pdl09Lr04Jhh9Vw9pwW28jHSa68V3TMfScFCvranyOLpFs5J5pnqED1o
X-Received: by 2002:a65:53ce:: with SMTP id z14mr5963399pgr.445.1572026926291;
 Fri, 25 Oct 2019 11:08:46 -0700 (PDT)
Date:   Fri, 25 Oct 2019 11:08:22 -0700
In-Reply-To: <20191025180827.191916-1-irogers@google.com>
Message-Id: <20191025180827.191916-5-irogers@google.com>
Mime-Version: 1.0
References: <20191024190202.109403-1-irogers@google.com> <20191025180827.191916-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v4 4/9] perf tools: splice events onto evlist even on error
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
        Andi Kleen <ak@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If event parsing fails the event list is leaked, instead splice the list
onto the out result and let the caller cleanup.

An example input for parse_events found by libFuzzer that reproduces
this memory leak is 'm{'.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/parse-events.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c516d0cce946..4c4c6f3e866a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1952,15 +1952,20 @@ int parse_events(struct evlist *evlist, const char *str,
 
 	ret = parse_events__scanner(str, &parse_state, PE_START_EVENTS);
 	perf_pmu__parse_cleanup();
+
+	if (!ret && list_empty(&parse_state.list)) {
+		WARN_ONCE(true, "WARNING: event parser found nothing\n");
+		return -1;
+	}
+
+	/*
+	 * Add list to the evlist even with errors to allow callers to clean up.
+	 */
+	perf_evlist__splice_list_tail(evlist, &parse_state.list);
+
 	if (!ret) {
 		struct evsel *last;
 
-		if (list_empty(&parse_state.list)) {
-			WARN_ONCE(true, "WARNING: event parser found nothing\n");
-			return -1;
-		}
-
-		perf_evlist__splice_list_tail(evlist, &parse_state.list);
 		evlist->nr_groups += parse_state.nr_groups;
 		last = evlist__last(evlist);
 		last->cmdline_group_boundary = true;
-- 
2.24.0.rc0.303.g954a862665-goog


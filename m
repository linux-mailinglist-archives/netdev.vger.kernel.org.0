Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055042305ED
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 10:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgG1I6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 04:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728348AbgG1I5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 04:57:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCAAC0619D4
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 01:57:41 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p138so796626yba.12
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 01:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nX/1NZr6qGhnB5fWEWRCVFU3/TmZaNj5LyMINF6iah8=;
        b=C4tiQ/JT4wpELCImOIwKNla4CWq4rVq7GmsYOkdbWLzvQnBGSN4ijrmKf5muLUqYz8
         QmG3Ayk33QBbjyPb8paRmHGAXlk/hn8rTu2TrBDgLGf53y3CBIIn3egYYyyp+RfznFcS
         7w1/DVrHHiSuzQSLMyA19FiSV4WSuMIlXwjMuP7HrY2nnYMhRu/Wa4qxV9Ll8rcKj5YX
         00SJozfC5ObsHV1GrOM2Nz0HnrTvx0sFZVhLI2JSDo1ZBaZ/EiEvQRhdJXW2zIfhGPbG
         ZK3CalcCoZpL09BOij3aGTD+Kg+X1MnMthWMyx6FOQjinVuoC35As1iBvJqRZ5zVk561
         Jh9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nX/1NZr6qGhnB5fWEWRCVFU3/TmZaNj5LyMINF6iah8=;
        b=VBUtt5QNgZuUIkmi0ipxN7V2jFskzW1oEmZEEYajT6U7wHFfIHWb/Apm0hsJE8tg3g
         a7aXjGWdBfX7kwOxGzqgM4/HV+JrXmcD4zl4QuLt35PmQi4nMUIY+FqTlyDyjAlDhSeJ
         PzeAsqBWXeqlpqlLt8qce76bv+bey1bUdXYNJ+Wg3uCfwO/2tdRGIXMOYPdnhjqXyB/Z
         H5BqaUwlY0ZalcJ5XmyDKQEwD3Dh28Cuk+8uattknIGBj8+WYiZPcx8ufk7fq9Nvr+2g
         pN0gqsOUoVn4S/hUea7gS3kiTU+n38DQ+uiHnqYYmzoF3ThWGMB4K0SikjCEpekGGoqS
         WhVw==
X-Gm-Message-State: AOAM530zqJ/Qv0vIdbDi2OBQ6PAQysng7MUnmbNynbh09Mac26ioY7Q5
        M0fF9zZroNjK+5UffT68YyWMDN1VssvV
X-Google-Smtp-Source: ABdhPJx8NSGF6mLTqzK5ekC5JPY7ACRycIrYng7z5LWrxFWN5dAz7vMCOxEpNCM7jbecgVk7PHTKckyA7kiD
X-Received: by 2002:a25:d745:: with SMTP id o66mr19987184ybg.116.1595926660128;
 Tue, 28 Jul 2020 01:57:40 -0700 (PDT)
Date:   Tue, 28 Jul 2020 01:57:31 -0700
In-Reply-To: <20200728085734.609930-1-irogers@google.com>
Message-Id: <20200728085734.609930-3-irogers@google.com>
Mime-Version: 1.0
References: <20200728085734.609930-1-irogers@google.com>
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH v2 2/5] perf record: Prevent override of attr->sample_period
 for libpfm4 events
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

From: Stephane Eranian <eranian@google.com>

Before:
$ perf record -c 10000 --pfm-events=cycles:period=77777

Would yield a cycles event with period=10000, instead of 77777.

This was due to an ordering issue between libpfm4 parsing
the event string and perf record initializing the event.

This patch fixes the problem by preventing override for
events with attr->sample_period != 0 by the time
perf_evsel__config() is invoked. This seems to have been the
intent of the author.

Signed-off-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/evsel.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 811f538f7d77..8afc24e2ec52 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -976,8 +976,7 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
 	 * We default some events to have a default interval. But keep
 	 * it a weak assumption overridable by the user.
 	 */
-	if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
-				     opts->user_interval != ULLONG_MAX)) {
+	if (!attr->sample_period) {
 		if (opts->freq) {
 			attr->freq		= 1;
 			attr->sample_freq	= opts->freq;
-- 
2.28.0.163.g6104cc2f0b6-goog


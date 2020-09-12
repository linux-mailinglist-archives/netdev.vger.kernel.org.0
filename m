Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4F126775B
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 04:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgILC5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 22:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgILC5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 22:57:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF9BC061796
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 19:56:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y6so15592ybi.11
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 19:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=JjLhvyF9iMwelIcaw0DBsu//Y1+/ZRLd9VReK2mwSGs=;
        b=cEuaKFtvziVsuhVvQm/MR9FV9+QVZlR9FW5IU+nia4FDj/qXfvp6uzCu734+nn4QQW
         nzF3mMWnA9wzXvXef021Ejg1zSdN+eXgjWdpqR/0hXCy9p+k28u0yiIMa75YaOkqlD84
         ZETk+umBq/6+72xE21jwKbBMDK3GbO4Pt5g0oD0NGp/bX512d2oJlTSfHp59Ffzm6Z4f
         3J1qFgWluIsOtMbusuaXSBgUjQ2dIuF859kOnyZzAYfiFwuYbxwjcYHNTy5iu2j9YCpk
         ZFQbbCNARJlNVVsnesgFR29Ioho5jW4Op21MZTxVxAhvESXqEqWRxVZOcYAkNL1Hv7B/
         I6LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JjLhvyF9iMwelIcaw0DBsu//Y1+/ZRLd9VReK2mwSGs=;
        b=tGL0zNZQ9GF/T2MX+syF+YRZGu3BvREn5kJRSuqTTTw4ESObAbSUDyF8GSojDrKtws
         BIOZkaBTB6JDg1aw6As6XbAzCzjBV3jyciUvJ10cT9VnOxx9y7UOdbrXDnncGNSTL5AZ
         oIADNSXiVhuczn9xg/qGJz5Qw9+Ad4yorvCEWHzy8wySbMZl++OwthsZMN/dJc1ELo0x
         Frk2v9z4oLNKyEGynpA1FQrMmuI4aNC5KGk/yluA3vkJInu9VKVFS95kFeh7Km5ePu40
         vPzYOyoTn00n1mVpEbs4L7JRZlfGkRSL54SO1UCh9FHGPshqvCtHTg8c0wkh+1wbiLMi
         tsvg==
X-Gm-Message-State: AOAM533pRUj8f4lkyUBmM7BT3+vddDs9FfOf6W19t6ok/cbvh2P868Zi
        zLiwE/LRQBpuUgFoRKb7OGaCOUiNQfku
X-Google-Smtp-Source: ABdhPJz3ff6ZAhAaEVz80+FABBEVLhzUutcRr/Uhs+2mnjS21WRcmYL5tmOf4eZWJ+py9c5W+hUwdj339FiU
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:2:f693:9fff:fef4:4583])
 (user=irogers job=sendgmr) by 2002:a25:dcc6:: with SMTP id
 y189mr7066582ybe.178.1599879418975; Fri, 11 Sep 2020 19:56:58 -0700 (PDT)
Date:   Fri, 11 Sep 2020 19:56:52 -0700
In-Reply-To: <20200912025655.1337192-1-irogers@google.com>
Message-Id: <20200912025655.1337192-2-irogers@google.com>
Mime-Version: 1.0
References: <20200912025655.1337192-1-irogers@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v3 1/4] perf record: Set PERF_RECORD_PERIOD if attr->freq is set.
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
        David Sharp <dhsharp@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Sharp <dhsharp@google.com>

evsel__config() would only set PERF_RECORD_PERIOD if it set attr->freq
from perf record options. When it is set by libpfm events, it would not
get set. This changes evsel__config to see if attr->freq is set outside of
whether or not it changes attr->freq itself.

Signed-off-by: David Sharp <dhsharp@google.com>
Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/evsel.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index fd865002cbbd..3e985016da7e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -979,13 +979,18 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
 	if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
 				     opts->user_interval != ULLONG_MAX)) {
 		if (opts->freq) {
-			evsel__set_sample_bit(evsel, PERIOD);
 			attr->freq		= 1;
 			attr->sample_freq	= opts->freq;
 		} else {
 			attr->sample_period = opts->default_interval;
 		}
 	}
+	/*
+	 * If attr->freq was set (here or earlier), ask for period
+	 * to be sampled.
+	 */
+	if (attr->freq)
+		evsel__set_sample_bit(evsel, PERIOD);
 
 	if (opts->no_samples)
 		attr->sample_freq = 0;
-- 
2.28.0.618.gf4bc123cb7-goog


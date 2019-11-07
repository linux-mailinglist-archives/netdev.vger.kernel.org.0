Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE86F3B23
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfKGWPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:15:23 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:42782 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbfKGWPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:15:05 -0500
Received: by mail-pl1-f202.google.com with SMTP id 30so2692573plb.9
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 14:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AdCqemr3Cpf7H//3sUI2jx4nwjMA/tcTnOzbDM/nvC0=;
        b=jrQORgPzeZELMCAxvGhKK+LNKIHx0lR7EPWzROuGYaZ+8MQcE47ixHonnM93zYy6Bb
         nqX5lHMzBwuMZf0i1kUDabzHy8kdEY46PjxcAApEcS91vHsUB6MfoINBzDy2G4B5wHaR
         HoXGNztVqF4MNmFNLonRL2ICkbGLFEhkXxnmnsKhAZyejQg+RxxIiKY7wNzIIewoeyCq
         THAE+F2X5AyEIIUIWWoU8vmV7zRhdAMlzpBlaCPqBwkFWjmJdNttL/Tlsua/9W6NL0JO
         f51/JAkOljq+y3t/Fd5eL9Rf/ZbXtyvMoyjb0iBJ/vFzTQOG4qe1MRJAyPoRNrzWYIp5
         rs2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AdCqemr3Cpf7H//3sUI2jx4nwjMA/tcTnOzbDM/nvC0=;
        b=lb6NpNM2dRS20nSxms8KrHKAcX2N7vtHrCFX8UNu6SKSlGeIfsNnuvheiejcE1/VRo
         SsAoZYcSiNZ22L6iJRLJ5db+ebzK4qW+58fvk2GByE3mZWos5njOQpmX96Q8LP4hsOhO
         Ys8AZg17F/Fmj96FYq29ws7fUn8delOQtqWRgRmJvaqgLVzj1eJPbHYW1tFpRVq6U+uB
         jsiw8ytZt3IidbWcCyYC/woXx3xW76otG2d+15GfTB4a1RnOjq89NTt9W8tPdQEjRfpQ
         7svGhv8L6z4PD0+tVj6F0+oSiTViEZyCg5/YQPsdyv5FRNoXnCudzykDcuBeLmUDmJ+u
         wCgw==
X-Gm-Message-State: APjAAAVHdYrpDRTyb+rThjjyOM75XfIreTdcSlinGzPPYlqY5Q49TGaH
        HgVkLgVb0Hl70crx7SNtsPFTrxy9R8Qk
X-Google-Smtp-Source: APXvYqz/rkI814x4MOw4cAa7e4QfcUS64HmMtxPkZptIuD8Y+rQW1uOQ0spijoWFfSm8En8eJae60a5ns/vv
X-Received: by 2002:a63:5848:: with SMTP id i8mr7445484pgm.217.1573164903292;
 Thu, 07 Nov 2019 14:15:03 -0800 (PST)
Date:   Thu,  7 Nov 2019 14:14:26 -0800
In-Reply-To: <20191107221428.168286-1-irogers@google.com>
Message-Id: <20191107221428.168286-9-irogers@google.com>
Mime-Version: 1.0
References: <20191030223448.12930-1-irogers@google.com> <20191107221428.168286-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v6 08/10] perf tools: if pmu configuration fails free terms
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

Avoid a memory leak when the configuration fails.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/parse-events.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 578288c94d2a..a0a80f4e7038 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1388,8 +1388,15 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 	if (get_config_terms(head_config, &config_terms))
 		return -ENOMEM;
 
-	if (perf_pmu__config(pmu, &attr, head_config, parse_state->error))
+	if (perf_pmu__config(pmu, &attr, head_config, parse_state->error)) {
+		struct perf_evsel_config_term *pos, *tmp;
+
+		list_for_each_entry_safe(pos, tmp, &config_terms, list) {
+			list_del_init(&pos->list);
+			free(pos);
+		}
 		return -EINVAL;
+	}
 
 	evsel = __add_event(list, &parse_state->idx, &attr,
 			    get_config_name(head_config), pmu,
-- 
2.24.0.432.g9d3f5f5b63-goog


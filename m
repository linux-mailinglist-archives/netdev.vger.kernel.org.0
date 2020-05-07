Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A85B1C8DCA
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgEGOJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbgEGOI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:08:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C14DC05BD0E
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 07:08:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h185so7085414ybg.6
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 07:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WNLwvCLfBBjUXdSm9htdY2ZIrU9tK5abqhIDyW74dxc=;
        b=biQh+rIPaJjiWmCdpodETgccn4Y8n5FVL+Mpr1MGuwevY0+0SykmjiYjnIyHYQMSBY
         IR4+qgSztOBizqP2lGvsdWjUQzlUnfjxI9lZ8cNpebFxnizLjDTBQQ8NfHsAa93Htouv
         mrQ8GovuR/j5bV1vGV8e9R1zTUZmDbrcjuldLL2/J3s++NkilCKmBluMxqXG2cIbRqEU
         dAq/VoetqTDUKRgLyWw/0o6+WAtaMsG+6YWBCiJvb2V9KMeq3j6eLqL7LV45hnvhutcN
         j1/j0E36THBQDBgTLTFMupBXqIgInb0pLME/AOQ3nEmGnsF+BJe4lZ5MxcqCuUH015zI
         grMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WNLwvCLfBBjUXdSm9htdY2ZIrU9tK5abqhIDyW74dxc=;
        b=S3ued05dVkDijaiQPO3HLsc1X9BwdLBCBBOHnBHRye9/tZCQ43F7BBB2lDNogJ70k9
         vjUPNSRVuMkmWT7BljPcclWyKvxs3Yp1oICz6hQ/hpd5wQ57abWxbV0zR8IyhjJ88Vuj
         4b0/uteEFtyp6P9XL9k8FwVNw2PS5YZKz6rDOrrR0EVGG3aGEJLqqEtzivSrvT2aTSHd
         G2FghhfNPxLFPLSR7GyMkd70kGl7GGVetEpcwNZAZ/aMlmOhdSv3S5ukiqvq45s+2uZ+
         1M+HiE6XTUEAqNBMhp3P0LlZ2OzprK/KxSWfG2Kx9WRdR2ygVWFaBhH3aH6WXyFOMVMT
         yF6A==
X-Gm-Message-State: AGi0Puaw0U+tiePJuM8gtr7+JMHzxYukozr3Lf3D7MQ0kjISB1cy1YTW
        eb37erco0FVdUHiXG4NcxEZjxwUXnmCK
X-Google-Smtp-Source: APiQypK7cb30cBnYwkBB+E9mLL262GSv1zCyE6oU2nAP4RqCHtNPorpKhkR4Mmq+RPtTBEFQtMYEM/rnQiQh
X-Received: by 2002:a25:b951:: with SMTP id s17mr23122292ybm.205.1588860535288;
 Thu, 07 May 2020 07:08:55 -0700 (PDT)
Date:   Thu,  7 May 2020 07:08:12 -0700
In-Reply-To: <20200507140819.126960-1-irogers@google.com>
Message-Id: <20200507140819.126960-17-irogers@google.com>
Mime-Version: 1.0
References: <20200507140819.126960-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [RFC PATCH v2 16/23] perf evsel: fix 2 memory leaks
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

If allocated, perf_pkg_mask and metric_events need freeing.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/evsel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f3e60c45d59a..d5c28e583986 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1268,6 +1268,8 @@ void evsel__exit(struct evsel *evsel)
 	zfree(&evsel->group_name);
 	zfree(&evsel->name);
 	zfree(&evsel->pmu_name);
+	zfree(&evsel->per_pkg_mask);
+	zfree(&evsel->metric_events);
 	perf_evsel__object.fini(evsel);
 }
 
-- 
2.26.2.526.g744177e7f7-goog


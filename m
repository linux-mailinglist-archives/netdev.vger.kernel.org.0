Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DFE1CA2BD
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 07:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgEHFgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 01:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgEHFgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 01:36:45 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E0AC05BD09
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 22:36:45 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id q57so657260qte.3
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 22:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=C6LPLmrigRmdQi0c0CotlbbH7zK9/A+DlS6KBijVebI=;
        b=ZqcU//g/tDoNUk+BflT6oxVRhwFNlxaecUArUJq7b6DIuYviS1zPB63htx7eezcWnv
         mjpi256rFmlq5dECrbtjNuAo6W7/9W97qRDhWvk/nKbZeZYpsO+co+M5QF/9mUbppg48
         XVfHhlowBOs3xPub9CpxW8VQpZvurmYGpmzyFjYP6PXjdUNUSJjdYiVK16CmocfntkYk
         JUT3A/QV3R67vbvQsIEnGOQ8aj8juzWJ7sVOsPuY0Fvb02PNZirKIl2PmOLAUK93sHD/
         AD+d2efAnrJLmjgIxB6FUgkBXgPtdQv89cIqHhLsKdrA9woImewcPZ9LUMgB91xGexb4
         LzVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=C6LPLmrigRmdQi0c0CotlbbH7zK9/A+DlS6KBijVebI=;
        b=K0IVHV1magWsaurhz9XTzKqNN1yA65SovqwZtXXUagqMLVPFsVLhtcfxY0yunshG5e
         mwDROAOPxwceQFGup6lomXIOYJ05ALYiLqcYP/Jp3HhyWmkpVlcR3Af5WWaDbF+f77CV
         BbadktaOmKS5NsU3LtDZm4dHgyEki9iAEZEMB4a8p+HC4CRdJzoYUjkzTYkKmJVeP+Qn
         asDFaIyvx/hV2YL0AyLRyjXrSutB0oYaA1ZzrExvDyL2sHl3SosflzdetOIN3F33voqO
         T1YKJx+U+INfZ5hg4m4s6CXU7cP4F7GTMyXpzFPqRMYxwqQzsqOKmsNe8x4WIBnoKg7E
         by/g==
X-Gm-Message-State: AGi0PuayscgqXGx88Uld5jkbF6VNzxbnnYv6tq6EWywsg0SioyDIytNI
        pVS042IxihJ1RNFKhGdo28ML5oM9/Gpw
X-Google-Smtp-Source: APiQypLZE8PW098KJogxnKU36FARCXl5qZ1knKN1SvWTLokDiLZbnoxoqjzSzj0//cKKJgd7zzWKn8WkT9tp
X-Received: by 2002:a05:6214:1462:: with SMTP id c2mr1086669qvy.202.1588916204234;
 Thu, 07 May 2020 22:36:44 -0700 (PDT)
Date:   Thu,  7 May 2020 22:36:21 -0700
In-Reply-To: <20200508053629.210324-1-irogers@google.com>
Message-Id: <20200508053629.210324-7-irogers@google.com>
Mime-Version: 1.0
References: <20200508053629.210324-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [RFC PATCH v3 06/14] perf evsel: fix 2 memory leaks
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

If allocated, perf_pkg_mask and metric_events need freeing.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/evsel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 28683b0eb738..05bb46baad6a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1263,6 +1263,8 @@ void evsel__exit(struct evsel *evsel)
 	zfree(&evsel->group_name);
 	zfree(&evsel->name);
 	zfree(&evsel->pmu_name);
+	zfree(&evsel->per_pkg_mask);
+	zfree(&evsel->metric_events);
 	perf_evsel__object.fini(evsel);
 }
 
-- 
2.26.2.645.ge9eca65c58-goog


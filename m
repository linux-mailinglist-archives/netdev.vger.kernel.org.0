Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0141AB821
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 08:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408223AbgDPGgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 02:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2408194AbgDPGgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 02:36:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE0DC03C1A9
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 23:36:08 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f85so3116648ybg.12
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 23:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zcExPUIjugAT8xV6VI04RQsiRvISnNIvuUHEvy30OPQ=;
        b=jcEorxFYFV5HTI2YzScluwcyZpguips6m4llftytrCofa5eU0CLgR0lI0cZCPXntL5
         zhp8CnDeObNbvWbyJUae+3daWbBbN586y+H5KgDk73b6Szi+nJIEHH6zxcfF6RCfX65k
         sJu5vxH7JOOusiAVgWdofhhhNtk1G6phDx1TxMwxdflkhRfAO4e7W6njWjGhMou1F9eJ
         tQpRphYubJnkdogHDEdfBpjiPCZAj1GFi7f6a02WgYlGrcGYgBkIbGHjeNjYQwuCrni1
         +4Eu4PUDRhXOM4Hl3TBFk0UqXmn2M68AZPjTMqxLE2pQ0sZBMdpl7iRPDZ/IjByMsY5n
         /g1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zcExPUIjugAT8xV6VI04RQsiRvISnNIvuUHEvy30OPQ=;
        b=fekkKvMNhvYcvOo+n+njS7obZJ/zZ+JXYiIycu6DCdDaCSl9XAYS0nwVf/1Zn6qup6
         4XgQhj5D5drAKumqUzvTLJDxpCz9liCFr757tOgPzharf9VBuFjrIrlbhpvJmuGGIAvC
         Z3gJpZ1yiWpG7zGCa9iG1zrDD0n+udU4+KYnjQojwfjLpwbkPet36h0DTfQ4+sPeoO95
         kyx+eizrgn55G66pQuF+ENfG9xyqKqWjnbM/YmCm3J8ZH1cuGBlVy49xAoBShVkc/oS0
         QznRLzJa4XkLOvYSo+HIEXMGGwcDQ2hepJw2VmWXPsvWCrszRHhukHuTpoSpdp3kcwBz
         sDaw==
X-Gm-Message-State: AGi0PuZOLq3FOMkVqvf+9pk36yhpg8EP72B+t7BigcnmahHH0xyzex5n
        g1MnCix5aNdS6bLbv+CV6jKZQNSGoZ+u
X-Google-Smtp-Source: APiQypIRvbQP5HYg1CMsL+jPYhj9k2KONN5gLMlHj+WGKRXkmObU+J6Cr0U9tigHIRkmvhyNQyjgIHs/P+kB
X-Received: by 2002:a25:df06:: with SMTP id w6mr15209548ybg.9.1587018967219;
 Wed, 15 Apr 2020 23:36:07 -0700 (PDT)
Date:   Wed, 15 Apr 2020 23:35:50 -0700
In-Reply-To: <20200416063551.47637-1-irogers@google.com>
Message-Id: <20200416063551.47637-4-irogers@google.com>
Mime-Version: 1.0
References: <20200416063551.47637-1-irogers@google.com>
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH v9 3/4] perf pmu: add perf_pmu__find_by_type helper
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
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This is used by libpfm4 during event parsing to locate the pmu for an
event.

Signed-off-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/pmu.c | 11 +++++++++++
 tools/perf/util/pmu.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index ef6a63f3d386..5e918ca740c6 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -869,6 +869,17 @@ static struct perf_pmu *pmu_find(const char *name)
 	return NULL;
 }
 
+struct perf_pmu *perf_pmu__find_by_type(unsigned int type)
+{
+	struct perf_pmu *pmu;
+
+	list_for_each_entry(pmu, &pmus, list)
+		if (pmu->type == type)
+			return pmu;
+
+	return NULL;
+}
+
 struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu)
 {
 	/*
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 5fb3f16828df..de3b868d912c 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -65,6 +65,7 @@ struct perf_pmu_alias {
 };
 
 struct perf_pmu *perf_pmu__find(const char *name);
+struct perf_pmu *perf_pmu__find_by_type(unsigned int type);
 int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms,
 		     struct parse_events_error *error);
-- 
2.26.0.110.g2183baf09c-goog


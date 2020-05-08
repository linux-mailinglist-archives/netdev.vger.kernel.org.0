Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF381CA2E0
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 07:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgEHFh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 01:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgEHFgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 01:36:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C84C05BD0D
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 22:36:41 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y7so750349ybj.15
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 22:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EMaoPBnsp496f8fnle4PLwTyhTwnaVEb2fZ0BoIlE/s=;
        b=jZ8/3BzUau6j8ZEvbsjxAuGI7hb6DTIvN/+4pZeSwdomRiSNh85BVtF9D8gUSNVzGW
         0eWncZr8l/llXRWz7VqOOZykXeBtJ3SKKEDwFOtudoKFQnaFGvJxJmPF2nVefWSW6T1N
         ujEs8CCMrw76bYxjsNxUwbOVzos4CsPvDRMCd5/PW/oSuWhkpIA3lRzQjco0kInXDbPm
         8LmrpY+BMC3pKeUMPrR8rm5su1lRDsLumbV0h+zp0IpapZChomkqsjjuZcY5Cf2QXSOm
         iDcH2pbz97F5r2NX7V3MQ5S2ooUU3tb01J5+66RrtZtTIz6KF+NJhOkHR6wRY5hgklGo
         l52A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EMaoPBnsp496f8fnle4PLwTyhTwnaVEb2fZ0BoIlE/s=;
        b=jY8mnsORxBySYtmMN/MRXFVBge73P+QAyS7Fm4CnKnXzTasNeWmwgd0nq5Zq1xW/Bn
         TSxtfDlYDwZGG8AAq2KeWuR3wNHaAkBDEpGvrz7d6Wub/sDMAGF2LQ4BStdCYKbt8wFR
         Li3+xe8y9eCFmhBrW6Ebb0/08hJZ633NbtjjDSGVc++PlMENOUamwEyD6OgvB2V1eEBd
         zeTJT9ydlB2zxou8mY6fw289yEZD24OvkXSCH4kLXpfQj/wTiojKyq8VudUEpVqtzxJ+
         QQ0J/tJh11UKe8FVqJ/nvgZK0PSygYqbf5TZDohjQYItsMN0SchHR3odVie6gp9ghiYv
         izAA==
X-Gm-Message-State: AGi0PuYX2mgTbMNG/+ws5/py9RJ1l5wpqMO3k0xqmhINw6Ob0QZUSqO4
        97vuV502nJyU6zUzc5SZQdFSOIN2lVy0
X-Google-Smtp-Source: APiQypLQw6jwdcVMaZFQOy5PNutRW9zCylVfFgkKjPKR5hivKEFBHzRJZKkDf50HqYjqdKRWSm4C4Wle3tYc
X-Received: by 2002:a25:51c1:: with SMTP id f184mr1837043ybb.448.1588916200664;
 Thu, 07 May 2020 22:36:40 -0700 (PDT)
Date:   Thu,  7 May 2020 22:36:19 -0700
In-Reply-To: <20200508053629.210324-1-irogers@google.com>
Message-Id: <20200508053629.210324-5-irogers@google.com>
Mime-Version: 1.0
References: <20200508053629.210324-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [RFC PATCH v3 04/14] libbpf: Fix memory leak and possible double-free
 in hashmap__clear
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
        Alston Tang <alston64@fb.com>, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

Fix memory leak in hashmap_clear() not freeing hashmap_entry structs for each
of the remaining entries. Also NULL-out bucket list to prevent possible
double-free between hashmap__clear() and hashmap__free().

Running test_progs-asan flavor clearly showed this problem.

Reported-by: Alston Tang <alston64@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200429012111.277390-5-andriin@fb.com
Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/lib/bpf/hashmap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/lib/bpf/hashmap.c b/tools/lib/bpf/hashmap.c
index 54c30c802070..cffb96202e0d 100644
--- a/tools/lib/bpf/hashmap.c
+++ b/tools/lib/bpf/hashmap.c
@@ -59,7 +59,14 @@ struct hashmap *hashmap__new(hashmap_hash_fn hash_fn,
 
 void hashmap__clear(struct hashmap *map)
 {
+	struct hashmap_entry *cur, *tmp;
+	int bkt;
+
+	hashmap__for_each_entry_safe(map, cur, tmp, bkt) {
+		free(cur);
+	}
 	free(map->buckets);
+	map->buckets = NULL;
 	map->cap = map->cap_bits = map->sz = 0;
 }
 
-- 
2.26.2.645.ge9eca65c58-goog


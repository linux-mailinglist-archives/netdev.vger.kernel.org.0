Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BAE1D5685
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgEOQuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726374AbgEOQuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 12:50:15 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483CEC05BD0A
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 09:50:15 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id c20so3087029qtw.11
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 09:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tvl7gLFsS/dAedcEqfrKtncclZsMityBUyr8g2OugcQ=;
        b=OGopoj+ElQmzcTdGxoabqS9eF87VZHL+YKcn8EL4MNkN1sf7PKD0S2cQHJu4CCOCWV
         /5Sq2Mu8iguP210lceBZY1OO7RJ7CkYhrHtqn0BnSF1j3XS36C+L2n4P+PjRx7R31Nch
         3h/5QgSoVrdR+N2Xw2zQ87s8q5TAMqdL9PQ3bsgB8plIwGFcvz7ILoCxnI8yG2BJOoJC
         ueRDeyh/REt1PRHNocvBh9oMcPpFMAOXMuWkysXsgYYA29hR0F6TOtUhwG56cx1qxdwp
         nietz7S0Q8Bo1TU6F0n5gdf4Md+m2AuEMuP0aaUaIqLEXvF9Fv3EsaeMFxNZCP/YTICg
         q1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tvl7gLFsS/dAedcEqfrKtncclZsMityBUyr8g2OugcQ=;
        b=QVqjR/z+3Dn4Umqki9LXkPbbrT7Eq5uRlvz70KfmGDcSpKijfVM/P6jMWcZd1LamPw
         KWpCIwySrbVbXXOtyOi/bHhHxDQPa8NvDwxI9mW0wmuWLm/ekxO1IrK3eNnZdR+9hGrb
         bBYi/yazFRwoYtb01rJVlnRm2Vbgi0qY2qASDhEjYItV1+f2NgpQkWACSxv+NcNM+Ikf
         MdZFlUM31VgatChkTWxTV/PXZZLLayqq8feEUlVCWXID6ZTQE5mLecXk7HbOs6KgJ8+v
         oX+3oO2snY15TpNoadjZxqL80I5inb7H/LF/HeOJiSyNVvLvd+d5KMqkhKJDhbAHlZI+
         D4XA==
X-Gm-Message-State: AOAM531sCogSmYv5brMcqJjKYKcXTau0VQsmjDLjCYsJZ0P2Ev12WrdK
        GUt1AuuCUqa7k9JUaFtVUd+9PZuHZwSV
X-Google-Smtp-Source: ABdhPJxUGHNwST/oAVqzulPWSrIN3rsRJlT5Lod9ZxyqGr+y0Xlu97Cd7HZ7tWpnI1/fWybDyl8ugub3NP1L
X-Received: by 2002:a05:6214:164:: with SMTP id y4mr4179863qvs.249.1589561414334;
 Fri, 15 May 2020 09:50:14 -0700 (PDT)
Date:   Fri, 15 May 2020 09:50:01 -0700
In-Reply-To: <20200515165007.217120-1-irogers@google.com>
Message-Id: <20200515165007.217120-2-irogers@google.com>
Mime-Version: 1.0
References: <20200515165007.217120-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH v2 1/7] libbpf: Fix memory leak and possible double-free in hashmap__clear
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
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
2.26.2.761.g0e0b3e54be-goog


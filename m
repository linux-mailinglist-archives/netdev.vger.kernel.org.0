Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3690C1D4684
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 08:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgEOG5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 02:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726623AbgEOG4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 02:56:34 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37623C05BD0B
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 23:56:33 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id o16so1410868qto.12
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 23:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tvl7gLFsS/dAedcEqfrKtncclZsMityBUyr8g2OugcQ=;
        b=L1Pcz6gnqUzZkJrzhBUQp0QUfmzqMeD11Syg0lPwtZra+G6eYVcIwSdxLHbea30lMH
         VPEiAhP4to/UFfvAX0LAMJ1tyxOpktCcAdayUEcYBXl6F8VgXGGU/TEUYJ3y15A/3R5E
         YU6LMqnfuUcMQBUHHdnob6YvUNLUlY7ezab93T8g6Q4fi9fcQCkBISB+hhwPcYVCeE8R
         1CUJySRpZreY8cMtNlU8Cm6Tfuw8qoyN8n86PLRd4NRTktgnuecp7WTaCr2RQI8IQ5td
         cCkgS+2KoQy94ltW9Gy0mZAHyMKpiXB+4bjqQRJZt7KHphQ7+zuJxxd+VRgQ0t2PZ1MJ
         xouw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tvl7gLFsS/dAedcEqfrKtncclZsMityBUyr8g2OugcQ=;
        b=g4J0R3fObdSEavzVwBv2+wqCwmPO0FK+yCcS309/WjPbtR7dZcysD/nlrOPrxK+QML
         ozrDPn3NjywKl5Jl/ZezdkSiIub0uHk0nS0aywU7gh5Nt102cFAzSwzhMX4FgTZWOHFg
         +zGkVSUZLxGx/G2rqDj9tX1QMQjjmZjSJ2RqEVAEdqOdPQ95e6YhH7IwPrIctqQzso2h
         YjbwV6YUDGVeBy16FqoHXviQxKk/lUMFJ2BvVQ64xoQiQaIK0VyVbBf+SK+ES6BgOXwk
         NyWMGXjThwmQq+RDTwNFyz2/pP+XQQSi0wsD6+LvI88rjfzGESW9BcHHCJvoXw+C5kIx
         uJiQ==
X-Gm-Message-State: AOAM532uDf+Mu7sHo6qJITweSRWJI2NPjRx/9CDRjnSx8tKyi1230xrf
        1aAznKO8idGWg358KiTuSzIkzzOyz0VC
X-Google-Smtp-Source: ABdhPJxDHoNPBj+Xy4XlruWwU/uTMdd15h3I5dMGic4z9Trd8Ynf0UfZutAZW27seEr+Fu0dO/wbEvgsqVcx
X-Received: by 2002:a0c:ac41:: with SMTP id m1mr2102104qvb.71.1589525792231;
 Thu, 14 May 2020 23:56:32 -0700 (PDT)
Date:   Thu, 14 May 2020 23:56:17 -0700
In-Reply-To: <20200515065624.21658-1-irogers@google.com>
Message-Id: <20200515065624.21658-2-irogers@google.com>
Mime-Version: 1.0
References: <20200515065624.21658-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 1/8] libbpf: Fix memory leak and possible double-free in hashmap__clear
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


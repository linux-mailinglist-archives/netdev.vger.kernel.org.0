Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D41D44E293
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 08:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbhKLHsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 02:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbhKLHsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 02:48:20 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27677C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 23:45:30 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id z65-20020a256544000000b005c21b35717dso13297654ybb.10
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 23:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=lBk8dGY4hFJkFmSHmPRQmSxy6IAflxMTO27FP9s8b+w=;
        b=OTwDuIdL8CRDE4t/A+7voiAtQtDhuLkEOav8gVsu8YQHJpcmQjg0Ymj0XLxITAEx61
         +gIHzmRepKXd2Dmvxfl/Zir6uirlc/VRoo/FDs7lO28ZaX0USpBUrQ6l6RYKJ4iDiABi
         v5PE/XDJVDlmtX+dc6uns0KL44Efq9VxexECohoyGKWK0qqvDmXpb+5rBpxUMduEdWIf
         zUdn+AIr/KNU36T26BKIWbMNu/bmR5nu/LNHXKMncamGUszfd+NSjK0z+evloDdt3Bmc
         Nxqzm3hE9iWqencUaWPWHFEcdA8bXX3ZCrtnB8NDQvW75NpcNsjpTFEM172C1hT5vWxf
         +8ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=lBk8dGY4hFJkFmSHmPRQmSxy6IAflxMTO27FP9s8b+w=;
        b=tpjuRDkfOTEAYGPAujNl8A8hW7wzuxJlzDU0MMYLJGpASamo96i0JQnLjyNAfrHg/M
         HetoEOgHdnuHzQGowotpits5la5ocl/mbb3UkKNrPQwZ/iUTBEPclWb3R723joUh097D
         ieO9Vxduxe+n4EoTBJ3wR2Ez4dkQVmhHyUmuUGzho+aqoapCRFKem2S9ZfjPF9Ddjv3x
         ZR/I0RECwAFPikxayYZXom9VhP6STX8sL44lAEep7SUxtn9T7F8ePq1k1WjHnwc1FEk9
         9H0qZA3iDbb/89WZkib1xJ2XM5Xg17wF9piS1bnRhPsNtzwBF+QdM/QEZiWk1qvo4Zck
         e2Pg==
X-Gm-Message-State: AOAM5338aQDG+hbW2RdxjzFM6qf02K5NjJnKjxktEaPANG4UMFqKigXj
        h90bmNyuvPd7Cb45ogbReXRWHCHYepEW
X-Google-Smtp-Source: ABdhPJyzg/K2BXrzWNNCTEC82Wr4M/VaVTvD03vyOuSvcRJzqozFC7v08rJvrUrHF/y+btADRBPrseTPWBF5
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:5ce9:74ca:7ed9:75f2])
 (user=irogers job=sendgmr) by 2002:a25:3341:: with SMTP id
 z62mr14319876ybz.101.1636703129304; Thu, 11 Nov 2021 23:45:29 -0800 (PST)
Date:   Thu, 11 Nov 2021 23:45:25 -0800
Message-Id: <20211112074525.121633-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2] perf bpf: Avoid memory leak from perf_env__insert_btf
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

perf_env__insert_btf doesn't insert if a duplicate btf id is
encountered and this causes a memory leak. Modify the function to return
a success/error value and then free the memory if insertion didn't
happen.

v2. Adds a return -1 when the insertion error occurs in
    perf_env__fetch_btf. This doesn't affect anything as the result is
    never checked.

Fixes: 3792cb2ff43b ("perf bpf: Save BTF in a rbtree in perf_env")
Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/bpf-event.c | 6 +++++-
 tools/perf/util/env.c       | 5 ++++-
 tools/perf/util/env.h       | 2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index 4d3b4cdce176..d49cdff8fb39 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -119,7 +119,11 @@ static int perf_env__fetch_btf(struct perf_env *env,
 	node->data_size = data_size;
 	memcpy(node->data, data, data_size);
 
-	perf_env__insert_btf(env, node);
+	if (!perf_env__insert_btf(env, node)) {
+		/* Insertion failed because of a duplicate. */
+		free(node);
+		return -1;
+	}
 	return 0;
 }
 
diff --git a/tools/perf/util/env.c b/tools/perf/util/env.c
index 17f1dd0680b4..b9904896eb97 100644
--- a/tools/perf/util/env.c
+++ b/tools/perf/util/env.c
@@ -75,12 +75,13 @@ struct bpf_prog_info_node *perf_env__find_bpf_prog_info(struct perf_env *env,
 	return node;
 }
 
-void perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node)
+bool perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node)
 {
 	struct rb_node *parent = NULL;
 	__u32 btf_id = btf_node->id;
 	struct btf_node *node;
 	struct rb_node **p;
+	bool ret = true;
 
 	down_write(&env->bpf_progs.lock);
 	p = &env->bpf_progs.btfs.rb_node;
@@ -94,6 +95,7 @@ void perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node)
 			p = &(*p)->rb_right;
 		} else {
 			pr_debug("duplicated btf %u\n", btf_id);
+			ret = false;
 			goto out;
 		}
 	}
@@ -103,6 +105,7 @@ void perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node)
 	env->bpf_progs.btfs_cnt++;
 out:
 	up_write(&env->bpf_progs.lock);
+	return ret;
 }
 
 struct btf_node *perf_env__find_btf(struct perf_env *env, __u32 btf_id)
diff --git a/tools/perf/util/env.h b/tools/perf/util/env.h
index 1383876f72b3..163e5ec503a2 100644
--- a/tools/perf/util/env.h
+++ b/tools/perf/util/env.h
@@ -167,7 +167,7 @@ void perf_env__insert_bpf_prog_info(struct perf_env *env,
 				    struct bpf_prog_info_node *info_node);
 struct bpf_prog_info_node *perf_env__find_bpf_prog_info(struct perf_env *env,
 							__u32 prog_id);
-void perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node);
+bool perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node);
 struct btf_node *perf_env__find_btf(struct perf_env *env, __u32 btf_id);
 
 int perf_env__numa_node(struct perf_env *env, int cpu);
-- 
2.34.0.rc1.387.gb447b232ab-goog


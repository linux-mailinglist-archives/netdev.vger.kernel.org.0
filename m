Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE82446CA3
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 06:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbhKFFlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 01:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbhKFFlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 01:41:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D85C061205
        for <netdev@vger.kernel.org>; Fri,  5 Nov 2021 22:38:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v133-20020a25c58b000000b005c20153475dso16698875ybe.17
        for <netdev@vger.kernel.org>; Fri, 05 Nov 2021 22:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZayAaJHcuA1bcDDOidW5iIDpwigbcsn41v2z+XbHtiI=;
        b=SXDPhCPtzx39uuxzIlWZELOIKZv4gyA0EQdzsEQMDIkSv+kaeZ8NuPiA9pVw/3o1zX
         N4554yb9P6B4XgLl4AzRwMSH3M3+DSh78fbX8hwQ4vOdJChFwJDdw1K2k0wr1MhLxxnI
         UwlSMTmrzlt1jSqX7PDuUiNImN5B21a+MMMtxGWrzMJ3wziLW5ehyFdi0SIi9NldHJNy
         dX8S0Q7jKBrO8TQJ8buTu0CQMSO6a01cPIIOPz/IpvNzQtQcV8lIi9k6lmUQ9UBsQWAh
         KiOK4FuGdB7m7NmXXYyqBwiaw+fCchE362eog/yOYDJiQ1wyeztT/o465v5DLZhqsVHL
         oQcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZayAaJHcuA1bcDDOidW5iIDpwigbcsn41v2z+XbHtiI=;
        b=XErMSvNbH8MrG85Rihe62dqruuyAC9uECKTHLZI/zNrwYUnTccbPB4xXUhMfRbz28q
         62GpDgwxhUBP7ujCIxfOtesgwCVik+4uztfdt7eGGD2rX1vf/F/Xas7EMbmHALsHyzDZ
         foNf2uQF7n7B4NLJMDIRlEmFuLjiJv4iv7WSW/CHFyCgGgu0PYEfJksASD/4sX2MJMxy
         MHgEhhvVdeJ5l3qGTcuf5QZ8FdGf5zEvGeU6s9vAurhfOi3NuKP/XukJSdkBsJwnrqux
         LBOh1j77KDxGB4+Tz3Rogr5Q0VQZiXVzv4chHRP/cJh4dDtmUb+KnIrvbgSvSZioreiy
         eCTQ==
X-Gm-Message-State: AOAM5300Prn9z/bOsnHMUsRLstq8gRom4r9QtsPW+M813LaoQpHUtxwu
        GShMbhOsD0npPPqatz5gryJulqzLxL/F
X-Google-Smtp-Source: ABdhPJzG9WMyFJYgNZwnoYHUb+JlLflaX6yIfrm7b3g1aUgL21oqFvCPOCOP5R/Jg7FyEJy7a49xsEAUjMTO
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:b70b:3e34:63e5:9e95])
 (user=irogers job=sendgmr) by 2002:a25:2f13:: with SMTP id
 v19mr69075829ybv.410.1636177103010; Fri, 05 Nov 2021 22:38:23 -0700 (PDT)
Date:   Fri,  5 Nov 2021 22:37:32 -0700
Message-Id: <20211106053733.3580931-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 1/2] perf bpf: Avoid memory leak from perf_env__insert_btf
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

Fixes: 3792cb2ff43b ("perf bpf: Save BTF in a rbtree in perf_env")
Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/bpf-event.c | 5 ++++-
 tools/perf/util/env.c       | 5 ++++-
 tools/perf/util/env.h       | 2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index 1a7112a87736..0783b464777a 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -120,7 +120,10 @@ static int perf_env__fetch_btf(struct perf_env *env,
 	node->data_size = data_size;
 	memcpy(node->data, data, data_size);
 
-	perf_env__insert_btf(env, node);
+	if (!perf_env__insert_btf(env, node)) {
+		/* Insertion failed because of a duplicate. */
+		free(node);
+	}
 	return 0;
 }
 
diff --git a/tools/perf/util/env.c b/tools/perf/util/env.c
index cf773f0dec38..5b24eb010336 100644
--- a/tools/perf/util/env.c
+++ b/tools/perf/util/env.c
@@ -74,12 +74,13 @@ struct bpf_prog_info_node *perf_env__find_bpf_prog_info(struct perf_env *env,
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
@@ -93,6 +94,7 @@ void perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node)
 			p = &(*p)->rb_right;
 		} else {
 			pr_debug("duplicated btf %u\n", btf_id);
+			ret = false;
 			goto out;
 		}
 	}
@@ -102,6 +104,7 @@ void perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node)
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
2.34.0.rc0.344.g81b53c2807-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5FE45C4C0
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 14:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351929AbhKXNvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 08:51:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351480AbhKXNtb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 08:49:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05AFF63353;
        Wed, 24 Nov 2021 13:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759002;
        bh=+VTHtgmTLJma6INwrMhFlKSmR9cER8AU8U0QToEs+hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7egISAjwyaMFDO8BiB8c0xjNCaricYR3FfKnz2d6/dGTkQaSCvbnN1XgIFWfihLr
         DtKLm3MlLNrK3AR/+66jCKFXSk3EUmvJ9gObI6QcWpPb9eKfrjthH2gKAh7q0aneyR
         Bdc0PYw+AKD9BhDYzEEve4y7IJmHxUaIakgscJ1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/279] perf bpf: Avoid memory leak from perf_env__insert_btf()
Date:   Wed, 24 Nov 2021 12:56:28 +0100
Message-Id: <20211124115722.261423828@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit 4924b1f7c46711762fd0e65c135ccfbcfd6ded1f ]

perf_env__insert_btf() doesn't insert if a duplicate BTF id is
encountered and this causes a memory leak. Modify the function to return
a success/error value and then free the memory if insertion didn't
happen.

v2. Adds a return -1 when the insertion error occurs in
    perf_env__fetch_btf. This doesn't affect anything as the result is
    never checked.

Fixes: 3792cb2ff43b1b19 ("perf bpf: Save BTF in a rbtree in perf_env")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Yonghong Song <yhs@fb.com>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Link: http://lore.kernel.org/lkml/20211112074525.121633-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 6 +++++-
 tools/perf/util/env.c       | 5 ++++-
 tools/perf/util/env.h       | 2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index a410b3968b3af..16ad0e6e9e9c5 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -120,7 +120,11 @@ static int perf_env__fetch_btf(struct perf_env *env,
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
index cf773f0dec384..5b24eb010336c 100644
--- a/tools/perf/util/env.c
+++ b/tools/perf/util/env.c
@@ -74,12 +74,13 @@ out:
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
index 1383876f72b37..163e5ec503a26 100644
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
2.33.0




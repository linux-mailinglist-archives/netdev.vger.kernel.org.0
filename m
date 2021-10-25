Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E53439172
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhJYIhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbhJYIgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:36:32 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D38C06118D;
        Mon, 25 Oct 2021 01:34:06 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gn3so7715906pjb.0;
        Mon, 25 Oct 2021 01:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FimO42wHtyfBgzya/uAaxmcTkfbAGy9rm+wuLjXRCpM=;
        b=CMzBBLZvEjXS7erkK4gC8zgIdfsYiNz7dGUg+d49ScAYY+q/TShlcX2Ju9kusSxdEb
         a01pYcPiTgrVOP16z1WWCDbus2MLMoqyEtRZsKF/7I+556oB8thmUiWvwLCCpaKcQafk
         Q90z1GqDhsyVHwTvOPZwkwT2UGNiLDen6CuNr1/umo5xRLQ0dY8i6HLK+wtn+TAosQfr
         Gx9CNRh8KkLCvQ8YsPpvVqpNHjwYP40LzSyOVqHsNeZe1Gq2hOhsXNidrxl2ApprLLfy
         +sgZXnWrt+SqR2w8WyrxCCvutwz8aEMBZtUCHn0oVbuzBtSXFuPLQphqjh15nH9ExfPA
         M8FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FimO42wHtyfBgzya/uAaxmcTkfbAGy9rm+wuLjXRCpM=;
        b=LHzJCXNPTUUn9d2DPLnw+oNJ6bBmtMCpkxp1Bo83EDtimHesMe7zOVpgeC3XIFUgaH
         icqDuVN0odDyF5BJxnc/7cCxODyh9HlTAGZQhunnu23akoLUYPpNEDA1T6850BC3ooH1
         1TcFKP8Cc0c1wtJLLBQr4LFL7m10NOCUcchJHzjUMdOnebZLuU8jegqcPVLwZ2IG5+La
         qUk1qZbm6WQabvUYfLy2dfgWJr1AoAhSAwy6eBNCeLqUfHrdNUw226r7Vid1FDz95z9U
         /Sy4M8GSxF5ZMnvT6nfh7dWcJAggLsTgNWQfRXnk/vdQGuBrxgAOy1/I5wbgj91JDxrd
         Y7aA==
X-Gm-Message-State: AOAM532/+4JV/EFegz+6JRrLrQoBGoOfqalcBogiKqLrL5q28UI5eh/Y
        dl/tjM/nV6aNWsxOLXo3IYQ=
X-Google-Smtp-Source: ABdhPJz2AlsUyCzUZMxKu+M0vjHOcLRcbjq0i+wwmiMJBlPaI9iPLMs9CncCZefQOcgo7EXDtDLr1Q==
X-Received: by 2002:a17:90a:62c9:: with SMTP id k9mr21015248pjs.52.1635150845679;
        Mon, 25 Oct 2021 01:34:05 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id p13sm2495694pfo.102.2021.10.25.01.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 01:34:05 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org, keescook@chromium.org,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        arnaldo.melo@gmail.com, pmladek@suse.com, peterz@infradead.org,
        viro@zeniv.linux.org.uk, valentin.schneider@arm.com,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        christian@brauner.io, dietmar.eggemann@arm.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH v6 10/12] tools/testing/selftests/bpf: make it adopt to task comm size change
Date:   Mon, 25 Oct 2021 08:33:13 +0000
Message-Id: <20211025083315.4752-11-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211025083315.4752-1-laoar.shao@gmail.com>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hard-coded 16 is used in various bpf progs. These progs get task
comm either via bpf_get_current_comm() or prctl() or
bpf_core_read_str(), all of which can work well even if the task comm size
is changed.

In these BPF programs, one thing to be improved is the
sched:sched_switch tracepoint args. As the tracepoint args are derived
from the kernel, we'd better make it same with the kernel. So the macro
TASK_COMM_LEN is converted to type enum, then all the BPF programs can
get it through BTF.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
---
 include/linux/sched.h                                   | 9 +++++++--
 tools/testing/selftests/bpf/progs/test_stacktrace_map.c | 6 +++---
 tools/testing/selftests/bpf/progs/test_tracepoint.c     | 6 +++---
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c1a927ddec64..124538db792c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -274,8 +274,13 @@ struct task_group;
 
 #define get_current_state()	READ_ONCE(current->__state)
 
-/* Task command name length: */
-#define TASK_COMM_LEN			16
+/*
+ * Define the task command name length as enum, then it can be visible to
+ * BPF programs.
+ */
+enum {
+	TASK_COMM_LEN = 16,
+};
 
 extern void scheduler_tick(void);
 
diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
index 00ed48672620..e9b602a6dc1b 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2018 Facebook
 
-#include <linux/bpf.h>
+#include <vmlinux.h>
 #include <bpf/bpf_helpers.h>
 
 #ifndef PERF_MAX_STACK_DEPTH
@@ -41,11 +41,11 @@ struct {
 /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
 struct sched_switch_args {
 	unsigned long long pad;
-	char prev_comm[16];
+	char prev_comm[TASK_COMM_LEN];
 	int prev_pid;
 	int prev_prio;
 	long long prev_state;
-	char next_comm[16];
+	char next_comm[TASK_COMM_LEN];
 	int next_pid;
 	int next_prio;
 };
diff --git a/tools/testing/selftests/bpf/progs/test_tracepoint.c b/tools/testing/selftests/bpf/progs/test_tracepoint.c
index 4b825ee122cf..f21982681e28 100644
--- a/tools/testing/selftests/bpf/progs/test_tracepoint.c
+++ b/tools/testing/selftests/bpf/progs/test_tracepoint.c
@@ -1,17 +1,17 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2017 Facebook
 
-#include <linux/bpf.h>
+#include <vmlinux.h>
 #include <bpf/bpf_helpers.h>
 
 /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
 struct sched_switch_args {
 	unsigned long long pad;
-	char prev_comm[16];
+	char prev_comm[TASK_COMM_LEN];
 	int prev_pid;
 	int prev_prio;
 	long long prev_state;
-	char next_comm[16];
+	char next_comm[TASK_COMM_LEN];
 	int next_pid;
 	int next_prio;
 };
-- 
2.17.1


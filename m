Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE2053247A
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 09:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbiEXHxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 03:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235441AbiEXHxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 03:53:32 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB098722C
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 00:53:31 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id bo5so15779919pfb.4
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 00:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wV0DpKXatddjDbJCjTJofvulVU/99t8+gdCbNaoZbpM=;
        b=KA1pZeloa4+9p56nYDJMi/agE/umtXJKAy7AbfgNIM0jOuC5MFFdUc3MGY1OD7YwVX
         EL6/PSLALvaRWZeO0+V+2+gf4CS7DtkspoPvrmlC3tByyaZlbilbP3+DrOZW+XLk4b3c
         F/495q2T9EV7hGQNvVpfNMYLYeeg7XtGDCxmK3WQzRkZ/r1ejx0LUmNw+iTCXk/JMXvo
         7zN2FoQYP9NXh2LCAI0HiCSXwxsVyEomVVv7k1VZ/BXs8Thsv0KWTU2rCfZyGALbl81B
         HP1jA2bTwTg1MoooDPess+wnu6N8qp1+hItLooVZkrNVoXQ75+fcLXcdoNIy9wy3425Y
         aJuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wV0DpKXatddjDbJCjTJofvulVU/99t8+gdCbNaoZbpM=;
        b=AEBzWhb6FyfWklBdzFQU4QYHbXS27gFQdq1THzPJcAsK6UFLddtlyvfYkYo58/5t5q
         mMgX06f0U/enWSfEAxOwXEXcriFH3cAeXPANeBPaTgCAK4lr4v+DkiMpvoUBAcAjB3Cs
         lfOYZouSm3UG85ZUedSGfpb6EgIhazLOO0Au6J0gkDoXwMiGt8Y5rZX9yK9CWxCwCZsi
         NTNtSkooRbxcBXqOXOVp0wWLHbt8PPiEa4TY47OVCLZtamsSLVUQ2hGIy0xipNpZb4Kq
         N0xH5RjNT1UsKxyY4DiUdUeh6AskbFO1xudaakkdzboZomhZET0G7asztERHaSxdaFNd
         /AXQ==
X-Gm-Message-State: AOAM531IY929iKuR1zubVAUPdsFiZIWZNtviPSnI99oa0Emyuv2Gy+lZ
        8gb+TPaTMdrcHhS4+4G2HOT3Cg==
X-Google-Smtp-Source: ABdhPJw1lV/AnIKXMFK++/pxRxsIkuT1tsDXuJeG2hGTxeRGAav7QzcnjK9gJbM7LScExUgEBgqQyQ==
X-Received: by 2002:a63:df0f:0:b0:3db:2d4:ded9 with SMTP id u15-20020a63df0f000000b003db02d4ded9mr23094534pgg.267.1653378810601;
        Tue, 24 May 2022 00:53:30 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id m3-20020a62a203000000b00518327b7d23sm8682136pff.46.2022.05.24.00.53.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 May 2022 00:53:30 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject: [PATCH v2 2/2] selftest/bpf/benchs: Add bpf_map benchmark
Date:   Tue, 24 May 2022 15:53:06 +0800
Message-Id: <20220524075306.32306-3-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220524075306.32306-1-zhoufeng.zf@bytedance.com>
References: <20220524075306.32306-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

Add benchmark for hash_map to reproduce the worst case
that non-stop update when map's free is zero.

Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 tools/testing/selftests/bpf/Makefile          |  4 +-
 tools/testing/selftests/bpf/bench.c           |  2 +
 .../selftests/bpf/benchs/bench_bpf_map.c      | 78 +++++++++++++++++++
 .../selftests/bpf/benchs/run_bench_bpf_map.sh | 10 +++
 .../selftests/bpf/progs/bpf_map_bench.c       | 27 +++++++
 5 files changed, 120 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_bpf_map.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_bpf_map.sh
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_bench.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 3820608faf57..cd2fada21ed7 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -549,6 +549,7 @@ $(OUTPUT)/bench_ringbufs.o: $(OUTPUT)/ringbuf_bench.skel.h \
 $(OUTPUT)/bench_bloom_filter_map.o: $(OUTPUT)/bloom_filter_bench.skel.h
 $(OUTPUT)/bench_bpf_loop.o: $(OUTPUT)/bpf_loop_bench.skel.h
 $(OUTPUT)/bench_strncmp.o: $(OUTPUT)/strncmp_bench.skel.h
+$(OUTPUT)/bench_bpf_map.o: $(OUTPUT)/bpf_map_bench.skel.h
 $(OUTPUT)/bench.o: bench.h testing_helpers.h $(BPFOBJ)
 $(OUTPUT)/bench: LDLIBS += -lm
 $(OUTPUT)/bench: $(OUTPUT)/bench.o \
@@ -560,7 +561,8 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o \
 		 $(OUTPUT)/bench_ringbufs.o \
 		 $(OUTPUT)/bench_bloom_filter_map.o \
 		 $(OUTPUT)/bench_bpf_loop.o \
-		 $(OUTPUT)/bench_strncmp.o
+		 $(OUTPUT)/bench_strncmp.o \
+		 $(OUTPUT)/bench_bpf_map.o
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.a %.o,$^) $(LDLIBS) -o $@
 
diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index f973320e6dbf..32644c4adc84 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -397,6 +397,7 @@ extern const struct bench bench_hashmap_with_bloom;
 extern const struct bench bench_bpf_loop;
 extern const struct bench bench_strncmp_no_helper;
 extern const struct bench bench_strncmp_helper;
+extern const struct bench bench_bpf_map;
 
 static const struct bench *benchs[] = {
 	&bench_count_global,
@@ -431,6 +432,7 @@ static const struct bench *benchs[] = {
 	&bench_bpf_loop,
 	&bench_strncmp_no_helper,
 	&bench_strncmp_helper,
+	&bench_bpf_map,
 };
 
 static void setup_benchmark()
diff --git a/tools/testing/selftests/bpf/benchs/bench_bpf_map.c b/tools/testing/selftests/bpf/benchs/bench_bpf_map.c
new file mode 100644
index 000000000000..4db08ed23f1f
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/bench_bpf_map.c
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Bytedadnce */
+
+#include <argp.h>
+#include "bench.h"
+#include "bpf_map_bench.skel.h"
+
+/* BPF triggering benchmarks */
+static struct ctx {
+	struct bpf_map_bench *skel;
+	struct counter hits;
+} ctx;
+
+static void validate(void)
+{
+	if (env.consumer_cnt != 1) {
+		fprintf(stderr, "benchmark doesn't support multi-consumer!\n");
+		exit(1);
+	}
+}
+
+static void *producer(void *input)
+{
+	while (true) {
+		/* trigger the bpf program */
+		syscall(__NR_getpgid);
+		atomic_inc(&ctx.hits.value);
+	}
+
+	return NULL;
+}
+
+static void *consumer(void *input)
+{
+	return NULL;
+}
+
+static void measure(struct bench_res *res)
+{
+	res->hits = atomic_swap(&ctx.hits.value, 0);
+}
+
+static void setup(void)
+{
+	struct bpf_link *link;
+	int map_fd, i, max_entries;
+
+	setup_libbpf();
+
+	ctx.skel = bpf_map_bench__open_and_load();
+	if (!ctx.skel) {
+		fprintf(stderr, "failed to open skeleton\n");
+		exit(1);
+	}
+
+	link = bpf_program__attach(ctx.skel->progs.benchmark);
+	if (!link) {
+		fprintf(stderr, "failed to attach program!\n");
+		exit(1);
+	}
+
+	//fill hash_map
+	map_fd = bpf_map__fd(ctx.skel->maps.hash_map_bench);
+	max_entries = bpf_map__max_entries(ctx.skel->maps.hash_map_bench);
+	for (i = 0; i < max_entries; i++)
+		bpf_map_update_elem(map_fd, &i, &i, BPF_ANY);
+}
+
+const struct bench bench_bpf_map = {
+	.name = "bpf-map",
+	.validate = validate,
+	.setup = setup,
+	.producer_thread = producer,
+	.consumer_thread = consumer,
+	.measure = measure,
+	.report_progress = ops_report_progress,
+	.report_final = ops_report_final,
+};
diff --git a/tools/testing/selftests/bpf/benchs/run_bench_bpf_map.sh b/tools/testing/selftests/bpf/benchs/run_bench_bpf_map.sh
new file mode 100755
index 000000000000..d7cc969e4f85
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/run_bench_bpf_map.sh
@@ -0,0 +1,10 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source ./benchs/run_common.sh
+
+set -eufo pipefail
+
+nr_threads=`expr $(cat /proc/cpuinfo | grep "processor"| wc -l) - 1`
+summary=$($RUN_BENCH -p $nr_threads bpf-map)
+printf "$summary"
diff --git a/tools/testing/selftests/bpf/progs/bpf_map_bench.c b/tools/testing/selftests/bpf/progs/bpf_map_bench.c
new file mode 100644
index 000000000000..655366e6e0f4
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_map_bench.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Bytedance */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include "bpf_misc.h"
+
+char _license[] SEC("license") = "GPL";
+
+#define MAX_ENTRIES 1000
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, u32);
+	__type(value, u64);
+	__uint(max_entries, MAX_ENTRIES);
+} hash_map_bench SEC(".maps");
+
+SEC("fentry/" SYS_PREFIX "sys_getpgid")
+int benchmark(void *ctx)
+{
+	u32 key = bpf_get_prandom_u32();
+	u64 init_val = 1;
+
+	bpf_map_update_elem(&hash_map_bench, &key, &init_val, BPF_ANY);
+	return 0;
+}
-- 
2.20.1


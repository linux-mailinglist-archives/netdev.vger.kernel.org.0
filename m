Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD39925CDAD
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 00:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgICWed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 18:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729306AbgICWdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 18:33:43 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A839C061260
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 15:33:42 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id n189so2478093qkf.9
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 15:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=YtFCPZBdJXDjbSKt5/zjDz8IHcdLgdcZvlnYmeCwFuo=;
        b=NzopNnadr7Oai+HfEWRHMJwJ/Q9TdVS8wC8zHenEGYxbbZb3cJTa+3Kru3qZBeVtaL
         kDYaKSs9YI08ltK1fbuhenJX//XRFp+RVqPvHonTgPIgmYSwhp4A7fHUqpJiUoyctlGP
         +k4guH3ovRpqVgnj6r4Do/15+RIpyxsQ3K3G6T1mcpPhV28S+prrglaKYZhf0yQS71CA
         3u3Lj5MaCVHM/EOHFNbIYJtg1p/0Re2L4J5TM2/FB3nD7fjEFb1WXOQfTNxpC1rEgKPC
         tUeuTadirJTvIa+dCSNPmWR627Bfz6tMb/fHlJ/eTlxaHeXqsaichphqKjvgrcPz76pn
         uSHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YtFCPZBdJXDjbSKt5/zjDz8IHcdLgdcZvlnYmeCwFuo=;
        b=RTWE0uSbRYsDhxkO7nmb74jnWTGva05wSnsiMIMERYdGszqJIGHB/+PvXh51y1JZ3u
         zzkddknB+a6bl9do+r0yW3Ez1KuHhkHfZ5QlhpPRtFAwrunoJLahlsTqfHm5Z+zprkiz
         ZUYnknQGHJ5q1EE4PJJpMnoDiy7eCzZgEXeKUducdlFvchS1v5r0ri4NZtFxsX6jnCfA
         0C5b4ZqlBVEEkstdDM3HOWZPTdh0GRzbLIEqf03NYvtU8+qIqVsohrEHNKDDPCDUqk90
         odCKbtwFjL88pxHJr9ytBsEecsYntZ6IZbkFVeHzwcia+7DI2aSHBz3leHuI8Oq/tP2a
         byOA==
X-Gm-Message-State: AOAM5310buNgl1tM3ADs9HfE0//MhQEHyeUNED0wiUNbrDoPbCdr4idu
        rA4vWGdd9ZfXsTh5V19uGC44ylW5MMMXCI/WtkkB8CcO6zMWaIcdUuUkO/jaXMYlAhfHK8PGzSP
        IIwjBkAWSjOJ5503j/xiTGLGZSlrN6LozXnLloaW8GeuXNGFPJhoRHOqhH6XLNg==
X-Google-Smtp-Source: ABdhPJwVJlctO7Df/2i9YKmbaBnBvhpLZWU0KEsRZQcC6LsYJl/IaM0eQBUQnwrtnH/FMLTSICufzH0uafE=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a05:6214:a85:: with SMTP id
 ev5mr4102957qvb.1.1599172421523; Thu, 03 Sep 2020 15:33:41 -0700 (PDT)
Date:   Thu,  3 Sep 2020 15:33:29 -0700
In-Reply-To: <20200903223332.881541-1-haoluo@google.com>
Message-Id: <20200903223332.881541-4-haoluo@google.com>
Mime-Version: 1.0
References: <20200903223332.881541-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH bpf-next v2 3/6] bpf/selftests: ksyms_btf to test typed ksyms
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Selftests for typed ksyms. Tests two types of ksyms: one is a struct,
the other is a plain int. This tests two paths in the kernel. Struct
ksyms will be converted into PTR_TO_BTF_ID by the verifier while int
typed ksyms will be converted into PTR_TO_MEM.

Signed-off-by: Hao Luo <haoluo@google.com>
---
 .../testing/selftests/bpf/prog_tests/ksyms.c  | 31 +++------
 .../selftests/bpf/prog_tests/ksyms_btf.c      | 63 +++++++++++++++++++
 .../selftests/bpf/progs/test_ksyms_btf.c      | 23 +++++++
 tools/testing/selftests/bpf/trace_helpers.c   | 26 ++++++++
 tools/testing/selftests/bpf/trace_helpers.h   |  4 ++
 5 files changed, 123 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf.c

diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms.c b/tools/testing/selftests/bpf/prog_tests/ksyms.c
index e3d6777226a8..d51ad2aedf64 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms.c
@@ -7,39 +7,22 @@
 
 static int duration;
 
-static __u64 kallsyms_find(const char *sym)
-{
-	char type, name[500];
-	__u64 addr, res = 0;
-	FILE *f;
-
-	f = fopen("/proc/kallsyms", "r");
-	if (CHECK(!f, "kallsyms_fopen", "failed to open: %d\n", errno))
-		return 0;
-
-	while (fscanf(f, "%llx %c %499s%*[^\n]\n", &addr, &type, name) > 0) {
-		if (strcmp(name, sym) == 0) {
-			res = addr;
-			goto out;
-		}
-	}
-
-	CHECK(false, "not_found", "symbol %s not found\n", sym);
-out:
-	fclose(f);
-	return res;
-}
-
 void test_ksyms(void)
 {
-	__u64 link_fops_addr = kallsyms_find("bpf_link_fops");
 	const char *btf_path = "/sys/kernel/btf/vmlinux";
 	struct test_ksyms *skel;
 	struct test_ksyms__data *data;
+	__u64 link_fops_addr;
 	struct stat st;
 	__u64 btf_size;
 	int err;
 
+	err = kallsyms_find("bpf_link_fops", &link_fops_addr);
+	if (CHECK(err == -ENOENT, "kallsyms_fopen", "failed to open: %d\n", errno))
+		return;
+	if (CHECK(err == -EINVAL, "ksym_find", "symbol 'bpf_link_fops' not found\n"))
+		return;
+
 	if (CHECK(stat(btf_path, &st), "stat_btf", "err %d\n", errno))
 		return;
 	btf_size = st.st_size;
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
new file mode 100644
index 000000000000..7b6846342449
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Google */
+
+#include <test_progs.h>
+#include <bpf/libbpf.h>
+#include <bpf/btf.h>
+#include "test_ksyms_btf.skel.h"
+
+static int duration;
+
+void test_ksyms_btf(void)
+{
+	__u64 runqueues_addr, bpf_prog_active_addr;
+	struct test_ksyms_btf *skel;
+	struct test_ksyms_btf__data *data;
+	struct btf *btf;
+	int percpu_datasec;
+	int err;
+
+	err = kallsyms_find("runqueues", &runqueues_addr);
+	if (CHECK(err == -ENOENT, "kallsyms_fopen", "failed to open: %d\n", errno))
+		return;
+	if (CHECK(err == -EINVAL, "ksym_find", "symbol 'runqueues' not found\n"))
+		return;
+
+	err = kallsyms_find("bpf_prog_active", &bpf_prog_active_addr);
+	if (CHECK(err == -EINVAL, "ksym_find", "symbol 'bpf_prog_active' not found\n"))
+		return;
+
+	btf = libbpf_find_kernel_btf();
+	if (CHECK(IS_ERR(btf), "btf_exists", "failed to load kernel BTF: %ld\n",
+		  PTR_ERR(btf)))
+		return;
+
+	percpu_datasec = btf__find_by_name_kind(btf, ".data..percpu",
+						BTF_KIND_DATASEC);
+	if (percpu_datasec < 0) {
+		printf("%s:SKIP:no PERCPU DATASEC in kernel btf\n",
+		       __func__);
+		test__skip();
+		return;
+	}
+
+	skel = test_ksyms_btf__open_and_load();
+	if (CHECK(!skel, "skel_open", "failed to open and load skeleton\n"))
+		return;
+
+	err = test_ksyms_btf__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* trigger tracepoint */
+	usleep(1);
+
+	data = skel->data;
+	CHECK(data->out__runqueues != runqueues_addr, "runqueues",
+	      "got %llu, exp %llu\n", data->out__runqueues, runqueues_addr);
+	CHECK(data->out__bpf_prog_active != bpf_prog_active_addr, "bpf_prog_active",
+	      "got %llu, exp %llu\n", data->out__bpf_prog_active, bpf_prog_active_addr);
+
+cleanup:
+	test_ksyms_btf__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
new file mode 100644
index 000000000000..e04e31117f84
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Google */
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+
+__u64 out__runqueues = -1;
+__u64 out__bpf_prog_active = -1;
+
+extern const struct rq runqueues __ksym; /* struct type global var. */
+extern const int bpf_prog_active __ksym; /* int type global var. */
+
+SEC("raw_tp/sys_enter")
+int handler(const void *ctx)
+{
+	out__runqueues = (__u64)&runqueues;
+	out__bpf_prog_active = (__u64)&bpf_prog_active;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index 4d0e913bbb22..ade555fe8294 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -90,6 +90,32 @@ long ksym_get_addr(const char *name)
 	return 0;
 }
 
+/* open kallsyms and read symbol addresses on the fly. Without caching all symbols,
+ * this is faster than load + find. */
+int kallsyms_find(const char *sym, unsigned long long *addr)
+{
+	char type, name[500];
+	unsigned long long value;
+	int err = 0;
+	FILE *f;
+
+	f = fopen("/proc/kallsyms", "r");
+	if (!f)
+		return -ENOENT;
+
+	while (fscanf(f, "%llx %c %499s%*[^\n]\n", &value, &type, name) > 0) {
+		if (strcmp(name, sym) == 0) {
+			*addr = value;
+			goto out;
+		}
+	}
+	err = -EINVAL;
+
+out:
+	fclose(f);
+	return err;
+}
+
 void read_trace_pipe(void)
 {
 	int trace_fd;
diff --git a/tools/testing/selftests/bpf/trace_helpers.h b/tools/testing/selftests/bpf/trace_helpers.h
index 25ef597dd03f..f62fdef9e589 100644
--- a/tools/testing/selftests/bpf/trace_helpers.h
+++ b/tools/testing/selftests/bpf/trace_helpers.h
@@ -12,6 +12,10 @@ struct ksym {
 int load_kallsyms(void);
 struct ksym *ksym_search(long key);
 long ksym_get_addr(const char *name);
+
+/* open kallsyms and find addresses on the fly, faster than load + search. */
+int kallsyms_find(const char *sym, unsigned long long *addr);
+
 void read_trace_pipe(void);
 
 #endif
-- 
2.28.0.526.ge36021eeef-goog


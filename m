Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90ED26CEE7
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgIPWjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgIPWiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:38:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54E3C06178A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 15:37:59 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y6so273907ybi.11
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 15:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=vvYBQtKOgN8kXGYHKygvkHrl9r9E5uPOXUkMOvuJWis=;
        b=BGuTIed0/xRLqTymp3GxzBLK7ty88WIXznYGAUf6pH+x8egUjGRyADtzW0zfQAmS4i
         Hwat4HvqMDy/nIcmU517KEM4vJsxEMD/X66C5aa89IbaF6baeKaL7+Jle7OCax6nZkLQ
         x9EFG28nq8mDiIxO9qbutHAI74Q4uO9o1ozbhRHxOGJpJta8sCvQlIWuUKDnmn2WPGhH
         KDFXkM7aVOVfhr9ulIsjUdBpqlBeNUxrpLf+VC/rFM41BR9j7EI2ZAf5CC5bJHhK8woc
         5xBNfEdt6udsTuchpG9htAmBBXxNe3i8Icb41gthGybNsUFLsp3S7e7pyG0TcJcGK0UX
         Xh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vvYBQtKOgN8kXGYHKygvkHrl9r9E5uPOXUkMOvuJWis=;
        b=QONajiieG0uXSV34pGJANhvXhp77xSitRYzw1XxxxHsdfvV/Ni+xcmiVGqTZ2CL44O
         BtFNrM0JABsFbVvUsfFDRw+jLlb6nWSMeDpsjxlPUr6W8XrWdv0OjMfis/ES1lWyBs5x
         rBcsh9TYpuCBOJyliP7zeLge967lbEjKxIbBvKMxDhim4iDqHdrLwMeD6wFQZqVC1FLJ
         +eHHKpiDVrlxOPm0tm947oWQHrq2nizqM67g5PzVenf7H1VcZp150fJQzjHyu7lFUKRj
         W4A/+vkrUvcJK4eJSMB+9+U3wzz35ULe2ZQtS1EkBE5fpvQqEcFI+FsTdJ+s6yabHZxN
         v47g==
X-Gm-Message-State: AOAM532LxfDCuS7edsbd9dT7ETobSQwvKGOshDAsytjjfuUIjaiuIcj9
        gnINJFCyoAVbwtJbuwkCoN3n2aVbaXt4As+6TCK8e5kkn2/HaZNjjsQN6UNanGGFfAz8hsv4sPO
        VgtzroEO4VpTyu4RrbyOBkQUGmw7gqNuEO4rCJQRcQRZLg6YnkN5Nju9TQevXJQ==
X-Google-Smtp-Source: ABdhPJwWfzm5gcI4TQecIvpOsrWcubyrCwa2wyUceV4lWyRUVpMo7F10KeOp24rUjw1kqWq/hx0pO/R3/YQ=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a25:338b:: with SMTP id z133mr39068013ybz.54.1600295879018;
 Wed, 16 Sep 2020 15:37:59 -0700 (PDT)
Date:   Wed, 16 Sep 2020 15:35:09 -0700
In-Reply-To: <20200916223512.2885524-1-haoluo@google.com>
Message-Id: <20200916223512.2885524-4-haoluo@google.com>
Mime-Version: 1.0
References: <20200916223512.2885524-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH bpf-next v3 3/6] selftests/bpf: ksyms_btf to test typed ksyms
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
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Selftests for typed ksyms. Tests two types of ksyms: one is a struct,
the other is a plain int. This tests two paths in the kernel. Struct
ksyms will be converted into PTR_TO_BTF_ID by the verifier while int
typed ksyms will be converted into PTR_TO_MEM.

Signed-off-by: Hao Luo <haoluo@google.com>
---
 .../testing/selftests/bpf/prog_tests/ksyms.c  | 38 ++++------
 .../selftests/bpf/prog_tests/ksyms_btf.c      | 70 +++++++++++++++++++
 .../selftests/bpf/progs/test_ksyms_btf.c      | 23 ++++++
 tools/testing/selftests/bpf/trace_helpers.c   | 27 +++++++
 tools/testing/selftests/bpf/trace_helpers.h   |  4 ++
 5 files changed, 137 insertions(+), 25 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf.c

diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms.c b/tools/testing/selftests/bpf/prog_tests/ksyms.c
index b771804b2342..b295969b263b 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms.c
@@ -7,40 +7,28 @@
 
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
-	__u64 per_cpu_start_addr = kallsyms_find("__per_cpu_start");
-	__u64 link_fops_addr = kallsyms_find("bpf_link_fops");
 	const char *btf_path = "/sys/kernel/btf/vmlinux";
 	struct test_ksyms *skel;
 	struct test_ksyms__data *data;
+	__u64 link_fops_addr, per_cpu_start_addr;
 	struct stat st;
 	__u64 btf_size;
 	int err;
 
+	err = kallsyms_find("bpf_link_fops", &link_fops_addr);
+	if (CHECK(err == -EINVAL, "kallsyms_fopen", "failed to open: %d\n", errno))
+		return;
+	if (CHECK(err == -ENOENT, "ksym_find", "symbol 'bpf_link_fops' not found\n"))
+		return;
+
+	err = kallsyms_find("__per_cpu_start", &per_cpu_start_addr);
+	if (CHECK(err == -EINVAL, "kallsyms_fopen", "failed to open: %d\n", errno))
+		return;
+	if (CHECK(err == -ENOENT, "ksym_find", "symbol 'per_cpu_start' not found\n"))
+		return;
+
 	if (CHECK(stat(btf_path, &st), "stat_btf", "err %d\n", errno))
 		return;
 	btf_size = st.st_size;
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
new file mode 100644
index 000000000000..c6ef06c0629a
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -0,0 +1,70 @@
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
+	struct test_ksyms_btf *skel = NULL;
+	struct test_ksyms_btf__data *data;
+	struct btf *btf;
+	int percpu_datasec;
+	int err;
+
+	err = kallsyms_find("runqueues", &runqueues_addr);
+	if (CHECK(err == -EINVAL, "kallsyms_fopen", "failed to open: %d\n", errno))
+		return;
+	if (CHECK(err == -ENOENT, "ksym_find", "symbol 'runqueues' not found\n"))
+		return;
+
+	err = kallsyms_find("bpf_prog_active", &bpf_prog_active_addr);
+	if (CHECK(err == -EINVAL, "kallsyms_fopen", "failed to open: %d\n", errno))
+		return;
+	if (CHECK(err == -ENOENT, "ksym_find", "symbol 'bpf_prog_active' not found\n"))
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
+		goto cleanup;
+	}
+
+	skel = test_ksyms_btf__open_and_load();
+	if (CHECK(!skel, "skel_open", "failed to open and load skeleton\n"))
+		goto cleanup;
+
+	err = test_ksyms_btf__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* trigger tracepoint */
+	usleep(1);
+
+	data = skel->data;
+	CHECK(data->out__runqueues_addr != runqueues_addr, "runqueues_addr",
+	      "got %llu, exp %llu\n",
+	      (unsigned long long)data->out__runqueues_addr,
+	      (unsigned long long)runqueues_addr);
+	CHECK(data->out__bpf_prog_active_addr != bpf_prog_active_addr, "bpf_prog_active_addr",
+	      "got %llu, exp %llu\n",
+	      (unsigned long long)data->out__bpf_prog_active_addr,
+	      (unsigned long long)bpf_prog_active_addr);
+
+cleanup:
+	btf__free(btf);
+	test_ksyms_btf__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
new file mode 100644
index 000000000000..7dde2082131d
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
+__u64 out__runqueues_addr = -1;
+__u64 out__bpf_prog_active_addr = -1;
+
+extern const struct rq runqueues __ksym; /* struct type global var. */
+extern const int bpf_prog_active __ksym; /* int type global var. */
+
+SEC("raw_tp/sys_enter")
+int handler(const void *ctx)
+{
+	out__runqueues_addr = (__u64)&runqueues;
+	out__bpf_prog_active_addr = (__u64)&bpf_prog_active;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index 4d0e913bbb22..1bbd1d9830c8 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -90,6 +90,33 @@ long ksym_get_addr(const char *name)
 	return 0;
 }
 
+/* open kallsyms and read symbol addresses on the fly. Without caching all symbols,
+ * this is faster than load + find.
+ */
+int kallsyms_find(const char *sym, unsigned long long *addr)
+{
+	char type, name[500];
+	unsigned long long value;
+	int err = 0;
+	FILE *f;
+
+	f = fopen("/proc/kallsyms", "r");
+	if (!f)
+		return -EINVAL;
+
+	while (fscanf(f, "%llx %c %499s%*[^\n]\n", &value, &type, name) > 0) {
+		if (strcmp(name, sym) == 0) {
+			*addr = value;
+			goto out;
+		}
+	}
+	err = -ENOENT;
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
2.28.0.618.gf4bc123cb7-goog


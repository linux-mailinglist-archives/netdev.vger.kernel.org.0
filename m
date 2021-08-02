Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3AC3DE1A4
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 23:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbhHBV2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 17:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbhHBV2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 17:28:50 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72059C061764
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 14:28:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 16-20020a250b100000b029055791ebe1e6so20691413ybl.20
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 14:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ODkZ12y9VJZTq4nc4bH4DoKlUmZBSPQz81yAqgkg0eE=;
        b=BzK32olg2iQlqF9m7iU2aJmAcx+SSv8kSnQpHpBwBtSKiDPgl+xTOZIQme7PJRZPqt
         d0tb1n0PHNb/+lbOaMQdOVwSqnACyrc8qQg96jQz/Jexiteg3GZatc4ZTAq6396bA2pT
         JxsBUfHwgiyhCwvI1AoL3eMhC7JZHF3xHzJSOFiyHuZiz7CN9Dng+fRiGy1XKsgTk5bd
         t31/zlw6kiCfEwrGZwwkPruQj9C5BSRvK1kHw70wjfztxN7IbPZFTQyzCLiY42q4aDrd
         58wgUukaugcs6rzm74Vw6ysOMQ5MyPx8tPVvpdLOCc7Laao2C21IiXA/4ER4dtSvZCoq
         dK8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ODkZ12y9VJZTq4nc4bH4DoKlUmZBSPQz81yAqgkg0eE=;
        b=ihV4wUUUjvcnU8+lPPY5327fNyAXr7mv2NwdKHF73XVfmvmItFzrMpSeWaLZClF413
         3NbDKenRgDBkAzyjYmwxF5v/dpbczFUTyst/K4zY6hIP7A0rYlyZcDjCBK4fb3SzUSF3
         XsL2Is5j4FLIAxPovuaEBk+Jf3+BPgTYqIGLaf4HzzraI33ulLCO0LL/7fiSDEI4aq00
         MCqD8GaRvdDs2PDBSCE14Gt1kcJ0JJlpl149M/9BnRqqQ4s78YjNxDCfWiXERNAm2oYr
         LqnQpfBirM+do9phaXsWuYlbgPuoMdu6Jrc/bvd8zeWNzKwOnPmFJG6uIz9noM1DV0rv
         83aQ==
X-Gm-Message-State: AOAM533YeYdAH/m0AUp10Hsqct/k7Fin3C9mJKfluZ4g0TZ8T2KGK8Fh
        8YgQp3TwunKwG1TQ37vd8KUN1w73WfJ/k+ZxVyyknwiqSIahls8/8pO33Ng0WvAImrNx7bvXZWq
        rrt9n4jW8H5CL1c7wiPySa6GpedOKAKviktdaUNcpno4BBZRZ7HArbMfr6SEbcQ==
X-Google-Smtp-Source: ABdhPJzG5tGog1iLpbDVSPxQPFlC3Q++sFxIWR8R2zRBMb2yxEKRoqMaxnQx6waRy8j6zNNe6N7+vEe6ILI=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:d458:19a6:9920:f320])
 (user=haoluo job=sendgmr) by 2002:a25:a286:: with SMTP id c6mr22889747ybi.349.1627939719573;
 Mon, 02 Aug 2021 14:28:39 -0700 (PDT)
Date:   Mon,  2 Aug 2021 14:28:15 -0700
Message-Id: <20210802212815.3488773-1-haoluo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH bpf-next] libbpf: support weak typed ksyms.
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently weak typeless ksyms have default value zero, when they don't
exist in the kernel. However, weak typed ksyms are rejected by libbpf.
This means that if a bpf object contains the declaration of a
non-existing weak typed ksym, it will be rejected even if there is
no program that references the symbol.

In fact, we could let them to pass the checks in libbpf and leave the
object to be rejected by the bpf verifier. More specifically, upon
seeing a weak typed symbol, libbpf can assign it a zero btf_id, which
is associated to the type 'void'. The verifier expects the symbol to
be BTF_VAR_KIND instead, therefore will reject loading.

In practice, we often add new kernel symbols and roll out the kernel
changes to fleet. And we want to release a single bpf object that can
be loaded on both the new and the old kernels. Passing weak typed ksyms
in libbpf allows us to do so as long as the programs that reference the
new symbols are disabled on the old kernel.

Signed-off-by: Hao Luo <haoluo@google.com>
---
 tools/lib/bpf/libbpf.c                        | 17 +++++-
 .../selftests/bpf/prog_tests/ksyms_btf.c      | 42 +++++++++++++
 .../selftests/bpf/progs/test_ksyms_weak.c     | 60 +++++++++++++++++++
 3 files changed, 116 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_weak.c

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index cb106e8c42cb..1cac02bfa599 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6584,7 +6584,7 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
 }
 
 static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_name,
-			    __u16 kind, struct btf **res_btf,
+			    __u16 kind, bool is_weak, struct btf **res_btf,
 			    int *res_btf_fd)
 {
 	int i, id, btf_fd, err;
@@ -6608,6 +6608,9 @@ static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_name,
 				break;
 		}
 	}
+	if (is_weak && id == -ENOENT)
+		return 0;
+
 	if (id <= 0) {
 		pr_warn("extern (%s ksym) '%s': failed to find BTF ID in kernel BTF(s).\n",
 			__btf_kind_str(kind), ksym_name);
@@ -6627,11 +6630,19 @@ static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
 	const char *targ_var_name;
 	int id, btf_fd = 0, err;
 	struct btf *btf = NULL;
+	bool is_weak = ext->is_weak;
 
-	id = find_ksym_btf_id(obj, ext->name, BTF_KIND_VAR, &btf, &btf_fd);
+	id = find_ksym_btf_id(obj, ext->name, BTF_KIND_VAR, is_weak, &btf, &btf_fd);
 	if (id < 0)
 		return id;
 
+	if (is_weak && id == 0) {
+		ext->is_set = true;
+		ext->ksym.kernel_btf_obj_fd = 0;
+		ext->ksym.kernel_btf_id = 0;
+		return 0;
+	}
+
 	/* find local type_id */
 	local_type_id = ext->ksym.type_id;
 
@@ -6676,7 +6687,7 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 
 	local_func_proto_id = ext->ksym.type_id;
 
-	kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC,
+	kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC, false,
 				    &kern_btf, &kern_btf_fd);
 	if (kfunc_id < 0) {
 		pr_warn("extern (func ksym) '%s': not found in kernel BTF\n",
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
index 67bebd324147..12a5e5ebcc3d 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -6,6 +6,7 @@
 #include <bpf/btf.h>
 #include "test_ksyms_btf.skel.h"
 #include "test_ksyms_btf_null_check.skel.h"
+#include "test_ksyms_weak.skel.h"
 
 static int duration;
 
@@ -81,6 +82,44 @@ static void test_null_check(void)
 	test_ksyms_btf_null_check__destroy(skel);
 }
 
+static void test_weak_syms(void)
+{
+	struct test_ksyms_weak *skel;
+	struct test_ksyms_weak__data *data;
+
+	skel = test_ksyms_weak__open_and_load();
+	if (CHECK(skel, "skel_open_and_load",
+		  "unexpected load of a prog referencing non-existing ksyms\n")) {
+		test_ksyms_weak__destroy(skel);
+		return;
+	}
+
+	skel = test_ksyms_weak__open();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		return;
+
+	bpf_program__set_autoload(skel->progs.fail_handler, false);
+	if (CHECK(test_ksyms_weak__load(skel), "skel_load", "failed to load skeleton\n"))
+		goto cleanup;
+
+	if (CHECK(test_ksyms_weak__attach(skel), "skel_attach", "failed to attach skeleton\n"))
+		goto cleanup;
+
+	/* trigger tracepoint */
+	usleep(1);
+
+	data = skel->data;
+	CHECK(data->out__existing_typed != 0, "existing_typed",
+	      "failed to reference an existing typed symbol\n");
+	CHECK(data->out__existing_typeless == -1, "existing_typeless",
+	      "failed to get the address of an existing typeless symbol\n");
+	CHECK(data->out__non_existing_typeless != 0, "non_existing_typeless",
+	      "non-existing typeless symbol does not default to zero\n");
+
+cleanup:
+	test_ksyms_weak__destroy(skel);
+}
+
 void test_ksyms_btf(void)
 {
 	int percpu_datasec;
@@ -105,4 +144,7 @@ void test_ksyms_btf(void)
 
 	if (test__start_subtest("null_check"))
 		test_null_check();
+
+	if (test__start_subtest("weak_ksyms"))
+		test_weak_syms();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
new file mode 100644
index 000000000000..e956fdf3162c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test weak ksyms.
+ *
+ * Copyright (c) 2021 Google
+ */
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+
+int out__existing_typed = -1;
+__u64 out__existing_typeless = -1;
+
+__u64 out__non_existing_typeless = -1;
+__u64 out__non_existing_typed = -1;
+
+/* existing weak symbols */
+
+/* test existing weak symbols can be resolved. */
+extern const struct rq runqueues __ksym __weak; /* typed */
+extern const void bpf_prog_active __ksym __weak; /* typeless */
+
+
+/* non-existing weak symbols. */
+
+/* typeless symbols, default to zero. */
+extern const void bpf_link_fops1 __ksym __weak;
+
+/* typed symbols, fail verifier checks if referenced. */
+extern const int bpf_link_fops2 __ksym __weak;
+
+/* typed symbols, pass if not referenced. */
+extern const int bpf_link_fops3 __ksym __weak;
+
+SEC("raw_tp/sys_enter")
+int pass_handler(const void *ctx)
+{
+	/* tests existing symbols. */
+	struct rq *rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, 0);
+	if (rq)
+		out__existing_typed = rq->cpu;
+	out__existing_typeless = (__u64)&bpf_prog_active;
+
+	/* tests non-existing symbols. */
+	out__non_existing_typeless = (__u64)&bpf_link_fops1;
+
+	return 0;
+}
+
+SEC("raw_tp/sys_exit")
+int fail_handler(const void *ctx)
+{
+	/* tests non-existing symbols. */
+	out__non_existing_typed = (__u64)&bpf_link_fops2;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.32.0.554.ge1b32706d8-goog


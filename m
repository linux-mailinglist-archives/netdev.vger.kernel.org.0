Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3B63E9AFA
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbhHKWlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbhHKWlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 18:41:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24BDC0613D3
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 15:40:40 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id c63-20020a25e5420000b0290580b26e708aso4141172ybh.12
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 15:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=0Kk1Ly3+8Zmn4nGcb3Ki0q34Pvxk1NKTaTJ+2bwT2C8=;
        b=b+zgDJuwGPLjZnHkA9uJ/d2iNa4iSOjQGHgwSiYFnV4lmNY2iFPvaHUtt4/fvOA0CZ
         V2h1zF47wJG6TVOOCTj0fCxx/ObTkCHGWr8Zot4ry7tM1lI9WchDjSj1tNAUqRK+YeCQ
         CxwxE5po9OxgHBR1XOQ8yJxk//IHcSurjjHtL0g9h95D9OdmgKsuzTTYx135/ExScGOz
         jOPAAZRXwXoJ/QqJ6Z/bW0sUqqrwDY3sRM/TpRpkQ4WStozsF+b4E5LdsCRi3ee696US
         sQfyvvv9Jh0yV9DjHUpeCXrCzHLcPweA7cFZTiAQqpAbCWrlbGYNNWeHf2jYmJTFAd1D
         ZS3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=0Kk1Ly3+8Zmn4nGcb3Ki0q34Pvxk1NKTaTJ+2bwT2C8=;
        b=ehtfMCUR1PWQj+yq8NACq1xXkaJ2rhgC8EFEwscdBX4+45oTCFE+K1AdnSqxCkEItj
         VyzJmMQoV+RXZd1sANzuaH2xuwNCDlo5JQzLgC4W8uTlkjHJy45Hc5bgtsOXWfV5aT0f
         xVgrdU/oy6uW1FpkhBFjTllxnNsyUnAnqrzkvxyw7CrEfa7ecftBijCzTKM/yNbTYDX4
         +XRrtGMTVeEmIBLWfIkM+V0pcjLf/Dffk25kMPCGMUs3DbXxwrVIVgk6woyku29yRc68
         Uix/tqwt7ppYGb+Dlqgk7sMLk3ZMPpWd5zPETFAX+2snOBfo5uKo9oCX0gKd1HGvMmn5
         hlWg==
X-Gm-Message-State: AOAM5316ARRklARYodd+j05iVaEnGN+YQDXTHeISCwLzWAFdLzJ7mOz9
        1Et61tLNwODc/OuQ8F+EaYQKwvSNuB4gj9a0+L1qacoxIs65YDlh0/mV4smos3DLapoYiwq1jun
        mA79lwGZNbVZZusj+zlh/S+vJegLuX9fj6goIQsjbfwBU39qmI+JTnRsBwJr1QQ==
X-Google-Smtp-Source: ABdhPJy3XESaIdtx7zYheLyyF2L7JYmQvF+St+vF/DI33J8ykF6isvFxQPj72iwRk4n6jOVrxYTmcklYPvY=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:d426:eb6d:7242:119b])
 (user=haoluo job=sendgmr) by 2002:a25:4187:: with SMTP id o129mr369323yba.455.1628721639806;
 Wed, 11 Aug 2021 15:40:39 -0700 (PDT)
Date:   Wed, 11 Aug 2021 15:40:36 -0700
Message-Id: <20210811224036.2416308-1-haoluo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH bpf-next v2] libbpf: support weak typed ksyms.
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
exist in the kernel. However, weak typed ksyms are rejected by libbpf
if they can not be resolved. This means that if a bpf object contains
the declaration of a nonexistent weak typed ksym, it will be rejected
even if there is no program that references the symbol.

Nonexistent weak typed ksyms can also default to zero just like
typeless ones. This allows programs that access weak typed ksyms to be
accepted by verifier, if the accesses are guarded. For example,

extern const int bpf_link_fops3 __ksym __weak;

/* then in BPF program */

if (&bpf_link_fops3) {
   /* use bpf_link_fops3 */
}

If actual use of nonexistent typed ksym is not guarded properly,
verifier would see that register is not PTR_TO_BTF_ID and wouldn't
allow to use it for direct memory reads or passing it to BPF helpers.

Signed-off-by: Hao Luo <haoluo@google.com>
---
 Changes since v1:
  - Weak typed symbols default to zero, as suggested by Andrii.
  - Use ASSERT_XXX() for tests.

 tools/lib/bpf/libbpf.c                        | 17 ++++--
 .../selftests/bpf/prog_tests/ksyms_btf.c      | 31 ++++++++++
 .../selftests/bpf/progs/test_ksyms_weak.c     | 57 +++++++++++++++++++
 3 files changed, 100 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_weak.c

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index cb106e8c42cb..e7547a2967cf 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5277,11 +5277,11 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 				}
 				insn[1].imm = ext->kcfg.data_off;
 			} else /* EXT_KSYM */ {
-				if (ext->ksym.type_id) { /* typed ksyms */
+				if (ext->ksym.type_id && ext->is_set) { /* typed ksyms */
 					insn[0].src_reg = BPF_PSEUDO_BTF_ID;
 					insn[0].imm = ext->ksym.kernel_btf_id;
 					insn[1].imm = ext->ksym.kernel_btf_obj_fd;
-				} else { /* typeless ksyms */
+				} else { /* typeless ksyms or unresolved typed ksyms */
 					insn[0].imm = (__u32)ext->ksym.addr;
 					insn[1].imm = ext->ksym.addr >> 32;
 				}
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
@@ -6627,11 +6630,15 @@ static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
 	const char *targ_var_name;
 	int id, btf_fd = 0, err;
 	struct btf *btf = NULL;
+	bool is_weak = ext->is_weak;
 
-	id = find_ksym_btf_id(obj, ext->name, BTF_KIND_VAR, &btf, &btf_fd);
+	id = find_ksym_btf_id(obj, ext->name, BTF_KIND_VAR, is_weak, &btf, &btf_fd);
 	if (id < 0)
 		return id;
 
+	if (is_weak && id == 0)
+		return 0;
+
 	/* find local type_id */
 	local_type_id = ext->ksym.type_id;
 
@@ -6676,7 +6683,7 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 
 	local_func_proto_id = ext->ksym.type_id;
 
-	kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC,
+	kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC, false,
 				    &kern_btf, &kern_btf_fd);
 	if (kfunc_id < 0) {
 		pr_warn("extern (func ksym) '%s': not found in kernel BTF\n",
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
index 67bebd324147..cf3acfa5a91d 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -6,6 +6,7 @@
 #include <bpf/btf.h>
 #include "test_ksyms_btf.skel.h"
 #include "test_ksyms_btf_null_check.skel.h"
+#include "test_ksyms_weak.skel.h"
 
 static int duration;
 
@@ -81,6 +82,33 @@ static void test_null_check(void)
 	test_ksyms_btf_null_check__destroy(skel);
 }
 
+static void test_weak_syms(void)
+{
+	struct test_ksyms_weak *skel;
+	struct test_ksyms_weak__data *data;
+	int err;
+
+	skel = test_ksyms_weak__open_and_load();
+	if (CHECK(!skel, "test_ksyms_weak__open_and_load", "failed\n"))
+		return;
+
+	err = test_ksyms_weak__attach(skel);
+	if (CHECK(err, "test_ksyms_weak__attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* trigger tracepoint */
+	usleep(1);
+
+	data = skel->data;
+	ASSERT_EQ(data->out__existing_typed, 0, "existing typed ksym");
+	ASSERT_NEQ(data->out__existing_typeless, -1, "existing typeless ksym");
+	ASSERT_EQ(data->out__non_existent_typeless, 0, "nonexistent typeless ksym");
+	ASSERT_EQ(data->out__non_existent_typed, 0, "nonexistent typed ksym");
+
+cleanup:
+	test_ksyms_weak__destroy(skel);
+}
+
 void test_ksyms_btf(void)
 {
 	int percpu_datasec;
@@ -105,4 +133,7 @@ void test_ksyms_btf(void)
 
 	if (test__start_subtest("null_check"))
 		test_null_check();
+
+	if (test__start_subtest("weak_ksyms"))
+		test_weak_syms();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
new file mode 100644
index 000000000000..9b099fa59822
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
@@ -0,0 +1,57 @@
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
+__u64 out__non_existent_typeless = -1;
+__u64 out__non_existent_typed = -1;
+
+/* existing weak symbols */
+
+/* test existing weak symbols can be resolved. */
+extern const struct rq runqueues __ksym __weak; /* typed */
+extern const void bpf_prog_active __ksym __weak; /* typeless */
+
+
+/* non-existent weak symbols. */
+
+/* typeless symbols, default to zero. */
+extern const void bpf_link_fops1 __ksym __weak;
+
+/* typed symbols, default to zero. */
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
+	/* tests non-existent symbols. */
+	out__non_existent_typeless = (__u64)&bpf_link_fops1;
+
+	/* tests non-existent symbols. */
+	out__non_existent_typed = (__u64)&bpf_link_fops2;
+
+	if (&bpf_link_fops2) /* can't happen */
+		out__non_existent_typed = (__u64)bpf_per_cpu_ptr(&bpf_link_fops2, 0);
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.32.0.605.g8dce9f2422-goog


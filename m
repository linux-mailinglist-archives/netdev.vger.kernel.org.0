Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115DC5AEF90
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 17:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbiIFPzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 11:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbiIFPzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 11:55:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EBD8E0DB
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 08:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662477206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hqVG6kot2DG2+/bzipVphXBv4av3jZ6NLb872Gyl1U0=;
        b=BMYDRvxfWAUZUQBhMnDTX2Z2KEbFflyFiLiKK2nvLCObsx8DkJGoElVebmMOJzcLPuzdm0
        ZJpQFkXz9eV9hI51zTab2sSffS+In+cP3/aFUgqnGWtxLwlssJgvpP4HbJ3SD2m0VKtE2q
        A5d5UMQb9DA7M1gXA7etVwHicmdXo0A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-yjVdq830NFqmJbna3EU-YQ-1; Tue, 06 Sep 2022 11:13:23 -0400
X-MC-Unique: yjVdq830NFqmJbna3EU-YQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E6B380418F;
        Tue,  6 Sep 2022 15:13:23 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D152840D296C;
        Tue,  6 Sep 2022 15:13:20 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v11 4/7] selftests/bpf: add test for accessing ctx from syscall program type
Date:   Tue,  6 Sep 2022 17:13:00 +0200
Message-Id: <20220906151303.2780789-5-benjamin.tissoires@redhat.com>
In-Reply-To: <20220906151303.2780789-1-benjamin.tissoires@redhat.com>
References: <20220906151303.2780789-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to also export the kfunc set to the syscall program type,
and then add a couple of eBPF programs that are testing those calls.

The first one checks for valid access, and the second one is OK
from a static analysis point of view but fails at run time because
we are trying to access outside of the allocated memory.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v11:
- use new way of declaring tests

changes in v10:
- use new definitions for tests in an array
- add a new kfunc syscall_test_null_fail test

no changes in v9

no changes in v8

changes in v7:
- add 1 more case to ensure we can read the entire sizeof(ctx)
- add a test case for when the context is NULL

new in v6
---
 net/bpf/test_run.c                            |   1 +
 .../selftests/bpf/prog_tests/kfunc_call.c     | 143 +++++++++++++++++-
 .../selftests/bpf/progs/kfunc_call_fail.c     |  39 +++++
 .../selftests/bpf/progs/kfunc_call_test.c     |  38 +++++
 4 files changed, 214 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_fail.c

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 25d8ecf105aa..f16baf977a21 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1634,6 +1634,7 @@ static int __init bpf_prog_test_run_init(void)
 
 	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_prog_test_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &bpf_prog_test_kfunc_set);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &bpf_prog_test_kfunc_set);
 	return ret ?: register_btf_id_dtor_kfuncs(bpf_prog_test_dtor_kfunc,
 						  ARRAY_SIZE(bpf_prog_test_dtor_kfunc),
 						  THIS_MODULE);
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index 9dfbe5355a2d..d5881c3331a8 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2021 Facebook */
 #include <test_progs.h>
 #include <network_helpers.h>
+#include "kfunc_call_fail.skel.h"
 #include "kfunc_call_test.skel.h"
 #include "kfunc_call_test.lskel.h"
 #include "kfunc_call_test_subprog.skel.h"
@@ -10,37 +11,96 @@
 
 #include "cap_helpers.h"
 
+static size_t log_buf_sz = 1048576; /* 1 MB */
+static char obj_log_buf[1048576];
+
+enum kfunc_test_type {
+	tc_test = 0,
+	syscall_test,
+	syscall_null_ctx_test,
+};
+
 struct kfunc_test_params {
 	const char *prog_name;
 	unsigned long lskel_prog_desc_offset;
 	int retval;
+	enum kfunc_test_type test_type;
+	const char *expected_err_msg;
 };
 
-#define TC_TEST(name, __retval) \
+#define __BPF_TEST_SUCCESS(name, __retval, type) \
 	{ \
 	  .prog_name = #name, \
 	  .lskel_prog_desc_offset = offsetof(struct kfunc_call_test_lskel, progs.name), \
 	  .retval = __retval, \
+	  .test_type = type, \
+	  .expected_err_msg = NULL, \
+	}
+
+#define __BPF_TEST_FAIL(name, __retval, type, error_msg) \
+	{ \
+	  .prog_name = #name, \
+	  .lskel_prog_desc_offset = 0 /* unused when test is failing */, \
+	  .retval = __retval, \
+	  .test_type = type, \
+	  .expected_err_msg = error_msg, \
 	}
 
+#define TC_TEST(name, retval) __BPF_TEST_SUCCESS(name, retval, tc_test)
+#define SYSCALL_TEST(name, retval) __BPF_TEST_SUCCESS(name, retval, syscall_test)
+#define SYSCALL_NULL_CTX_TEST(name, retval) __BPF_TEST_SUCCESS(name, retval, syscall_null_ctx_test)
+
+#define SYSCALL_NULL_CTX_FAIL(name, retval, error_msg) \
+	__BPF_TEST_FAIL(name, retval, syscall_null_ctx_test, error_msg)
+
 static struct kfunc_test_params kfunc_tests[] = {
+	/* failure cases:
+	 * if retval is 0 -> the program will fail to load and the error message is an error
+	 * if retval is not 0 -> the program can be loaded but running it will gives the
+	 *                       provided return value. The error message is thus the one
+	 *                       from a successful load
+	 */
+	SYSCALL_NULL_CTX_FAIL(kfunc_syscall_test_fail, -EINVAL, "processed 4 insns"),
+	SYSCALL_NULL_CTX_FAIL(kfunc_syscall_test_null_fail, -EINVAL, "processed 4 insns"),
+
+	/* success cases */
 	TC_TEST(kfunc_call_test1, 12),
 	TC_TEST(kfunc_call_test2, 3),
 	TC_TEST(kfunc_call_test_ref_btf_id, 0),
+	SYSCALL_TEST(kfunc_syscall_test, 0),
+	SYSCALL_NULL_CTX_TEST(kfunc_syscall_test_null, 0),
+};
+
+struct syscall_test_args {
+	__u8 data[16];
+	size_t size;
 };
 
 static void verify_success(struct kfunc_test_params *param)
 {
 	struct kfunc_call_test_lskel *lskel = NULL;
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
 	struct bpf_prog_desc *lskel_prog;
 	struct kfunc_call_test *skel;
 	struct bpf_program *prog;
 	int prog_fd, err;
-	LIBBPF_OPTS(bpf_test_run_opts, topts,
-		.data_in = &pkt_v4,
-		.data_size_in = sizeof(pkt_v4),
-		.repeat = 1,
-	);
+	struct syscall_test_args args = {
+		.size = 10,
+	};
+
+	switch (param->test_type) {
+	case syscall_test:
+		topts.ctx_in = &args;
+		topts.ctx_size_in = sizeof(args);
+		/* fallthrough */
+	case syscall_null_ctx_test:
+		break;
+	case tc_test:
+		topts.data_in = &pkt_v4;
+		topts.data_size_in = sizeof(pkt_v4);
+		topts.repeat = 1;
+		break;
+	}
 
 	/* first test with normal libbpf */
 	skel = kfunc_call_test__open_and_load();
@@ -79,6 +139,72 @@ static void verify_success(struct kfunc_test_params *param)
 		kfunc_call_test_lskel__destroy(lskel);
 }
 
+static void verify_fail(struct kfunc_test_params *param)
+{
+	LIBBPF_OPTS(bpf_object_open_opts, opts);
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+	struct bpf_program *prog;
+	struct kfunc_call_fail *skel;
+	int prog_fd, err;
+	struct syscall_test_args args = {
+		.size = 10,
+	};
+
+	opts.kernel_log_buf = obj_log_buf;
+	opts.kernel_log_size = log_buf_sz;
+	opts.kernel_log_level = 1;
+
+	switch (param->test_type) {
+	case syscall_test:
+		topts.ctx_in = &args;
+		topts.ctx_size_in = sizeof(args);
+		/* fallthrough */
+	case syscall_null_ctx_test:
+		break;
+	case tc_test:
+		topts.data_in = &pkt_v4;
+		topts.data_size_in = sizeof(pkt_v4);
+		break;
+		topts.repeat = 1;
+	}
+
+	skel = kfunc_call_fail__open_opts(&opts);
+	if (!ASSERT_OK_PTR(skel, "kfunc_call_fail__open_opts"))
+		goto cleanup;
+
+	prog = bpf_object__find_program_by_name(skel->obj, param->prog_name);
+	if (!ASSERT_OK_PTR(prog, "bpf_object__find_program_by_name"))
+		goto cleanup;
+
+	bpf_program__set_autoload(prog, true);
+
+	err = kfunc_call_fail__load(skel);
+	if (!param->retval) {
+		/* the verifier is supposed to complain and refuses to load */
+		if (!ASSERT_ERR(err, "unexpected load success"))
+			goto out_err;
+
+	} else {
+		/* the program is loaded but must dynamically fail */
+		if (!ASSERT_OK(err, "unexpected load error"))
+			goto out_err;
+
+		prog_fd = bpf_program__fd(prog);
+		err = bpf_prog_test_run_opts(prog_fd, &topts);
+		if (!ASSERT_EQ(err, param->retval, param->prog_name))
+			goto out_err;
+	}
+
+out_err:
+	if (!ASSERT_OK_PTR(strstr(obj_log_buf, param->expected_err_msg), "expected_err_msg")) {
+		fprintf(stderr, "Expected err_msg: %s\n", param->expected_err_msg);
+		fprintf(stderr, "Verifier output: %s\n", obj_log_buf);
+	}
+
+cleanup:
+	kfunc_call_fail__destroy(skel);
+}
+
 static void test_main(void)
 {
 	int i;
@@ -87,7 +213,10 @@ static void test_main(void)
 		if (!test__start_subtest(kfunc_tests[i].prog_name))
 			continue;
 
-		verify_success(&kfunc_tests[i]);
+		if (!kfunc_tests[i].expected_err_msg)
+			verify_success(&kfunc_tests[i]);
+		else
+			verify_fail(&kfunc_tests[i]);
 	}
 }
 
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_fail.c b/tools/testing/selftests/bpf/progs/kfunc_call_fail.c
new file mode 100644
index 000000000000..4168027f2ab1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_fail.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_kfunc_call_test_mem_len_pass1(void *mem, int len) __ksym;
+
+struct syscall_test_args {
+	__u8 data[16];
+	size_t size;
+};
+
+SEC("?syscall")
+int kfunc_syscall_test_fail(struct syscall_test_args *args)
+{
+	bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(*args) + 1);
+
+	return 0;
+}
+
+SEC("?syscall")
+int kfunc_syscall_test_null_fail(struct syscall_test_args *args)
+{
+	/* Must be called with args as a NULL pointer
+	 * we do not check for it to have the verifier consider that
+	 * the pointer might not be null, and so we can load it.
+	 *
+	 * So the following can not be added:
+	 *
+	 * if (args)
+	 *      return -22;
+	 */
+
+	bpf_kfunc_call_test_mem_len_pass1(args, sizeof(*args));
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
index 5aecbb9fdc68..94c05267e5e7 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
@@ -92,4 +92,42 @@ int kfunc_call_test_pass(struct __sk_buff *skb)
 	return 0;
 }
 
+struct syscall_test_args {
+	__u8 data[16];
+	size_t size;
+};
+
+SEC("syscall")
+int kfunc_syscall_test(struct syscall_test_args *args)
+{
+	const int size = args->size;
+
+	if (size > sizeof(args->data))
+		return -7; /* -E2BIG */
+
+	bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(args->data));
+	bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(*args));
+	bpf_kfunc_call_test_mem_len_pass1(&args->data, size);
+
+	return 0;
+}
+
+SEC("syscall")
+int kfunc_syscall_test_null(struct syscall_test_args *args)
+{
+	/* Must be called with args as a NULL pointer
+	 * we do not check for it to have the verifier consider that
+	 * the pointer might not be null, and so we can load it.
+	 *
+	 * So the following can not be added:
+	 *
+	 * if (args)
+	 *      return -22;
+	 */
+
+	bpf_kfunc_call_test_mem_len_pass1(args, 0);
+
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.36.1


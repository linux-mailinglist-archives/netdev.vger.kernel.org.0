Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50763C70A8
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 14:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbhGMMqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 08:46:47 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:35786 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236167AbhGMMqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 08:46:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UfgRy8k_1626180226;
Received: from localhost(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0UfgRy8k_1626180226)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Jul 2021 20:43:54 +0800
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Shuyi Cheng <chengshuyi@linux.alibaba.com>
Subject: [PATCH bpf-next v4 3/3] selftests/bpf: Switches existing selftests to using open_opts for custom BTF
Date:   Tue, 13 Jul 2021 20:42:39 +0800
Message-Id: <1626180159-112996-4-git-send-email-chengshuyi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626180159-112996-1-git-send-email-chengshuyi@linux.alibaba.com>
References: <1626180159-112996-1-git-send-email-chengshuyi@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch mainly replaces the bpf_object_load_attr of 
the core_autosize.c and core_reloc.c files with bpf_object_open_opts.

Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
---
 .../selftests/bpf/prog_tests/core_autosize.c       | 22 ++++++++---------
 .../testing/selftests/bpf/prog_tests/core_reloc.c  | 28 ++++++++++------------
 2 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_autosize.c b/tools/testing/selftests/bpf/prog_tests/core_autosize.c
index 981c251..d163342 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_autosize.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_autosize.c
@@ -54,7 +54,7 @@ void test_core_autosize(void)
 	int err, fd = -1, zero = 0;
 	int char_id, short_id, int_id, long_long_id, void_ptr_id, id;
 	struct test_core_autosize* skel = NULL;
-	struct bpf_object_load_attr load_attr = {};
+	struct bpf_object_open_opts open_opts = {};
 	struct bpf_program *prog;
 	struct bpf_map *bss_map;
 	struct btf *btf = NULL;
@@ -125,9 +125,11 @@ void test_core_autosize(void)
 	fd = -1;
 
 	/* open and load BPF program with custom BTF as the kernel BTF */
-	skel = test_core_autosize__open();
+	open_opts.btf_custom_path = btf_file;
+	open_opts.sz = sizeof(struct bpf_object_open_opts);
+	skel = test_core_autosize__open_opts(&open_opts);
 	if (!ASSERT_OK_PTR(skel, "skel_open"))
-		return;
+		goto cleanup;
 
 	/* disable handle_signed() for now */
 	prog = bpf_object__find_program_by_name(skel->obj, "handle_signed");
@@ -135,9 +137,7 @@ void test_core_autosize(void)
 		goto cleanup;
 	bpf_program__set_autoload(prog, false);
 
-	load_attr.obj = skel->obj;
-	load_attr.target_btf_path = btf_file;
-	err = bpf_object__load_xattr(&load_attr);
+	err = bpf_object__load(skel->obj);
 	if (!ASSERT_OK(err, "prog_load"))
 		goto cleanup;
 
@@ -204,13 +204,13 @@ void test_core_autosize(void)
 	skel = NULL;
 
 	/* now re-load with handle_signed() enabled, it should fail loading */
-	skel = test_core_autosize__open();
+	open_opts.btf_custom_path = btf_file;
+	open_opts.sz = sizeof(struct bpf_object_open_opts);
+	skel = test_core_autosize__open_opts(&opts);
 	if (!ASSERT_OK_PTR(skel, "skel_open"))
-		return;
+		goto cleanup;
 
-	load_attr.obj = skel->obj;
-	load_attr.target_btf_path = btf_file;
-	err = bpf_object__load_xattr(&load_attr);
+	err = bpf_object__load(skel);
 	if (!ASSERT_ERR(err, "bad_prog_load"))
 		goto cleanup;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index d02e064..10eb2407 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -816,7 +816,7 @@ static size_t roundup_page(size_t sz)
 void test_core_reloc(void)
 {
 	const size_t mmap_sz = roundup_page(sizeof(struct data));
-	struct bpf_object_load_attr load_attr = {};
+	struct bpf_object_open_opts open_opts = {};
 	struct core_reloc_test_case *test_case;
 	const char *tp_name, *probe_name;
 	int err, i, equal;
@@ -846,9 +846,17 @@ void test_core_reloc(void)
 				continue;
 		}
 
-		obj = bpf_object__open_file(test_case->bpf_obj_file, NULL);
+		if (test_case->btf_src_file) {
+			err = access(test_case->btf_src_file, R_OK);
+			if (!ASSERT_OK(err, "btf_src_file"))
+				goto cleanup;
+		}
+
+		open_opts.btf_custom_path = test_case->btf_src_file;
+		open_opts.sz = sizeof(struct bpf_object_open_opts);
+		obj = bpf_object__open_file(test_case->bpf_obj_file, &open_opts);
 		if (!ASSERT_OK_PTR(obj, "obj_open"))
-			continue;
+			goto cleanup;
 
 		probe_name = "raw_tracepoint/sys_enter";
 		tp_name = "sys_enter";
@@ -861,18 +869,8 @@ void test_core_reloc(void)
 		if (CHECK(!prog, "find_probe",
 			  "prog '%s' not found\n", probe_name))
 			goto cleanup;
-
-
-		if (test_case->btf_src_file) {
-			err = access(test_case->btf_src_file, R_OK);
-			if (!ASSERT_OK(err, "btf_src_file"))
-				goto cleanup;
-		}
-
-		load_attr.obj = obj;
-		load_attr.log_level = 0;
-		load_attr.target_btf_path = test_case->btf_src_file;
-		err = bpf_object__load_xattr(&load_attr);
+
+		err = bpf_object__load(obj);
 		if (err) {
 			if (!test_case->fails)
 				ASSERT_OK(err, "obj_load");
-- 
1.8.3.1


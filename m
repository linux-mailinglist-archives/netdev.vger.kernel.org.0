Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37069537EF2
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiE3N5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238810AbiE3Ny4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:54:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E88D95497;
        Mon, 30 May 2022 06:38:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8821860F2A;
        Mon, 30 May 2022 13:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576EAC385B8;
        Mon, 30 May 2022 13:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917881;
        bh=LX/u9J6vANI+mUWjsI7476ZgonTSnepyNxc/Lp6m9LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dO32Pyld2RNnCslzCpVOff8zLEoteFpT9uLreJrDpex4l5zi/f0Y0wa68WCQBPMnj
         qkAaXcE09isS++aWe9mefGrA6E5Cxz+BrBjtmgihTSMdYreWnWjX6+8n/AHmvtgztC
         nzAV+Gjp88Qzcm6bajbl7GZB7mAmje7j/fYs8uqIrU/guubAUItcgsjLdI4TPYPMsn
         1GpjwyIfvfENLgwkAgtslRCWEvmAOn2793/IOOUNRNYe5eTNCA9fve8nk7m0KmjwCa
         l1gz0mKRAor14aUCk0KLsnyjk4KAaV4vw1WCQBsj65p7eM8JLxn0Y6YSha01GXQAfZ
         cWVVsgkd5s7Cg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuntao Wang <ytcoode@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        ast@kernel.org, daniel@iogearbox.net, shuah@kernel.org,
        kuifeng@fb.com, sunyucong@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 126/135] selftests/bpf: Add missing trampoline program type to trampoline_count test
Date:   Mon, 30 May 2022 09:31:24 -0400
Message-Id: <20220530133133.1931716-126-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuntao Wang <ytcoode@gmail.com>

[ Upstream commit b23316aabffa835ecc516cb81daeef5b9155e8a5 ]

Currently the trampoline_count test doesn't include any fmod_ret bpf
programs, fix it to make the test cover all possible trampoline program
types.

Since fmod_ret bpf programs can't be attached to __set_task_comm function,
as it's neither whitelisted for error injection nor a security hook, change
it to bpf_modify_return_test.

This patch also does some other cleanups such as removing duplicate code,
dropping inconsistent comments, etc.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20220519150610.601313-1-ytcoode@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h                           |   2 +-
 .../bpf/prog_tests/trampoline_count.c         | 134 +++++++-----------
 .../bpf/progs/test_trampoline_count.c         |  16 ++-
 3 files changed, 61 insertions(+), 91 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3121d1fc8e75..2f7e00e7af37 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -652,7 +652,7 @@ struct btf_func_model {
 #define BPF_TRAMP_F_RET_FENTRY_RET	BIT(4)
 
 /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
- * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
+ * bytes on x86.
  */
 #define BPF_MAX_TRAMP_PROGS 38
 
diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
index 9c795ee52b7b..b0acbda6dbf5 100644
--- a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
+++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
@@ -1,126 +1,94 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #define _GNU_SOURCE
-#include <sched.h>
-#include <sys/prctl.h>
 #include <test_progs.h>
 
 #define MAX_TRAMP_PROGS 38
 
 struct inst {
 	struct bpf_object *obj;
-	struct bpf_link   *link_fentry;
-	struct bpf_link   *link_fexit;
+	struct bpf_link   *link;
 };
 
-static int test_task_rename(void)
-{
-	int fd, duration = 0, err;
-	char buf[] = "test_overhead";
-
-	fd = open("/proc/self/comm", O_WRONLY|O_TRUNC);
-	if (CHECK(fd < 0, "open /proc", "err %d", errno))
-		return -1;
-	err = write(fd, buf, sizeof(buf));
-	if (err < 0) {
-		CHECK(err < 0, "task rename", "err %d", errno);
-		close(fd);
-		return -1;
-	}
-	close(fd);
-	return 0;
-}
-
-static struct bpf_link *load(struct bpf_object *obj, const char *name)
+static struct bpf_program *load_prog(char *file, char *name, struct inst *inst)
 {
+	struct bpf_object *obj;
 	struct bpf_program *prog;
-	int duration = 0;
+	int err;
+
+	obj = bpf_object__open_file(file, NULL);
+	if (!ASSERT_OK_PTR(obj, "obj_open_file"))
+		return NULL;
+
+	inst->obj = obj;
+
+	err = bpf_object__load(obj);
+	if (!ASSERT_OK(err, "obj_load"))
+		return NULL;
 
 	prog = bpf_object__find_program_by_name(obj, name);
-	if (CHECK(!prog, "find_probe", "prog '%s' not found\n", name))
-		return ERR_PTR(-EINVAL);
-	return bpf_program__attach_trace(prog);
+	if (!ASSERT_OK_PTR(prog, "obj_find_prog"))
+		return NULL;
+
+	return prog;
 }
 
 /* TODO: use different target function to run in concurrent mode */
 void serial_test_trampoline_count(void)
 {
-	const char *fentry_name = "prog1";
-	const char *fexit_name = "prog2";
-	const char *object = "test_trampoline_count.o";
-	struct inst inst[MAX_TRAMP_PROGS] = {};
-	int err, i = 0, duration = 0;
-	struct bpf_object *obj;
+	char *file = "test_trampoline_count.o";
+	char *const progs[] = { "fentry_test", "fmod_ret_test", "fexit_test" };
+	struct inst inst[MAX_TRAMP_PROGS + 1] = {};
+	struct bpf_program *prog;
 	struct bpf_link *link;
-	char comm[16] = {};
+	int prog_fd, err, i;
+	LIBBPF_OPTS(bpf_test_run_opts, opts);
 
 	/* attach 'allowed' trampoline programs */
 	for (i = 0; i < MAX_TRAMP_PROGS; i++) {
-		obj = bpf_object__open_file(object, NULL);
-		if (!ASSERT_OK_PTR(obj, "obj_open_file")) {
-			obj = NULL;
+		prog = load_prog(file, progs[i % ARRAY_SIZE(progs)], &inst[i]);
+		if (!prog)
 			goto cleanup;
-		}
 
-		err = bpf_object__load(obj);
-		if (CHECK(err, "obj_load", "err %d\n", err))
+		link = bpf_program__attach(prog);
+		if (!ASSERT_OK_PTR(link, "attach_prog"))
 			goto cleanup;
-		inst[i].obj = obj;
-		obj = NULL;
-
-		if (rand() % 2) {
-			link = load(inst[i].obj, fentry_name);
-			if (!ASSERT_OK_PTR(link, "attach_prog")) {
-				link = NULL;
-				goto cleanup;
-			}
-			inst[i].link_fentry = link;
-		} else {
-			link = load(inst[i].obj, fexit_name);
-			if (!ASSERT_OK_PTR(link, "attach_prog")) {
-				link = NULL;
-				goto cleanup;
-			}
-			inst[i].link_fexit = link;
-		}
+
+		inst[i].link = link;
 	}
 
 	/* and try 1 extra.. */
-	obj = bpf_object__open_file(object, NULL);
-	if (!ASSERT_OK_PTR(obj, "obj_open_file")) {
-		obj = NULL;
+	prog = load_prog(file, "fmod_ret_test", &inst[i]);
+	if (!prog)
 		goto cleanup;
-	}
-
-	err = bpf_object__load(obj);
-	if (CHECK(err, "obj_load", "err %d\n", err))
-		goto cleanup_extra;
 
 	/* ..that needs to fail */
-	link = load(obj, fentry_name);
-	err = libbpf_get_error(link);
-	if (!ASSERT_ERR_PTR(link, "cannot attach over the limit")) {
-		bpf_link__destroy(link);
-		goto cleanup_extra;
+	link = bpf_program__attach(prog);
+	if (!ASSERT_ERR_PTR(link, "attach_prog")) {
+		inst[i].link = link;
+		goto cleanup;
 	}
 
 	/* with E2BIG error */
-	ASSERT_EQ(err, -E2BIG, "proper error check");
-	ASSERT_EQ(link, NULL, "ptr_is_null");
+	if (!ASSERT_EQ(libbpf_get_error(link), -E2BIG, "E2BIG"))
+		goto cleanup;
+	if (!ASSERT_EQ(link, NULL, "ptr_is_null"))
+		goto cleanup;
 
 	/* and finaly execute the probe */
-	if (CHECK_FAIL(prctl(PR_GET_NAME, comm, 0L, 0L, 0L)))
-		goto cleanup_extra;
-	CHECK_FAIL(test_task_rename());
-	CHECK_FAIL(prctl(PR_SET_NAME, comm, 0L, 0L, 0L));
+	prog_fd = bpf_program__fd(prog);
+	if (!ASSERT_GE(prog_fd, 0, "bpf_program__fd"))
+		goto cleanup;
+
+	err = bpf_prog_test_run_opts(prog_fd, &opts);
+	if (!ASSERT_OK(err, "bpf_prog_test_run_opts"))
+		goto cleanup;
+
+	ASSERT_EQ(opts.retval & 0xffff, 4, "bpf_modify_return_test.result");
+	ASSERT_EQ(opts.retval >> 16, 1, "bpf_modify_return_test.side_effect");
 
-cleanup_extra:
-	bpf_object__close(obj);
 cleanup:
-	if (i >= MAX_TRAMP_PROGS)
-		i = MAX_TRAMP_PROGS - 1;
 	for (; i >= 0; i--) {
-		bpf_link__destroy(inst[i].link_fentry);
-		bpf_link__destroy(inst[i].link_fexit);
+		bpf_link__destroy(inst[i].link);
 		bpf_object__close(inst[i].obj);
 	}
 }
diff --git a/tools/testing/selftests/bpf/progs/test_trampoline_count.c b/tools/testing/selftests/bpf/progs/test_trampoline_count.c
index f030e469d05b..7765720da7d5 100644
--- a/tools/testing/selftests/bpf/progs/test_trampoline_count.c
+++ b/tools/testing/selftests/bpf/progs/test_trampoline_count.c
@@ -1,20 +1,22 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <stdbool.h>
-#include <stddef.h>
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
-struct task_struct;
+SEC("fentry/bpf_modify_return_test")
+int BPF_PROG(fentry_test, int a, int *b)
+{
+	return 0;
+}
 
-SEC("fentry/__set_task_comm")
-int BPF_PROG(prog1, struct task_struct *tsk, const char *buf, bool exec)
+SEC("fmod_ret/bpf_modify_return_test")
+int BPF_PROG(fmod_ret_test, int a, int *b, int ret)
 {
 	return 0;
 }
 
-SEC("fexit/__set_task_comm")
-int BPF_PROG(prog2, struct task_struct *tsk, const char *buf, bool exec)
+SEC("fexit/bpf_modify_return_test")
+int BPF_PROG(fexit_test, int a, int *b, int ret)
 {
 	return 0;
 }
-- 
2.35.1


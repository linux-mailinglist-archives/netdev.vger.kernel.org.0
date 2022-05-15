Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE83527606
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 08:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbiEOGbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 02:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiEOGbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 02:31:37 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E63B6256;
        Sat, 14 May 2022 23:31:35 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 137so11272550pgb.5;
        Sat, 14 May 2022 23:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mq5z7L0nka28G5WQMErNElXNP4BU7U7qW4P3u/glHjA=;
        b=PyyIXI09nSD7Pe9xseOuYKNsfvFoHBh6zSkdIpTKnquu3/Rm5AG5cOnZae5mwbo3eF
         +nkEAr/LTXzYGrKDVdVGJxP97uBSVkPeOmA0yktBIr3BLGH1JLgyOATfjegN56g1pvoC
         0KvB0XHVTM2X5MC17cDsFi0FcyZ++8TtWXfXzygIpvFHybGHrcOYXJWlxJaQKvsal7Ry
         vAkuOraRsxLMqlUeMs7Qjagg2FIQUCVb8LigE6GA2L0vEaKvIxFHqnCXBS/fTZMMCMDk
         T6i3QdiCoN4NNaUwjYGelUtKV1rDZGtaQAu8s7GIbx0wItxDf5LtIZG/ls19avmuOKBs
         Gelw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mq5z7L0nka28G5WQMErNElXNP4BU7U7qW4P3u/glHjA=;
        b=mZmC0IPtOwbzIlKo+PB6LzYZwKvxRIni1gFgBW9uXyTEUWGZYjlRN3i32keHGeFFC4
         bkXXGiyPPSIcZHrmH4ZSCvz4dy0oR6hRGIZcWnugTCnakK4aVhdCk9y0U9LWPPlpu5bq
         RPsGuraRirjTwo7OPJEhmS+f3qZ1lng1759BFPe66BJs2C94Fx+3fPZbTm1V+8jh91yx
         b9mK5qmAGAm9ioOJ4/vyS8pokiMH63VcyrmhZBbpiL3A8sVjlrGdQ9z/4nSDNDOMD4Qy
         Nzw1BmKw0eLqw9hjXblnhgEb2QkOhk1D6MwCM+NKd6/O5cK7P6KDQ6GMoNmUv7kfcYVD
         JkbQ==
X-Gm-Message-State: AOAM5308yJPoxYAtkPSUA5xOWjA9FTKXb7FueXQEp5PkmWciXK6vL4WE
        Cm5vpD+fZpCQuH6I3mxMuH4=
X-Google-Smtp-Source: ABdhPJwPwjTWLK5/PHqE98MdF3otwmW4s5Ca+oqHA/ZbeH7+LRKl1YVBh5Cthu/Fla7w6y8sm7+3zQ==
X-Received: by 2002:a05:6a00:14d4:b0:50e:12c8:4868 with SMTP id w20-20020a056a0014d400b0050e12c84868mr12270705pfu.72.1652596294808;
        Sat, 14 May 2022 23:31:34 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id d11-20020a62f80b000000b0050dc7628149sm4528368pfh.35.2022.05.14.23.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 23:31:34 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Kui-Feng Lee <kuifeng@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] selftests/bpf: Add missing trampoline program type to trampoline_count test
Date:   Sun, 15 May 2022 14:31:20 +0800
Message-Id: <20220515063120.526063-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the trampoline_count test doesn't include any fmod_ret bpf
programs, fix it to make the test cover all possible trampoline program
types.

Since fmod_ret bpf programs can't be attached to __set_task_comm function,
as it's neither whitelisted for error injection nor a security hook, change
it to bpf_modify_return_test.

This patch also does some other cleanups such as removing duplicate code,
dropping inconsistent comments, etc.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 include/linux/bpf.h                           |   2 +-
 .../bpf/prog_tests/trampoline_count.c         | 121 ++++++------------
 .../bpf/progs/test_trampoline_count.c         |  16 ++-
 3 files changed, 47 insertions(+), 92 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c107392b0ba7..cb01f247e05f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -724,7 +724,7 @@ struct btf_func_model {
 #define BPF_TRAMP_F_RET_FENTRY_RET	BIT(4)
 
 /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
- * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
+ * bytes on x86.
  */
 #define BPF_MAX_TRAMP_LINKS 38
 
diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
index 9c795ee52b7b..b1d25998cc48 100644
--- a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
+++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
@@ -1,126 +1,79 @@
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
+	int i;
 
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
+	prog = load_prog(file, progs[0], &inst[i]);
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
+	ASSERT_EQ(libbpf_get_error(link), -E2BIG, "E2BIG");
 	ASSERT_EQ(link, NULL, "ptr_is_null");
 
-	/* and finaly execute the probe */
-	if (CHECK_FAIL(prctl(PR_GET_NAME, comm, 0L, 0L, 0L)))
-		goto cleanup_extra;
-	CHECK_FAIL(test_task_rename());
-	CHECK_FAIL(prctl(PR_SET_NAME, comm, 0L, 0L, 0L));
-
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
2.36.1


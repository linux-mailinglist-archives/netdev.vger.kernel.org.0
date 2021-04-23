Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BE23689CA
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240086AbhDWA1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240012AbhDWA1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:32 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B462C06138C;
        Thu, 22 Apr 2021 17:26:56 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g16so19625175pfq.5;
        Thu, 22 Apr 2021 17:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uMTjltqajgdVrwhXaGl/162P4PUnuM1AeyInQysPzu4=;
        b=Z8dEhU2QxZkxLjOIJokcvaFHQc6FR9H86Y5rqbidDvf8XTTZAaG77MJuqWGq7gEYMl
         GgP2Ef+CZp2LGHj99DMar5rfKkxvYGpqqIwlD5O3LudrcaWYZ/dp43ukuwBbEEEn0rPB
         kvysCqytlKl1aqLKkNcBpqzCGq8becdx+x9a3iRP3cy7yivbvpHRtro20/gbcfVCZnQS
         LXKTDkp9LDwLbd7STrkTnT19/HwHVxIvu3BCngQh0o5+t8kLRuqTYJqAgEumXGZ2LUKP
         t5mLCaJA6HGJ8fdfi8lTtQa1gQqHe7hcqVIIDhpugkWRoUAKTiT9qidM+41n/5aOqY8G
         blqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uMTjltqajgdVrwhXaGl/162P4PUnuM1AeyInQysPzu4=;
        b=NWmC7dNYVlLPft0L5MqCSpvZxxEKuXeAbzBTByXfnNGuO1zR6C6NUOWbjupVElbIyP
         Z9S7Zy1v0+7OMcFniWWEgFb24MyaXFT4DGuuhJsh5CuGRNLT2wPz5Jwn5reDVApV6VvW
         PevEC9DtxdKxOc3rVu+nKpCCjda449IynE9amasgd9Km4ZDiHdfmb4YQWNnN2qq8bire
         hN4yrhrghTfFTJTUT4bCB/UXDxtksynROMLegTZon3BBPVgKhGbFMTi1OVTYRd6Rt9Fq
         2O4+T4yU4Sp8oNz1rWOeARcOwuBkCt2XFz70P9XMiCnCJCyNmtHiMAbC6W38cPBde8Dy
         H3Cw==
X-Gm-Message-State: AOAM5320bsVCRU0jdj5YzaZVQlCuWHazsZmFThOvZvEQQpDSNU/lEv+t
        pPustSjaUxLduRwzEdW0614=
X-Google-Smtp-Source: ABdhPJxvB8SzG4qsH26F5RHFc+271eomR/jS5HJCRamKEBaS3Len44x8VV8fQ2VcEEVGZ20KmgK4xQ==
X-Received: by 2002:aa7:9702:0:b029:260:dd79:5b33 with SMTP id a2-20020aa797020000b0290260dd795b33mr1214544pfg.14.1619137615520;
        Thu, 22 Apr 2021 17:26:55 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.26.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:26:55 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 05/16] selftests/bpf: Test for syscall program type
Date:   Thu, 22 Apr 2021 17:26:35 -0700
Message-Id: <20210423002646.35043-6-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

bpf_prog_type_syscall is a program that creates a bpf map,
updates it, and loads another bpf program using bpf_sys_bpf() helper.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |  1 +
 .../selftests/bpf/prog_tests/syscall.c        | 53 ++++++++++++++
 tools/testing/selftests/bpf/progs/syscall.c   | 73 +++++++++++++++++++
 3 files changed, 127 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/syscall.c
 create mode 100644 tools/testing/selftests/bpf/progs/syscall.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index c5bcdb3d4b12..9fdfdbc61857 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -278,6 +278,7 @@ MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 			\
 	     -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)			\
+	     -I$(TOOLSINCDIR) \
 	     -I$(abspath $(OUTPUT)/../usr/include)
 
 CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
diff --git a/tools/testing/selftests/bpf/prog_tests/syscall.c b/tools/testing/selftests/bpf/prog_tests/syscall.c
new file mode 100644
index 000000000000..e550e36bb5da
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/syscall.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <test_progs.h>
+#include "syscall.skel.h"
+
+struct args {
+	__u64 log_buf;
+	__u32 log_size;
+	int max_entries;
+	int map_fd;
+	int prog_fd;
+};
+
+void test_syscall(void)
+{
+	static char verifier_log[8192];
+	struct args ctx = {
+		.max_entries = 1024,
+		.log_buf = (uintptr_t) verifier_log,
+		.log_size = sizeof(verifier_log),
+	};
+	struct bpf_prog_test_run_attr tattr = {
+		.ctx_in = &ctx,
+		.ctx_size_in = sizeof(ctx),
+	};
+	struct syscall *skel = NULL;
+	__u64 key = 12, value = 0;
+	__u32 duration = 0;
+	int err;
+
+	skel = syscall__open_and_load();
+	if (CHECK(!skel, "skel_load", "syscall skeleton failed\n"))
+		goto cleanup;
+
+	tattr.prog_fd = bpf_program__fd(skel->progs.bpf_prog);
+	err = bpf_prog_test_run_xattr(&tattr);
+	if (CHECK(err || tattr.retval != 1, "test_run sys_bpf",
+		  "err %d errno %d retval %d duration %d\n",
+		  err, errno, tattr.retval, tattr.duration))
+		goto cleanup;
+
+	CHECK(ctx.map_fd <= 0, "map_fd", "fd = %d\n", ctx.map_fd);
+	CHECK(ctx.prog_fd <= 0, "prog_fd", "fd = %d\n", ctx.prog_fd);
+	CHECK(memcmp(verifier_log, "processed", sizeof("processed") - 1) != 0,
+	      "verifier_log", "%s\n", verifier_log);
+
+	err = bpf_map_lookup_elem(ctx.map_fd, &key, &value);
+	CHECK(err, "map_lookup", "map_lookup failed\n");
+	CHECK(value != 34, "invalid_value",
+	      "got value %llu expected %u\n", value, 34);
+cleanup:
+	syscall__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/syscall.c b/tools/testing/selftests/bpf/progs/syscall.c
new file mode 100644
index 000000000000..01476f88e45f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/syscall.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <linux/stddef.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <../../tools/include/linux/filter.h>
+
+volatile const int workaround = 1;
+
+char _license[] SEC("license") = "GPL";
+
+struct args {
+	__u64 log_buf;
+	__u32 log_size;
+	int max_entries;
+	int map_fd;
+	int prog_fd;
+};
+
+SEC("syscall")
+int bpf_prog(struct args *ctx)
+{
+	static char license[] = "GPL";
+	static struct bpf_insn insns[] = {
+		BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+	static union bpf_attr map_create_attr = {
+		.map_type = BPF_MAP_TYPE_HASH,
+		.key_size = 8,
+		.value_size = 8,
+	};
+	static union bpf_attr map_update_attr = { .map_fd = 1, };
+	static __u64 key = 12;
+	static __u64 value = 34;
+	static union bpf_attr prog_load_attr = {
+		.prog_type = BPF_PROG_TYPE_XDP,
+		.insn_cnt = sizeof(insns) / sizeof(insns[0]),
+	};
+	int ret;
+
+	map_create_attr.max_entries = ctx->max_entries;
+	prog_load_attr.license = (long) license;
+	prog_load_attr.insns = (long) insns;
+	prog_load_attr.log_buf = ctx->log_buf;
+	prog_load_attr.log_size = ctx->log_size;
+	prog_load_attr.log_level = 1;
+
+	ret = bpf_sys_bpf(BPF_MAP_CREATE, &map_create_attr, sizeof(map_create_attr));
+	if (ret <= 0)
+		return ret;
+	ctx->map_fd = ret;
+	insns[3].imm = ret;
+
+	map_update_attr.map_fd = ret;
+	map_update_attr.key = (long) &key;
+	map_update_attr.value = (long) &value;
+	ret = bpf_sys_bpf(BPF_MAP_UPDATE_ELEM, &map_update_attr, sizeof(map_update_attr));
+	if (ret < 0)
+		return ret;
+
+	ret = bpf_sys_bpf(BPF_PROG_LOAD, &prog_load_attr, sizeof(prog_load_attr));
+	if (ret <= 0)
+		return ret;
+	ctx->prog_fd = ret;
+	return 1;
+}
-- 
2.30.2


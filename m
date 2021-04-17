Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3813362D4D
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 05:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbhDQDeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 23:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235637AbhDQDdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 23:33:52 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F82C061343;
        Fri, 16 Apr 2021 20:32:46 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so15619148pjv.1;
        Fri, 16 Apr 2021 20:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=juescyeqEg9hEGwhuSnnl3UE8v2/E5qhSRyU01YXHdw=;
        b=KtqWavkOsmaFbveErZvNIo9yyswLg35dzj5cX2+Cy1E3c38RkgAvsa/Aou8AC/NFf4
         B+jo2any6vIUzM9fDtemfVoGxvJxBr7qIbgGvJ05bTwSNkvSrGkdvVcQ8RXCMtxQIULN
         FcoL7irVXPFEpEnruzerDUHO06dH5lrnGH2PVl7aDMB7DDUbewumODs2+m+X4FG2qp3X
         HUE6C4dWBvCEqHczt9seOoEMrl9ZHPqx+FrV0sqTycKrMLCJnBMlEoHiifNF1Azdgohl
         lZR6yA6VZYA/AMz0LHCnnWHumiwjulkFfCARf7+CVVtYRgtoaCdDgPkUy6v1DB8Rtb04
         1Ttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=juescyeqEg9hEGwhuSnnl3UE8v2/E5qhSRyU01YXHdw=;
        b=U1kOO1CdYE5JRBjTp1f4hCEKTdbzlnpqF82AOU3+o0bmZ5qGkSxm6ymmQOttrevbOr
         Hls07eL3zFvE2i+TlTh6DV36o1Fz6jWaPcuTlCMWcBWlFJz3xzLAd1qWbT0oz248plLE
         RO2RAOMVenyk/6BxpWDRWVvWy9s3iZAOk9E6pI5QFAFvxMYVlvP2aloAZuiBZKLu454C
         tvIpaPRIA4ntZgTnA7uU1krcUt0eCYkriEj5sdwHhVQqRxx2DwwqGMlbyULJaCAd/NXq
         ixOUQt+ggNTcASVYcPjWZbOiO2uvcx8toj+ip1sSK8m8IP5izKW2DiW513MxLplc6caA
         mLVg==
X-Gm-Message-State: AOAM533dKXSSVVmq6JreIgrNOqanIxr74mUbEPU2ZhX9/2ctBLSZUW2Z
        R17cUWOd+8V9CJTkGrAVAEU=
X-Google-Smtp-Source: ABdhPJxiJUJpWLUrmItlv+ucglF2UcdjZMIGzNSXbWmYV1xageDs8jaIlGbPggu6McN7Kkxx704VAw==
X-Received: by 2002:a17:90a:c203:: with SMTP id e3mr12760496pjt.173.1618630365486;
        Fri, 16 Apr 2021 20:32:45 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id h1sm6069870pgv.88.2021.04.16.20.32.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Apr 2021 20:32:44 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 13/15] libbpf: Generate loader program out of BPF ELF file.
Date:   Fri, 16 Apr 2021 20:32:22 -0700
Message-Id: <20210417033224.8063-14-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

The BPF program loading process performed by libbpf is quite complex
and consists of the following steps:
"open" phase:
- parse elf file and remember relocations, sections
- collect externs and ksyms including their btf_ids in prog's BTF
- patch BTF datasec (since llvm couldn't do it)
- init maps (old style map_def, BTF based, global data map, kconfig map)
- collect relocations against progs and maps
"load" phase:
- probe kernel features
- load vmlinux BTF
- resolve externs (kconfig and ksym)
- load program BTF
- init struct_ops
- create maps
- apply CO-RE relocations
- patch ld_imm64 insns with src_reg=PSEUDO_MAP, PSEUDO_MAP_VALUE, PSEUDO_BTF_ID
- reposition subprograms and adjust call insns
- sanitize and load progs

During this process libbpf does sys_bpf() calls to load BTF, create maps,
populate maps and finally load programs.
Instead of actually doing the syscalls generate a trace of what libbpf
would have done and represent it as the "loader program".
The "loader program" consists of single map with:
- union bpf_attr(s)
- BTF bytes
- map value bytes
- insns bytes
and single bpf program that passes bpf_attr(s) and data into bpf_sys_bpf() helper.
Executing such "loader program" via bpf_prog_test_run() command will
replay the sequence of syscalls that libbpf would have done which will result
the same maps created and programs loaded as specified in the elf file.
The "loader program" removes libelf and majority of libbpf dependency from
program loading process.

kconfig, typeless ksym, struct_ops and CO-RE are not supported yet.

The order of relocate_data and relocate_calls had to change in order
for trace generation to see all relocations for given program with
correct insn_idx-es.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/Build              |   2 +-
 tools/lib/bpf/bpf.c              |  61 ++++
 tools/lib/bpf/bpf.h              |  35 ++
 tools/lib/bpf/bpf_gen_internal.h |  38 +++
 tools/lib/bpf/gen_trace.c        | 529 +++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.c           | 199 ++++++++++--
 tools/lib/bpf/libbpf.map         |   1 +
 tools/lib/bpf/libbpf_internal.h  |   2 +
 8 files changed, 834 insertions(+), 33 deletions(-)
 create mode 100644 tools/lib/bpf/bpf_gen_internal.h
 create mode 100644 tools/lib/bpf/gen_trace.c

diff --git a/tools/lib/bpf/Build b/tools/lib/bpf/Build
index 9b057cc7650a..d0a1903bcc3c 100644
--- a/tools/lib/bpf/Build
+++ b/tools/lib/bpf/Build
@@ -1,3 +1,3 @@
 libbpf-y := libbpf.o bpf.o nlattr.o btf.o libbpf_errno.o str_error.o \
 	    netlink.o bpf_prog_linfo.o libbpf_probes.o xsk.o hashmap.o \
-	    btf_dump.o ringbuf.o strset.o linker.o
+	    btf_dump.o ringbuf.o strset.o linker.o gen_trace.o
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index b96a3aba6fcc..517e4f949a73 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -972,3 +972,64 @@ int bpf_prog_bind_map(int prog_fd, int map_fd,
 
 	return sys_bpf(BPF_PROG_BIND_MAP, &attr, sizeof(attr));
 }
+
+int bpf_load(const struct bpf_load_opts *opts)
+{
+	struct bpf_prog_test_run_attr tattr = {};
+	struct bpf_prog_load_params attr = {};
+	int map_fd = -1, prog_fd = -1, key = 0, err;
+
+	if (!OPTS_VALID(opts, bpf_load_opts))
+		return -EINVAL;
+
+	map_fd = bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "__loader.map", 4,
+				     opts->data_sz, 1, 0);
+	if (map_fd < 0) {
+		pr_warn("failed to create loader map");
+		err = errno;
+		goto out;
+	}
+
+	err = bpf_map_update_elem(map_fd, &key, opts->data, 0);
+	if (err < 0) {
+		pr_warn("failed to update loader map");
+		err = errno;
+		goto out;
+	}
+
+	attr.prog_type = BPF_PROG_TYPE_SYSCALL;
+	attr.insns = opts->insns;
+	attr.insn_cnt = opts->insns_sz / sizeof(struct bpf_insn);
+	attr.license = "GPL";
+	attr.name = "__loader.prog";
+	attr.fd_array = &map_fd;
+	attr.log_level = opts->ctx->log_level;
+	attr.log_buf_sz = opts->ctx->log_size;
+	attr.log_buf = (void *) opts->ctx->log_buf;
+	prog_fd = libbpf__bpf_prog_load(&attr);
+	if (prog_fd < 0) {
+		pr_warn("failed to load loader prog %d", errno);
+		err = errno;
+		goto out;
+	}
+
+	tattr.prog_fd = prog_fd;
+	tattr.ctx_in = opts->ctx;
+	tattr.ctx_size_in = opts->ctx->sz;
+	err = bpf_prog_test_run_xattr(&tattr);
+	if (err < 0 || (int)tattr.retval < 0) {
+		pr_warn("failed to execute loader prog %d retval %d",
+			errno, tattr.retval);
+		if (err < 0)
+			err = errno;
+		else
+			err = -(int)tattr.retval;
+		goto out;
+	}
+	err = 0;
+out:
+	close(map_fd);
+	close(prog_fd);
+	return err;
+
+}
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 875dde20d56e..0d36fd412450 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -278,6 +278,41 @@ struct bpf_test_run_opts {
 LIBBPF_API int bpf_prog_test_run_opts(int prog_fd,
 				      struct bpf_test_run_opts *opts);
 
+/* The layout of bpf_map_prog_desc and bpf_loader_ctx is feature dependent
+ * and will change from one version of libbpf to another and features
+ * requested during loader program generation.
+ */
+union bpf_map_prog_desc {
+	struct {
+		__u32 map_fd;
+		__u32 max_entries;
+	};
+	struct {
+		__u32 prog_fd;
+		__u32 attach_prog_fd;
+	};
+};
+
+struct bpf_loader_ctx {
+	size_t sz;
+	__u32 log_level;
+	__u32 log_size;
+	__u64 log_buf;
+	union bpf_map_prog_desc u[];
+};
+
+struct bpf_load_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	struct bpf_loader_ctx *ctx;
+	const void *data;
+	const void *insns;
+	__u32 data_sz;
+	__u32 insns_sz;
+};
+#define bpf_load_opts__last_field insns_sz
+
+LIBBPF_API int bpf_load(const struct bpf_load_opts *opts);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/bpf_gen_internal.h b/tools/lib/bpf/bpf_gen_internal.h
new file mode 100644
index 000000000000..a79f2e4ad980
--- /dev/null
+++ b/tools/lib/bpf/bpf_gen_internal.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+/* Copyright (c) 2021 Facebook */
+#ifndef __BPF_GEN_INTERNAL_H
+#define __BPF_GEN_INTERNAL_H
+
+struct relo_desc {
+	const char *name;
+	int kind;
+	int insn_idx;
+};
+
+struct bpf_gen {
+	void *data_start;
+	void *data_cur;
+	void *insn_start;
+	void *insn_cur;
+	__u32 nr_progs;
+	__u32 nr_maps;
+	int log_level;
+	int error;
+	struct relo_desc *relos;
+	int relo_cnt;
+};
+
+void bpf_object__set_gen_trace(struct bpf_object *obj, struct bpf_gen *gen);
+
+void bpf_gen__init(struct bpf_gen *gen, int log_level);
+int bpf_gen__finish(struct bpf_gen *gen);
+void bpf_gen__load_btf(struct bpf_gen *gen, const void *raw_data, __u32 raw_size);
+void bpf_gen__map_create(struct bpf_gen *gen, struct bpf_create_map_attr *map_attr, int map_idx);
+struct bpf_prog_load_params;
+void bpf_gen__prog_load(struct bpf_gen *gen, struct bpf_prog_load_params *load_attr, int prog_idx);
+void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *value, __u32 value_size);
+void bpf_gen__map_freeze(struct bpf_gen *gen, int map_idx);
+void bpf_gen__record_find_name(struct bpf_gen *gen, const char *name, enum bpf_attach_type type);
+void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind, int insn_idx);
+
+#endif
diff --git a/tools/lib/bpf/gen_trace.c b/tools/lib/bpf/gen_trace.c
new file mode 100644
index 000000000000..1a80a8dd1c9f
--- /dev/null
+++ b/tools/lib/bpf/gen_trace.c
@@ -0,0 +1,529 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+/* Copyright (c) 2021 Facebook */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <linux/filter.h>
+#include "btf.h"
+#include "bpf.h"
+#include "libbpf.h"
+#include "libbpf_internal.h"
+#include "hashmap.h"
+#include "bpf_gen_internal.h"
+
+#define MAX_USED_MAPS 64
+#define MAX_USED_PROGS 32
+
+/* The following structure describes the stack layout of the loader program.
+ * In addition R6 contains the pointer to context.
+ * R7 contains the result of the last sys_bpf command (typically error or FD).
+ */
+struct loader_stack {
+	__u32 btf_fd;
+	__u32 map_fd[MAX_USED_MAPS];
+	__u32 prog_fd[MAX_USED_PROGS];
+	__u32 inner_map_fd;
+	__u32 last_btf_id;
+	__u32 last_attach_btf_obj_fd;
+};
+#define stack_off(field) (__s16)(-sizeof(struct loader_stack) + offsetof(struct loader_stack, field))
+
+static int bpf_gen__realloc_insn_buf(struct bpf_gen *gen, __u32 size)
+{
+	size_t off = gen->insn_cur - gen->insn_start;
+
+	if (gen->error)
+		return -ENOMEM;
+	if (off + size > UINT32_MAX) {
+		gen->error = -ERANGE;
+		return -ERANGE;
+	}
+	gen->insn_start = realloc(gen->insn_start, off + size);
+	if (!gen->insn_start) {
+		gen->error = -ENOMEM;
+		return -ENOMEM;
+	}
+	gen->insn_cur = gen->insn_start + off;
+	return 0;
+}
+
+static int bpf_gen__realloc_data_buf(struct bpf_gen *gen, __u32 size)
+{
+	size_t off = gen->data_cur - gen->data_start;
+
+	if (gen->error)
+		return -ENOMEM;
+	if (off + size > UINT32_MAX) {
+		gen->error = -ERANGE;
+		return -ERANGE;
+	}
+	gen->data_start = realloc(gen->data_start, off + size);
+	if (!gen->data_start) {
+		gen->error = -ENOMEM;
+		return -ENOMEM;
+	}
+	gen->data_cur = gen->data_start + off;
+	return 0;
+}
+
+static void bpf_gen__emit(struct bpf_gen *gen, struct bpf_insn insn)
+{
+	if (bpf_gen__realloc_insn_buf(gen, sizeof(insn)))
+		return;
+	memcpy(gen->insn_cur, &insn, sizeof(insn));
+	gen->insn_cur += sizeof(insn);
+}
+
+static void bpf_gen__emit2(struct bpf_gen *gen, struct bpf_insn insn1, struct bpf_insn insn2)
+{
+	bpf_gen__emit(gen, insn1);
+	bpf_gen__emit(gen, insn2);
+}
+
+void bpf_gen__init(struct bpf_gen *gen, int log_level)
+{
+	gen->log_level = log_level;
+	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_6, BPF_REG_1));
+	bpf_gen__emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_10, stack_off(last_attach_btf_obj_fd), 0));
+}
+
+static int bpf_gen__add_data(struct bpf_gen *gen, const void *data, __u32 size)
+{
+	void *prev;
+
+	if (bpf_gen__realloc_data_buf(gen, size))
+		return 0;
+	prev = gen->data_cur;
+	memcpy(gen->data_cur, data, size);
+	gen->data_cur += size;
+	return prev - gen->data_start;
+}
+
+static int insn_bytes_to_bpf_size(__u32 sz)
+{
+	switch (sz) {
+	case 8: return BPF_DW;
+	case 4: return BPF_W;
+	case 2: return BPF_H;
+	case 1: return BPF_B;
+	default: return -1;
+	}
+}
+
+/* *(u64 *)(blob + off) = (u64)(void *)(blob + data) */
+static void bpf_gen__emit_rel_store(struct bpf_gen *gen, int off, int data)
+{
+	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_0, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, data));
+	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, off));
+	bpf_gen__emit(gen, BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0));
+}
+
+/* *(u64 *)(blob + off) = (u64)(void *)(%sp + stack_off) */
+static void bpf_gen__emit_rel_store_sp(struct bpf_gen *gen, int off, int stack_off)
+{
+	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_0, BPF_REG_10));
+	bpf_gen__emit(gen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, stack_off));
+	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, off));
+	bpf_gen__emit(gen, BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0));
+}
+
+static void bpf_gen__move_ctx2blob(struct bpf_gen *gen, int off, int size, int ctx_off)
+{
+	bpf_gen__emit(gen, BPF_LDX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_0, BPF_REG_6, ctx_off));
+	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, off));
+	bpf_gen__emit(gen, BPF_STX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_1, BPF_REG_0, 0));
+}
+
+static void bpf_gen__move_stack2blob(struct bpf_gen *gen, int off, int size, int stack_off)
+{
+	bpf_gen__emit(gen, BPF_LDX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_0, BPF_REG_10, stack_off));
+	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, off));
+	bpf_gen__emit(gen, BPF_STX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_1, BPF_REG_0, 0));
+}
+
+static void bpf_gen__move_stack2ctx(struct bpf_gen *gen, int ctx_off, int size, int stack_off)
+{
+	bpf_gen__emit(gen, BPF_LDX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_0, BPF_REG_10, stack_off));
+	bpf_gen__emit(gen, BPF_STX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_6, BPF_REG_0, ctx_off));
+}
+
+static void bpf_gen__emit_sys_bpf(struct bpf_gen *gen, int cmd, int attr, int attr_size)
+{
+	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_1, cmd));
+	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_2, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, attr));
+	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_3, attr_size));
+	bpf_gen__emit(gen, BPF_EMIT_CALL(BPF_FUNC_sys_bpf));
+	/* remember the result in R7 */
+	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_0));
+}
+
+static void bpf_gen__emit_check_err(struct bpf_gen *gen)
+{
+	bpf_gen__emit(gen, BPF_JMP_IMM(BPF_JSGE, BPF_REG_7, 0, 2));
+	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_0, BPF_REG_7));
+	bpf_gen__emit(gen, BPF_EXIT_INSN());
+}
+
+static void __bpf_gen__debug(struct bpf_gen *gen, int reg1, int reg2, const char *fmt, va_list args)
+{
+	char buf[1024];
+	int addr, len, ret;
+
+	if (!gen->log_level)
+		return;
+	ret = vsnprintf(buf, sizeof(buf), fmt, args);
+	if (ret < 1024 - 7 && reg1 >= 0 && reg2 < 0)
+		strcat(buf, " r=%d");
+	len = strlen(buf) + 1;
+	addr = bpf_gen__add_data(gen, buf, len);
+
+	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, addr));
+	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_2, len));
+	if (reg1 >= 0)
+		bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_3, reg1));
+	if (reg2 >= 0)
+		bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_4, reg2));
+	bpf_gen__emit(gen, BPF_EMIT_CALL(BPF_FUNC_trace_printk));
+}
+
+static void bpf_gen__debug_regs(struct bpf_gen *gen, int reg1, int reg2, const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	__bpf_gen__debug(gen, reg1, reg2, fmt, args);
+	va_end(args);
+}
+
+static void bpf_gen__debug_ret(struct bpf_gen *gen, const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	__bpf_gen__debug(gen, BPF_REG_7, -1, fmt, args);
+	va_end(args);
+}
+
+static void bpf_gen__emit_sys_close(struct bpf_gen *gen, int stack_off)
+{
+	bpf_gen__emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_10, stack_off));
+	bpf_gen__emit(gen, BPF_JMP_IMM(BPF_JSLE, BPF_REG_1, 0, 2 + (gen->log_level ? 6 : 0)));
+	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_9, BPF_REG_1));
+	bpf_gen__emit(gen, BPF_EMIT_CALL(BPF_FUNC_sys_close));
+	bpf_gen__debug_regs(gen, BPF_REG_9, BPF_REG_0, "close(%%d) = %%d");
+}
+
+int bpf_gen__finish(struct bpf_gen *gen)
+{
+	int i;
+
+	bpf_gen__emit_sys_close(gen, stack_off(btf_fd));
+	for (i = 0; i < gen->nr_progs; i++)
+		bpf_gen__move_stack2ctx(gen, offsetof(struct bpf_loader_ctx,
+						      u[gen->nr_maps + i].map_fd), 4,
+					stack_off(prog_fd[i]));
+	for (i = 0; i < gen->nr_maps; i++)
+		bpf_gen__move_stack2ctx(gen, offsetof(struct bpf_loader_ctx,
+						      u[i].prog_fd), 4,
+					stack_off(map_fd[i]));
+	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_0, 0));
+	bpf_gen__emit(gen, BPF_EXIT_INSN());
+	pr_debug("bpf_gen__finish %d\n", gen->error);
+	return gen->error;
+}
+
+void bpf_gen__load_btf(struct bpf_gen *gen, const void *btf_raw_data, __u32 btf_raw_size)
+{
+	union bpf_attr attr = {};
+	int attr_size = offsetofend(union bpf_attr, btf_log_level);
+	int btf_data, btf_load_attr;
+
+	pr_debug("btf_load: size %d\n", btf_raw_size);
+	btf_data = bpf_gen__add_data(gen, btf_raw_data, btf_raw_size);
+
+	attr.btf_size = btf_raw_size;
+	btf_load_attr = bpf_gen__add_data(gen, &attr, attr_size);
+
+	/* populate union bpf_attr with user provided log details */
+	bpf_gen__move_ctx2blob(gen, btf_load_attr + offsetof(union bpf_attr, btf_log_level), 4,
+			       offsetof(struct bpf_loader_ctx, log_level));
+	bpf_gen__move_ctx2blob(gen, btf_load_attr + offsetof(union bpf_attr, btf_log_size), 4,
+			       offsetof(struct bpf_loader_ctx, log_size));
+	bpf_gen__move_ctx2blob(gen, btf_load_attr + offsetof(union bpf_attr, btf_log_buf), 8,
+			       offsetof(struct bpf_loader_ctx, log_buf));
+	/* populate union bpf_attr with a pointer to the BTF data */
+	bpf_gen__emit_rel_store(gen, btf_load_attr + offsetof(union bpf_attr, btf), btf_data);
+	/* emit BTF_LOAD command */
+	bpf_gen__emit_sys_bpf(gen, BPF_BTF_LOAD, btf_load_attr, attr_size);
+	bpf_gen__debug_ret(gen, "btf_load size %d", btf_raw_size);
+	bpf_gen__emit_check_err(gen);
+	/* remember btf_fd in the stack, if successful */
+	bpf_gen__emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7, stack_off(btf_fd)));
+}
+
+void bpf_gen__map_create(struct bpf_gen *gen, struct bpf_create_map_attr *map_attr, int map_idx)
+{
+	union bpf_attr attr = {};
+	int attr_size = offsetofend(union bpf_attr, btf_vmlinux_value_type_id);
+	bool close_inner_map_fd = false;
+	int map_create_attr;
+
+	attr.map_type = map_attr->map_type;
+	attr.key_size = map_attr->key_size;
+	attr.value_size = map_attr->value_size;
+	attr.map_flags = map_attr->map_flags;
+	memcpy(attr.map_name, map_attr->name,
+	       min((unsigned)strlen(map_attr->name), BPF_OBJ_NAME_LEN - 1));
+	attr.numa_node = map_attr->numa_node;
+	attr.map_ifindex = map_attr->map_ifindex;
+	attr.max_entries = map_attr->max_entries;
+	switch (attr.map_type) {
+	case BPF_MAP_TYPE_PERF_EVENT_ARRAY:
+	case BPF_MAP_TYPE_CGROUP_ARRAY:
+	case BPF_MAP_TYPE_STACK_TRACE:
+	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
+	case BPF_MAP_TYPE_HASH_OF_MAPS:
+	case BPF_MAP_TYPE_DEVMAP:
+	case BPF_MAP_TYPE_DEVMAP_HASH:
+	case BPF_MAP_TYPE_CPUMAP:
+	case BPF_MAP_TYPE_XSKMAP:
+	case BPF_MAP_TYPE_SOCKMAP:
+	case BPF_MAP_TYPE_SOCKHASH:
+	case BPF_MAP_TYPE_QUEUE:
+	case BPF_MAP_TYPE_STACK:
+	case BPF_MAP_TYPE_RINGBUF:
+		break;
+	default:
+		attr.btf_key_type_id = map_attr->btf_key_type_id;
+		attr.btf_value_type_id = map_attr->btf_value_type_id;
+	}
+
+	pr_debug("map_create: %s idx %d type %d value_type_id %d\n",
+		 attr.map_name, map_idx, map_attr->map_type, attr.btf_value_type_id);
+
+	map_create_attr = bpf_gen__add_data(gen, &attr, attr_size);
+	if (attr.btf_value_type_id)
+		/* populate union bpf_attr with btf_fd saved in the stack earlier */
+		bpf_gen__move_stack2blob(gen, map_create_attr + offsetof(union bpf_attr, btf_fd), 4,
+					 stack_off(btf_fd));
+	switch (attr.map_type) {
+	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
+	case BPF_MAP_TYPE_HASH_OF_MAPS:
+		bpf_gen__move_stack2blob(gen, map_create_attr + offsetof(union bpf_attr, inner_map_fd),
+					 4, stack_off(inner_map_fd));
+		close_inner_map_fd = true;
+		break;
+	default:;
+	}
+	/* emit MAP_CREATE command */
+	bpf_gen__emit_sys_bpf(gen, BPF_MAP_CREATE, map_create_attr, attr_size);
+	bpf_gen__debug_ret(gen, "map_create %s idx %d type %d value_size %d",
+			   attr.map_name, map_idx, map_attr->map_type, attr.value_size);
+	bpf_gen__emit_check_err(gen);
+	/* remember map_fd in the stack, if successful */
+	if (map_idx < 0) {
+		bpf_gen__emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7, stack_off(inner_map_fd)));
+	} else {
+		if (map_idx != gen->nr_maps) {
+			gen->error = -EDOM; /* internal bug */
+			return;
+		}
+		bpf_gen__emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7, stack_off(map_fd[map_idx])));
+		gen->nr_maps++;
+	}
+	if (close_inner_map_fd)
+		bpf_gen__emit_sys_close(gen, stack_off(inner_map_fd));
+}
+
+void bpf_gen__record_find_name(struct bpf_gen *gen, const char *attach_name,
+			       enum bpf_attach_type type)
+{
+	const char *prefix;
+	int kind, len, name;
+
+	btf_get_kernel_prefix_kind(type, &prefix, &kind);
+	pr_debug("find_btf_id '%s%s'\n", prefix, attach_name);
+	len = strlen(prefix);
+	if (len)
+		name = bpf_gen__add_data(gen, prefix, len);
+	name = bpf_gen__add_data(gen, attach_name, strlen(attach_name) + 1);
+	name -= len;
+
+	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_1, 0));
+	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_2, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, name));
+	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_3, kind));
+	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_4, BPF_REG_10));
+	bpf_gen__emit(gen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, stack_off(last_attach_btf_obj_fd)));
+	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_5, 0));
+	bpf_gen__emit(gen, BPF_EMIT_CALL(BPF_FUNC_btf_find_by_name_kind));
+	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_0));
+	bpf_gen__debug_ret(gen, "find_by_name_kind(%s%s,%d)", prefix, attach_name, kind);
+	bpf_gen__emit_check_err(gen);
+	/* remember btf_id */
+	bpf_gen__emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7, stack_off(last_btf_id)));
+}
+
+void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind, int insn_idx)
+{
+	struct relo_desc *relo;
+
+	relo = libbpf_reallocarray(gen->relos, gen->relo_cnt + 1, sizeof(*relo));
+	if (!relo) {
+		gen->error = -ENOMEM;
+		return;
+	}
+	gen->relos = relo;
+	relo += gen->relo_cnt;
+	relo->name = name;
+	relo->kind = kind;
+	relo->insn_idx = insn_idx;
+	gen->relo_cnt++;
+}
+
+static void bpf_gen__emit_relo(struct bpf_gen *gen, struct relo_desc *relo, int insns)
+{
+	int name, insn;
+
+	pr_debug("relo: %s at %d\n", relo->name, relo->insn_idx);
+	name = bpf_gen__add_data(gen, relo->name, strlen(relo->name) + 1);
+
+	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_1, 0));
+	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_2, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, name));
+	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_3, relo->kind));
+	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_4, BPF_REG_10));
+	bpf_gen__emit(gen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, stack_off(last_attach_btf_obj_fd)));
+	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_5, 0));
+	bpf_gen__emit(gen, BPF_EMIT_CALL(BPF_FUNC_btf_find_by_name_kind));
+	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_0));
+	bpf_gen__debug_ret(gen, "find_by_name_kind(%s,%d)", relo->name, relo->kind);
+	bpf_gen__emit_check_err(gen);
+	/* store btf_id into insn[insn_idx].imm */
+	insn = (int)(long)&((struct bpf_insn *)(long)insns)[relo->insn_idx].imm;
+	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_0, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, insn));
+	bpf_gen__emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_0, BPF_REG_7, 0));
+}
+
+void bpf_gen__prog_load(struct bpf_gen *gen, struct bpf_prog_load_params *load_attr, int prog_idx)
+{
+	union bpf_attr attr = {};
+	int attr_size = offsetofend(union bpf_attr, fd_array);
+	int prog_load_attr, license, insns, func_info, line_info, i;
+
+	pr_debug("prog_load: type %d insns_cnt %zd\n",
+		 load_attr->prog_type, load_attr->insn_cnt);
+	/* add license string to blob of bytes */
+	license = bpf_gen__add_data(gen, load_attr->license, strlen(load_attr->license) + 1);
+	/* add insns to blob of bytes */
+	insns = bpf_gen__add_data(gen, load_attr->insns,
+				  load_attr->insn_cnt * sizeof(struct bpf_insn));
+
+	attr.prog_type = load_attr->prog_type;
+	attr.expected_attach_type = load_attr->expected_attach_type;
+	attr.attach_btf_id = load_attr->attach_btf_id;
+	attr.prog_ifindex = load_attr->prog_ifindex;
+	attr.kern_version = 0;
+	attr.insn_cnt = (__u32)load_attr->insn_cnt;
+	attr.prog_flags = load_attr->prog_flags;
+
+	attr.func_info_rec_size = load_attr->func_info_rec_size;
+	attr.func_info_cnt = load_attr->func_info_cnt;
+	func_info = bpf_gen__add_data(gen, load_attr->func_info,
+				      attr.func_info_cnt * attr.func_info_rec_size);
+
+	attr.line_info_rec_size = load_attr->line_info_rec_size;
+	attr.line_info_cnt = load_attr->line_info_cnt;
+	line_info = bpf_gen__add_data(gen, load_attr->line_info,
+				      attr.line_info_cnt * attr.line_info_rec_size);
+
+	memcpy(attr.prog_name, load_attr->name,
+	       min((unsigned)strlen(load_attr->name), BPF_OBJ_NAME_LEN - 1));
+	prog_load_attr = bpf_gen__add_data(gen, &attr, attr_size);
+
+	/* populate union bpf_attr with a pointer to license */
+	bpf_gen__emit_rel_store(gen, prog_load_attr + offsetof(union bpf_attr, license), license);
+
+	/* populate union bpf_attr with a pointer to instructions */
+	bpf_gen__emit_rel_store(gen, prog_load_attr + offsetof(union bpf_attr, insns), insns);
+
+	/* populate union bpf_attr with a pointer to func_info */
+	bpf_gen__emit_rel_store(gen, prog_load_attr + offsetof(union bpf_attr, func_info), func_info);
+
+	/* populate union bpf_attr with a pointer to line_info */
+	bpf_gen__emit_rel_store(gen, prog_load_attr + offsetof(union bpf_attr, line_info), line_info);
+
+	/* populate union bpf_attr fd_array with a pointer to stack where map_fds are saved */
+	bpf_gen__emit_rel_store_sp(gen, prog_load_attr + offsetof(union bpf_attr, fd_array),
+				   stack_off(map_fd[0]));
+
+	/* populate union bpf_attr with user provided log details */
+	bpf_gen__move_ctx2blob(gen, prog_load_attr + offsetof(union bpf_attr, log_level), 4,
+			       offsetof(struct bpf_loader_ctx, log_level));
+	bpf_gen__move_ctx2blob(gen, prog_load_attr + offsetof(union bpf_attr, log_size), 4,
+			       offsetof(struct bpf_loader_ctx, log_size));
+	bpf_gen__move_ctx2blob(gen, prog_load_attr + offsetof(union bpf_attr, log_buf), 8,
+			       offsetof(struct bpf_loader_ctx, log_buf));
+	/* populate union bpf_attr with btf_fd saved in the stack earlier */
+	bpf_gen__move_stack2blob(gen, prog_load_attr + offsetof(union bpf_attr, prog_btf_fd), 4,
+				 stack_off(btf_fd));
+	if (attr.attach_btf_id) {
+		/* populate union bpf_attr with btf_id and obj_fd found by helper */
+		bpf_gen__move_stack2blob(gen, prog_load_attr + offsetof(union bpf_attr, attach_btf_id), 4,
+					 stack_off(last_btf_id));
+		bpf_gen__move_stack2blob(gen, prog_load_attr + offsetof(union bpf_attr, attach_btf_obj_fd), 4,
+					 stack_off(last_attach_btf_obj_fd));
+	}
+	for (i = 0; i < gen->relo_cnt; i++)
+		bpf_gen__emit_relo(gen, gen->relos + i, insns);
+	if (gen->relo_cnt) {
+		free(gen->relos);
+		gen->relo_cnt = 0;
+		gen->relos = NULL;
+	}
+	/* emit PROG_LOAD command */
+	bpf_gen__emit_sys_bpf(gen, BPF_PROG_LOAD, prog_load_attr, attr_size);
+	bpf_gen__debug_ret(gen, "prog_load %s insn_cnt %d", attr.prog_name, attr.insn_cnt);
+	bpf_gen__emit_check_err(gen);
+	/* remember prog_fd in the stack, if successful */
+	bpf_gen__emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7, stack_off(prog_fd[gen->nr_progs])));
+	if (attr.attach_btf_id)
+		bpf_gen__emit_sys_close(gen, stack_off(last_attach_btf_obj_fd));
+	gen->nr_progs++;
+}
+
+void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *pvalue, __u32 value_size)
+{
+	union bpf_attr attr = {};
+	int attr_size = offsetofend(union bpf_attr, flags);
+	int map_update_attr, value, key;
+	int zero = 0;
+
+	pr_debug("map_update_elem: idx %d\n", map_idx);
+	value = bpf_gen__add_data(gen, pvalue, value_size);
+	key = bpf_gen__add_data(gen, &zero, sizeof(zero));
+	map_update_attr = bpf_gen__add_data(gen, &attr, attr_size);
+	bpf_gen__move_stack2blob(gen, map_update_attr + offsetof(union bpf_attr, map_fd), 4,
+				 stack_off(map_fd[map_idx]));
+	bpf_gen__emit_rel_store(gen, map_update_attr + offsetof(union bpf_attr, key), key);
+	bpf_gen__emit_rel_store(gen, map_update_attr + offsetof(union bpf_attr, value), value);
+	/* emit MAP_UPDATE_ELEM command */
+	bpf_gen__emit_sys_bpf(gen, BPF_MAP_UPDATE_ELEM, map_update_attr, attr_size);
+	bpf_gen__debug_ret(gen, "update_elem idx %d value_size %d", map_idx, value_size);
+	bpf_gen__emit_check_err(gen);
+}
+
+void bpf_gen__map_freeze(struct bpf_gen *gen, int map_idx)
+{
+	union bpf_attr attr = {};
+	int attr_size = offsetofend(union bpf_attr, map_fd);
+	int map_freeze_attr;
+
+	pr_debug("map_freeze: idx %d\n", map_idx);
+	map_freeze_attr = bpf_gen__add_data(gen, &attr, attr_size);
+	bpf_gen__move_stack2blob(gen, map_freeze_attr + offsetof(union bpf_attr, map_fd), 4,
+				 stack_off(map_fd[map_idx]));
+	/* emit MAP_FREEZE command */
+	bpf_gen__emit_sys_bpf(gen, BPF_MAP_FREEZE, map_freeze_attr, attr_size);
+	bpf_gen__debug_ret(gen, "map_freeze");
+	bpf_gen__emit_check_err(gen);
+}
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 083e441d9c5e..a61b4d401527 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -54,6 +54,7 @@
 #include "str_error.h"
 #include "libbpf_internal.h"
 #include "hashmap.h"
+#include "bpf_gen_internal.h"
 
 #ifndef BPF_FS_MAGIC
 #define BPF_FS_MAGIC		0xcafe4a11
@@ -435,6 +436,8 @@ struct bpf_object {
 	bool loaded;
 	bool has_subcalls;
 
+	struct bpf_gen *gen_trace;
+
 	/*
 	 * Information when doing elf related work. Only valid if fd
 	 * is valid.
@@ -2651,7 +2654,15 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 		bpf_object__sanitize_btf(obj, kern_btf);
 	}
 
-	err = btf__load(kern_btf);
+	if (obj->gen_trace) {
+		__u32 raw_size = 0;
+		const void *raw_data = btf__get_raw_data(kern_btf, &raw_size);
+
+		bpf_gen__load_btf(obj->gen_trace, raw_data, raw_size);
+		btf__set_fd(kern_btf, 0);
+	} else {
+		err = btf__load(kern_btf);
+	}
 	if (sanitize) {
 		if (!err) {
 			/* move fd to libbpf's BTF */
@@ -4277,6 +4288,17 @@ static bool kernel_supports(enum kern_feature_id feat_id)
 	return READ_ONCE(feat->res) == FEAT_SUPPORTED;
 }
 
+static void mark_feat_supported(enum kern_feature_id last_feat)
+{
+	struct kern_feature_desc *feat;
+	int i;
+
+	for (i = 0; i <= last_feat; i++) {
+		feat = &feature_probes[i];
+		WRITE_ONCE(feat->res, FEAT_SUPPORTED);
+	}
+}
+
 static bool map_is_reuse_compat(const struct bpf_map *map, int map_fd)
 {
 	struct bpf_map_info map_info = {};
@@ -4344,6 +4366,13 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 	char *cp, errmsg[STRERR_BUFSIZE];
 	int err, zero = 0;
 
+	if (obj->gen_trace) {
+		bpf_gen__map_update_elem(obj->gen_trace, map - obj->maps,
+					 map->mmaped, map->def.value_size);
+		if (map_type == LIBBPF_MAP_RODATA || map_type == LIBBPF_MAP_KCONFIG)
+			bpf_gen__map_freeze(obj->gen_trace, map - obj->maps);
+		return 0;
+	}
 	err = bpf_map_update_elem(map->fd, &zero, map->mmaped, 0);
 	if (err) {
 		err = -errno;
@@ -4369,7 +4398,7 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 
 static void bpf_map__destroy(struct bpf_map *map);
 
-static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
+static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, bool is_inner)
 {
 	struct bpf_create_map_attr create_attr;
 	struct bpf_map_def *def = &map->def;
@@ -4415,9 +4444,9 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
 
 	if (bpf_map_type__is_map_in_map(def->type)) {
 		if (map->inner_map) {
-			int err;
+			int err = 0;
 
-			err = bpf_object__create_map(obj, map->inner_map);
+			err = bpf_object__create_map(obj, map->inner_map, true);
 			if (err) {
 				pr_warn("map '%s': failed to create inner map: %d\n",
 					map->name, err);
@@ -4429,7 +4458,12 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
 			create_attr.inner_map_fd = map->inner_map_fd;
 	}
 
-	map->fd = bpf_create_map_xattr(&create_attr);
+	if (obj->gen_trace) {
+		bpf_gen__map_create(obj->gen_trace, &create_attr, is_inner ? -1 : map - obj->maps);
+		map->fd = 0;
+	} else {
+		map->fd = bpf_create_map_xattr(&create_attr);
+	}
 	if (map->fd < 0 && (create_attr.btf_key_type_id ||
 			    create_attr.btf_value_type_id)) {
 		char *cp, errmsg[STRERR_BUFSIZE];
@@ -4457,11 +4491,11 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
 	return 0;
 }
 
-static int init_map_slots(struct bpf_map *map)
+static int init_map_slots(struct bpf_object *obj, struct bpf_map *map)
 {
 	const struct bpf_map *targ_map;
 	unsigned int i;
-	int fd, err;
+	int fd, err = 0;
 
 	for (i = 0; i < map->init_slots_sz; i++) {
 		if (!map->init_slots[i])
@@ -4469,7 +4503,12 @@ static int init_map_slots(struct bpf_map *map)
 
 		targ_map = map->init_slots[i];
 		fd = bpf_map__fd(targ_map);
-		err = bpf_map_update_elem(map->fd, &i, &fd, 0);
+		if (obj->gen_trace) {
+			printf("// TODO map_update_elem: idx %ld key %d value==map_idx %ld\n",
+			       map - obj->maps, i, targ_map - obj->maps);
+		} else {
+			err = bpf_map_update_elem(map->fd, &i, &fd, 0);
+		}
 		if (err) {
 			err = -errno;
 			pr_warn("map '%s': failed to initialize slot [%d] to map '%s' fd=%d: %d\n",
@@ -4511,7 +4550,7 @@ bpf_object__create_maps(struct bpf_object *obj)
 			pr_debug("map '%s': skipping creation (preset fd=%d)\n",
 				 map->name, map->fd);
 		} else {
-			err = bpf_object__create_map(obj, map);
+			err = bpf_object__create_map(obj, map, false);
 			if (err)
 				goto err_out;
 
@@ -4527,7 +4566,7 @@ bpf_object__create_maps(struct bpf_object *obj)
 			}
 
 			if (map->init_slots_sz) {
-				err = init_map_slots(map);
+				err = init_map_slots(obj, map);
 				if (err < 0) {
 					zclose(map->fd);
 					goto err_out;
@@ -4937,6 +4976,9 @@ static int load_module_btfs(struct bpf_object *obj)
 	if (obj->btf_modules_loaded)
 		return 0;
 
+	if (obj->gen_trace)
+		return 0;
+
 	/* don't do this again, even if we find no module BTFs */
 	obj->btf_modules_loaded = true;
 
@@ -6082,6 +6124,11 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 	if (str_is_empty(spec_str))
 		return -EINVAL;
 
+	if (prog->obj->gen_trace) {
+		printf("// TODO core_relo: prog %ld insn[%d] %s %s kind %d\n",
+		       prog - prog->obj->programs, relo->insn_off / 8,
+		       local_name, spec_str, relo->kind);
+	}
 	err = bpf_core_parse_spec(local_btf, local_id, spec_str, relo->kind, &local_spec);
 	if (err) {
 		pr_warn("prog '%s': relo #%d: parsing [%d] %s %s + %s failed: %d\n",
@@ -6818,6 +6865,19 @@ bpf_object__relocate_calls(struct bpf_object *obj, struct bpf_program *prog)
 
 	return 0;
 }
+static void
+bpf_object__free_relocs(struct bpf_object *obj)
+{
+	struct bpf_program *prog;
+	int i;
+
+	/* free up relocation descriptors */
+	for (i = 0; i < obj->nr_programs; i++) {
+		prog = &obj->programs[i];
+		zfree(&prog->reloc_desc);
+		prog->nr_reloc = 0;
+	}
+}
 
 static int
 bpf_object__relocate(struct bpf_object *obj, const char *targ_btf_path)
@@ -6867,12 +6927,8 @@ bpf_object__relocate(struct bpf_object *obj, const char *targ_btf_path)
 			return err;
 		}
 	}
-	/* free up relocation descriptors */
-	for (i = 0; i < obj->nr_programs; i++) {
-		prog = &obj->programs[i];
-		zfree(&prog->reloc_desc);
-		prog->nr_reloc = 0;
-	}
+	if (!obj->gen_trace)
+		bpf_object__free_relocs(obj);
 	return 0;
 }
 
@@ -7061,6 +7117,9 @@ static int bpf_object__sanitize_prog(struct bpf_object* obj, struct bpf_program
 	enum bpf_func_id func_id;
 	int i;
 
+	if (obj->gen_trace)
+		return 0;
+
 	for (i = 0; i < prog->insns_cnt; i++, insn++) {
 		if (!insn_is_helper_call(insn, &func_id))
 			continue;
@@ -7146,6 +7205,12 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.log_level = prog->log_level;
 	load_attr.prog_flags = prog->prog_flags;
 
+	if (prog->obj->gen_trace) {
+		bpf_gen__prog_load(prog->obj->gen_trace, &load_attr,
+				   prog - prog->obj->programs);
+		*pfd = 0;
+		return 0;
+	}
 retry_load:
 	if (log_buf_size) {
 		log_buf = malloc(log_buf_size);
@@ -7223,6 +7288,35 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	return ret;
 }
 
+static int bpf_program__record_externs(struct bpf_program *prog)
+{
+	struct bpf_object *obj = prog->obj;
+	int i;
+
+	for (i = 0; i < prog->nr_reloc; i++) {
+		struct reloc_desc *relo = &prog->reloc_desc[i];
+		struct extern_desc *ext = &obj->externs[relo->sym_off];
+
+		switch (relo->type) {
+		case RELO_EXTERN_VAR:
+			if (ext->type != EXT_KSYM)
+				continue;
+			if (!ext->ksym.type_id) /* typeless ksym */
+				continue;
+			bpf_gen__record_extern(obj->gen_trace, ext->name, BTF_KIND_VAR,
+					       relo->insn_idx);
+			break;
+		case RELO_EXTERN_FUNC:
+			bpf_gen__record_extern(obj->gen_trace, ext->name, BTF_KIND_FUNC,
+					       relo->insn_idx);
+			break;
+		default:
+			continue;
+		}
+	}
+	return 0;
+}
+
 static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd, int *btf_type_id);
 
 int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
@@ -7268,6 +7362,8 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 			pr_warn("prog '%s': inconsistent nr(%d) != 1\n",
 				prog->name, prog->instances.nr);
 		}
+		if (prog->obj->gen_trace)
+			bpf_program__record_externs(prog);
 		err = load_program(prog, prog->insns, prog->insns_cnt,
 				   license, kern_ver, &fd);
 		if (!err)
@@ -7359,6 +7455,8 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 			return err;
 		}
 	}
+	if (obj->gen_trace)
+		bpf_object__free_relocs(obj);
 	free(fd_array);
 	return 0;
 }
@@ -7740,6 +7838,12 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
 		if (ext->type != EXT_KSYM || !ext->ksym.type_id)
 			continue;
 
+		if (obj->gen_trace) {
+			ext->is_set = true;
+			ext->ksym.kernel_btf_obj_fd = 0;
+			ext->ksym.kernel_btf_id = 0;
+			continue;
+		}
 		t = btf__type_by_id(obj->btf, ext->btf_id);
 		if (btf_is_var(t))
 			err = bpf_object__resolve_ksym_var_btf_id(obj, ext);
@@ -7854,6 +7958,11 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 		return -EINVAL;
 	}
 
+	if (obj->gen_trace) {
+		mark_feat_supported(FEAT_FD_IDX);
+		bpf_gen__init(obj->gen_trace, attr->log_level);
+	}
+
 	err = bpf_object__probe_loading(obj);
 	err = err ? : bpf_object__load_vmlinux_btf(obj, false);
 	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
@@ -7864,6 +7973,9 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 	err = err ? : bpf_object__relocate(obj, attr->target_btf_path);
 	err = err ? : bpf_object__load_progs(obj, attr->log_level);
 
+	if (obj->gen_trace && !err)
+		err = bpf_gen__finish(obj->gen_trace);
+
 	/* clean up module BTFs */
 	for (i = 0; i < obj->btf_module_cnt; i++) {
 		close(obj->btf_modules[i].fd);
@@ -8579,6 +8691,11 @@ void *bpf_object__priv(const struct bpf_object *obj)
 	return obj ? obj->priv : ERR_PTR(-EINVAL);
 }
 
+void bpf_object__set_gen_trace(struct bpf_object *obj, struct bpf_gen *gen)
+{
+	obj->gen_trace = gen;
+}
+
 static struct bpf_program *
 __bpf_program__iter(const struct bpf_program *p, const struct bpf_object *obj,
 		    bool forward)
@@ -9215,6 +9332,28 @@ static int bpf_object__collect_st_ops_relos(struct bpf_object *obj,
 #define BTF_ITER_PREFIX "bpf_iter_"
 #define BTF_MAX_NAME_SIZE 128
 
+void btf_get_kernel_prefix_kind(enum bpf_attach_type attach_type,
+				const char **prefix, int *kind)
+{
+	switch (attach_type) {
+	case BPF_TRACE_RAW_TP:
+		*prefix = BTF_TRACE_PREFIX;
+		*kind = BTF_KIND_TYPEDEF;
+		break;
+	case BPF_LSM_MAC:
+		*prefix = BTF_LSM_PREFIX;
+		*kind = BTF_KIND_FUNC;
+		break;
+	case BPF_TRACE_ITER:
+		*prefix = BTF_ITER_PREFIX;
+		*kind = BTF_KIND_FUNC;
+		break;
+	default:
+		*prefix = "";
+		*kind = BTF_KIND_FUNC;
+	}
+}
+
 static int find_btf_by_prefix_kind(const struct btf *btf, const char *prefix,
 				   const char *name, __u32 kind)
 {
@@ -9235,21 +9374,11 @@ static int find_btf_by_prefix_kind(const struct btf *btf, const char *prefix,
 static inline int find_attach_btf_id(struct btf *btf, const char *name,
 				     enum bpf_attach_type attach_type)
 {
-	int err;
-
-	if (attach_type == BPF_TRACE_RAW_TP)
-		err = find_btf_by_prefix_kind(btf, BTF_TRACE_PREFIX, name,
-					      BTF_KIND_TYPEDEF);
-	else if (attach_type == BPF_LSM_MAC)
-		err = find_btf_by_prefix_kind(btf, BTF_LSM_PREFIX, name,
-					      BTF_KIND_FUNC);
-	else if (attach_type == BPF_TRACE_ITER)
-		err = find_btf_by_prefix_kind(btf, BTF_ITER_PREFIX, name,
-					      BTF_KIND_FUNC);
-	else
-		err = btf__find_by_name_kind(btf, name, BTF_KIND_FUNC);
+	const char *prefix;
+	int kind;
 
-	return err;
+	btf_get_kernel_prefix_kind(attach_type, &prefix, &kind);
+	return find_btf_by_prefix_kind(btf, prefix, name, kind);
 }
 
 int libbpf_find_vmlinux_btf_id(const char *name,
@@ -9348,7 +9477,7 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd,
 	__u32 attach_prog_fd = prog->attach_prog_fd;
 	const char *name = prog->sec_name, *attach_name;
 	const struct bpf_sec_def *sec = NULL;
-	int i, err;
+	int i, err = 0;
 
 	if (!name)
 		return -EINVAL;
@@ -9383,7 +9512,13 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd,
 	}
 
 	/* kernel/module BTF ID */
-	err = find_kernel_btf_id(prog->obj, attach_name, attach_type, btf_obj_fd, btf_type_id);
+	if (prog->obj->gen_trace) {
+		bpf_gen__record_find_name(prog->obj->gen_trace, attach_name, attach_type);
+		*btf_obj_fd = 0;
+		*btf_type_id = 1;
+	} else {
+		err = find_kernel_btf_id(prog->obj, attach_name, attach_type, btf_obj_fd, btf_type_id);
+	}
 	if (err) {
 		pr_warn("failed to find kernel BTF type ID of '%s': %d\n", attach_name, err);
 		return err;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b9b29baf1df8..a5dffc0a3369 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -361,4 +361,5 @@ LIBBPF_0.4.0 {
 		bpf_linker__new;
 		bpf_map__inner_map;
 		bpf_object__set_kversion;
+		bpf_load;
 } LIBBPF_0.3.0;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 9114c7085f2a..fd5c57ac93f1 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -214,6 +214,8 @@ int bpf_object__section_size(const struct bpf_object *obj, const char *name,
 int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
 				__u32 *off);
 struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf);
+void btf_get_kernel_prefix_kind(enum bpf_attach_type attach_type,
+				const char **prefix, int *kind);
 
 struct btf_ext_info {
 	/*
-- 
2.30.2


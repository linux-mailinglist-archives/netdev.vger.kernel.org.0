Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D123FADD6
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 20:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235948AbhH2Shg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 14:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235882AbhH2Sh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 14:37:29 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BA8C061575
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:36 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id u3so26108528ejz.1
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1GGWQS2F8TIkjkfRjAwlg/olnvQAdF9KhtCTM+aLY1E=;
        b=mY9VHMDkf10DOfWWJ9LPFz58W+fOhT0WiNNGEz0oY4yy+QF9rVODBM3wOPrAZUkL/a
         VfOpjHe4oNSDj/2Dqyuk2SxYIDyZEz8QqzKaGuoj7IIfxJxxN/4hgViFf/V1OFZhgzdZ
         wnsSZ3Kjlej/9V/FUCzlKd31Tedkl6og7j7QMBtQC8ieNqYBr19rKy+nKMpLZmLst+c4
         dA+1Feor3dzyReBq1IVuFjsZTzTwgBtsEQUQrJAoFGfRLa3YslDmTck/PhLKtOswkzlE
         ycvJxl72ojmhJlIKLrMkczo0l6AEt82gLa/LgmvC83xg9muK61kX80qZRH4QuTZOHsdg
         jYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1GGWQS2F8TIkjkfRjAwlg/olnvQAdF9KhtCTM+aLY1E=;
        b=hZPMn/vY2FTviQfFZHNbbtuqlzulNqgtsbBjax3bYBLbdLzSXBGWi3p0qCo5mY1ebS
         oBYyl3eyvmmyahM8Rqo5plMd/lyF3pX7qH6CeIoMwc8cr8p6noEWfHmxrsocnGhZmh9M
         qim7NTQ+8SrWL6hQ3avbAmcmsff2Efa8PtlOi0QSYh4r32KorzHhFfQyhKzg061qNaNO
         9RP9UwSo2lDiUmVB5PRNTYKWcU4Gx7EpHZLWnc2jRJ2ktgRBwQC5F6qkQtHWQS+chqN7
         4WKb9CPzuXyvwZi3SWxBbDIqUU2v/EqMnse5w6Tu7q842s0hU6PHUg6jOKCVuxfKVIcO
         r17Q==
X-Gm-Message-State: AOAM532OmXZq1CmE/KD6r6lOIBQtJ9sgblKEuEqrMJOBAA/vJJ+YD5mn
        Ft0mTdTPKrOTjR8blgrWHCCa4w==
X-Google-Smtp-Source: ABdhPJztWwzHfOlq6NTBL4sR80p+q/yo0f34c2gZbNUrjyvbkWbad3VsG/8KPpe90Rot8ntsglMrAw==
X-Received: by 2002:a17:906:7256:: with SMTP id n22mr21093771ejk.173.1630262194958;
        Sun, 29 Aug 2021 11:36:34 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id cr9sm6427992edb.17.2021.08.29.11.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 11:36:34 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v2 05/13] bpfilter: Add codegen infrastructure
Date:   Sun, 29 Aug 2021 22:36:00 +0400
Message-Id: <20210829183608.2297877-6-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210829183608.2297877-1-me@ubique.spb.ru>
References: <20210829183608.2297877-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare codegen infrastructure to be used by matches, targets, rules and
tables.

The resulting BPF program is stored as an array of bpf_insn structs.

There are multiple flavours of BPF programs needed for bpfilter: TC and
XDP. While most of the logic is same for the both flavours there are
multiple points where the logic is slightly different. To support such
points there is a codegen_ops struct which provides a polymorphic
interface to emit a specific set of instructions for each individual
flavour.

An emitted instruction may need to be fixed up later - as some data
isn't known at the moment of emitting. To support such cases there are
fixups and relocations. The difference between them is point of time
when data becomes known. For fixups such time point is end of code
generation and for relocations it is a time just before loading the
program. Fixups and relocations are performed during code
generation/preparation for program loading when required data becomes
known and instructions might be adjusted.

Subprogs are required to support user defined chains and helper
subprograms. All already generated subprogs are stored in subprogs
array. This sorted array acts as an index. All subprogs awaiting
generation phase are stored in awaiting_subprogs lists.

To support a shared state between multiple BPF programs there is
shared_codegen struct. Currently it may be used to have a single
counters map both for TC and XDP BPF programs.

Beside that there is a runtime_context struct that might be used to
store frequently required data such as size of the packet and pointer to
L3/L4 headers. This context is stored on the stack and there are macros
to access individual fields of this struct.  Immediately after
runtime_context on stack there is a scratchpad area.

The calling convention follows the BPF calling convention with a couple
of additions:
 * CODEGEN_REG_CTX(BPF_REG_9) is a pointer to program context
 * CODEGEN_REG_RUNTIME_CTX(BPF_REG_8) is a pointer to runtime context

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile                         |  14 +-
 net/bpfilter/codegen.c                        | 732 ++++++++++++++++++
 net/bpfilter/codegen.h                        | 188 +++++
 .../testing/selftests/bpf/bpfilter/.gitignore |   1 +
 tools/testing/selftests/bpf/bpfilter/Makefile |  22 +-
 5 files changed, 954 insertions(+), 3 deletions(-)
 create mode 100644 net/bpfilter/codegen.c
 create mode 100644 net/bpfilter/codegen.h

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 1809759d08c4..f3838368ba08 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -3,9 +3,19 @@
 # Makefile for the Linux BPFILTER layer.
 #
 
+LIBBPF_SRCS = $(srctree)/tools/lib/bpf/
+LIBBPF_A = $(obj)/libbpf.a
+LIBBPF_OUT = $(abspath $(obj))
+
+$(LIBBPF_A):
+	$(Q)$(MAKE) -C $(LIBBPF_SRCS) O=$(LIBBPF_OUT)/ OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
+
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o map-common.o
-userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
+bpfilter_umh-objs := main.o map-common.o codegen.o
+bpfilter_umh-userldlibs := $(LIBBPF_A) -lelf -lz
+userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi -I $(srctree)/tools/lib
+
+$(obj)/bpfilter_umh: $(LIBBPF_A)
 
 ifeq ($(CONFIG_BPFILTER_UMH), y)
 # builtin bpfilter_umh should be linked with -static
diff --git a/net/bpfilter/codegen.c b/net/bpfilter/codegen.c
new file mode 100644
index 000000000000..0fa84d03af63
--- /dev/null
+++ b/net/bpfilter/codegen.c
@@ -0,0 +1,732 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#define _GNU_SOURCE
+
+#include "codegen.h"
+
+#include "../../include/uapi/linux/bpfilter.h"
+
+#include <linux/if_ether.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/pkt_cls.h>
+
+#include <unistd.h>
+#include <sys/syscall.h>
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <bpf/libbpf.h>
+
+#include "context.h"
+
+enum fixup_insn_type { FIXUP_INSN_OFF, FIXUP_INSN_IMM, __MAX_FIXUP_INSN_TYPE };
+
+static int sys_bpf(int cmd, union bpf_attr *attr, unsigned int size)
+{
+	return syscall(SYS_bpf, cmd, attr, size);
+}
+
+static __u64 bpf_ptr_to_u64(const void *ptr)
+{
+	return (__u64)(unsigned long)ptr;
+}
+
+static int subprog_desc_comparator(const void *x, const void *y)
+{
+	const struct codegen_subprog_desc *subprog_x = *(const struct codegen_subprog_desc **)x;
+	const struct codegen_subprog_desc *subprog_y = *(const struct codegen_subprog_desc **)y;
+
+	if (subprog_x->type != subprog_y->type)
+		return subprog_x->type - subprog_y->type;
+
+	if (subprog_x->type == CODEGEN_SUBPROG_USER_CHAIN)
+		return subprog_x->offset - subprog_y->offset;
+
+	BUG_ON(1);
+
+	return -1;
+}
+
+static const struct codegen_subprog_desc *
+codegen_find_subprog(struct codegen *codegen, const struct codegen_subprog_desc **subprog)
+{
+	const struct codegen_subprog_desc **found;
+
+	found = bsearch(subprog, codegen->subprogs, codegen->subprogs_cur,
+			sizeof(codegen->subprogs[0]), subprog_desc_comparator);
+
+	return found ? *found : NULL;
+}
+
+static const struct codegen_subprog_desc *codegen_find_user_chain_subprog(struct codegen *codegen,
+									  uint32_t offset)
+{
+	const struct codegen_subprog_desc subprog = { .type = CODEGEN_SUBPROG_USER_CHAIN,
+						      .offset = offset };
+	const struct codegen_subprog_desc *subprog_ptr = &subprog;
+
+	return codegen_find_subprog(codegen, &subprog_ptr);
+}
+
+int codegen_push_awaiting_subprog(struct codegen *codegen, struct codegen_subprog_desc *subprog)
+{
+	struct list_head *t, *n;
+
+	if (codegen_find_subprog(codegen, (const struct codegen_subprog_desc **)&subprog)) {
+		free(subprog);
+		return 0;
+	}
+
+	list_for_each_safe(t, n, &codegen->awaiting_subprogs) {
+		struct codegen_subprog_desc *awaiting_subprog;
+
+		awaiting_subprog = list_entry(t, struct codegen_subprog_desc, list);
+		if (!subprog_desc_comparator(&awaiting_subprog, &subprog)) {
+			free(subprog);
+			return 0;
+		}
+	}
+
+	list_add_tail(&subprog->list, &codegen->awaiting_subprogs);
+
+	return 0;
+}
+
+static int codegen_fixup_insn(struct bpf_insn *insn, enum fixup_insn_type type, __s32 v)
+{
+	if (type == FIXUP_INSN_OFF) {
+		if (insn->off)
+			return -EINVAL;
+
+		insn->off = v;
+
+		return 0;
+	}
+
+	if (type == FIXUP_INSN_IMM) {
+		if (insn->imm)
+			return -EINVAL;
+
+		insn->imm = v;
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+int codegen_fixup(struct codegen *codegen, enum codegen_fixup_type fixup_type)
+{
+	struct list_head *t, *n;
+
+	list_for_each_safe(t, n, &codegen->fixup) {
+		enum fixup_insn_type type = __MAX_FIXUP_INSN_TYPE;
+		struct codegen_fixup_desc *fixup;
+		struct bpf_insn *insn;
+		int err;
+		__s32 v;
+
+		fixup = list_entry(t, struct codegen_fixup_desc, list);
+		if (fixup->type != fixup_type)
+			continue;
+
+		if (fixup->type >= __MAX_CODEGEN_FIXUP_TYPE)
+			return -EINVAL;
+
+		if (fixup->insn > codegen->len_cur)
+			return -EINVAL;
+
+		insn = &codegen->img[fixup->insn];
+
+		if (fixup_type == CODEGEN_FIXUP_NEXT_RULE ||
+		    fixup_type == CODEGEN_FIXUP_END_OF_CHAIN) {
+			type = FIXUP_INSN_OFF;
+			v = codegen->len_cur - fixup->insn - 1;
+		}
+
+		if (fixup_type == CODEGEN_FIXUP_JUMP_TO_CHAIN) {
+			const struct codegen_subprog_desc *subprog;
+
+			subprog = codegen_find_user_chain_subprog(codegen, fixup->offset);
+			if (!subprog)
+				return -EINVAL;
+
+			type = FIXUP_INSN_OFF;
+			v = subprog->insn - fixup->insn - 1;
+		}
+
+		if (fixup_type == CODEGEN_FIXUP_COUNTERS_INDEX) {
+			type = FIXUP_INSN_IMM;
+			v = codegen->rule_index;
+		}
+
+		err = codegen_fixup_insn(insn, type, v);
+		if (err)
+			return err;
+
+		list_del(t);
+		free(fixup);
+	}
+
+	return 0;
+}
+
+int emit_fixup(struct codegen *codegen, enum codegen_fixup_type fixup_type, struct bpf_insn insn)
+{
+	struct codegen_fixup_desc *fixup;
+
+	fixup = malloc(sizeof(*fixup));
+	if (!fixup)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&fixup->list);
+	fixup->type = fixup_type;
+	fixup->insn = codegen->len_cur;
+	list_add_tail(&fixup->list, &codegen->fixup);
+
+	EMIT(codegen, insn);
+
+	return 0;
+}
+
+int emit_add_counter(struct codegen *codegen)
+{
+	struct bpf_insn insns[2] = { BPF_LD_MAP_FD(BPF_REG_ARG1, 0) };
+	struct codegen_reloc_desc *reloc;
+
+	reloc = malloc(sizeof(*reloc));
+	if (!reloc)
+		return -ENOMEM;
+	EMIT(codegen, BPF_LDX_MEM(BPF_W, CODEGEN_REG_SCRATCH3, CODEGEN_REG_RUNTIME_CTX,
+				  STACK_RUNTIME_CONTEXT_OFFSET(data_size)));
+
+	INIT_LIST_HEAD(&reloc->list);
+	reloc->type = CODEGEN_RELOC_MAP;
+	reloc->map = CODEGEN_MAP_COUNTERS;
+	reloc->insn = codegen->len_cur;
+	list_add_tail(&reloc->list, &codegen->relocs);
+
+	EMIT(codegen, insns[0]);
+	EMIT(codegen, insns[1]);
+	EMIT_FIXUP(codegen, CODEGEN_FIXUP_COUNTERS_INDEX,
+		   BPF_ST_MEM(BPF_W, BPF_REG_10, STACK_SCRATCHPAD_OFFSET - 4, 0));
+	EMIT(codegen, BPF_MOV64_REG(BPF_REG_ARG2, BPF_REG_10));
+	EMIT(codegen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_ARG2, STACK_SCRATCHPAD_OFFSET - 4));
+	EMIT(codegen, BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem));
+	EMIT(codegen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 14));
+
+	reloc = malloc(sizeof(*reloc));
+	if (!reloc)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&reloc->list);
+	reloc->type = CODEGEN_RELOC_MAP;
+	reloc->map = CODEGEN_MAP_COUNTERS;
+	reloc->insn = codegen->len_cur;
+	list_add_tail(&reloc->list, &codegen->relocs);
+
+	EMIT(codegen, insns[0]);
+	EMIT(codegen, insns[1]);
+	EMIT(codegen, BPF_LDX_MEM(BPF_DW, CODEGEN_REG_SCRATCH5, BPF_REG_0, 0));
+	EMIT(codegen, BPF_LDX_MEM(BPF_DW, CODEGEN_REG_SCRATCH4, BPF_REG_0, 8));
+	EMIT(codegen, BPF_LDX_MEM(BPF_W, CODEGEN_REG_SCRATCH3, CODEGEN_REG_RUNTIME_CTX,
+				  STACK_RUNTIME_CONTEXT_OFFSET(data_size)));
+	EMIT(codegen, BPF_ALU64_IMM(BPF_ADD, CODEGEN_REG_SCRATCH5, 1));
+	EMIT(codegen, BPF_ALU64_REG(BPF_ADD, CODEGEN_REG_SCRATCH4, CODEGEN_REG_SCRATCH3));
+	EMIT(codegen, BPF_STX_MEM(BPF_DW, BPF_REG_0, CODEGEN_REG_SCRATCH5, 0));
+	EMIT(codegen, BPF_STX_MEM(BPF_DW, BPF_REG_0, CODEGEN_REG_SCRATCH4, 8));
+	EMIT(codegen, BPF_MOV64_REG(BPF_REG_ARG2, BPF_REG_10));
+	EMIT(codegen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_ARG2, STACK_SCRATCHPAD_OFFSET - 4));
+	EMIT(codegen, BPF_MOV64_REG(BPF_REG_ARG3, BPF_REG_0));
+	EMIT(codegen, BPF_MOV32_IMM(BPF_REG_ARG4, BPF_EXIST));
+	EMIT(codegen, BPF_EMIT_CALL(BPF_FUNC_map_update_elem));
+
+	return 0;
+}
+
+static int codegen_reloc(struct codegen *codegen)
+{
+	struct shared_codegen *shared_codegen;
+	struct list_head *t;
+
+	shared_codegen = codegen->shared_codegen;
+
+	list_for_each(t, &codegen->relocs) {
+		struct codegen_reloc_desc *reloc;
+		struct bpf_insn *insn;
+
+		reloc = list_entry(t, struct codegen_reloc_desc, list);
+
+		if (reloc->insn >= codegen->len_cur)
+			return -EINVAL;
+
+		insn = &codegen->img[reloc->insn];
+
+		if (reloc->type == CODEGEN_RELOC_MAP) {
+			enum codegen_map_type map_type;
+
+			if (codegen->len_cur <= reloc->insn + 1)
+				return -EINVAL;
+
+			if (insn->code != (BPF_LD | BPF_DW | BPF_IMM))
+				return -EINVAL;
+
+			map_type = insn->imm;
+			if (map_type < 0 || map_type >= __MAX_CODEGEN_MAP_TYPE)
+				return -EINVAL;
+
+			BUG_ON(shared_codegen->maps_fd[map_type] < 0);
+			insn->imm = shared_codegen->maps_fd[map_type];
+
+			continue;
+		}
+
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int load_maps(struct codegen *codegen)
+{
+	struct shared_codegen *shared_codegen;
+	int i;
+
+	shared_codegen = codegen->shared_codegen;
+
+	if (shared_codegen->maps_refcnt++)
+		return 0;
+
+	for (i = 0; i < __MAX_CODEGEN_MAP_TYPE; ++i) {
+		int j, fd, saved_errno;
+		union bpf_attr *map;
+
+		BUG_ON(shared_codegen->maps_fd[i] > -1);
+
+		map = &shared_codegen->maps[i];
+		fd = sys_bpf(BPF_MAP_CREATE, map, sizeof(*map));
+
+		if (fd > -1) {
+			shared_codegen->maps_fd[i] = fd;
+			continue;
+		}
+
+		saved_errno = errno;
+
+		for (j = 0; j < i; ++j) {
+			close(shared_codegen->maps_fd[j]);
+			shared_codegen->maps_fd[j] = -1;
+		}
+
+		return saved_errno;
+	}
+
+	return 0;
+}
+
+static void unload_maps(struct codegen *codegen)
+{
+	struct shared_codegen *shared_codegen;
+	int i;
+
+	shared_codegen = codegen->shared_codegen;
+
+	if (--shared_codegen->maps_refcnt)
+		return;
+
+	for (i = 0; i < __MAX_CODEGEN_MAP_TYPE; ++i) {
+		if (shared_codegen->maps_fd[i] > -1) {
+			close(shared_codegen->maps_fd[i]);
+			shared_codegen->maps_fd[i] = -1;
+		}
+	}
+}
+
+static int xdp_gen_inline_prologue(struct codegen *codegen)
+{
+	EMIT(codegen, BPF_MOV64_REG(CODEGEN_REG_CTX, BPF_REG_ARG1));
+	EMIT(codegen, BPF_MOV64_REG(CODEGEN_REG_RUNTIME_CTX, BPF_REG_FP));
+	EMIT(codegen, BPF_MOV32_IMM(CODEGEN_REG_RETVAL, XDP_ABORTED));
+
+	return 0;
+}
+
+static int xdp_load_packet_data(struct codegen *codegen, int dst_reg)
+{
+	EMIT(codegen, BPF_LDX_MEM(BPF_W, dst_reg, CODEGEN_REG_CTX, offsetof(struct xdp_md, data)));
+
+	return 0;
+}
+
+static int xdp_load_packet_data_end(struct codegen *codegen, int dst_reg)
+{
+	EMIT(codegen,
+	     BPF_LDX_MEM(BPF_W, dst_reg, CODEGEN_REG_CTX, offsetof(struct xdp_md, data_end)));
+
+	return 0;
+}
+
+static int xdp_emit_ret_code(struct codegen *codegen, int ret_code)
+{
+	int xdp_ret_code;
+
+	if (ret_code == BPFILTER_NF_ACCEPT)
+		xdp_ret_code = XDP_PASS;
+	else if (ret_code == BPFILTER_NF_DROP)
+		xdp_ret_code = XDP_DROP;
+	else
+		return -EINVAL;
+
+	EMIT(codegen, BPF_MOV32_IMM(BPF_REG_0, xdp_ret_code));
+
+	return 0;
+}
+
+static int xdp_gen_inline_epilogue(struct codegen *codegen)
+{
+	EMIT(codegen, BPF_EXIT_INSN());
+
+	return 0;
+}
+
+struct xdp_img_ctx {
+	int fd;
+};
+
+static int xdp_load_img(struct codegen *codegen)
+{
+	struct xdp_img_ctx *img_ctx;
+	int fd, err;
+
+	if (codegen->img_ctx)
+		return -EINVAL;
+
+	img_ctx = malloc(sizeof(*img_ctx));
+	if (!img_ctx)
+		return -ENOMEM;
+
+	fd = load_img(codegen);
+	if (fd < 0) {
+		err = fd;
+		goto err_free;
+	}
+
+	// TODO: device id
+	err = bpf_set_link_xdp_fd(2, fd, 0);
+	if (err)
+		goto err_free;
+
+	img_ctx->fd = fd;
+	codegen->img_ctx = img_ctx;
+
+	return fd;
+
+err_free:
+	if (fd > -1)
+		close(fd);
+	free(img_ctx);
+
+	return err;
+}
+
+static void xdp_unload_img(struct codegen *codegen)
+{
+	struct xdp_img_ctx *img_ctx;
+
+	BUG_ON(!codegen->img_ctx);
+
+	img_ctx = (struct xdp_img_ctx *)codegen->img_ctx;
+
+	BUG_ON(img_ctx->fd < 0);
+
+	close(img_ctx->fd);
+	free(img_ctx);
+
+	codegen->img_ctx = NULL;
+
+	unload_img(codegen);
+}
+
+static const struct codegen_ops xdp_codegen_ops = {
+	.gen_inline_prologue = xdp_gen_inline_prologue,
+	.load_packet_data = xdp_load_packet_data,
+	.load_packet_data_end = xdp_load_packet_data_end,
+	.emit_ret_code = xdp_emit_ret_code,
+	.gen_inline_epilogue = xdp_gen_inline_epilogue,
+	.load_img = xdp_load_img,
+	.unload_img = xdp_unload_img,
+};
+
+static int tc_gen_inline_prologue(struct codegen *codegen)
+{
+	EMIT(codegen, BPF_MOV64_REG(CODEGEN_REG_CTX, BPF_REG_ARG1));
+	EMIT(codegen, BPF_MOV64_REG(CODEGEN_REG_RUNTIME_CTX, BPF_REG_FP));
+	EMIT(codegen, BPF_MOV32_IMM(CODEGEN_REG_RETVAL, TC_ACT_OK));
+
+	return 0;
+}
+
+static int tc_load_packet_data(struct codegen *codegen, int dst_reg)
+{
+	EMIT(codegen,
+	     BPF_LDX_MEM(BPF_W, dst_reg, CODEGEN_REG_CTX, offsetof(struct __sk_buff, data)));
+
+	return 0;
+}
+
+static int tc_load_packet_data_end(struct codegen *codegen, int dst_reg)
+{
+	EMIT(codegen, BPF_LDX_MEM(BPF_W, CODEGEN_REG_DATA_END, CODEGEN_REG_CTX,
+				  offsetof(struct __sk_buff, data_end)));
+
+	return 0;
+}
+
+static int tc_emit_ret_code(struct codegen *codegen, int ret_code)
+{
+	int tc_ret_code;
+
+	if (ret_code == BPFILTER_NF_ACCEPT)
+		tc_ret_code = BPF_OK;
+	else if (ret_code == BPFILTER_NF_DROP)
+		tc_ret_code = BPF_DROP;
+	else
+		return -EINVAL;
+
+	EMIT(codegen, BPF_MOV32_IMM(BPF_REG_0, tc_ret_code));
+
+	return 0;
+}
+
+static int tc_gen_inline_epilogue(struct codegen *codegen)
+{
+	EMIT(codegen, BPF_EXIT_INSN());
+
+	return 0;
+}
+
+struct tc_img_ctx {
+	int fd;
+	struct bpf_tc_hook hook;
+	struct bpf_tc_opts opts;
+};
+
+static int tc_load_img(struct codegen *codegen)
+{
+	struct tc_img_ctx *img_ctx;
+	int fd, err;
+
+	if (codegen->img_ctx)
+		return -EINVAL;
+
+	img_ctx = calloc(1, sizeof(*img_ctx));
+	if (!img_ctx)
+		return -ENOMEM;
+
+	img_ctx->hook.sz = sizeof(img_ctx->hook);
+	img_ctx->hook.ifindex = 2;
+	img_ctx->hook.attach_point = BPF_TC_EGRESS;
+
+	fd = load_img(codegen);
+	if (fd < 0) {
+		err = fd;
+		goto err_free;
+	}
+
+	err = bpf_tc_hook_create(&img_ctx->hook);
+	if (err == -EEXIST)
+		err = 0;
+	if (err)
+		goto err_free;
+
+	img_ctx->opts.sz = sizeof(img_ctx->opts);
+	img_ctx->opts.handle = 1;
+	img_ctx->opts.priority = 1;
+	img_ctx->opts.prog_fd = fd;
+	err = bpf_tc_attach(&img_ctx->hook, &img_ctx->opts);
+	if (err)
+		goto err_free;
+
+	img_ctx->fd = fd;
+	codegen->img_ctx = img_ctx;
+
+	return fd;
+
+err_free:
+	if (fd > -1)
+		close(fd);
+	free(img_ctx);
+	return err;
+}
+
+static void tc_unload_img(struct codegen *codegen)
+{
+	struct tc_img_ctx *img_ctx;
+	int err;
+
+	BUG_ON(!codegen->img_ctx);
+
+	img_ctx = (struct tc_img_ctx *)codegen->img_ctx;
+	img_ctx->opts.flags = 0;
+	img_ctx->opts.prog_fd = 0;
+	img_ctx->opts.prog_id = 0;
+	err = bpf_tc_detach(&img_ctx->hook, &img_ctx->opts);
+	if (err)
+		BFLOG_EMERG(codegen->ctx, "cannot detach tc program: %s\n", strerror(-err));
+
+	err = bpf_tc_hook_destroy(&img_ctx->hook);
+	if (err)
+		BFLOG_EMERG(codegen->ctx, "cannot destroy tc hook: %s\n", strerror(-err));
+
+	BUG_ON(img_ctx->fd < 0);
+	close(img_ctx->fd);
+	free(img_ctx);
+
+	codegen->img_ctx = NULL;
+
+	unload_img(codegen);
+}
+
+static const struct codegen_ops tc_codegen_ops = {
+	.gen_inline_prologue = tc_gen_inline_prologue,
+	.load_packet_data = tc_load_packet_data,
+	.load_packet_data_end = tc_load_packet_data_end,
+	.emit_ret_code = tc_emit_ret_code,
+	.gen_inline_epilogue = tc_gen_inline_epilogue,
+	.load_img = tc_load_img,
+	.unload_img = tc_unload_img,
+};
+
+void create_shared_codegen(struct shared_codegen *shared_codegen)
+{
+	shared_codegen->maps_refcnt = 0;
+
+	shared_codegen->maps[CODEGEN_MAP_COUNTERS].map_type = BPF_MAP_TYPE_PERCPU_ARRAY;
+	shared_codegen->maps[CODEGEN_MAP_COUNTERS].key_size = 4;
+	shared_codegen->maps[CODEGEN_MAP_COUNTERS].value_size =
+		sizeof(struct bpfilter_ipt_counters);
+	shared_codegen->maps[CODEGEN_MAP_COUNTERS].max_entries = 0;
+	snprintf(shared_codegen->maps[CODEGEN_MAP_COUNTERS].map_name,
+		 sizeof(shared_codegen->maps[CODEGEN_MAP_COUNTERS].map_name), "bpfilter_cntrs");
+	shared_codegen->maps_fd[CODEGEN_MAP_COUNTERS] = -1;
+}
+
+int create_codegen(struct codegen *codegen, enum bpf_prog_type type)
+{
+	int err;
+
+	memset(codegen, 0, sizeof(*codegen));
+
+	if (type == BPF_PROG_TYPE_XDP)
+		codegen->codegen_ops = &xdp_codegen_ops;
+	else if (type == BPF_PROG_TYPE_SCHED_CLS)
+		codegen->codegen_ops = &tc_codegen_ops;
+	else
+		return -EINVAL;
+	codegen->prog_type = type;
+
+	codegen->log_buf_size = 1 << 20;
+	codegen->log_buf = malloc(codegen->log_buf_size);
+	if (!codegen->log_buf) {
+		err = -ENOMEM;
+		goto err_free;
+	}
+
+	codegen->len_max = BPF_MAXINSNS;
+	codegen->img = malloc(codegen->len_max * sizeof(codegen->img[0]));
+	if (!codegen->img) {
+		err = -ENOMEM;
+		goto err_free;
+	}
+
+	INIT_LIST_HEAD(&codegen->fixup);
+	INIT_LIST_HEAD(&codegen->relocs);
+	INIT_LIST_HEAD(&codegen->awaiting_subprogs);
+
+	return 0;
+
+err_free:
+	free(codegen->img);
+
+	return err;
+}
+
+int load_img(struct codegen *codegen)
+{
+	union bpf_attr attr = {};
+	int err, fd;
+
+	err = load_maps(codegen);
+	if (err)
+		return err;
+
+	err = codegen_reloc(codegen);
+	if (err)
+		return err;
+
+	attr.prog_type = codegen->prog_type;
+	attr.insns = bpf_ptr_to_u64(codegen->img);
+	attr.insn_cnt = codegen->len_cur;
+	attr.license = bpf_ptr_to_u64("GPL");
+	attr.prog_ifindex = 0;
+	snprintf(attr.prog_name, sizeof(attr.prog_name), "bpfilter");
+
+	if (codegen->log_buf && codegen->log_buf_size) {
+		attr.log_buf = bpf_ptr_to_u64(codegen->log_buf);
+		attr.log_size = codegen->log_buf_size;
+		attr.log_level = 1;
+	}
+
+	fd = sys_bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
+	if (fd == -1) {
+		BFLOG_DEBUG(codegen->ctx, "Cannot load BPF program: %s\n", codegen->log_buf);
+		return -errno;
+	}
+
+	return fd;
+}
+
+
+void unload_img(struct codegen *codegen)
+{
+	unload_maps(codegen);
+}
+
+void free_codegen(struct codegen *codegen)
+{
+	struct list_head *t, *n;
+	int i;
+
+	list_for_each_safe(t, n, &codegen->fixup) {
+		struct codegen_fixup_desc *fixup;
+
+		fixup = list_entry(t, struct codegen_fixup_desc, list);
+		free(fixup);
+	}
+
+	list_for_each_safe(t, n, &codegen->relocs) {
+		struct codegen_reloc_desc *reloc;
+
+		reloc = list_entry(t, struct codegen_reloc_desc, list);
+		free(reloc);
+	}
+
+	list_for_each_safe(t, n, &codegen->awaiting_subprogs) {
+		struct codegen_subprog_desc *subprog;
+
+		subprog = list_entry(t, struct codegen_subprog_desc, list);
+		free(subprog);
+	}
+
+	for (i = 0; i < codegen->subprogs_cur; ++i)
+		free(codegen->subprogs[i]);
+	free(codegen->subprogs);
+
+	free(codegen->log_buf);
+	free(codegen->img);
+}
diff --git a/net/bpfilter/codegen.h b/net/bpfilter/codegen.h
new file mode 100644
index 000000000000..7953f6938dcc
--- /dev/null
+++ b/net/bpfilter/codegen.h
@@ -0,0 +1,188 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#ifndef NET_BPFILTER_CODEGEN_H
+#define NET_BPFILTER_CODEGEN_H
+
+#include <linux/bpf.h>
+#include <linux/filter.h>
+#include <linux/ip.h>
+#include <linux/types.h>
+#include <linux/udp.h>
+
+#include <bpf/bpf_endian.h>
+
+#include <errno.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+
+struct context;
+struct table;
+struct rule;
+
+#define CODEGEN_REG_RETVAL BPF_REG_0
+#define CODEGEN_REG_SCRATCH1 BPF_REG_1
+#define CODEGEN_REG_SCRATCH2 BPF_REG_2
+#define CODEGEN_REG_SCRATCH3 BPF_REG_3
+#define CODEGEN_REG_SCRATCH4 BPF_REG_4
+#define CODEGEN_REG_SCRATCH5 BPF_REG_5
+#define CODEGEN_REG_DATA_END CODEGEN_REG_SCRATCH5
+#define CODEGEN_REG_L3 BPF_REG_6
+#define CODEGEN_REG_L4 BPF_REG_7
+#define CODEGEN_REG_RUNTIME_CTX BPF_REG_8
+#define CODEGEN_REG_CTX BPF_REG_9
+
+#define EMIT(codegen, x)                                                                           \
+	do {                                                                                       \
+		if (codegen->len_cur + 1 > codegen->len_max)                                       \
+			return -ENOMEM;                                                            \
+		codegen->img[codegen->len_cur++] = x;                                              \
+	} while (0)
+
+#define EMIT_FIXUP(codegen, fixup_type, x)                                                         \
+	do {                                                                                       \
+		const int __err = emit_fixup(codegen, fixup_type, x);                              \
+		if (__err)                                                                         \
+			return __err;                                                              \
+	} while (0)
+
+#define EMIT_ADD_COUNTER(codegen)                                                                  \
+	do {                                                                                       \
+		const int __err = emit_add_counter(codegen);                                       \
+		if (__err)                                                                         \
+			return __err;                                                              \
+	} while (0)
+
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#define EMIT_LITTLE_ENDIAN(codegen, x) EMIT(codegen, x)
+#else
+#define EMIT_LITTLE_ENDIAN(codegen, x)
+#endif
+
+#define EMIT_DEBUG(codegen, reg)                                                                   \
+	do {                                                                                       \
+		EMIT(codegen, BPF_ST_MEM(BPF_W, BPF_REG_10, STACK_SCRATCHPAD_OFFSET - 44,          \
+					 __bpf_constant_ntohl(0x6c750000)));                       \
+		EMIT(codegen, BPF_ST_MEM(BPF_W, BPF_REG_10, STACK_SCRATCHPAD_OFFSET - 48,          \
+					 __bpf_constant_ntohl(0x4720256c)));                       \
+		EMIT(codegen, BPF_ST_MEM(BPF_W, BPF_REG_10, STACK_SCRATCHPAD_OFFSET - 52,          \
+					 __bpf_constant_ntohl(0x42464442)));                       \
+		EMIT(codegen, BPF_MOV64_REG(BPF_REG_1, BPF_REG_10));                               \
+		EMIT(codegen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, STACK_SCRATCHPAD_OFFSET - 52));    \
+		EMIT(codegen, BPF_MOV32_IMM(BPF_REG_2, 12));                                       \
+		EMIT(codegen, BPF_MOV64_REG(BPF_REG_3, reg));                                      \
+		EMIT(codegen, BPF_EMIT_CALL(BPF_FUNC_trace_printk));                               \
+	} while (0)
+
+struct runtime_context {
+	uint32_t data_size;
+	void *l3;
+	void *l4;
+};
+
+#define STACK_RUNTIME_CONTEXT_OFFSET(field)                                                        \
+	(-(short)(offsetof(struct runtime_context, field) +                                        \
+		  sizeof(((struct runtime_context *)NULL)->field)))
+
+#define STACK_SCRATCHPAD_OFFSET (-(short)sizeof(struct runtime_context))
+
+enum codegen_map_type { CODEGEN_MAP_COUNTERS, __MAX_CODEGEN_MAP_TYPE };
+
+enum codegen_fixup_type {
+	CODEGEN_FIXUP_NEXT_RULE,
+	CODEGEN_FIXUP_END_OF_CHAIN,
+	CODEGEN_FIXUP_JUMP_TO_CHAIN,
+	CODEGEN_FIXUP_COUNTERS_INDEX,
+	__MAX_CODEGEN_FIXUP_TYPE
+};
+
+struct codegen_fixup_desc {
+	struct list_head list;
+	enum codegen_fixup_type type;
+	uint32_t insn;
+	union {
+		uint32_t offset;
+	};
+};
+
+enum codegen_reloc_type { CODEGEN_RELOC_MAP, __MAX_CODEGEN_RELOC_TYPE };
+
+struct codegen_reloc_desc {
+	struct list_head list;
+	enum codegen_reloc_type type;
+	uint32_t insn;
+	union {
+		struct {
+			enum codegen_map_type map;
+			// TODO: add BTF
+		};
+	};
+};
+
+enum codegen_subprog_type {
+	CODEGEN_SUBPROG_USER_CHAIN,
+};
+
+struct codegen_subprog_desc {
+	struct list_head list;
+	enum codegen_subprog_type type;
+	uint32_t insn;
+	union {
+		uint32_t offset;
+	};
+};
+
+struct codegen_ops;
+struct shared_codegen;
+
+struct codegen {
+	struct context *ctx;
+	struct bpf_insn *img;
+	char *log_buf;
+	size_t log_buf_size;
+	enum bpf_prog_type prog_type;
+	uint32_t len_cur;
+	uint32_t len_max;
+	uint32_t rule_index;
+	const struct codegen_ops *codegen_ops;
+	struct shared_codegen *shared_codegen;
+	struct list_head fixup;
+	struct list_head relocs;
+	struct list_head awaiting_subprogs;
+	uint16_t subprogs_cur;
+	uint16_t subprogs_max;
+	struct codegen_subprog_desc **subprogs;
+	void *img_ctx;
+};
+
+struct shared_codegen {
+	int maps_refcnt;
+	union bpf_attr maps[__MAX_CODEGEN_MAP_TYPE];
+	int maps_fd[__MAX_CODEGEN_MAP_TYPE];
+};
+
+struct codegen_ops {
+	int (*gen_inline_prologue)(struct codegen *codegen);
+	int (*load_packet_data)(struct codegen *codegen, int dst_reg);
+	int (*load_packet_data_end)(struct codegen *codegen, int dst_reg);
+	int (*emit_ret_code)(struct codegen *codegen, int ret_code);
+	int (*gen_inline_epilogue)(struct codegen *codegen);
+	int (*load_img)(struct codegen *codegen);
+	void (*unload_img)(struct codegen *codegen);
+};
+
+void create_shared_codegen(struct shared_codegen *shared_codegen);
+int create_codegen(struct codegen *codegen, enum bpf_prog_type type);
+int codegen_push_awaiting_subprog(struct codegen *codegen, struct codegen_subprog_desc *subprog);
+int codegen_fixup(struct codegen *codegen, enum codegen_fixup_type fixup_type);
+int emit_fixup(struct codegen *codegen, enum codegen_fixup_type fixup_type, struct bpf_insn insn);
+int emit_add_counter(struct codegen *codegen);
+int load_img(struct codegen *codegen);
+void unload_img(struct codegen *codegen);
+void free_codegen(struct codegen *codegen);
+
+#endif // NET_BPFILTER_CODEGEN_H
diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
index 983fd06cbefa..39ec0c09dff4 100644
--- a/tools/testing/selftests/bpf/bpfilter/.gitignore
+++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
+tools/**
 test_map
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index c262aad8c2a4..48dc696e0f09 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -4,9 +4,11 @@ top_srcdir = ../../../../..
 TOOLSDIR := $(abspath ../../../../)
 TOOLSINCDIR := $(TOOLSDIR)/include
 APIDIR := $(TOOLSINCDIR)/uapi
+LIBDIR := $(TOOLSDIR)/lib
+BPFDIR := $(LIBDIR)/bpf
 BPFILTERSRCDIR := $(top_srcdir)/net/bpfilter
 
-CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR)
+CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR) -I$(LIBDIR)
 
 TEST_GEN_PROGS += test_map
 
@@ -14,6 +16,24 @@ KSFT_KHDR_INSTALL := 1
 
 include ../../lib.mk
 
+SCRATCH_DIR := $(OUTPUT)/tools
+BUILD_DIR := $(SCRATCH_DIR)/build
+BPFOBJ_DIR := $(BUILD_DIR)/libbpf
+BPFOBJ := $(BPFOBJ_DIR)/libbpf.a
+
+MAKE_DIRS := $(BPFOBJ_DIR)
+
+$(MAKE_DIRS):
+	$(call msg,MKDIR,,$@)
+	$(Q)mkdir -p $@
+
+$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       		\
+	   ../../../../include/uapi/linux/bpf.h                                 \
+	   | $(INCLUDE_DIR) $(BUILD_DIR)/libbpf
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ 	\
+		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
+
 BPFILTER_MAP_SRCS := $(BPFILTERSRCDIR)/map-common.c
+BPFILTER_CODEGEN_SRCS := $(BPFILTERSRCDIR)/codegen.c $(BPFOBJ) -lelf -lz
 
 $(OUTPUT)/test_map: test_map.c $(BPFILTER_MAP_SRCS)
-- 
2.25.1


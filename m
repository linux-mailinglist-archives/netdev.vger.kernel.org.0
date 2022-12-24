Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196C165566A
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 01:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbiLXAEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 19:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbiLXAEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 19:04:40 -0500
X-Greylist: delayed 443 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 23 Dec 2022 16:04:36 PST
Received: from 9.mo545.mail-out.ovh.net (9.mo545.mail-out.ovh.net [46.105.79.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF41617E13
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 16:04:35 -0800 (PST)
Received: from ex4.mail.ovh.net (unknown [10.111.172.143])
        by mo545.mail-out.ovh.net (Postfix) with ESMTPS id 3E70125F95;
        Sat, 24 Dec 2022 00:04:33 +0000 (UTC)
Received: from dev-fedora-x86-64.naccy.de (37.65.8.229) by
 DAG10EX1.indiv4.local (172.16.2.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 01:04:31 +0100
From:   Quentin Deslandes <qde@naccy.de>
To:     <qde@naccy.de>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Dmitrii Banshchikov <me@ubique.spb.ru>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@meta.com>
Subject: [PATCH bpf-next v3 06/16] bpfilter: add BPF bytecode generation infrastructure
Date:   Sat, 24 Dec 2022 01:03:52 +0100
Message-ID: <20221224000402.476079-7-qde@naccy.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221224000402.476079-1-qde@naccy.de>
References: <20221224000402.476079-1-qde@naccy.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.65.8.229]
X-ClientProxiedBy: CAS6.indiv4.local (172.16.1.6) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 4760586281833131639
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrheefgddujecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmdenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpefsuhgvnhhtihhnucffvghslhgrnhguvghsuceoqhguvgesnhgrtggthidruggvqeenucggtffrrghtthgvrhhnpeduledugfeileetvdelieeujedttedtvedtgfetteevfeejhfffkeeujeetfffgudenucfkphepuddvjedrtddrtddruddpfeejrdeihedrkedrvddvleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehquggvsehnrggttgihrdguvgeqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepjhholhhsrgeskhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkshgvlhhfthgvshhtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpmhgvsehusghiqhhuvgdrshhpsgdrrhhupdhshhhurghhsehkvghrnhgvlhdrohhrghdpmhihkhholhgrlhesfhgsrdgtohhmpdhprggsvghnihesrhgvughhrghtrdgtohhmpdhkuhgsrg
 eskhgvrhhnvghlrdhorhhgpdgvughumhgriigvthesghhoohhglhgvrdgtohhmpdgurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhkvghrnhgvlhdqthgvrghmsehmvghtrgdrtghomhdphhgrohhluhhosehgohhoghhlvgdrtghomhdpshgufhesghhoohhglhgvrdgtohhmpdhkphhsihhnghhhsehkvghrnhgvlhdrohhrghdpjhhohhhnrdhfrghsthgrsggvnhgusehgmhgrihhlrdgtohhmpdihhhhssehfsgdrtghomhdpshhonhhgsehkvghrnhgvlhdrohhrghdpmhgrrhhtihhnrdhlrghusehlihhnuhigrdguvghvpdgrnhgurhhiiheskhgvrhhnvghlrdhorhhgpdgurghnihgvlhesihhoghgvrghrsghogidrnhgvthdprghstheskhgvrhhnvghlrdhorhhgpdhnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheeghedpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare codegen infrastructure to be used by matches, targets, rules,
and tables.

struct codegen contains an array of struct bpf_insn representing the
generated BPF program.

The current infrastructure allows for multiple BPF program flavours to
be supported (TC, XDP...). Most of the logic will be shared, but each
flavour will be able to define its own prologue and epilogue bytecode,
as well as packet data access. Loading and unloading flow is also
flavour-dependent.

Not all required information is known during generation. This commit
introduces two bpfilter concepts to resolve this issue:
- Fixup: placeholder to replace once code generation is complete. For
example, fixup is used to jump to the next rule. The next rule's
offset is only known once it has been generated.
- Relocation: placeholder to replace before loading the BPF program. BPF
maps are an example of features using relocation. Maps are created
before the programs are loaded, so their FD is only known at that
point in time.

Subprogs are required to support user-defined chains and helper
subprograms. All already generated subprogs are stored in subprogs
array. This sorted array acts as an index. All subprogs awaiting
the generation phase are stored in awaiting_subprogs list.

struct shared_codegen is used to share data between various BPF programs
created by BPF filter. The only currently supported shared data is the
map containing the counters for each rule defined: a unique map shared
between all the programs stores the counters for all the bpfilter
programs.

Besides that, there is a runtime_context struct that might be used to
store frequently required data such as the size of the packet and pointer to
L3/L4 headers. This context is stored on the stack and there are macros
to access individual fields of this struct.  Immediately after
runtime_context on stack, there is a scratchpad area.

The calling convention follows the BPF calling convention with a couple
of additions:
* CODEGEN_REG_CTX(BPF_REG_9) is a pointer to the program context
* CODEGEN_REG_RUNTIME_CTX(BPF_REG_8) is a pointer to the runtime context

Co-developed-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Quentin Deslandes <qde@naccy.de>
---
 net/bpfilter/Makefile                         |  12 +-
 net/bpfilter/codegen.c                        | 530 ++++++++++++++++++
 net/bpfilter/codegen.h                        | 181 ++++++
 .../testing/selftests/bpf/bpfilter/.gitignore |   1 +
 tools/testing/selftests/bpf/bpfilter/Makefile |  19 +
 5 files changed, 742 insertions(+), 1 deletion(-)
 create mode 100644 net/bpfilter/codegen.c
 create mode 100644 net/bpfilter/codegen.h

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 9878f5fd8152..ac039f1fac34 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -3,11 +3,21 @@
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
 bpfilter_umh-objs := main.o logger.o map-common.o
-bpfilter_umh-objs += context.o
+bpfilter_umh-objs += context.o codegen.o
+bpfilter_umh-userldlibs := $(LIBBPF_A) -lelf -lz
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
+$(obj)/bpfilter_umh: $(LIBBPF_A)
+
 ifeq ($(CONFIG_BPFILTER_UMH), y)
 # builtin bpfilter_umh should be linked with -static
 # since rootfs isn't mounted at the time of __init
diff --git a/net/bpfilter/codegen.c b/net/bpfilter/codegen.c
new file mode 100644
index 000000000000..545bc7aeb77c
--- /dev/null
+++ b/net/bpfilter/codegen.c
@@ -0,0 +1,530 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
+ */
+
+#include "codegen.h"
+
+#include "../../include/uapi/linux/bpfilter.h"
+
+#include <unistd.h>
+#include <sys/syscall.h>
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "logger.h"
+
+enum fixup_insn_type {
+	FIXUP_INSN_OFF,
+	FIXUP_INSN_IMM,
+	__MAX_FIXUP_INSN_TYPE
+};
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
+static const struct codegen_subprog_desc *codegen_find_subprog(struct codegen *codegen,
+							       const struct codegen_subprog_desc **subprog)
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
+	const struct codegen_subprog_desc subprog = {
+		.type = CODEGEN_SUBPROG_USER_CHAIN,
+		.offset = offset
+	};
+	const struct codegen_subprog_desc *subprog_ptr = &subprog;
+
+	return codegen_find_subprog(codegen, &subprog_ptr);
+}
+
+int codegen_push_awaiting_subprog(struct codegen *codegen,
+				  struct codegen_subprog_desc *subprog)
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
+static int codegen_fixup_insn(struct bpf_insn *insn, enum fixup_insn_type type,
+			      __s32 v)
+{
+	switch (type) {
+	case FIXUP_INSN_OFF:
+		if (insn->off) {
+			BFLOG_ERR("missing instruction offset");
+			return -EINVAL;
+		}
+
+		insn->off = v;
+
+		return 0;
+	case FIXUP_INSN_IMM:
+		if (insn->imm) {
+			BFLOG_ERR("missing instruction immediate value");
+			return -EINVAL;
+		}
+
+		insn->imm = v;
+
+		return 0;
+	default:
+		BFLOG_ERR("invalid fixup instruction type");
+		return -EINVAL;
+	}
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
+		__s32 v;
+		int r;
+
+		fixup = list_entry(t, struct codegen_fixup_desc, list);
+		if (fixup->type != fixup_type)
+			continue;
+
+		if (fixup->type >= __MAX_CODEGEN_FIXUP_TYPE) {
+			BFLOG_ERR("invalid instruction fixup type: %d",
+				  fixup->type);
+			return -EINVAL;
+		}
+
+		if (fixup->insn > codegen->len_cur) {
+			BFLOG_ERR("invalid instruction fixup offset");
+			return -EINVAL;
+		}
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
+			subprog = codegen_find_user_chain_subprog(codegen,
+								  fixup->offset);
+			if (!subprog) {
+				BFLOG_ERR("subprogram not found for offset %d",
+					  fixup->offset);
+				return -EINVAL;
+			}
+
+			type = FIXUP_INSN_OFF;
+			v = subprog->insn - fixup->insn - 1;
+		}
+
+		if (fixup_type == CODEGEN_FIXUP_COUNTERS_INDEX) {
+			type = FIXUP_INSN_IMM;
+			BFLOG_DBG("fixup counter for rule %d", codegen->rule_index);
+			v = codegen->rule_index;
+		}
+
+		r = codegen_fixup_insn(insn, type, v);
+		if (r) {
+			BFLOG_ERR("failed to fixup codegen instruction: %s",
+				  STRERR(r));
+			return r;
+		}
+
+		list_del(t);
+		free(fixup);
+	}
+
+	return 0;
+}
+
+int emit_fixup(struct codegen *codegen, enum codegen_fixup_type fixup_type,
+	       struct bpf_insn insn)
+{
+	struct codegen_fixup_desc *fixup;
+
+	fixup = malloc(sizeof(*fixup));
+	if (!fixup) {
+		BFLOG_ERR("out of memory");
+		return -ENOMEM;
+	}
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
+	if (!reloc) {
+		BFLOG_ERR("out of memory");
+		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&reloc->list);
+	reloc->type = CODEGEN_RELOC_MAP;
+	reloc->map = CODEGEN_MAP_COUNTERS;
+	reloc->insn = codegen->len_cur;
+	list_add_tail(&reloc->list, &codegen->relocs);
+
+	EMIT(codegen, insns[0]);
+	EMIT(codegen, insns[1]);
+
+	EMIT_FIXUP(codegen, CODEGEN_FIXUP_COUNTERS_INDEX,
+		   BPF_ST_MEM(BPF_W, BPF_REG_10, STACK_SCRATCHPAD_OFFSET - 4, 0));
+	EMIT(codegen, BPF_MOV64_REG(BPF_REG_ARG2, BPF_REG_10));
+	EMIT(codegen,
+	     BPF_ALU64_IMM(BPF_ADD, BPF_REG_ARG2, STACK_SCRATCHPAD_OFFSET - 4));
+	EMIT(codegen, BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem));
+	EMIT(codegen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 14));
+
+	reloc = malloc(sizeof(*reloc));
+	if (!reloc) {
+		BFLOG_ERR("out of memory");
+		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&reloc->list);
+	reloc->type = CODEGEN_RELOC_MAP;
+	reloc->map = CODEGEN_MAP_COUNTERS;
+	reloc->insn = codegen->len_cur;
+	list_add_tail(&reloc->list, &codegen->relocs);
+
+	EMIT(codegen, insns[0]);
+	EMIT(codegen, insns[1]);
+
+	EMIT(codegen, BPF_LDX_MEM(BPF_DW, CODEGEN_REG_SCRATCH5, BPF_REG_0, 0));
+	EMIT(codegen, BPF_LDX_MEM(BPF_DW, CODEGEN_REG_SCRATCH4, BPF_REG_0, 8));
+	EMIT(codegen, BPF_LDX_MEM(BPF_W, CODEGEN_REG_SCRATCH3, CODEGEN_REG_RUNTIME_CTX,
+				  STACK_RUNTIME_CONTEXT_OFFSET(data_size)));
+	EMIT(codegen, BPF_ALU64_IMM(BPF_ADD, CODEGEN_REG_SCRATCH5, 1));
+	EMIT(codegen,
+	     BPF_ALU64_REG(BPF_ADD, CODEGEN_REG_SCRATCH4, CODEGEN_REG_SCRATCH3));
+	EMIT(codegen, BPF_STX_MEM(BPF_DW, BPF_REG_0, CODEGEN_REG_SCRATCH5, 0));
+	EMIT(codegen, BPF_STX_MEM(BPF_DW, BPF_REG_0, CODEGEN_REG_SCRATCH4, 8));
+	EMIT(codegen, BPF_MOV64_REG(BPF_REG_ARG2, BPF_REG_10));
+	EMIT(codegen,
+	     BPF_ALU64_IMM(BPF_ADD, BPF_REG_ARG2, STACK_SCRATCHPAD_OFFSET - 4));
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
+		if (reloc->insn >= codegen->len_cur) {
+			BFLOG_ERR("invalid instruction relocation offset");
+			return -EINVAL;
+		}
+
+		insn = &codegen->img[reloc->insn];
+
+		if (reloc->type == CODEGEN_RELOC_MAP) {
+			enum codegen_map_type map_type;
+
+			if (codegen->len_cur <= reloc->insn + 1) {
+				BFLOG_ERR("invalid instruction relocation map offset");
+				return -EINVAL;
+			}
+
+			if (insn->code != (BPF_LD | BPF_DW | BPF_IMM)) {
+				BFLOG_ERR("invalid instruction relocation code %d",
+					  insn->code);
+				return -EINVAL;
+			}
+
+			map_type = insn->imm;
+			if (map_type < 0 || map_type >= __MAX_CODEGEN_MAP_TYPE) {
+				BFLOG_ERR("invalid instruction relocation map type: %d",
+					  map_type);
+				return -EINVAL;
+			}
+
+			BUG_ON(shared_codegen->maps_fd[map_type] < 0);
+			insn->imm = shared_codegen->maps_fd[map_type];
+
+			continue;
+		}
+
+		BFLOG_ERR("invalid instruction relocation type %d", reloc->type);
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
+		int j;
+		int fd;
+		int saved_errno;
+		union bpf_attr *map;
+
+		BUG_ON(shared_codegen->maps_fd[i] > -1);
+
+		map = &shared_codegen->maps[i];
+		fd = sys_bpf(BPF_MAP_CREATE, map, sizeof(*map));
+		if (fd > -1) {
+			BFLOG_DBG("opened BPF map with FD %d", fd);
+			shared_codegen->maps_fd[i] = fd;
+			continue;
+		}
+
+		BFLOG_ERR("bpf syscall failed during map creation: %s",
+			  STRERR(fd));
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
+void create_shared_codegen(struct shared_codegen *shared_codegen)
+{
+	shared_codegen->maps_refcnt = 0;
+
+	shared_codegen->maps[CODEGEN_MAP_COUNTERS].map_type =
+		BPF_MAP_TYPE_PERCPU_ARRAY;
+	shared_codegen->maps[CODEGEN_MAP_COUNTERS].key_size = 4;
+	shared_codegen->maps[CODEGEN_MAP_COUNTERS].value_size =
+		sizeof(struct bpfilter_ipt_counters);
+	shared_codegen->maps[CODEGEN_MAP_COUNTERS].max_entries = 0;
+	snprintf(shared_codegen->maps[CODEGEN_MAP_COUNTERS].map_name,
+		 sizeof(shared_codegen->maps[CODEGEN_MAP_COUNTERS].map_name),
+			"bpfilter_cntrs");
+	shared_codegen->maps_fd[CODEGEN_MAP_COUNTERS] = -1;
+}
+
+int create_codegen(struct codegen *codegen, enum bpf_prog_type type)
+{
+	int r;
+
+	memset(codegen, 0, sizeof(*codegen));
+
+	switch (type) {
+	default:
+		BFLOG_ERR("unsupported BPF program type %d", type);
+		return -EINVAL;
+	}
+
+	codegen->prog_type = type;
+
+	codegen->log_buf_size = 1 << 20;
+	codegen->log_buf = malloc(codegen->log_buf_size);
+	if (!codegen->log_buf) {
+		BFLOG_ERR("out of memory");
+		r = -ENOMEM;
+		goto err_free;
+	}
+
+	codegen->len_max = BPF_MAXINSNS;
+	codegen->img = malloc(codegen->len_max * sizeof(codegen->img[0]));
+	if (!codegen->img) {
+		BFLOG_ERR("out of memory");
+		r = -ENOMEM;
+		goto err_free;
+	}
+
+	codegen->shared_codegen = NULL;
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
+	return r;
+}
+
+int load_img(struct codegen *codegen)
+{
+	union bpf_attr attr = {};
+	int fd;
+	int r;
+
+	r = load_maps(codegen);
+	if (r) {
+		BFLOG_ERR("failed to load maps: %s", STRERR(r));
+		return r;
+	}
+
+	r = codegen_reloc(codegen);
+	if (r) {
+		BFLOG_ERR("failed to generate relocations: %s", STRERR(r));
+		return r;
+	}
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
+		BFLOG_ERR("failed to load BPF program: %s", codegen->log_buf);
+		return -errno;
+	}
+
+	return fd;
+}
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
index 000000000000..cca45a13c4aa
--- /dev/null
+++ b/net/bpfilter/codegen.h
@@ -0,0 +1,181 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
+ */
+
+#ifndef NET_BPFILTER_CODEGEN_H
+#define NET_BPFILTER_CODEGEN_H
+
+#include <linux/bpf.h>
+#include <linux/filter.h>
+#include <linux/list.h>
+
+#include <bpf/libbpf.h>
+
+#include <errno.h>
+#include <stddef.h>
+#include <stdint.h>
+
+struct context;
+
+#define CODEGEN_REG_RETVAL	BPF_REG_0
+#define CODEGEN_REG_SCRATCH1	BPF_REG_1
+#define CODEGEN_REG_SCRATCH2	BPF_REG_2
+#define CODEGEN_REG_SCRATCH3	BPF_REG_3
+#define CODEGEN_REG_SCRATCH4	BPF_REG_4
+#define CODEGEN_REG_SCRATCH5	BPF_REG_5
+#define CODEGEN_REG_DATA_END	CODEGEN_REG_SCRATCH5
+#define CODEGEN_REG_L3		BPF_REG_6
+#define CODEGEN_REG_L4		BPF_REG_7
+#define CODEGEN_REG_RUNTIME_CTX BPF_REG_8
+#define CODEGEN_REG_CTX		BPF_REG_9
+
+#define EMIT(codegen, x)					     \
+	do {							     \
+		typeof(codegen) __codegen = codegen;		     \
+		if ((__codegen)->len_cur + 1 > (__codegen)->len_max) \
+			return -ENOMEM;				     \
+		(__codegen)->img[codegen->len_cur++] = (x);	     \
+	} while (0)
+
+#define EMIT_FIXUP(codegen, fixup_type, insn)				       \
+	do {								       \
+		const int __err = emit_fixup((codegen), (fixup_type), (insn)); \
+		if (__err)						       \
+			return __err;					       \
+	} while (0)
+
+#define EMIT_ADD_COUNTER(codegen)			     \
+	do {						     \
+		const int __err = emit_add_counter(codegen); \
+		if (__err)				     \
+			return __err;			     \
+	} while (0)
+
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#define EMIT_LITTLE_ENDIAN(codegen, x) EMIT(codegen, x)
+#else
+#define EMIT_LITTLE_ENDIAN(codegen, x)
+#endif
+
+struct runtime_context {
+	uint32_t data_size;
+	void *l3;
+	void *l4;
+};
+
+#define STACK_RUNTIME_CONTEXT_OFFSET(field)		    \
+	(-(short)(offsetof(struct runtime_context, field) + \
+		  sizeof(((struct runtime_context *)NULL)->field)))
+
+#define STACK_SCRATCHPAD_OFFSET (-(short)sizeof(struct runtime_context))
+
+enum codegen_map_type {
+	CODEGEN_MAP_COUNTERS,
+	__MAX_CODEGEN_MAP_TYPE
+};
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
+enum codegen_reloc_type {
+	CODEGEN_RELOC_MAP,
+	__MAX_CODEGEN_RELOC_TYPE
+};
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
+	int iptables_hook;
+	union {
+		enum bpf_tc_attach_point bpf_tc_hook;
+	};
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
+int codegen_push_awaiting_subprog(struct codegen *codegen,
+				  struct codegen_subprog_desc *subprog);
+int codegen_fixup(struct codegen *codegen, enum codegen_fixup_type fixup_type);
+int emit_fixup(struct codegen *codegen, enum codegen_fixup_type fixup_type,
+	       struct bpf_insn insn);
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
index c262aad8c2a4..e3b8bf76a10c 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -5,6 +5,8 @@ TOOLSDIR := $(abspath ../../../../)
 TOOLSINCDIR := $(TOOLSDIR)/include
 APIDIR := $(TOOLSINCDIR)/uapi
 BPFILTERSRCDIR := $(top_srcdir)/net/bpfilter
+LIBDIR := $(TOOLSDIR)/lib
+BPFDIR := $(LIBDIR)/bpf
 
 CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR)
 
@@ -14,6 +16,23 @@ KSFT_KHDR_INSTALL := 1
 
 include ../../lib.mk
 
+SCRATCH_DIR := $(OUTPUT)/tools
+BUILD_DIR := $(SCRATCH_DIR)/build
+BPFOBJ_DIR := $(BUILD_DIR)/libbpf
+BPFOBJ := $(BPFOBJ_DIR)/libbpf.a
+
+MAKE_DIRS := $(BPFOBJ_DIR)
+$(MAKE_DIRS):
+	$(call msg,MKDIR,,$@)
+	$(Q)mkdir -p $@
+
+$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)			\
+	   ../../../../include/uapi/linux/bpf.h					\
+	   | $(INCLUDE_DIR) $(BUILD_DIR)/libbpf
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ 	\
+		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
+
 BPFILTER_MAP_SRCS := $(BPFILTERSRCDIR)/map-common.c
+BPFILTER_CODEGEN_SRCS := $(BPFILTERSRCDIR)/codegen.c $(BPFOBJ) -lelf -lz
 
 $(OUTPUT)/test_map: test_map.c $(BPFILTER_MAP_SRCS)
-- 
2.38.1


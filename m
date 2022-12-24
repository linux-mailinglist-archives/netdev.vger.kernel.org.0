Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4890D655677
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 01:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236516AbiLXAGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 19:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbiLXAFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 19:05:20 -0500
Received: from smtpout5.r2.mail-out.ovh.net (smtpout5.r2.mail-out.ovh.net [54.36.141.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795C91A39A
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 16:04:41 -0800 (PST)
Received: from ex4.mail.ovh.net (unknown [10.110.103.144])
        by mo511.mail-out.ovh.net (Postfix) with ESMTPS id 8D54226732;
        Sat, 24 Dec 2022 00:04:39 +0000 (UTC)
Received: from dev-fedora-x86-64.naccy.de (37.65.8.229) by
 DAG10EX1.indiv4.local (172.16.2.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 01:04:38 +0100
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
Subject: [PATCH bpf-next v3 11/16] bpfilter: add rule structure
Date:   Sat, 24 Dec 2022 01:03:57 +0100
Message-ID: <20221224000402.476079-12-qde@naccy.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221224000402.476079-1-qde@naccy.de>
References: <20221224000402.476079-1-qde@naccy.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.65.8.229]
X-ClientProxiedBy: CAS6.indiv4.local (172.16.1.6) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 4762556610060873335
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrheefgddujecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmdenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpefsuhgvnhhtihhnucffvghslhgrnhguvghsuceoqhguvgesnhgrtggthidruggvqeenucggtffrrghtthgvrhhnpeduledugfeileetvdelieeujedttedtvedtgfetteevfeejhfffkeeujeetfffgudenucfkphepuddvjedrtddrtddruddpfeejrdeihedrkedrvddvleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehquggvsehnrggttgihrdguvgeqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepjhholhhsrgeskhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkshgvlhhfthgvshhtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpmhgvsehusghiqhhuvgdrshhpsgdrrhhupdhshhhurghhsehkvghrnhgvlhdrohhrghdpmhihkhholhgrlhesfhgsrdgtohhmpdhprggsvghnihesrhgvughhrghtrdgtohhmpdhkuhgsrg
 eskhgvrhhnvghlrdhorhhgpdgvughumhgriigvthesghhoohhglhgvrdgtohhmpdgurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhkvghrnhgvlhdqthgvrghmsehmvghtrgdrtghomhdphhgrohhluhhosehgohhoghhlvgdrtghomhdpshgufhesghhoohhglhgvrdgtohhmpdhkphhsihhnghhhsehkvghrnhgvlhdrohhrghdpjhhohhhnrdhfrghsthgrsggvnhgusehgmhgrihhlrdgtohhmpdihhhhssehfsgdrtghomhdpshhonhhgsehkvghrnhgvlhdrohhrghdpmhgrrhhtihhnrdhlrghusehlihhnuhigrdguvghvpdgrnhgurhhiiheskhgvrhhnvghlrdhorhhgpdgurghnihgvlhesihhoghgvrghrsghogidrnhgvthdprghstheskhgvrhhnvghlrdhorhhgpdhnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheduuddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rule structure is an equivalent to ipt_entry structure. A rule
consists of zero or more matches and a target. A rule has a pointer to
its ipt_entry structure in entries blob. This structure is defined to
ease iteration over the various rules of a given chain. The original
ipt_entry blob is kept to simplify interaction with iptables binary.

Inline bytecode generation is performed by gen_inline_rule(), and
consists of the following steps:
1. Emit instructions for rule's L3 src/dst addresses and protocol.
2. Emit instructions for each rule's match by calling match's interface.
3. Emit instructions for rule's target by calling target's interface.

Co-developed-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Quentin Deslandes <qde@naccy.de>
---
 net/bpfilter/Makefile                         |   2 +-
 net/bpfilter/rule.c                           | 286 ++++++++++++++++++
 net/bpfilter/rule.h                           |  37 +++
 .../testing/selftests/bpf/bpfilter/.gitignore |   1 +
 tools/testing/selftests/bpf/bpfilter/Makefile |   4 +
 .../selftests/bpf/bpfilter/bpfilter_util.h    |   8 +
 .../selftests/bpf/bpfilter/test_rule.c        |  56 ++++
 7 files changed, 393 insertions(+), 1 deletion(-)
 create mode 100644 net/bpfilter/rule.c
 create mode 100644 net/bpfilter/rule.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_rule.c

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 7e642e0ae932..759fb6c847d1 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -13,7 +13,7 @@ $(LIBBPF_A):
 userprogs := bpfilter_umh
 bpfilter_umh-objs := main.o logger.o map-common.o
 bpfilter_umh-objs += context.o codegen.o
-bpfilter_umh-objs += match.o xt_udp.o target.o
+bpfilter_umh-objs += match.o xt_udp.o target.o rule.o
 bpfilter_umh-userldlibs := $(LIBBPF_A) -lelf -lz
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
diff --git a/net/bpfilter/rule.c b/net/bpfilter/rule.c
new file mode 100644
index 000000000000..0f5217f6ab16
--- /dev/null
+++ b/net/bpfilter/rule.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
+ */
+
+#define _GNU_SOURCE
+
+#include "rule.h"
+
+#include "../../include/uapi/linux/bpfilter.h"
+
+#include <linux/filter.h>
+#include <linux/ip.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+#include <errno.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "codegen.h"
+#include "context.h"
+#include "logger.h"
+#include "match.h"
+
+static const struct bpfilter_ipt_target *ipt_entry_target(const struct bpfilter_ipt_entry *ipt_entry)
+{
+	return (const void *)ipt_entry + ipt_entry->target_offset;
+}
+
+static const struct bpfilter_ipt_match *ipt_entry_match(const struct bpfilter_ipt_entry *entry,
+							size_t offset)
+{
+	return (const void *)entry + offset;
+}
+
+static int ipt_entry_num_matches(const struct bpfilter_ipt_entry *ipt_entry)
+{
+	const struct bpfilter_ipt_match *ipt_match;
+	uint32_t offset = sizeof(*ipt_entry);
+	int num_matches = 0;
+
+	while (offset < ipt_entry->target_offset) {
+		ipt_match = ipt_entry_match(ipt_entry, offset);
+
+		if ((uintptr_t)ipt_match % __alignof__(struct bpfilter_ipt_match)) {
+			BFLOG_ERR("match must be aligned on struct bpfilter_ipt_match size");
+			return -EINVAL;
+		}
+
+		if (ipt_entry->target_offset < offset + sizeof(*ipt_match)) {
+			BFLOG_ERR("invalid target offset for struct ipt_entry");
+			return -EINVAL;
+		}
+
+		if (ipt_match->u.match_size < sizeof(*ipt_match)) {
+			BFLOG_ERR("invalid match size for struct ipt_match");
+			return -EINVAL;
+		}
+
+		if (ipt_entry->target_offset < offset + ipt_match->u.match_size) {
+			BFLOG_ERR("invalid target offset for struct ipt_entry");
+			return -EINVAL;
+		}
+
+		++num_matches;
+		offset += ipt_match->u.match_size;
+	}
+
+	if (offset != ipt_entry->target_offset) {
+		BFLOG_ERR("invalid offset");
+		return -EINVAL;
+	}
+
+	return num_matches;
+}
+
+static int init_rule_matches(struct context *ctx,
+			     const struct bpfilter_ipt_entry *ipt_entry,
+			     struct rule *rule)
+{
+	const struct bpfilter_ipt_match *ipt_match;
+	uint32_t offset = sizeof(*ipt_entry);
+	struct match *match;
+	int r;
+
+	rule->matches = calloc(rule->num_matches, sizeof(rule->matches[0]));
+	if (!rule->matches) {
+		BFLOG_ERR("out of memory");
+		return -ENOMEM;
+	}
+
+	match = rule->matches;
+	while (offset < ipt_entry->target_offset) {
+		ipt_match = ipt_entry_match(ipt_entry, offset);
+		r = init_match(ctx, ipt_match, match);
+		if (r) {
+			free(rule->matches);
+			rule->matches = NULL;
+			BFLOG_ERR("failed to initialize match: %s", STRERR(r));
+			return r;
+		}
+
+		++match;
+		offset += ipt_match->u.match_size;
+	}
+
+	return 0;
+}
+
+static int check_ipt_entry_ip(const struct bpfilter_ipt_ip *ip)
+{
+	if (ip->flags & ~BPFILTER_IPT_F_MASK) {
+		BFLOG_ERR("invalid flags: %d", ip->flags);
+		return -EINVAL;
+	}
+
+	if (ip->invflags & ~BPFILTER_IPT_INV_MASK) {
+		BFLOG_ERR("invalid inverse flags: %d", ip->invflags);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+bool rule_has_standard_target(const struct rule *rule)
+{
+	return rule->target.target_ops == &standard_target_ops;
+}
+
+bool rule_is_unconditional(const struct rule *rule)
+{
+	static const struct bpfilter_ipt_ip unconditional;
+
+	if (rule->num_matches)
+		return false;
+
+	return !memcmp(&rule->ipt_entry->ip, &unconditional,
+		       sizeof(unconditional));
+}
+
+int init_rule(struct context *ctx, const struct bpfilter_ipt_entry *ipt_entry,
+	      struct rule *rule)
+{
+	const struct bpfilter_ipt_target *ipt_target;
+	int r;
+
+	r = check_ipt_entry_ip(&ipt_entry->ip);
+	if (r) {
+		BFLOG_ERR("failed to check IPT entry IP: %s", STRERR(r));
+		return r;
+	}
+
+	if (ipt_entry->target_offset < sizeof(*ipt_entry)) {
+		BFLOG_ERR("invalid struct ipt_entry target offset: %d",
+			  ipt_entry->target_offset);
+		return -EINVAL;
+	}
+
+	if (ipt_entry->next_offset <
+	    ipt_entry->target_offset + sizeof(*ipt_target)) {
+		BFLOG_ERR("invalid struct ipt_entry next offset: %d",
+			  ipt_entry->next_offset);
+		return -EINVAL;
+	}
+
+	ipt_target = ipt_entry_target(ipt_entry);
+
+	if (ipt_target->u.target_size < sizeof(*ipt_target)) {
+		BFLOG_ERR("invalid struct ipt_target target size: %d",
+			  ipt_target->u.target_size);
+		return -EINVAL;
+	}
+
+	if (ipt_entry->next_offset <
+	    ipt_entry->target_offset + ipt_target->u.target_size) {
+		BFLOG_ERR("invalid struct ipt_entry next offset: %d",
+			  ipt_entry->next_offset);
+		return -EINVAL;
+	}
+
+	rule->ipt_entry = ipt_entry;
+
+	r = init_target(ctx, ipt_target, &rule->target);
+	if (r) {
+		BFLOG_ERR("failed to initialise target: %s", STRERR(r));
+		return r;
+	}
+
+	if (rule_has_standard_target(rule)) {
+		if (XT_ALIGN(ipt_entry->target_offset + sizeof(struct bpfilter_ipt_standard_target)) !=
+		    ipt_entry->next_offset) {
+			BFLOG_ERR("invalid struct ipt_entry target offset alignment");
+			return -EINVAL;
+		}
+	}
+
+	rule->num_matches = ipt_entry_num_matches(ipt_entry);
+	if (rule->num_matches < 0)
+		return rule->num_matches;
+
+	return init_rule_matches(ctx, ipt_entry, rule);
+}
+
+int gen_inline_rule(struct codegen *ctx, const struct rule *rule)
+{
+	int r;
+
+	const struct bpfilter_ipt_ip *ipt_ip = &rule->ipt_entry->ip;
+
+	if (!ipt_ip->src_mask && !ipt_ip->src) {
+		if (ipt_ip->invflags & IPT_INV_SRCIP)
+			return 0;
+	}
+
+	if (!ipt_ip->dst_mask && !ipt_ip->dst) {
+		if (ipt_ip->invflags & IPT_INV_DSTIP)
+			return 0;
+	}
+
+	if (ipt_ip->src_mask || ipt_ip->src) {
+		const int op = ipt_ip->invflags & IPT_INV_SRCIP ? BPF_JEQ : BPF_JNE;
+
+		EMIT(ctx, BPF_LDX_MEM(BPF_W, CODEGEN_REG_SCRATCH1, CODEGEN_REG_L3,
+				      offsetof(struct iphdr, saddr)));
+		EMIT(ctx, BPF_ALU32_IMM(BPF_AND, CODEGEN_REG_SCRATCH1, ipt_ip->src_mask));
+		EMIT_FIXUP(ctx, CODEGEN_FIXUP_NEXT_RULE,
+			   BPF_JMP_IMM(op, CODEGEN_REG_SCRATCH1, ipt_ip->src, 0));
+	}
+
+	if (ipt_ip->dst_mask || ipt_ip->dst) {
+		const int op = ipt_ip->invflags & IPT_INV_DSTIP ? BPF_JEQ : BPF_JNE;
+
+		EMIT(ctx, BPF_LDX_MEM(BPF_W, CODEGEN_REG_SCRATCH2, CODEGEN_REG_L3,
+				      offsetof(struct iphdr, daddr)));
+		EMIT(ctx, BPF_ALU32_IMM(BPF_AND, CODEGEN_REG_SCRATCH2, ipt_ip->dst_mask));
+		EMIT_FIXUP(ctx, CODEGEN_FIXUP_NEXT_RULE,
+			   BPF_JMP_IMM(op, CODEGEN_REG_SCRATCH2, ipt_ip->dst, 0));
+	}
+
+	if (ipt_ip->protocol) {
+		EMIT(ctx, BPF_LDX_MEM(BPF_B, CODEGEN_REG_SCRATCH4, CODEGEN_REG_L3,
+				      offsetof(struct iphdr, protocol)));
+		EMIT_FIXUP(ctx, CODEGEN_FIXUP_NEXT_RULE,
+			   BPF_JMP_IMM(BPF_JNE, CODEGEN_REG_SCRATCH4, ipt_ip->protocol, 0));
+
+		EMIT(ctx, BPF_LDX_MEM(BPF_B, CODEGEN_REG_SCRATCH4, CODEGEN_REG_L3,
+				      offsetof(struct iphdr, protocol)));
+		EMIT(ctx, BPF_MOV64_REG(CODEGEN_REG_L4, CODEGEN_REG_L3));
+		EMIT(ctx, BPF_LDX_MEM(BPF_B, CODEGEN_REG_SCRATCH1, CODEGEN_REG_L3, 0));
+		EMIT(ctx, BPF_ALU32_IMM(BPF_AND, CODEGEN_REG_SCRATCH1, 0x0f));
+		EMIT(ctx, BPF_ALU32_IMM(BPF_LSH, CODEGEN_REG_SCRATCH1, 2));
+		EMIT(ctx, BPF_ALU64_REG(BPF_ADD, CODEGEN_REG_L4, CODEGEN_REG_SCRATCH1));
+	}
+
+	for (int i = 0; i < rule->num_matches; ++i) {
+		const struct match *match;
+
+		match = &rule->matches[i];
+		r = match->match_ops->gen_inline(ctx, match);
+		if (r) {
+			BFLOG_ERR("failed to generate inline code match: %s",
+				  STRERR(r));
+			return r;
+		}
+	}
+
+	EMIT_ADD_COUNTER(ctx);
+
+	r = rule->target.target_ops->gen_inline(ctx, &rule->target);
+	if (r) {
+		BFLOG_ERR("failed to generate inline code for target: %s",
+			  STRERR(r));
+		return r;
+	}
+
+	codegen_fixup(ctx, CODEGEN_FIXUP_NEXT_RULE);
+
+	return 0;
+}
+
+void free_rule(struct rule *rule)
+{
+	free(rule->matches);
+}
diff --git a/net/bpfilter/rule.h b/net/bpfilter/rule.h
new file mode 100644
index 000000000000..3a50c6112d3b
--- /dev/null
+++ b/net/bpfilter/rule.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
+ */
+
+#ifndef NET_BPFILTER_RULE_H
+#define NET_BPFILTER_RULE_H
+
+#include <stdint.h>
+#include <stdbool.h>
+
+#include "target.h"
+
+struct bpfilter_ipt_entry;
+struct codegen;
+struct context;
+struct match;
+
+struct rule {
+	const struct bpfilter_ipt_entry *ipt_entry;
+	uint32_t came_from;
+	uint32_t hook_mask;
+	uint16_t num_matches;
+	struct match *matches;
+	struct target target;
+	uint32_t index;
+};
+
+bool rule_has_standard_target(const struct rule *rule);
+bool rule_is_unconditional(const struct rule *rule);
+int init_rule(struct context *ctx, const struct bpfilter_ipt_entry *ipt_entry,
+	      struct rule *rule);
+int gen_inline_rule(struct codegen *ctx, const struct rule *rule);
+void free_rule(struct rule *rule);
+
+#endif // NET_BPFILTER_RULE_H
diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
index 89912a44109f..a934ddef58d2 100644
--- a/tools/testing/selftests/bpf/bpfilter/.gitignore
+++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
@@ -4,3 +4,4 @@ test_map
 test_match
 test_xt_udp
 test_target
+test_rule
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index 587951d14c0c..4ef52bfe2d21 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -14,6 +14,7 @@ TEST_GEN_PROGS += test_map
 TEST_GEN_PROGS += test_match
 TEST_GEN_PROGS += test_xt_udp
 TEST_GEN_PROGS += test_target
+TEST_GEN_PROGS += test_rule
 
 KSFT_KHDR_INSTALL := 1
 
@@ -39,12 +40,15 @@ BPFILTER_MAP_SRCS := $(BPFILTERSRCDIR)/map-common.c
 BPFILTER_CODEGEN_SRCS := $(BPFILTERSRCDIR)/codegen.c $(BPFOBJ) -lelf -lz
 BPFILTER_MATCH_SRCS := $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/xt_udp.c
 BPFILTER_TARGET_SRCS := $(BPFILTERSRCDIR)/target.c
+BPFILTER_RULE_SRCS := $(BPFILTERSRCDIR)/rule.c
 
 BPFILTER_COMMON_SRCS := $(BPFILTER_MAP_SRCS) $(BPFILTER_CODEGEN_SRCS)
 BPFILTER_COMMON_SRCS += $(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/logger.c
 BPFILTER_COMMON_SRCS += $(BPFILTER_MATCH_SRCS) $(BPFILTER_TARGET_SRCS)
+BPFILTER_COMMON_SRCS += $(BPFILTER_RULE_SRCS)
 
 $(OUTPUT)/test_map: test_map.c $(BPFILTER_MAP_SRCS)
 $(OUTPUT)/test_match: test_match.c $(BPFILTER_COMMON_SRCS)
 $(OUTPUT)/test_xt_udp: test_xt_udp.c $(BPFILTER_COMMON_SRCS)
 $(OUTPUT)/test_target: test_target.c $(BPFILTER_COMMON_SRCS)
+$(OUTPUT)/test_rule: test_rule.c $(BPFILTER_COMMON_SRCS)
diff --git a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
index 0d6a6bee5514..8dd7911fa06f 100644
--- a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
+++ b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
@@ -4,6 +4,7 @@
 #define BPFILTER_UTIL_H
 
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
 
 #include <stdio.h>
 #include <stdint.h>
@@ -42,4 +43,11 @@ static inline void init_error_target(struct xt_error_target *ipt_target,
 		 error_name);
 }
 
+static inline void init_standard_entry(struct ipt_entry *entry, __u16 matches_size)
+{
+	memset(entry, 0, sizeof(*entry));
+	entry->target_offset = sizeof(*entry) + matches_size;
+	entry->next_offset = sizeof(*entry) + matches_size + sizeof(struct xt_standard_target);
+}
+
 #endif // BPFILTER_UTIL_H
diff --git a/tools/testing/selftests/bpf/bpfilter/test_rule.c b/tools/testing/selftests/bpf/bpfilter/test_rule.c
new file mode 100644
index 000000000000..db2cc7c5586a
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/test_rule.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include "rule.h"
+
+#include <linux/bpfilter.h>
+#include <linux/err.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "../../kselftest_harness.h"
+
+#include "context.h"
+#include "logger.h"
+#include "rule.h"
+
+#include "bpfilter_util.h"
+
+FIXTURE(test_standard_rule)
+{
+	struct context ctx;
+	struct {
+		struct ipt_entry entry;
+		struct xt_standard_target target;
+	} entry;
+	struct rule rule;
+};
+
+FIXTURE_SETUP(test_standard_rule)
+{
+	const int verdict = BPFILTER_NF_ACCEPT;
+
+	logger_set_file(stderr);
+	ASSERT_EQ(create_context(&self->ctx), 0);
+
+	init_standard_entry(&self->entry.entry, 0);
+	init_standard_target(&self->entry.target, 0, -verdict - 1);
+}
+
+FIXTURE_TEARDOWN(test_standard_rule)
+{
+	free_rule(&self->rule);
+	free_context(&self->ctx);
+}
+
+TEST_F(test_standard_rule, init)
+{
+	ASSERT_EQ(0, init_rule(&self->ctx, (const struct bpfilter_ipt_entry *)&self->entry.entry,
+			       &self->rule));
+}
+
+TEST_HARNESS_MAIN
-- 
2.38.1


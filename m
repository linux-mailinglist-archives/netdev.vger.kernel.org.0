Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6109765569B
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 01:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiLXAU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 19:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiLXAUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 19:20:25 -0500
Received: from 6.mo547.mail-out.ovh.net (6.mo547.mail-out.ovh.net [46.105.44.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A99D8FF0
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 16:20:22 -0800 (PST)
Received: from ex4.mail.ovh.net (unknown [10.110.171.74])
        by mo547.mail-out.ovh.net (Postfix) with ESMTPS id D5B3820ED6;
        Sat, 24 Dec 2022 00:04:41 +0000 (UTC)
Received: from dev-fedora-x86-64.naccy.de (37.65.8.229) by
 DAG10EX1.indiv4.local (172.16.2.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 01:04:40 +0100
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
Subject: [PATCH bpf-next v3 13/16] bpfilter: add table code generation
Date:   Sat, 24 Dec 2022 01:03:59 +0100
Message-ID: <20221224000402.476079-14-qde@naccy.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221224000402.476079-1-qde@naccy.de>
References: <20221224000402.476079-1-qde@naccy.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.65.8.229]
X-ClientProxiedBy: CAS6.indiv4.local (172.16.1.6) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 4763119556604259959
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrheefgddujecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmdenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpefsuhgvnhhtihhnucffvghslhgrnhguvghsuceoqhguvgesnhgrtggthidruggvqeenucggtffrrghtthgvrhhnpeduledugfeileetvdelieeujedttedtvedtgfetteevfeejhfffkeeujeetfffgudenucfkphepuddvjedrtddrtddruddpfeejrdeihedrkedrvddvleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehquggvsehnrggttgihrdguvgeqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepjhholhhsrgeskhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkshgvlhhfthgvshhtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpmhgvsehusghiqhhuvgdrshhpsgdrrhhupdhshhhurghhsehkvghrnhgvlhdrohhrghdpmhihkhholhgrlhesfhgsrdgtohhmpdhprggsvghnihesrhgvughhrghtrdgtohhmpdhkuhgsrg
 eskhgvrhhnvghlrdhorhhgpdgvughumhgriigvthesghhoohhglhgvrdgtohhmpdgurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhkvghrnhgvlhdqthgvrghmsehmvghtrgdrtghomhdphhgrohhluhhosehgohhoghhlvgdrtghomhdpshgufhesghhoohhglhgvrdgtohhmpdhkphhsihhnghhhsehkvghrnhgvlhdrohhrghdpjhhohhhnrdhfrghsthgrsggvnhgusehgmhgrihhlrdgtohhmpdihhhhssehfsgdrtghomhdpshhonhhgsehkvghrnhgvlhdrohhrghdpmhgrrhhtihhnrdhlrghusehlihhnuhigrdguvghvpdgrnhgurhhiiheskhgvrhhnvghlrdhorhhgpdgurghnihgvlhesihhoghgvrghrsghogidrnhgvthdprghstheskhgvrhhnvghlrdhorhhgpdhnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheegjedpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Table code generation consists of multiple steps:
  1) Find front and last rules for the supplied table and hook.
  2) Try to generate code for each rule in [front rule; last rule].
  3) Try to generate each remaining subprog by its type.

Co-developed-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Quentin Deslandes <qde@naccy.de>
---
 net/bpfilter/codegen.c | 359 +++++++++++++++++++++++++++++++++++++++++
 net/bpfilter/codegen.h |   2 +
 2 files changed, 361 insertions(+)

diff --git a/net/bpfilter/codegen.c b/net/bpfilter/codegen.c
index e7ae7dfa5118..db0a20b378b5 100644
--- a/net/bpfilter/codegen.c
+++ b/net/bpfilter/codegen.c
@@ -4,15 +4,22 @@
  * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
  */
 
+#define _GNU_SOURCE
+
 #include "codegen.h"
 
 #include "../../include/uapi/linux/bpfilter.h"
 
+#include <linux/if_ether.h>
+#include <linux/ip.h>
 #include <linux/pkt_cls.h>
 
+#include <bpf/bpf_endian.h>
+
 #include <unistd.h>
 #include <sys/syscall.h>
 
+#include <search.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -20,6 +27,8 @@
 #include <bpf/libbpf.h>
 
 #include "logger.h"
+#include "rule.h"
+#include "table.h"
 
 enum fixup_insn_type {
 	FIXUP_INSN_OFF,
@@ -53,6 +62,65 @@ static int subprog_desc_comparator(const void *x, const void *y)
 	return -1;
 }
 
+/**
+ * codegen_inline_memset_zero_64() - Generate eBPF bytecode to initialise a
+ *	contiguous memory area with 0.
+ * @ctx: codegen context.
+ * @addr_reg: register containing the address of the memory area to initialise.
+ *	The caller need to initialise the register properly before calling this
+ *	function.
+ * @size: size of the memory area. As this function initialises 64 bits at a
+ *	time, @size needs to be a multiple of 64 bits. If it doesn't, the
+ *	function return without intialising the memory and an error message is
+ *	printed out.
+ *
+ * Return: 0 on success, negative errno value on error.
+ */
+static int codegen_inline_memset_zero_64(struct codegen *ctx, int reg,
+					 size_t size)
+{
+	if (size % 8) {
+		BFLOG_ERR("codegen_memset_zero_64() called with size %ld, size must be a multiple of 8",
+			  size);
+		return -EINVAL;
+	}
+
+	for (size_t i = 0; i * 8 < size; ++i)
+		EMIT(ctx, BPF_ST_MEM(BPF_DW, reg, i * 8, 0));
+
+	return 0;
+}
+
+static int codegen_push_subprog(struct codegen *codegen,
+				struct codegen_subprog_desc *subprog)
+{
+	// TODO: merge this with codegen_fixup_push.
+
+	if (codegen->subprogs_cur == codegen->subprogs_max) {
+		struct codegen_subprog_desc **subprogs;
+		uint16_t subprogs_max;
+
+		subprogs_max = codegen->subprogs_cur ?
+			       2 * codegen->subprogs_cur : 1;
+		subprogs = reallocarray(codegen->subprogs, subprogs_max,
+					sizeof(codegen->subprogs[0]));
+		if (!subprogs) {
+			BFLOG_ERR("out of memory");
+			return -ENOMEM;
+		}
+
+		codegen->subprogs_max = subprogs_max;
+		codegen->subprogs = subprogs;
+	}
+
+	codegen->subprogs[codegen->subprogs_cur++] = subprog;
+
+	qsort(codegen->subprogs, codegen->subprogs_cur,
+	      sizeof(codegen->subprogs[0]), subprog_desc_comparator);
+
+	return 0;
+}
+
 static const struct codegen_subprog_desc *codegen_find_subprog(struct codegen *codegen,
 							       const struct codegen_subprog_desc **subprog)
 {
@@ -601,6 +669,297 @@ int create_codegen(struct codegen *codegen, enum bpf_prog_type type)
 	return r;
 }
 
+static int try_codegen_rules(struct codegen *codegen, struct rule *rule_front,
+			     struct rule *rule_last)
+{
+	int r;
+
+	for (; rule_front <= rule_last; ++rule_front, ++codegen->rule_index) {
+		rule_front->index = codegen->rule_index;
+		r = gen_inline_rule(codegen, rule_front);
+		if (r) {
+			BFLOG_ERR("failed to generate inline rule: %s",
+				  STRERR(r));
+			return r;
+		}
+
+		r = codegen_fixup(codegen, CODEGEN_FIXUP_NEXT_RULE);
+		if (r) {
+			BFLOG_ERR("failed to generate next rule fixups: %s",
+				  STRERR(r));
+			return r;
+		}
+
+		r = codegen_fixup(codegen, CODEGEN_FIXUP_COUNTERS_INDEX);
+		if (r) {
+			BFLOG_ERR("failed to generate counters fixups: %s",
+				  STRERR(r));
+			return r;
+		}
+	}
+
+	r = codegen_fixup(codegen, CODEGEN_FIXUP_END_OF_CHAIN);
+	if (r) {
+		BFLOG_ERR("failed to generate end of chain fixups: %s",
+			  STRERR(r));
+		return r;
+	}
+
+	return 0;
+}
+
+static struct rule *table_find_last_rule(const struct table *table,
+					 struct rule *rule_front)
+{
+	for (; rule_front; ++rule_front) {
+		if (!rule_is_unconditional(rule_front))
+			continue;
+
+		if (!rule_has_standard_target(rule_front))
+			continue;
+
+		if (standard_target_verdict(rule_front->target.ipt_target) >= 0)
+			continue;
+
+		return rule_front;
+	}
+
+	return rule_front;
+}
+
+static int try_codegen_user_chain_subprog(struct codegen *codegen,
+					  const struct table *table,
+					  struct codegen_subprog_desc *subprog)
+{
+	struct rule *rule_front;
+	struct rule *rule_last;
+	int r;
+
+	rule_front = table_find_rule_by_offset(table, subprog->offset);
+	if (!rule_front) {
+		BFLOG_ERR("failed to get rule at offset %d", subprog->offset);
+		return -EINVAL;
+	}
+
+	rule_last = table_find_last_rule(table, rule_front);
+	if (!rule_last) {
+		BFLOG_ERR("failed to find last rule");
+		return -EINVAL;
+	}
+
+	subprog->insn = codegen->len_cur;
+	codegen->rule_index = rule_front - table->rules;
+	r = try_codegen_rules(codegen, rule_front, rule_last);
+	if (r) {
+		BFLOG_ERR("failed to generate rules");
+		return r;
+	}
+
+	return codegen_push_subprog(codegen, subprog);
+}
+
+static int try_codegen_subprogs(struct codegen *codegen, const struct table *table)
+{
+	while (!list_empty(&codegen->awaiting_subprogs)) {
+		struct codegen_subprog_desc *subprog;
+		int r = -EINVAL;
+
+		subprog = list_entry(codegen->awaiting_subprogs.next,
+				     struct codegen_subprog_desc,
+				     list);
+
+		if (subprog->type == CODEGEN_SUBPROG_USER_CHAIN) {
+			r = try_codegen_user_chain_subprog(codegen, table,
+							   subprog);
+			if (r < 0) {
+				BFLOG_ERR("failed to generate code for user defined chain: %s",
+					  STRERR(r));
+				return r;
+			}
+		} else {
+			BFLOG_ERR("code generation for subprogram of type %d is not supported",
+				  subprog->type);
+			return -EINVAL;
+		}
+
+		list_del(&subprog->list);
+	}
+
+	return 0;
+}
+
+/**
+ * generate_inline_forward_packet_assessment() - Add eBPF bytecode to assess
+ *	whether the current packet is to be forwarded or not.
+ * @ctx: context to add the bytecode to.
+ *
+ * Use bpf_fib_lookup() to find out whether the current packet is to be
+ * forwarded or not. bpf_fib_lookup() requires a struct bpf_fib_lookup to be
+ * filled with data from the packet.
+ * The outcome of the bytecode will depend on the actual iptables hook used:
+ * BPFILTER_INET_HOOK_FORWARD's chain will be processed if the packet is to be
+ * forwarded, or will be skipped otherwise and jump to the next chain. The
+ * opposite behaviour apply if hook is BPFILTER_INET_HOOK_LOCAL_IN.
+ *
+ * Return: 0 on success, negative errno value on error.
+ */
+static int generate_inline_forward_packet_assessment(struct codegen *ctx)
+{
+	// Set ARG2 to contain the address of the struct bpf_fib_lookup.
+	EMIT(ctx, BPF_MOV64_REG(BPF_REG_ARG2, BPF_REG_10));
+	EMIT(ctx, BPF_ALU64_IMM(BPF_ADD, BPF_REG_ARG2,
+				(-(unsigned int)sizeof(struct bpf_fib_lookup)) - sizeof(struct runtime_context)));
+
+	codegen_inline_memset_zero_64(ctx, BPF_REG_ARG2,
+				      sizeof(struct bpf_fib_lookup));
+
+	// Store h_proto for further decision
+	EMIT(ctx, BPF_LDX_MEM(BPF_H, CODEGEN_REG_SCRATCH3, CODEGEN_REG_L3,
+			      -(short int)(ETH_HLEN) + (short int)offsetof(struct ethhdr, h_proto)));
+	EMIT(ctx, BPF_JMP_IMM(BPF_JEQ, CODEGEN_REG_SCRATCH3,
+			      bpf_htons(ETH_P_IP), 2));
+
+	// Not IPv4? Then do no process any FORWARD rule and move to the next chain (program).
+	EMIT(ctx, BPF_MOV64_IMM(CODEGEN_REG_RETVAL, TC_ACT_UNSPEC));
+	EMIT_FIXUP(ctx, CODEGEN_FIXUP_END_OF_CHAIN, BPF_JMP_A(0));
+
+	// bpf_fib_lookup.family field
+	EMIT(ctx, BPF_ST_MEM(BPF_B, BPF_REG_ARG2,
+			     offsetof(struct bpf_fib_lookup, family), AF_INET));
+
+	// bpf_fib_lookup.l4_protocol field
+	EMIT(ctx, BPF_LDX_MEM(BPF_B, CODEGEN_REG_SCRATCH3, CODEGEN_REG_L3,
+			      offsetof(struct iphdr, protocol)));
+	EMIT(ctx, BPF_STX_MEM(BPF_B, BPF_REG_ARG2, CODEGEN_REG_SCRATCH3,
+			      offsetof(struct bpf_fib_lookup, l4_protocol)));
+
+	// bpf_fib_lookup.tot_len field
+	EMIT(ctx, BPF_LDX_MEM(BPF_H, CODEGEN_REG_SCRATCH3, CODEGEN_REG_L3,
+			      offsetof(struct iphdr, tot_len)));
+	EMIT(ctx, BPF_STX_MEM(BPF_H, BPF_REG_ARG2, CODEGEN_REG_SCRATCH3,
+			      offsetof(struct bpf_fib_lookup, tot_len)));
+
+	// bpf_fib_lookup.ifindex field
+	EMIT(ctx, BPF_LDX_MEM(BPF_W, CODEGEN_REG_SCRATCH3, CODEGEN_REG_CTX,
+			      offsetof(struct __sk_buff, ingress_ifindex)));
+	EMIT(ctx, BPF_STX_MEM(BPF_W, BPF_REG_ARG2, CODEGEN_REG_SCRATCH3,
+			      offsetof(struct bpf_fib_lookup, ifindex)));
+
+	// bpf_fib_lookup.tos field
+	EMIT(ctx, BPF_LDX_MEM(BPF_B, CODEGEN_REG_SCRATCH3, CODEGEN_REG_L3,
+			      offsetof(struct iphdr, tos)));
+	EMIT(ctx, BPF_STX_MEM(BPF_B, BPF_REG_ARG2, CODEGEN_REG_SCRATCH3,
+			      offsetof(struct bpf_fib_lookup, tos)));
+
+	// bpf_fib_lookup.ipv4_src and bpf_fib_lookup.ipv4_dst fields
+	EMIT(ctx, BPF_LDX_MEM(BPF_W, CODEGEN_REG_SCRATCH3, CODEGEN_REG_L3,
+			      offsetof(struct iphdr, saddr)));
+	EMIT(ctx, BPF_STX_MEM(BPF_W, BPF_REG_ARG2, CODEGEN_REG_SCRATCH3,
+			      offsetof(struct bpf_fib_lookup, ipv4_src)));
+	EMIT(ctx, BPF_LDX_MEM(BPF_W, CODEGEN_REG_SCRATCH3, CODEGEN_REG_L3,
+			      offsetof(struct iphdr, daddr)));
+	EMIT(ctx, BPF_STX_MEM(BPF_W, BPF_REG_ARG2, CODEGEN_REG_SCRATCH3,
+			      offsetof(struct bpf_fib_lookup, ipv4_dst)));
+
+	EMIT(ctx, BPF_MOV64_REG(BPF_REG_ARG1, CODEGEN_REG_CTX));
+	EMIT(ctx, BPF_MOV64_IMM(BPF_REG_ARG3, sizeof(struct bpf_fib_lookup)));
+	EMIT(ctx, BPF_MOV64_IMM(BPF_REG_ARG4, 0));
+
+	EMIT(ctx, BPF_EMIT_CALL(BPF_FUNC_fib_lookup));
+	EMIT(ctx, BPF_MOV64_REG(CODEGEN_REG_SCRATCH3, CODEGEN_REG_RETVAL));
+	EMIT(ctx, BPF_MOV64_IMM(CODEGEN_REG_RETVAL, TC_ACT_UNSPEC));
+	EMIT_FIXUP(ctx, CODEGEN_FIXUP_END_OF_CHAIN,
+		   BPF_JMP_IMM(ctx->iptables_hook == BPFILTER_INET_HOOK_FORWARD ? BPF_JNE : BPF_JEQ,
+			       CODEGEN_REG_SCRATCH3, BPF_FIB_LKUP_RET_SUCCESS, 0));
+
+	return 0;
+}
+
+int try_codegen(struct codegen *codegen, const struct table *table)
+{
+	struct rule *rule_front;
+	struct rule *rule_last;
+	int r;
+
+	r = codegen->codegen_ops->gen_inline_prologue(codegen);
+	if (r) {
+		BFLOG_ERR("failed to generate inline prologue: %s", STRERR(r));
+		return r;
+	}
+
+	r = codegen->codegen_ops->load_packet_data(codegen, CODEGEN_REG_L3);
+	if (r) {
+		BFLOG_ERR("failed to generate code to load packet data: %s",
+			  STRERR(r));
+		return r;
+	}
+
+	r = codegen->codegen_ops->load_packet_data_end(codegen,
+						       CODEGEN_REG_DATA_END);
+	if (r) {
+		BFLOG_ERR("failed to generate code to load packet data end: %s",
+			  STRERR(r));
+		return r;
+	}
+
+	// save packet size once
+	EMIT(codegen, BPF_MOV64_REG(CODEGEN_REG_SCRATCH2, CODEGEN_REG_DATA_END));
+	EMIT(codegen, BPF_ALU64_REG(BPF_SUB, CODEGEN_REG_SCRATCH2, CODEGEN_REG_L3));
+	EMIT(codegen, BPF_STX_MEM(BPF_W, CODEGEN_REG_RUNTIME_CTX, CODEGEN_REG_SCRATCH2,
+				  STACK_RUNTIME_CONTEXT_OFFSET(data_size)));
+
+	EMIT(codegen, BPF_ALU64_IMM(BPF_ADD, CODEGEN_REG_L3, ETH_HLEN));
+	EMIT_FIXUP(codegen, CODEGEN_FIXUP_END_OF_CHAIN,
+		   BPF_JMP_REG(BPF_JGT, CODEGEN_REG_L3, CODEGEN_REG_DATA_END, 0));
+	EMIT(codegen, BPF_MOV64_REG(CODEGEN_REG_SCRATCH1, CODEGEN_REG_L3));
+	EMIT(codegen, BPF_ALU64_IMM(BPF_ADD, CODEGEN_REG_SCRATCH1, sizeof(struct iphdr)));
+	EMIT_FIXUP(codegen, CODEGEN_FIXUP_END_OF_CHAIN,
+		   BPF_JMP_REG(BPF_JGT, CODEGEN_REG_SCRATCH1, CODEGEN_REG_DATA_END, 0));
+
+	if (codegen->iptables_hook == BPFILTER_INET_HOOK_LOCAL_IN ||
+	    codegen->iptables_hook == BPFILTER_INET_HOOK_FORWARD) {
+		/* There is no XDP nor TC forward hook to attach to. So, we
+		 * need to add code to assess whether a incoming packet it
+		 * to be forwarded or not.
+		 */
+		BFLOG_NOTICE("generate forward packet assessment");
+		generate_inline_forward_packet_assessment(codegen);
+	}
+
+	rule_front = &table->rules[table->hook_entry[codegen->iptables_hook]];
+	rule_last = &table->rules[table->underflow[codegen->iptables_hook]];
+
+	codegen->rule_index = rule_front - table->rules;
+	r = try_codegen_rules(codegen, rule_front, rule_last);
+	if (r) {
+		BFLOG_ERR("failed to generate rules: %s", STRERR(r));
+		return r;
+	}
+
+	r = codegen->codegen_ops->gen_inline_epilogue(codegen);
+	if (r) {
+		BFLOG_ERR("failed to generate inline epilogue: %s",
+			  STRERR(r));
+		return r;
+	}
+
+	r = try_codegen_subprogs(codegen, table);
+	if (r) {
+		BFLOG_ERR("failed to generate subprograms: %s", STRERR(r));
+		return r;
+	}
+
+	r = codegen_fixup(codegen, CODEGEN_FIXUP_JUMP_TO_CHAIN);
+	if (r) {
+		BFLOG_ERR("failed to generate fixups: %s", STRERR(r));
+		return r;
+	}
+
+	codegen->shared_codegen->maps[CODEGEN_RELOC_MAP].max_entries = table->num_rules;
+
+	return 0;
+}
+
 int load_img(struct codegen *codegen)
 {
 	union bpf_attr attr = {};
diff --git a/net/bpfilter/codegen.h b/net/bpfilter/codegen.h
index cca45a13c4aa..6cfd8e7a3692 100644
--- a/net/bpfilter/codegen.h
+++ b/net/bpfilter/codegen.h
@@ -18,6 +18,7 @@
 #include <stdint.h>
 
 struct context;
+struct table;
 
 #define CODEGEN_REG_RETVAL	BPF_REG_0
 #define CODEGEN_REG_SCRATCH1	BPF_REG_1
@@ -174,6 +175,7 @@ int codegen_fixup(struct codegen *codegen, enum codegen_fixup_type fixup_type);
 int emit_fixup(struct codegen *codegen, enum codegen_fixup_type fixup_type,
 	       struct bpf_insn insn);
 int emit_add_counter(struct codegen *codegen);
+int try_codegen(struct codegen *codegen, const struct table *table);
 int load_img(struct codegen *codegen);
 void unload_img(struct codegen *codegen);
 void free_codegen(struct codegen *codegen);
-- 
2.38.1

